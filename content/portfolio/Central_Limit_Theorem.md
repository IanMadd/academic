+++
# Date this page was created.
date = 2017-03-12T00:00:00

# Project title.
title =  "The Central Limit Theorem"

# Project summary to display on homepage.
summary = "This demonstrates what the Central Limit Theorem is, why it is significant, and what conclusions you can draw from sampled data."

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

This will demonstrate what the Central Limit Theorem is, why it is significant, and what conclusions you can draw from sampled data. This also demonstrates how to use the R programming language to sample from a data set and draw conclusions about the data using the sampled data. There is also a simulation at the bottom that shows how different distributions and sample sizes affect the distribution of sampled data.

This is intended for students with some familiarity with both statistics and the R programming language.

# Table of Contents

1. [Introduction](#introduction)
    1. [Mean of Sample Means](#mean_sample_means)
    2. [Standard Error of the Mean](#standard_error_mean)
    3. [Sampling Error](#sampling_error)
    4. [Number of Sample Means](#number_sample_means)
3. [An Example Using Die Rolls](#dice)
2. [An Example Using Temperature Data](#example)
    1. [Prepare Temperature Data](#prepare_data)
    2. [Plot Temperature Data](#plotting_temp_data)
    3. [Sample Means](#example_sample_means)
    4. [Sampling Error](#example_sampling_error)
    5. [Mean of Sample Means](#example_mean_of_sample_means)
3. [Central Limit Theorem and Z-Values](#central_limit_theorem_zvalues)
    1. [Sample Size Less Than 30](#sample_size_lessthan_30)
    2. [Example: Z-Score with Weather Data](#example_zscore_weather_data)
    3. [Pnorm Function](#pnorm_function)
    4. [Smaller Sample Size](#smaller_sample_size)
4. [Finite Population Correction Factor](#finite_population_correction_factor)
    1. [Population Size and Population Correction Factor](#population_size_and_pop_corr_factor)
        1. [Small N](#small_n)
        2. [Large N](#large_n)
        3. [No Correction Factor](#no_correction_factor)
6. [Simulating the Central Limit Theorem](#simulate)
7. [Additional Sources](#additional_sources)


# Introduction {#introduction}

The Central Limit Theorem is one of the most important concepts in inferential statistics.

It states that if you have a population with a mean $\mu$ and a standard deviation $\sigma$ and you take an infinitely large number of sample means:

1. The mean of the sample means will be equal to the population mean *regardless of the sample size* and *regardless of the population distribution*.
2. The sample means will be normal for a normally distributed population distribution and sample means for other population distributions will approach a normal distribution as the sample size increases.
3. The standard deviation of the sample means will be approximately equal to the standard deviation of the population divided by the square root of the sample size *regardless of the sample size*.
4. As the sample size increases the standard deviation decreases.

Sample sizes of 30 or more ($n \geq 30$) are considered sufficiently large unless you know the population is normally distributed, in which case smaller sample sizes are acceptable.

<br>

## Mean of Sample Means {#mean_sample_means}

As the the number of sample means approach infinity, the mean of the sampled means will have the same mean as the population regardless of the sample size and regardless of the population distribution.

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

The standard error of the mean will get smaller as the sample size increases. A
smaller standard error would indicate that the sample data is more
representative of the total population. For example, if we had identical
standard deviations for two different populations but different sample sizes,
then the standard error of the mean would be smaller for the set with a larger
sample size.

<br>

You can use the standard error of the mean to draw inferences about the
population data from a sample. This is useful in the many many situations where
it would be impossible to measure every individual from a population. For
example, you can take the standard deviation of the means of a group of samples
and multiply it by the square root of the sample size to find a population
standard deviation.

<br>

## Sampling Error {#sampling_error}

Sampling error is the difference between the actual population data and the
same measure of the sampled data.

Since the sample does not include all members of the population, statistics on
the sample, such as means and quantiles, generally differ from the
characteristics of the entire population, which are known as parameters.

<br>

## Number of Sample Means {#number_sample_means}

* When the population data is normally distributed then the sample means will also be normally distributed.
* When the population data is not normally distributed then at least 30 sample means will have to be made for the sample means to be normally distributed. This is because of sampling error.

<br>

****

# An Example With Dice {#dice}

Consider an example with a die. A die has an equal probability of landing on
any side so the probability distribution is uniform. But, taking the mean of
multiple samples produces a normal distribution.

In this example below, a die is sampled thirty times and then the mean is taken
from those 30 samples. That operation is repeated 10,000 times and the
resulting set of sample means is plotted in a histogram.

```
die <- 1:6
die_rolls <- NULL

for (i in 1:10000){
    die_rolls <- append(die_rolls, mean(sample(die, 30, replace = TRUE)))
}

hist(die_rolls)
```

![](/portfolio/Central_Limit_Theorem_files/die_roll_histogram.png)


In the figure above you can see the following:

1. the sample means have a normal distribution
2. the population mean is 3.5 and so is the mean of the sample means
3. the standard deviation of the samples multiplied by the square root of the
sample size is close to the square root of the population (see below)

```
sd(die_rolls)*sqrt(30)
[1] 1.720758

sd(die)
[1] 1.870829
```

<br>

# An Example Using Temperature Data {#example}

<br>

This example will sample from population data to demonstrate that:

* a non-normal population will appear normal when sampled
* that the sample means will converge around the population mean
* that the standard deviation of the sample means is approximately equal to the
population standard deviation divided by the square root of the sample size

This example uses historical data from the [United States Historical Climatology Network](https://www.ncdc.noaa.gov/data-access/land-based-station-data/land-based-datasets/us-historical-climatology-network-ushcn). The data set contains daily high temperatures in Farmington, Maine from 1911 through 2010. [Download the data here.](/data/ME_2765tmax.txt)


The variables in the data file are:

* station number (i.e., 172765: 2-digit state code, followed by 4-digit station code)
* day of year (1-365)
* month
* day of month
* year the daily record was set
* daily temperature high

<br>

## Prepare the Data {#prepare_data}


First load the following packages:

```
library(data.table)
library(ggplot2)
library(easyGgplot2)
```


<br>
Then import the data:
<br>
```
Station172765_TMax<- data.table(read.table("/data/ME_2765tmax.txt", header = FALSE))
```

<br>

The columns are labeled "V1" through "V6" so replace the column names with more descriptive names.

```
setnames(Station172765_TMax, c("V1", "V2", "V3", "V4", "V5", "V6"), c("StationID", "YearDay", "Year", "Month", "MonthDay", "MaxTemp"))
```

<br>

On days that no data was collected the temperature is recorded as -999, change that to NA.

```
Station172765_TMax[MaxTemp == -999, MaxTemp := NA]
```

<br>

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
Station172765_TMax[,hist(MaxTemp, xlab="Temp", main="Frequency Max Temp - Farmington, ME, 1911 - 2010")]
```

![](/portfolio/Central_Limit_Theorem_files/172765_temp_histogram.png)

## Sample Means {#example_sample_means}



This will return a data table called `sampleMeans` with four columns of 10000 sample means each; each sample mean will come from 2, 10, 30 or 50 samples from the temperature data set.

```

Station172765_TMax[,.(sampleSize2 = replicate(10,mean(sample(MaxTemp,2,replace = TRUE),na.rm = TRUE)))]

sampleMeans <- Station172765_TMax[,.(
    sampleSize2 = replicate(10000,mean(sample(MaxTemp,2,replace = TRUE),na.rm = TRUE)),
    sampleSize10 = replicate(10000,mean(sample(MaxTemp,10,replace = TRUE),na.rm = TRUE)),
    sampleSize30 = replicate(10000,mean(sample(MaxTemp,30,replace = TRUE),na.rm = TRUE)),
    sampleSize50 = replicate(10000,mean(sample(MaxTemp,50,replace = TRUE),na.rm = TRUE))
    )]

```

 <br>

## Sampling Error of Sample Means {#example_sampling_error}

This dataset shows that there can be substantial variability in the sample means especially for smaller sample sizes, but an infinitely large number of sample means will have a mean equal to the population mean regardless of the sample size or distribution. In this case the sample means are clustering around ~54.5 for a population mean.

```
> sampleMeans[1:5]

##    sampleSize2 sampleSize10 sampleSize30 sampleSize50
## 1:        63.5     54.50000     58.50000     51.73469
## 2:        47.5     37.22222     55.33333     54.98000
## 3:        63.0     63.90000     49.50000     55.04167
## 4:        53.5     50.30000     52.26667     50.26531
## 5:        52.5     64.40000     55.60000     56.04000
```
<br>


## Mean of Sample Means {#example_mean_of_sample_means}

Taking the mean of all of the sample means shows that they are fairly close to the population mean.

```
> sapply(sampleMeans, mean)

##  sampleSize2 sampleSize10 sampleSize30 sampleSize50
##     54.52900     54.46785     54.44227     54.46443

Station172765_TMax[, mean(MaxTemp, na.rm = TRUE)]

## [1] 54.45328
```
<br>

## Standard Error of the Mean


The standard deviation of the sample means, also called the *standard error of
the mean*, is much smaller with a larger sample size and much larger with a
small sample size.

```
sapply(sampleMeans, sd)

## sampleSize2 sampleSize10 sampleSize30 sampleSize50
##   14.943480     6.766649     3.880390     3.023907
```

Also notice that the standard deviation of the sample means is approximately equal to the standard deviation of the population data divided by the square root of the sample size. Compare the standard deviations above to the population standard deviation divided by the square root of the sample size below.
```
Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(2)
## [1] 14.93637

Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(10)
## [1] 6.679747

Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(30)
## [1] 3.856554

Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]/sqrt(50)
## [1] 2.987274
```

<br>
Without a complete data set for this weather data, you could take the standard deviation of the sample means and multiply it by the square root of our sample size to get the standard deviation of the population.

```
> sampleMeans[,sd(sampleSize50)] * sqrt(50)

## [1] 21.38225

Station172765_TMax[, sd(MaxTemp, na.rm = TRUE)]
## [1] 21.12321
```

<br>

## Plot Sample Means

<br>
Plotting the sampleMeans data as a density plot shows that this sampled data looks like a normal distribution even though the original data was bimodal. You can also see that the standard error is much larger for the sample means with the smaller sample size.

```
meltedSampleMeans <- sampleMeans[,.(
    sampleSize = c(
        rep("sampleSize2",10000),
        rep("sampleSize10",10000),
        rep("sampleSize30",10000),
        rep("sampleSize50",10000)
    ),
    sampleMeans = c(
        sampleSize2,
        sampleSize10,
        sampleSize30,
        sampleSize50
    )
)]

p <- ggplot(meltedSampleMeans, aes(sampleMeans, fill = sampleSize, color = sampleSize))
p + geom_density(alpha = 0.2) + geom_vline(xintercept = 54.45328) + labs(x = "Sample Means", y = "Density")
```

![](/portfolio/Central_Limit_Theorem_files/sample_means_hist.png)

Notice that the different sets of sample means are all clustered around the same population mean (the black vertical line), and that the standard deviation declines as the sample size increases.

<br>

# Cental Limit Theorem Z-Values {#central_limit_theorem_zvalues}

If the number of samples is large enough, i.e., more than 30, then conclusions can be made about the sample means in the same way that conclusions can be made about normally distributed datasets.

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

If the number of samples is less than 30, then use the normal formula for a z-score.

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

## Pnorm function {#pnorm_function}

You can use the [pnorm](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/Normal.html) function to calculate probabilities based on the summary data of a normal distribution.

The arguments for pnorm look like this:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**pnorm(quantile, mean = 0, sd = 1, lower.tail = TRUE, log.p = FALSE)**

What's key in this operation is that the value for the standard deviation entered into pnorm is **not** 21.12321, but $21.12321 \div \sqrt{36}$.

```
pnorm(60, mean=54.45328, sd=(21.12321/sqrt(36)), lower.tail = FALSE)
## [1] 0.0575667
```

So that means there's a 5.76% chance that an average of 36 samples from this data set will be greater than 60 degrees. A short test in R with the weather station data set shows that this estimation holds up.

This will take 1,000,000 sample means with a sample size of 36, then return a count of the number of samples greater than 60.

```
> sampleMeans60 <- Station172765_TMax[,replicate(1000000, mean(sample(MaxTemp,36, replace = TRUE),na.rm=TRUE))]

> table(sampleMeans60 > 60)

##  FALSE   TRUE
## 943019  56981
```

$$\frac{56981}{1000000} = .056981 \approx 5.70\%$$

<br>

### Smaller Sample Size {#smaller_sample_size}

Where it gets interesting is if we have 5 days instead of 36. Five days falls below the level at which we have to divide sigma by the root of the sample size.

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
The Central Limit Theorem and standard error of the mean assume that samples are drawn with replacement. However, almost all survey work are conducted on finite populations and samples are drawn without replacement. In these cases, and especially when the sample size *n* is large compared to the population size *N* (more than 5%), the finite population correction (FPC) factor is used to account for the added precision gained by sampling close to a larger percentage of the population. The effect of the FPC is that the error becomes zero when the sample size *n* is equal to the population size *N*.

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


# Simulating the Central Limit Theorem {#simulate}

The simulation below allows you to select different population
distributions, change parameters that change the shape of the population
distribution, and then change the sample size. From there you can view
different plots that allow you to compare the population data with sampled
data, or view changes in the sampled data as the sample size increases or
decreases.

The different tabs will show different plots:

* *Population Distribution*. This shows the population distribution.
* *Distributions of Samples*. This shows histograms of eight samples.
* *Distribution of Sample Means*. This shows the distribution of the sample means.
* *Sample Means QQ Plot*. A [quantile quantile plot](https://en.wikipedia.org/wiki/Q–Q_plot) which compares the distribution of the sample means to a normal distribution.

<iframe src="https://ianmadd.shinyapps.io/CentralLimitTheorem/" width = 100% height = 1200px >
    </iframe>

This simulation is based on code from [Quality and Innovation](https://qualityandinnovation.com/2015/03/30/sampling-distributions-and-central-limit-theorem-in-r/) and [ShinyEd](http://www2.stat.duke.edu/~mc301/shinyed/). The
code can be found on [github](https://github.com/IanMadd/CLT) and is hosted by
[shinyapps.io](https://ianmadd.shinyapps.io/CentralLimitTheorem/).

# Additional Sources {#additional_sources}

<br>

* [Sampling Distributions and Central Limit Theorem in R](http://www.r-bloggers.com/sampling-distributions-and-central-limit-theorem-in-r/)
* [Simulation of the Sampling Distribution of the Mean Can Mislead](/files/watkins.pdf)
* [The Use of R Language in the Teaching of Central Limit Theorem](http://atcm.mathandtech.org/EP2009/papers_full/2812009_17251.pdf)
* [Simulation: Central Limit Theorem](http://www.math.utah.edu/~treiberg/M3074Simulation.pdf)
* [UCLA: The Central Limit Theorem](http://www.stat.ucla.edu/~nchristo/introeconometrics/introecon_central_limit_theorem.pdf)
* [Sampling Distributions and the Central Limit Theorem](http://www.cios.org/readbook/rmcs/ch10.pdf)
* [In Brief: Standard Deviation and Standard Error](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3148365/)

<br>
