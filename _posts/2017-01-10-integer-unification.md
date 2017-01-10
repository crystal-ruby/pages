---
layout: news
author: Torsten
---

I just read mri 2.4 "unifies" Fixnum and Integer. This, it turns out, is something quite
different from what i though, mostly about which class names are returned.
And that it is ok to have two implementations for the same class, Integer.

But even it wasn't what i thought, it did spark an idea, and i hope a solution to a problem
that i have seen lurking ahead. Strangely the solution maybe even more radical than the
cross function jumps it replaces.

## A problem lurking ahead

As i have been thinking more about what happens when a type changes, i noticed something:

An object may change it's type in one method (A), but may be used in a method (B), far up the call
stack. How does B know to treat the object different. Specifically, the calls B makes
on the object are determined by the type before the change. So they will be wrong after the change,
and so B needs to know about the type change.

Such a type change was supposed to be handled by a cross method jump, thus fixing the problem
in A. But the propagation to B is cumbersome, there can be just so many of them.
Anything that i though of is quite a bit too involved. And this is before even thinking about closures.

## A step back

Looking at this from a little higher vantage there are maybe one too many things i have been trying
to avoid.

The first one was the bit-tagging. The ruby (and smalltalk) way of tagging an integer
with a marker bit. Thus loosing a bit and gaining a gazillion type checks. In mri c land
an object is a VALUE, and a VALUE is either a tagged integer or a pointer to an object struct.
So on **every** operation the bit has to be checked. Both of these i've been trying to avoid.

So that lead to a system with no explicit information in the lowest level representation and
thus a large dance to have that information in an external type system and keeping that type
information up to date.

Off course the elephant in the room here is that i have also be trying to avoid making integers and
floats objects. Ie keeping their c, or machine representation, just like anyone else before me.
Too wasteful to even think otherwise.

## And a step forward

The inspiration that came by reading about the unification of integers was exactly that:
**to unify integers** . Unifying with objects, ie **making integers objects**

I have been struggling with the dichotomy between integer and objects for a long time. There always
seemed something so fundamentally wrong there. Ok, maybe if the actual hardware would do the tagging
and that continuous checking, then maybe. But otherwise: one is a direct, the other an indirect
value. It just seemed wrong.

Making Integers (and floats etc) first class citizens, objects with a type, resolves the chasm
very nicely. Off course it does so at a price, but i think it will be worth it.

## The price of Unification

Initially i wanted to make all objects the size of a cache line or multiples thereof. This is
something i'll have to let go of: Integer objects should naturally be 2 words, namely the type
and the actual value.

So this is doubling the amount of ram used to represent integers. But maybe worse, it makes them
subject to garbage collection. Both can probably be alleviated by having the first 256 pinned, ie
a fixed array, but still.

Also using a dedicated memory manager for them and keeping a pool of unused as a linked list
should make it quick. And off course the main hope lies in the fact that your average program
nowadays (especially oo) does not really use integers all that much.

## OO to the rescue

Off course this is not the first time my thought have strayed that way. There are two reasons why
they quickly scuttled back home to known territory before. The first was the automatic optimization
reflex: why use 2 words for something that can be done in one, and all that gc on top.

But the second was probably even more important: If we then have the value inside the object
(as a sort of instance variable or array element), then when return it then we have the "naked"
integer wreaking havoc in our system, as the code expects objects everywhere.
And if we don't return it, then how do operations happen, since machines only operate on values.

The thing that i had not considered is that that line of thinking is mixing up the levels
of abstraction. It assumes a lower level than one needs: What is needed is that the system
knows about integer objects (in a similar way that the other ways assumes knowledge of integer
values.)

Concretely the "machine", or compiler, needs to be able to perform the basic Integer operations,
on the Integer objects. This is really not so different from it knowing how to perform the
operations on two values. It just involves getting the actual values from the object and
putting them back.

OO helps in another way that never occurred to me. **Data hiding:** we never actually pass out
the value. The value is private to the object and not accessible from the outside. In fact it not
even accessible from the inside to the object itself. Admittedly this means more functionality in
the compiler, but since that is a solved problem (see builtin), it's ok.

## Unified method caching

So having gained this unification, we can now determine the type of an object very very easily.
The type will *always* be the first word of the memory that the object occupies. We don't have
immediate values anymore, so always is always.

This is *very* handy, since we have given up being god and thus knowing everything at any time.
In concrete terms this means that in a method, we can *not* know what type an object is.
In fact it's worse, we can't even say what type it is, even if we have checked it, but after we
have passed it as an argument to another method.

Luckily programs are not random, and it quite rare for an object to change type, and so a given
object will usually have one of a very small set of types. This can be used to do method caching.
Instead of looking up the method statically and calling it unconditionally at run-time, we will
need some kind of lookup at run-time.

The lookup tables can be objects that the method carries. A small table (3 entries) with pairs of
type vs jump address. A little assembler to go through the list and jump, or in case of a miss
jump to some handler that does a real lookup in the type.

In a distant future a smaller version may be created. For the case where the type has been
checked already during the method, a further check may be inlined completely into the code and
only revert to the table in case of a miss. But that's down the road a bit.

Next question: How does this work with Parfait. Or the interpreter??
