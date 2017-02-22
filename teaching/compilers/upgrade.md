---
title: Upgrading your repository
---

The [repository with the skeleton code](https://github.com/mbg/compconstr-code) contains [four branches](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging), one for each supervision. The `master` branch initially contains the skeleton code for the first supervision and is the branch you are doing all of your work in. The other three branches, `supervision2`, `supervision3`, and `supervision4`, contain patches which will add new skeleton code to your working copy of the code to help you with later practicals.

## Ensuring that you are in sync with `upstream`

The skeleton code may have been updated since you cloned or forked it, so you should ensure that you have the latest updates. If you have forked my repository on GitHub, that repository will be referred to as `upstream` and your own repository on GitHub as `master`. If you have only cloned it onto your local machine, my repository on GitHub will be referred to as `origin`.

## If you have forked my repository to your own GitHub account

Ensure sure that `upstream` is registered as a remote on your local machine. You can test whether this is the case by running:

```sh
$ git remote -v
```

If there is no `upstream` remote listed which points to `https://github.com/mbg/compconstr-code`, then you should add it now by running:

```sh
$ git remote add upstream https://github.com/mbg/compconstr-code
```

Run the following command to fetch updates from `upstream` to your local machine:

```sh
git fetch upstream
```

To merge new skeleton code for a practical into your existing solutions for a previous practical, you can use `git merge`. First, you should ensure that you are on the `master` branch:

```sh
git checkout master
```

Next, you can merge the new code into yours. For example, if you have just completed the code for the first supervision, you can merge the skeleton code for the second supervision into your code by running:

```sh
$ git merge upstream/supervision2
```

## If you have cloned my repository to your local machine

Run the following command to fetch updates from `origin` to your local machine:

```sh
git pull
```

To merge new skeleton code for a practical into your existing solutions for a previous practical, you can use `git merge`. First, you should ensure that you are on the `master` branch:

```sh
git checkout master
```

Next, you can merge the new code into yours. For example, if you have just completed the code for the first supervision, you can merge the skeleton code for the second supervision into your code by running:

```sh
$ git merge supervision2
```
