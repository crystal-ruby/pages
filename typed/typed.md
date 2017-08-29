---
layout: typed
title: Typed intermediate representation
---

### Intermediate representation

Compilers use different intermediate representations to go from the source code to a binary,
which would otherwise be too big a step.

The **typed** intermediate representation is a strongly typed layer, between the dynamically typed
ruby above, and the register machine below. One can think of it as a mix between c and c++,
minus the syntax aspect. While in 2015, this layer existed as a language, (see soml-parser), it
is now a tree representation only.


#### Object oriented to the core, including calling convention

Types are modeled by the class Type and carry information about instance variable names
and their basic type. *Every object* stores a reference
to it's type, and while **types are immutable**, the reference may change. The basic types every
object is made up off, include at least integer and reference (pointer).

The object model, ie the basic properties of objects that the system relies on, is quite simple
and explained in the runtime section. It involves a single reference per object.
Also the object memory model is kept quite simple in that object sizes are always small multiples
of the cache size of the hardware machine.
We use object encapsulation to build up larger looking objects from these basic blocks.

The calling convention is also object oriented, not stack based*. Message objects are used to
define the data needed for invocation. They carry arguments, a frame and return address.
The return address is pre-calculated and determined by the caller, so
a method invocation may thus be made to return to an entirely different location.
\*(A stack, as used in c, is not typed, not object oriented, and as such a source of problems)

There is no non- object based memory at all. The only global constants are instances of
classes that can be accessed by writing the class name in ruby source.

#### Runtime / Parfait

The typed representation layer depends on the higher layer to actually determine and instantiate
types (type objects, or objects of class Type). This includes method arguments and local variables.

The typed layer is mainly concerned in defining TypedMethods, for which argument or local variable
have specified type (like in c). Basic Type names are the class names they represent,
but the "int" may be used for brevity
instead of Integer.

The runtime, Parfait, is kept
to a minimum, currently around 15 classes, described in detail [here](parfait.html).

Historically Parfait has been coded in ruby, as it was first needed in the compiler.
This had the additional benefit of providing solid test cases for the functionality.
