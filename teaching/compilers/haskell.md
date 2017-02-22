---
title: Getting started with the Haskell exercises
---

The practical exercises for this course involve tinkering with a compiler written in Haskell. This document describes what you need to do to get started with these exercises.

## Haskell

If you have never used Haskell before, you should start by downloading the Glasgow Haskell Compiler (GHC). The easiest way to do this is via <a href="https://docs.haskellstack.org/en/stable/README/">Stack</a> which also serves as a package manager and build tool. Once you have installed Stack using the <a href="https://docs.haskellstack.org/en/stable/README/">instructions on the website</a>, you are done!

If you have previously used Haskell and/or already installed GHC, but have not used Stack before, download Stack before proceeding. The documentation for the practical exercises assumes that you are using Stack.

##Skeleton code

Once you have installed GHC, you need to obtain a copy of the skeleton code. The code lives on [GitHub](https://github.com/mbg/compconstr-code). I would encourage you to fork this repository to your own GitHub account (if you have one) so that you can submit your work just by linking to your repository. If you choose to do that, you can then clone your GitHub repository to your machine using the following command:

```sh
$ git clone https://github.com/YOUR_USERNAME/compconstr-code
```

If you do not want to fork the repository to your own account, you can clone my version of the repository by replacing `YOUR_USERNAME` with `mbg` in the command above.

After you have cloned the repository that contains the skeleton code, you can verify that everything is working by running the following command in the root directory of the repository:

```sh
$ stack build
```

This will download all dependencies for the compiler and compile the code into an executable. You can repeat this command whenever you wish to recompile the compiler such as after changing part of the code. If you are running `stack build` for the first time, it may take a while to complete since it will have to download everything required to build the compiler. This will not be necessary in subsequent runs.

Finally, you can test the compiler was built successfully by running:

```sh
$ stack exec stg-exe ./tests/Map.stg
```

This will invoke the compiler we have just built, `stg-exe`, with the name of one source file, `./tests/Map.stg`, as argument. Our compiler will try to parse the input file, but will fail with a lexical error since parts of it need to be implemented by you! The error will look roughly like this:

```sh
Parsing ./tests/Map.stg...
stg.EXE: lexical error at line 3, column 13
```

You are now ready to start with the [practical exercises](practical1.html).
