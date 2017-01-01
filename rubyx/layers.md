---
layout: rubyx
title: RubyX architectural layers
---

## Main Layers

To implement an object system to execute object oriented languages takes a large system.
The parts or abstraction layers are detailed below.

It is important to understand the approach first though, as it differs from the normal
interpretation. The idea is to **compile** ruby. It may be easiest to compare to a static
object oriented language like c++. When c++ was created c++ code was translated into c, which
then gets translated into assembler, which gets translated to binary code, which is linked
and executed. Compiling to binaries is what gives these languages speed, and is the reason
to compile ruby.

In a similar way to the c++ example, we need level between ruby and assembler, as it is too
big a mental step from ruby to assembler. Off course course one could try to compile to c, but
since c is not object oriented that would mean dealing with all off c's non oo heritage, like
linking model, memory model, calling convention etc.

Top down the layers are:

- **Melon** , compiling ruby code into typed layer and includes bootstrapping code

- **Typed intermediate layer:** Statically typed object oriented with object oriented
call semantics.

- **Risc register machine abstraction** provides a level of machine abstraction, but
              as the name says, quite a simple one.

- **Binary and cpu specific assembler**  This includes arm assembly and elf support
          to produce a binary that can then read in ruby programs

### Melon

To compile and run ruby, we need to parse and compile ruby code. While parsing ruby is quite
a difficult task, it has already been implemented in pure ruby
[here](https://github.com/whitequark/parser). The output of the parser is again
an ast, which needs to be compiled to the typed layer.

The dynamic aspects of ruby are actually reltively easy to handle, once the whole system is
in place, because the whole system is written in ruby without external dependencies.
Since (when finished) it can compile ruby, it can do so to produce a binary. This binary can
then contain the whole of the system, and so the resulting binary will be able to produce
binary code when it runs. With small changes to the linking process (easy in ruby!) it can
then extend itself.

The type aspect is more tricky: Ruby is not typed and but the typed layer is after all. And
if everything were objects (as we like to pretend in ruby) we could just do a lot of
dynamic checking, possibly later introduce some caching. But everything is not an object,
minimally integers are not, but maybe also floats and other values.
The distinction between what is an integer and what an object has sprouted an elaborate
type system, which is (by necessity) present in the typed layer.



### Typed intermediate layer

The Typed intermediate layer is more fully described [here](/typed/typed.html)

In broad strokes it consists off:

- **MethodCompiler:**  compiles the ast into a sequence of Register instructions.
                        and runtime objects (classes, methods etc)
- **Parfait:** Is the runtime, ie the minimal set of objects needed to
                  create a binary with the required information to be dynamic
- **Builtin:**  A very small set of primitives that are impossible to express in ruby

The idea is to have different methods for different types, but implementing the same ruby
logic. In contrast to the usual 1-1 relationship between a ruby method and it's binary
definition, there is a 1-n.

The typed layer defines the Type class and BasicTypes and also lets us return to different
places from a function. By using this, we can
compile a single ruby method into several typed functions. Each such function is typed, ie all
arguments and variables are of known type. According to these types we can call functions according
to their signatures. Also we can autognerate error methods for unhandled types, and predict
that only a fraction of the possible combinations will actually be needed.


Just to summarize a few of typed layer features that are maybe unusual:

- **Message based calling:** Calling is completely object oriented (not stack based)
                              and uses Message and Frame objects.
- **Return addresses:**  A method call may return to several addresses, according
                          to type, and in case of exception
- **Cross method jumps** When a type switch is detected, a method may jump into the middle
                            of another method.


### Register Machine

The Register machine layer is a relatively close abstraction of risc hardware, but without the
quirks.

The register machine has registers, indexed addressing, operators, branches and everything
needed for the next layer. It doesn't not try to abstract every possible machine feature
(like llvm), but rather "objectifies" the risc view to provide what is needed for the typed
layer, the next layer up.

The machine has it's own (abstract) instruction set, and the mapping to arm is quite
straightforward. Since the instruction set is implemented as derived classes, additional
instructions may be defined and used later, as long as translation is provided for them too.
In other words the instruction set is extensible (unlike cpu instruction sets).

Basic object oriented concepts are needed already at this level, to be able to generate a whole
self contained system. Ie what an object is, a class, a method etc. This minimal runtime is called
parfait, and the same objects will be used at runtime and compile time.

Since working with at this low machine level (essentially assembler) is not easy to follow for
everyone, an interpreter was created. Later a graphical interface, a kind of
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
