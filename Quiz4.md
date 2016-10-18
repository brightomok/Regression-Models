---
title: "Ryan Tillis - Data Science - Regression Models - Quiz 4 - Coursera"
author: <a href="http://www.ryantillis.com"> Ryan Tillis </a>
date: "August 4, 2016"
output: html_document
---

```{r setup, include=FALSE, echo=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Quiz 4

This is Quiz 4 from Coursera's Regression Models class within the Data Science Specialization. This publication is intended as a learning resource, all answers are documented and explained. Datasets are available in R packages.

<hr>

<font size="+2">**1.**  </font>Consider the space shuttle data ?𝚜𝚑𝚞𝚝𝚝𝚕𝚎 in the 𝙼𝙰𝚂𝚂 library. Consider modeling the use of the autolander as the outcome (variable name 𝚞𝚜𝚎). Fit a logistic regression model with autolander (variable auto) use (labeled as "auto" 1) versus not (0) as predicted by wind sign (variable wind). Give the estimated odds ratio for autolander use comparing head winds, labeled as "head" in the variable headwind (numerator) to tail winds (denominator).

<hr>

* <font size="+1">**Answer:** 0.969</font>

<hr>

#####Explanation:
Fitting the model using a binomial distribution gives a beta coefficient of .031.

```{r Question 1}
library(MASS)
data(shuttle)
head(shuttle)

#Checking out the data
unique(shuttle$use)
unique(shuttle$wind)

#Creating 0,1 variable for auto/noauto factor
shuttle$use <- as.numeric(shuttle$use == "auto")

#generating model
mdl <- glm(factor(use)~factor(wind)-1,binomial,data = shuttle)

exp(mdl$coef[1])/exp(mdl$coef[2])
```

<hr>
<font size="+2">**2.**  </font> Consider the previous problem. Give the estimated odds ratio for autolander use comparing head winds (numerator) to tail winds (denominator) adjusting for wind strength from the variable magn.
<hr>

* <font size="+1">**0.969
**</font>

<hr>

#####Explanation:

The unadjusted beta values are higher. Weight is confounding significantly.

```{r Q2}
#Checking out the factor levels
unique(shuttle$magn)
mdl2 <- glm(factor(use)~factor(wind)+factor(magn)-1,binomial,data = shuttle)
summary(mdl2)
exp(mdl2$coef[1])/exp(mdl2$coef[2])
```
<hr>

<font size="+2">3.  </font> If you fit a logistic regression model to a binary variable, for example use of the autolander, then fit a logistic regression model for one minus the outcome (not using the autolander) what happens to the coefficients?

<hr>

* <font size="+1">**The coefficients reverse their signs.**</font>

<hr>

#####Explanation:

The sign of the ceofficient flips. One minus a binary variable flips zeros with 1 and vice versa.

```{r Question 3}
mdl3 <- glm(1-use~factor(wind)-1,binomial,data = shuttle)
mdl3$coef
mdl$coef
```

<hr>

<font size="+2">**4.**  </font> Consider the insect spray data 𝙸𝚗𝚜𝚎𝚌𝚝𝚂𝚙𝚛𝚊𝚢𝚜. Fit a Poisson model using spray as a factor level. Report the estimated relative rate comapring spray A (numerator) to spray B (denominator). 

<hr>

* <font size="+1">**0.9457**</font>

<hr>

#####Explanation:

Mtcars reports the weight in units of 1000 lbs. Using I(wt*.5) doubles the weight coefficient from the previous model. This reflects a 2000 lbs (1 ton) increase holding the factor variable fixed.

```{r Question 4}
data("InsectSprays")
mdl4 <- glm(count~spray-1,poisson,data = InsectSprays)
exp(mdl4$coef[1])/exp(mdl4$coef[2])
```

<hr>

<font size="+2">5.  </font> Consider a Poisson glm with an offset, t. So, for example, a model of the form 𝚐𝚕𝚖(𝚌𝚘𝚞𝚗𝚝 ~ 𝚡 + 𝚘𝚏𝚏𝚜𝚎𝚝(𝚝), 𝚏𝚊𝚖𝚒𝚕𝚢 = 𝚙𝚘𝚒𝚜𝚜𝚘𝚗) where 𝚡 is a factor variable comparing a treatment (1) to a control (0) and 𝚝 is the natural log of a monitoring time. What is impact of the coefficient for 𝚡 if we fit the model 𝚐𝚕𝚖(𝚌𝚘𝚞𝚗𝚝 ~ 𝚡 + 𝚘𝚏𝚏𝚜𝚎𝚝(𝚝𝟸), 𝚏𝚊𝚖𝚒𝚕𝚢 = 𝚙𝚘𝚒𝚜𝚜𝚘𝚗) where 𝟸 <- 𝚕𝚘𝚐(𝟷𝟶) + 𝚝? In other words, what happens to the coefficients if we change the units of the offset variable. (Note, adding log(10) on the log scale is multiplying by 10 on the original scale.)

<hr>

* <font size="+1">**The coefficient estimate is unchanged**</font>

<hr>

#####Explanation:

Coefficient stays because poisson regression is modeling odds so the multiplicative offset will cancel out.

```{r Question 5}
mdl5 <- glm(count~spray,poisson,offset = log(count+1),data = InsectSprays)
mdl6 <- glm(count~spray,poisson,offset = log(10)+log(count+1),data = InsectSprays)
mdl6$coef
mdl5$coef
```

<hr>

<font size="+2">**6.**  </font> Consider the data
```{r set2}
x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)
```
Using a knot point at 0, fit a linear model that looks like a hockey stick with two lines meeting at x=0. Include an intercept term, x and the knot point term. What is the estimated slope of the line after 0?

<hr>

* <font size="+1">**1.013**</font>

<hr>

#####Explanation:

To give the coefficients R automatically subtracted the mean slope of the first line from that of the second, so we can simply add it back to get the true value.


```{r Question 6}
x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)

k<-c(0)
split<-sapply(k,function(k) (x>k)*(x-k))
xmat<-cbind(1,x,split)
mdl7 <- lm(y~xmat-1)
yhat<-predict(mdl7)
mdl7$coef
mdl7$coef[3]+mdl7$coef[2]
plot(x,y)
lines(x,yhat, col= "red", lwd =2)
```

<hr>
Check out my website at: <http://www.ryantillis.com/>
