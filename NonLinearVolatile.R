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








# -------------------- 1. Estimate wf_iteration -------------------- #

residual_sum_squared <- function(parameters) {
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
      temp_est <- optim(c(i,j,k) , residual_sum_squared)
      val <- rbind(  val,  c(temp_est$par,temp_est$value) )
    }
  }
}

est_parameters <- val[val[,4] == min(val[,4])][1:3]

plot(x, y_volatile)
lines(x, y_volatile_trend - (est_parameters[1] * cos(est_parameters[2] * x)))