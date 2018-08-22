+++

# Date this page was created.
date = 2016-04-27T00:00:00

# Project title.
title = "How To Use Data Tables in R"

# Project summary to display on homepage.
summary = "A guide to using the data.table package in R."

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "headers/R_logo.png"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ["r-programming"]

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = true

# Optional featured image (relative to `static/img/` folder).
[header]
image = "headers/R_logo.png"
caption = ""

+++

***

# Purpose


Data tables can handle large data sets faster than data frames, however the [i,j,by] syntax can be a bit confusing. This will explain how to:

* use the [data.tables](https://github.com/Rdatatable/data.table/wiki) package in R.
* select data by row and column
* perform functions on subsetted data
* 
<br>

# Table of Contents


1. [Create a Data Table](#create)
2. [List Data Tables](#list_data_tables)
3. [[i, j, by]](#i_j_by)
4. [Select rows: DT[i]] (#dti)
    1. [Print rows by searching for a value in a column] (#print_rows_searching_value_in_column)
5. [Select Columns: DT[,j]] (#dtj)   
    1. [Performing functions on a column] (#perform_functions_on_column)
6. [Selecting Rows and Columns `DT[i,j]`] (#dtij)
7. [Perform a function on a column by the value of another column `DT[i,j,by]`](#dt_ijby)
9. Perform A Function On A Column By Values In Another Column From A Subset of Rows DT[i,j,by]
* [Return The Number of Objects .N] (#objects_N)
10. [Modifying Data.Tables DT[i,j := ]](#modifying_data_tables)
11. Complete Cases - removing NA rows
12. Using setkey() to sort by a keyed column
    * key()
    * Returning specified columns - mult()
    * Nomatch
    * Math Operations using setkey
    * by=.EACHI
    * Using setkey() on Multiple Columns
    * N
13. List
14. SD (Subset of Data)
    * lapply
    * SDcols
15. Chaining multiple operations together
16. Set and looping in a data.table
17. Change column names using setnames()
18. Changing column order - setcolorder()
19. Unique
20. Additional Information (#additional_information)

<br>
    
# Introduction




<br>

# Create a data.table {#create}

<br>

Start by creating a few data tables. This tutorial will use two data tables, one called **DT** with dummy data, and another called **MTCarsDT** which contains the `mtcars` dataset from the datasets package.

<br>

```
library(data.table)


set.seed(45L)

DT <- data.table(
    V1=rep(c(1,2),6),
    V2=rep(LETTERS[1:3],4),
    V3=rep(round(rnorm(4),4),3),
    V4=1:12,
    V5=21:32,
    V6=LETTERS[1:12],
    V7=101:112,
    V8=121:132,
    V9=rep(c(NA,1,2,3), 3)
    )
```

```{r}
DT

##     V1 V2      V3 V4 V5 V6  V7  V8 V9
##  1:  1  A  0.3408  1 21  A 101 121 NA
##  2:  2  B -0.7033  2 22  B 102 122  1
##  3:  1  C -0.3795  3 23  C 103 123  2
##  4:  2  A -0.7460  4 24  D 104 124  3
##  5:  1  B  0.3408  5 25  E 105 125 NA
##  6:  2  C -0.7033  6 26  F 106 126  1
##  7:  1  A -0.3795  7 27  G 107 127  2
##  8:  2  B -0.7460  8 28  H 108 128  3
##  9:  1  C  0.3408  9 29  I 109 129 NA
## 10:  2  A -0.7033 10 30  J 110 130  1
## 11:  1  B -0.3795 11 31  K 111 131  2
## 12:  2  C -0.7460 12 32  L 112 132  3
```


```{r}
MTCarsDT <- data.table(mtcars)
```

```{r}
head(MTCarsDT)

##     mpg cyl disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## 3: 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## 4: 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## 5: 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## 6: 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```
<br>

# Listing Data Tables {#list_data_tables} 

The data.table package has a nice function that will list all tables in the global environment as well as their columns, and some extra information.

```
tables()

##      NAME     NROW NCOL MB COLS                                        
## [1,] DT         12    9  1 V1,V2,V3,V4,V5,V6,V7,V8,V9                  
## [2,] MTCarsDT   32   11  1 mpg,cyl,disp,hp,drat,wt,qsec,vs,am,gear,carb
##      KEY
## [1,]    
## [2,]    
## Total: 2MB
```




# [i, j, by]{#i_j_by}

<br>

Data Tables allow you to find data in them and perform operations using the following syntax: `DT[i, j, by]`, which means, “Take DT, subset rows using `i`, then calculate `j` grouped by `by`.” This is similar to SQL syntax where i corresponds to SELECT, 

<br>

# Select rows: `DT[i]` {#dti}

<br>

To start with we'll select rows.


```
MTCarsDT[3]

##     mpg cyl disp hp drat   wt  qsec vs am gear carb
## 1: 22.8   4  108 93 3.85 2.32 18.61  1  1    4    1

MTCarsDT[3:5]

##     mpg cyl disp  hp drat    wt  qsec vs am gear carb
## 1: 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## 2: 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## 3: 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2

MTCarsDT[c(3,5:8)]

##     mpg cyl  disp  hp drat   wt  qsec vs am gear carb
## 1: 22.8   4 108.0  93 3.85 2.32 18.61  1  1    4    1
## 2: 18.7   8 360.0 175 3.15 3.44 17.02  0  0    3    2
## 3: 18.1   6 225.0 105 2.76 3.46 20.22  1  0    3    1
## 4: 14.3   8 360.0 245 3.21 3.57 15.84  0  0    3    4
## 5: 24.4   4 146.7  62 3.69 3.19 20.00  1  0    4    2

```
<br>
Notice that the previous command uses the combine function, c(), to list the different rows that will be printed. Without the combine function R will print the 3rd row for columns 5 through 8, like this:
```
MTCarsDT[3,5:8]

##    drat   wt  qsec vs
## 1: 3.85 2.32 18.61  1
```
<br>

## Print rows by searching for a value in a column {#print_rows_searching_value_in_column}

Print rows with 6 cylinder cars

```
MTCarsDT[cyl == 6]

##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3: 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## 4: 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
## 5: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 6: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
## 7: 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```

Print rows with 4 and 6 cylinder cars.

```{r}
MTCarsDT[cyl %in% c(4,6)]
```

Print rows with cars that have 110 or 123 hp.
```{r}
MTCarsDT[hp %in% c(110,123)]
```
<br>

# Select Columns: `DT[,j]` {#dtj}

<br>
<br>

Print the hp column as a vector
```{r}
MTCarsDT[,hp]
```

Print just the hp column as a data.table
```{r}
head(MTCarsDT[,.(hp)])
```


Note that the expression `.(hp)` is identical to `list(hp)`, the period is equivalent to the list function.

```
head(MTCarsDT[,list(hp)])
```

Print multiple columns as a data.table.

<br>

```
MTCarsDT[,.(hp, cyl)]
```

```
MTCarsDT[,.(hp, cyl)]
```


<br>




***

You can also print columns by index using the index number and `with=FALSE`, but this is a bad idea. See below.

```
head(MTCarsDT[, 1:3, with=FALSE])
```

```
head(MTCarsDT[, c(1:3,4,6), with=FALSE])
```

<br>

**WARNING**

Using `with=FALSE` to refer to columns by index number can create errors. If you reference a column by number and then add, move, or replace columns, the code may continue to execute and may appear normal but it will return incorrect results without any warning. For this reason you should refer to columns by name rather than number.

***

<br>

## Performing functions on a column {#perform_functions_on_column}

You can perform functions on a column. 

This will return the mean of the hp column:
```
MTCarsDT[,mean(hp)]
```

Return the mean of `hp` and standard deviation of `mpg`.
```
MTCarsDT[,.(mean(hp), sd(mpg))]
```

The same as above but the results have different names.
```{r}
MTCarsDT[,.(horsepower=mean(hp), milespergallon=sd(mpg))]
```

This prints the horsepower for each row and repeats the values of the sd and mean of the hp column.
```
MTCarsDT[,.(hp, SD_HP=sd(hp), Mean_HP=mean(hp))]
```



```
MTCarsDT[,.(hp, SD_HP=sd(hp), Mean_HP=mean(hp))]
```

***

<br>
We can use apply on a data.table to apply a function to each column
```
sapply(MTCarsDT, class)
sapply(DT, mean) #returns errors if column is not numeric
```

<br>
The curly braces allow multiple functions. Notice that the separate functions must be placed on separate lines or be separated by semicolons.
```
MTCarsDT[, {print(disp); plot(mpg, wt); sapply(MTCarsDT, mean)}]
```


# Selecting Rows and Columns `DT[i,j]` {#dtij}

<br>

Print rows 1:5 but only the hp, weight, and mpg columns.
```{r}
MTCarsDT[1:5, .(hp,wt,mpg)]
```

Return cylinders, hp, mean hp and mpg for 6 cylinder cars.
```{r}
MTCarsDT[cyl == 6,.(cyl,hp,MeanHorsepower = mean(hp),mpg)]
```
Note that the mean horsepower is *only* for 6 cylinder cars and doesn't include 4 and 8 cylinder cars.

```{r, collapse=TRUE}
MTCarsDT[,mean(hp)]
```
<br>

# Perform a function on a column by the value of another column `DT[,j,by]` {#dtjby}

<br>
This gives the mean horsepower by the number of cylinders.
```{r}
MTCarsDT[,.(MeanHP = mean(hp)), by=cyl]
```

This will give mean time in seconds for 1/4 mile race based on both gears and cylinders.
```{r}
MTCarsDT[,.(MeanQuarterMile = mean(qsec)), by=.(cyl,gear)]
```
<br>


# Perform A Function On A Column By Values In Another Column From A Subset of Rows `DT[i,j,by]` {#dt_ijby}

This gives the mean horsepower of the first ten cars by the number of cylinders.
```
MTCarsDT[1:10,.(mean_hp = mean(hp)), by=cyl]
```
<br>

This will give the mean hp for cars with 4 gears grouped by the number cylinders.
```{r}
MTCarsDT[gear == 4,.(Mean_HP = mean(hp)), by=cyl]
```

# Count The Number of Objects `.N` {#objects_N}

`.N` is a variable that will return the number of instances. 


This gives a total count of the number of rows in the dataset:
```
MTCarsDT[,.N]

## [1] 32
```

This returns a count of the number of cars grouped by the number of gears they might have.
```
MTCarsDT[,.N, by=gear]

##     gear  N
##  1:    4 12
##  2:    3 15
##  3:    5  5
```

This returns the count of gears only for 6 cylinder cars:

```
MTCarsDT[cyl == 6, .N, by=gear]

##     gear N
##  1:    4 4
##  2:    3 2
##  3:    5 1
```

This also works.
```
MTCarsDT[,table(gear)]

##  gear
##   3  4  5 
##  15 12  5 
```

# Modifying Data.Tables `DT[i,j := ]` {#modifying_data_tables}

<br>

The `:=` operator updates columns and does so invisibly. The := operator makes the assignment operator (`DT <- DT[.....]`) unnecessary because it is significantly faster than the assignment operator. [For more on :=](https://www.rdocumentation.org/packages/data.table/versions/1.11.4/topics/%3A%3D).
```{r}
DT[,V8]

DT[, V8 := round(exp(V3),2)]

DT[,V8]
```

Replace NA's in V9 column with 0

```{r}
DT[,V9]
```

```{r}
DT[is.na(V9), V9 := 0]
DT[1:5]
```


Columns V6 and V7 are updated with the results of the functions after the := operator.
```{r}
DT[,.(V6,V7)]
DT[, c("V6","V7") := .(LETTERS [3:5], round(exp(V1),2))]
DT[,.(V6,V7)]
```

Adding brackets (`[]`) to the end of the operation will print the result automatically.
```{r}
DT[, c("V6", "V7") := .(LETTERS [3:5], round(exp(V1),2))][]
```

This deletes the V1 column
```{r}
DT[, V1 := NULL][]
```

And this deletes V7 and V8

```{r}
DT[, c("V7","V8") := NULL][]
```


Find the values in column V2 = A and assign X to them.
```{r}
DT[V2 == "A", V2 := "X"][]
```
Add columns V7 and V8 back.

```{r}
DT[,c("V7","V8") := .(101:112,121:132)][]
```

# Complete Cases - removing NA rows

We can use `complete cases` to delete all rows with NA values from any column. Complete cases is not part of the data.table package, but it is handy.

<br>
First I'll change the V8 column to include some NA's, then delete all those rows with NA's.
```{r}
DT[,"V8" := rep(c(NA,1,2,3), 3)][]
DT <- DT[complete.cases(DT)]
head(DT)
```


# Using `setkey()` to sort by a keyed column

<br>

Setkey does two things:

1. It reorders the rows of the data.table by the keyed column in increasing order.

2. It marks the keyed column in the data.table.

3. It allows us to easily search through that column.


First, this operation keys the V2 column in this Data Table.
```{r, warning=FALSE, message=FALSE}
setkey(DT,V2)
DT
```


<br>

We can search through a keyed column quite easily.

If only one column has been keyed we can search the keyed column and display all rows that match the search.
```{r}
setkey(DT,V2)
DT["B"]
```

We can also search for two values in the keyed column.

<br>
```{r}
DT[c("B", "X")]
```


## key()

`key()` will tell us which column, if any, are set as the keyed column.
```{r}
key(DT)
```

`haskey()` will return TRUE or FALSE if a data.table has a key assigned.

```{r}
haskey(MTCarsDT)
```

And our old friend `tables()` will also tell us any keyed columns in any data.table in the global environment.

```{r}
tables()
```


## Returning specified columns - mult()

The `mult` command returns the row specified. The options are *first*, *last* and *all*. All is the default.
```{r, collapse=TRUE}
DT["X", mult="first"]
DT["X", mult="last"]
DT["X", mult="all"]
```
<br>

## Nomatch

<br>

If you search for a value that doesn't exist the data table will return with an NA row.

<br>
```{r}
DT[c("X", "D")]
```
<br>

However you can add the **nomatch** command and it won't include the NA row.

<br>
```{r}
DT[c("X", "D"), nomatch=0]
```

<br>

## Math Operations using setkey
<br>

Now we can perform specific operations on these rows that have been keyed. Like getting the mean hp for 6 cylinder cars.

```{r}
setkey(MTCarsDT, cyl)
MTCarsDT[.(6), mean(hp)]
```

<br>

And we can return mean hp for both 4 and 6 cylinder cars...

```{r}
MTCarsDT[.(c(4, 6)), mean(hp)]
```

<br>

## by=.EACHI

<br>

But what if we want the mean hp for 6 cylinder cars and the mean hp for 4 cylinder cars returned separately. Use the `by.=EACHI` command which will perform same operation separately for each entered value in the keyed column. For keyed columns that are characater data we can just enter a command like this example from DT:

```{r}
setkey(DT, V2)
DT[c("X", "B"), mean(V5), by=.EACHI]
```



This however returns an error:

<br>
`
MTCarsDT[c(4, 6), mean(hp), by=.EACHI]
`

<br>
The problem is that when subsetting a keyed column that has integer data, the data.table syntax assumes that `MTCarsDT[c(4, 6), mean(hp), by=.EACHI]` is referring to the 4th and 6th rows, not to all 4 cylinder and 6 cylinder cars.

For example this operation gives the mean of rows 4 and 6.

```{r}
MTCarsDT[c(4, 6), mean(hp)]
```
<br>

The solution is to put the `c(4,6)` into a list (see [List](#list) below) which works like this:

```{r}
MTCarsDT[.(c(4, 6)), mean(hp), by=.EACHI]
```
<br>

So while this works with character data:

* `DT[c("X", "B"), mean(V5), by=.EACHI]`

A list must be used for integer data:

* `MTCarsDT[.(c(4, 6)), mean(hp), by=.EACHI]`


<br>
Notice also that I used this same syntax above in [Math Operations using setkey](#math-operations-using-setkey)

<br>
<br>

## Using setkey() on Multiple Columns

<br>

We can key multiple columns, for example the cylinder and gear columns.
```{r}
setkey(MTCarsDT, cyl, gear)
```
<br>
And then print the rows with 4 cylinders and 5 gears
```{r}
MTCarsDT[.(4,5)]
```

<br>
Or 4 cylinders and 4 or 5 gears
```{r}
MTCarsDT[.(4,c(4,5))]
```

<br>
And then return the mean hp for 4 cylinder 4 gear cars and for 4 cylinder 5 gear cars.
```{r}
MTCarsDT[.(4, c(4,5)), mean(hp), by=.EACHI]
```
<br>



# N

<br>
`.N` displays the last row.
```{r}
MTCarsDT[.N]
```

<br>
`.N-1` displays the penultimate row and so on.
```{r, collapse=TRUE}
MTCarsDT[.N-1]
MTCarsDT[.N-4]
```

<br>
but `,.N` displays the number of rows

```{r}
MTCarsDT[,.N]
```

This can be handy if you want to display the largest value of a keyed row. For example, this will give the heaviest vehicle followed by the heaviest vehicles sorted by the number of cylinders.


```{r}
setkey(MTCarsDT, wt)
MTCarsDT[, wt[.N]]
MTCarsDT[, wt[.N], by=cyl]
```


# List

The `.()` command is the same as `list()`.

<div class="col2">
```{r}
head(MTCarsDT[,.(cyl, disp)])
head(MTCarsDT[,list(cyl, disp)])
```
</div>

<br>

We can use this list function to get the mean hp for each combination of gears and cylinders

```{r}
MTCarsDT[,mean(hp),.(cyl,gear)]
```
<br>

# SD - ie **S**ubset of **D**ata

<br>

So first we can set the key to the cylinders column in MTCarsDT.

```{r}
setkey(MTCarsDT, cyl)
MTCarsDT
```

Using .SD it will print all of the data above but group the data by the number of cylinders. This works even if there is no key. Notice that the cylinders column is missing. 
```{r}
MTCarsDT[,print(.SD), by = cyl]
```
<br>
And you can select all the data by cylinder.
```{r}
MTCarsDT[.(6),print(.SD), by="cyl"]
```

<br>

This prints the first and last row grouped by the number of cylinders in the data set.

```{r}
MTCarsDT[,.SD[c(1,.N)], by=cyl]
```
<br>

## lapply

Using lapply() we can perform a function on every column grouped by the number of cylinders.

```{r}
MTCarsDT[, lapply(.SD, mean), by=cyl]
```

<br>

## SDcols

<br>

We can select specifically the columns we want to calculate and display using `.SDcols`.
```{r}
MTCarsDT[, lapply(.SD,mean), by=cyl, .SDcols = c("wt","hp", "disp")]
```

<br>

Or we can use `.SDcols` to specify the column numbers that we want to display, although reference columns by number is frowned upon.

```{r}
MTCarsDT[, lapply(.SD,mean), by=cyl, .SDcols = 3:7]
```

<br>

And we can specify a several columns in a sequence by using `pasteO` as long as the columns are numbered sequentially.

```{r}
DT[,lapply(.SD,sum), by=V2, .SDcols = paste0("V",3:5)]
```
<br>

# Chaining multiple operations together

Chaining allows you to perform multiple functions in one statement.

<br>

This set of operations will print the mean horsepower for cars, grouped by cylinder, that have more than 100 hp. But this creates a new data.table and is unnecessary.

```{r, collapse=TRUE}
MTCarsDT2 <- MTCarsDT[, .(mean.hp = mean(hp)), by=cyl]
MTCarsDT2
MTCarsDT2[mean.hp > 100]
```
<br>

This is the easier way.

```{r}

MTCarsDT[, .(mean.hp = mean(hp)), by=cyl][mean.hp > 100]

```


# Set and looping in a data.table

Set can be used to assign values in a data.table. Normally the := operation is better but **set** yields faster results in a **for loop** than any other function, so if you must loop, use set().

[From inside-R](http://www.inside-r.org/packages/cran/data.table/docs/set):

> Since [.data.table incurs overhead to check the existence and type of arguments (for example), set() provides direct (but less flexible) assignment by reference with low overhead, appropriate for use inside a for loop. See examples. := is more flexible than set() because := is intended to be combined with i and by in single queries on large datasets.


Remember our friend DT?

```{r, collapse=TRUE}
DT
```
<br>

This is the syntax for set : `for (i in from:to) set(DT, row, column, new value)`

And this will renumber the V9 column:

```{r, collapse=TRUE}
for (i in 1:9) set(DT,i,"V9",i)
head(DT)
```

<br>

An example of the speed of using set.

```{r, collapse=TRUE}
m = matrix(1,nrow=100000,ncol=100)
DF = as.data.frame(m)
DT = as.data.table(m)
dim(DT)
```

Now we can run a speed test on the different methods of assigning the value of i to the i'th row of the first column.
```{r, collapse=TRUE, cache=TRUE}
system.time(for (i in 1:100000) DF[i,1] <- i)

system.time(for (i in 1:100000) DT[i,V1:=i])

system.time(for (i in 1:100000) set(DT,i,1L,i))
```
So you can see there are big speed advantages to using set() over the assignment operator <- or the assignment by reference operator := .
<br>

Also notice the the use of `1L` to select the first column in the set command of the final speed test. See [here](http://stackoverflow.com/questions/7014387/whats-the-difference-between-1l-and-1) and [here](https://cran.r-project.org/doc/manuals/R-lang.html#Constants) for a discussion of the use of 1 vs 1L for integers in R.

# Change column names using setnames()

<br>
The syntax is setnames(DT, "oldname", "newname")

```{r, collapse=TRUE}
colnames(MTCarsDT)
setnames(MTCarsDT, "hp", "horsepower")
colnames(MTCarsDT)
```

You can also change multiple columnames at the same time.

```{r}
setnames(MTCarsDT, c("cyl", "disp"), c("cylinders", "displacement"))
colnames(MTCarsDT)
```
<br>

# Changing column order - setcolorder()

We can create a new column order by

```{r}
MTCarsColumns <- c("drat","wt","qsec","vs","am","gear","carb","mpg","cylinders","displacement","horsepower")

setcolorder(MTCarsDT, MTCarsColumns)
MTCarsDT[1]
```
<br>

or by giving it a string of names

```{r}
setcolorder(MTCarsDT, c("mpg","cylinders","displacement","horsepower","drat","wt","qsec","vs","am","gear","carb"))
MTCarsDT[1]
```
<br>

# Unique

Unique returns a data.table where duplicate data, by keyed row, are removed. So here's a new data.table, notice that rows 3 and 12 are identical to rows 1 and 10 respectively.

```{r}
DT <- data.table(A = rep(1:3, each=4), B = rep(1:4, each=3),
                 C = rep(1:2, 6), key = "B")
DT
```

Using `duplicated` we can see that there are two rows `TRUE` that are identical to other rows that have already been displayed.

```{r}
duplicated(DT)
```

<br>

`Unique` will return a DT without the duplicates.

```{r}
unique(DT)
```

uniqueN returns the number of unique rows.

```{r}
uniqueN(DT)
```
<br>

# Additional Information {#additional_information}

More info and references:

* [Data Tables Github Wiki](https://github.com/Rdatatable/data.table/wiki)
* [What's the difference between `1L` and `1`?](http://stackoverflow.com/questions/7014387/whats-the-difference-between-1l-and-1)
* [R Language Definition: Constants](https://cran.r-project.org/doc/manuals/R-lang.html#Constants)
* [A data.table R tutorial by DataCamp: intro to DT[i, j, by]](http://www.r-bloggers.com/a-data-table-r-tutorial-by-datacamp-intro-to-dti-j-by/)
