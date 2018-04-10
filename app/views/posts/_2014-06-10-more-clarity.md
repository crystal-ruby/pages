It's such a nice name, crystal. My first association is clarity, and that is exactly what i am trying to achieve.

But i've been struggling a bit to achieve any clarity on the topic of system boundary: where does OO stop. I mean i can't very well define method lookup in ruby syntax, as that involves method lookups. But tail recursion is so booring, it just never stops!

#### Kernel

In the design phase (yes there was one!), i had planned to use lambdas. A little naive maybe, as they are off course objects. Thus calling them means a method resolution.

So i'm settling for Module methods. I say settling because that off course always makes the module object available, though i don't see any use for it. A waste in space (one register) and time (loading it), but no better ideas are forthcoming.

The place for these methods, and i'll go into it a little which in a second, is the Kernel. And finally the name makes sense too. That is it's original (pre 1.9) place, as a module that Object includes, ie "below" even Object.

So Kernel is the place for methods that are needed to build the system, and may not be called on objects. Simple.

In other words, anything that can be coded on normal objects, should. But when that stops being possible, Kernel is the place.

And what are these functions? get_instance_variable or set too. Same for functions. Strangley these may in turn rely on functions that can be coded in ruby, but at the heart of the matter is an indexed operation ie object[2].

This functionality, ie getting the n'th data in an object, is essential, but c makes such a good point of of it having no place in a public api. So it needs to be implemented in a "private" part and used in a save manner. More on the layers emerging below.

The Kernel is a module in salama that defines functions which return function objects. So the code is generated, instead of parsed. An essential distinction.

#### System

It's an important side note on that Kernel definition above, that it is _not_ the same as system access function. These are in their own Module and may (or must) use the kernel to implement their functionality. But not the same.

Kernel is the VM's "core" if you want.

System is the access to the operating system functionality.

#### Layers

So from that Kernel idea have now emerged 3 Layers, 3 ways in which code is created.

##### Machine

The lowest layer is the Machine layer. This Layer generates Instructions or sequences thereof. So off course there is an Instruction class with derived classes, but also Block, the smallest, linear, sequences of Instructions.

Also there is an abstract RegisterMachine that is mostly a mediator to the current implementation (ArmMachine). The machine has functions that create Instructions

Some few machine functions return Blocks, or append their instructions to blocks. This is really more a macro layer. Usually they are small, but div10 for example is a real 10 instruction beauty.

##### Kernel

The Kernel functions return function objects. Kernel functions have the same name as the function they implement, so Kernel::putstring defines a function called putstring. Function objects (Vm::Function) carry entry/exit/body code, receiver/return/argument types and a little more.

The important thing is that these functions are callable from ruby code. Thus they form the glue from the next layer up, which is coded in ruby, to the machine layer. In a way the Kernel "exports" the machine functionality to salama.

##### Parfait

Parfait is a thin layer implementing a mini-minimal OO system. Sure, all your usual suspects of string and integers are there, but they only implement what is really really necessary. For example strings mainly have new equals and put.

Parfait is heavy on Object/Class/Metaclass functionality, object instance and method lookup. All things needed to make an OO system OO. Not so much "real" functionality here, more creating the ability for that.

Stdlib would be the next layer up, implementing the whole of ruby functionality in terms of what Parfait provides.

The important thing here is that Parfait is written completely in ruby. Meaning it get's parsed by salama like any other code, and then transformed into executable form and written.

Any executable that salama generates will have Parfait in it. But only the final version of salama as a ruby vm, will have the whole stdlib and parser along.

#### Salama

Salama uses the Kernel and Machine layers straight when creating code. Off course.
The closest equivalent to salama would be a compiler and so it is it's job to create code (machine layer objects).

But it is my intention to keep that as small as possible. And the good news is it's all ruby :-)

##### Extensions

I just want to mention the idea of extensions that is a logical step for a minimal system. Off course they would be gems, but the interesting thing is they (like salama) could:

- use salamas existing kernel/machine abstraction to define new functionality that is not possible in ruby
- define new machine functionality, adding kernel type api's, to create wholly new, possibly hardware specific functionality

I am thinking graphic acceleration, GPU usage, vector api's, that kind of thing. In fact i aim to implement the whole floating point functionality as an extensions (as it clearly not essential for OO).
