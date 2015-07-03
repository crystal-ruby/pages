---
layout: news
author: Torsten
---

After almost a year of rewrite: **Hello World** is back.

**Working executables again**

So much has changed in the last year it is almost impossible to recap.
Still a little summary:

### Register Machine

The whole layer of the [Register Machine](/2014/09/30/a-better-register-machine.html) as an
abstraction was not there. Impossible is was to see what was happening.

### Passes

In the beginning i was trying to *just do it*. Just compile the vm down to arm instructions.
But the human brain (or possibly just mine) is not made to think in terms of process.
I think much better in terms of Structure. So i made vm and register instructions and
[implemented Passes](/2014/07/05/layers-vs-passes.html) to go between them.

### The virtual machine design

Thinking about what objects makes up a virtual machine has brought me to a clear understanding
of the [objects needed](/2014/09/12/register-allocation-reviewed.html).
In fact things got even simpler as stated in that post, as i have
[stopped using the machine stack](/2014/06/27/an-exceptional-thought.html)
altogether and am using a linked list instead.
Recently is has occurred to me that that linked list
[doesn't even change](/06/20/the-static-call-chain.html), so it is very simple indeed.

### Smaller, though not small, changes

- The [Salma Object File](/2014/08/19/object-storage.html) format was created.
- The [Book](http://dancinglightning.gitbooks.io/the-object-machine/content/) was started
- I gave lightning talks at Frozen Rails 2014, Helsinki and Bath Ruby 2015
- I presented at Munich and Zurich user groups, lots to take home from all that

### Future

The mountain is still oh so high, but at last there is hope again. The second dip into arm
(gdb) debugging has made it very clear that a debugger is needed. Preferably visual, possibly 3d,
definitely browser based. So either Opal or even Volt.

Already more clarity in upcoming fields has arrived:

- inlining is high on the list, to code in higher language
- the difference between [statement and expression](/2015/05/20/expression-is-slot.html) helped
  to structure code.
- hopefully the debugger / interpreter will help to write better tests too.
