clear
sleep 0.5
# Credits
echo "                                               "
echo "               Partition manager               "
echo "             Created by kapmino269             "
echo "            Optimized by SebaUbuntu            "
echo "                                               "
# Variable definition
EMMC_LOCATION="/dev/block/platform/soc/"
EMMC_POSSIBILITIES_LIST="/tmp/emmc.txt"
EMMC_POSSIBILITIES_NUMBER=$(ls $EMMC_LOCATION | wc -l)
EMMC_POSSIBILITIES_NUMBER=$((EMMC_POSSIBILITIES_NUMBER+1))
EMMC_POSSIBILITIES_LISTING=1

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

# Obtain how much eMMC folders does exist
ls $EMMC_LOCATION >$EMMC_POSSIBILITIES_LIST

# List all eMMC possible directories
echo "Choose:- "
while [ $EMMC_POSSIBILITIES_LISTING != $EMMC_POSSIBILITIES_NUMBER ]
	do
	EMMC_CURRENT_NAME=$(cat $EMMC_POSSIBILITIES_LIST | sed -n ${EMMC_POSSIBILITIES_LISTING}p)
	echo "$EMMC_POSSIBILITIES_LISTING - $EMMC_CURRENT_NAME"
	EMMC_POSSIBILITIES_LISTING=$((EMMC_POSSIBILITIES_LISTING+1))
done 

echo ""

# Choose an eMMC fstab to use
echo "Type the folder's correspondent number: "
echo "Note: you need to select which folder contains"
echo "system, vendor, etc. partitions, see it "
echo "with the recovery file manager."
echo "If there is only one folder, select that."
read -p "Number=" CORRECT_EMMC

# Check if the inserted eMMC number is correct
if [ -z "$CORRECT_EMMC" ]
	then
	echo "Nothing has been inserted, aborted"
	exit
fi
if [ "$CORRECT_EMMC" -gt "$EMMC_POSSIBILITIES_NUMBER" ]
	then
	echo "ERROR: You have inserted an invalid number"
	exit
fi

echo ""

CORRECT_EMMC=$(cat $EMMC_POSSIBILITIES_LIST | sed -n ${CORRECT_EMMC}p)
CORRECT_EMMC="${EMMC_LOCATION}${CORRECT_EMMC}/by-name"
echo "Full location: ${CORRECT_EMMC}"

echo ""

# Second phase of the script
PARTITION_LIST="/tmp/part.txt"
PARTITION_NUMBER=$(ls $CORRECT_EMMC | wc -l)
PARTITION_NUMBER=$((PARTITION_NUMBER+1))
PARTITION_NUMBER_INCLUDING_ALL=$((PARTITION_NUMBER+1))
PARTITION_LISTING_FULL_BACKUP=1
PARTITION_LISTING=1

# Obtain how much partitions does exist
ls $CORRECT_EMMC >$PARTITION_LIST
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
		dd if=$CORRECT_EMMC${a} of=$BACKUP_LOCATION/${a}.img
		PARTITION_LISTING_FULL_BACKUP=$((PARTITION_LISTING_FULL_BACKUP+1))
		echo "--------------" 
		sleep 3
	done 

# Backup a determined partition
	else
	a=$(cat $PARTITION_LIST | sed -n ${INPUT}p)
	echo "$INPUT - Backup $a"
	dd if=$CORRECT_EMMC/${a} of=$BACKUP_LOCATION/${a}.img
fi
exit
