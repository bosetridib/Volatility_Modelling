library(readxl)
er <- read_excel("Exchange Rate Daily.xls")
er$Date <- as.Date(er$Date, format = "%d/%m/%Y")

n <- length(er[[1]])

deltausd <- diff(er$USD)
plot(er$Date, er$USD, type="l")
plot(er$Date[-n], deltausd, type="l")
acf(deltausd, lag.max = 0.8*n)
pacf(deltausd, lag.max = 0.8*n)

# Variance change . . .

varusd <- NULL
br <- 100

for (i in 1:(n/br))
{
  varusd[i] <- var(deltausd[((br*(i-1))+1) : (br*i)])
}

pardef <- par()
par(mfrow=c(2,2))

plot(varusd, type="l")
plot(varusd[1:10], type="l")
plot(varusd[10:35], type="l")
plot(varusd[35:48], type="l")

par(pardef)

# Regression test . . .

deltausds1 <- deltausd[1:(10*br)]
deltausdv <- deltausd[(10*br):(35*br)]
deltausds2 <- deltausd[(35*br):(48*br)]
xs1 <- 1:length(deltausds1)
xv <- 1:length(deltausdv)
xs2 <- 1:length(deltausds2)
llimit <- 0.0001
ulimit <- 10000




# Regression for s1 . . .

coeffests1 <- function(betas1)
{
  (sum(deltausds1 * cos(betas1*xs1)) * sum(xs1*sin(betas1*2*xs1)))
  - (2*sum(xs1*deltausds1*sin(betas1*xs1)) * sum((cos(betas1*xs2))^2))
}

bcofs1 <- uniroot(coeffests1, interval = c(llimit,ulimit), extendInt = "yes")$root
acofs1 <- sum(deltausds1*cos(bcofs1 * xs1))/sum((cos(bcofs1*xs1))^2)

plot(xs1, deltausds1)
lines(xs1, acofs1*cos(bcofs1*xs1), col="brown")

resids1 <- deltausds1 - acofs1*cos(bcofs1*xs1)
plot(xs1,resids1,type="l")

library(normtest)
jb.norm.test(resids1)
qqnorm(resids1)
qqline(resids1)




# Regression for s2 . . .

coeffests2 <- function(betas2)
{
  (sum(deltausds2 * cos(betas2*xs2)) * sum(xs2*sin(betas2*2*xs2)))
  - (2*sum(xs2*deltausds2*sin(betas2*xs2)) * sum((cos(betas2*xs2))^2))
}

bcofs2 <- uniroot(coeffests2, interval = c(llimit,ulimit), extendInt = "yes")$root
acofs2 <- sum(deltausds2*cos(bcofs2 * xs2))/sum((cos(bcofs2*xs2))^2)

plot(xs2, deltausds2)
lines(xs2, acofs2*cos(bcofs2*xs2), col="brown")

resids2 <- deltausds2 - acofs2*cos(bcofs2*xs2)
plot(xs2,resids2,type="l")

jb.norm.test(normtest)
jarque.bera.test(resids2)
qqnorm(resids2)
qqline(resids2)



# Regression for v . . .

wf <- function(x,n,a,b)
{
  v <- NULL
  for(j in 1:n)
  {
    v[j] <- (a^j)*cos((b^j)*x)
  }
  return(sum(v))
}

plot(xv, deltausdv)
yv <- wf(x=xv,n=5,a=acofs1,b=bcofs1)
lines(xv,yv)