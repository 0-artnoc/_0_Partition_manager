#Base
D="/storage/7FE8-0427/Stock"
C="/sdcard/part.txt"
system="system.img.ext4.lz4"
t=$(ls $D |grep lz4 | wc -l)
t=$((t+1))
p=1
#Files
ls $D |grep lz4 >$C
#Work
while [ "$p" -ne "$t" ]
do
a=$(cat $C |sed -n ${p}p)
if [ "$a" = "$system" ]
then
echo "Changing Methods"
echo "$p - Decompression $a"
lz4 -d $D/$a --no-sparse
p=$((p+1))
else
echo "$p - Decompression $a"
lz4 -d $D/$a
p=$((p+1))
echo "--------------" 
sleep 3
fi
done
