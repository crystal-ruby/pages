---
layout: rubyx
title: RubyX architectural layers
---

## Main Layers

To implement an object system to execute object oriented languages takes a large system.
The parts or abstraction layers are detailed below.

It is important to understand the approach first though, as it differs from the normal
interpretation. The idea is to **compile** ruby. The argument is often made that
typed languages are faster, but i don't believe in that. I think dynamic languages
just push more functionality into the "virtual machine" and it is in fact only the
compiling to binaries that gives static languages their speed. This is the reason
to compile ruby.

![Architectural layers](/assets/layers.jpg)


### Ruby

To compile and run ruby, we first need to parse ruby. While parsing ruby is quite
a difficult task, it has already been implemented in pure ruby
[here](https://github.com/whitequark/parser). The output of the parser is
an ast, which holds information about the code in instances of a single *Node* class.
Nodes have a type (which you sometimes see in s-expressions) and a list of children.

There are two basic problems when working with ruby ast: one is the a in ast, the other is ruby.

Since an abstract syntax tree only has one base class, one needs to employ the visitor
pattern to write a compiler. This ends up being one great class with lots of unrelated
functions, removing much of the benefit of OO.

The second, possibly bigger problem, is ruby itself: Ruby is full of programmer happiness,
three ways to do this, five to do that. To simplify that, remove the duplication and
make analyis easier, Vool was created.

### Virtual Object Oriented Language

Virtual, in this context, means that there is no syntax for this language; it is an
intermediate representation which *could* be targeted by several languages.

The main purpose is to simplify existing oo languages down to it's core components: mostly
calling, assignment, continuations and exceptions. Typed classes for each language construct
exist and make it easier to transform a statement into a lower level representations.

Examples for things that exist in ruby but are broken down in Vool are *unless* , ternary operator,
do while or for loops and other similar syntactic sugar.

### Minimal Object machine

We compile Vool statements into Mom instructions. Mom is a machine, which means it has
instructions. But unlike a cpu (or the risc layer below) it does not have memory, only objects.
It also has no registers, and together these two things mean that all information is stored in
objects. Also the calling convention is object based and uses Frame and Message instances to
save state.

Objects are typed, and are in fact the same objects the language operates on. Just the
functionality is expressed through instructions. Methods are in fact defined (as vool) on classes
and then compiled to Mom/Risc/Arm and the results stored in the method object.

Compilation to Mom happens in two stages:
1. The linear statements/code is translated to Mom instructions.
2. Control statements are translated to jumps and labels.

The second step leaves a linked list of machine instructions as the input for the next stage.
In the future a more elaborate system of optimisations is envisioned between these stages.

### Risc

The Register machine layer is a relatively close abstraction of risc hardware, but without the
quirks.

The Risc machine has registers, indexed addressing, operators, branches and everything
needed for the next layer. It does not try to abstract every possible machine feature
(like llvm), but rather "objectifies" the general risc view to provide what is needed for
the Mom layer, the next layer up.

The machine has it's own (abstract) instruction set, and the mapping to arm is quite
straightforward. Since the instruction set is implemented as derived classes, additional
instructions may be defined and used later, as long as translation is provided for them too.
In other words the instruction set is extensible (unlike cpu instruction sets).

Basic object oriented concepts are needed already at this level, to be able to generate a whole
self contained system. Ie what an object is, a class, a method etc. This minimal runtime is called
parfait, and the same objects will be used at runtime and compile time.

Since working with at this low machine level (essentially assembler) is not easy to follow for
everyone (me :-), an interpreter was created (by me:-). Later a graphical interface, a kind of
[visual debugger](https://github.com/ruby-x/rubyx-debugger) was added.
Visualizing the control flow and being able to see values updated immediately helped
tremendously in creating this layer. And the interpreter helps in testing, ie keeping it
working in the face of developer change.


### Binary , Arm and Elf

A physical machine will run binaries containing instructions that the cpu understands, in a
format the operating system understands (elf). Arm and elf subdirectories hold the code for
these layers.

Arm is a risc architecture, but anyone who knows it will attest, with it's own quirks.
For example any instruction may be executed conditionally in arm. Or there is no 32bit
register load instruction. It is possible to create very dense code using all the arm
special features, but this is not implemented yet.

All Arm instructions are (ie derive from) Register instruction and there is an ArmTranslator
that translates RegisterInstructions to ArmInstructions.
