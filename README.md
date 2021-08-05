# Volatility Modeling with R

Volatility is present within several macroeconomic variables such as exchange rate, inflation, interest rate, etc. Due to its presence, econometric analysis and forecasting is faced with several difficulties. The volatility can be located in the sudden change in variance of the data in the differenced form, and is modelled as such. The econometric treatment of volatility includes regressing the variance of the data (in differenced form) on the lagged variances. But this project attempts to model voaltility differently. It will be assumed that the variance is stable, while the trend is what would cause the volatility. A rigorous economic interpretation of such method is hard to carry out, but is certainly not impossible. However, the objective of this project is to model volatility in the INR-USD exchange rate with such method, hoping that it would be applicable in the general scenario.

## Installation

Nothing except R (https://www.r-project.org/) is currently required to run this project. Moreover, nothing except the built-in packages are required within R. The MS-Windows link to install R is https://cran.r-project.org/bin/windows/base/, and the MacOS link is https://cran.r-project.org/bin/macosx/. For linux one may see https://cran.r-project.org/bin/linux/, but installation from any package manager would be sufficient.

I used RStudio IDE (https://www.rstudio.com/products/rstudio/download/#download) which can be downloaded from their official website or from any available linux package managers.

## The models

### Model-1

In this model, we simulate volatility with the Weierstrass function. While the function is a sum of infinite series, the number of terms we use in the series is specified.