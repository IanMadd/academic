---
title: BFG Repo-Cleaner - Deleting Large File From Git
author: ''
date: '2018-09-01'
slug: deleting-large-file-from-git
categories:
  - Git
  - Short Note
tags:
  - git
header:
  caption: ''
  image: ''
draft: true
---
[BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) is the best way to delete a large file from a git repository that you've already committed.

When a file is committed to a repository, it stays in the repository's history even if you remove it in a subsequent commit. This allows a user to undo later commits and bring back the previous commits, with all their files undisturbed. The problem is that users may want to completely delete a file that is too large or could have sensitive information stored in it.

BFG Repo-Cleaner will delete those files from every commit in a repositiory's history.

[Download from their website and follow their instructions.](https://rtyley.github.io/bfg-repo-cleaner/) [You'll need the Java Development Kit](https://www.oracle.com/technetwork/java/javase/downloads/index.html) if you don't already have it installed.
