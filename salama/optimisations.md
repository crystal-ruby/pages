---
layout: salama
title: Optimisation ideas
---

I won't manage to implement all of these idea in the beginning, so i just jot them down. 

### Avoid dynamic lookup

This off course is a broad topic, which may be seen under the topic of caching. Slightly wrongly though in my view, as avoiding them is really the aim. Especially for variables.

#### I - Instance Variables

Ruby has dynamic instance variables, meaning you can add a new one at any time. This is as it should be.

But this can easily lead to a dictionary/hash type of implementation. As variable "lookup" is probably *the* most
common thing an OO system does, that leads to bad performance (unneccessarily). 

So instead we keep variables layed out c++ style, continous, array style, at the address of the object. Then we have 
to manage that in a dynamic manner. This (as i mentioned [here](memory.html)) is done by the indirection of the Type. A Type is 
a dynamic structure mapping names to indexes (actually implemented as an array too, but the api is hash-like).

When a new variable is added, we create a *new* Type and change the Type of the object. We can do this as the Type will
determine the Class of the object, which stays the same. The memory page mentions how this works with constant sized objects.

So, Problem one fixed: instance variable access at O(1)

#### II - Method lookup

Off course that helps with Method access. All Methods are at the end variables on some (class) object. But as we can't very well have the same (continuous) index for a given method name on all classes, it has to be looked up. Or does it?

Well, yes it does, but maybe not more than once: We can conceivably store the result, except off course not in a dynamic 
structure as that would defeat the purpose.

In fact there could be several caching strategies, possibly for different use cases, possibly determined by actual run-time
measurements, but for now I just destribe a simeple one using Data-Blocks, Plocks.

So at a call-site, we know the name of the function we want to call, and the object we want to call it on, and so have to 
find the actual function object, and by that the actual call address. In abstract terms we want to create a switch with 
3 cases and a default.

So the code is something like, if first cache hit, call first cache , .. times three and if not do the dynamic lookup. 
The Plock can store those cache hits inside the code. So then we "just" need to get the cache loaded.

Initializing the cached values is by normal lazy initialization. Ie we check for nil and if so we do the dynamic lookup, and store the result. 

Remember, we cache Type against function address. Since Types never change, we're done. We could (as hinted above) 
do things with counters or robins, but that is for later.

Alas: While Types are constant, darn the ruby, method implementations can actually change! And while it is tempting to 
just create a new Type for that too, that would mean going through existing objects and changing the Type, nischt gut.
So we need change notifications, so when we cache, we must register a change listener and update the generated function,
or at least nullify it.

### Inlining

Ok, this may not need too much explanation. Just work. It may be intersting to experiment how much this saves, and how much 
inlining is useful. I could imagine at some point it's the register shuffling that determines the effort, not the 
actual call.

Again the key is the update notifications when some of the inlined functions have changed. 

And it is important to code the functions so that they have a single exit point, otherwise it gets messy. Up to now this 
was quite simple, but then blocks and exceptions are undone.

### Register negotiation

This is a little less baked, but it comes from the same idea as inlining. As calling functions is a lot of register
 shuffling, we could try to avoid some of that.

More precisely, usually calling conventions have registers in which arguments are passed. And to call an "unknown", ie any function, some kind of convention is neccessary.

But on "cached" functions, where the function is know, it is possible to do something else. And since we have the source 
(ast) of the function around, we can do things previouly imposible.

One such thing may be to recompile the function to acccept arguments exactly where they are in the calling function. Well, now that it's written down. it does sound a lot like inlining, except without the inlining:-)

An expansion if this idea would be to have a Negotiator on every function call. Meaning that the calling function would not 
do any shuffling, but instead call a Negotiator, and the Negotiator does the shuffling and calling of the function.
This only really makes sense if the register shuffling information is encoded in the Negotiator object (and does not have
to be passed).

Negotiators could do some counting and do the recompiling when it seems worth it. The Negotiator would remove itself from 
the chain and connect called and new receiver directly. How much is in this i couldn't say though.
 