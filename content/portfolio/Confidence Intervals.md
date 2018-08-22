---
title: "Confidence Intervals When Sigma Is Known."
output: 
    html_document:
        fig_height: 4
        fig_width: 6
        toc: true # table of content true
        toc_float: false
        depth: 3  # upto three depths of headings (specified by #, ## and ###)
        number_sections: true  ## if you want number sections at each table header  
        theme: spacelab # many options for theme, this one is my favorite.
        highlight: tango # specifies the syntax highlighting style
---


## Libraries

```{r, message=FALSE, warning=FALSE}
library(data.table)
library(tigerstats)
```

#Finding Confidence Intervals Using NY City Tree Data

Import Data

So this is data from a 2015 tree census from NY City's [Open Data website](https://data.cityofnewyork.us). [Link to tree data.](https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh)

First we load it into a data.table.
```{r, cache=TRUE}
TreeCensus<- fread("data/2015_Street_Tree_Census_-_Tree_Data.csv")
dim(TreeCensus)
```

So this data set is 41 columns by 468,341 observations. 

And for this example we want to find the mean [diameter at breast height](https://en.wikipedia.org/wiki/Diameter_at_breast_height) (DBH) of the Pin Oak (Quercus palustris). We could simply tell R to tell us this information:

```{r}
TreeCensus[spc_common == "Pin Oak", mean(tree_dbh)]
TreeCensus[spc_latin == "Quercus palustris", mean(tree_dbh)]
```

<br>

It's a complete census so that's pretty easy, but if we didn't have that census data we could go out and sample a bunch of Pin Oaks and then draw some conclusions from that sample. The problem is that if we sampled 50 Pin Oaks we couldn't be 100% certain that the mean of that sample represents the mean of the population and it likely wouldn't be the same because of the problem of sampling error. So, what we're looking for is a range of possible values and a degree of confidence that the actual population mean is between those values. 

Standard confidence levels are 90%, 95% and 99%. For this example we'll do 95%

First let's sample 50 Pin Oaks from the census:

```{r}
PinOakSample<- TreeCensus[spc_latin == "Quercus palustris", sample(tree_dbh, 50)]
PinOakSample
```

<br>

So we can get the mean of our sample.

```{r}
mean(PinOakSample)
```

<br>
This is called a **point estimate**.

<br>
**Point Estimate**

* A point estimate of a population parameter is a single value used to estimate the population parameter. For example, the sample mean x is a point estimate of the population mean μ.

***

Now this sample will have a sampling error so we won't get the exact mean of the population of all trees that we would find in the data from the tree census. But it gets us fairly close. 

The question is, how close does it get us? There is no way of knowing for sure how close this estimate is to the population mean without the census data. But we can use an interval estimate to find a range of values that the population mean falls in.

**Interval Estimate**

* An interval estimate is defined by two numbers, between which a population parameter is said to lie. For example, a < μ < b is an interval estimate for the population mean μ. It indicates that the population mean is greater than a but less than b.

The population mean must be within a range of normally distributed values where the standard deviation is the standard deviation of the popuation and the mean is the mean of the sample. Our confidence in this range is the confidence level. 

**Confidence Level**

* In survey sampling, different samples can be randomly selected from the same population; and each sample can often produce a different confidence interval. Some confidence intervals include the true population parameter; others do not.

* A confidence level refers to the percentage of all possible samples that can be expected to include the true population parameter. For example, suppose all possible samples were selected from the same population, and a confidence interval were computed for each sample. A 95% confidence level implies that 95% of the confidence intervals would include the true population parameter.

Confidence levels are usually 90%, 95% or 99%.

So if we want to be 95% confident that the population mean is within a range then it must be somewhere within a normally distributed range that has the mean of the sample and standard deviation of the population.

```{r, fig.align='center'}
qnormGC(c(.95), region = "between", mean=mean(PinOakSample),sd=(TreeCensus[spc_common == "Pin Oak", sd(tree_dbh)]/sqrt(length(PinOakSample))), graph = TRUE)
```

The confidence interval is the range of values around the mean where, in this example, 95% of the mean values would lie.

##The Formula

The formula for finding this range:

$$\overline{X} \pm z_{\alpha / 2} \left( \frac{\sigma}{\sqrt{n}} \right)$$

<center>
OR
</center>

$$\overline{X} - z_{\alpha / 2} \left( \frac{\sigma}{\sqrt{n}} \right) < \mu < \overline{X} + z_{\alpha / 2} \left( \frac{\sigma}{\sqrt{n}} \right)$$

Where:

* $\overline{X}$ is the sample mean
* $\alpha$ is the confidence level and represents the total of the areas in both tails of the normal distribution.
* $\sigma$ is the population standard deviation
* $n$ is the number of measures in the sample

Also

* $z_{\alpha / 2} \left( \frac{\sigma}{\sqrt{n}} \right)$ is called the maximum error of the estimate. It is represent by the variable E.

The maximum error of the estimate is one-half the width of the confidence interval. 

###Finding Z Value

So first thing we do is take alpha and find the z score. Because we're finding the middle values of a normal distribution on both sides of the mean we have to divide alpha in two. Depending on [which](https://en.wikipedia.org/wiki/Standard_normal_table#Cumulative_from_mean_.280_to_Z.29) [z table](https://en.wikipedia.org/wiki/Standard_normal_table#Cumulative) we use there is a different method for finding the value of z. But both methods give the same answer.  

The Z-Score tells us the number of standard deviations from the mean on which a particular value falls. In this case we're find the number of standard deviations from the mean that contains 95% percent of our distribution.

####**Method #1**

[Cumulative Standard Normal Table](https://en.wikipedia.org/wiki/Standard_normal_table#Cumulative)

The Cumulateive Standard Normal Table gives cumulative percentages from 0% to 100% and from $-\infty \text{ to} +\infty$ with 50% equal to the mean or 0 in a standard normal distribution. 

Now since we are looking for a range of values in the middle of a distribution, or the middle 95%, and the cumulative standard normal table gives us values starting from $- \infty$ we have to convert the 95% to the equivalent value in a cumulative standard normal table. In other words we want the middle 95% plus everything that falls below the distribution all the way to %-\infty%.

$$\alpha = 1-.95 = .05$$

$$\alpha / 2 = .05 / 2 = .025$$

$$1-.025 = .975$$

Then using the [Cumulative Standard Normal Table](https://en.wikipedia.org/wiki/Standard_normal_table#Cumulative) we find that:

$$z_{\alpha/2} = 1.96$$ 

<center>
**OR**
</center>

```{r}
alpha <- 1-.95
z <- 1-(alpha/2)
z
alpha
alpha/2

qnorm(z, lower.tail=TRUE)
qnormGC(z, region="below", graph = TRUE)
```

<br>

Of course this also means that we could find the top end of the range as well, or the everything from $\infty$ to the top of the 95% range and get the same answer. 

```{r}
qnorm(alpha/2, lower.tail = FALSE)
qnormGC(alpha/2, region="above", graph = TRUE)
```
<br>

####**Method #2**

The [Cumulative From the Mean Standard Normal Table](https://en.wikipedia.org/wiki/Standard_normal_table#Cumulative_from_mean_.280_to_Z.29) gives cumulative values from the mean to a percentage. So we can do this...

$$\alpha/2 = .475$$ 

And from the [Cumulative From the Mean Standard Normal Table](https://en.wikipedia.org/wiki/Standard_normal_table#Cumulative_from_mean_.280_to_Z.29) we know that a probability of 0.475 gives a z value of 1.96.

Using the Cumulative From the Mean Standard Normal Table we find that 0.475 gives a z value of 1.96. This method seems to get to the heart of  $z_{\alpha / 2}$ as alpha should be the total percentage of values grouped around the mean that one wants to estimate, and we just want half of that percentage so we can get the range above and below the mean.

There isn't really a method for giving R a decimal percent of 0.475 and getting 1.96 in return. 

<br>

####**Method #3 Just Use R**

How you do it in R:

```{r, fig.align='center'}
qnorm(c(.025,.975))
```


<br>

**Three Methods**

Note that these all give the same answer.

<div class="col3">
```{r}
qnormGC(.95, region="between", graph = TRUE)

qnormGC(.975, region="below", graph = TRUE)

qnormGC(.025, region = "above", graph=TRUE)

```
</div>

<br>


###Finding The Maximum Error Of The Estimate

So now we're calculating the formula $z_{\alpha / 2} \left( \frac{\sigma}{\sqrt{n}} \right)$

We've got a value for $z_{\alpha / 2}$ which is 1.96, now we just need to plug in $\sigma$ and n.

```{r}
z_value <- qnorm(z, lower.tail = TRUE)
z_value
MaximumErrorOfEstimate <- z_value*(TreeCensus[spc_common == "Pin Oak", sd(tree_dbh)]/sqrt(length(PinOakSample)))

MaximumErrorOfEstimate
```

Then we just have to find our range above and below the mean, which is:
```{r}
mean(PinOakSample) - MaximumErrorOfEstimate
mean(PinOakSample) + MaximumErrorOfEstimate
```

<br>
So the actual mean DBH of the census is approximately 15.6 which falls within the confidence interval.  

<br>

#Just Do The Operation in R


<br>
The easier way to do this is to just load all this information in qnorm including both the upper and lower bounds of the distribution.

```{r, fig.align='center'}
qnorm(c(alpha/2,(1-alpha/2)), mean=mean(PinOakSample), sd=(TreeCensus[spc_common == "Pin Oak", sd(tree_dbh)]/sqrt(length(PinOakSample))), lower.tail=TRUE)

qnormGC(.95, mean=mean(PinOakSample), sd=(TreeCensus[spc_common == "Pin Oak", sd(tree_dbh)]/sqrt(length(PinOakSample))), region = "between", graph = TRUE)
```
<div>

#Range of Different Confidence Intervals

Now different levels of certain will change the size of the range. If you want more certainty then the range will be larger, if less certainty is ok then the range will be smaller. Here are the 90% and 99% confidence intervals. Note that the 99% confidence interval has a wider range.

<div class="col2">
```{r}
qnormGC(c(.90), region = "between", mean=mean(PinOakSample),sd=(TreeCensus[spc_common == "Pin Oak", sd(tree_dbh)]/sqrt(length(PinOakSample))), graph = TRUE)
```

```{r}
qnormGC(c(.99), region = "between", mean=mean(PinOakSample),sd=(TreeCensus[spc_common == "Pin Oak", sd(tree_dbh)]/sqrt(length(PinOakSample))), graph = TRUE)
```

</div>

#Other Stuff

As a fun exercise (fun?) we can create a bunch of sample means and show that a certain number of them are actually greater than the 95% confidence interval.

This first bit of code creates a list of 1000 sample means. 
```{r}
PinOakSampleMeans <- vector('numeric')
for( i in 1:1000){
    PinOakSampleMeans<- append(PinOakSampleMeans,mean(TreeCensus[spc_latin == "Quercus palustris", sample(tree_dbh, 50)]))
}
```

<div>

So we're finding the percentage of times where the population mean falls within the 95% confidence interval of a sample mean.

In other words, if this function indicates that the population mean is within a range of values 95% of the time, then we should find that these sample means fall within the 95% confidence interval of the population mean 95% of the time.

```{r}
#95% confidence interval for population mean

qnorm(c(.025,.975), mean=TreeCensus[spc_common=="Pin Oak", mean(tree_dbh)], sd = TreeCensus[spc_common == "Pin Oak", sd(tree_dbh)]/sqrt(length(PinOakSample)))


#The percentage of values outside of the confidence interval.

length(PinOakSampleMeans[PinOakSampleMeans > (TreeCensus[spc_common=="Pin Oak", mean(tree_dbh)] + MaximumErrorOfEstimate) | PinOakSampleMeans < (TreeCensus[spc_common=="Pin Oak", mean(tree_dbh)] - MaximumErrorOfEstimate)]) / length(PinOakSampleMeans)
```



```{r}
hist(PinOakSampleMeans)
```



#Sample Size

This brings us to another issue. What is the minimum sample size if we want an accurate sample mean. The correct sample size depends on three things:

* The maximum error estimate (E)
* The population standard deviation $\sigma$
* the degree of confidence (90%, 95%, or 99%)

$$E=z_{\alpha / 2} \left( \frac{\sigma}{\sqrt{n}} \right)$$

and solving for n gives us:

$$n = \left(\frac{z_{\alpha / 2} \cdot \sigma}{E} \right)^{2}$$

So in our example of our Pin Oaks with a 95% confidence level the math would look like this:

$$n = \left(\frac{1.959964 \cdot 9.783641}{2.711837} \right)^{2}$$
$$n = 50$$

If there's a fraction, round up to the next highest whole number.

Here are the minimum sample sizes for the three different confidence levels, 90%, 95% and 99%:

```{r}
z_values <- c(qnorm((1-((1-.90)/2)), lower.tail = TRUE), qnorm((1-((1-.95)/2)), lower.tail = TRUE), qnorm((1-((1-.99)/2)), lower.tail = TRUE))

((z_values * TreeCensus[spc_common == "Pin Oak", sd(tree_dbh)])/MaximumErrorOfEstimate)^2
```

So, as the level of certainty increases, the number of samples must also increase. 



