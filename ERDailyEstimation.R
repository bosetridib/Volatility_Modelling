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

coeffests1 <- function(betas1)
{
  (sum(deltausds1 * cos(betas1*xs1)) * sum(xs1*sin(betas1*2*xs1)))
  - (2*sum(xs1*deltausds1*sin(betas1*xs1)) * sum((cos(betas1*xs2))^2))
}

llimit <- 0.0001
ulimit <- 10000

bcofs1 <- uniroot(coeffests1, interval = c(llimit,ulimit), extendInt = "yes")$root
acofs1 <- sum(deltausds1*cos(bcofs1 * xs1))/sum((cos(bcofs1*xs1))^2)

plot(xs1, deltausds1)
lines(xs1, acofs1*cos(bcofs1*xs1), col="brown")

resids1 <- deltausds1 - acofs1*cos(bcofs1*xs1)
plot(xs1,resids1,type="l")

library(normtest)
jb.norm.test(resids1)
qqnorm(resids1)
qqline(resids1)




# Regression for s2 . . .

coeffests2 <- function(betas2)
{
  (sum(deltausds2 * cos(betas2*xs2)) * sum(xs2*sin(betas2*2*xs2)))
  - (2*sum(xs2*deltausds2*sin(betas2*xs2)) * sum((cos(betas2*xs2))^2))
}

bcofs2 <- uniroot(coeffests2, interval = c(llimit,ulimit), extendInt = "yes")$root
acofs2 <- sum(deltausds2*cos(bcofs2 * xs2))/sum((cos(bcofs2*xs2))^2)

plot(xs2, deltausds2)
lines(xs2, acofs2*cos(bcofs2*xs2), col="brown")

resids2 <- deltausds2 - acofs2*cos(bcofs2*xs2)
plot(xs2,resids2,type="l")

jb.norm.test(normtest)
jarque.bera.test(resids2)
qqnorm(resids2)
qqline(resids2)



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