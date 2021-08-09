# The Weierstrass function returning values with a,b, with wf_iteration terms
wf <- function(x,n,a,b)
{
  v <- NULL
  for(j in 1:n)
  {
    v[j] <- (a^j)*cos((b^j)*x)    # the formula of each term in Weierstrass function
  }
  return(sum(v))
}

# ================== 1. The simulated AR(0) time-series ================== #

y <- NULL    # The generated volatile variable

# The required parameters in Weierstrass function.
a <- 1.5               # this parameter's for amplitude
b <- 5                 # this parameter's for the fluctuations
wf_iteration <- 11     # the iteration is the number of terms in the function's series

# The residual with ~IIDN(mean=0,sd)
std_dev <- 35   # standard deviation
n <- 100        # number of observations
u <- rnorm(n,0,std_dev)

# The index of each observation, acting as time series variable 't'
x <- 1:n

# The time-series variable with wf+u values

for(i in 1:n)
{
  if((i <= n/4) || (i > 3*n/4))
  {
    y[i] <- wf(x[i],1,a,b)+u[i]
  }

  else
  {
    y[i] <- wf(x[i],wf_iteration,a,b)+u[i]
  }
}

# The trend of the series

trend <- NULL

for(i in 1:n)
{
  if((i <= n/4) || (i > 3*n/4))
  {
    trend[i] <- wf(x[i],1,a,b)              # wf_iteration=1, denoting stable periods
  }
  
  else
  {
    trend[i] <- wf(x[i],wf_iteration,a,b)   # wf_iteration is specified for volatile periods
  }
}


plot(x, y, type="l",lty=1,xlab = "t")       # the stable and volatile periods shown
lines(x,trend,lty=2,lwd=1)                  # the trend is the dashed line
# plot(x, trend, type="l")                  # the plot of trend only
# plot(u,type="l")                          # plot of the random normal u

# the three quarters in the stable and volatile periods.
q01 <- 1:(n/4)
q13 <- ((n/4)+1):(3*n/4)
q34 <- (3*n/4+1):n

# the output would be the variance test of the simulated stable vs volatile periods
list(
      var.test(y[q01],y[q13]),
      var.test(y[q13],y[q34]),
      var.test(y[q01],y[q34])
    )










# ============= 2. The simulated time-series with a upward trend ============= #

y_trend <- NULL
a <- 1.1
b <- 17
wf_iteration_trend <- 41
stdev <- 40
n <- 200
u <- rnorm(n,0,stdev)
x <- 1:n
trend_coefficient <- 10*x^(0.75)

# The TS . . .

for(i in 1:n)
{
  if((i <= n/4) || (i > 3*n/4))
  {
    y_trend[i] <- trend_coefficient[i]+wf(x[i],1,a,b)+u[i]
  }
  
  else
  {
    y_trend[i] <- trend_coefficient[i]+wf(x[i],wf_iteration_trend,a,b)+u[i]
  }
}

# The trend . . .

at <- NULL

for(i in 1:n)
{
  if((i <= n/4) || (i > 3*n/4))
  {
    at[i] <- trend_coefficient[i]+wf(x[i],1,a,b)
  }
  
  else
  {
    at[i] <- trend_coefficient[i]+wf(x[i],wf_iteration_trend,a,b)
  }
}


plot(x, y_trend, type="l")
# plot(x, at, type="l")
# plot(x[q13], at[q13], type="l")
lines(x,at,col="brown")

q01 <- 1:(n/4)
q13 <- ((n/4)+1):(3*n/4)
q34 <- (3*n/4+1):n
list(
  var.test(y_trend[q01],y_trend[q13]),
  var.test(y_trend[q13],y_trend[q34]),
  var.test(y_trend[q01],y_trend[q34])
)








# ================== 3. The simulated AR(1) time-series ================== #

y_ar1 <- NULL

# The parameters of the Weierstrass function
a <- 1.1
b <- 17

# The number of terms in the function
wf_iteration_ar1 <- 31

# The IIDN residual observations
stdev <- 40
n <- 200
u <- rnorm(n,0,stdev)
x <- 1:n

# The AR(1) coefficient
rho <- 1

# The AR(1) time-series

for(i in 1:n)
{
  if(i == 1)
  {
    y_ar1[i] <- wf(x[i],1,a,b) + u[i]
  }
  else
  {
    if((i <= n/4) || (i > 3*n/4))                   # the stable period of the first and last quarters
    {
      y_ar1[i] <- wf(x[i],1,a,b) +                  # for stability, wf_iteration_ar1 is 1
        rho*y_ar1[i-1] + u[i]
    }
    
    else                                            # the volatile periods in the second and third quarters
    {
      y_ar1[i] <- wf(x[i],wf_iteration_ar1,a,b) +   # for volatility, wf_iteration_ar1 is stated above
        rho*y_ar1[i-1] + u[i]
    }
  }
}

# The trend of the AR(1) model, basically the y_ar1 without the residuals

trend_ar1 <- NULL

for(i in 1:n)
{
  if(i == 1)
  {
    trend_ar1[i] <- wf(x[i],1,a,b)
  }
  else
  {
    if((i <= n/4) || (i > 3*n/4))
    {
      trend_ar1[i] <- wf(x[i],1,a,b) +
        rho*trend_ar1[i-1]
    }
    
    else
    {
      trend_ar1[i] <- wf(x[i],wf_iteration_ar1,a,b) +
        rho*trend_ar1[i-1]
    }
  }
}

# The plots illustrates the time-series and its autoregressive trend
                  
plot(x,y_ar1,type="l",                                # the plot of the time-series
     ylim = c(min(min(trend_ar1), min(y_ar1))-stdev,
              max(max(trend_ar1), max(y_ar1))+stdev)
)
lines(x,trend_ar1,col="red")                          # the plot of the trend

# Variance tests of the differenced for of the time-series within the volatile vs stable periods

q01 <- 1:(n/4)
q13 <- ((n/4)+1):(3*n/4)
q34 <- (3*n/4+1):n
list(
  var.test(diff(y_ar1[q01]),diff(y_ar1[q13])),
  var.test(diff(y_ar1[q13]),diff(y_ar1[q34])),
  var.test(diff(y_ar1[q01]),diff(y_ar1[q34]))
)