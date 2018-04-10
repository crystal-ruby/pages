Now that i *have* had time to write some more code (250 commits last month), here is
the good news:

## Sending is done

A dynamic language like ruby really has at it's heart the dynamic method resolution. Without
that we'd be writing C++. Not much can be done in ruby without looking up methods.

Yet all this time i have been running circles around this mother of a problem, because
(after all) it is a BIG one. It must be the one single most important reason why dynamic
languages are interpreted and not compiled.

## A brief recap

Last year already i started on a rewrite. After hitting this exact same wall for the fourth
time. I put in some more Layers, the way a good programmer fixes any daunting problem.

The [Readme](https://github.com/ruby-x/rubyx) has quite a good summary on the new layers,
and off course i'll update the architecture soon. But in case you didn't click, here is the
very very short summary:


- Vool is a Virtual Object Oriented Language. Virtual in that is has no own syntax. But
  it has semantics, and those are substantially simpler than ruby. Vool is Ruby without
  the fluff.

- Mom, the Minimal Object Machine layer is the first machine layer. Mom has no concept of memory
  yet, only objects. Data is transferred directly from object
  to object with one of Mom's main instructions, the SlotLoad.

- Risc layer here abstracts the Arm in a minimal and independent way. It does not model
  any real RISC cpu instruction set, but rather implements what is needed for rubyx.

- There is a minimal *Arm* translator that transforms Risc instructions to Arm instructions.
  Arm instructions assemble themselves into binary code. A minimal *Elf* implementation is
  able to create executable binaries from the assembled code and Parfait objects.

- Parfait: Generating code (by descending above layers) is only half the story in an oo system.
  The other half is classes, types, constant objects and a minimal run-time. This is
  what is Parfait is.

## Compiling and building

After having finished all this layering work, i was back to square *resolve*: how to
dynamically, at run-time, resolve a method to binary. The strategy was going to be to have
some short risc based check and bail out to a method.

But off course when i got there i started thinking that the resolve method (in ruby)
would need resolve itself. And after briefly considering cheating (hardcoding type
information into this *one* method), i opted to write the code in Risc. Basically assembler.

And it was horrible. It worked, but it was completely unreadable. So then i wrote a dsl for
generating risc instructions, using a combination of method_missing, instance_eval and
operator overloading. The result is quite readable code, a mixture between assembler and
a mathematical notation, where one can just freely name registers and move data around
with *[]* and *<<*.

By then resolving worked, but it was still a method. Since it was already in risc, i basically
inlined the code by creating a new Mom instruction and moving the code to it's *to_risc*.
Now resolving still worked, and also looked good.

A small bug in calling the resulting method was fixed, and *voila*, ruby-x can dynamically call
any method.

## The proof

Previous, static, Hello Worlds looked like this:
> "Hello world".putstring

Off course we can know the type that putstring applies to and so this does not
involve any method resolution at runtime, only at compile time.

Todays step is thus:
> a = "Hello World"

> a.putstring

This does involve a run-time lookup of the *putstring* method. It being a method on String,
it is indeed found and called.(1) Hurray.

And maths works too:
> a = 150

> a.div10

Does indeed result in 15. Even with the *new* integers. Part of the rewrite was to upgrade
integers to first class objects.

PS(1): I know with more analysis the compiler *could* now that *a* is a String (or Integer),
but just now it doesn't. Take my word for it or even better, read the code.
