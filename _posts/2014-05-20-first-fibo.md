---
layout: news
author: Torsten
---
Both "ends", parsing and machine code, were relatively clear cut. Now it is into unknown territory. 

I had ported the Kaleidescope llvm tutorial language to ruby-llvm last year, so thee were some ideas floating.

The idea of basic blocks, as the smallest unit of code without branches was pretty clear. Using those as jump
targets was also straight forward. But how to get from the AST to arm Intructions was not, and took some trying out.

In the end, or rather now, it is the AST layer that "compiles" itself into the Vm layer. The Vm layer then assembles
   itself into Instructions. 

General instructions are part of the Vm layer, but the code picks up derived classes and thus makes machine
dependant code possible. So far so ok.

Register allocation was (and is) another story. Argument passing and local variables do work now, but there is definately
room for improvement there.

To get anything out of a running program i had to implement putstring (easy) and putint (difficult). Surprisingly 
division is not easy and when pinned to 10 (divide by 10) quite strange. Still it works. While i was at writing
assmbler i found a fibonachi in 10 or so instructions.

To summarise, function definition and calling (including recursion) works. 
If and and while structures work and also some operators and now it's easy to add more. 

So we have a Fibonacchi in ruby using a while implementation that can be executed by crystal and outputs the
   correct result. After a total of 7 weeks this is much more than expected!
