# The Weierstrass function

wf <- function(x,n,a,b)
{
  v <- NULL
  for(j in 1:n)
  {
    v[j] <- (a^j)*cos((b^j)*x)
  }
  return(sum(v))
}

# The parameters initialization
a <- 100
b <- 71
# wf_iteration is 1, which means the data is in stable period

# The residual's IIDN parameters
std_dev <- 40
n <- 200            # the number of parameters
u <- rnorm(n,0,std_dev)
x <- 1:n


# The stable data is generated, along with the trend.
y_nls <- NULL
y_nls_trend <- NULL

for(i in 1:n)
{
  y_nls[i] <- wf(x[i],1,a,b) + u[i]
  y_nls_trend[i] <- wf(x[i],1,a,b)
}





# -------------------------- 1. NLS function -------------------------- #

# The nls function in R is used for the nonlinear estimations. However, it
# requires some parameters with which it begins the estimations. The alpha
# and beta are initialized with the data generating parameters.
init_parameters <- list(alpha = a, beta = b)

model_nls_stable <- nls(y_nls ~ alpha*cos(beta*x), start = init_parameters)
summary(model_nls_stable)

# The line function plots the difference between actual trend and fitted model
plot(x, y_nls)
lines(x, y_nls_trend - fitted(model_nls_stable))





# ------------------- 2. Manual Calculations ------------------- #

# A manual calculation is also provided to check efficiency.
b_est_func <- function(b_coeff)
{
    (
      sum( x*y_nls * sin(b_coeff*x) ) * sum( (cos(b_coeff*x))^2 )
    ) -
    (
      sum( y_nls * cos(b_coeff*x) ) * sum(x*sin(b_coeff*x)*sin(b_coeff*x))
    )
}

b_est <- uniroot(b_est_func, interval = c(b-10,b+10), extendInt = "yes")$root
a_est <- sum( y_nls * cos(b_est*x) ) /
  sum( (cos(b_est*x))^2 )

c(a_est,b_est)

# The plot of the data with the least square technique.
plot(x, y_nls)
lines(x, y_nls_trend - (a_est * cos(b_est * x)))





# --------------------- 3. Minimize RSS --------------------- #

# Minimizing the Residual Sum Squared is to seek parameters for which the RSS
# is minimum. The function to minimize would be as below.

residual_sum_squared <- function(parameters) {
  return(
    sum(
      (y_nls - parameters[1] * cos(parameters[2]*x))^2
    )
  )
}

# The setup to find the required coefficietns are as below.

val <- NULL
for (i in seq(0,100, by = 5)) {
  for (j in seq(0,100, by = 5)){
    temp_est <- optim(c(i,j) , residual_sum_squared)
    val <- rbind(
      val,
      c(temp_est$par,temp_est$value)
    )
  }
}

est_parameters <- val[val[,3] == min(val[,3])][1:2]

plot(x, y_nls)
lines(x, y_nls_trend - (est_parameters[1] * cos(est_parameters[2] * x)))