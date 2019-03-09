+++
# Date this page was created.
date = 2019-01-06T00:00:00

# Project title.
title =  "A Step By Step Contribution to QGIS Documentation"

# Project summary to display on homepage.
summary = "This is a rewrite of [QGIS's documentation](https://docs.qgis.org/testing/en/docs/index.html) showing users how to contribute changes to the documentation using [Github](https://github.com/qgis/QGIS-Documentation)."

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "/headers/githubLogo.png"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ['other']

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = true

# Optional featured image (relative to `static/img/` folder).
[header]
    image = "headers/githubLogo.png"
    caption = ""

+++

# Purpose

This is user documentation for the QGIS website which explains how users can contribute
changes to the QGIS documentation using Github. It's intended for users who know
little about Git or Github. The documentation was originally written using
[Sphinx](https://www.sphinx-doc.org/en/master/) and
[reStructuredText](http://docutils.sourceforge.net/rst.html) and is reproduced
here in Markdown.

# A Step By Step Contribution

* [Using the GitHub web interface](#githubWebInterface)

    1. [Fork QGIS-Documentation](#forkQGISDocs)
    2. [Make changes](#makeChanges)
        * [Alternative 1: Use the Fix Me shortcut](#fixMeShortcut)
        * [Alternative 2: Create an ad hoc branch in your documentation repository](#createAdHocBranch)
    3. [Modify files](#modifyFiles)
    4. [Share your changes via Pull Request](#shareChangesPullRequest)
        1. [Start a new pull request](#startNewPullRequest)
        2. [Compare changes](#compareChanges)
        3. [Describe your pull request](#describePullRequest)
        4. [Make corrections](#makeCorrections)
        5. [Review and comment pull request](#reviewAndCommentPullRequest)
    5. [Delete your merged branch](#deleteMergedBranch)

Now that you know how to write documentation using [reStructuredText and
Sphinx](https://docs.qgis.org/testing/en/docs/documentation_guidelines/writing.html#writing-doc-guidelines), let's dive into the process of sharing your changes with the community.

# Using the GitHub web interface {#githubWebInterface}


The GitHub web interface allows you to do the following:

* edit files
* preview and commit your changes
* make a pull request to have your changes inserted into the main repository
* create, update, or delete branches

Read the GitHub [Hello-world](https://guides.github.com/activities/hello-world/)
project to learn some basic vocabulary and actions that will be used below.


{{% alert note %}}

**If you are fixing a reported issue**

If you are making changes to fix an [issue](https://github.com/qgis/QGIS-
Documentation/issues), add a comment to the issue report to assign it to
yourself. This will prevent more than one person from working on the same
issue.

{{% /alert %}}


## 1. Fork QGIS-Documentation {#forkQGISDocs}

Assuming you already have a [GitHub account](https://github.com/join),
you first need to fork the source files of the documentation.

Navigate to the [QGIS-Documentation repository](https://github.com/qgis/QGIS-Documentation) page and click on the <img src="/img/githubFork.png" style="display: inline-block; margin: 0" width="60px"/> button in the upper right corner.

In your GitHub account you will find a QGIS-Documentation repository
(`https://github.com/<YourName>/QGIS-Documentation`).
This repository is a copy of the official QGIS-Documentation repository where
you have full write access and you can make changes without affecting the
official documentation.

## 2. Make changes {#makeChanges}


There are different ways to contribute to QGIS documentation. We show
them separately below, but you can switch from one process to the other
without any harm.

### Alternative 1: Use the ``Fix Me`` shortcut {#fixMeShortcut}


Pages on the QGIS website can be edited quickly and easily by clicking on the
``Fix Me`` link in the footer of each page.

1. This will open the file in the ``qgis:master`` branch with a message at the
   top of the page telling you that you don't have write access to this repo
   and your changes will be applied to a new branch of your repository.

2. Make your changes following the [writing guidelines](https://docs.qgis.org/testing/en/docs/documentation_guidelines/index.html#qgis-documentation-guidelines).

3. When you finish, make a short comment about your changes and click on
   `Propose file change`. This will generate a
   new [branch](https://help.github.com/articles/about-branches/) (`patch-xxx`) in your repository.

4. After you click on `Propose file change` github will navigate to
   the `Comparing changes` page.

   * If you're done making changes, skip to [Compare changes](#compareChanges) in the [Share your changes via Pull Request](#shareChangesPullRequest) section below.
   * If there are additional changes that you want to make before submitting
     them to QGIS, follow these steps:

     1. Navigate to your fork of QGIS-Documentation (``https://github.com/<YourName>/QGIS-Documentation``)
     2. Click on <img src="/img/githubBranch.png" style="display: inline-block; margin: 0;" width="100px" /> and search for the ``patch-xxx`` branch. Select
        this patch branch. The <img src="/img/githubBranch.png" style="display: inline-block; margin: 0;" width="100px" /> button will now say
        `Branch: patch-xxx`
     3. Jump down to [Modify files](#modifyFiles) below.

### Alternative 2: Create an ad hoc branch in your documentation repository {#createAdHocBranch}


You can edit files directly from your fork of the QGIS Documentation.

Click on <img src="/img/githubBranch.png" style="display: inline-block; margin: 0;" width="100px" /> in the upper left corner of your forked QGIS-
Documentation repository and enter a unique name in the text field to create a
new [branch](https://help.github.com/articles/about-branches/).
The name of the new branch should relate to the problem you intend to fix. The
<img src="/img/githubBranch.png" style="display: inline-block; margin: 0;" width="100px" /> button should now say `Branch: branch_name`.

{{% alert note %}}
**Do your changes in an ad hoc branch, never in the** ``master`` **branch**


By convention, avoid making changes in your ``master`` branch except when
you merge the modifications from the ``master`` branch of ``qgis/QGIS-Documentation``
into your copy of the QGIS-Documentation repository.
Separate branches allow you to work on multiple problems at the same time
without interfering with other branches. If you make a mistake you can
always delete a branch and start over by creating a new one from the master
branch.

{{% /alert %}}

## 3. Modify files {#modifyFiles}


 1. Browse the source files of your fork of QGIS-Documentation to the file that needs to be modified
 2. Make your modifications following the [writing guidelines](https://docs.qgis.org/testing/en/docs/documentation_guidelines/writing.html#writing-doc-guidelines)
 3. When you finish, navigate to the **Commit Changes** frame at the bottom of
   the page, make a short comment about your changes, and click on
   `Commit Changes` to commit the changes directly to your branch.
   Make sure `Commit directly to the branch_name branch.` is selected.
 4. Repeat the previous steps for any other file that needs to be updated to
   fix the issue

## 4. Share your changes via Pull Request {#shareChangesPullRequest}

You need to make a pull request to integrate your changes into the official documentation.


{{% alert note %}}
**If you used a** ``Fix Me`` **link**

  After you commit your changes GitHub will automatically open a new page
  comparing the changes you made in your ``patch-xxx`` branch to the ``qgis/QGIS-Documentation``
  master branch.

  Skip to [Step 2](#compareChanges) below.

{{% /alert %}}

### 1. Start a new pull request {#startNewPullRequest}


Navigate to the main page of the [QGIS-Documentation](https://github.com/qgis/QGIS-Documentation)
repository and click on `New pull request`.



### 2. Compare changes {#compareChanges}


If you see two dialog boxes, one that says `base:master` and the other
`compare:branch_name` (see figure), this will only merge your changes from
one of your branches to your master branch. To fix this click on the
`compare across forks` link.

<img src="/img/githubCompareAcrossForks.png" style="margin:60px 0 0 0">
*If your Comparing changes page looks like this, click on the compare across forks link.*

You should see four drop-down menus. These will allow you to compare the
changes that you have made in your branch with the master branch that you want
to merge into. They are:

* **base fork**: the fork that you want to merge your changes into
* **base**: the branch of the base fork that you want to merge your changes into
* **head fork**: the fork that has changes that you want to incorporate into the base fork
* **compare**: the branch with those changes

Select ``qgis/QGIS-Documentation`` as the base fork with ``master`` as base,
set the head fork to your repository ``<YourName>/QGIS-Documentation``,
and set compare to your modified branch.

<img src="/img/githubCreatePullRequestComparison.png" style="margin: 60px 0 0 0">
*Comparing changes between ``qgis/QGIS-Documentation`` and your repository*

A green check with the words **Able to merge** shows that your changes can
be merged into the official documentation without conflicts.

Click the `Create pull request` button.

{{% alert warning %}}

  **If you see** <img src="/img/githubCantMerge.png" style="display: inline-block; margin: 0;">

This means that there are [conflicts](https://help.github.com/articles/addressing-merge-conflicts/).
The files that you are modifying are not up to date with the branch you are
targeting because someone else has made a commit that conflicts with your
changes. You can still create the pull request but you'll need to fix any
[conflicts](https://help.github.com/articles/addressing-merge-conflicts/) to complete the merge.

{{% /alert %}}

{{% alert note %}}

Though released and being translated, the documentation of QGIS
2.18 is still maintained and existing issues are fixed. If you are
fixing issues for a different release, change **base** from `master`
to the appropriate `release_...` branch in the steps above.

{{% /alert %}}

## 3. Describe your pull request {#describePullRequest}


A text box will open. Add any relevant comments for the issue you are
addressing.

If this relates to a particular [issue](https://github.com/qgis/QGIS-Documentation/issues),
add the issue number to your comments. This is done by entering # and the issue
number (*e.g.* `#1234`). If preceded by terms like `fix` or `close`, the
concerned issue will be closed as soon as the pull request is merged.

Add links to any documentation pages that you are changing.

Click on `Create pull request`.

### 4. Make corrections {#makeCorrections}


A new pull request will automatically be added to the [Pull requests list](https://github.com/qgis/QGIS-Documentation/pulls).
Other editors and administrators will review your pull request and they may make
suggestions or ask for corrections.

A pull request will also trigger a [Travis CI build](https://travis-ci.org/qgis/QGIS-Documentation)
which automatically checks your contribution for build errors.
If Travis CI finds an error, a red cross will appear next to your commit.
Click on the red cross or on `Details` in the summary section at the bottom
of the pull request page to see the details of the error. You'll have to fix
any reported errors or warnings before your changes are committed to the
`qgis/QGIS-Documentation` repository.

You can make modifications to your pull request until it is merged with the
main repository, either to improve your request, to address requested
modifications, or to fix a build error.

To make changes click on the <img src="/img/githubFilesChanged.png" style="display: inline-block; margin: 0" /> tab in your pull request
page and click the pencil button <img src="/img/githubEditPencil.png" style="display: inline-block; margin: 0" /> next to the filename that
you want to modify.

Any additional changes will be automatically added to your pull request if you
make those changes to the same branch that you submitted in your pull request.
For this reason, you should only make additional changes if those changes
relate to the issue that you intend to fix with that pull request.

If you want to fix another issue, create a new branch for
those changes and repeat the steps above.

An administrator will merge your contribution after any build errors are
corrected, and after you and the administrators are satisfied with your changes.

### 5. Review and comment pull request {#reviewAndCommentPullRequest}


You can make [comments](https://help.github.com/articles/commenting-on-a-pull-request/)
on the changes in a pull request. Navigate to the [pull request page](https://github.com/qgis/QGIS-Documentation/pulls)
and click on the pull request that you want to comment on.

At the bottom of the page you will find a text box where you can leave general
comments about a pull request.

To add comments about specific lines, click on
<img src="/img/githubFilesChanged.png" style="display: inline-block; margin: 0" /> and find the file you want to comment on. You may have to
click on `Load diff` to see the changes. Scroll to the line you
want to comment on and click on the <img src="/img/githubBluePlus.png" style="display: inline-block; margin: 0" />. That will open a text box
allowing you to leave a comment.

## 5. Delete your merged branch {#deleteMergedBranch}


You can delete the branch after your changes have been merged.
Deleting old branches saves you from having unused and outdated branches in
your repository.

Navigate to your fork of the QGIS-Documentation repository (`https://github.com/<YourName>/QGIS-Documentation`).
Click on the `Branches` tab. Below `Your branches` you'll
see a list of your branches. Click on the <img src="/img/mActionDeleteSelected.png" style="display: inline-block; margin: 0" /> <sup>Delete this
branch</sup> icon to delete any unwanted branches.
