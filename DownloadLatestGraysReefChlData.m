tempDaysToGet=7; %Number of previous days of daily data that we want to retrieve
tempWeeksToGet=2; %Number of previous weeks of weekly data that we want to retrieve

tempLocalDataDirName='ChlData'; %Set the local subdirectory names for where we want to store downloaded files
tempLocalDataSubdirNames={'MODIS/daily','MODIS/7day','VIIRS/daily','VIIRS/7day'};

%Set the remote (FTP) subdirectory names and data filenames to download
tempRemoteDataSubdirNames={...
    '/pub/socd1/ecn/data/modis/chl-swir/daily/fg',... %MODIS Daily Chl Data subfolder for Florida/Georgia region
    '/pub/socd1/ecn/data/modis/chl-swir/7day/fg',... %MODIS 7Day Chl Data subfolder for Florida/Georgia region
    '/pub/socd1/ecn/data/viirs/chl/daily/fg',... %VIIRS Daily Chl Data subfolder for Florida/Georgia region
    '/pub/socd1/ecn/data/viirs/chl/7day/fg'}; %VIIRS 7Day Chl Data subfolder for Florida/Georgia region
tempRemoteDataFilenames={...
    'MODWCW_%04d%03d_DAILY_AQUA_CHLORA_FG_1KM.nc4',... %MODIS Daily file format
    'MODWCW_%04d%03d_7DAY_AQUA_CHLORA_FG_1KM.nc4',...  %MODIS 7Day file format
    'VRSUCW_%04d%03d_DAILY_SNPP_CHLORA_FG_750M.nc4',... %VIIRS Daily file format
    'VRSUCW_%04d%03d_7DAY_SNPP_CHLORA_FG_750M.nc4'}; %VIIRS 7Day file format
tempRemoteDataFileType={'daily','7day','daily','7day'}; %For each, is it daily or 7day data?

%Make a list of local folders to store data files and create them if needed
tempDirsToCheck=strcat(tempLocalDataDirName,'/',tempLocalDataSubdirNames); 
for i=1:numel(tempDirsToCheck)
    if ~exist(tempDirsToCheck{i},'dir')
        mkdir(tempDirsToCheck{i});
    end
end


tempTodayDayOfYear=day(datetime,('dayofyear')); %Get the current day of the year
tempTodayYear=year(datetime); %Get the current year

fprintf('Connecting to FTP site\n');
tempftpobj=ftp('ftp.star.nesdis.noaa.gov'); %Connect to the NOAA Chl data site

for i=1:numel(tempRemoteDataFileType)
    tempFilesToGet=[];
    if strcmp(tempRemoteDataFileType{i},'daily')
        tempFilesToGet=compose(tempRemoteDataFilenames{i},repmat(tempTodayYear,tempDaysToGet+1,1),(tempTodayDayOfYear:-1:tempTodayDayOfYear-tempDaysToGet)');
    elseif strcmp(tempRemoteDataFileType{i},'7day')
        tempFilesToGet=compose(tempRemoteDataFilenames{i},repmat(tempTodayYear,tempWeeksToGet*7+1,1),(tempTodayDayOfYear:-1:tempTodayDayOfYear-tempWeeksToGet*7)');
    end
    if ~isempty(tempFilesToGet)
        fprintf('Moving to %s\n',tempRemoteDataSubdirNames{i});
        cd(tempftpobj,tempRemoteDataSubdirNames{i});
        tempListingSuccessful=0;
        while ~tempListingSuccessful
            try
                fprintf('Getting dir listing %s ...\n',tempRemoteDataSubdirNames{i});
                pause(2);
                tempListing=dir(tempftpobj,'*.nc4');
                tempListing=[tempListing.name];
                tempListingSuccessful=1;
            catch
                fprintf('Re-connecting ...\n');
                close(tempftpobj);
                tempftpobj=ftp('ftp.star.nesdis.noaa.gov'); %Re-connect to the NOAA Chl data site
                cd(tempftpobj,tempRemoteDataSubdirNames{i});
            end
        end        
        
        for j=1:numel(tempFilesToGet)
            tempFileDownloadSuccess=0;
            if ~isempty(strfind(tempListing,tempFilesToGet{j}))
                fprintf('Getting %s ...\n',tempFilesToGet{j});
                while ~tempFileDownloadSuccess
                    try %Try getting the file
                        pause(2);
                        mget(tempftpobj,tempFilesToGet{j},tempDirsToCheck{i});
                        tempFileDownloadSuccess=1;
                    catch %If the connection fails, re-connect and try again
                        fprintf('Re-connecting ...\n');
                        close(tempftpobj);
                        tempftpobj=ftp('ftp.star.nesdis.noaa.gov'); %Re-connect to the NOAA Chl data site
                        cd(tempftpobj,tempRemoteDataSubdirNames{i});
                        fprintf('Re-getting %s ...\n',tempFilesToGet{j});
                    end
                end
            end
        end
    end
end
fprintf('Downloads complete.\n');

clear temp* i       