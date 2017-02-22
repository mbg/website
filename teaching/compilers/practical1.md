---
title: Practical 1 - Compiler Construction
---

Compiler Construction is a relatively practical topic, so it makes sense for you to implement a compiler as part of the course. Specifically, you will be working with a medium-sized compiler which translates programs in the language of an abstract machine, the Spineless-Tagless G-Machine (STG-Machine), to a C encoding of those programs with the semantics of the abstract machine. The compiler itself is written in Haskell - a modern, functional programming language. Fear not if you have never come across Haskell before: you are given a skeleton code for the compiler which is mostly complete and you will only be asked to fill in a few gaps.

This practical gives you an opportunity to practise a range of skills and revise some of last term\'s courses: Compiler Construction theory, Semantics of Programming Languages, C/C++, version control using Git, and testing. The latter two will help you with your group and individual project as well.

In the first part of the practical, you will be completing the front-end of the compiler which turns a textual representation of a program (aka source code) to an in-memory representation of its abstract syntax. This process consists of two stages: *lexing* and *parsing*. Lexing turns the textual representation of a program to a list of *tokens* which roughly correspond to the terminal symbols in the grammar of the language. Parsing uses the productions of the grammar to turn these tokens into an *abstract syntax tree*.

## Getting Started

There is a separate [guide to help you get started with the practical exercises](haskell.html) which walks you through the steps needed to set up Haskell on your machine and to obtain a copy of the skeleton code. You should read that page before proceeding. You should also complete the theory questions first as the practical exercises are applying that theory.

## Tokens

As mentioned above, the first stage of a compiler is usually lexing, which turns plain text into tokens. To begin, identify the terminal symbols in the context-free grammar for the [concrete syntax of the STG language](compiler-spec.pdf). This is just for your own benefit and you do not need to include them in your answers.

Tokens typically correspond to the terminal symbols in the context-free grammar of a language. A corresponding data type for tokens, `Token`, has been defined in [src/Token.hs](https://github.com/mbg/compconstr-code/blob/master/src/Token.hs#L23). For class of non-terminal, there is a data constructor in the `Token` type. For example, a `=` terminal symbol is represented by `TEquals` and all variable names are represented by `TVar` which takes a value of type `String` as argument (the variable name). However, one or more token types have not been included in the skeleton code - add them as new data constructors to the `Token` type.

You will also have to extend the definition of the `pp` function at the bottom of [src/Token.hs](https://github.com/mbg/compconstr-code/blob/master/src/Token.hs) with corresponding cases for the new constructors you add to the `Token` type so that the compiler knows how to pretty-print them. Pretty-printing is essentially the inverse of parsing in that it takes some processed representation of the compiler input (tokens, parse tree, etc.) and turns it into text that can be looked at by a human. Our pretty-printer uses [the pretty library](https://hackage.haskell.org/package/pretty). For example:

```haskell
pp (TVar xs)     = text "variable" <+> text xs
```

The `pp` function is of type `Token -> Doc` here, where `Doc` is the type of pretty-printed documents. If the `pp` function is applied to a `TVar` token, the above case is used to pretty-print a token that represents a variable non-terminal. The `text` function pretty-prints a `String` value (it is of type `String -> Doc`) and the `<+>` operator combines two documents into one with a space inbetween (it is of type `Doc -> Doc -> Doc`). You can look at [the documentation for the pretty library](https://hackage.haskell.org/package/pretty-1.1.3.4/docs/Text-PrettyPrint-Annotated-HughesPJ.html) for an explanation of all pretty-printing functions that are available to you, but you probably will not need them.

## Lexer

The lexer is specified in the [src/Lexer.x](https://github.com/mbg/compconstr-code/blob/master/src/Lexer.x) file. We are using a lexer generator named [Alex](https://www.haskell.org/alex/) for this purpose which turns that lexer specification into a Haskell encoding of a corresponding DFA. You can find the [documentation for Alex](https://www.haskell.org/alex/doc/html/) on the website. The specification largely consists of regular expressions and semantic actions (in Haskell) which are invoked when a regular expression matches the input. For example,
```lex
"letrec"                    { makeToken TLetRec                         }
```
tries to exactly match the string `letrec` and constructs a `TLetRec` token if successful. You should add rules for the token types you added in the previous question. There are two functions you might want to use in the semantic actions: `makeToken` and `makeTokenWith`. `makeToken` discards the result of the regular expression that was matched and just returns what it is given as argument as the token such as in the example shown above. `makeTokenWith` applies its argument to the result of the regular expression that was matched. For example,
```lex
@var                        { makeTokenWith TVar                        }
```
uses the `@var` macro defined at the top of the file to match on all valid variable names and if it is used successfully, a new token is constructed by applying `TVar` to the name of the variable.

## Abstract Syntax Tree

An abstract syntax tree is an in-memory representation of the syntax tree of a program. You may find the types for abstract syntax trees of STG programs in [src/AST.hs](https://github.com/mbg/compconstr-code/blob/master/src/AST.hs). There are some data type constructors missing, however, and you will need to add them. Do not forget to also add corresponding cases to the definitions of the `pp` function at the bottom of the file.

## Parser

The parser takes a list of tokens as input and produces an abstract syntax tree if the input is valid STG program or an error if not. The parser is specified in [src/Parser.y](https://github.com/mbg/compconstr-code/blob/master/src/Parser.y). Here we are using a parser generator named [Happy](https://www.haskell.org/happy/) which turns the specification into an LARL(1) parser. You can find the [documentation for Happy](https://www.haskell.org/happy/doc/html/) on the website. The specification consists of non-terminal symbols, productions, and semantic actions. For example,

```yacc
default :: { DefaultAlt }
default : VAR '->' expr              {% mkDefaultVar $1 $3                  }
        | DEFAULT '->' expr          {% mkDefault $1 $3                     }
```

defines a non-terminal named `default` whose semantic actions return a value of type `DefaultAlt`. The non-terminal has two productions and corresponding semantic actions - note that the functions used in the semantic actions are defined in [src/P.hs](https://github.com/mbg/compconstr-code/blob/master/src/P.hs). The productions make use of another non-terminal, `expr`, which is defined elsewhere in [src/P.hs](https://github.com/mbg/compconstr-code/blob/master/src/P.hs), and two terminals. All terminals are declared at the top of the file. For example,

```yacc
DEFAULT                          { (TDefault, $$)                       }
```

maps the `DEFAULT` terminal to a token identified by `TDefault` and gives it its position in the source file as value (the \$\$ part). Add productions for the constructors you added for the previous question, as well as terminals for the token types you added for the first practical question. For the semantic actions, corresponding function stubs exist in [src/P.hs](https://github.com/mbg/compconstr-code/blob/master/src/P.hs) - complete them by replacing `undefined` with your own code.

## Testing

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

The regression tests are contained in the [tests](https://github.com/mbg/compconstr-code/tree/master/tests) folder. Each test consists of a `.stg` file and a `.stdout` file which otherwise share the same filename. The `.stg` file contains the STG program that should be parsed and the `.stdout` file contains the expected compiler output. If the output generated by the compiler as a result of parsing the `.stg` file matches that specified in the `.stdout` file, the test is successful. Otherwise, the test fails. Currently, there is only one regression test. To add additional regression tests to the test suite, place additional `.stg` and `.stdout` files in the [tests](https://github.com/mbg/compconstr-code/tree/master/tests) folder. You will also need to add the name of the `.stg` file to the `files` list in the [test/ParserSpec.hs](https://github.com/mbg/compconstr-code/blob/master/test/ParserSpec.hs#L27) file.

Thoroughly test your parser to ensure that all valid programs in the STG language, according to [the grammar](compiler-spec.pdf), can be parsed successfully. Explain how you have extended the test suite to test your parser and why you are convinced that the parser is correct.

## Continuous Integration

If you have forked the repository to your own GitHub account and wish to use continuous integration, the repository contains a [.travis.yml](https://github.com/mbg/compconstr-code/blob/master/.travis.yml) file for use with [Travis CI](https://travis-ci.org/). Note that you will likely want to edit the [.travis.yml](https://github.com/mbg/compconstr-code/blob/master/.travis.yml) file to include the test suite in the build script by changing the following from:

```yaml
script:
- stack --no-terminal --skip-ghc-check build
```

to:

```yaml
script:
- stack --no-terminal --skip-ghc-check test
```

This will run the test suite every time Travis CI performs a build for your compiler. Without this change, Travis CI will only compile your compiler and not run any tests.
