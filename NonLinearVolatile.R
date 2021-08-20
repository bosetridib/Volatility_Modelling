zv <- NULL
zvt <- NULL
a <- 1.5
b <- 23
wfi <- 5
stdev <- 10
n <- 200
u <- rnorm(n,0,stdev)
x <- 1:n

wf <- function(x,n,a,b)
{
  v <- NULL
  for(j in 1:n)
  {
    v[j] <- (a^j)*cos((b^j)*x)
  }
  return(sum(v))
}


# The volatile trend series

for(i in 1:n)
{
  zv[i] <- wf(x[i],wfi,a,b) + u[i]
}

for(i in 1:n)
{
  zvt[i] <- wf(x[i],wfi,a,b)
}


# Regression result . . .
slst <- list(A = a, B = b)
modv <- nls(zv ~ A*cos(B*x), start = slst)
options(digits = 12)
summary(modv)

findZeros(
  sum(zv*(cos(b*x)
          + 2*a * cos(b^2 * x)
          + 3*a^2 * cos(b^3 * x)
          + 4*a^3 * cos(b^4 * x)
          + 5*a^4 * cos(b^5 * x)
  )) - 
    ((a*cos(b*x)
      + a^2*cos(b^2*x)
      + a^3*cos(b^3*x)
      + a^4*cos(b^4*x)
      + a^5*cos(b^5*x)
    ) * (cos(b*x)
         + 2*a * cos(b^2 * x)
         + 3*a^2 * cos(b^3 * x)
         + 4*a^3 * cos(b^4 * x)
         + 5*a^4 * cos(b^5 * x)
    )) ~ a & b,
  sum(zv*(a*sin(b*x) * x 
          + 2*a^2*b * sin(b^2*x) * x
          + 3*a^3*b^2 * sin(b^3*x) * x
          + 4*a^4*b^3 * sin(b^4*x) * x
          + 5*a^5*b^4 * sin(b^5*x) * x
  )) - 
    ((a*cos(b*x)
      + a^2*cos(b^2*x)
      + a^3*cos(b^3*x)
      + a^4*cos(b^4*x)
      + a^5*cos(b^5*x)
    )*(a*sin(b*x) * x
       + 2*a^2*b * sin(b^2*x) * x
       + 3*a^3*b^2 * sin(b^3*x) * x
       + 4*a^4*b^3 * sin(b^4*x) * x
       + 5*a^5*b^4 * sin(b^5*x) * x
    )) ~ a & b,
  near = c(a=1, b=23), within = c(a=2,b=25),
  nearest = 1000, iterate = 1000
)

plot(x,zv,ylim = c(min(zv) , max(zv)))
# lines(x,zvt - fitted(modv),col = "black")
lines(x,zvt,col = "blue")
lines(x,fitted(modv),col = "brown")

plot(x,zv,ylim = c(min(zv) , max(zv)))
# lines(x,zvt - fitted(modv1),col = "red")
lines(x,zvt,col = "blue")
lines(x,fitted(modv1),col = "brown")