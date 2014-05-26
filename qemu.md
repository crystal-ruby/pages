---
layout: site
title: How to configure Qemu
---

Target Pi on Mac
----------------

So even the idea is to run software on the Pi, not everyone has a Pi (yet :-)

Others, like me, prefer to develop on a laptop and not carry the Pi around. 

For all those, this here explains how to emulate the Pi on a Mac.

Replace the buggy llvm
-----------------------

Written April 2014: as of writing the latest and greatest llvm based gcc (5.1) on Maverick (10.9) has a bug that makes qemu hang.

So type gcc -v and if the output contains "LLVM version 5.1", you must install gcc4.2. Easily donw with homebrew:

brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb

This will not interfere with the systems compiler as the gcc4.3 has postfixed executables (ie gcc-4.2) 

Qemu 
----

Then its time to get the Qemu. There may be other emulators out there, and i have read of armulator, but this is what i found discribed and it works and is "easy enough".

brew install qemu --env=std --cc=gcc-4.2

For people not on Maverick it may work without the -cc option. 

Pi images
----------

Create a directory for the stuff on your mac, ie pi.

Get the latest Raspian image.

There seems to be some chicken and egg problem, so quemu needs the kernel seperately. There is one in the links.

Configure
---------

In the blog post there is some fun configuration, I did it and it works. Not sure what happens if you don't.
The booting is described below (you may or may not need an extra init=/bin/bash in the root... quotes), so boot your Pi and then configure:

nano /etc/ld.so.preload

Put a # in front of the first to comment it out. Should just be one line there.

Press ctrl-x then y then enter to save and exit.

(Optional) Create a file /etc/udev/rules.d/90-qemu.rules with the following content:
KERNEL=="sda", SYMLINK+="mmcblk0"
KERNEL=="sda?", SYMLINK+="mmcblk0p%n"
KERNEL=="sda2", SYMLINK+="root"

The kernel sees the disk as /dev/sda, while a real pi sees /dev/mmcblk0. 
This will create symlinks to be more consistent with the real pi.

Boot
-----

There is quite a bit to the command line to boot the pi (i have an alias), here it is:

qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append 'root=/dev/sda2 panic=1 rootfstype=ext4 rw' -hda raspbian.img -redir tcp:2222::22

- the cpu is what braodcom precifies, ok
- memory is unfortuantely hardcoded in the versatilepb "machine"
- the kernel is the file name of the kernel you downloaded (or extracted)
- raspbian.img is the image you downloaded. Renamed as it probably had the datestamp on it
- the redir redircts the port 2222 to let you log into the pi

So "ssh -p 2222 -l pi localhost" will get you "in". Ie username pi (password raspberry is the default) and port 2222

Qemu bridges the network (that it emulates), and so your pi is now as connected as your mac.

More Disk
---------

The image that you download has only 200Mb free. Since the gcc is included and we're developing (tiny little files of) ruby, this may be ok. If not there is a 3 step procedure to up the space.

1. dd if=/dev/zero bs=1m count=2048 >> raspbian.img 

The 2048 gets you 2Gb as we specified 1m (meg).

2. On the pi launch "sudo fdisk /dev/sda" . This will probably only work if your do the (Optional) config above.

Say p, and write down the start of the second partition (122880 for me).
d 2 will delete the second partition
n p 2 will create a new primary second partition
write the number as start and just return to the end.
p to check
w to write and quit.

3. Reboot, and run resize2fs

Links
-----

Blog post: http://xecdesign.com/qemu-emulating-raspberry-pi-the-easy-way/
Kernel: http://xecdesign.com/downloads/linux-qemu/kernel-qemu
Rasbian file system(preferably be torrent): http://www.raspberrypi.org/downloads/
