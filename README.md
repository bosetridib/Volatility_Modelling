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

In this model, we simulate volatility with the Weierstrass function. While the function is a sum of infinite series, the number of terms we use in the series is specified with 'wfi_iteration' term. The objective of this part is to illustrate the _idea_ with simulated stable and volatile periods, in which the trend of the time series fluctuates, rather than the variance of the residuals.

The user may change the values of a, b, n, std_dev and wfi_iteration to see the result of different combinations of the parameters generating processes which ranges from seeming purely mathematical one to the closer to real-world time-series data.

In the first part, the plot would show the differenced form of the time-series with this idea, while in the second part, the plot shows the AR(1) form of the time series. The trend is included in both parts to illustrate the idea.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/ModelSimulation1.jpeg)


![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/ModelSimulation2.jpeg)

In the third part, the plot would show the AR(1) form of the time-series with the same idea. The objective here is to show that the AR(1) trend is stable, and after the first difference, the variance-tests shows the same result as the previous one.

![alt text](https://github.com/bosetridib/Volatility_Modelling/blob/main/ModelSimulation3.jpeg)
