---
title: Practical 2 - Compiler Construction
---

In the second part of the practical, you will be implementing an interpreter for the STG language which implements the [operational semantics of the STG machine](http://www.cl.cam.ac.uk/~mbg28/teaching/compilers/compiler-spec.pdf).

## Upgrading the Skeleton Code

This practical continues where we left off in the previous practical. To begin, [follow the instructions for upgrading your code](upgrade.html) to obtain the skeleton code for this practical.

## Task: Interpreter

Implement an interpreter for the STG language according to the [specification of the operational semantics](http://www.cl.cam.ac.uk/~mbg28/teaching/compilers/compiler-spec.pdf). A basic framework for the interpreter can be found in [src/Interpreter.hs](https://github.com/mbg/compconstr-code/blob/supervision2/src/Interpreter.hs). In particular, you should replace all occurrences of `undefined` in the definition of [`step`](https://github.com/mbg/compconstr-code/blob/supervision2/src/Interpreter.hs#L168) with your own code. See below for some help.

## Sequencing operations

Note that the type of the `step` function is `Config -> Maybe Config`. `Config` is the type of STG machine configurations and is defined at the top of [src/Interpreter.hs](https://github.com/mbg/compconstr-code/blob/supervision2/src/Interpreter.hs#L70). `Maybe` is Haskell\'s version of the `option` type in ML and is defined as:

```haskell
data Maybe a = Just a | Nothing
```

In other words, the `step` function takes a configuration as argument and either returns a new configuration wrapped in the `Just` constructor or `Nothing` to indicate failure. While it is useful to know that a function may fail, this may also be somewhat cumbersome. For example, consider using the [`val` function](https://github.com/mbg/compconstr-code/blob/supervision2/src/Interpreter.hs#L77), which may fail if a variable can neither be found in the local nor the global environment, inside the definition of `step`. If we use `val`, we have to check if it was successful or not to determine whether we wish to proceed with the result or return failure ourselves. One such example might be the rule for built-in operators where we need to look up the values of the arguments before proceeding:

```haskell
step (Eval (OpE op [x1,x2] _) p,as,rs,us,h,env) =
    case val p M.empty x1 of
        Nothing -> Nothing
        Just i1 -> case val p M.empty x2 of
            Nothing -> Nothing
            Just i2 -> Just ...
```

This is of course extremely tedious, since we have to write the same test over and over again. Fortunately, there is some Haskell magic to help us out. It just so happens that the `Maybe` type has a particular property which allows us to make use of a special syntax in Haskell: the do-notation. Using this notation, the above code may be rewritten as:

```haskell
step (Eval (OpE op [x1,x2] _) p,as,rs,us,h,env) = do
    i1 <- val p M.empty x1
    i2 <- val p M.empty x2
    Just ...
```

The `do` keyword is followed by a sequence of statements, which come in two forms. A statement of form `x <- m` where `m :: Maybe a` and `x :: a` (for some type `a`) binds `x` in subsequent statements by evaluating `m` and automagically performing the test shown above, extracting the value of type `a` from the value of type `Maybe a` if successful. A statement of form `m` where `m :: Maybe a` can also be used. If it occurs as the last statement in a do-block, then it is used as the value of the do-block (but note that the `a` must then match the expected type of the whole block). Otherwise, `m` is evaluated and its result is used to perform the above test, but the result is then discarded and not bound to a variable.

## Useful functions and types

You may find the following functions and types useful. In particular, the `Interpreter` module makes use of the `Data.Map` module from the [*containers* package](https://hackage.haskell.org/package/containers-0.5.7.1/docs/Data-Map-Lazy.html), which implements dictionaries.

Note that `Data.Map` is imported as qualified and all function and type names from that module are prefixed with `M.` in our code as a result. In particular, note that `type GlEnv = M.Map String Addr` and `type Heap = M.Map Addr Closure`. The following functions from `Data.Map` and other imported modules will be useful in completing the definition of `step`:

### `M.empty :: M.Map k a`

`M.empty` represents an empty dictionary.

### `M.size :: M.Map k a -> Int`

`M.size dict` returns the number of entries in `dict`. O(1).

### `M.fromList :: Ord k => [(k,a)] -> M.Map k a`

`M.fromList xs` converts a list of pairs to a dictionary. O(n * log n).

### `M.insert :: Ord k => k -> a -> M.Map k a -> M.Map k a`

`M.insert key val dict` inserts a value `val` with key `key` into the dictionary `dict`. O(log n).

### `M.union :: Ord k => M.Map k a -> M.Map k a -> M.Map k a`

`M.union d1 d2` calculates the left-biased union of `d1` and `d2`. *I.e.* it prefers `d1` when duplicate keys are encountered. O(n + m).

### `M.lookup :: Ord k => k -> M.Map k a -> Maybe a`

`M.lookup key dict` looks up `key` in `dict`. O(log n).

### `mapM :: (a -> Maybe b) -> [a] -> Maybe [b]`

`mapM f xs` applies `f` to every element in `xs` (like `map`), but checks that `f` was successful before proceeding to the next element. In other words, if `f` fails for at least one element in `xs`, then `mapM` also fails.

You may also find the [documentation for functions which deal with lists](http://hackage.haskell.org/package/base-4.8.2.0/docs/Data-List.html) in Haskell useful.

Another useful resource is [Hoogle](https://www.haskell.org/hoogle/), which you can use to search Haskell libraries for things by name or type. For example, if you wanted to find a function which returns the size of a list, but don\'t know its name, you could search for `[a] -> Int`.

## Task: Testing

Thoroughly test your interpreter to ensure that all rules in the operational semantics have been implemented correctly, according to the specification in Appendix app:semantics. Explain how you have tested your interpreter and why you are convinced that it is correct.

The skeleton code comes with a basic test suite for the compiler. You can run the test suite using Stack:

```sh
$ stack test
```

This will run all regression tests in the test suite and report on the outcome. If you run the test suite without completing the exercises, you will get a result similar to the following which indicates that one test was performed and failed, preceded by more details about the failure which have been omitted here:

```sh
Finished in 0.0110 seconds
1 example, 1 failure

Completed 2 action(s).
Test suite failure for package stg-0.1.0.0
   spec:  exited with: ExitFailure 1
Logs printed to console
```

The regression tests are contained in the [tests](https://github.com/mbg/compconstr-code/tree/supervision2/tests) folder. Each test consists of a `.stg` file and a `.stdout` file which otherwise share the same filename. The `.stg` file contains the STG program that should be parsed and the `.stdout` file contains the expected compiler output. If the output generated by the compiler as a result of parsing the `.stg` file matches that specified in the `.stdout` file, the test is successful. Otherwise, the test fails. Currently, there is only one regression test. To add additional regression tests to the test suite, place additional `.stg` and `.stdout` files in the [tests](https://github.com/mbg/compconstr-code/tree/master/tests) folder. You will also need to add the name of the `.stg` file to the `files` list in the [test/ParserSpec.hs](https://github.com/mbg/compconstr-code/blob/supervision2/test/ParserSpec.hs#L27) file.

Thoroughly test your parser to ensure that all valid programs in the STG language, according to [the grammar](compiler-spec.pdf), can be parsed successfully. Explain how you have extended the test suite to test your parser and why you are convinced that the parser is correct.
