---
layout: news
author: Torsten
---

The register machine abstraction has been somewhat thin, and it is time to change that

### Current affairs

When i started, i started from the assembler side, getting arm binaries working and off course learning the arm cpu
instruction set in assembler memnonics.

Not having **any** experience at this level i felt that arm was pretty sensible. Much better than i expected. And
so i abtracted the basic instruction classes a little and had the arm instructions implement them pretty much one
to one.

Then i tried to implement any ruby logic in that abstraction and failed. Thus was born the virtual machine 
abstraction of having Message, Frame and Self objects. This in turn mapped nicely to registers with indexed
addressing.

### Addressing

I just have to sidestep here a little about addressing: the basic problem is off course that we have no idea at
compile-time at what address the executable will end up.

The problem first emerged with calling functions. Mostly because that was the only objects i had, and so i was
very happy to find out about pc relative addressing, in which you jump or call relative to your current position 
(**p**rogram **c**ounter). Since the relation is not changed by relocation all is well.

Then came the first strings and the aproach can be extended: instead of grabbing some memory location, ie loading
and address and dereferencing, we calculate the address in relation to pc and then dereference. This is great and 
works fine.

But the smug smile is wiped off the face when one tries to store references. This came with the whole object
aproach, the bootspace holding references to **all** objects in the system. I even devised a plan to always store
relative addresses. Not relative to pc, but relative to the self that is storing. This i'm sure would have
worked fine too, but it does mean that the running program also has to store those relative addresses (or have 
different address types, shudder). That was a runtime burden i was not willing to accept.

So there are two choices as far as i see: use elf relocation, or relocate in init code. And yet again i find myself
biased to the home-growm aproach. Off course i see that this is partly because i don't want to learn the innards of
elf as something very complicated that does a simple thing. But also because it is so simple i am hoping it isn't
such a big deal. Most of the code for it, object iteration, type testing, layout decoding, will be useful and
neccessary later anyway.

### Concise instruction set

So that addressing aside was meant to further the point of a need for a good register instruction set (to write the
relocation in). And the code that i have been writing to implement the vm instructions clearly shows a need for
a better model at the register model.

On the other hand, the idea of Passes will make it very easy to have a completely sepeate register machine layer.
We just transfor the vm to that, and then later from that to arm (or later intel). So there are three things that i
am looking for with the new register machine instruction set:

- easy to understand the model (ie register machine, pc, ..), free of real machine quirks
- small set of instructions that is needed for our vm
- better names for instructions

Especially the last one: all the mvn and ldr is getting to me. It's so 50's, as if we didn't have the space to spell
out move or load. And even those are not good names, at least i am always wondering what is a move and what a load.
And as i explained above in the addressing, if i wanted to load an address of an object into a register with relative
addressing, i would actually have to do an add. But when reading an add instruction it is not an intuative
conclusion that a load is meant. And since this is a fresh effort i would rather change these things now and make
it easier for others to learn sensible stuff than me get used to cryptics only to have everyone after me do the same.

So i will have instructions like RegisterMove, ConstantLoad, Branch, which will translate to mov, ldr and b in arm. I still like to keep the arm level with the traditional names, so people who actually know arm feel right at home.
But the extra register layer will make it easier for everyone who has not programmed assembler (and me!), 
which i am guessing is quite a lot in the *ruby* community.

In implementation terms it is a relatively small step from the vm layer to the register layer. And an even smaller 
one to the arm layer. But small steps are good, easy to take, easy to understand, no stumbling.

### Extra Benefits

As i am doing this for my own sanity, any additional benefits are really extra, for free as it were. And those extra
benefits clearly exist.

##### Clean interface for cpu specific implementation

That really says it all. That interface was a bit messy, as the RegisterMachine was used in Vm code, but was actually
an Arm implementation. So no seperation. Also as mentioned the instruction set was arm heavy, with the quirks 
even arm has.

So in the future any specific cpu implementation can be quite self sufficient. The classes it uses don't need to 
derive from anything specific and need only implement the very small code interface (position/length/assemble).
And to hook in, all that is needed is to provide a translation from RegisterMachine instructions, which can be
done very nicely by providing a Pass for every instruction. So that layer of code is quite seperate from the actual
assembler, so it should be easy to reuse existing code (like wilson or metasm).

##### Reusable optimisations

Clearly the better seperation allows for better optimisations. Concretely Passes can be written to optimize the
RegiterMachine's workings. For example register use, constant extraction from loops, or folding of double
moves (when a value is moved from reg1 to reg2, and then from reg2 to reg3, and reg2 never being used).

Such optimisations are very general and should then be reusable for specific cpu implementations. They are still
usefull at RegiterMachine level mind, as the code is "cleaner" there and it is easier to detect fluff. But the same
code may be run after a cpu translation, removing any "fluff" the translation introduced. Thus the translation
process may be kept simpler too, as that doesn't need to check for possible optimisations at the same time
as translating. Everyone wins :-)
