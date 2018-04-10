Quite long ago i [had already determined](/2014/06/27/an-exceptional-thought.html) that return
addresses and exceptional return addresses should be explicitly stored in the message.

It was also clear that Message would have to be a linked list. Just managing that list at run-time
in Register Instructions (ie almost assembly) proved hard. Not that i was creating Message objects
but i did shuffle their links about. I linked and unlinked messages by setting their next/prev fields
at runtime.

## The List is static

Now i realized that touching the list structure in any way at runtime is not necessary.
The list is completely static, ie created at compile time and never changed.

To be more precise: I created the Messages at compile time and set them up as a forward linked list.
Each Item had *caller* field (a backlink) which i then filled at run-time. I was keeping the next
message to be used as a variable in the Space, and because that is basically global it was
relatively easy to update when making a call.
But i noticed when debugging that when i updated the message's next field, it was already set to
the value i was setting it to. And that made me stumble and think. Off course!

It is the data **in** the Messages that changes. But not the Message, nor the call chain.

As programmer one has the call graph in mind and as that is a graph, i was thinking that the
Message list changes. But no. When working on one message, it is always the same message one sends
next. Just as one always returns to the same one that called.

It is the addresses and Method arguments that change, not the message.

The best analogy i can think of is when calling a friend. Whatever you say, it is alwas the same
number you call.

Or in C terms, when using the stack (push/pop), it is not the stack memory that changes, only the
pointer to the top. A stack is an array, right, so the array stays the same,
even it's size stays the same. Only the used part of it changes.

## Simplifies call model

Obviously this simplifies the way one thinks about calls. Just stick the data into the pre-existing
Message objects and go.

When i first had the [return address as argument](/2014/06/27/an-exceptional-thought.html) idea,
i was thinking that in case of exception one would have to garbage collect Messages.
In the same way that i was thinking that they need to be dynamically managed.

Wrong again. The message chain (double linked list to be precise) stays. One just needs to clear
the data out from them, so that garbage does get collected. Anyway, it's all quite simple and that's
nice.

As an upshot from this new simplicity we get **speed**. As the method enter and exit codes are
3-4 (arm) instructions, we are on par with c. Oh and i forgot to mention Frames. Don't need to
generate those at run-time either. Every message gets a static Frame. Done. Up to the method
what to do with it. Ie don't use it or use it as array, or create an array to store more than
fits into the static frame.
