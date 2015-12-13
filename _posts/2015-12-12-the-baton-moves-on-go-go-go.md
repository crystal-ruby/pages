---
layout: news
author: Torsten
---

Nothing significant has ever been achieved by a single person. Also software is clearly a group effort.

For me the time has come to pass the baton on. The journey has been fun and the results surprising
to say the least. But i did my sprint, with over 1000 hours/commits, and the air is out, energy gone.

Time for **you** to do your bit, or (more litkely) some other project making the next move.

## The hierarchy of languages

To recap: Traditionally VM's have been built as interpreters, because of what i called the semantic
gap in the last post. Meaning the language being compiled (say ruby) and the language used for
implementation (say c) are just too far apart, mentally.

The way to do it is the way c++ did it, by compiling **into** a lower language, c in c++'s case.
This leads to high demands on that lower language, which is why i created [soml](/soml/soml.html).

Now the **main rquirement** is really that it be dynamic, so that it is possible to create more code
at runtime. I threw in oo and multi-returns, but those things can be dealt with in other ways
as we see below.

Having [written the language](/2015/11/28/one-compiler-down-one-to-go.html) i really really
appreciate what other people have done. While i got it up and running (surprising in itself) it is
a loooong way off a usable system. So i took a step back to evaluate.

## Language alternatives

Looking around with my new "requirements" i found a couple of other alternatives. So the main idea
was not to add another language to the world, just so i can compile into it. Instead to use an
existing one. Go and Julia are good candidates i think. Go would be my choice, so i'll go
(pun intended) into a little detail.

### Dynamic

Now go is not per se a dynamic language, other than julia where it is baked in already. But other
than julia, go is self hosted, so the whole compiler, assembler, linker chain is available in go.
And once one has found a mapping from oo to go, in oo as well. So then it is "easy" , just compile
the oo into go, compile, link and run.

Maybe one needs to be a little more clever about replacing existing methods, but that's not too
difficult. One just writes the new on, and when done,
[CAS's](https://en.wikipedia.org/wiki/Compare-and-swap) the first instruction of the old
function to be a jump to the new. To save memory one can even rewrite the old one to be the new one
(reuse the memory), apart from the first jump off course. And then cas the patched jump to the
new first instruction. Ok, some footwork, but conceptually easy.

### OO in go

As Go is so insistent on pointing out, there is no oo in go. So how is that supposed to work when i
said one needs oo in the lower language. Well, go has all the pieces needed to make oo, compound
and basic types, interfaces and methods. It's just a matter of perception.

Objects map to structs off course and methods to methods (duh), good to go, yes? Not quite.
Classes do not map to types. What i had as a Layout maps to a type, and so each type must
carry it's class. For basic types this off course can't work and that brings us back to one of the
earliest things, that values are not objects, so that's ok.

A class is then the set of all types (structs) with the same names, but not same sub types
(potentially a lot, but computers are good at that). Julia shows nicely how then the method
matching has to be done on the type signature. I had written
[that down already](https://dancinglightning.gitbooks.io/the-object-machine/content/object/dynamic_types.html)
but found it has a name, multi-dispatch. Problem solved.

### No multi-return

Then the last problem is to solve is the lack of multi-return in any of those languages.
Multi-return was an idea that i hadn't actually implemented yet, but it was to allow several
return *addresses* (not values). There are two ways around that as far as i see.
The sort of more Julia way is to "box" the return value and check for type in the receiver.

In go, i would use multiple return values to achieve the same. So *every* (generated) oo function
would return a tuple of all possible types (int/float/ref) and a separate indicator which is the
value to be used. Off course that makes the generated functions ugly and bloated, but since they are
typed (and probably will include a lot of dead ends) optimisation should take care of that.

## Time is getting on

As i said, i feel i've done my bit here. 50 is very close and with it comes a surprising joy of
mowing or raking the lawn. It really needs someone younger to pull this off.

I also had some idea of using this project on pi or arduinos, because ruby just is not fast enough
on those. But [Artoo](http://artoo.io/), has got some brothers, one is [Gobot](http://gobot.io/),
and since they all play together nicely, they will do me fine. Ruby where possible, go where needed.

It seems the language scene has never been so active and so i'm sure someone will have the
same idea soon enough. We are after all **one species**, not nearly as individual as we like to think.
I'll be watching.
