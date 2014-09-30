---
layout: news
author: Torsten
---

While trying to figure out what i am coding i had to attack this storage format before i wanted to. The 
immediate need is for code dumps, that are concise but readable. I started with yaml but that just takes 
too many lines, so it's too difficult to see what is going on.

I just finished it, it's a sort of condensed yaml i call sof (salama object file), but i want to take the
moment to reflect why i did this, what the bigger picture is, where sof may go.

### Program lifecycle

Let's take a step back to mother smalltalk: there was the image. The image was/is the state of all the
 objects in the system. Even threads, everything. Absolute object thinking taken to the ultimate. 
 A great idea off course, but doomed to ultimately fail because no man is an island (so no vm is either).

#### Development

Software development is a team sport, a social activity at it's core. This is not always realised, 
when the focus is too much on the outcome, but when you look at it, everything is done in teams.

The other thing not really taken into account in the standard developemnt model is that it is a process in 
time that really only gets jucy with a first customer released version. Then you get into branches for bugs
and features, versions with major and minor and before long you'r in a jungle of code.

#### Code centered
 
But all that effort is concentrated on code. Ok nowadays schema evlolution is part of the game, so the
existance of data is acknowledged, but only as an external thing. Nowhere near that smalltalk model.

But off course a truely object oriented program is not just code. It's data too. Maybe currently "just"
configuration and enums/constants and locales, but that is exactly my point.

The lack of defined data/object storage is holding us back, making all our programs fruit-flies. 
I mean it lives a short time and dies. A program has no way of "learning", of accumulating data/knowledge
to use in a next invocation.

#### Optimisation example

Let's take optimisation as an example. So a developer runs tests (rubyprof/valgrind or something) 
with some output and makes program changes accordingly. But there are two obvious problems.
Firstly the data is collected in development not production. Secondly, and more importantly, a person is
needed.

Of course a program could quite easily monitor itself, possibly over a long time, possibly only when
not at epak load. And surely some optimisations could be automated, a bit like the O1 .. On compiler
switches, more and more effort could be exerted on critical regions. Possibly all the way to 
super-optimisation.

But even if we did this, and a program would improve/jit itself, the fruits of this work are only usable
during that run of that program. Future invocations, just like future versions of that program do not
benefit. And thus start again, just like in Groundhog day.

### Storage

So to make that optimisation example work, we would need a storage: Theoretically we could make the program
change it's own executable/object files, in ruby even it's source. Theoretically, as we have no 
representation of the code to work on.

In salama we do have an internal representation, both at the code level (ast) and the compiled code 
(CompiledMethod, Intructions and friends).

#### Storage Format

Going back to the Image we can ask why was it doomed to fail: because of the binary, 
proprietary implementation. Not because of the idea as such.

Binary data needs either a rigourous specification and/or software to work on it. Work, what work?
We need to merge the data between installations, maintain versions and branches. That sounds a lot like
version control, because it basically is. Off course this "could" have been solved by the smalltalk
people, but wasn't. I think it's fair to say that git was the first system to solve that problem.

And git off course works with diff, and so for a 3-way merge to be successful we need a text format. 
Which is why i started with yaml, and which is why also sof is text-based.

The other benefit is off course human readability.

So now we have an object file * format in text, and we have git. What we do with it is up to us.
(* well, i only finished the writer. reading/parsing is "left as an excercise for the reader":-)

#### Sof as object file format

Ok, i'll sketch it a little: Salama would use sof as it's object file format, and only sof would ever be
stored in git. For developers to work, tools would create source and when that is edited compile it to sof.

A program would be a repository of sof and resource files. Some convention for load order would be helpful
and some "area" where programs may collect data or changes to the program. Some may off course alter the 
sof's directly.

How, when and how automatically changes are merged (via git) is up to developer policy . But it is 
easily imaginable that data in program designated areas get merged back into the "mainstream" automatically.

