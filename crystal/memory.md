---
layout: crystal
title: Memory layout and management
---

Memory management must be one of the main horrors of computing. That's why garbage collected languages like ruby are so great. Even simple malloc implementations tend to be quite complicated. Unneccessay so, if one used object oriented principles of data hiding.

### Object and values

As has been mentioned, in a true OO system, object tagging is not really an option. Tagging being the technique of adding the lowest bit as marker to pointers and thus having to shift ints and loosing a bit. Mri does this for Integers but not other value types. We accept this and work with it and just say "off course" , but it's not modelled well.

Integers are not Objects like "normal" objects. They are Values, on par with ObjectReferences, and have the following distinctive differences:

- equality implies identity
- constant for whole lifetime
- pass by value semantics

If integers were normal objects, the first would mean they would be sindletons. The second means you can't change them, you can only change a variable to hold a different value. It also means you can't add instance variables to an integer, neither singleton_methods. And the third means that if you do change the variable, a passed value will not be changed. Also they are not garbage collected. If you noticed how weird that idea is (the gc), you can see how natural is that Value idea.

Instead of trying to make this difference go away (like MRI) I think it should be explicit and indeed be expanded to all Objects that have these properties. Words for examples (ruby calls them Symbols), are the same. A Table is a Table, and Toble is not. Floats (all numbers) and Times are the same.

### Object Layout

So if we're not tagging we must pass and keep the type information around seperately. For passing it has been mentioned that a seperate register is used.

For keeping track of the type data we need to make a descision of how many we support. The register for passing gives the upper limit of 4 bits, and this fits well with the idea of cache lines. So if we use cahce lines, for every 8 words, we take one for the type.

Traditionally the class of the object is stored in the object. But this forces the dynamic lookup that is a good part of the performance problem. Instead we store the Object's Layout. The Layout then stores the Class, but it is the layout that describes the memory layout of the object (and all objects with the same layout).

This is is in essence a level of indirection that gives us the space to have several Layouts for one class, and so we can eveolve the class without having to hange the Layout (we just create new ones for every change)

The memory layout of **every** object is type word, layout reference and "data".

That leaves the length open and we can use the 8th 4bits to store it. That gives a maximum of 16 Lines.

#### Continuations

But (i hear), ruby is dynamic, we must be able to add variables and methods to an object at any time. So the layout can't 
be fixed. Ok, we can change the Layout every time, but when any empty slots have been used up, what then. 

Then we use Continuations, so instead of adding a new variable to the end of the object, we use a new object and store 
in the original object. Thus extending the object.

Continuations are pretty normal objects and it is just up to the layout to manage the redirection.
Off course this may splatter objects a little, but in running application this does not really happen much. Most instance variables are added quite soon after startup, just as functions are usually parsed in the beginning.

The good side of continuation is also that we can be quite tight on initial allocation, and even minimal with continuations. Continuations can be completely changed out after all. 

### Pages and Spaces

Now we have the smallest units taken care of, we need to store them and allocate and manage larger chunks. This is much 
simpler and we can use a fixed size Page, as say 256 lines.

The highest order is a Space, which is just a list of Pages. Spaces manage Pages in a very simliar way that Pages manage Objects, ie ie as liked lists of free Objects/Pages. 

A Page, like a Space, is off course a normal object. The actual memory materialises out of nowhere, but then gets 
filled immediately with objects. So no empty memory is managed, just objects that can be repurposed.
