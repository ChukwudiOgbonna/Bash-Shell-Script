# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# assign our arguments to these variables
targetDirectory=$1
destinationDirectory=$2

# check if they are valid
echo $targetDirectory
echo $destinationDirectory

# get current timetsamp
currentTS=$(date +%s)

# rename our file with current timestamp
backupFileName="backup-$currentTS.tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# assign current directory to variable
origAbsPath=$(pwd)

# change current directory to destination, then assign it to our variable
cd $destinationDirectory
destDirAbsPath=$(pwd)

# change directory to original path then back to target directory
cd $origAbsPath
cd $targetDirectory

# get timestamp 24 hours before
yesterdayTS=$(($currentTS - 24 * 60 * 60))

declare -a toBackup

for file in $(ls) # for every file in the directory
do
  # if the time stamp of the file is more than 24 hours before, then add the file to backup array
  if ((`date -r $file +%s` > $yesterdayTS))
  then
    toBackup+=($file)
  fi
done
# compress and archive the files in the array and send them to the backupfilename
tar -czvf $backupFileName ${toBackup[*]}
# move backupfilename to directory folder
mv $backupFileName $destDirAbsPath


