# ================= Estimation of INR-USD Exchange Rate ================= #

# The loading of dataset from the xls file can be done easily with the
# read_excel function in the readxl package. The date variable is in character
# format, and is converted to the date-datatype in R.
library(readxl)
er <- read_excel("Exchange Rate Daily.xls")
er$Date <- as.Date(er$Date, format = "%d/%m/%Y")

# The number of observations can be found with the length of first column.
n <- length(er[[1]])

# The supposedly volatile data can be first-order differenced, and is then
# plotted.
deltausd <- diff(er$USD)
plot(er$Date, er$USD, type="l")
plot(er$Date[-n], deltausd, type="l")

# --------------------- 1. Splitting Dataset --------------------- #

# The calculation of change in variance from period to period is done with
# breaking the data in several small intervals. The plot gives us a visual
# representation of how the variance of several periods in the data is
# significantly different.

varusd <- NULL
br <- 100

for (i in 1:(n/br))
{
  varusd[i] <- var(
    deltausd[
      ((br*(i-1))+1) : (br*i)
    ]
  )
}

plot(varusd, type="l")

# Now, the data seems to begin with unstable variance at 10th break, which then
# ends at 37th break.

deltausds1 <- deltausd[1:(10*br)]
deltausdv <- deltausd[(10*br + 1):(36*br - 1)]
deltausds2 <- deltausd[(36*br):n]

xs1 <- 1:length(deltausds1)
xv <- 1:length(deltausdv)
xs2 <- 1:length(deltausds2)





# ------------------ 2. Estimating Stable Periods ------------------ #

init_parameters_stable <- list(alpha = 1, beta = 10)

model_nls_stable1 <- nls(deltausds1 ~ alpha*cos(beta*xs1), start = init_parameters_stable)
summary(model_nls_stable1)

# The line function plots the difference between actual trend and fitted model
plot(xs1, deltausds1)
lines(xs1, fitted(model_nls_stable1))





# Regression for s2 . . .

init_parameters_stable <- list(alpha = 1, beta = 10)

model_nls_stable2 <- nls(deltausds2 ~ alpha*cos(beta*xs2), start = init_parameters_stable)
summary(model_nls_stable2)

# The line function plots the difference between actual trend and fitted model
plot(xs2, deltausds2)
lines(xs2, fitted(model_nls_stable2), col = 'blue')


# Regression for v . . .

wf <- function(x,n,a,b)
{
  v <- NULL
  for(j in 1:n)
  {
    v[j] <- (a^j)*cos((b^j)*x)
  }
  return(sum(v))
}

plot(xv, deltausdv)
yv <- wf(x=xv,n=5,a=acofs1,b=bcofs1)
lines(xv,yv)