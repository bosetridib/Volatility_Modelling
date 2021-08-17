# Volatility Modeling with R

Volatility is present within several macroeconomic variables such as exchange rate, inflation, interest rate, etc. Due to its presence, econometric analysis and forecasting is faced with several difficulties. The volatility can be located in the sudden change in variance of the data in the differenced form, and is modelled as such. Excluding the econometric treatment of volatility, this project attempts to model voaltility differently. It will be assumed that the variance is stable, while the trend is what would cause the volatility. A rigorous economic interpretation of such method is hard to carry out, but is certainly not impossible. However, the objective of this project is to model volatility in the INR-USD exchange rate with such method, hoping that it would be applicable in the general scenario.

## Installation

Nothing except R (https://www.r-project.org/) is currently required to run this project. Moreover, nothing except the built-in packages are required within R. The MS-Windows link to install R is https://cran.r-project.org/bin/windows/base/, and the MacOS link is https://cran.r-project.org/bin/macosx/. For linux one may see https://cran.r-project.org/bin/linux/, but installation from any package manager would be sufficient.

I used RStudio IDE (https://www.rstudio.com/products/rstudio/download/#download) which can be downloaded from their official website or from any available linux package managers. The project here is developed with RStudio IDE installed on two linux distribution - Arcolinux and on Solus OS, with which I carried out this project.

## The Project and the Idea

That volatility can be explained by the trend and not the variance, is a novel idea. But to illustrate, and even to successfully execute the testing of this idea requires simulations. As the simulations done does reflects, the real-world data, yet at least partially, we go further and re-estimate the parameters of the simulated models so as to establish the applicable methods.

In lucid terms, one might be suggested that apart from modelling the variance of the differenced form of the data, one may consider to model the trend which would would be more intuitive than the general definitions. If one argues that the fluctuations in the data is not just _noise_ but also a fluctuation of _habit/behavior_ of the variable, then one might come to a better understanding of the economic interpretation behind the data.

## The Models

### ModelSimulation

In this section, we simulate volatility with the Weierstrass function. While the function is a sum of infinite series, number of terms we use in the series is specified with _wfi_iteration_ term. Objective of this part is to illustrate **the idea** with simulated stable and volatile periods, in which the trend of the time series fluctuates, rather than variance of the residuals.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/ModelSimulation1.jpeg "Part 1")

The user may change the values of _a_, _b_, _n_, _std_dev_ and _wfi_iteration_ in the beginning - to see the result of different combinations of the parameters generating processes ranging from seeming purely mathematical one to the closer to real-world time-series data.

In the first part, the plot would show the zero-level autoregression or AR(0) form of the time-series with this idea, while in the third part, the plot shows the AR(1) form of the time series. The trend is included in both parts to illustrate the idea. In the second part, the plot shows how including an upward trend affects the same process. In the third part, the _rho_ variable is to specify the AR coefficient.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/ModelSimulation2.jpeg "Part 2")

The trend (which is different from the upward trend included in the 2nd part) is included in all the plots. It is to shows how fluctuations in the trend only, resembles data which seems volatile in nature. The trend part is what's different from the IIDN(0,std_dev) part. The trend in the second part is a function of specified as u*t^v, which is included in the general trend.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/ModelSimulation3.jpeg "Part 3")

All of the simulations resembles plots closer to the real-world data, but only for a specific range of values of the parameters. The trend's association to the stability and volatility of the data is what is the key here.

### NLS Method

In the real-world data, the testing would first require whether the data is distributed in stable and volatile process. For that, the variance test of several portions of the time-series should be performed. However, fitting of the data with the Weierstrass function with proper parameters requires non-linear regression techniques. Since the range of the values of the parameters can be found with the simulations, we may have a set of viable initializing parameters, or a range of them.

Among several, one of the techniques is to find parameters which minimize the residual sum squared. The r-function _nls_ is also suitable for non-linear estimations. The Fourier analysis is also found to be used in this case.

The estimation of the stable processes is done in the beginning. Apart from the _nls_ method, a manual calculation of the least-square estimates is also used. The math behind that is stated below.

For the stable process, we have *wf_iteration* equals 1, and hence the residual sum squared can be found easily.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/NLSstableEstA.png "NLS Stable Estimation for a")

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/NLSstableEstB.png "NLS Stable Estimated b")

The solution of the last equation would give us the estimated parameter _b_. With that, we can caluclate the estimated parameter _a_. In comparison, this method is found to be less efficient in practice: the estimated parameters with _nls_ method are much closer to the actual parameters used in generating the data, and the estimated _a_ is found to be _biased_ with the least square technique.