---
title: A compiler for Cada
authors: Michael B. Gale
---

| Downloads |
|:--------:|
| [PDF](/files/dissertation.pdf)      |
| [Code](https://github.com/mbg/ncc)   |

## Abstract

Monads have evolved into a powerful and versatile tool for functional programming languages, but remain a challenging concept for those versed in other programming paradigms. Their usefulness encourages us to explore means by which they can be made more accessible. While efforts have been made to introduce syntactic constructs for this purpose, such as the do-notation and monad comprehensions in Haskell, these constructs work universally for all monads and do not aid programmers with the unique aspects of individual monads.

High-level programming languages aim to hide machinery in an underlying system which is frequently used in programs. In cases where no such abstractions are available, programmers may have to write repetitive or difficult code. For this reason, it is desirable to enrich functional programming languages with abstractions for some frequently used monads.

Our goal in this dissertation will be to explore the role of the state monad, to design a functional programming language which makes effective use of our observations, and to implement a compiler for it in Haskell. In the process of developing this language, which we shall name Cada, we will explore the foundations of functional programming and learn that implementing a compiler for a modern functional language is nothing to be afraid of.

## BibTeX

```
@thesis{mbg13cada,
   author = {Gale, M. B.},
   title = {A compiler for Cada},
   type = {BSc (Hons) Dissertation},
   institution = {The University of Nottingham},
   date = {2013}
}
```
