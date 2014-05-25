Good Principles
---------------

Good principles, or rules of thumb, are not so easy to formulate. They come from experience and abstract it.
If they don't come from, or not enough, experience they easily become just abstract and who really can tell
 the difference (only one with more experience off course, and he/she does not need to read about principles). 
A conundrum.

- Microkernel
  Or "leave it out if you can", is definately something i go by. A variation of make it as simple as you can,
  but not more simple.
  
- Walk the straight line
  Or "No futureproof" means not to design before you code. Not to anticipate, only to do the job that
  needs doing. Better design should be extracted from working code.
  
- tdd extreme
  Having suffered from broken software (small feature add breaks whole software) so many times, the new tdd
  wind is not just nice, it is essential. Software size is measured in tests passed, not lines written. Any
  new feature is only accepted with enough tests, bugs fixed after a failed test is written.

- Layers represent an interface, not an implementation
  It is said that every problem in computing can be solved by adding anohter layer of indirection. And so 
  we have many layers, which, when done right, help us to understand the system. (Read, layers are for us,
  not the computer)
  But implementing each layer comes with added cost, often unneccessary. Layers can and should be collapsed
  in the implementation. Inlining, is a good example, a Jit another.
  
- Use names rightly
  or the principle of least surprise. Programming is so much naming, so if done right will lead to a 
  natural understanding, even of code not read. 
  Good names are Formatter or compile, but unfortunately not everything we have learnt is named well, like
  Array (should be ordered list), Hash (names implementation not function) or string (should be word, or bytebuffer).

- No sahara
  There has been much misunderstood talk about drying things up. Dry is good, but was never meant for code, but
  for information (configuration). Trying to dry code leads to overly small functions, calling chains that
  are difficult to understand and serve only a misundertood slogan.

