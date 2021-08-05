zs <- NULL
zst <- NULL
a <- 10
b <- 71
wfi <- 41
stdev <- 500
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

# The stable trend series

for(i in 1:n)
{
  zs[i] <- wf(x[i],1,a,b) + u[i]
}

for(i in 1:n)
{
  zst[i] <- wf(x[i],1,a,b)
}


# Regression result . . .
slst <- list(alpha = a, beta = b)
mods <- nls(zs ~ alpha*cos(beta*x), start = slst)
options(digits = 12)
summary(mods)

plot(x,zs,ylim = c(min(zs) , max(zs)))
lines(x,zst-fitted(mods))

# Manual calculation of alpha beta . . .
coeffest <- function(beta)
{
    (sum(zs * cos(beta*x)) * sum(x*sin(beta*2*x)))
    - (2*sum(x*zs*sin(beta*x)) * sum((cos(beta*x))^2))
}

bcof <- uniroot(coeffest, interval = c(b-3,b+3), extendInt = "yes")$root
acof <- sum(zs*cos(bcof * x))/sum((cos(bcof*x))^2)

cat("\014")

c(acof,bcof)