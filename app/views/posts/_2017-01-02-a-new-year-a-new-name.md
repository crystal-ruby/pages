## RubyX compiles ruby to binary

The previous name was from a time in ancient history, three years ago, in internet time over
a decade (X years!). From when i thought i was going to build
a virtual machine. It has been clear for a while that what i am really doing is building a
compiler. A new thing needs a new name and finally inspiration struck in the form of RubyX.

It's a bit of a shame that both domain and github were taken, but the - versions work well too.
Renaming of the organization, repositories and changing of domain is now complete. I did not
rewrite history, so all old posts still refer to salama.

What i like about the new name most, is the closeness to ruby, this is after all an implementation
of ruby. Also the unclarity of what the X is is nice, is it as in X-files, the unknown of the
maths variable or ala mac, the 10 for a version number? Or the hope of achieving 10 times
performance as a play on the 3 times performance of ruby 3. It's a mystery, but it is a ruby
mystery and that is the main thing.


### 2. Type system

About the work that has been done, the type system rewrite is probably the biggest.

Types are now immutable throughout the system, and the space keeps a list of all unique types.
Adding, removing, changing type all goes through a hashing process and leads to a unique
instance, that may have to be created.

### 3. TypedMethod arguments and locals

Close on the heal of the type immutability was the change to types as argument and local variable
descriptors. A type instance is now used to describe the arguments (names and types) uniquely,
clearing up previous imprecision.

Argument and locals type, along with the name of the method describe a method uniquely. Obviously
the types may not be changed. Methods with different argument types are thus different methods, a
fact that still has to be coded into the ruby compiler.

### 4. Arguments and calling convention

The Message used to carry the arguments, while locals were a separate frame object. An imbalance
if one thinks about closures, as both have to be decoupled from their activation.

Now both arguments and locals are represented as NamedList's, which are basically just objects.
The type is transferred from the method to the NamedList instance at call time, so it is available
at run-time. This makes the whole calling convention easier to understand.

### 5. Parfait in ruby

Parfait is more normal ruby now, specifically we are using instance variables in Parfait again,
just like in any ruby. When compiling we have to deal with the mapping to indexes, but that's what
we have types for, so no problem. The new version simplifies the boot process a little too.

Positioning has been removed from Parfait completely and pushed into the Assembler where it belongs.

### 6. SOML goodbye

All trances of the soml language have been eradicated. All that is left is an intermediate typed
tree  representation. But the MethodCompiler still generates binary so that's good.
Class and method generation capabilities have been removed from that compiler and now live
one floor up, at the ruby level.  

### 7. Ruby Compiler

Finally work on the ruby compiler has started and after all that ground work is actually quite easy.
Class statements create classes already. Method definitions extract their argument and local
variable names, and create their representation as RubyMethod. More to come.

All in all almost all of the previous posts todos are done. Next up is the fanning of RubyMethods
into TypedMethods by instantiating type variations. When compilation of those works, i just need
to implement the cross function jumps and voila.

Certainly an interesting year ahead.
