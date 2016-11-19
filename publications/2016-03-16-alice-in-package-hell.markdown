---
title: Alice in Package Hell
authors: Mark Florisson, Michael B. Gale, and Alan Mycroft
---

## Abstract

Modularity in software systems is encouraged because components can be reused across different systems, replaced with other implementations, and updated independently. Yet the task of determining whether a particular version of a software component is compatible with the other components in a system is a problem that plagues most programming languages. Typically, the dependencies of a component are constrained by version ranges. Upon installation, dependencies are resolved by finding a set of package versions where all such constraints are satisfied. However, version ranges do not encode any of the requirements a component has on its dependencies and locking versions at install-time may impose unsatisfiable constraints on components which might be installed later on.

We introduce System P, a package calculus in which package abstractions express dependencies which may be shared between components. Instead of version ranges, interfaces specify the requirements a package has on its dependencies. Dependency resolution for this calculus is more flexible than in existing systems and is also asymptotically faster as it runs in polynomial-time. We prove that our system is sound. Additionally, we present an interface reconstruction algorithm which, given a package without package abstractions or interfaces, computes the interfaces of all dependencies and determines which packages should be abstracted over.
