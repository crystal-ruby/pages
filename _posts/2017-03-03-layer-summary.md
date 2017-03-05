---
layout: news
author: Torsten
---

Going on holiday without a computer was great. Forcing me to recap and write things down on paper.

## Layers

One of the main results was that the current layers are a bit mixed up and that will have to be
fixed. But first, some of the properties in which i think of the different layers.

### Layer properties

**Structure of the representation** is one of the main distinction of the layers. We know the parser gives us a **tree** and that the produced binary is a **blob**, but what in between. As options we would still have graphs and lists.

A closely related property of the representation is whether it is **abstract or concrete**.
An abstract representation is represented as a single class in ruby and it's properties are
accessible through an abstract interface, like a hash. A concrete representation would use
a class per type, have properties available as ruby attributes and thus allow functions on the
class.

If we think of the layer as a language, what **Language level** would it be, assembler, c, oo.
Does it have **control structures**, or **jumps**.

### Ruby Layer

The top ruby layer is a given, since it is provided by the external gem *parser*.
Parser outputs an abstract syntax tree (AST), so it is a *tree*. Also it is abstract, thus
represented by a single ruby class, which carries a type as an attribute.

What might sound self-evident that this layer is very close to ruby, this means that inherits
all of ruby's quirks, and all the redundancy that makes ruby a nice language. By quirks i mean
things like the integer 0 being true in an if statement. A good example of redundancy is the
existence of if and until, or the ability to add if after the statement.

### Virtual Language

The next layer down, and the first to be defined in ruby-x, is the virtual language layer.
By language i mean object oriented language, and by virtual an non existent minimal version of an
object oriented language. This is like ruby, but without the quirks or redundancy. This is
meant to be compatible with other oo languages, meaning that it should be possible to transform
a python or smalltalk program into this layer.

The layer is represented as a concrete tree and derived from the ast by removing:
- unless, the ternary operator and post conditionals
- splats and multi-assignment
- implicit block passing
- case statement
- global variables

It should be relatively obvious how these can be replaced by existing constructs (details in code)

### Virtual object Machine

The next down represents what we think of as a machine, more than a language, and an object
oriented at that.

A differentiating factor is that a machine has no control structures like a language. Only jumps.
The logical structure is more a stream or array. Something closer to the memory that
i will map to in lower layers. We still use a tree representation for this level, but with the
interpretation that neighboring children get implicitly jumped to.

The machine deals in objects, not in memory as a von Neumann machine would. The machine has
instructions to move data from one object to another. There are no registers, just objects.
Also basic arithmetic and testing is covered by the instruction set.

### Risc layer

This layer is a minimal abstraction of an arm processor. Ie there are eight registers, instructions
to and from memory and between registers. Basic integer operations work on registers. So does
testing, and off course there are jumps. While the layer deals in random access memory, it is
aware and uses the object machines objects.

The layer is minimal in the sense that it defines only instructions needed to implement ruby.
Instructions are defined in a concrete manner, ie one class per Instruction, which make the
set of Instructions extensible by other gems.

The structure is a linked list which is manly interested in three types of Instructions. Namely
Jumps, jump targets (Labels), and all other. All the other Instructions a linear in the von Neumann
sense, that the next instruction will be executed implicitly.

### Arm and elf Layer

The mapping of the risc layer to the arm layer is very straightforward, basically one to one with
the exception of constant loading (which is quirky on the arm 32 bit due to historical reasons).
Arm instructions (being instructions of a real cpu), have the ability to assemble themselves into
binary, which apart from the loading are 4 bytes.

The structure of the Arm instruction is the same as the risc layer, a linked list.

There is also code to assemble the objects, and with the instruction stream make a binary elf
executable. While elf support is minimal, the executable does execute on rasperry pi or qemu.
