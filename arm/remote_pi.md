---
layout: arm
title: How to use a remote pi
---

###Headless

The pi is a strange mix, development board and full pc in one. Some people use it as a pc, but not me.

I use the pi because it is the same price as an Arduino, but much more powerful.

As such i don't use the keyboard or display and that is called headless mode, logging in with ssh.

    ssh -p 2222 -l pi localhost

    the -p 2222 is only needed for the qemu version, not the real pi.

###Authorized

Over ssh one can use many other tools, but the password soon gets to be a pain.
So the first thing i do is copy my public key over to the pi. This will allow login without password.

    scp -P 2222 .ssh/id_rsa.pub pi@localhost:.ssh/authorized_keys

This assumes a fresh pi, otherwise you have to append your key to the authorized ones. Also if it complains about no
id_rsa.pub then you have to generate a key pair (public/private) using ssh-keygen (no password, otherwise you'll be typing that)

###Syncing

Off course I do all that to be able to actually work on my machine. On the Pi my keyboard doesn't even work and
i'd have to use emacs or nano instead of TextMate. So i need to get the files accross.
For this there is a million ways, but since i just go one way (mac to pi) i use rsync (over ssh).

I set up a directory (home) in my pi directory (on the mac), that i copy to the home directory on the pi using:

    rsync -r -a -v -e "ssh -l pi -p 2222" ~/pi/home/ localhost:/home/pi

The pi/home is on my laptop and the command transfers all files to /home/pi , the default directory of the pi user.

###Automatic sync

Transferring files is off course nice, but having to do it by hand after saving quickly becomes tedious.

Fswatch to the rescue. It will watch the filesystem (fs) for changes. Install with brew install fswatch

Then you can store the above rsync command in a shell script, say sync.sh.
Add afplay "/System/Library/Sounds/Morse.aiff" if you like to know it worked.

Then just run

    fswatch ~/pi/home/ sync.sh

And hear the ping each time you save.

Conclusion
----------

So the total setup involves the qemu set up as described. To work i

- start the terminal (iterm)
- start the pi, with my alias "pi" *
- log in to the pi in it's window
- open textmate with the directory i work (within the home)
- edit, save, wait for ping, alt-tab to pi window, run my whatever and repeat until it's time for tea

* (i don't log into the prompt it gives in item so as not to accidentally quit the qemu session with ctr-c )
