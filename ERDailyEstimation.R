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
deltausds2 <- deltausd[(36*br):n-1]

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

init_parameters_stable <- list(alpha = 0.5, beta = 10)

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

est_function <- function(parameters) {
  
  # Generating y-variable according to the Weierstrass function - first and
  # second parameters are a and b while third one is the wf_iteration
  y <- NULL
  for (i in 1:n) {
    y[i] <- wf(i,parameters[1],parameters[2],parameters[3])
  }
  
  return( sum( (deltausdv - y)^2 ) )
}

# The setup to find the required coefficients are as below.

val <- NULL
for (i in seq(0,10, by = 0.5))
{
  for (j in seq(0,10, by = 0.5))
  {
    for (k in 2:20)
    {
      temp_est <- optim(c(k,i,j) , est_function)
      val <- rbind(  val,  c(temp_est$par,temp_est$value) )
    }
  }
}

# The parameters with the minimum residual sum squared according to the optim
# function.
est_parameters1 <- val[val[,4] == min(val[,4])][1:3]
# est_parameters1 <- c(5.250519, 1.376494, 99.367226)

# Estimated wf_iteration with this method
wf_iteration_est1 <- round(est_parameters1[1],0)

# Estimated y with the above parameters
y_est1 <- NULL
for (i in 1:length(xv)) {
  y_est1[i] <- wf(i , wf_iteration_est1, est_parameters1[2], est_parameters1[3])
}

plot(xv, deltausdv)
lines(xv, y_est1, col = 'blue')







est_function <- function(parameters) {
  
  # Generating y-variable according to the Weierstrass function - first and
  # second parameters are a and b while third one is the wf_iteration
  y <- NULL
  for (i in 1:length(xv)) {
    y[i] <- wf(i,parameters[1],parameters[2],parameters[3])
  }
  
  return( sum( (deltausdv - y)^2 ) )
}

val <- NULL
for (i in seq(0,1, by = 0.005))
{
  for (j in seq(0,10, by = 1))
  {
    for (k in 2:20)
    {
      temp_est <- optim(c(k,i,j) , est_function)
      val <- rbind(  val,  c(temp_est$par,temp_est$value) )
    }
  }
}
# The parameters with the minimum residual sum squared according to the optim
# function.
est_parameters1 <- val[val[,4] == min(val[,4])][1:3]
# est_parameters1 <- c(5.70162558, 0.02856102, 8.41170090)

# Estimated wf_iteration with this method
wf_iteration_est1 <- round(est_parameters1[1],0)

# Estimated y with the above parameters
y_est1 <- NULL
for (i in 1:length(xv)) {
  y_est1[i] <- wf(i , wf_iteration_est1, est_parameters1[2], est_parameters1[3])
}

plot(xv, deltausdv)
lines(xv, y_est1, col = 'blue')