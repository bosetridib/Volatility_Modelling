# ================== The simulated time-series ================== #

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