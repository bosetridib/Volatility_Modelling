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
# ends at 37th break. However, at 25th break, the unstability seems to change.
# The data is splitted into two stable periods at both ends, and into two
# volatile periods in between them.

deltausds1 <- deltausd[1:(10*br - 1)]
deltausdv1 <- deltausd[(10*br + 1):(25*br - 1)]
deltausdv2 <- deltausd[25*br:(36*br - 1)]
deltausds2 <- deltausd[(36*br):n-1]

xs1 <- 1:length(deltausds1)
xv1 <- 1:length(deltausdv1)
xv2 <- 1:length(deltausdv2)
xs2 <- 1:length(deltausds2)





# ------------------ 2. Estimating Stable Periods ------------------ #

# The estimation of the first period

# The nls method requires initial parameters, which are provided after some
# trials
init_parameters_stable1 <- list(alpha = 1, beta = 10)

# Note again that the wf_iteration is 1 in the stable periods.
model_nls_stable1 <- nls(
  deltausds1 ~ alpha*cos(beta*xs1),
  start = init_parameters_stable1
)
summary(model_nls_stable1)

# The line function plots the difference between actual trend and fitted model
plot(xs1, deltausds1)
lines(xs1, fitted(model_nls_stable1), col = 'blue')

# Residual generation of the first period
resids1 <- deltausds1 - fitted(model_nls_stable1)









# The estimation of the second period, similar to the first one

init_parameters_stable2 <- list(alpha = 0.5, beta = 10)

# The model
model_nls_stable2 <- nls(
  deltausds2 ~ alpha*cos(beta*xs2),
  start = init_parameters_stable2
)
summary(model_nls_stable2)

# The line function plots the difference between actual trend and fitted model
plot(xs2, deltausds2)
lines(xs2, fitted(model_nls_stable2), col = 'blue')

# Residual generation in the second period
resids2 <- deltausds2 - fitted(model_nls_stable2)








# ------------------ 3. Estimating Volatile Periods ------------------ #

wf <- function(x, wf_iterations, a, b)
{
  v <- NULL
  for(j in 1:wf_iterations)
  {
    v[j] <- (a^j)*cos((b^j)*x)
  }
  return(sum(v))
}

# The volatile data is standardized here. Considering that the residuals are
# more or less stable throughout the data, we take the standard deviation of
# the first period residual, and standardize the volatile data with that value.

deltausdv_std1 <- deltausdv1/sd(resids1)
deltausdv_std2 <- deltausdv2/sd(resids2)

est_function_volatile1 <- function(parameters) {
  
  # Generating y-variable according to the Weierstrass function - first and
  # second parameters are a and b while third one is the wf_iteration
  y <- NULL
  for (i in 1:length(xv1)) {
    y[i] <- wf(i,parameters[1],parameters[2],parameters[3])
  }
  
  # Note that the standardized volatile data is used in estimation
  return( sum( (deltausdv_std1 - y)^2 ) )
}

# The setup to find the required coefficients are below.

val <- NULL
for (i in seq(0,10, by = 2))
{
  for (j in seq(0,10, by = 2))
  {
    for (k in 2:20)
    {
      temp_est <- optim(c(k,i,j) , est_function_volatile1)
      val <- rbind(  val,  c(temp_est$par,temp_est$value) )
    }
  }
}

# The parameters with the minimum residual sum squared according to the optim
# function.
est_parameters_volatile1 <- val[val[,4] == min(val[,4])][1:3]
# est_parameters1 <- c(15.4369174, 0.1877411, 10.4375063)

# Estimated wf_iteration with this method
wf_iteration_est1 <- round(est_parameters_volatile1[1],0)

# Estimated y with the above parameters
y_est_volatile1 <- NULL
for (i in 1:length(xv1)) {
  y_est_volatile1[i] <- wf(i , wf_iteration_est1, est_parameters_volatile1[2], est_parameters_volatile1[3])
}

plot(xv1, deltausdv1)
lines(xv1, y_est_volatile1, col = 'blue')









est_function_volatile2 <- function(parameters) {
  
  # Generating y-variable according to the Weierstrass function - first and
  # second parameters are a and b while third one is the wf_iteration
  y <- NULL
  for (i in 1:length(xv2)) {
    y[i] <- wf(i,parameters[1],parameters[2],parameters[3])
  }
  
  # Note that the standardized volatile data is used in estimation
  return( sum( (deltausdv_std2 - y)^2 ) )
}

# The setup to find the required coefficients are below.

val <- NULL
for (i in seq(0,10, by = 2))
{
  for (j in seq(0,10, by = 2))
  {
    for (k in 2:20)
    {
      temp_est <- optim(c(k,i,j) , est_function_volatile2)
      val <- rbind(  val,  c(temp_est$par,temp_est$value) )
    }
  }
}

# The parameters with the minimum residual sum squared according to the optim
# function.
est_parameters_volatile2 <- val[val[,4] == min(val[,4])][1:3]
# est_parameters1 <- c(15.4369174, 0.1877411, 10.4375063)

# Estimated wf_iteration with this method
wf_iteration_est2 <- round(est_parameters_volatile2[1],0)

# Estimated y with the above parameters
y_est_volatile2 <- NULL
for (i in 1:length(xv2)) {
  y_est_volatile2[i] <- wf(i , wf_iteration_est2, est_parameters_volatile2[2], est_parameters_volatile2[3])
}

plot(xv2, deltausdv2)
lines(xv2, y_est_volatile2, col = 'blue')