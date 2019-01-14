# MNDNR FISHERY SURVEY SCRAPER FOR BWCA LAKES
# v1.0
#
# U KNO WHO IT IS

# import the list of lakes with lake,url as the fields
$lakes = Import-Csv C:\Users\PUTUSERNAMEHERE\Desktop\bwca-lake-dnr-links_from-pp-2015.csv
$testCSV = Import-CSV C:\Users\PUTUSERNAMEHERE\Desktop\bwca-lake-json\test.csv

# set output directory
$outputDir = "C:\Users\PUTUSERNAMEHERE\Desktop\bwca-lake-json\"

# set log file output path
$logFile = $outputDir+"log.txt"

# function to display log messages and save them to file
function logMessage($message) {
    Write-Host $message
    ((Get-Date -UFormat "%D %H:%M:%S UTC%Z").ToString()+"," + $message) >> $logFile # get date every time we log something, show UTC offset
}

# start dump
logMessage "Beginning DNR Fishery Survey data dump..."

# iterate through the list
foreach($lake in $lakes) {
    $name = $lake.lake
    $id = $($lake.url).Split('=')[1] # get the ID from the URL without needing to do any fancy shit
    $url = "https://maps2.dnr.state.mn.us/cgi-bin/lakefinder/detail.cgi?type=lake_survey&id="+$id
    $outputName = $outputDir+$name+"-"+$id+".json"
    
    if($id -gt 0) { # make sure it has a file to download
        (New-Object System.Net.WebClient).DownloadFile($url,$outputName) # download the thing
        if ((Get-Item -Path $outputName).Length -gt 0) { # if it got a file more than 0 bytes
            logMessage "$name-$id,$url,success"
        } else {
            logMessage "$name-$id,$url,failure"
        }
    } else {
        logMessage "$name has no ID"

    }
    
}
