---
layout: news
author: Torsten
---

Parsing is a difficult, the theory incomprehensible and older tools cryptic. At least for me.

And then i heard recursive is easy and used by even llvm. Formalised as peg parsing libraries exists, and in ruby
they have dsl's and are suddenly quite understandable. 

Off the candidates i had first very positive experiences with treetop. Upon continuing i found the code 
generation aspect not just clumbsy (after all you can define methods in ruby), but also to interfere unneccessarily
with code control. On top of that conversion into an AST was not easy.

After looking around i found Parslet, which pretty much removes all those issues. Namely

- It does not generate code, it generates methods. And has a nice dsl. 
- It transforms to ruby basic types and has the notion on a transormation. 
        So an easy and clean way to create an AST
- One can use ruby modules to partition a larger parser
- Minimal dependencies (one file).
- Active use and development.

So i was sold, and i got up to speed quite quickly. But i also found out how fiddly such a parser is in regards
to ordering and whitespace.

I spent some time to make quite a solid test framework, testing the differnet rules seperately and also the 
stages seperately, so things would not break accidentally when growing.

After about another 2 weeks i was able to parse functions, both calls and definitions, ifs and whiles and off course basic 
types of integers and strings. 

With the great operator support it was a breeze to create all 15 ish binary operators. Even Array and Hash constant 
definition was very quick. All in all surprisingly painless, thanks to Kasper! 

