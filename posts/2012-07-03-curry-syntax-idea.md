---
title: Idea: Haskell syntax for partial application in any argument
description: Currying rocks, `flip` helps, but what about the other arguments?
keywords: blogging, programming, productivity, git, haskell, hakyll
tags: haskell, syntax
math: yes
---


Let `f` applied to `@` (and some other arguments) denote partial application of `f` that still needs the argument replaced by `@`.

~~~ {.haskell}
f :: Int -> Float -> String -> IO ()
f @ 0.5 @  :: Int -> String -> IO ()
f @ 0.5 "" :: Int -> IO ()
~~~

Currying rocks. `(2^) ´map´ [1..16]` is a great example. Let's do away with the boilerprate, finally.
A similar syntax is (rarely?) used in mathemathics with $$\cdot$$ instead of `@` for obvious reasons. `.` is used for function composition in haskell, so I (arbitrarily) picked `@` for this post. It's already used in patterns and thus cannot be used as an identifier, but as far as I see there would be no conflict. There are however some ambiguities that need to be resolved. My best bet is the following:

~~~ {.haskell}
f @ = f
(f @) = f
((((f @) @) @) @) = f
(f @) x = f x != f @ x
~~~

The last inequality is bothering, but it does not ruin the idea for me (at least if compilers don't assume the inverse for some reason). Is there any chance for this to be implemented?
