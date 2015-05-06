---
layout: site
author: Torsten
---

As noted in previous posts, differentiating between compile- and run-time is one of the more
difficult things in doing the vm. That is because the computing that needs to happen is so similar,
in other words almost all of the vm - level is available at run-time too.

But off course we try to do as much as posible at compile-time.

One hears or reads that exactly this is a topic causing (also) other vms problems.
Specifically how one assures that what is compiled at compile-time and and run-time are
identical or at least compatible.

The obvious answer seems to me to **use the same code**.In a way that "just" moves the question
around a bit, becuase then one would have to know how to do that. I'll go into that below,
but find that the concept is worth exploring first.

Let's take a simple example of accessing an instance variable. This is off course available at
run-time through the function *instance_variable_get* , which could go something like:

    def instance_variable_get name
      index = @layout.index name
      return nil unless index
      at_index(index)
    end

Let's assume the *builtin* at_index function and take the layout to be an array like structure.
As noted in previous posts, when this is compiled we get a Method with Blocks, and exactly one
Block will initiate the return. The previous post detailed how at that time the return value will
be in the ReturnSlot.

So then we get to the idea of how: We "just" need to take the blocks from the method and paste
them where the instance variable is accessed. Following code will pick the value from the ReturnSlot
as it would any other value and continue.

The only glitch in this plan is that the code will assume a new message and frame. But if we just
paste it it will use message/frame/self from the enclosing method. So that is where the work is:
translating slots from the inner, inlined fuction to the outer one. Possibly creating new frame
entries.

tbc
