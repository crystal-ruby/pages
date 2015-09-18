---
layout: news
author: Torsten
---

It is the **one** thing i said i wasn't going to do: Write a language.
There are too many languages out there already, and just because i want to write a vm,
doesn't mean i want to add to the language jungle.
**But** ...

## The gap

As it happens in life, which is why they say never to say never, it happens just like it
i didn't want. It turns out the semantic gap of what i have is too large.

There is the **register level** , which is approximately assembler, and there is the **vm level**
which is more or less the ruby level. So my head hurts from trying to implement ruby in assembler,
no wonder.

Having run into this wall, which btw is the same wall that crystal ran into, one can see the sense
in what others have done more clearly: Why rubinus uses c++ underneath. Why crystal does not
implement ruby, but a statically typed language. And ultimately why there is no ruby compiler.
The gap is just too large to bridge.

## The need for a language

As I have the architecture of passes, i was hoping to get by with just another layer in the
architecture. A tried an tested approach after all. And while i won't say that that isn't a
possibility, i just don't see it. I think it may be one of those where hindsight will be perfect.

I can see as far as this: If i implement a language, that will mean a parser, ast and compiler.
The target will be my register layer. So a reasonable step up is a sort of object c, that has
basic integer maths and object access. I'll detail that more below, but the point is, if i have
that, i can start writing a vm implementation in that language.

Off course the vm implementation involves a parser, an ast and a compiler, unless we go to the free
compilers (see below). And so implementing the vm in a new language is in essence swapping nodes of
the higher level tree with nodes of the lower level (c-ish) one. Ie parsing should not strictly
speaking be necessary. This node swapping is after all what the pass architecture was designed
to do. But, as i said, i just can't see that happening (yet?).

### Trees vs. Blocks

Speaking of the Pass architecture: I flopped. Well, maybe not so much with the actual Passes, but
with the Method representation. Blocks holding Instructions, and being in essence a list.
Misinformed copying from llvm, misinformed by the final outcome. Off course the final binary
has a linear address space, but that is where the linearity ends. The natural structure of code
is a tree, not a list, as demonstrated by the parse *tree*. Flattening it just creates navigational
problems. Also as a metal model it is easier, as it is easy to imagine swapping out subtrees,
expanding or collapsing nodes etc.

## Bosl - Basic Object System Language

### Typed

Quite a while before cristalizing into the idea of a new language, i already saw the need for a type
system. Off course, and this dates back to the first memory layouts. But i mean the need for a
*strong typing* system, or maybe it's even clearer to call it compile time typing. The type that c
and c++ have. It is essential (mentally, this is off course all for the programmer, not the computer)
to be able to thing in a static type system, and then extend that and make it dynamic.
Or possibly use it in a dynamic way.

This is a good example of this too big gap, where one just steps on quicksand if everything is
all the time dynamic.

The way i had the implementation figured was to have different versions of the same function. In
each function we would have compile time types, everything known. I'll probably still do that,
just written in bosl.

### Object c

The language needs to be object based, off course. Just because it's typed and not dynamic
and closer to assembler, doesn't mean we need to give up objects. In fact we mustn't. Bosl (working
  name) should be a little bit in like c++, ie compile time known variable arrangement and types,
  objects. But no classes (or inheritance), more like structs, with full access to everything.
So a struct.variable syntax would mean grab that variable at that address, no functions, no possible
override, just get it. This is actually already implemented as i needed it for the slot access.  

So objects without encapsulation or classes. A lower level object orientation.

### Citrus (or treetop) and whitequark

This new approach (and more experience) shed a new light on ruby parsing. The previous idea was to
start small, write the necessary stuff in the parsable subset and with time expand that set.

Alas . . ruby is a beast to parse, and because of the **semantic gap** writing the system,
even in a subset, is not viable. And it turns out the brave warriors of the ruby community have
already produced a pure, production ready, [ruby parser](https://github.com/whitequark/parser).
That can obviously read itself and anything else, so the start small approach is doubly out.

Also, when writing the debugger, i found that parslet is not opal compatible and that doesn't seem
to be changing. So, casting the net, i found Citrus which is small and clean without *any* runtime
dependency (a great feat). Citrus has a grammar, and i find at least it looks nicer than the ruby
grammar code. So for bosl it will probably be that and as small a syntax as i can get away with.

### Interoperability

The system code needs to be callable from the higher level, and possibly the other way around.
This probably means the same or compatible calling mechanism and data model. The data model is
quite simple as the at the system level all is just machine words, but in object sized
packets. As for the calling it will probably mean that the same message object needs to be used
and what is now called calling at the machine level is supported. Sending off course won't be.

### Still missing a piece

How the level below calling can be represented is still open. It is clear though that it does need
to be present, as otherwise any kind of concurrency is impossible to achieve. The question ties
in with the still open question of [Quajects](http://valerieaurora.org/synthesis/SynthesisOS/ch4.html).
Meaning, what is the yin in the yin and yang of object oriented programming. The normal yang way sees
the code as active and the data as passive. By normal i mean oo implementations in which blocks and
closures just fall from the sky and have no internal structure. There is obviously a piece of
the puzzle missing that Alexia was onto.

### Start small

The first next step is to wrap the functionality i have in the Passes as a language.

Then to expand that language, by writing increasingly more complex programs in it.

And then to re-attack ruby using the whitequark parser, that probably means jumping on the
mspec train.

All in all, no biggie :-)

## Compilers are not free

Oh and i re-read and re-watched Toms [compilers for free](http://codon.com/compilers-for-free) talk,
which did make quite an impression on me the first time. But when i really thought about actually
going down that road (who does't enjoy a free beer), i got into the small print.

The second biggest of which is that writing a partial evaluator is just about as complicated
as writing a compiler.

But the biggest problem is that the (free) compiler you could get, has the implementation language
of the evaluator, as it's **output**. You need a compiler to start with, in other words.
Also the interpreter would have to be written in the same compilable language.
So writing a ruby compiler by writing a ruby interpreter would mean
writing the interpreter in c, and (worse) writing the partial evaluator *for* c, not for ruby.

Ok, maybe it is not quite as bad as that makes it sound. As i do have the register layer ready
and will be writing a c-ish language, it may even be possible to write an interpreter **in bosl**,
and then it would be ok to write an evaluator **for bosl** too.

I will nevertheless go the straighter route for now, ie write a compiler, and maybe return to the
promised freebie later. It does feel like a lot of what the partial evaluator is, would be called
compiler optimization in another lingo. So may be road will lead there naturally.
