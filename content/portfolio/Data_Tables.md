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

The [Data Table](https://github.com/Rdatatable/data.table/wiki) package inherits from [data frames](https://cran.r-project.org/doc/manuals/r-release/R-intro.html#Data-frames), both display tabular data and are a list of vectors of the same length.

Data tables can handle large data sets faster than data frames, however the [i,j,by] syntax can be a bit confusing.

This will explain how to:

* use the [Data Table](https://github.com/Rdatatable/data.table/wiki) syntax,
* select data by row and column,
* subset data by keyed column,
* perform functions on subsetted data.

<br>

# Table of Contents

1. [Create a Data Table](#create)
2. [List Data Tables](#list_data_tables)
3. [Intoduction to Data Table syntax [i, j, by]](#i_j_by)
4. [Select rows: DT[i]](#dti)
    * [Return Rows By Value](#return_rows_by_value)
5. [Select Columns: DT[,j]](#dtj)
    * [Performing functions on a column] (#perform_functions_on_column)
6. [Selecting Rows and Columns `DT[i,j]`] (#dtij)
7. [Perform A Function On A Column By The Value Of Another Column `DT[j,by]`](#dt_jby)
8. [Subset Rows, Select Columns, and Perform an Operation `DT[i,j,by]`](#dt_ijby)
10. [Return The Number of Objects .N] (#objects_N)
10. [Modifying Data.Tables DT[i,j := ]](#modifying_data_tables)
    * [Delete Columns] (#delete_columns)
12. [Using Setkey] (#setkey)
    * [key()] (#key)
    * [Returning specified rows - mult()] (#mult)
    * [Nomatch] (#nomatch)
    * [Math Operations Using Setkey] (#math_operations_using_setkey)
    * [by=.EACHI] (#by_eachi)
    * [Using Setkey on Multiple Columns] (#setkey_multiple_columns)
    * [N] (#N)
13. [List] (#list)
14. [SD (Subset of Data)](#sd)
    * [lapply](#SD_lapply)
    * [SDcols](#SDcols)
15. [Chaining Multiple Operations Together] (#chaining)
16. [Set And Looping In A Data Table] (#set_looping)
17. [Setnames - Change Column Names](#setnames)
18. [Setcolorder - Changing Column Order](#setcolorder)
19. [Unique - Removing Duplicate Rows](#unique)
20. [Additional Sources of Information] (#additional_sources)


<br>

# Create a data.table {#create}

The data.table command creates a data table in this format:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`data.table(NameColumn1 = (some_data), NameColumn2 = (some_other_data),...)`

This tutorial will use two data tables, one called **DT** with dummy data, and
another called **MTCarsDT** which contains the `mtcars` dataset from the
datasets package.

First create the **DT** data table:

```
> library(data.table)


> set.seed(45L)

> DT <- data.table(
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

And this is what it looks like:

```
> DT

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

<br>

Now create the MTCarsDT data table:

```
> MTCarsDT <- data.table(mtcars)
```

Which looks like this:

```
> head(MTCarsDT)

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

The `tables` function will list all tables in the global environment as well as their columns, and some extra summary information.

```
> tables()

##      NAME     NROW NCOL MB COLS
## [1,] DT         12    9  1 V1,V2,V3,V4,V5,V6,V7,V8,V9
## [2,] MTCarsDT   32   11  1 mpg,cyl,disp,hp,drat,wt,qsec,vs,am,gear,carb
##      KEY
## [1,]
## [2,]
## Total: 2MB
```

<br>

# Intoduction to Data Table syntax [i,&nbsp;j,&nbsp;by]{#i_j_by}

<br>

Data Tables allow you to find data and perform operations using the following
syntax:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DT[i, j, by]`

This means, “Take the data table `DT`, subset rows using `i`, then calculate
`j`, grouped by`by`.” This is similar to SQL syntax where *i* corresponds to
SELECT, *j* corresponds to WHERE, and *by* corresponds to GROUP BY.

<br>
<br>

# Select rows: `DT[i]` {#dti}

<br>

To start with we'll select rows.

Start by selecting the 3rd row:
```
> MTCarsDT[3]

##     mpg cyl disp hp drat   wt  qsec vs am gear carb
## 1: 22.8   4  108 93 3.85 2.32 18.61  1  1    4    1
```

The 3rd through 5th rows:

```
> MTCarsDT[3:5]

##     mpg cyl disp  hp drat    wt  qsec vs am gear carb
## 1: 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## 2: 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## 3: 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
```

And the 3rd and 5th through 8th rows:

```
> MTCarsDT[c(3,5:8)]

##     mpg cyl  disp  hp drat   wt  qsec vs am gear carb
## 1: 22.8   4 108.0  93 3.85 2.32 18.61  1  1    4    1
## 2: 18.7   8 360.0 175 3.15 3.44 17.02  0  0    3    2
## 3: 18.1   6 225.0 105 2.76 3.46 20.22  1  0    3    1
## 4: 14.3   8 360.0 245 3.21 3.57 15.84  0  0    3    4
## 5: 24.4   4 146.7  62 3.69 3.19 20.00  1  0    4    2

```
<br>
Notice that the previous command uses the combine function, **c()**, to list the different rows that will be printed. Without the combine function R will print the 3rd row for columns 5 through 8, like this:
```
> MTCarsDT[3,5:8]

##    drat   wt  qsec vs
## 1: 3.85 2.32 18.61  1
```
<br>

## Return Rows By Value {#return_rows_by_value}

You can return rows by the value of specific rows.

For example, return rows with 6 cylinder cars:

```
> MTCarsDT[cyl == 6]

##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3: 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## 4: 18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
## 5: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 6: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
## 7: 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```

Return rows with 4 and 6 cylinder cars:

```
> MTCarsDT[cyl %in% c(4,6)]

##    gear N
## 1:    4 4
## 2:    3 2
## 3:    5 1
```

Return rows with cars with 110 or 123 hp engines:
```
> MTCarsDT[hp %in% c(110,123)]

##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3: 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## 4: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 5: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
```
<br>

# Return Columns: `DT[,j]` {#dtj}

Use the following format to return columns:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DT[,j]`

For example, return the hp column as a vector:
```
> MTCarsDT[,hp]

## [1] 110 110 93 110 175 105 245 62 95 123 123 180 180 180 205 215 230 66 52 65
## [21] 97 150 150 245 175 66 91 113 264 175 335 109
```

To return a data table you have to use the list function.

This operation will print the first ten rows of the hp column as a data table:
```
> MTCarsDT[1:10,list(hp)]

##     hp
##  1: 110
##  2: 110
##  3:  93
##  4: 110
##  5: 175
##  6: 105
##  7: 245
##  8:  62
##  9:  95
##  10: 123
```


Note that the expression `.(hp)` is identical to `list(hp)`, the period is equivalent to the list function.

```
> MTCarsDT[1:10,.(hp)]

##     hp
##  1: 110
##  2: 110
##  3:  93
##  4: 110
##  5: 175
##  6: 105
##  7: 245
##  8:  62
##  9:  95
##  10: 123
```

Print multiple columns as a data.table:


```
> MTCarsDT[1:10,.(hp, cyl)]

##     hp cyl
##  1: 110   6
##  2: 110   6
##  3:  93   4
##  4: 110   6
##  5: 175   8
##  6: 105   6
##  7: 245   8
##  8:  62   4
##  9:  95   4
##  10: 123   6
```

<br>

You can also print columns by index number but this is generally a bad idea, **see the warning below**.

```
> MTCarsDT[1:5, 1:3]

##      mpg cyl disp
##  1: 21.0   6  160
##  2: 21.0   6  160
##  3: 22.8   4  108
##  4: 21.4   6  258
##  5: 18.7   8  360
```

```
> MTCarsDT[1:5, c(1:3,4,6)]

##      mpg cyl disp  hp    wt
##  1: 21.0   6  160 110 2.620
##  2: 21.0   6  160 110 2.875
##  3: 22.8   4  108  93 2.320
##  4: 21.4   6  258 110 3.215
##  5: 18.7   8  360 175 3.440
```

<br>

***

**WARNING**

Referring to columns by index number can create errors. If you reference a column by number and then add, move, or replace columns, the code may continue to execute but it will return incorrect results possibly without any warning. For this reason you should refer to columns by name rather than number.

***

<br>

## Performing functions on a column {#perform_functions_on_column}

You can execute functions on a column of data by putting the name of the column
inside of a function.

For example, this will return the mean of the `hp` column:
```
> MTCarsDT[,mean(hp)]

##  [1] 146.6875
```

This will return the mean of the `hp` column and the standard deviation of the
`mpg` column:
```
> MTCarsDT[,.(mean(hp), sd(mpg))]

##           V1       V2
##  1: 146.6875 6.026948
```

This is the same as operation above but it returns the results with different
names:
```
> MTCarsDT[,.(horsepower=mean(hp), milespergallon=sd(mpg))]

##     horsepower milespergallon
##  1:   146.6875       6.026948
```

This prints the `hp` column and repeats the values of the standard deviation and mean of the `hp` column. The head function prints only the first six rows. Compare this operation with next operation which selects the first six rows within the brackets.
```
> head(MTCarsDT[,.(hp, SD_HP=sd(hp), Mean_HP=mean(hp))])

##      hp    SD_HP  Mean_HP
##  1: 110 68.56287 146.6875
##  2: 110 68.56287 146.6875
##  3:  93 68.56287 146.6875
##  4: 110 68.56287 146.6875
##  5: 175 68.56287 146.6875
##  6: 105 68.56287 146.6875
```

Notice here that the numbers for standard deviation and mean are different in this function below. This returns only the mean and standard deviation for the `hp` column for the **first six columns only**.

```
> MTCarsDT[1:6,.(hp, SD_HP=sd(hp), Mean_HP=mean(hp))]

##      hp    SD_HP  Mean_HP
##  1: 110 29.08894 117.1667
##  2: 110 29.08894 117.1667
##  3:  93 29.08894 117.1667
##  4: 110 29.08894 117.1667
##  5: 175 29.08894 117.1667
##  6: 105 29.08894 117.1667
```

***

<br>
You can use `apply()` on a data.table to apply a function to each column:
```
> sapply(MTCarsDT, class)

##        mpg       cyl      disp        hp      drat        wt      qsec        vs        am      gear      carb
##  "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric"
```


Use curly braces to perform multiple functions in one function call. Notice that the separate functions must be placed on separate lines or be separated by semicolons.

```
> MTCarsDT[, {print(disp); plot(mpg, wt); sapply(MTCarsDT, mean)}]

##   [1] 160.0 160.0 108.0 258.0 360.0 225.0 360.0 146.7 140.8 167.6 167.6 275.8 275.8
##  [14] 275.8 472.0 460.0 440.0  78.7  75.7 71.1 120.1 318.0 304.0 350.0 400.0
##  [27] 79.0 120.3  95.1 351.0 145.0 301.0 121.0
##         mpg        cyl       disp         hp       drat         wt       qsec
##   20.090625   6.187500 230.721875 146.687500   3.596563   3.217250  17.848750
##          vs         am       gear       carb
##    0.437500   0.406250   3.687500   2.812500
```
![](/portfolio/Data_Tables_files/MTCarsDT_plot.png)

<br>

# Selecting Rows and Columns `DT[i,j]` {#dtij}

You can select data from a data table by both row and column using the `DT[i,j]` syntax.

This will print rows 1:5 but only the hp, weight, and mpg columns.
```
> MTCarsDT[1:5, .(hp,wt,mpg)]

##      hp    wt  mpg
##  1: 110 2.620 21.0
##  2: 110 2.875 21.0
##  3:  93 2.320 22.8
##  4: 110 3.215 21.4
##  5: 175 3.440 18.7
```

This will return cylinders, hp, mean hp and mpg for 6 cylinder cars.

```
> MTCarsDT[cyl == 6,.(cyl,hp,MeanHorsepower = mean(hp),mpg)]

##     cyl  hp MeanHorsepower  mpg
##  1:   6 110       122.2857 21.0
##  2:   6 110       122.2857 21.0
##  3:   6 110       122.2857 21.4
##  4:   6 105       122.2857 18.1
##  5:   6 123       122.2857 19.2
##  6:   6 123       122.2857 17.8
##  7:   6 175       122.2857 19.7
```

Note that the mean horsepower shown above is *only* for 6 cylinder cars and doesn't include 4 and 8 cylinder cars. The function below shows the mean horsepower for cars of all engine sizes.

```
MTCarsDT[,mean(hp)]

##  [1] 146.6875
```

<br>

# Perform A Function On A Column By The Value Of Another Column `DT[,j,by]` {#dt_jby}

<br>

This gives the mean horsepower for cars by number of cylinders.

```
MTCarsDT[,.(MeanHP = mean(hp)), by=cyl]

##     cyl    MeanHP
##  1:   6 122.28571
##  2:   4  82.63636
##  3:   8 209.21429
```

This will give mean time in seconds for 1/4 mile race by both gears and cylinders.

```
MTCarsDT[,.(MeanQuarterMile = mean(qsec)), by=.(cyl,gear)]

##     cyl gear MeanQuarterMile
##  1:   6    4         17.6700
##  2:   4    4         19.6125
##  3:   6    3         19.8300
##  4:   8    3         17.1425
##  5:   4    3         20.0100
##  6:   4    5         16.8000
##  7:   8    5         14.5500
##  8:   6    5         15.5000
```

<br>

# Subset Rows, Select Columns, and Perform an Operation `DT[i,j,by]` {#dt_ijby}

Now we can put all the operations together and perform a function on a subset of rows and columns.

This will give the mean hp for cars with 4 gears grouped by the number cylinders:

```
MTCarsDT[gear == 4,.(Mean_HP = mean(hp)), by=cyl]

##     cyl Mean_HP
##  1:   6   116.5
##  2:   4    76.0
```

<br>

# Count The Number of Objects `.N` {#objects_N}

`.N` is a variable that will return the number of instances.


This gives a total count of the number of rows in the dataset:
```
MTCarsDT[,.N]

## [1] 32
```

This returns a count of the number of cars grouped by the number of gears they might have:
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

This performs the same function:
```
MTCarsDT[cyl == 6,table(gear)]

##  gear
##   3  4  5
##   2  4  1
```

<br>

# Modify Data Tables `DT[i,j := ]` {#modifying_data_tables}

<br>

The `:=` operator updates columns and does so invisibly. That is to say, when you use `:=` it doesn't print a result unless you explicitly tell it to. The := operator makes the assignment operator (`DT <- DT[.....]`) unnecessary because it is significantly faster than the assignment operator. [For more on :=](https://www.rdocumentation.org/packages/data.table/versions/1.11.4/topics/%3A%3D).

```
DT[,V8]

## [1] 121 122 123 124 125 126 127 128 129 130 131 132


DT[, V8 := 1:12]
DT[, V8]

## [1]  1  2  3  4  5  6  7  8  9 10 11 12
```

Adding brackets (`[]`) to the end of the operation will print the result automatically.

```
DT[, V8 := round(exp(V3),2)][]

## [1] 1.93 0.25 0.37 1.48 1.93 0.25 0.37 1.48 1.93 0.25 0.37 1.48
```

Replace NA's in V9 column with 0:

```
DT[,V9]

## [1] NA  1  2  3 NA  1  2  3 NA  1  2  3
```

```
DT[is.na(V9), V9 := 0][]

## [1] 0 1 2 3 0 1 2 3 0 1 2 3
```


Columns V6 and V7 are updated with the results of the functions after the := operator.
```
DT[,.(V6,V7)]

##     V6  V7
##  1:  A 101
##  2:  B 102
##  3:  C 103
##  4:  D 104
##  5:  E 105
##  6:  F 106
##  7:  G 107
##  8:  H 108
##  9:  I 109
## 10:  J 110
## 11:  K 111
## 12:  L 112


DT[, c("V6","V7") := .(LETTERS [3:5], round(exp(V1),2))][]

##     V1 V2      V3 V4 V5 V6   V7 V8 V9
##  1:  1  A  0.6581  1 21  C 2.72  1  0
##  2:  2  B -1.4012  2 22  D 7.39  2  1
##  3:  1  C -1.0002  3 23  E 2.72  3  2
##  4:  2  A  0.3930  4 24  C 7.39  4  3
##  5:  1  B  0.6581  5 25  D 2.72  5  0
##  6:  2  C -1.4012  6 26  E 7.39  6  1
##  7:  1  A -1.0002  7 27  C 2.72  7  2
##  8:  2  B  0.3930  8 28  D 7.39  8  3
##  9:  1  C  0.6581  9 29  E 2.72  9  0
## 10:  2  A -1.4012 10 30  C 7.39 10  1
## 11:  1  B -1.0002 11 31  D 2.72 11  2
## 12:  2  C  0.3930 12 32  E 7.39 12  3
```

## Delete Columns {#delete_columns}

This will delete the V1 column.
```
DT[, V1 := NULL][]

    V2      V3 V4 V5 V6   V7 V8 V9
 1:  A  0.6581  1 21  C 2.72  1  0
 2:  B -1.4012  2 22  D 7.39  2  1
 3:  C -1.0002  3 23  E 2.72  3  2
 4:  A  0.3930  4 24  C 7.39  4  3
 5:  B  0.6581  5 25  D 2.72  5  0
 6:  C -1.4012  6 26  E 7.39  6  1
 7:  A -1.0002  7 27  C 2.72  7  2
 8:  B  0.3930  8 28  D 7.39  8  3
 9:  C  0.6581  9 29  E 2.72  9  0
10:  A -1.4012 10 30  C 7.39 10  1
11:  B -1.0002 11 31  D 2.72 11  2
12:  C  0.3930 12 32  E 7.39 12  3
```

And this will delete the V7 and V8 columns.

```
DT[, c("V7","V8") := NULL][]

##     V2      V3 V4 V5 V6 V9
##  1:  A -0.9712  1 21  C  0
##  2:  B  0.8338  2 22  D  1
##  3:  C  0.2974  3 23  E  2
##  4:  A  0.9116  4 24  C  3
##  5:  B -0.9712  5 25  D  0
##  6:  C  0.8338  6 26  E  1
##  7:  A  0.2974  7 27  C  2
##  8:  B  0.9116  8 28  D  3
##  9:  C -0.9712  9 29  E  0
## 10:  A  0.8338 10 30  C  1
## 11:  B  0.2974 11 31  D  2
## 12:  C  0.9116 12 32  E  3
```

Find the rows in column V2 that are equal to **A** and assign X to them:

```
DT[V2 == "A", V2 := "X"][]

##     V2      V3 V4 V5 V6 V9
##  1:  X -0.9712  1 21  C  0
##  2:  B  0.8338  2 22  D  1
##  3:  C  0.2974  3 23  E  2
##  4:  X  0.9116  4 24  C  3
##  5:  B -0.9712  5 25  D  0
##  6:  C  0.8338  6 26  E  1
##  7:  X  0.2974  7 27  C  2
##  8:  B  0.9116  8 28  D  3
##  9:  C -0.9712  9 29  E  0
## 10:  X  0.8338 10 30  C  1
## 11:  B  0.2974 11 31  D  2
## 12:  C  0.9116 12 32  E  3
```

Add columns V7 and V8 back:

```
DT[,c("V7","V8") := .(101:112,121:132)][]

##     V2      V3 V4 V5 V6 V9  V7  V8
##  1:  X -0.9712  1 21  C  0 101 121
##  2:  B  0.8338  2 22  D  1 102 122
##  3:  C  0.2974  3 23  E  2 103 123
##  4:  X  0.9116  4 24  C  3 104 124
##  5:  B -0.9712  5 25  D  0 105 125
##  6:  C  0.8338  6 26  E  1 106 126
##  7:  X  0.2974  7 27  C  2 107 127
##  8:  B  0.9116  8 28  D  3 108 128
##  9:  C -0.9712  9 29  E  0 109 129
## 10:  X  0.8338 10 30  C  1 110 130
## 11:  B  0.2974 11 31  D  2 111 131
## 12:  C  0.9116 12 32  E  3 112 132
```


# Using Setkey {#setkey}

<br>

Setkey does three things:

1. It reorders the rows of the data.table by the keyed column in increasing order.

2. It marks the keyed column in the data table.

3. It allows you to easily search through that column.


First, this operation keys the V2 column in this data table and it sorts the data table into alphabetical order by the keyed column.
```
setkey(DT,V2)
DT

##     V2      V3 V4 V5 V6 V9  V7  V8
##  1:  B -0.0486  2 22  D  1 102 122
##  2:  B  0.4519  5 25  D  0 105 125
##  3:  B  0.6997  8 28  D  3 108 128
##  4:  B -0.2843 11 31  D  2 111 131
##  5:  C -0.2843  3 23  E  2 103 123
##  6:  C -0.0486  6 26  E  1 106 126
##  7:  C  0.4519  9 29  E  0 109 129
##  8:  C  0.6997 12 32  E  3 112 132
##  9:  X  0.4519  1 21  C  0 101 121
## 10:  X  0.6997  4 24  C  3 104 124
## 11:  X -0.2843  7 27  C  2 107 127
## 12:  X -0.0486 10 30  C  1 110 130
```

<br>

This will search for the value of **B** in the keyed column.

```
DT["B"]

##    V2      V3 V4 V5 V6 V9  V7  V8
## 1:  B -0.0486  2 22  D  1 102 122
## 2:  B  0.4519  5 25  D  0 105 125
## 3:  B  0.6997  8 28  D  3 108 128
## 4:  B -0.2843 11 31  D  2 111 131
```

The combine function, `c()`, allows you to search for two values in the keyed column at the same time.

```
DT[c("B", "X")]

##   V2      V3 V4 V5 V6 V9  V7  V8
## 1:  B -0.0486  2 22  D  1 102 122
## 2:  B  0.4519  5 25  D  0 105 125
## 3:  B  0.6997  8 28  D  3 108 128
## 4:  B -0.2843 11 31  D  2 111 131
## 5:  X  0.4519  1 21  C  0 101 121
## 6:  X  0.6997  4 24  C  3 104 124
## 7:  X -0.2843  7 27  C  2 107 127
## 8:  X -0.0486 10 30  C  1 110 130
```

<br>

## key() {#key}

`key()` indicates which column, if any, are set as the keyed column.
```
key(DT)

## [1] "V2"
```

`haskey()` will return TRUE or FALSE if a data.table has a key assigned.

```
haskey(MTCarsDT)

## [1] FALSE
```

The last column returned by the `tables()` function will also indicate if any data tables in the global environment have keyed columns.

```
tables()

       NAME NROW NCOL MB                        COLS KEY
1:       DT   12    8  0       V2,V3,V4,V5,V6,V9,...  V2
2: MTCarsDT   32   11  0 mpg,cyl,disp,hp,drat,wt,...
Total: 0MB
```

<br>

## Returning specified rows - mult() {#mult}

The `mult` command returns the row specified. The options are *first*, *last* and *all*. All is the default:

```
DT["X", mult="first"]

##    V2     V3 V4 V5 V6 V9  V7  V8
## 1:  X 0.4519  1 21  C  0 101 121

DT["X", mult="last"]

##    V2      V3 V4 V5 V6 V9  V7  V8
## 1:  X -0.0486 10 30  C  1 110 130

DT["X", mult="all"]

##    V2      V3 V4 V5 V6 V9  V7  V8
## 1:  X  0.4519  1 21  C  0 101 121
## 2:  X  0.6997  4 24  C  3 104 124
## 3:  X -0.2843  7 27  C  2 107 127
## 4:  X -0.0486 10 30  C  1 110 130
```

<br>

## Nomatch {#nomatch}

If you search for a value that doesn't exist the data table will return with an NA row.

```
DT[c("X", "D")]

##    V2      V3 V4 V5   V6 V9  V7  V8
## 1:  X  0.4519  1 21    C  0 101 121
## 2:  X  0.6997  4 24    C  3 104 124
## 3:  X -0.2843  7 27    C  2 107 127
## 4:  X -0.0486 10 30    C  1 110 130
## 5:  D      NA NA NA <NA> NA  NA  NA
```


However you can add the **nomatch** command and it won't include the NA row.


```
DT[c("X", "D"), nomatch=0]

##    V2      V3 V4 V5   V6 V9  V7  V8
## 1:  X  0.4519  1 21    C  0 101 121
## 2:  X  0.6997  4 24    C  3 104 124
## 3:  X -0.2843  7 27    C  2 107 127
## 4:  X -0.0486 10 30    C  1 110 130
```

<br>

## Math Operations Using Setkey {#math_operations_using_setkey}
<br>

Setkey allows you to perform operations on rows that have been keyed. This will get the mean hp for 6 cylinder cars and the mean horsepower for 4 and 6 cylinder cars.

```
setkey(MTCarsDT, cyl)
MTCarsDT[.(6), mean(hp)]

## [1] 122.2857

MTCarsDT[.(c(4, 6)), mean(hp)]

## [1] 98.05556
```

<br>

## by=.EACHI {#by_eachi}

To return the mean **hp** for 4 and 6 cylinder cars separately use the `by=.EACHI` command. This will perform the same operation separately for each value in the keyed column. Notice that numerical data requires the list command:

```
MTCarsDT[.(c(4,6)), mean(hp), by=.EACHI]

##    cyl        V1
## 1:   4  82.63636
## 2:   6 122.28571
```

<br>

## Using setkey() on Multiple Columns {#setkey_multiple_columns}

You can key multiple columns, for example the cylinder and gear columns.

```
setkey(MTCarsDT, cyl, gear)
```
And then print the rows with 6 cylinders and 5 gears:

```
MTCarsDT[.(6,5)]

##     mpg cyl  disp  hp drat    wt qsec vs am gear carb
## 1: 19.7   6  145 175 3.62 2.77 15.5  0  1    5    6
```

Or 6 cylinders and 4 or 5 gears:

```
MTCarsDT[.(6,c(4,5))]

##     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## 3: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## 4: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
## 5: 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
```


And then return the mean horsepower for 4 cylinder 4 gear cars and for 4 cylinder 5 gear cars:

```
MTCarsDT[.(4, c(4,5)), mean(hp), by=.EACHI]

##    cyl gear  V1
## 1:   4    4  76
## 2:   4    5 102
```

<br>

# N {#N}


`.N` displays the last row.
```
MTCarsDT[.N]

##    mpg cyl disp  hp drat   wt qsec vs am gear carb
## 1:  15   8  301 335 3.54 3.57 14.6  0  1    5    8
```


`.N-1` displays the penultimate row and so on.
```
MTCarsDT[.N-4]

##     mpg cyl disp  hp drat    wt qsec vs am gear carb
## 1: 15.2   8  304 150 3.15 3.435 17.3  0  0    3    2
```

<br>

but `,.N` displays the number of rows

```{r}
MTCarsDT[,.N]

## [1] 32
```

This can be handy if you want to display the largest value of a keyed row. The first operation will give the heaviest vehicle and the second will give the heaviest vehicles sorted by the number of cylinders.

```
setkey(MTCarsDT, wt)
MTCarsDT[, wt[.N]]

## [1] 5.424

MTCarsDT[, wt[.N], by=cyl]

##    cyl    V1
## 1:   4 3.190
## 2:   6 3.460
## 3:   8 5.424
```


# List {#list}

The `.()` command is the same as `list()`.

The `list` command ensures that a data table is returned and not a vector.

```
## MTCarsDT[1:5,.(cyl, disp)]
##    cyl  disp
## 1:   4  95.1
## 2:   4  75.7
## 3:   4  71.1
## 4:   4  79.0
## 5:   4 120.3
```

Use the `list` function to return the mean horsepower for each combination of
gears and cylinders:

```
MTCarsDT[,mean(hp),.(cyl,gear)]

##    cyl gear       V1
## 1:   4    5 102.0000
## 2:   4    4  76.0000
## 3:   4    3  97.0000
## 4:   6    4 116.5000
## 5:   6    5 175.0000
## 6:   8    5 299.5000
## 7:   6    3 107.5000
## 8:   8    3 194.1667
```

<br>

# SD (**S**ubset of **D**ata) {#sd}

SD stands for **Subset** of **Data**. `SD` will create a subsetted data table grouped by the `by` statement.

This operation will return the **MTCarsDT** sorted first by number of cylinders and then by horsepower.
```
> setkey(MTCarsDT, hp)
> MTCarsDT[,.SD, by=cyl]

##    cyl  mpg  disp  hp drat    wt  qsec vs am gear carb
##  1:   4 30.4  75.7  52 4.93 1.615 18.52  1  1    4    2
##  2:   4 24.4 146.7  62 3.69 3.190 20.00  1  0    4    2
##  3:   4 33.9  71.1  65 4.22 1.835 19.90  1  1    4    1
##  4:   4 27.3  79.0  66 4.08 1.935 18.90  1  1    4    1
##  5:   4 32.4  78.7  66 4.08 2.200 19.47  1  1    4    1
##  6:   4 26.0 120.3  91 4.43 2.140 16.70  0  1    5    2
##  7:   4 22.8 108.0  93 3.85 2.320 18.61  1  1    4    1
##  8:   4 22.8 140.8  95 3.92 3.150 22.90  1  0    4    2
##  9:   4 21.5 120.1  97 3.70 2.465 20.01  1  0    3    1
## 10:   4 21.4 121.0 109 4.11 2.780 18.60  1  1    4    2
## 11:   4 30.4  95.1 113 3.77 1.513 16.90  1  1    5    2
## 12:   6 18.1 225.0 105 2.76 3.460 20.22  1  0    3    1
## 13:   6 21.4 258.0 110 3.08 3.215 19.44  1  0    3    1
## 14:   6 21.0 160.0 110 3.90 2.620 16.46  0  1    4    4
## 15:   6 21.0 160.0 110 3.90 2.875 17.02  0  1    4    4
## 16:   6 19.2 167.6 123 3.92 3.440 18.30  1  0    4    4
## 17:   6 17.8 167.6 123 3.92 3.440 18.90  1  0    4    4
## 18:   6 19.7 145.0 175 3.62 2.770 15.50  0  1    5    6
## 19:   8 15.5 318.0 150 2.76 3.520 16.87  0  0    3    2
## 20:   8 15.2 304.0 150 3.15 3.435 17.30  0  0    3    2
## 21:   8 19.2 400.0 175 3.08 3.845 17.05  0  0    3    2
## 22:   8 18.7 360.0 175 3.15 3.440 17.02  0  0    3    2
## 23:   8 16.4 275.8 180 3.07 4.070 17.40  0  0    3    3
## 24:   8 17.3 275.8 180 3.07 3.730 17.60  0  0    3    3
## 25:   8 15.2 275.8 180 3.07 3.780 18.00  0  0    3    3
## 26:   8 10.4 472.0 205 2.93 5.250 17.98  0  0    3    4
## 27:   8 10.4 460.0 215 3.00 5.424 17.82  0  0    3    4
## 28:   8 14.7 440.0 230 3.23 5.345 17.42  0  0    3    4
## 29:   8 14.3 360.0 245 3.21 3.570 15.84  0  0    3    4
## 30:   8 13.3 350.0 245 3.73 3.840 15.41  0  0    3    4
## 31:   8 15.8 351.0 264 4.22 3.170 14.50  0  1    5    4
## 32:   8 15.0 301.0 335 3.54 3.570 14.60  0  1    5    8
##     cyl  mpg  disp  hp drat    wt  qsec vs am gear carb
```

Using `.SD` with `print` will return all of the data above, but group the data by the number of cylinders. This works even if there is no keyed column. Also, notice that it doesn't print the cylinders column.

```
> MTCarsDT[,print(.SD), by = cyl]

##      mpg  disp  hp drat    wt  qsec vs am gear carb
##  1: 30.4  75.7  52 4.93 1.615 18.52  1  1    4    2
##  2: 24.4 146.7  62 3.69 3.190 20.00  1  0    4    2
##  3: 33.9  71.1  65 4.22 1.835 19.90  1  1    4    1
##  4: 27.3  79.0  66 4.08 1.935 18.90  1  1    4    1
##  5: 32.4  78.7  66 4.08 2.200 19.47  1  1    4    1
##  6: 26.0 120.3  91 4.43 2.140 16.70  0  1    5    2
##  7: 22.8 108.0  93 3.85 2.320 18.61  1  1    4    1
##  8: 22.8 140.8  95 3.92 3.150 22.90  1  0    4    2
##  9: 21.5 120.1  97 3.70 2.465 20.01  1  0    3    1
## 10: 21.4 121.0 109 4.11 2.780 18.60  1  1    4    2
## 11: 30.4  95.1 113 3.77 1.513 16.90  1  1    5    2
##     mpg  disp  hp drat    wt  qsec vs am gear carb
## 1: 18.1 225.0 105 2.76 3.460 20.22  1  0    3    1
## 2: 21.4 258.0 110 3.08 3.215 19.44  1  0    3    1
## 3: 21.0 160.0 110 3.90 2.620 16.46  0  1    4    4
## 4: 21.0 160.0 110 3.90 2.875 17.02  0  1    4    4
## 5: 19.2 167.6 123 3.92 3.440 18.30  1  0    4    4
## 6: 17.8 167.6 123 3.92 3.440 18.90  1  0    4    4
## 7: 19.7 145.0 175 3.62 2.770 15.50  0  1    5    6
##      mpg  disp  hp drat    wt  qsec vs am gear carb
##  1: 15.5 318.0 150 2.76 3.520 16.87  0  0    3    2
##  2: 15.2 304.0 150 3.15 3.435 17.30  0  0    3    2
##  3: 19.2 400.0 175 3.08 3.845 17.05  0  0    3    2
##  4: 18.7 360.0 175 3.15 3.440 17.02  0  0    3    2
##  5: 16.4 275.8 180 3.07 4.070 17.40  0  0    3    3
##  6: 17.3 275.8 180 3.07 3.730 17.60  0  0    3    3
##  7: 15.2 275.8 180 3.07 3.780 18.00  0  0    3    3
##  8: 10.4 472.0 205 2.93 5.250 17.98  0  0    3    4
##  9: 10.4 460.0 215 3.00 5.424 17.82  0  0    3    4
## 10: 14.7 440.0 230 3.23 5.345 17.42  0  0    3    4
## 11: 14.3 360.0 245 3.21 3.570 15.84  0  0    3    4
## 12: 13.3 350.0 245 3.73 3.840 15.41  0  0    3    4
## 13: 15.8 351.0 264 4.22 3.170 14.50  0  1    5    4
## 14: 15.0 301.0 335 3.54 3.570 14.60  0  1    5    8
## Empty data.table (0 rows) of 1 col: cyl
```

And you can subset the data by cylinder by adding an `i` statement, or by keying cylinders and using the list function.

```
> MTCarsDT[cyl == 6,print(.SD), by="cyl"]

##     mpg  disp  hp drat    wt  qsec vs am gear carb
## 1: 18.1 225.0 105 2.76 3.460 20.22  1  0    3    1
## 2: 21.0 160.0 110 3.90 2.620 16.46  0  1    4    4
## 3: 21.0 160.0 110 3.90 2.875 17.02  0  1    4    4
## 4: 21.4 258.0 110 3.08 3.215 19.44  1  0    3    1
## 5: 19.2 167.6 123 3.92 3.440 18.30  1  0    4    4
## 6: 17.8 167.6 123 3.92 3.440 18.90  1  0    4    4
## 7: 19.7 145.0 175 3.62 2.770 15.50  0  1    5    6
## Empty data.table (0 rows) of 1 col: cyl
```

```
> setkey(MTCarsDT, cyl)
> MTCarsDT[.(6),print(.SD), by="cyl"]

##     mpg  disp  hp drat    wt  qsec vs am gear carb
## 1: 18.1 225.0 105 2.76 3.460 20.22  1  0    3    1
## 2: 21.0 160.0 110 3.90 2.620 16.46  0  1    4    4
## 3: 21.0 160.0 110 3.90 2.875 17.02  0  1    4    4
## 4: 21.4 258.0 110 3.08 3.215 19.44  1  0    3    1
## 5: 19.2 167.6 123 3.92 3.440 18.30  1  0    4    4
## 6: 17.8 167.6 123 3.92 3.440 18.90  1  0    4    4
## 7: 19.7 145.0 175 3.62 2.770 15.50  0  1    5    6
## Empty data.table (0 rows) of 1 col: cyl
```

To print the highest and lowest horsepower vehicle sorted by the number of cylinders, first key by horsepower, then use `SD` to print the first and last of row by cylinder:
```
> setkey(MTCarsDT, hp)
> MTCarsDT[,.SD[c(1,.N)], by=cyl]

##    cyl  mpg  disp  hp drat    wt  qsec vs am gear carb
## 1:   4 30.4  75.7  52 4.93 1.615 18.52  1  1    4    2
## 2:   4 30.4  95.1 113 3.77 1.513 16.90  1  1    5    2
## 3:   6 18.1 225.0 105 2.76 3.460 20.22  1  0    3    1
## 4:   6 19.7 145.0 175 3.62 2.770 15.50  0  1    5    6
## 5:   8 15.2 304.0 150 3.15 3.435 17.30  0  0    3    2
## 6:   8 15.0 301.0 335 3.54 3.570 14.60  0  1    5    8
```
<br>

## lapply {#SD_lapply}

With `lapply` you can perform a function on every column grouped by the number of cylinders.

```
> MTCarsDT[, lapply(.SD, mean), by=cyl]
##    cyl      mpg     disp        hp     drat       wt     qsec        vs        am     gear     carb
## 1:   4 26.66364 105.1364  82.63636 4.070909 2.285727 19.13727 0.9090909 0.7272727 4.090909 1.545455
## 2:   6 19.74286 183.3143 122.28571 3.585714 3.117143 17.97714 0.5714286 0.4285714 3.857143 3.428571
## 3:   8 15.10000 353.1000 209.21429 3.229286 3.999214 16.77214 0.0000000 0.1428571 3.285714 3.500000
```

<br>

## SDcols {#SDcols}

You can select specific columns using `.SDcols`.

```
> MTCarsDT[, lapply(.SD,mean), by=cyl, .SDcols = c("wt","hp", "disp")]

##    cyl       wt        hp     disp
## 1:   4 2.285727  82.63636 105.1364
## 2:   6 3.117143 122.28571 183.3143
## 3:   8 3.999214 209.21429 353.1000
```
<br>

You can also specify the column numbers that you want to display.

```
> MTCarsDT[, lapply(.SD,mean), by=cyl, .SDcols = 3:7]

##    cyl     disp        hp     drat       wt     qsec
## 1:   4 105.1364  82.63636 4.070909 2.285727 19.13727
## 2:   6 183.3143 122.28571 3.585714 3.117143 17.97714
## 3:   8 353.1000 209.21429 3.229286 3.999214 16.77214
```

<br>

# Chaining multiple operations together {#chaining}

Chaining allows you to perform multiple functions in one statement.

Without chaining these two operations will:

1. return the mean horsepower for cars, grouped by cylinder,
2. and then return those means with more than 100 hp.

```
> MTCarsDT2 <- MTCarsDT[, .(mean.hp = mean(hp)), by=cyl]
> MTCarsDT2

##    cyl   mean.hp
## 1:   4  82.63636
## 2:   6 122.28571
## 3:   8 209.21429

> MTCarsDT2[mean.hp > 100]

##    cyl  mean.hp
## 1:   6 122.2857
## 2:   8 209.2143
```

This can be done in one operation and on one line with chaining.

```
> MTCarsDT[, .(mean.hp = mean(hp)), by=cyl][mean.hp > 100]

##    cyl  mean.hp
## 1:   6 122.2857
## 2:   8 209.2143
```

More than two operations can be chained together. This will return 6 cylinder cars; calculate the mean horsepower sorted by gears, carburetors, and whether they're automatic or manual; select only cars with 4 gears; and then return cars that are manual transmission. *(manual = 1, automatic = 0)*

```
> MTCarsDT[cyl ==6][,.(mean.hp=mean(hp)), by = .(gear,carb, am)][gear == 4][am==1]

##    gear carb am mean.hp
## 1:    4    4  1     110
```

<br>

# Set and looping in a data.table {#set_looping}

`Set` can be used to assign values in a data.table. Normally the `:=` operation is better, but `set` yields faster results in a for loop than any other function, so if you want to create a for loop, use `set`.

This is the syntax for set : `for (i in from:to) set(DT, row, column, new value)`

In this example we'll replace the values in the V8 column with the numbers 1-12.
Here's the DT dataset:

```
> DT

##    V2      V3 V4 V5 V6 V9  V7  V8
##  1:  X -1.9649  1 21  C  0 101 121
##  2:  B  0.2992  2 22  D  1 102 122
##  3:  C -0.6450  3 23  E  2 103 123
##  4:  X -0.4986  4 24  C  3 104 124
##  5:  B -1.9649  5 25  D  0 105 125
##  6:  C  0.2992  6 26  E  1 106 126
##  7:  X -0.6450  7 27  C  2 107 127
##  8:  B -0.4986  8 28  D  3 108 128
##  9:  C -1.9649  9 29  E  0 109 129
## 10:  X  0.2992 10 30  C  1 110 130
## 11:  B -0.6450 11 31  D  2 111 131
## 12:  C -0.4986 12 32  E  3 112 132
```

This will renumber the V8 column:

```
> for (i in 1:12) set(DT,i,"V8",i)
> DT

##     V2      V3 V4 V5 V6 V9  V7 V8
##  1:  X -1.8123  1 21  C  1 101  1
##  2:  B  0.2134  2 22  D  2 102  2
##  3:  C -0.2825  3 23  E  3 103  3
##  4:  X -0.3802  4 24  C  4 104  4
##  5:  B -1.8123  5 25  D  5 105  5
##  6:  C  0.2134  6 26  E  6 106  6
##  7:  X -0.2825  7 27  C  7 107  7
##  8:  B -0.3802  8 28  D  8 108  8
##  9:  C -1.8123  9 29  E  9 109  9
## 10:  X  0.2134 10 30  C  1 110 10
## 11:  B -0.2825 11 31  D  2 111 11
## 12:  C -0.3802 12 32  E  3 112 12
```

<br>

This example shows the speed of using `set` in a for loop.

First, create a matrix, a data frame, and a data table, each with 100,000 rows and 100 columns.

```
m = matrix(1,nrow=100000,ncol=100)
DF = as.data.frame(m)
DT = as.data.table(m)
```

Now run a speed test on the different methods of assigning the value of *i* to the *i*'th row of the first column.
```
> system.time(for (i in 1:100000) m[i,1] <- i)
   user  system elapsed
  0.015   0.003   0.019

> system.time(for (i in 1:100000) DF[i,1] <- i)
   user  system elapsed
 49.487  44.195  94.792

> system.time(for (i in 1:100000) DT[i,1] <- i)
   user  system elapsed
457.258 290.126 757.099

> system.time(for (i in 1:100000) DT[i,V1:=i])
   user  system elapsed
 27.656   0.096  28.228

> system.time(for (i in 1:100000) set(DT,i,1L,i))
   user  system elapsed
  0.237   0.030   0.268
```

You can see there are big speed advantages to using `set` over the assignment operator `<-` or the assignment by reference operator `:=`.

<br>

Also notice the the use of **1L** to select the first column in the set command of the final speed test. See [here](http://stackoverflow.com/questions/7014387/whats-the-difference-between-1l-and-1) and [here](https://cran.r-project.org/doc/manuals/R-lang.html#Constants) for a discussion of the use of 1 vs 1L for integers in R.

<br>

# Change column names using setnames() {#setnames}

Use `setnames` to change the names of columns.
The syntax for using `setnames` is:

&nbsp;&nbsp;&nbsp;&nbsp;`setnames(DT, "oldname", "newname")`

This example will replace the column name **hp** with the name **horsepower**:
```
> colnames(MTCarsDT)

##  [1] "mpg"  "cyl"  "disp" "hp"   "drat" "wt"   "qsec" "vs"   "am"   "gear" "carb"

> setnames(MTCarsDT, "hp", "horsepower")

> colnames(MTCarsDT)

##  [1] "mpg"        "cyl"        "disp"       "horsepower" "drat"       "wt"
##  [7] "qsec"       "vs"         "am"         "gear"       "carb"
```

You can also change multiple columnames at the same time:

```
> setnames(MTCarsDT, c("cyl", "disp"), c("cylinders", "displacement"))
> colnames(MTCarsDT)

##  [1] "mpg"          "cylinders"    "displacement" "horsepower"   "drat"
##  [6] "wt"           "qsec"         "vs"           "am"           "gear"
##  [11]"carb"

```
<br>

# Changing column order - setcolorder() {#setcolorder}

Use `setcolorder` to change the order of columns.

Create a new vector with the names of the different columns in the order you want them, then use `setcolorder` to rearrange the columns.

```
> MTCarsColumns <- c("drat","wt","qsec","vs","am","gear","carb","mpg","cylinders","displacement","horsepower")

> setcolorder(MTCarsDT, MTCarsColumns)
> MTCarsDT[1]

> MTCarsDT[1]

##    drat    wt  qsec vs am gear carb  mpg cylinders displacement horsepower
## 1: 4.93 1.615 18.52  1  1    4    2 30.4         4         75.7         52
```

# Unique {#unique}

`Unique` returns a data.table where duplicate data, by keyed row, are removed. So here's a new data table, notice that rows 2 and 3 are identical to rows 4 and 6 respectively.

```
> DT <- data.table(A = c('A','B','C','B','A','C'), B=c(1,2,3,2,4,3), C=c(10,20,30,20,60,30))
> DT

   A B  C
1: A 1 10
2: B 2 20
3: C 3 30
4: B 2 20
5: A 4 60
6: C 3 20
```

`Duplicated` will return **TRUE** if a row is identical to a previous row. In this example there are two rows that are identical to other rows.

```{r}
> duplicated(DT)

## [1] FALSE FALSE FALSE  TRUE FALSE  TRUE
```

`Unique` will return a data table without the duplicates.

```
> unique(DT)

##    A B  C
## 1: A 1 10
## 2: B 2 20
## 3: C 3 30
## 4: A 4 60
```

`uniqueN` returns the number of unique rows.

```
> uniqueN(DT)

## [1] 4
```
<br>

# Additional Sources of Information {#additional_sources}

More info and references:

* [Data Tables Github Wiki](https://github.com/Rdatatable/data.table/wiki)
* [CRAN - Data Table](https://cran.r-project.org/web/packages/data.table/data.table.pdf)
* [What's the difference between `1L` and `1`?](http://stackoverflow.com/questions/7014387/whats-the-difference-between-1l-and-1)
* [R Language Definition: Constants](https://cran.r-project.org/doc/manuals/R-lang.html#Constants)
* [A data.table R tutorial by DataCamp: intro to DT[i, j, by]](http://www.r-bloggers.com/a-data-table-r-tutorial-by-datacamp-intro-to-dti-j-by/)
