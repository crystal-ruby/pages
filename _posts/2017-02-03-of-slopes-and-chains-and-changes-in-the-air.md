---
layout: news
author: Torsten
---

As i said in the last post, a step back and forward, possibly two, was taken and understanding
grows again. Especially when i think that some way is the way, it always changes and i turn out
to be at least partially wrong. The way of life, of imperfect intelligence, to strive for that
perfection that is forever out of reach. Here's the next installment.

## Slopes and Ramps

When thinking about method caching and how to implement it i came across this thing that i will
call a Slope for now. The Slope of a function that is. At least that's where the thought started.

The Slope of a function is a piece of code that has two main properties:

- it is straight, up to the end. i mean it has no branches from the outside.
  It may have internally but that does not affect anything.
- it ends in a branch that returns (a call), but this is not part of the Slope

Those *two* properties would better be called a Ramp. The Ramp the function goes along before it
jumps of to the next function.

The **Slope** is the part before the jump. So a Ramp is a Slope and a Jump.

Code in the Slope, it struck me, has the unique possibility of doing a jump, with out worrying about
returning. After all, it knows there is a call coming. After contemplating this a little i
found the flaw, which one understands when thinking about where the function returns to. So Slope
can jump away without caring if (and only if) the return address is set to after that jump (and the
address is actually set by the code before the jump).

Remembering that we set the return address in the caller (not as in c the callee) we can arrange
for that. And so we can write Slope code that just keeps going. Because once the return address
is set up, the code can just keep jumping forward. The only thing is that the call must come.

In more concrete terms: Method caching can be a series of checks and jumps. If the check is ok
we call, otherwise jump on. And even the last fail (the switches default case) can be a jump
to what we would otherwise call a method. A method that determines the real jump target from
the type (of self, in the message) and calls it. Except it's not a method because it never
returns, which is symmetrically to us not calling it.

So this kind of "method" which is not really a method, but still a fair bit of logic, i'll call
a Slope.

## Links and Chains

A Slope, the story continues, is really just a specific case of something else. If we take away
the expectation that a call is coming, we are left with a sequence of code with jumps to more
code. This could be called a Chain, and each part of the Chain would be a Link.

To define that: a **Link** is sequence of code that ends in a jump. It has no other jumps, just
the one at the end. And the jump at the end jumps to another Link.

The Code i am talking about here is risc level code, one could say assembler instructions.

The concept though is very familiar: at a higher level the Link would be a Statement and a
Chain a sequence of Statements. We're missing the branch abstraction yet, but otherwise this is
a lower level description of code in a similar way as the typed level Code and Statements are
a description of higher level code.

## Typed level is wrong

The level that is nowadays called Typed, and used to be soml, is basically made up of language
constructs. It does not allow for manipulation of the risc level. As the ruby level is translated
to the typed level, which in turn is translated to the risc level, the ruby compiler has no
way of manipulating the risc level. This is as it should be.

The problem is just, that the constructs that are currently at the typed level, do not allow
to express the results needed at the risc level.

Through the history of the development the levels have become mixed up. It is relatively clear at
the ruby level what kind of construct is needed at the risc level. This is what has to drive the
constructs at the typed level. We need access to these kinds of Slope or Link ideas at the ruby
level.

Another way of looking at the typed level inadequacies is the size of the codes generated. Some of
the expressions (or statements) resolve to 2 or 3 risc instructions. Others, like the call, are
15. This is an indication that part of the level is wrong. A good way to architect the layers
would result in an *even* expansion of the amount of code at every level.

## Too little testing

The ruby compiler should really drive the development more. The syntax and behavior of ruby are
quite clear, and i feel the risc layer is quite a solid target. So before removing too much or
rewriting too much i shall just add more (and more) functionality to the typed layer.

At the same time some of the concepts (like a method call) will probably not find any use, but
as long as they don't harm, i shall leave them lying around.
