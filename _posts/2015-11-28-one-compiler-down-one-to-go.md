---
layout: news
author: Torsten
---

Ok, that was surprising: I just wrote a language in two months. Parser, compiler, working binaries
and all.

Then i [documented it](/typed/typed.html) , detailed the [syntax](/typed/syntax.html) and even did
some [benchmarking](/typed/benchmarks.html). Speed is luckily roughly where i wanted it. Mostly
(only mostly?) slower than c, but only by about 50, very understandable percent. It is doing
things in a more roundabout, and easier to understand way, and lacking any optimisation. It means
you can do about a million fibonacci(20) in a second on a pi, and beat ruby at it by a about
a factor of 20.

So, the good news: it **it works**

Working means: calling works, if, while, assignment, class and method definition. The benchmarks
were hello world and fibonacci, both recursive and by looping.  

I even updated the [**whole book**](/book.html) to be up to date. Added a Soml section, updated
parfait, rewrote the register level . . .

### It all clicked into place

To be fair, i don't think anyone writes a language that isn't a toy in 2 months, and it was only
possible because  a lot of the stuff was there already.

- [Parfait](/typed/parfait.html) was pretty much there. Just consolidated it as it is all just adapter.
- The [Register abstraction](/typed/debugger.html) (bottom) was there.
- Using the ast library made things easier.
- A lot of the [parser](https://github.com/salama/salama-reader) could be reused.

And off course the second time around everything is easier (aka hindsight is perfect).

One of the better movie lines comes to mind,
([paraphrased](http://www.imdb.com/title/tt1341188/quotes)) "We are all just one small
adjustment away from making our code work". It was a step sideways in the head which brought a leap
forward in terms of direction. Not where i was going but where i wanted to go.

### Open issues

Clearly i had wobbled on the parfait front. Now it's clear it will have to be recoded in soml,
and then re-translated into ruby. But it was good to have it there in ruby all the time for the
concepts to solidify.

Typing is not completely done, and negative tests for types are non existant. Also exceptions and
the machinery for the returns.

I did a nice framework for testing the binaries on a remote machine, would be nice to have it
on travis. But my image is over 2Gb.

### And onto the next compiler

The ideas about how to compile ruby into soml have been percolating and are waiting to be put to
action. [The theory](http://book.salama-vm.org/object/dynamic_types.html) looks good,but one has
to see it to believe it.

The first steps are quite clear though. Get the [ruby parser](https://github.com/whitequark/parser)
integrated, get the compiler up, start with small tests. Work the types at the same time.

And let the adventure continue.
