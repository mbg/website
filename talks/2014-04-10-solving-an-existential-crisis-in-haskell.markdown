---
title: Solving an existential crisis in Haskell
venue: BCTCS'14 - Loughborough University
slides: http://www.cl.cam.ac.uk/~mbg28/slides/bctcs2014.pdf
---

Haskell\'s type system provides mechanisms for type refinement
within the scope of certain value expressions if GADTs or type classes
are used. The type system propagates sufficient information to ensure
that nothing can go wrong even if types are erased from the run-time
representation of a program. This is not the case when we are using
existential types, where we deliberately hide concrete types from the
type system. Nevertheless, we may desire to eliminate existential types
in a different part of a program in order to restore the original
types.

For this purpose, we propose an extension to Haskell which allows
programmers to restrict existential types within individual data
constructors to finite, but open, domains of types. Each type in such a
domain must be associated with a value tag that is then stored at run
time to allow it to serve as witness in a case expression.
