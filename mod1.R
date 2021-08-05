y <- NULL
a <- 1.5
b <- 5
wfi <- 11
stdev <- 35
n <- 100
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

# The TS . . .

for(i in 1:n)
{
  if((i <= n/4) || (i > 3*n/4))
  {
    y[i] <- wf(x[i],1,a,b)+u[i]
  }

  else
  {
    y[i] <- wf(x[i],wfi,a,b)+u[i]
  }
}

# The trend . . .

at <- NULL

for(i in 1:n)
{
  if((i <= n/4) || (i > 3*n/4))
  {
    at[i] <- wf(x[i],1,a,b)
  }
  
  else
  {
    at[i] <- wf(x[i],wfi,a,b)
  }
}


plot(x, y, type="l",lty=1,xlab = "t")
# plot(x, at, type="l")
# plot(x[q13], at[q13], type="l")
lines(x,at,lty=2,lwd=1)
# plot(u,type="l")

q01 <- 1:(n/4)
q13 <- ((n/4)+1):(3*n/4)
q34 <- (3*n/4+1):n
list(
      var.test(y[q01],y[q13]),
      var.test(y[q13],y[q34]),
      var.test(y[q01],y[q34])
    )