# Volatility Modeling with R

This project attempts to model volatility differently than the current methodologies. Volatility is present within several macroeconomic variables such as exchange rate, inflation, interest rate, etc. Due to its presence, econometricians faces several difficulties in analysis and forecasting. Volatility can be located in the sudden change in variance of the data in the _differenced_ form.

Here, it is assumed that the variance is stable, while the trend is what fluctuates, causing volatility. A rigorous economic interpretation of such a method is hard to carry out but is certainly not impossible. However, the objective of this project is to model volatility in the INR-USD exchange rate with such a method, hoping that it would be applicable in the general scenario.

## Installation

[R](https://www.r-project.org/) is required to execute this project. Link to install R on different OS:

  * [Linux](https://cran.r-project.org/bin/linux/ "link to install R") (installation from any package manager would be sufficient)
  * [MS-Windows](https://cran.r-project.org/bin/windows/base/ "link to install R")
  * [MacOS](https://cran.r-project.org/bin/macosx/ "link to install R")

Nothing except the _readxl_ package is required within R. The project here is developed with [RStudio IDE](https://www.rstudio.com/products/rstudio/download/#download "Download RStudio") (installed on [ArcoLinux](https://arcolinux.com/) and on [Solus OS](https://getsol.us/home/)).

## The Project and the Idea

The project aims to illustrate the novel idea that volatility is explainable by the trend, not the white-noise variance. The project involves simulation and re-estimation of the simulated data, such that those estimation techniques can be executed on the real-world data.

In lucid terms, the idea suggests that apart from modeling the variance of the _differenced_ form of the data with the usual _GARCH_ modeling, one may consider modeling the trend which would be more intuitive. The argument is that the fluctuations in the data are not just _noise_ but also a fluctuation of the inherent _habit/behavior_ of the variable. In this way, one might come to a better, or at least different, understanding of the economic interpretation behind the data.

## The Models

### ModelSimulation

In this section, we simulate volatility with the [Weierstrass function](https://en.wikipedia.org/wiki/Weierstrass_function). While the function is a sum of infinite series, the number of terms we use here is limited, specified with the _wfi_iteration_ term. The objective of this part is to illustrate the **idea** with simulated stable and volatile periods: the trend of the time series fluctuates, rather than the variance of the residuals.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/images/ModelSimulation1.jpeg "Part 1")

The user may change the values of _a_, _b_, _n_, _std_dev_, and _wfi_iteration_ in the beginning - to see the result of different combinations of the parameters generating processes ranging from seeming purely mathematical one to the closer to real-world time-series data.

The trend is included in all the plots to illustrate the idea. In the first part, the plot would show the simulation at zero-level autoregression (or AR(0)) form of the time-series with this idea, while in the third part, the plot shows the AR(1) form of the time series. In the second part, the plot shows how including an upward trend (in addition to the fluctuating trend shown) affects the same process. In the third part, the _rho_ variable is to specify the AR coefficient.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/images/ModelSimulation2.jpeg "Part 2")

The trend is included in all the plots to show how fluctuations in the trend result in volatility. The trend variable is what's different from the IIDN(0,std_dev) residual in the data. The trend in the second part is a function specified as _c*(t^n)_, which is added to the general trend. One may alter the constant _c_ and the power _n_ to alter the upward trend by making it a line, parabola, or any non-linear curvature.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/images/ModelSimulation3.jpeg "Part 3")

All of the simulated plots resemble the real-world data, but only for a specific range of values of the parameters (_a_, _b_, and _wfi_iteration_). The trend's association to the stability and volatility of the data is what is the key here - the data is volatile only in the period from 25 to 75 percentile, and is stable in both ends.

### Non-Linear Stable

In the real-world data, the testing would require first to seek whether the data distribution is in a stable and volatile process. The variance test of several portions of the time series may be useful for that. However, fitting the data with the _Weierstrass function_ with proper parameters requires non-linear regression techniques. Since the range of the parameter values can be found with the simulations, we may have a set of viable initializing parameters or a range of them.

Among several, one of the techniques is to find parameters that minimize the residual sum squared. The _nls_ function in R is also suitable for non-linear estimations. The Fourier analysis is also found to be useful in this case but is excluded for now.

The estimation of the stable processes is done in the beginning. Apart from the _nls_ method, a manual calculation of the least-square estimates is also used. The math behind that is stated below.

For the stable process, we have *wf_iteration* equals 1, and hence the residual sum squared can be found easily.

<img src="https://github.com/bosetridib/Volatility_Modelling/blob/main/images/NLSstableEstA.png" width=450/>

<img src="https://github.com/bosetridib/Volatility_Modelling/blob/main/images/NLSstableEstB.png" width=450/>

The solution of the last equation would give us the estimated parameter _b_. With that, we can calculate the estimated parameter _a_. In comparison, however, this method is found to be less efficient in practice: the estimated parameters with the _nls_ method are much closer to the actual parameters used in generating the data, and the estimated _a_ is found to be _biased_ with the least square technique.

### Non-Linear Volatile

In this section, we try to estimate the parameters assuming that the data is generated by the Weierstrass function. The objective here is not only to estimate parameters _a_ and _b_ only but also to the _wf_iteration_.

In the first part, the three parameters of the volatile processes are estimated by using the _optim_ function, and in the second part, the parameters are estimated by minimizing the RSS. Note that in both of these parts, the wf_iteration is estimated. It is in the third part where the wf_iteration is assumed to be known (estimations from the above two parts can be used).

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/images/NLSVolatile2.jpeg " NLS Volatile-2")

In all these illustrations, the left panel superimposes the actual and estimated residuals while the right panel superimposes actual and estimated _volatile trend_.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/images/NLSVolatile3.jpeg " NLS Volatile-3")

## The Estimation

The simulation and re-estimations in the above-mentioned sections seem sufficient to be applicable for real-world data. The remaining objective is only to estimate the INR-USD exchange rate with the methods applied to the simulated data. The data is in the file _Exchange Rate Daily.xls_, and the _ERDailyEstimation.R_ file deals with the estimation of the ER (daily exchange rate).

The first section deals with splitting the data in terms of volatile and stable periods. The variance of periods with 100 values is calculated, and then the split takes place concerning in which sets of periods the data seems volatile and stable.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/images/ERvar.jpeg " Exchange rate Variance")

The data is then split into four parts. The first and the last parts seem stable, while the second and third seem volatile. Moreover, the second and third parts are also treated differently.

The second section deals with estimating the stable periods. This is done through the usual _nls_ function in R, which was found to be quite useful in the simulations. The estimated parameters in both parts seem to be closer.

``` R
Formula: deltausds1 ~ alpha * cos(beta * xs1)

Parameters:
       Estimate Std. Error  t value Pr(>|t|)    
alpha  0.009856   0.008625    1.143    0.253    
beta   9.999674   0.001516 6597.203   <2e-16 ***
---
Signif. codes:  0 ???***??? 0.001 ???**??? 0.01 ???*??? 0.05 ???.??? 0.1 ??? ??? 1

Residual standard error: 0.1929 on 998 degrees of freedom

Number of iterations to convergence: 42 
Achieved convergence tolerance: 1.047e-06
```
``` R
Formula: deltausds2 ~ alpha * cos(beta * xs2)

Parameters:
       Estimate Std. Error   t value Pr(>|t|)    
alpha 4.463e-03  2.209e-03     2.021   0.0435 *  
beta  1.000e+01  7.078e-04 14132.866   <2e-16 ***
---
Signif. codes:  0 ???***??? 0.001 ???**??? 0.01 ???*??? 0.05 ???.??? 0.1 ??? ??? 1

Residual standard error: 0.05432 on 1208 degrees of freedom

Number of iterations to convergence: 15 
Achieved convergence tolerance: 9.805e-06
```
This resembles our hypothesis of stable periods having, more or less, the same properties.

The third part deals with estimating the volatile data. In this section, the volatile data is first standardized with respect to the expected residual's standard deviation and then estimated with loops. The estimated parameters after the iterations are noted in the comments. The plot of the data including the estimated trend of the data is given below.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/images/ERVolatile1.jpeg " ER Volatile-1")

As can be seen, the trend is somewhat capturing the volatility. By standardizing the data with the first stable period's residual's standard deviation (which is less than 1), the spread of the trend is increased respectively.