Since i got the ideas of Slots and the associated instruction Set, i have been wondering how that
fits in with the code generation.

I moved the patched AST compiler methods to a Compiler, ok. But still what do all those compile
methods return.

## Expression

In ruby, everything is an expression. To recap "Expressions have a value, while statements do not",
or statements represent actions while expressions represent values.

So in ruby everything represents a value, also statements, or functions. There is no such thing
as the return void in C. Even loops and ifs result in a value, for a loop the last computed value
and for an if the value of the branch taken.

Having had a vague grasp of this concept i tried to sort of haphazardly return the kind of value
that i though appropriate. Sometimes literals, sometimes slots. Sometimes "Return" , a slot
representing the return value of a function.

## Return slot

Today i realized that the Slot representing the return value is special.

It does not hold the value that is returned, but rather the other way around.

A function returns what is in the Return slot, at the time of return.

From there it is easy to see that it must be the Return that holds the last computed value.
A function can return at any time after all.

The last computed value is the Expression that is currently evaluated. So the compile, which
initiates the evaluation, returns the Return slot. Always. Easy, simple, nice!

## Example

Constants: say the expression

    true

would compile to a

    ConstantLoad(ReturnSlot , TrueConstant)

While

    2 + 4

would compile to

    ConstantLoad(ReturnSlot , IntegerConstant(2))
    Set(ReturnSlot , OtherSlot)
    ConstantLoad(ReturnSlot , IntegerConstant(4))
    Set(ReturnSlot , EvenOtherSlot)
    MethodCall() # unspecified details here


## Optimisations

But but but i hear that is so totally inefficient. All the time we move data around, to and from
that one Return slot, just so that the return is simple. Yes but no.

It is very easy to optimize the trivial extra away. Many times the expression moves a value to Return
just to move it away in the next Instruction. A sequence like in above example

    ConstantLoad(ReturnSlot , IntegerConstant(2))
    Set(ReturnSlot , OtherSlot)

can easily be optimized into

    ConstantLoad(OtherSlot , IntegerConstant(2))

tbc
