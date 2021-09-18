tempLocalDataDirName='ChlData'; %Tthe local subdirectory name where downloaded files are saved
tempLocalDataSubdirNames={'MODIS/daily','MODIS/7day','VIIRS/daily','VIIRS/7day'}; %The subdirectory names of the data
tempDirsToCheck=strcat(tempLocalDataDirName,'/',tempLocalDataSubdirNames); 

%The Lat,Lon coordinates of Grays Reef (the SE and NW corners) based on
%https://nmsgraysreef.blob.core.windows.net/graysreef-prod/media/archive/management/research/images/research_area_large.jpg
GraysSE=[31+21.764/60,-(80+49.689/60)];
GraysNW=[31+25.264/60,-(80+55.272/60)];

%Go through the data directories and extract chlor-a field for the valid
%lat/lon coordinates of the area of interest from all NC data files.
%Negative values are 'no data' usually due to cloud cover. Make these NaN
tempFileNames={'filename'};
tempDataOut=nan(1,6);

for i=1:numel(tempDirsToCheck) %for each data directory
    tempList=dir(strcat(tempDirsToCheck{i},'/','*.nc4')); 
    for j=1:numel(tempList) %and every .nc4 file in that directory
        tempLat=ncread(strcat(tempList(j).folder,'/',tempList(j).name),'lat');
        tempLon=ncread(strcat(tempList(j).folder,'/',tempList(j).name),'lon');
        tempChl=ncread(strcat(tempList(j).folder,'/',tempList(j).name),'chlor_a');
        tempValidData=find(tempLat>=GraysSE(1) & tempLat<=GraysNW(1) & tempLon>=GraysNW(2) & tempLon<=GraysSE(2)); %determine the valid data points within the region of interest
        tempGraysData=tempChl(tempValidData); %pull only those Chl data points
        tempGraysData(tempGraysData<0)=NaN; %convert the negative values to NaN
        tempFileNames{end+1}=tempList(j).name;
        tempDataOut(end+1,:)=[prctile(tempGraysData,[5,50,95]),nanmean(tempGraysData),nanstd(tempGraysData),sum(isnan(tempGraysData))];
     end
end
tempFileNames=tempFileNames(2:end)';
tempDataOut=tempDataOut(2:end,:);
tempSatellite=cell(numel(tempFileNames),1);
tempDailyOr7Day=cell(numel(tempFileNames),1);
tempDates=NaT(numel(tempFileNames),1);

for i=1:numel(tempFileNames)
    tempDates(i)=datetime(str2double(tempFileNames{i}(8:11)),1,str2double(tempFileNames{i}(12:14)));
    if strcmp(tempFileNames{i}(1),'M')
        tempSatellite{i}='MODIS';
    elseif strcmp(tempFileNames{i}(1),'V')
        tempSatellite{i}='VIIRS';
    else
        tempSatellite{i}='Unknown';
    end
    if strcmp(tempFileNames{i}(16),'D')
        tempDailyOr7Day{i}='Daily';
    elseif strcmp(tempFileNames{i}(16),'7')
        tempDailyOr7Day{i}='7Day';
    else
        tempDailyOr7Day{i}='Unknown';
    end
end
tempTableOut=table(tempFileNames,tempSatellite,tempDailyOr7Day,tempDates,tempDataOut(:,1),tempDataOut(:,2),tempDataOut(:,3),tempDataOut(:,4),tempDataOut(:,5),tempDataOut(:,6),'VariableNames',{'Filename','Satellite','Daily_Or_7Day','Date','5th_Percentile','Median','95th_Percentile','Mean','StdDeviation','NumberOfInvalidMeasurements'});
writetable(tempTableOut,'DataOutput.csv');

clear i j temp* Grays* ans
