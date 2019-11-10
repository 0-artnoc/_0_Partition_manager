D="/dev/block/platform/soc/7824900.sdhci/by-name"
C="/tmp/part.txt"
S="/external_sdcard/part"
t=$(ls $D | wc -l)
t=$((t+1))
p=1
ls $D >$C
mkdir $S
while [ $p != $t ]
do
a=$(cat $C | sed -n ${p}p)
echo "$p - Backup $a"
dd if=$D/${a} of=$S/${a}.img
p=$((p+1))
echo "--------------" 
sleep 3
done 