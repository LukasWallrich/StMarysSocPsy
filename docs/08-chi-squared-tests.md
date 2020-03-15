# Chi-squared tests for associations between categorical variables

TK: add video

When we want to see whether two categorical variables are associated with each other, typical linear models won't work. Instead, we need a new way to decide whether a difference between the data we observe and that which we expect under the null-hypothesis is unlikely to occur due to chance. But before we get to that, we should look at the data.

## Tables of frequencies and proportions

With two categorical variables, the data we observe can best be shown in a frequency table - i.e. a table that shows how many observations fall into each combination of categories of the two variables. This is created with the ` table()` function. Let's look an example of the association between political parties and their winning candidates' gender in the 2019 UK general election. (Note that this is based on the official statistics published by the election authorities, who registered candidate gender as a binary variable.)





```r
table(constituencies$ElectionWon, constituencies$WinnerGender)
```

```
##      
##       Female Male
##   Con     87  278
##   Lab    104   98
##   LD       7    4
##   SNP     16   32
```

If there is an association between the two variables, then the proportional distribution will differ between the rows (i.e. one party would have a higher *share* of women than another party). To see whether that is the case, proportion tables that show shares are helpful. These can be created from the `table()` output with the `prop.table()` function. However, there are three options for proportions: are we interested in the share of each cell as a part of the total number of candidates? Or as a share of all winning candidates of a gender (i.e what share of female winning candidates are from the Conservative party)? Or rather the shares of women and men as a share of the total winning candidates of each party? In this case the latter seems most relevant and interpretable.


```r
x <- table(constituencies$ElectionWon, constituencies$WinnerGender)
#prop.table(x) - share of each cell as part of the total
#prop.table(x, margin = 2) - share of each cell as part of the column
prop.table(x, margin = 1) %>% #Share of each cell as part of the row
   round(2) #Round to 2 decimal places
```

```
##      
##       Female Male
##   Con   0.24 0.76
##   Lab   0.51 0.49
##   LD    0.64 0.36
##   SNP   0.33 0.67
```

## The null hypothesis and the $\chi^2$ statistic

To be able to test whether any differences between the rows or between the columns that we observe in a frequency table are statistically significant, we need to be clear on what the null hypothesis is. If two variables are statistically independent, then their distribution needs to be the same across each row and along each column. This does not mean that all cells need to have the same value, In our case, given that there are many more male than female election winners and many more Conservative MPs than MPs of any other party, we would expect the male Conservatives cell to have the highest number of observations if there was no relationship between party and winning candidates' gender, i.e. if the null hypothesis was true. 

The expected number of observations in each cell under the null hypothesis can be calculated as the share of its row entire row of the total observations (e.g., the total share of female candidates) * the share of its column of the total (e.g., the total share of Labour candidates) * the total number of observations. Based on that logic, the expected number of observations per cell would be the following.


```
##                           constituencies$WinnerGender
## constituencies$ElectionWon Female Male
##                        Con    125  240
##                        Lab     69  133
##                        LD       4    7
##                        SNP     16   32
```

Once we know what to expect under the null-hypothesis, we need a way to see how far our observed data diverges from that. The $\chi^2$ (chi-squared) test statistic provides a way of measuring that distance in a way that is independent of our sample size and therefore comparable across studies. It is calculated as follows, where O is the *observed* number of cases per cell of the frequency table and E is the *expected* number under the null-hypothesis:

$$\chi^2=\sum\frac{(O-E)^2}E$$

In R, easiest way to calculate it and test whether the distance of the observed distribution from the null distribution is statistically significant is to use the chisq.test() function.

## The chisq.test() function

As a simple fictional example, we might be interested in whether Scottish and British people differ in their preference for tea versus coffee. If we ask 100 people, we might observe the following distribution:




```r
table(prefData$nationality, prefData$preference)
```

```
##           
##            Coffee Tea
##   English      45  95
##   Scottish     30  30
```

To calculate the distance from distribution expected if there was no association between nationality and tea preference, we use the chisq.test() function. That also gives us an associated *p*-value.


```r
chisq.test(prefData$nationality, prefData$preference, correct = F)
```

```
## 
## 	Pearson's Chi-squared test
## 
## data:  prefData$nationality and prefData$preference
## X-squared = 5.7143, df = 1, p-value = 0.01683
```

In this case, we would conclude that there is a statistically significant difference, with English people preferring tea more frequently than Scottish people do, $\chi^2$(1) = 4.98, *p* = .016. 

### Dealing with small samples

When testing the significance of $\chi^2$-values, the calculated values are compared to a continuous distribution. When you have a small sample, however, your possible $\chi^2$-values cannot be continous; rather, a single observation shifting from one cell to another would be associated with a substantial jump in the $\chi^2$ statistic. This can make the normal *p*-values far too low in such cases, and therefore lead to Type I errors (false positives).

It is often recommended that $\chi^2$ should not be used with samples where the expected frequency in more than 20% of the cells is less than 5. In a 2x2 table (i.e when each of the two variables has only two possible categories), the Yates correction can be used to reduce the $\chi^2$-value and therefore make the test more conservative (R does that by default in `chisq.test()`, but it can be turned off by setting `correct = FALSE`). However, this sometimes goes too far, so my recommendation is to simulate *p*-values for any samples where you have cells with low expected frequencies (say less than 20 expected cases in the smallest cell). You can do that by setting `simulate.p.value = TRUE` in the function call. Note that like any simulation, this is based on random number generation, so that `set.seed()` should be used with a fixed number of your choice to ensure that the results can be reproduced.

If we were to rerun the example above with a smaller sample but more extreme differences, we can compare the three possible methods of calculating $\chi^2$. To see how small the smallest expected value is, we can look at the `expected` element of the output of the chisq.test() function.


```r
table(prefDataSmall$nationality, prefDataSmall$preference)
chisq.test(prefDataSmall$nationality, prefDataSmall$preference, correct = F)
```

```
##           
##            Coffee Tea
##   English      12  30
##   Scottish     10   8
## 
## 	Pearson's Chi-squared test
## 
## data:  prefDataSmall$nationality and prefDataSmall$preference
## X-squared = 3.9508, df = 1, p-value = 0.04685
```

It looks like the difference is significant. However, we should consider how small the smallest expected cell count is, to decide whether we need to adjust our way of testing significance. For that, we can look at the `expected` element of the output of the chisq.test() function.


```r
chisq.test(prefDataSmall$nationality, prefDataSmall$preference, correct = F)$expected
```

```
##                          prefDataSmall$preference
## prefDataSmall$nationality Coffee  Tea
##                  English    15.4 26.6
##                  Scottish    6.6 11.4
```

With fewer than 7 expected cases of Scottish coffee drinkers, the standard $\chi^2$ significance test is not reliable. Therefore, we either need to use the correction or simulation. Given that the simulation is based on random numbers, we should use the `set.seed()` function to initialise the random number generator - that makes sure that the results are reproducible.


```r
set.seed(300688)
chisq.test(prefDataSmall$nationality, prefDataSmall$preference, correct = T)
chisq.test(prefDataSmall$nationality, prefDataSmall$preference, simulate.p.value = T)
```

```
## 
## 	Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  prefDataSmall$nationality and prefDataSmall$preference
## X-squared = 2.8742, df = 1, p-value = 0.09001
## 
## 
## 	Pearson's Chi-squared test with simulated p-value (based on 2000
## 	replicates)
## 
## data:  prefDataSmall$nationality and prefDataSmall$preference
## X-squared = 3.9508, df = NA, p-value = 0.07496
```

These other two methods agree that caution is needed. Usually, the simulated *p*-value will be a bit lower and a bit more accurate than the result of the Yates' continuity correction, so I would report that the data shows a trend towards a greater preference for tea among English respondents that falls short of the conventional standard of statistical significance, with $\chi^2$ = 3.95, *p* = .075 (based on 2000 Monte Carlo simulations).

## Post-hoc tests

$\chi^2$-tests can be used to test for an association between variables with many different levels, such as music preferences or political parties. In that case, a significant result only tells us that at least one of the cell counts is significantly different from the expectation under the null-hypothesis. To get more details, post-hoc tests would be needed. To go back to the example at the start, let's test whether the winning candidates' gender differed significantly between the major UK parties in the 2019 General Election. It certainly looks that way from the proportions table, and the `chisq.test()` agrees


```r
prop.table(x, margin = 1) %>% #Share of each cell as part of the row
   round(2) #Round to 2 decimal places

chisq.test(constituencies$ElectionWon, constituencies$WinnerGender,
           simulate.p.value = TRUE)
```

```
##      
##       Female Male
##   Con   0.24 0.76
##   Lab   0.51 0.49
##   LD    0.64 0.36
##   SNP   0.33 0.67
## 
## 	Pearson's Chi-squared test with simulated p-value (based on 2000
## 	replicates)
## 
## data:  constituencies$ElectionWon and constituencies$WinnerGender
## X-squared = 48.504, df = NA, p-value = 0.0004998
```

However, this does not allow us to answer questions about any specific parties. For that, we need post-hoc tests. The most common tests compare each cell to its expected value under the null-hypothesis, but other tests are possible. For instance, you might be more interested to compare parties to each other rather than to this expected (average) value. For that, you would need to filter your data and run multiple chisq.tests.

To compare each cell to the expected value, we can use the `chisq.posthoc.test` package. This package contains the `chisq.posthoc.test()` function that takes a table as the input and computes standardised residuals (i.e. distances) and *p*-values for each cell. To avoid an inflated error rate, it can correct for multiple comparisons; by default the Bonferroni correction is used.


```r
library(chisq.posthoc.test)
table(constituencies$ElectionWon, constituencies$WinnerGender) %>% chisq.posthoc.test(simulate.p.value = TRUE, method = "bonferroni")
```

```
##   Dimension     Value     Female       Male
## 1       Con Residuals -6.4559388  6.4559388
## 2       Con  p values  0.0000000  0.0000000
## 3       Lab Residuals  6.2985557 -6.2985557
## 4       Lab  p values  0.0000000  0.0000000
## 5        LD Residuals  2.0776181 -2.0776181
## 6        LD  p values  0.3019560  0.3019560
## 7       SNP Residuals -0.1295052  0.1295052
## 8       SNP  p values  1.0000000  1.0000000
```
 
In this table, the *p*-values can tell us which party/gender combinations differ significantly from the expectation under the null-hypothesis, while the sign of the residuals indicates the direction of the effect. Thus we can see that the Conservatives had significantly fewer male winning candidates while Labour had significantly more.
 
*A note on statistical power and the importance of thinking about corrections:* This approach to running post-hoc tests runs one test per cell. In this situation with 2 genders and 4 parties, we have 8 cells, so that the Bonferroni correction multiplies each *p*-value by 8, which makes it relatively hard to detect effects. However, as should be clear from the table, in cases where one variable has only two levels, half of the tests are redundant. If we know that the Conservatives have significantly fewer female winners, it follows necessarily that they have significantly more male winners. *p*-values in each row are identical, and the residuals are symmetric. Therefore, we should only count half of the tests, and multiply p-values by 4 rather than 8. The general point is that it is essential to check how many tests a post-hoc functions counts in adjusting *p*-values by comparing the *p*-values reported when the adjustment parameter is set to "none" to those reported with "bonferroni" correction. Then make sure that you understand where that number comes from and that it makes sense in your situation.

## Effect sizes

As always, finding that the variables are related to a statistically significant degree is only the first step, and you also want to report the strength of the relationship. Clear proportion tables are essential here, and then there are two options to sum up the strength of relationships into a single number: **Cramer's V** as a standardised measure of the strength of an association between two categorical variables, and the **Odds Ratio** of being in one cell rather than another.

**Cramer's V** describes a full table, and is scaled from 0 (no relationship) to 1 (one variable is entirely predictable by the other). It is often recommended that one should be weary of values greater than .5, as that suggests that the two variables might be redundant. Many packages offer functions to calculate Cramer's V, including the `effectsize` package that allows us to calculate it based on the $\chi^2$-value, the sample size, and the number of levels of each variable.


```r
library(effectsize)
chisq_to_cramers_v(chisq = 48.5, n = 626, nrow=4, ncol=2)
```

```
## [1] 0.2783452
```

While this is a helpful statistic to compare effect strengths across multiple tests, it does not have an intuitive interpretation. Here, Odds Ratios might help. They can only be calculated for 2x2 tables, for instance for the fictional example regarding tea and coffee preferences. 


```
##           
##            Coffee Tea
##   English      45  95
##   Scottish     30  30
```

Here an **Odds Ratio** would state how much more likely it is to get a tea afficionado if we ask an English rather than a Scottish person. Odds are the ratio of the frequency of specified outcomes over the frequency of other outcomes. For instance, the odds of it being Sunday on a random day are 1 to 6. In this case, the odds for getting a tea afficionado when picking out an English person would be 95:45, while they would be 30:30 for a Scottish person. Thus the odds ratio would be $$OR = \frac{\frac{95}{45}}{\frac{30}{30}}=2.1$$, so that I would be 

* 2.1x more likely to get a tea afficionado rather than a coffee afficionado when picking out an English person from this sample than a Scottish person,
* 2.1x more likely to get a coffee afficionado rather than a tea afficionado when picking out a Scottish person rather than an English person from this sample,
* 2.1x more likely to have an English person in front of me when I encounter a tea afficionado from this sample, 
* and 2.1x more likely to have a Scottish person in front of me when I encounter a coffee afficionado from this sample.



All of these statements should be easier to interpret than a Cramer's V index of .17 (which happens to be the value of this sample). Of course you should pick which one of the ways of framing the relationship is the best answer to the question at hand, rather than reporting the same information multiple times.