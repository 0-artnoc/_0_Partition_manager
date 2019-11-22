clear
sleep 0.5
# Credits
echo "                                               "
echo "               Partition manager               "
echo "             Created by kapmino269             "
echo "            Optimized by SebaUbuntu            "
echo "                                               "
# Variable definition
EMMC_LOCATION="/dev/block/bootdevice/by-name/"

# Ask user where are backup files
echo "Insert the directory of the backup files" 
echo "(if nothing will be inserted the default value will be /sdcard/backup)"
read -p "Directory=" BACKUP_LOCATION 
if [ -z "$BACKUP_LOCATION" ]
	then
	echo "Nothing has been inserted, using /sdcard/backup"
	BACKUP_LOCATION="/sdcard/backup"
fi
		
echo ""
mkdir $BACKUP_LOCATION


echo "Full location of partitions: "
echo "${EMMC_LOCATION}"

echo ""

# Second phase of the script
PARTITION_LIST="/tmp/part.txt"
PARTITION_NUMBER=$(ls $EMMC_LOCATION | wc -l)
PARTITION_NUMBER=$((PARTITION_NUMBER+1))
PARTITION_NUMBER_INCLUDING_ALL=$((PARTITION_NUMBER+1))
PARTITION_LISTING_FULL_BACKUP=1
PARTITION_LISTING=1

# Obtain how much partitions does exist
ls $EMMC_LOCATION >$PARTITION_LIST
mkdir $BACKUP_LOCATION
# List all partitions
echo "Choose a partition to backup: "
while [ $PARTITION_LISTING != $PARTITION_NUMBER ]
	do
	a=$(cat $PARTITION_LIST | sed -n ${PARTITION_LISTING}p)
	echo "$PARTITION_LISTING -  $a"
	PARTITION_LISTING=$((PARTITION_LISTING+1))
done 

# Choose a partition to backup
echo "$PARTITION_NUMBER_INCLUDING_ALL -  ALL"
echo "Type the partition's correspondent number"
read -p "Number=" INPUT

# Check if the inserted partition number is correct
if [ -z "$INPUT" ]
	then
	echo "Nothing has been inserted, aborted"
	exit
fi
if [ "$INPUT" -gt "$PARTITION_NUMBER_INCLUDING_ALL" ]
	then
	echo "ERROR: You have inserted an invalid number"
	exit
fi

# Do a full backup (all partitions)
if [ "$INPUT" -eq "$PARTITION_NUMBER_INCLUDING_ALL" ]
	then
	while [ $PARTITION_LISTING_FULL_BACKUP != $PARTITION_NUMBER ]
		do
		a=$(cat $PARTITION_LIST | sed -n ${PARTITION_LISTING_FULL_BACKUP}p)
		echo "$PARTITION_LISTING_FULL_BACKUP - Backup $a"
		dd if=$EMMC_LOCATION${a} of=$BACKUP_LOCATION/${a}.img
		PARTITION_LISTING_FULL_BACKUP=$((PARTITION_LISTING_FULL_BACKUP+1))
		echo "--------------" 
		sleep 3
	done 

# Backup a determined partition
	else
	a=$(cat $PARTITION_LIST | sed -n ${INPUT}p)
	echo "$INPUT - Backup $a"
	dd if=$EMMC_LOCATION/${a} of=$BACKUP_LOCATION/${a}.img
fi
exit
