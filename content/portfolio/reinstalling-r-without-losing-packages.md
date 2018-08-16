+++
# Date this page was created.
date = 2016-04-27T00:00:00

# Project title.
title = "Reinstalling R Packages"

# Project summary to display on homepage.
summary = "R deletes all installed packages when a user updates or reinstalls R, this is an easy solution that will re-install R packages."

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "/headers/R_logo.png"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["r-programming"]

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = false
+++


<br>

When you reinstall R it deletes all of your installed packages and reinstalling them manually can be a nuisance. This is an easy way to automatically reinstall your R packages after you install a new version of R.

<br>

## Before Reinstalling R

Before you reinstall R, use setwd() to set a directory where you can save a text file of all your currently installed packages.

Run this command to create a text file in that directory called "Rpaackages":

```{r}
packages <- installed.packages()[,"Package"]
    save(packages, file="Rpackages")
```

<br>

## Reinstalling R

[Download R here](https://cran.r-project.org) and install according to the instructions.

<br>

## After Reinstalling R

After R has been reinstalled, use setwd() to set R to the same directory where the list of packages was saved.

Then run:

```{r}
load("Rpackages") 
    for (p in setdiff(packages, installed.packages()[,"Package"]))
    install.packages(p)
```

This may take a while depending on how many packages you have installed but it's far faster than manually installing each package one at a time. 
