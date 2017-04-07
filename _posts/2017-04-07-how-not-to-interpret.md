---
layout: news
author: Torsten
---

Method caching can be done at language level. Wow. But first some boring news:

## Vool is ready, Mom is coming

The **V**irtual **O**bject **O**riented **L**anguage level, as envisioned in the previous post,
is done. Vool is meant to be a language agnostic layer, and is typed, unlike the ast that
the ruby parser outputs. This  will allow to write more oo code, by putting code into the
statement classes, rather than using the visitor pattern. I tend to agree with CodeClimate on
the fact that the visitor pattern produces bad code.

Vool will not reflect some of ruby's more advanced features, like splats or implicit blocks,
and hopes to make the conditional logic more consistent.

The **M**inimal **O**bject **M**achine will be the next layer. It will sit between Vool and Risc
as an object version of the Risc machine. This is mainly to make it more understandable, as i
noticed that part of the Risc, especially calling, is getting quite complex. But more on that next..

## Inline Method caching

In ruby almost all work is actually done by method calling and an interpreter spends much of it's
time looking up methods to call. The obvious thing to do is to cache the result, and this has
been the plan for a while.

Off course for caching to work, one needs a cache key and invalidation strategy, both of which
are handled by the static types, which i'll review below.

### Small cache

Aaron Patterson has done [research into method caching](https://www.youtube.com/watch?v=b77V0rkr5rk)
in mri and found that most call sites (>99%) only need one cache entry.

This means a single small object can carry the information needed, probably type, function address
and counter, times two.

In rubyx this can literally be an object that we attach to the CallSite, either prefill if possible
or leave to be used at runtime.

### Method lookup is a static function

The other important idea here is that the actual lookup of a method is a know function. Known at
compile time that is.

Thus dynamic dispatch can be substituted by a cache lookup, and a static call. The result of the call
can/should update the cache and then we can start with the lookup again.

This makes it possible to remove dynamic dispatch from the code, actually at code level.
I had previously though of implementing the send at a lower level, but see now that it would
be quite possible to do it at the language level with an if and a call, possible another call
for the miss. That would drop the language down from dynamic (4th level) to static (3rd level).

I am still somewhat at odds whether to actually do this or leave it for the machine level (mom).

## Static Type review

To make the caching possible, the cache key - value association has to be constant.
Off course in oo systems the class of an object is constant and so we could just use that.
But in ruby you can change the class, add instance variables or add/remove/change methods,
and so the class as a key and the method as value is not correct over time.

In rubyx, an object has a type, and it's type can change. But a type can never change. A type refers
to the class that it represented at the time of creation. Conversely a class carries an instance
type, which is the type of new instances that get created. But when variables or methods are added
or removed from the class, a new type is created. Type instances never change. Method implementations
are attached to types, and once compiled, never changed either.

Thus using the object's type as cache key and the method as it's value will stay correct over time.
And the double bonus of this is that it takes care of both objects of different classes (as those will have different type for sure), but also objects of the same class, at different times, when
eg a method with the same name has been added. Those objects will have different type too, and
thus experience a cache miss and have their correct method found.

## Up next

More grunt-work. Now that Vool replaces the ast the ode from rubyx/passes has to be "ported" to use it. That means:
- class extraction and class object creation
- method extraction and creation
- type creation by ivar analysis
- frame creation by local variable analysis
