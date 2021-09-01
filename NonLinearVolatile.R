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





# ----------------------- 1. With optim function ----------------------- #

est_function <- function(parameters) {
  
  # Generating y-variable according to the Weierstrass function - first and
  # second parameters are a and b while third one is the wf_iteration
  for (i in 1:n) {
    y[i] <- wf(i,parameters[1],parameters[2],parameters[3])
  }
  
  return( sum( (y_volatile - y)^2 ) )
}

# The setup to find the required coefficients are as below.

val <- NULL
for (i in seq(0,100, by = 5))
{
  for (j in seq(0,100, by = 5))
  {
    for (k in 2:10)
    {
      temp_est <- optim(c(k,i,j) , est_function)
      val <- rbind(  val,  c(temp_est$par,temp_est$value) )
    }
  }
}

# The parameters with the minimum residual sum squared according to the optim
# function.
est_parameters1 <- val[val[,4] == min(val[,4])][1:3]

# Estimated wf_iteration with this method
wf_iteration_est1 <- round(est_parameters1[1],0)

# Estimated y with the above parameters
y_est1 <- NULL
for (i in 1:n) {
  y_est1[i] <- wf(i , wf_iteration_est1, est_parameters1[2], est_parameters1[3])
}

plot(x, y_volatile)
lines(x, y_volatile_trend, col="blue")
lines(x, y_est1)





# ------------------------ 2. With min(RSS) ------------------------ #

# The function that returns the RSS
residual_sum_square <- function(a, b, wfi) {
  y <- NULL
  for (i in 1:n) {
    y[i] <- wf(i , wfi, a, b)
  }
  return(sum(
    (y_volatile - y)^2
  ))
}

val <- NULL
for (i in seq(0,10, by = 0.5))
{
  for (j in seq(0,50, by = 1))
  {
    for (k in 2:10)
    {
      value <- residual_sum_square(i, j, k)
      val <- rbind(  val,  c(i, j, k, value) )
    }
  }
}

# Estimated parameters with the above method
est_parameters2 <- val[val[,4] == min(val[,4])][1:3]

# Estimated wf_iteration with this method
wf_iteration_est2 <- round(est_parameters2[3],0)

# Estimated y with the above parameters
y_est2 <- NULL
for (i in 1:n) {
  y_est2[i] <- wf(i , wf_iteration_est2, est_parameters2[1], est_parameters2[2])
}

plot(x, y_volatile)
lines(x, y_volatile_trend, col = "blue")
lines(x, y_est2)
lines(x, y_est2 - y_volatile_trend, col = "blue")




# -------------------------- 3. With nls -------------------------- #
# Regression result is below. It is assumed that wf_iteration is known. Note
# that here also the actual parameters are given in the 'start' list. The
# control section is to create the min factor lower enough to perform the
# iterations, and the warnOnly is used to ensure that the iterations
# complete without errors.

init_parameters_volatile <- list(A = a, B = b)

model_nls_volatile <- nls(
  y_volatile ~ A*cos(B*x) + A^2*cos(B^2*x) +
    A^3*cos(B^3*x) + A^4*cos(B^4*x) + A^5*cos(B^5*x),
  start = init_parameters_volatile,
  trace = TRUE,
  control = nls.control(minFactor = 1/2^15, warnOnly = TRUE)
)
summary(model_nls_volatile)

# The plots are below.
plot(x,y_volatile,ylim = c(min(y_volatile) , max(y_volatile)))
# lines(x,y_volatile_trend - fitted(model_nls_volatile),col = "black")
lines(x,y_volatile_trend,col = "blue")
lines(x,fitted(model_nls_volatile),col = "brown")