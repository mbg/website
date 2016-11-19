---
title: A Tale of Two Abstractions
authors: Michael B. Gale and Alan Mycroft
---

## Abstract

Monad transformers are infamous for being awkward to work with. To begin tackling this problem, we formulate a correspondence between state monad transformers and the inheritance mechanism of object-oriented languages. While object-oriented languages implicitly supply the boilerplate required for inheritance to work seamlessly, state monad transformers require it to be explicit. By hiding this boilerplate in type class instances, we gain the ease of member access of object-oriented languages. This allows us to use stacks of state monad transformers as easily as objects. We illustrate using examples that these *objects* are as easy to work with as their object-oriented counterparts.

Our *object classes* do not need to know about other *object classes* which inherit from them. The resulting hierarchy is therefore open for extension. This can be taken advantage of to construct modular data types and programs through the addition of an encoding for subtyping as well as inheritance. All of this is encoded entirely in Haskell and requires no new language features. Finally, a Template Haskell library allows programmers to write class definitions in the same style as in object-oriented languages and in which the boilerplate is automatically derived.
