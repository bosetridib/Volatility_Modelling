ar2 <- NULL
stdev <- 10
n <- 200
u <- rnorm(n,0,stdev)
x <- 1:n
p <- 1.8
q <- -0.25*(p^2) - 0.1*p


for (i in 1:n)
{
  if (i == 1)
  {
    ar2[i] <- 0+u[i]
  }
  if (i == 2)
  {
    ar2[i] <- ar2[i-1]+0+u[i]
  }
  if (i > 2)
  {
    ar2[i] <- (p*ar2[i-1])+(q*ar2[i-2])+u[i]
  }
}

plot(ar2,type="l")