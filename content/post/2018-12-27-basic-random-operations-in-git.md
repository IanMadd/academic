---
title: "Basic Random Operations in Git"
date: 2018-12-27T18:40:11-05:00
draft: false
author: Ian
categories:
  - Short Note
  - Git
tags:
  - git
---


## Display Git Branch in Bash Prompt



It is easy to accidentally make commits or other changes to the wrong branch in git.

To display the git branch in the bash prompt open the bash profile:

```
nano ~/.bash_profile
```

Then add the following text and save:

```
source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
PS1='\W$(__git_ps1 "(%s)") > '
```

From here on out your bash prompot will display the current git branch. For example:

```
academic(master) >
```

<br>

## Display Git Repository Information

This will display basic information stored in the git config file.

```
cat .git/config
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
	precomposeunicode = true
[remote "origin"]
	url = https://github.com/IanMadd/academic.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
[branch "rewrite-managingPython"]
	remote = origin
	merge = refs/heads/rewrite-managingPython

```

<br>

## Pretty Graphs in Git


The command `git log --pretty --graph` will show a log with branches, merges
and commits. The options `%h` shows the commit hash, and `%s` shows the commit
message (see below). There are [other options](https://git-scm.com/docs/pretty-formats) as well.

```
git log --pretty=format:"%h %s" --graph

* 8ed08a6 Added new portfolio section mentioning grant writing sample.
* 553547a Created minor updates to website.
* 8b0b442 Minor changes in text, also added Shiny central limit theorem simulation.
* 6dd69c3 Updated data frame page in portfolio.
* 10dc913 Added post about BFG-Repo Cleaner
* 01e9721 Delete Managing Python from portfolio.
* 6cc35db added post about BFG Cleaner.
* 91ec253 General updates to site, change layout of posts. Edited data table page.
*   022a475 Merge branch 'master' of https://github.com/IanMadd/academic
|\
| * d89b9ad Minor editing changes to some posts, removed a post that wasn't ready for prime time.
* | 3d51412 Minor editing changes to some posts, removed a post that wasn't ready for prime time.
|/
*   62f5ddb merged files
|\
| * 9b049fa added new pages, revised a lot of content and design of the website.
| * ac1abfb Added portfolio section
| * d04160c Create README.md
* | 4764bf9 I've been improving the content in the Central Limit Theorem page.
* | 600f901 continued minor changes to website appearance, continue updates to portfolio.
* | a447016 deleted unnecessary sample data
* | df6047c Continuing updates and modifications for the whole site.
* | 0afdcc3 added new pages, revised a lot of content and design of the website.
* | da2d0a6 Added portfolio section
* | da027f2 Create README.md
|/
* c1ef5db modification to about.md
* 691e018 Initial Commit
```

<br>

## Delete Local and Remote Branches


To delete a local branch just enter:

```
git branch -d branch_name
```
or
```
git branch --delete branch_name
```

To force delete, enter:

```
git branch -D branch_name
```

<p>

To delete a remote branch enter:

```
git push -d origin branch_name
```

<br>
