+++
# Date this page was created.
date = 2016-04-27T00:00:00

# Project title.
title =  "Central Limit Theorem"

# Project summary to display on homepage.
summary = "."

# Optional image to display on homepage (relative to `static/img/` folder).
image_preview = "/headers/R_logo.png"

# Tags: can be used for filtering projects.
# Example: `tags = ["machine-learning", "deep-learning"]`
tags = ['r-programming']

# Optional external URL for project (replaces project detail page).
external_link = ""

# Does the project detail page use math formatting?
math = true

# Optional featured image (relative to `static/img/` folder).
[header]
    image = "university-wide.png"
    caption = "My caption :smile:"
    
+++



<style>
  .col2 {
    columns: 2 200px;         /* number of columns and width in pixels*/
    -webkit-columns: 2 200px; /* chrome, safari */
    -moz-columns: 2 200px;    /* firefox */
  }
  .col3 {
    columns: 3 100px;
    -webkit-columns: 3 100px;
    -moz-columns: 3 100px;
  }
</style>





## Introduction

The Central Limit Theorem states that if you take many random samples of the same size from a population, take the mean of each sample, and then plot these means in a histogram, the plot will look like a normal distribution regardless of the distribution of data in the original data set and the *mean* of all of these sample means will approach the population mean as the number of samples approaches infinity.

## Purpose


## Table of Contents

1. [Packages](#packages)
2. [Mean of Sample Means](#mean_sample_means)



### Packages {#packages}

This demonstration will use the following packages:

* data.table
* ggplot2
* easyGgplot2


```{r, warning=FALSE, results='hide'}
library(data.table)
library(ggplot2)
library(easyGgplot2)
```



## Mean of Sample Means {#mean_sample_means}

As the the number of sample means approach infinity the sample means and population mean will converge. Or to put it more simply, the mean of the sampled means will have the same mean as the population.

$$\text{mean of sample means} = \text{population mean}$$

<center>**OR**</center>

$$\mu_{\bar{X}} = \mu$$

Where:

* $\bar{X}$ is a sample mean

* $\mu_{\bar{X}}$ is the mean of the sample means

* $\mu$ is the population mean

 
<br>


## Standard Error of the Mean

First off a statistician could find the standard error of a number of different statistics, like median, variance, and estimate among others. But the standard error of the mean is most common.

The standard deviation of the sample means is also called the **standard error of the mean.**

The standard deviation of the sample data will be equal to standard deviation of the population divided by the square root of the sample size, or: 


$$\text{standard error of the mean} = \frac{\text{population standard deviation}}{\sqrt{\text{sample size}}}$$

<center>**or**</center>

<br>

$$\sigma_{\bar{X}} = \frac{\sigma}{\sqrt{n}}$$

Where:

* $\sigma_{\bar{M}}$ is the standard error of the mean
* $\sigma$ is the standard deviation of the population
* n is the sample size

<br>

We can tell that the standard error of the mean will get smaller as the sample size increases. A smaller standard error would indicate that the sample data is more representative of the total population. For example if we had identical standard deviations for two different populations but different sample sizes, then the standard error of the mean would be smaller for the set with a larger sample size.

<br>

We can also use the standard error of the mean draw inferences about the population data from a sample. This is useful in the many many situations where it would be impossible to measure every individual from a population. For example if we 30 sets of fifty samples from a population, we can take the standard deviation of the means of those samples and find a population standard deviation.

<br>

## Sampling Error

Sampling error is the difference between the actual population data and the same measure of the sampled data. For example the mean of each sample will be different from the mean of the population data.

[From wikipedia:](https://en.wikipedia.org/wiki/Sampling_error)

>Since the sample does not include all members of the population, statistics on the sample, such as means and quantiles, generally differ from the characteristics of the entire population, which are known as parameters.

<br>

## Number of Sample Means

* When the population data is normally distributed then the sample means will also be normally distributed.
* When the population data is not normally distributed then at least 30 sample means will have to be made for the sample means to be normally distributed. This is because of sampling error.

<br>

# An Example: Temperature Data

<br>

This is historical data from the [United States Historical Climatology Network](http://cdiac.ornl.gov/climate/temp/us_recordtemps/ui.html), more specificially [this page](http://cdiac.ornl.gov/cgi-bin/broker?id=172765&_PROGRAM=prog.scat_data_d9k_424.sas&_SERVICE=default&_DEBUG=0&tempvar=htx). This data set contains daily temperature highs from 1911 through 2010.

<br>

The variables/columns in the data file are:

* Station number (i.e., 172765: 2-digit state code, followed by 4-digit station code)
* Day of year (1-365)
* Month
* Day of Month
* Year the daily record was set
* Record Hot Tmax

<br>
First we import the data.
<br>
```{r}
library(data.table)

Station172765_TMax<- data.table(read.table("../../static/data/ME_2765tmax.txt", header = FALSE))
#Station172765_TMax<- data.table(read.table("ME_2765tmax.txt", header = FALSE))
```

We need to a little cleanup. 
We'll replace the column names with more descriptive names. 
```{r}
setnames(Station172765_TMax, c("V1", "V2", "V3", "V4", "V5", "V6"), c("StationID", "YearDay", "Year", "Month", "MonthDay", "MaxTemp"))

Station172765_TMax
```

Also on days that no data was collected the temperature is recorded as -999, we'll change that to NA.
```{r}
Station172765_TMax[MaxTemp == -999, MaxTemp := NA]
```
<br>

## Plotting Temperature Data

This is a plot of the temperature highs with the day of the year on the x axis and the temperature on the y axis:

```{r, fig.width=6, fig.height=3, fig.align='center', warning=FALSE, cache=TRUE}
p <- ggplot(Station172765_TMax, aes(YearDay, MaxTemp))
p + geom_point() 
```
<br>

The histogram of the data shows that it's bimodal.

```{r, collapse=TRUE, fig.height=3, fig.width=6, fig.align='center', cache=TRUE}
hist(Station172765_TMax[,MaxTemp], xlab="Temp", main="Frequency Max Temp - Farmington, ME, 1911 - 2010")
```

```{r, collapse=TRUE, fig.height=3, fig.width=6, fig.align='center', cache=TRUE}
ggplot(Station172765_TMax, aes(MaxTemp)) + geom_density()
```

## Sample Means

<br>
Now we'll get the mean and standard deviation for all years in the data set. 

```{r, collapse=TRUE, cache=TRUE}
Station172765_TMax[, mean(MaxTemp, na.rm = TRUE)]
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]
```
<br>

To get a sample of the data we use the sample function.

```{r, cache=TRUE}
Station172765_TMax[,sample(MaxTemp, 5)]
```
<br>

This will return a data table with four columns of 1000 sample means, each sample mean will come from 2, 5, 25 or 49 sampled values from the temperature data set.

```{r, collapse=TRUE, cache=TRUE}
SampleMeans <- NULL
Means <- NULL


## Sample Size of 2
for (i in 1:1000){
    Means <- append(Means, mean(Station172765_TMax[,sample(MaxTemp,2)], na.rm=TRUE))
    i <- i + 1
    if (i == 1001) break
}
SampleMeans <- data.table(SampleSize2 = Means)


##Sample Size of 5
Means <- NULL
for (i in 1:1000){
    Means <- append(Means, mean(Station172765_TMax[,sample(MaxTemp,5)], na.rm=TRUE))
    i <- i + 1
    if (i == 1001) break
}
SampleMeans[,SampleSize5 := Means]


## Sample Size of 25

Means <- NULL
for (i in 1:1000){
    Means <- append(Means, mean(Station172765_TMax[,sample(MaxTemp,25)], na.rm=TRUE))
    i <- i + 1
    if (i == 1001) break
}
SampleMeans[,SampleSize25 := Means]

##Sample Size of 49

Means <- NULL
for (i in 1:1000){
    Means <- append(Means, mean(Station172765_TMax[,sample(MaxTemp,49)], na.rm=TRUE))
    i <- i + 1
    if (i == 1001) break
}
SampleMeans[,SampleSize49 := Means]


head(SampleMeans)

```
<br>

## Sampling Error of Sample Means

So we can see that there is a sampling error for each sample mean in the data set.
```{r, collapse=TRUE}
#Subtract the population mean from one sample mean of each sample size.

SampleMeans[1] - Station172765_TMax[, mean(MaxTemp, na.rm = TRUE)]

```

## Mean of Sample Means

But we can see that mean of all of the sample means is fairly close to the mean of population data.

```{r, collapse=TRUE}
sapply(SampleMeans, mean)

Station172765_TMax[, mean(MaxTemp, na.rm = TRUE)]
```
<br>

We can also see that as the number of sample means increases it comes closer and closer to the population mean.
<br>

```{r, collapse=TRUE, cache=TRUE}
SampleMeans[1:10, mean(SampleSize5)]
SampleMeans[1:100, mean(SampleSize5)]
SampleMeans[1:500, mean(SampleSize5)]
SampleMeans[1:1000, mean(SampleSize5)]

Station172765_TMax[, mean(MaxTemp, na.rm = TRUE)]
```
<br>

## Standard Error of the Mean

<br>

So first off we can find the standard deviation of the sample means (**standard error of the mean**) for each sample size. Notice that the standard deviation is much smaller for the set of means with the sample size of 49 and the standard deviation for the set of means is the largest for the data set with a sample size of 2.
```{r, collapse=TRUE}

sapply(SampleMeans, sd) 
```

Also notice that the standard deviation of the sample means is approximately equal to the standard deviation of the population data divided by the square root of the sample size.
```{r, collapse=TRUE, cache=TRUE}
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(2)
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(5)
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(25)
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(49)
```

<br>
If we didn't have a complete data set for this weather data, we could take the standard deviation of the sample means and multiply it by the square root of our sample size to get the standard deviation of the population.  

```{r, collapse=TRUE, cache=TRUE}
SampleMeans[,sd(SampleSize49)] * sqrt(49) 
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)] 
```

<br>

## Plot Sample Means

<br>
Now if we plot the SampleMeans data as a histogram and density plot we can see that this sampled data looks like a normal distribution while the original data was bimodal. We can also see that the standard error is much larger for the sample means with fewer samples per mean and that the means of the different sample means are about the same.

```{r, collapse=TRUE, fig.height=3, fig.width=6, fig.align='center'}
DT1 <- data.table(SampleSize = "SampleSize2",SampleMeans = SampleMeans$SampleSize2) 
DT2 <- data.table(SampleSize = "SampleSize5",SampleMeans = SampleMeans$SampleSize5) 
DT3 <- data.table(SampleSize = "SampleSize25",SampleMeans = SampleMeans$SampleSize25) 
DT4 <- data.table(SampleSize = "SampleSize49",SampleMeans = SampleMeans$SampleSize49) 

MeltedSampleMeans <- rbindlist(l=list(DT1, DT2, DT3, DT4))

p <- ggplot(MeltedSampleMeans, aes(SampleMeans, fill=SampleSize,color=SampleSize))
p + geom_density(alpha = 0.1)
```

<br>

### Plot Sample Means to Show Normality

We can see, by plotting different numbers of sample means, that as the number of sample means increases the plot of those means looks more and more normal. 

<br>

<div class="col2">

```{r, fig.height=3.5, fig.width=4, fig.align='center'}
qplot(SampleMeans$SampleSize5[1:10], geom = "density")
qqnorm(SampleMeans$SampleSize5[1:10])
qqline(SampleMeans$SampleSize5[1:10])
```
</div>
<br>
<div class="col2">
```{r, fig.height=3.5, fig.width=4, fig.align='center'}
qplot(SampleMeans$SampleSize5[1:20], geom = "density")
qqnorm(SampleMeans$SampleSize5[1:20])
qqline(SampleMeans$SampleSize5[1:20])
```
</div>
<br>
<div class="col2">
```{r, fig.height=3.5, fig.width=4, fig.align='center'}
qplot(SampleMeans$SampleSize5[1:30], geom = "density")
qqnorm(SampleMeans$SampleSize5[1:30])
qqline(SampleMeans$SampleSize5[1:30])
```
</div>
<br>
<div class="col2">
```{r, fig.height=3.5, fig.width=4, fig.align='center'}
qplot(SampleMeans$SampleSize5[1:40], geom = "density")
qqnorm(SampleMeans$SampleSize5[1:40])
qqline(SampleMeans$SampleSize5[1:40])
```
</div>
<br>
<div class="col2">
```{r, fig.height=3.5, fig.width=4, fig.align='center'}
qplot(SampleMeans$SampleSize5[1:50], geom = "density")
qqnorm(SampleMeans$SampleSize5[1:50])
qqline(SampleMeans$SampleSize5[1:50])
```
</div>
<br>
<div class="col2">
```{r, fig.height=3.5, fig.width=4, fig.align='center'}
qplot(SampleMeans$SampleSize5, geom = "density")
qqnorm(SampleMeans$SampleSize5)
qqline(SampleMeans$SampleSize5)
```
</div>
<br>

# Cental Limit Theorem Z-Values

If the number of samples is [large enough](##Number of Sample Means), ie more than 30, then conclusions can be made about the population data based on the sample data. 

The formula for [z-values](Normal_Distribution.html#z-scores-an-example) in normally distributed data:

$$z=\frac{\text{value-mean}}{\text{standard deviation}}$$

<br>
We can use this very similar formula to find z-values for sample means of population data:

$$z = \frac{\bar{X}-\mu}{\sigma\div\sqrt{n}}$$

<center>
**or**
</center>

$$z = \frac{\text{sample mean}-\text{population mean}}{\text{population standard deviation}\div\sqrt{\text{sample size}}}$$

<br>

## Z-Values With Sample Size Less Than 30

<br>

If the number of sample is less than 30 then use the normal formula for a z-score.

$$z = \frac{\bar{X}-\mu}{\sigma}$$

<br>

## Example Weather Data

So if we took a 36 days at random from the weather data, what is the probability that the mean of those 36 days would be greater than 65 degrees?

<br>

The standard deviation of the sample means would be: 
$$\sigma_{\bar{X}} =\frac{\sigma}{\sqrt{n}} = \frac{21.12321}{\sqrt{36}} = 3.520535$$

<center>
OR
</center>
```{r, collapse=TRUE, cache=TRUE}
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(36)
```

<br>

The z-score is:

$$z = \frac{\bar{X}-\mu}{\sigma\div\sqrt{n}} = \frac{65-54.45328}{21.12321\div\sqrt{36}} = 2.995772$$

```{r, collapse=TRUE}
(65-54.45328)/(21.12321/sqrt(36))
```
<br>
And based on [Z-Score lookup table](https://en.wikipedia.org/wiki/Standard_normal_table) the probability that 36 days would have a mean greater than 65 is 1-.9987 or **0.0013**.
<br>

### Pnorm function 

What's key in this operation is that the value for the standard deviation entered into pnorm is **not** 21.12321, but $21.12321 \div \sqrt{36}$. 

```{r}
pnorm(65, mean=54.45328, sd=(21.12321/sqrt(36)), lower.tail = FALSE)
```
<br>


The actual number of sample means greater than 65 is approximately 12% which is close enough.
```{r}
sapply(SampleMeans[SampleSize5>65], length)/nrow(SampleMeans) 
```
<br>

### Smaller Sample Size

Where it gets interesting is if we have 5 days instead of 36. Five days falls below the level at which we have to divide sigma by the root of the sample size. So...

The z-score is:

$$z = \frac{\bar{X}-\mu}{\sigma} = \frac{65-54.45328}{21.12321} = 0.4992953$$

```{r, collapse=TRUE}
(65-54.45328)/(21.12321)
```
<br>
And based on [Z-Score lookup table](https://en.wikipedia.org/wiki/Standard_normal_table) the probability that the mean of five values will be greater than 65 is 1-.6915 or **0.3085**.
<br>


# Finite Population Correction Factor

<br>
The Central Limit Theorem and standard error of the mean assume that samples are drawn with replacement. However almost all survey work are conducted on finite populations and samples are drawn without replacement. In these cases and especially when the sample size *n* is large compared to the population size *N* (more than 5%), the finite population correction factor is used to account for the added precision gained by sampling close to a larger percentage of the population. The effect of the FPC is that the error becomes zero when the sample size n is equal to the population size N.

Formula for the population correction factor:

$$\sqrt{\frac{N-n}{N-1}}$$

Where:

* *N* is the population size
* *n* is the sample size

<br>

So the standard error of the mean is multiplied by the population correction factor:

$$\sigma_{\bar{X}} = \frac{\sigma}{\sqrt{n}} \cdot \sqrt{\frac{N-n}{N-1}}$$

<br>

And the total formula for the z-value when using the population correction factor becomes:

$$z = \frac{\bar{X}-\mu}{\frac{\sigma}{\sqrt{n}}\cdot\sqrt{\frac{N-n}{N-1}}}$$

<br>

## Population Size and Population Correcton Factor

We can see the effect that this correction factor has based on the size of the population N and the sample size n. 

<br>

### Small N

If **N is small** and multiplied by a data set with a $\sigma$ of 1. 

$$\sqrt{\frac{150-30}{150-1}} = 0.8974236$$

$$\sigma_{\bar{X}\text{Small}} = \frac{1}{\sqrt{30}} \cdot \sqrt{\frac{150-30}{150-1}} = 0.1638464$$

$$z = \frac{4-3.5}{\frac{1}{\sqrt{30}}\cdot\sqrt{\frac{150-30}{150-1}}} = 3.051639$$

So in this case 99.89% of the sample means fall below 4. 


<br>

### Large N

If **N is large** and multiplied by a data set with a $\sigma$ of 1:

$$\sqrt{\frac{100000-5}{100000-1}} = 0.999855$$

<br>

$$\sigma_{\bar{X}\text{Large}} = \frac{1}{\sqrt{30}} \cdot \sqrt{\frac{1000-5}{1000-1}} = 0.1825477$$

$$z = \frac{4-3.5}{\frac{1}{\sqrt{30}}\cdot\sqrt{\frac{100000-30}{100000-1}}} = 2.73901$$

In this case 99.69% of the sample means fall below 4. 

<br>

### No Correction Factor

This is fairly close to the standard error of the mean without a correction factor:

$$\sigma_{\bar{X}\text{No Correction Factor}} = \frac{1}{\sqrt{30}} = 0.1825742$$

$$z = \frac{\bar{X}-\mu}{\frac{\sigma}{\sqrt{n}}}$$

$$z = \frac{4-3.5}{\frac{1}{\sqrt{30}}} \approx 2.738613$$

And like the previous case 99.69% of the sample means fall below 4.

<br>
<br>



# EXAMPLE 
A large freight elevator can transport a maximum of 9800 pounds. Suppose a load of cargo containing 49 boxes must be transported via the elevator. Experience has shown that the weight of boxes of this type of cargo follows a distribution with mean μ = 205 pounds and standard deviation σ = 15 pounds. Based on this information, what is the probability that all 49 boxes can be safely loaded onto the freight elevator and transported?

$$z = \frac{\text{sample mean}-\text{population mean}}{\text{population standard deviation}\div\sqrt{\text{sample size}}}$$

$$z = \frac{\bar{X}-\mu}{\sigma\div\sqrt{n}}$$



$$z=\frac{(9800\div49)-205}{15\div\sqrt{49}} = -2.33$$

$$.5-.4901 = 0.0099$$

So there's about a 1% chance that the freight elevator won't fail. 

<br>
Using the pnorm function we get:
```{r, collapse=TRUE}
pnorm((9800/49), mean=205, sd=(15/sqrt(49)), lower.tail = TRUE)
```

<br>
<br>

# Reference Websites

<br>

http://www.r-bloggers.com/sampling-distributions-and-central-limit-theorem-in-r/

http://www.math.uah.edu/stat/sample/CLT.html

http://atcm.mathandtech.org/EP2009/papers_full/2812009_17251.pdf

http://www.math.utah.edu/~treiberg/M3074Simulation.pdf

http://science.kennesaw.edu/~jdemaio/1107/Central%20Limit%20Theorem.htm

http://www.stat.ucla.edu/~nchristo/introeconometrics/introecon_central_limit_theorem.pdf

[Sampling Distributions and the Central Limit Theorem](http://www.cios.org/readbook/rmcs/ch10.pdf)

[In Brief: Standard Deviation and Standard Error](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3148365/)

<br>

**Simulating the Central Limit Theorem from R-bloggers**

This is code from [r-bloggers](http://www.r-bloggers.com/sampling-distributions-and-central-limit-theorem-in-r/) that simulates the central limit theorem. You can pick from several different distributions and then generate several plots that show the means of these distributions.



```{r}
sdm.sim <- function(n,src.dist=NULL,param1=NULL,param2=NULL) {
   r <- 10000  # Number of replications/samples - DO NOT ADJUST
   # This produces a matrix of observations with  
   # n columns and r rows. Each row is one sample:
   my.samples <- switch(src.dist,
	"E" = matrix(rexp(n*r,param1),r),
	"N" = matrix(rnorm(n*r,param1,param2),r),
	"U" = matrix(runif(n*r,param1,param2),r),
	"P" = matrix(rpois(n*r,param1),r),
	"C" = matrix(rcauchy(n*r,param1,param2),r),
        "B" = matrix(rbinom(n*r,param1,param2),r),
	"G" = matrix(rgamma(n*r,param1,param2),r),
	"X" = matrix(rchisq(n*r,param1),r),
	"T" = matrix(rt(n*r,param1),r))
   all.sample.sums <- apply(my.samples,1,sum)
   all.sample.means <- apply(my.samples,1,mean)   
   all.sample.vars <- apply(my.samples,1,var) 
   par(mfrow=c(2,2))
   hist(my.samples[1,],col="gray",main="Distribution of One Sample")
   hist(all.sample.sums,col="gray",main="Sampling Distribution of the Sum")
   hist(all.sample.means,col="gray",main="Sampling Distribution of the Mean")
   hist(all.sample.vars,col="gray",main="Sampling Distribution of the Variance")
}
```

> There are 9 population distributions to choose from: exponential (E), normal (N), uniform (U), Poisson (P), Cauchy (C), binomial (B), gamma (G), Chi-Square (X), and the Student’s t distribution (t). Note also that you have to provide either one or two parameters, depending upon what distribution you are selecting. For example, a normal distribution requires that you specify the mean and standard deviation to describe where it’s centered, and how fat or thin it is (that’s two parameters). A Chi-square distribution requires that you specify the degrees of freedom (that’s only one parameter). You can find out exactly what distributions require what parameters by going here: http://en.wikibooks.org/wiki/R_Programming/Probability_Distributions.

For example an exponential distribution looks like this:

```{r, echo=FALSE, fig.align='center', fig.height=3, fig.width=6, cache=TRUE, collapse=TRUE}
hist(rexp(100000,1))
```

But these plots show what the sample means for an exponential distribution look like:
```{r}
sdm.sim(10,src.dist="E",1)
```



