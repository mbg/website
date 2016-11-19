---
title: Programming with Monadic Effect Hierarchies
venue: BCTCS'15 - Middlesex University
slides: http://www.cl.cam.ac.uk/~mbg28/slides/bctcs2015.pdf
---

Effectful programming in purely-functional languages can be awkward to use when multiple effects are required at the same time. It is up to the programmer to set up a configuration of effects and to then correctly wire up their effectful computations so that they can run in a particular configuration. The more complicated the program, the more complicated is this process. Work in this area has largely focused on allowing programmers to write reusable code for arbitrary configurations of effects.

We take a different point of view and propose a technique, inspired by object-oriented programming, for structuring programs around hierarchies of effects. Programmers using this technique write classes, consisting of functions for a particular effect configuration and extensions thereof, but do not have to worry about initialising or wiring them up. This has proved to work well for monadic state, but our goal is to allow arbitrary effect configurations.
