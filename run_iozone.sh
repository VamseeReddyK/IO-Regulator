#!/bin/bash
date=`date +%F_%k:%M:`
hostname=`hostname`

# -i0 -i1 for test 0 and 1 (write and read)
# -r 4 for 4 KB records
# -s 100M  for 100M files for each thread, so 1000M ~ 1G total
# -t 10 for 10 threads 
# -R for excel
# -b for filename


sync=400
coe2=400
python cat_cgroup_io.py
while [ $sync -le 400 ]
do
#echo $sync | sudo tee /sys/block/sda/queue/iosched/slice_sync

delay=0
coe=2
while [ $delay -le 0 ]
do
i=3

#run infinitely, incrementing i on each interaction
sudo sync && echo 3 | sudo  tee /proc/sys/vm/drop_caches
while [ $i -ge 1 ]
do 
 
 ./iozone -w -J $delay -+T -i1 -I -r 512K  -s $[ 512*4 ]M -t 1  -F ./tmp_10G_$i >  iozone_sync$[ sync ]_delay$[ delay ]_user$[ i ].log  &
pi=$!
echo $pi | sudo tee /sys/fs/cgroup/blkio/user_$i/cgroup.procs

  let i=i-1
done

iostat -x  2 sda >  iostat_sync$sync_delay$delay.log &
io=$!
wait $pi
kill -9 $io
killall -s 9 iozone
sleep 3
let coe=coe*2
let delay=coe
done

let coe2=coe2*2
let sync=coe2
sleep 3
done


python cat_cgroup_io.py

echo finish
