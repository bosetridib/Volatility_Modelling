# The Weierstrass function

wf <- function(x, wf_iterations, a, b)
{
  v <- NULL
  for(j in 1:wf_iterations)
  {
    v[j] <- (a^j)*cos((b^j)*x)
  }
  return(sum(v))
}

# The parameters initialization
a <- 1.5
b <- 21
# wf_iteration is not equal to 1, which means the data is volatile
wf_iteration <- 5

y_volatile <- NULL
y_volatile_trend <- NULL

# The residual's IIDN parameters
stdev <- 40
n <- 200
u <- rnorm(n,0,stdev)
x <- 1:n

# The volatile trend series

for(i in 1:n)
{
  y_volatile[i] <- wf(x[i],wf_iteration,a,b) + u[i]
  y_volatile_trend[i] <- wf(x[i],wf_iteration,a,b)
}

# Regression result is below. Note that here also the parameters are
# given in the 'start' list. The control section is to create the min factor
# lower enough to perform the iterations, and the warnOnly is used to
# ensure that the iterations complete without errors.





est_function <- function(parameters) {
  for (i in 1:parameters[3]) {
    y <- parameters[1]^i * cos(parameters[2]^i * x)
  }
  return( sum( (y_volatile - y)^2 ) )
}

# The setup to find the required coefficietns are as below.

val <- NULL
for (i in seq(0,100, by = 5)) {
  for (j in seq(0,100, by = 5)){
    for (k in 2:10) {
      temp_est <- optim(c(i,j,k) , est_function)
      val <- rbind(  val,  c(temp_est$par,temp_est$value) )
    }
  }
}

est_parameters <- val[val[,4] == min(val[,4])][1:3]

for (i in 1:n) {
  y[i] <- wf(i , est_parameters[3], est_parameters[1], est_parameters[2])
}

plot(x, y_volatile)
lines(x, y_volatile_trend - y)