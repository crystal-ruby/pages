---
layout: arm
title: Arm resources
---

## Arm is the target

So, since the first target is arm, some of us may need to learn a bit (yep, that's me). So this is
a collection of helpful resources (links and specs) with sometimes very very brief summaries.

So why learn assembler, after all, it's likely you spent your programmers life  avoiding it:

  - Some things can not be expressed in Soml
  - To speed things up.
  - To add cpu specific capabilities

## Links

A very good [summary pdf](/arm/arm_inst.pdf) was created by the arm university, which i converted
to [html for online reading](/arm/target.html)

[Dave's](http://www.davespace.co.uk/arm/introduction-to-arm/why-learn.html) site explains just about
everything about the arm in nice and easy to understand terms.

A nice series on thinkgeek, here is the integer [division section](http://thinkingeek.com/2013/08/11/arm-assembler-raspberry-pi-chapter-15/) that has a
[code respository](https://github.com/rofirrim/raspberry-pi-assembler/blob/master/chapter15/magic.py)
with code to generate code for constants.

And off course there is the overwhelming arm infocenter, [here with it's bizarre division](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0473c/CEGECDGD.html)

The full 750 page specification for the pi , the [ARM1176JZF-S pdf is here](/arm/big_spec.pdf) or
[online](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0553a/BABFADHJ.html)

A nice list of [Kernel calls](http://docs.cs.up.ac.za/programming/asm/derick_tut/syscalls.html) 
## Virtual pi

And since not everyone has access to an arm, here is a description how to set up an [emulated pi](/arm/qemu.html)

And how to [access that](/arm/remote_pi.html) or any remote machine with ssl
