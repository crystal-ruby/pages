---
layout: typed
title: Parfait, a minimal runtime
---


### Type and Class

Each object has a type that describes the instance variables and basic types of the object.
Types also reference the class they implement.
Type objects are unique and constant, may not be changed over their lifetime.
When a field is added to a class, a new Type is created. For a given class and combination
of instance names and basic types, only one instance every exists describing that type (a bit
similar to symbols)

A Class describes a set of objects that respond to the same methods (the methods source is stored
in the RubyMethod class).
A Type describes a set of objects that have the same instance variables.

### Method, Message and Frame

The TypedMethod class describes a callable method. It carries a name, argument and local variable
type and several descriptions of the code.
The typed ast is kept for debugging, the register model instruction stream for optimisation
and further processing and finally the cpu specific binary
represents the executable code.

When TypedMethods are invoked, A message object (instance of Message class) is populated.
Message objects are created at compile time and form a linked list.
The data in the Message holds the receiver, return addresses, arguments and a frame.
Frames are also created at compile time and just reused at runtime.

### Space and support

The single instance of Space hold a list of all Types and all Classes, which in turn hold
the methods.
Also the space holds messages and will hold memory management objects like pages.

Words represent short immutable text and other word processing (buffers, text) is still tbd.

Lists (aka Array) are number indexed, starting at one, and dictionaries (aka Hash) are mappings from words to objects.
