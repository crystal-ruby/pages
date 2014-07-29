---
layout: site
author: Torsten
---

Part of what got me started on this project was the intuition that our programming model is in some way broken and so by 
good old programmers logic: you haven't understood it til you programmed it, I started to walk into the fog.

### FPGA's

Don't ask me why they should be called Field Programmable Gate Arrays, but they have facinated me for years, because off 
course they offer the "ultimate" in programming. Do away with fixed cpu instruction sets and get the programm in silicon.
Yeah!

But several attempts at learning the black magic have left me only little the wiser. Verlilog or VHDL are the languages that
make up 80-90% of what is used and they so not object oriented, or in any way user friendly. So that has been on the long
list, until i bumped into [pshdl](http://pshdl.org/) by way of Karstens [excellent video on it](https://www.youtube.com/watch?v=Er9luiBa32k). Pshdl aim to be simple and indeed looks it. Also similuation is exact 
and fast. Definately the way to go Karsten!

But what struck me is something he said. That in hardware programming it's all about getting your design/programm to fit into
the space you have, and make the timing of the gates work.

And i realized that is what is missing from our programming model: time and space. There is no time, as calls happen 
sequentially / always immediately. And there is no space as we have global memory with random access, unlimited by virtual
memory. But the world we live in is governed by time and space, and that governs the way our brain works.

### Active Objects vs threads

That is off course not soo new, and the actir model has been created to fix that. And while i haven't used it much, 
i believe it does, especially in non techie problems. And [Celluloid](http://celluloid.io/) seems to be a great
implementation of that idea.

Off course Celluloid needs native threads, so you'll need to run rubinius or jruby. Understandibly. And so we have 
a fix for the problem, if we use celluloid.

But it is a fix, it is not part of the system. The system has sequetial calls per thread and threads. Threads are evil as
i explain (rant about?) [here](/salama/threads.html), mainly because of the shared global memory. 

### Messaging with inboxes

If you read the rant (it is a little older) you'll se that it established the problem (shared global memory) but does not
propose a solution as such. The solution came from a combination of the rant, 
the [previous post](/2014/07/17/framing.html) and the fpga physical perspective.

A physical view would be that we have a fixed number of object places on the chip (like a cache) and as the previous post
explains, sending is creating a message (yet another object) and transferring control. Now in a physical view control is
not in one place like in a cpu. Any gate can switch at any cycle, so any object could be "active" at every cycle (without
going into any detail about what that means).

But it got me thinking how that would be coordinated, because one object doing two things may lead to trouble. But one of
the Sythesis ideas was [lock free synchronisation](http://valerieaurora.org/synthesis/SynthesisOS/ch5.html) 
by use of a test-and-swap primitive.

So if every object had an inbox, in a similar way that each object has a class now, we could create the message and put it
there. And by default we would expect it to be empty, and test that and if so put our message there. Otherwise we queue it.

From a sender perspective the process is: create a new Message, fill it with data, put it to receivers inbox. From a 
receivers perspective it's check you inbox, if empty do nothing, otherwise do what it says. Do what it says could easily
include the ruby rules for finding methods. Ie check if your youself have a method by that name, send to super if not etc.

In a fpga setting this would be even nicer, as all lookups could be implemented by associative memory and thus happen in one
cycle. Though there would be some manager needed to manage which objects are on the chip and which could be hoisted off. 
Nothing more complicated than a virtual memory manager though.

The inbox idea represents a solution to the thread problem and has the added benefit of being easy to understand and 
possibly even to implement. It should also make it safe to run several kernel threads, though i prefer the idea of
only having one or two kernel threads that do exclusively system calls and the rest with green threads that use 
home grown scheduling.

This approach also makes one way messaging very natural though one would have to inent a syntax for that. And futures should
come easy too.