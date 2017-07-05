# blkio-regulator

1. Compile the modified kernel
-------------------------------------------------------------
  $ cd ~/linux-4.10.17

  $ sudo cp /boot/<any configuration file> .config

  $ make bzImage

  $ make modules

  $ make modules_install

  $ sudo cp .config /boot/config-4.10.17

  $ sudo cp arch/x86/boot/bzImage /boot/vmlinuz-4.10.17

  $ sudo cp System.map /boot/System.map-4.10.17

  $ sudo mkinitramfs -o /boot/initramfs-4.10.17 4.10.17

  $ sudo update-grub

2. Reboot to the compiled kernel

3. Compile and load block io regulator module
--------------------------------------------------------------
  $ cd ~/blkio_regulator_module/KERN_SRC

  $ make clean && make

  $ sudo insmod blkio_regulator.ko

4. unload the module after testing
--------------------------------------------------------------
  $ sudo rmmod blkio_regulator



# Testing

Create block io cgroups script is used to create control groups 
along with their weights with the help of command line arguments

For example the following command will create 3 cgroups with weights 
100 200 300 respectively 

$ ./create_blkio_cgroups.sh -g 3 -w 100 200 300 -r

At the end run option should be given to execute iozone test in each 
cgroup
