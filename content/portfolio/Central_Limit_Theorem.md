+++
# Date this page was created.
date = 2017-03-12T00:00:00

# Project title.
title =  "The Central Limit Theorem"

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
    image = "headers/R_logo.png"
    caption = ""
    
+++




# Purpose

This will demonstrate what the Central Limit Theorem is, why it is significant, and what conclusions you can draw from sampled data.


# Table of Contents

1. [Introduction](#introduction)
    1. [Mean of Sample Means](#mean_sample_means)
    2. [Standard Error of the Mean](#standard_error_mean)
    3. [Sampling Error](#sampling_error)
    4. [Number of Sample Means](#number_sample_means)
2. [An Example with Temperature Data](#example)
    1. [Prepare Temperature Data](#prepare_data)
    2. [Plot Temperature Data](#plotting_temp_data)
    3. [Sample Means](#example_sample_means)
    4. [Sampling Error](#example_sampling_error)
    5. [Mean of Sample Means](#example_mean_of_sample_means)
3. [Central Limit Theorem and Z-Values](#central_limit_theorem_zvalues)
    1. [Sample Size Less Than 30](#sample_size_lessthan_30)
    2. [Example: Z-Score with Weather Data](#example_zscore_weather_data)
        1. [Using Pnorm Function](#pnorm_function)
    3. [Smaller Sample Size](#smaller_sample_size)
4. [Finite Population Correction Factor](#finite_population_correction_factor)
    1. [Population Size and Population Correction Factor](#population_size_and_pop_corr_factor)
        1. [Small N](#small_n)
        2. [Large N](#large_n)
        3. [No Correction Factor](#no_correction_factor)
5. [Example](#example2)
6. [Simulating the Central Limit Theorem](#simulate)
7. [Additional Sources](#additional_sources)


# Introduction {#introduction}

The Central Limit Theorem is one of the most important concepts in inferential statistics. 

It states that if you have a population with a mean $\mu$ and a standard deviation $\sigma$ and you take many sufficiently large samples with replacement from a population, the means of those samples will approach a normal distribution regardless of the distribution of the population. Further the *mean of these sample means* will approach the population mean as the number of samples approaches infinity and it's standard deviation will shrink as its sample size increases.

Sample sizes of 30 or more ($n \geq 30$) are considered sufficiently large unless you know the population is normally distributed, in which case smaller sample sizes are acceptable. However the population distribution will affect the sample size necessary to produce a normal distribution

<br>

## Mean of Sample Means {#mean_sample_means}

As the the number of sample means approach infinity the mean of the sampled means will have the same mean as the population.

$$\text{mean of sample means} = \text{population mean}$$

<center>**OR**</center>

$$\mu_{\bar{X}} = \mu$$

Where:

* $\bar{X}$ is a sample mean
* $\mu_{\bar{X}}$ is the mean of the sample means
* $\mu$ is the population mean

<br>

## Standard Error of the Mean {#standard_error_mean}

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

The standard error of the mean will get smaller as the sample size increases. A smaller standard error would indicate that the sample data is more representative of the total population. For example if we had identical standard deviations for two different populations but different sample sizes, then the standard error of the mean would be smaller for the set with a larger sample size.

<br>

You can use the standard error of the mean draw inferences about the population data from a sample. This is useful in the many many situations where it would be impossible to measure every individual from a population. For example if we 30 sets of fifty samples from a population, we can take the standard deviation of the means of those samples and find a population standard deviation.

<br>

## Sampling Error {#sampling_error}

Sampling error is the difference between the actual population data and the same measure of the sampled data. For example the mean of each sample will be different from the mean of the population data.

[From wikipedia:](https://en.wikipedia.org/wiki/Sampling_error)

>Since the sample does not include all members of the population, statistics on the sample, such as means and quantiles, generally differ from the characteristics of the entire population, which are known as parameters.

<br>

## Number of Sample Means {#number_sample_means}

* When the population data is normally distributed then the sample means will also be normally distributed.
* When the population data is not normally distributed then at least 30 sample means will have to be made for the sample means to be normally distributed. This is because of sampling error.

<br>

****

# An Example With Dice 

Consider an example with a die. A die has an equal probability of landing on any side so the probability distribution is uniform. But, taking the mean of multiple samples produces a normal distribution.

```
die <- 1:6
die_rolls <- NULL

for (i in 1:1000){
    die_rolls <- append(die_rolls, mean(sample(die, 30, replace = TRUE)))
}

hist(die_rolls)
```

![](/portfolio/Central_Limit_Theorem_files/die_roll_histogram.png)


<br>

# An Example: Temperature Data {#example}

<br>

This example will sample from population data to demonstrate that a non-normal population will appear normal when sampled, that the sample means will converge around the population mean, and that the standard deviation of the sample means is equal to the population standard deviation divided by the square root of the sample size.

This example uses historical data from the [United States Historical Climatology Network](https://www.ncdc.noaa.gov/data-access/land-based-station-data/land-based-datasets/us-historical-climatology-network-ushcn). The data set contains daily high temperatures in Farmington, Maine from 1911 through 2010. [Download the data here.](/data/ME_2765tmax.txt)


The variables/columns in the data file are:

* Station number (i.e., 172765: 2-digit state code, followed by 4-digit station code)
* Day of year (1-365)
* Month
* Day of Month
* Year the daily record was set
* Daily Temperature High

<br>

## Prepare the Data {#prepare_data}


First load the following packages:

```
library(data.table)
library(ggplot2)
library(easyGgplot2)
```


<br>
Then import the data.
<br>
```
Station172765_TMax<- data.table(read.table("/data/ME_2765tmax.txt", header = FALSE))
```

The columns are labeled "V1" through "V6" so replace the column names with more descriptive names. 

```
setnames(Station172765_TMax, c("V1", "V2", "V3", "V4", "V5", "V6"), c("StationID", "YearDay", "Year", "Month", "MonthDay", "MaxTemp"))
```

On days that no data was collected the temperature is recorded as -999, change that to NA.

```
Station172765_TMax[MaxTemp == -999, MaxTemp := NA]
```

Now view the dataset:

```
Station172765_TMax

##        StationID YearDay Year Month MonthDay MaxTemp
##     1:    172765       1 1911     1        1      18
##     2:    172765       2 1911     1        2      36
##     3:    172765       3 1911     1        3      38
##     4:    172765       4 1911     1        4      35
##     5:    172765       5 1911     1        5      17
##    ---                                              
## 36496:    172765     361 2010    12       27      25
## 36497:    172765     362 2010    12       28      26
## 36498:    172765     363 2010    12       29      24
## 36499:    172765     364 2010    12       30      32
## 36500:    172765     365 2010    12       31      44
```

<br>

## Plotting Temperature Data {#plotting_temp_data}

<br>

This plot shows the temperature highs with the day of the year on the x-axis and the temperature on the y-axis:

```
p <- ggplot(Station172765_TMax, aes(YearDay, MaxTemp))
p + geom_point() 
```
![](/portfolio/Central_Limit_Theorem_files/172765_temp_xy.png)

<br>

The histogram of the data shows that it's bimodal:

```
hist(Station172765_TMax[,MaxTemp], xlab="Temp", main="Frequency Max Temp - Farmington, ME, 1911 - 2010")
```

![](/portfolio/Central_Limit_Theorem_files/172765_temp_histogram.png)

## Sample Means {#example_sample_means}



This will return a data table called `SampleMeans` with four columns of 1000 sample means each; each sample mean will come from 2, 10, 30 or 50 samples from the temperature data set.

```
SampleMeans <- NULL
Means <- NULL


## Sample Size of 2
for (i in 1:200){
    Means <- append(Means, mean(Station172765_TMax[,sample(MaxTemp,2)], na.rm=TRUE))
}

SampleMeans <- data.table(SampleSize2 = Means)

##Sample Size of 10
Means <- NULL
for (i in 1:200){
    Means <- append(Means, mean(Station172765_TMax[,sample(MaxTemp,10)], na.rm=TRUE))
}
SampleMeans[,SampleSize10 := Means]

##Sample Size of 30
Means <- NULL
for (i in 1:200){
    Means <- append(Means, mean(Station172765_TMax[,sample(MaxTemp,30)], na.rm=TRUE))
}

SampleMeans[,SampleSize30 := Means]

##Sample Size of 50

Means <- NULL
for (i in 1:200){
    Means <- append(Means, mean(Station172765_TMax[,sample(MaxTemp,50)], na.rm=TRUE))

}
SampleMeans[,SampleSize50 := Means]

SampleMeans

```


## Sampling Error of Sample Means {#example_sampling_error}

This dataset shows that there can be substantial variability in the sample means, but as the sample size increases the variability of the sample mean declines and the sample means come closer to the true population mean. In this case the sample means are clustering around ~54.5 for a population mean.

```
head(SampleMeans)

   SampleSize2 SampleSize10 SampleSize30 SampleSize50
1:        54.5         48.1     61.07143     53.86000
2:        32.5         48.5     50.86667     59.22000
3:        73.0         54.2     56.86667     57.10000
4:        54.5         55.6     50.00000     54.59184
5:        49.0         58.7     61.90000     56.38000
6:        57.5         37.0     53.40000     55.82000
```
<br>


## Mean of Sample Means {#example_mean_of_sample_means}

Taking the mean of all of the sample means shows that they are fairly close to the population mean.

```
sapply(SampleMeans, mean)

 SampleSize2 SampleSize10 SampleSize30 SampleSize50 
    54.75500     54.48744     54.47269     54.25413 

Station172765_TMax[, mean(MaxTemp, na.rm = TRUE)]

## [1] 54.45328
```
<br>

## Standard Error of the Mean

<br>

The standard deviation of the sample means, also called the *standard error of the mean* is much smaller with a larger sample size and much larger with a small sample size.

```
sapply(SampleMeans, sd) 

## SampleSize2 SampleSize10 SampleSize30 SampleSize50 
##   13.695907     6.553337     3.999041     3.223173 
```

Also notice that the standard deviation of the sample means is approximately equal to the standard deviation of the population data divided by the square root of the sample size. Compare the standard deviations above to the population standard deviation divided by the square root of the sample size below.
```
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(2)
## [1] 14.93637

Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(5)
## [1] 6.679747

Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(25)
## [1] 3.856554

Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(49)
## [1] 2.987274
```

<br>
Without a complete data set for this weather data, you could take the standard deviation of the sample means and multiply it by the square root of our sample size to get the standard deviation of the population.  

```
SampleMeans[,sd(SampleSize49)] * sqrt(49) 
## [1] 22.79128

Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)] 
## [1] 21.12321
```

<br>

## Plot Sample Means

<br>
Plotting the SampleMeans data as a density plot shows that this sampled data looks like a normal distribution even though the original data was bimodal. You can also see that the standard error is much larger for the sample means with the smaller sample size.

```
DT1 <- data.table(SampleSize = "SampleSize2",SampleMeans = SampleMeans$SampleSize2) 
DT2 <- data.table(SampleSize = "SampleSize10",SampleMeans = SampleMeans$SampleSize10) 
DT3 <- data.table(SampleSize = "SampleSize30",SampleMeans = SampleMeans$SampleSize30) 
DT4 <- data.table(SampleSize = "SampleSize50",SampleMeans = SampleMeans$SampleSize50) 

MeltedSampleMeans <- rbindlist(l=list(DT1, DT2, DT3, DT4))

p <- ggplot(MeltedSampleMeans, aes(SampleMeans, fill=SampleSize,color=SampleSize))
p + geom_density(alpha = 0.1)
```

![](/portfolio/Central_Limit_Theorem_files/sample_means_hist.png)


<br>

# Cental Limit Theorem Z-Values {#central_limit_theorem_zvalues}

If the number of samples is large enough, ie more than 30, then conclusions can be made about the sample means in the same way that conclusions can be made about normally distributed datasets. 

Below is the formula for z-values in normally distributed data:

$$z=\frac{\text{value - mean}}{\text{standard deviation}}$$

<br>
We can use this very similar formula to find z-values for sample means of population data:

$$z = \frac{\bar{X}-\mu}{\sigma\div\sqrt{n}} = \frac{\bar{X}-\mu}{\sigma_{\bar{X}}}$$

<center>
**or**
</center>

$$z = \frac{\text{sample mean}-\text{population mean}}{\text{population standard deviation}\div\sqrt{\text{sample size}}} =  \frac{\text{sample mean}-\text{population mean}}{\text{sample standard deviation}}$$

<br>

## Z-Values With Sample Size Less Than 30 {#sample_size_lessthan_30}

<br>

If the number of sample is less than 30 then use the normal formula for a z-score.

$$z = \frac{\bar{X}-\mu}{\sigma}$$

<br>

## Example Weather Data {#example_zscore_weather_data}

So if we took 36 days at random from the weather data, what is the probability that the mean of those 36 days would be greater than 60 degrees?

<br>



The standard deviation of the sample means would be: 
$$\sigma_{\bar{X}} =\frac{\sigma}{\sqrt{n}} = \frac{21.12321}{\sqrt{36}} = 3.520535$$

<center>
OR
</center>
```
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(36)
## [1] 3.520536
```

<br>

The z-score is:

$$z = \frac{\bar{X}-\mu}{\sigma\div\sqrt{n}} = \frac{60-54.45328}{21.12321\div\sqrt{36}} = 1.575533$$

```
(60-54.45328)/(21.12321/sqrt(36))

## [1] 1.575533
```

<br>
And based on [Z-Score lookup table](https://en.wikipedia.org/wiki/Standard_normal_table) the probability that 36 days would have a mean greater than 60 is 1-.94295 or **0.05705**.
<br>

### Pnorm function {#pnorm_function}

What's key in this operation is that the value for the standard deviation entered into pnorm is **not** 21.12321, but $21.12321 \div \sqrt{36}$. 

```
pnorm(60, mean=54.45328, sd=(21.12321/sqrt(36)), lower.tail = FALSE)
## [1] 0.0575667
```

So that means there's a 5.76% percent chance that an average of 36 samples from this data set will be greater than 60 degrees. A short test in R with the weather station data set shows that this estimation holds up.

```
meanSamples <- NULL

for (i in 1:1000000){
    meanSamples <-append(meanSamples, mean(sample(Station172765_TMax$MaxTemp, 36, replace = TRUE),na.rm = TRUE))
}

table(meanSamples > 60)

## FALSE  TRUE 
## 94318  5682 
```

$$\frac{5682}{100000} = .05682$$



<br>

### Smaller Sample Size {#smaller_sample_size}

Where it gets interesting is if we have 5 days instead of 36. Five days falls below the level at which we have to divide sigma by the root of the sample size. So...

The z-score is:

$$z = \frac{\bar{X}-\mu}{\sigma} = \frac{60-54.45328}{21.12321} = 0.2625889$$


And based on [Z-Score lookup table](https://en.wikipedia.org/wiki/Standard_normal_table) the probability that the mean of five values will be greater than 60 is 1-.60257 or **0.39743**.
<br>

Using pnorm we get a similar answer:

```
pnorm(60, 54.45328, 21.12321, lower.tail = FALSE)

## [1] 0.3964337
```

<br>




# Finite Population Correction Factor {#finite_population_correction_factor}

<br>
The Central Limit Theorem and standard error of the mean assume that samples are drawn with replacement. However almost all survey work are conducted on finite populations and samples are drawn without replacement. In these cases and especially when the sample size *n* is large compared to the population size *N* (more than 5%), the finite population correction (FPC) factor is used to account for the added precision gained by sampling close to a larger percentage of the population. The effect of the FPC is that the error becomes zero when the sample size n is equal to the population size N.

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

## Population Size and Population Correction Factor {#population_size_and_pop_corr_factor}

This shows the effect that this correction factor has based on the size of the population N and the sample size n. 

<br>

### Small N {#small_n}

If **N is small** and multiplied by a data set with a $\sigma$ of 1. 

$$\sqrt{\frac{150-30}{150-1}} = 0.8974236$$

$$\sigma_{\bar{X}\text{Small}} = \frac{1}{\sqrt{30}} \cdot \sqrt{\frac{150-30}{150-1}} = 0.1638464$$

$$z = \frac{4-3.5}{\frac{1}{\sqrt{30}}\cdot\sqrt{\frac{150-30}{150-1}}} = 3.051639$$

So in this case 99.89% of the sample means fall below 4. 


<br>

### Large N {#large_n}

If **N is large** and multiplied by a data set with a $\sigma$ of 1:

$$\sqrt{\frac{100000-5}{100000-1}} = 0.999855$$

<br>

$$\sigma_{\bar{X}\text{Large}} = \frac{1}{\sqrt{30}} \cdot \sqrt{\frac{1000-5}{1000-1}} = 0.1825477$$

$$z = \frac{4-3.5}{\frac{1}{\sqrt{30}}\cdot\sqrt{\frac{100000-30}{100000-1}}} = 2.73901$$

In this case 99.69% of the sample means fall below 4. 

<br>

### No Correction Factor {#no_correction_factor}

This is fairly close to the standard error of the mean without a correction factor:

$$\sigma_{\bar{X}\text{No Correction Factor}} = \frac{1}{\sqrt{30}} = 0.1825742$$

$$z = \frac{\bar{X}-\mu}{\frac{\sigma}{\sqrt{n}}}$$

$$z = \frac{4-3.5}{\frac{1}{\sqrt{30}}} \approx 2.738613$$

And like the previous case 99.69% of the sample means fall below 4.

<br>
<br>



# EXAMPLE {#example2}

A large freight elevator can transport a maximum of 9800 pounds. Suppose a load of cargo containing 49 boxes must be transported via the elevator. Experience has shown that the weight of boxes of this type of cargo follows a distribution with mean μ = 205 pounds and standard deviation σ = 15 pounds. Based on this information, what is the probability that all 49 boxes can be safely loaded onto the freight elevator and transported?

$$z = \frac{\text{sample mean}-\text{population mean}}{\text{population standard deviation}\div\sqrt{\text{sample size}}}$$

$$z = \frac{\bar{X}-\mu}{\sigma\div\sqrt{n}}$$



$$z=\frac{(9800\div49)-205}{15\div\sqrt{49}} = -2.33$$

$$.5-.4901 = 0.0099$$

So there's about a 1% chance that the freight elevator won't fail. 

<br>
Using the pnorm function we get:
```
pnorm((9800/49), mean=205, sd=(15/sqrt(49)), lower.tail = TRUE)

## [1] 0.009815329
```

<br>
<br>



# Simulating the Central Limit Theorem {#simulate}

This is code from [Quality and Innovation](https://qualityandinnovation.com/2015/03/30/sampling-distributions-and-central-limit-theorem-in-r/) which was reposted by [R-Bloggers](http://www.r-bloggers.com/sampling-distributions-and-central-limit-theorem-in-r/) that simulates the central limit theorem. You can pick from several different distributions and then generate several plots that show the means of these distributions.



```
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

```
hist(rexp(100000,1))
```

![](/portfolio/Central_Limit_Theorem_files/Central_Limit_Theorem_Rbloggers_1.png)

But these plots show what the sample means for an exponential distribution look like:
```
sdm.sim(10,src.dist="E",1)
```
![](/portfolio/Central_Limit_Theorem_files/Central_Limit_Theorem_Rbloggers_2.png)

# Additional Sources {#additional_sources}

<br>

* [Sampling Distributions and Central Limit Theorem in R](http://www.r-bloggers.com/sampling-distributions-and-central-limit-theorem-in-r/)
* [The Use of R Language in the Teaching of Central Limit Theorem](http://atcm.mathandtech.org/EP2009/papers_full/2812009_17251.pdf)
* [Simulation: Central Limit Theorem](http://www.math.utah.edu/~treiberg/M3074Simulation.pdf)
* [UCLA: The Central Limit Theorem](http://www.stat.ucla.edu/~nchristo/introeconometrics/introecon_central_limit_theorem.pdf)
* [Sampling Distributions and the Central Limit Theorem](http://www.cios.org/readbook/rmcs/ch10.pdf)
* [In Brief: Standard Deviation and Standard Error](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3148365/)

<br>
