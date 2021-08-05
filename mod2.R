y1 <- NULL
a <- 1.1
b <- 17
wfi <- 31
stdev <- 40
n <- 200
u <- rnorm(n,0,stdev)
x <- 1:n
rho <- 1

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
  if(i == 1)
  {
    y1[i] <- wf(x[i],1,a,b) + u[i]
  }
  
  else
  {
    if((i <= n/4) || (i > 3*n/4))
    {
      y1[i] <- wf(x[i],1,a,b) + rho*y1[i-1] + u[i]
    }
    
    else
    {
      y1[i] <- wf(x[i],wfi,a,b) + rho*y1[i-1] + u[i]
    }
  }
}

# The trend . . .

at1 <- NULL

for(i in 1:n)
{
  if(i == 1)
  {
    at1[i] <- wf(x[i],1,a,b)
  }
  else
  {
    if((i <= n/4) || (i > 3*n/4))
    {
      at1[i] <- wf(x[i],1,a,b)+ rho*at1[i-1]
    }
    
    else
    {
      at1[i] <- wf(x[i],wfi,a,b)+ rho*at1[i-1]
    }
  }
}

# The plots . . .

plot(x,y1,type="l",
     ylim = c(min(min(at1), min(y1))-stdev,
              max(max(at1), max(y1))+stdev)
     )
lines(x,at1,col="red")
# plot(x,at1,type="l")

# Variance comparison . . .

# q01 <- 1:(n/4)
# q13 <- ((n/4)+1):(3*n/4)
# q34 <- (3*n/4+1):n
# list(
#   var.test(diff(y1[q01]),diff(y1[q13])),
#   var.test(diff(y1[q13]),diff(y1[q34])),
#   var.test(diff(y1[q01]),diff(y1[q34]))
# )