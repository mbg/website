---
title: What should I wear? Parametric polymorphism and its decidability
authors: Michael B. Gale
---

| Downloads |
|:--------:|
| [PDF](/files/wsiw.pdf)      |
| [Slides](/files/wsiw-slides.pdf)   |

## Abstract

Type systems are key components of modern programming languages, but their design dictates the style and ease in which programs may be written. A simple type system may be too restrictive to be useful, while a more sophisticated one may require programmers to do additional work. Finding the right balance between these two aspects is a key goal of research, because the aim of a type system should be to aid programmers.

Parametric polymorphism is an important component of the type systems of many modern programming languages, such as Haskell and C#. It enables us to assign types which contain type variables, allowing respective definitions to be used in a range of contexts if we instantiate the type variables with suitable types. Unsurprisingly, such an advantage does not come for free and much work has been done to determine what the right price should be.

In this report, we will review why polymorphism is needed and how it is introduced in the second-order lambda-calculus (also known as System F). We then show its problems in the context of functional programming languages and how these are dealt with in, for example, Haskell. Lastly, we examine more recent work on the subject, including intersection types and bidirectional type inference, to see how it fits into the larger picture.

## BibTeX

```
@report{mbg2013wsiw,
    author = {Gale, M. B.},
    title = {What should I wear? Parametric polymorphism and its decidability},
    type = {Technical Report},
    institution = {The University of Nottingham},
    date = {May 2013}
}
```
