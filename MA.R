ma1 <- NULL
phi <- 1

for(i in 1:n)
{
  if(i == 1)
  {
    ma1[i] <- 0 + u[i]
  }
  if(i > 1)
  {
    ma1[i] <- u[i]+ (phi*u[i-1])
  }
}

plot(ma1,type="l")

x <- 1:n