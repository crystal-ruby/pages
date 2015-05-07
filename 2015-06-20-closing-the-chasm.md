---
layout: site
author: Torsten
---

As noted in previous posts, differentiating between compile- and run-time is one of the more
difficult things in doing the vm. That is because the computing that needs to happen is so similar,
in other words almost all of the vm - level is available at run-time too.

But off course we try to do as much as possible at compile-time.

One hears or reads that exactly this is a topic causing (also) other vms problems.
Specifically how one assures that what is compiled at compile-time and and run-time are
identical or at least compatible.

## Inlining

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
translating slots from the inner, inlined function to the outer one. Possibly creating new frame
entries.

## Inlining what

But lets take a step back from the mechanics and look at what it is we need to inline. Above
example seems to suggest we inline code. Code, as in text, is off course impossible to inline.
That's because we have no information about it and so the argument passing and returning can't
possibly work. Quite apart from the tricky possibility of shadow variables, ie the inlined code
assigning to variables of the outside function.

Ok, so then we just take our parsed code, the abstract syntax tree. There we have all the
information we need to do the magic, at least it looks like that.
But, we may not have the ast!

The idea is to be able to make the step to a language independent system. Hence the sof (salama
  object file), even it has no reader yet. The idea being that we store object files of any
  language in sof and the vm would read those.

To do that we need to inline at the vm instruction level. Which in turn means that we will need
to retain enough information at that level to be able to do that. What that entails in detail
is unclear at the moment, but it gives a good direction.

## A rough plan

To recap the function calling at the instruction level. Btw it should be clear that we can
not inline method sends, as we don't know which function is being called. But off course the
actual send method may be inlined and that is in fact part of the aim.

To call a function, a NewMessage is created, loaded with args and stuff, then the FunctionCall is
issued. Upon entering a new frame may be created for local and temporary variables and at the
end the function returns. When it returns the return value will be in the Return slot and the
calling method will grab it if interested and swap the Message back to what it was before the call.

From that (and at that level) it becomes clearer what needs to be done, and it starts with the
the caller, off course. In the caller there needs to be a way to make the decision whether to
inline or not. For the run-time stuff we need a list for "always inline", later a complexity
analysis, later a run-time analysis. When the decision goes to inline, the message setup will
be skipped. Instead a mapping needs to be created from the called functions argument names to
the newly created (unique) local variables.
Then, going through the instructions, references to arguments must be exchanged with references
to the new variables. A similar process needs to replace reference to local variables in the
called method to local variables in the calling method. Similarly the return and self slots need
to be mapped.

After the final instruction of the called method, the reassigned return must be moved to the real
return  and the calling function may commence. And while this may sound a lot, one must remember
that the instruction set of the machine is quite small, and further refinement
(abstracting base classes for example) can be done to make the work easier.
