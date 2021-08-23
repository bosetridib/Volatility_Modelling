zs <- NULL
zst <- NULL
a <- 1
b <- 0.6
wfi <- 41
stdev <- 10
n <- 1000
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
summary(mods)

plot(x,zs,ylim = c(min(zs) , max(zs)))
lines(x,zst-fitted(mods))

ftzs <- fft(zst)
plot(abs(ftzs))
abline(v=b/(2*pi/n))