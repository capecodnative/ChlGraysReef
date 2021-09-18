# ChlGraysReef
A set of MATLAB scripts for downloading, extracting, and summarizing various satellite Chl-A data streams for Grays Reef off the coast of Georgia, USA

Scripts:
DownloadLatestGraysReefChlData.m
  Downloads .NC4 and .PNG satellite data from NOAA's East Coast ocean color FTP site ( ftp://ftp.star.nesdis.noaa.gov/ ). The number of days/weeks and other key filenaming parameters are settable in the first half of the script. More info about the satellite data streams is available here: https://eastcoast.coastwatch.noaa.gov/
  
ExtractGraysReefChlA.m
  Extracts the Chl data for the Grays Reef region (~22 mi^2) from all downloaded NC4 files. Exports to a .csv file with filename, satellite ID, daily or 7day, and various stats of the Chl data (5th, median, and 95th percentiles; mean and stdev; number of invalid points).
  
Files/Directories
/ChlData/ (and subdirectories): local subfolder where files from the download script are saved
DataOutput.csv : comma separated file summarizing valid Chl-A data from the downloaded data files

General region of Grays Reef on a demonstrative PNG of the satellite data
https://github.com/capecodnative/ChlGraysReef/blob/main/GraysReefLocationOnMap--Black%20Arrow.png

Detail of Grays Reef from NOAA
https://github.com/capecodnative/ChlGraysReef/blob/main/Grays%20Reef%20Map.jpg

Lat/Lon of Grays Reef including research area
https://github.com/capecodnative/ChlGraysReef/blob/main/Grays%20Reef%20Map%20Detail%20with%20LatLon.jpg
