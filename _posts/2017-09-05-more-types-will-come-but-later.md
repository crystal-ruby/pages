---
layout: news
author: Torsten
---

While work on Mom (Minimal object machine) continues, i can see the futures a little clearer.
Alas, for now the shortest route is best, so the future will have to wait. But here is what i'm
thinking.

## Types today

The [architecture](/rubyx/layers.html) document outlines this in more detail, but in short:
- types are immutable
- every object has a type (which may change)
- a type implements the interface of a class at a given time
- a type is defined by a list of attribute names

![Types diagram](/assets/types.jpg)

### How classes work

So the interesting thing here is how the classes work. Seeing as they are open, attributes can
be added and removed, but the types are immutable.

The solution is easy: when a new attribute is added to a class, a new type is created.

The *instance type* is then updated to point to the current type. This means that new objects will
be created with the new type, and old ones will keep their old type. Until the attribute is
added to them too, in which case their *type* is updated too.

**Methods** btw are stored at the Type, as they encode the knowledge of the memory layout
that comes with the type, into the code of the method. Remember: full data hiding, only objects
methods can access the variables, hence the type needs to be know only for *self*.

## The future of types

But what i wanted to talk about is how this picture is going to change in the future.
To understand why we might want to, let's look at method dispatch on an instance variable.

When you write something like @me.length , the compiler can check that @me is indeed an instance variable by checking the type of self. But since not information is stored about the type of
*me* , a dynamic dispatch is needed to call *length*.

The simple idea is to get rid of this dynamic dispatch by storing the type of instance variables
too. This makes a lot calls faster, but it does come at significant cost:
- every assignment to the variable has to be checked for type.
- many more types must be created to differentiate the variables by name **and** type.

Both of those don't maybe sound soo bad at first, but it's the cumulative effects that make a
difference. Instance assignment is one of the only two ways to move data around in a oo machine.
That's a lot of checking. And Types hold the methods, so for every new type *all* methods have
to be *a* stored, and *b* created/compiled .

But off course the biggest thing is all the coding this entails. So that's why it's in the future :-)

## Multilayered Mom

Just a note on Mom: this was meant to be a bridge between the language layer (vool) and the machine
layer (risc). This step, from tree and statements, to list and low level instructions was deemed
to big, so the abstract Minimal Object Machine is supposed to be a layer in between those.
And it is off course.

What i didn't fully appreciate before starting was that the two things are related. I mean
statements lend themselves to a tree, while having instruction in a tree is kind of silly.
Similarly statements in a list doesn't really make sense either. So it ended up being a two step
process inside Mom.

The *first* pass that transforms vool, keeps the tree structure. But it does introduce Mom's own
instructions. It turns out that this is sensible for exactly the linear parts of code.

The *second* pass flattens the remaining control structures into jumps and labels. The result
maps to the risc layer 1 to n, meaning every Mom instruction simple expands into one or usually
more risc instructions.

In the future i envision that this intermediate representation at the Mom level will be a
good place for further optimisations, but we shall see. At least the code is still recognisable,
meaning relatively easy to reason about. This is a property that the risc layer really does
not have anymore.
