# ChlGraysReef
A MATLAB script for pulling Chl-A data at Grays Reef from satellite data


DownloadLatestGraysReefChlData.m
  Downloads .NC4 and .PNG satellite data from NOAA's East Coast ocean color FTP site ( ftp://ftp.star.nesdis.noaa.gov/ ). Set the number of days/weeks and other key filenaming parameters in the first half of the script. More info about the satellite data streams is available here: https://eastcoast.coastwatch.noaa.gov/
  
ExtractGraysReefChlA.m
  Extracts the Chl data for the Grays Reef region (~22 mi^2) from all downloaded NC4 files. Exports to a .csv file with filename, satellite ID, daily or 7day, and various stats of the Chl data (5th, median, and 95th percentiles; mean and stdev; number of invalid points).
