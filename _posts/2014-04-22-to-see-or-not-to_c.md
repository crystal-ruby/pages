---
layout: news
author: Torsten
---

The c machine
-------------

Software engineers have clean brains, scrubbed into full c alignment through decades. A few rebels (klingons?) remain on embedded systems, but of those most strive towards posix compliancy too.

In other words, since all programming ultimately boils down to c, libc makes the bridge to the kernel/machine. All ....  all but a small village in the northern (cold) parts of europe (Antskog) where ...
 
So i had a look what we are talkng about.

The issue 
----------

Many, especially embedded guys, have noticed that your standard c library has become quite heavy (2 Megs).
Since it provides a defined (posix) and large functionality on a plethora of systems (os's) and cpu's. Even for different ABI's (application binary interfaces) and compilers/linkers it is no wonder.

ucLibc or dietLibc get the size down, especially diet quite a bit (130k). So that's ok then. Or is it?

Then i noticed that the real issue is not the size. Even my pi has 512 Mb, and of course even libc gets paged. 

The real issue is the step into the C world. So, extern functions, call marshelling, and the question is for what.

Afer all the c library was created to make it easier for c programs to use the kernel. And i have no intention of coding any more c.

ruby core/std-lib
------------

Off course the ruby-core and std libs were designed to do for ruby what libc does for c. Unfortunately they are badly designed and suffer from above brainwash (designed around c calls)

Since salama is pure ruby there is a fair amount of functionality that would be nicer to provide straight in ruby. As gems off course, for everybody to see and fix. 
For example, even if there were to be a printf (which i dislike) , it would be easy to code in ruby. 

What is needed is the underlying write to stdout.

Solution
--------

To get salama up and running, ie to have a "ruby" executable, there are really very few kernel calls needed. File open, read and stdout write, brk.

So the way this will go is to write syscalls where needed. 

Having tried to reverse engineer uc, diet and musl, it seems best to go straight to the source. 

Most of that is off course for intel, but eax goes to r7 and after that the args are from r0 up, so not too bad. The definate guide for arm is here http://sourceforge.net/p/strace/code/ci/master/tree/linux/arm/syscallent.h
But doesn't include arguments (only number of them), so http://syscalls.kernelgrok.com/ can be used.

So there, getting more metal by the minute. But the time from writing this to a hello world was 4 hours.
