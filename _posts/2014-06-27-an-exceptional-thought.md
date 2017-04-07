---
layout: news
author: Torsten
---

I was just reading my ruby book, wondering about functions and blocks and the like, as one does when implementing
a vm. Actually the topic i was struggling with was receivers, the pesty self, when i got the exception.

And while they say two steps forward, one step back, this goes the other way around.

### One step back

As I just learnt assembler, it is the first time i am really considering how functions are implemented, and how the stack is
used in that. Sure i heard about it, but the details were vague.

Off course a function must know where to return to. I mean the memory-address, as this can't very
well be fixed at compile time. In effect this must be passed to the function. But as programmers we
don't want to have to do that all the time and so it is passed implicitly.

##### The missing link

The arm architecture makes this nicely explicit. There, a call is actually called branch with link.
This almost rubbed me for a while as it struck me as an exceedingly bad name. Until i "got it",
that is. The link is the link back, well that was simple. But the thing is that the "link" is
put into the link register.

This never struck me as meaningful, until now. Off course it means that "leaf" functions do not
need to touch it. Leaf functions are functions that do not call other functions, though they may
do syscalls as the kernel restores all registers. In other cpu's the return address is pushed on
the stack, but in arm you have to do that yourself. Or not and save the instruction if you're so inclined.

##### The hidden argument

But the point here is, that this makes it very explicit. The return address is in effect just
another argument. It usually  gets passed automatically by compiler generated code, but never
the less. It is an argument.

The "step back" is to make this argument explicit in the vm code. Thus making it's handling,
ie passing or saving explicit too. And thus having less magic going on, because you can't
understand magic (you gotta believe it).

### Two steps forward

And so the thrust becomes clear i hope. We are talking about exceptions after all.

Because to those who have not read the windows calling convention on exception handling or even
heard of the dwarf specification thereof, i say don't. It melts the brain.
You have to be so good at playing computer in your head, it's not healthy.

Instead, we make things simple and explicit. An exception is after all just a different way for
a function to return. So we need an address for it to return too.

And as we have just made the normal return address an explicit argument, we just make the
exception return address and argument too. And presto.

Even just the briefest of considerations of how we generate those exception return addresses
(landing pads? what a strange name), leads to the conclusion that if a function does not do
any exception handling, it just passes the same address on, that it got itself. Thus a
generated exception would jump clear over such a function.

Since we have now got the exceptions to be normal code (alas with an exceptional name :-)) control
flow to and from it becomes quite normal too.

To summarize each function has now a minimum of three arguments: the self, the return address and
the exception address.

We have indeed taken a step forward.
