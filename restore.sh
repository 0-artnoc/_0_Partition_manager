#Base
D="/dev/block/platform/soc/7824900.sdhci/by-name"
C="/tmp/part.txt"
S="/external_sdcard/part"
t=$(ls $D | wc -l)
t=$((t+1))
f=$((t+1))
p=1
l=1
#Files
ls $D >$C
mkdir $S
#Output
echo "Choose :- "
while [ $l != $t ]
do
a=$(cat $C | sed -n ${l}p)
echo "$l -  $a"
l=$((l+1))
done 
echo "$f -  ALL"
echo "Type : "
read i
#Checker
if [ "$i" -gt "$f" ]
then
echo "ERRROOOOR ...."
exit
fi
#FULL Restore
if [ "$i" -eq "$f" ]
then
while [ $p != $t ]
do
a=$(cat $C | sed -n ${p}p)
echo "$p - Restore $a"
dd if=$S/${a}.img of=$D/${a} 
p=$((p+1))
echo "--------------" 
sleep 3
done 
#Restore determined partition
else
a=$(cat $C | sed -n ${i}p)
echo "$i - Restore $a"
dd if=$S/${a}.img of=$D/${a} 
fi
exit