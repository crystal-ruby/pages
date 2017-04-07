---
layout: news
author: Torsten
---

I am not stuck. I know i'm not. Just because there is little visible progress doesn't mean i'm stuck. It may just feel like it though.

But like little cogwheels in the clock, i can hear the background process ticking away and sometimes there is a gong.

What i wasn't stuck with, is where to draw the layer for the vm.

### Layers

Software engineers like layers. Like the onion boy. You can draw boxes, make presentation and convince your boss.
They help us to reason about the software.

In this case the model was to go from ast layer to a vm layer. Via a compile method, that could just as well have been a
visitor.

That didn't work, too big  astep and so it was from ast, to vm, to neumann. But i couldn't decide
on the abstraction of the virtual machine layer. Specifically, when you have a send (and you have
soo many sends in ruby), do you:

- model it as a vm instruction (a bit like java)
- implement it in a couple instructions like resolve, a loop and call
- go to a version that is clearly translatable to neumann, say without the value type implementation

Obviously the third is where we need to get to, as the next step is the neumann layer and somewhow
we need to get there. In effect one could take those three and present them as layers, not
as alternatives like i have.

### Passes

And then the little cob went click, and the idea of passes resurfaced. LLvm has these passes on
the code tree, is probably where it surfaced from.

So we can have as high of a degree of abstraction as possible when going from ast to code.
And then have as many passes over that as we want / need.

Passes can be order dependent, and create more and more detail. To solve the above layer
conundrum, we just do a pass for each of those options.

The two main benefits that come from this are:

1 - At each point, ie after and during each pass we can analyse the data. Imagine for example
that we would have picked the second layer option, that means there would never have been a
representation where the sends would have been explicit. Thus any analysis of them would be impossible or need reverse engineering (eg call graph analysis, or class caching)

2 - Passes can be gems or come from other sources. The mechanism can be relatively oblivious to
specific passes. And they make the transformation explicit, ie easier to understand.
In the example of having picked the second layer level, one would have to patch the
implementation of that transformation to achieve a different result. With passes it would be
a matter of replacing a pass, thus explicitly stating "i want a non-standard send implementation"

Actually a third benefit is that it makes testing simpler. More modular. Just test the initial ast->code and then mostly the results of passes.
