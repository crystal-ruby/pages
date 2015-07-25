---
layout: news
author: Torsten
---

It really is like [Bret Victor](http://worrydream.com/#!/InventingOnPrinciple) says in his video:
nowadays good programmers are the ones who play computer in their head well.

Why? Because you have to to program nowadays. And off course that's what i'm doing.

But when it got to debugging, it got a bit much. Using gdb for non C code, i mean it's bad enough
for c code.

## The debugger

The process of getting my "hello world" to work was quite hairy, what with debugging with gdb
and checking registers and stuff. Brr.

The "solution", my own debugger, possibly graphical, came quite quickly. But the effort seemed a
little big. It took a little, but then i started.

I fiddled a little with fancy 2 or even 3d representations but couldn't get things to work.
Also getting used to running ruby in the browser, with opal, took a while.

But now there is a [basic frame](https://github.com/salama/salama-debugger) up,
and i can see registers swishing around and ideas of what needs
to be visualized and partly even how, are gushing. Off course it's happening in html,
but that ok for now.

And the best thing: I found my first serious **bug** visually. Very satisfying.

I do so hope someone will pick this up and run with it. I'll put it on the site as soon as the first
program runs through.

## Interpreter

Off course to have a debugger i needed to start on an interpreter.
Now it wasn't just the technical challenge, but some resistance against interpreting, since the whole
idea of salama was to compile. But in the end it is a very different level that the interpreter
works at. I chose to put it at the register level (no the arm), so it would be useful for future
cpu's, and because the register to arm mapping is mainly about naming, not functionality. Ie it is
pretty much one to one.

But off course (he says after the fact), the interpreter solves a large part of the testing
issue. Because i wan't really happy with tests, and that was because i didn't have a good
idea how to test. Sure unit tests, fine. But to write all the little unit tests and hope the
total will result in what you want never struck me as a good plan.

Instead i tend to write system tests, and drop down to unit tests to find the bugs in system tests.
But i had no good system tests, other than running the executable. But **now i do**. Or rather
i will have once the Interpreter is finished. I can just run the Interpreter on a program and
see if it produced the right output. And by right output i really just mean stdout.

So two flies with one (oh i don't know how this goes, im'm not english), better test, and visual
feedback, both driving the process at double speed.

Now i "just" need a good way to visualize a static and running program.
