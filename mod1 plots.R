curwd <- getwd()
dir.create(paste(curwd,paste("Res/R stuffs/ModelPlots",as.character(Sys.time())),sep = "/"))
setwd(paste(curwd,paste("Res/R stuffs/ModelPlots",as.character(Sys.time())),sep = "/"))

wd <- 1440*2
ht <- 900*1.5

png(filename = "acf y", width = wd, height = ht)
acf(y, lag.max = 3*n/4)
dev.off()

png(filename = "acf ma1", width = wd, height = ht)
acf(ma1, lag.max = 3*n/4)
dev.off()

png(filename = "acf ar1", width = wd, height = ht)
acf(ar1, lag.max = 3*n/4)
dev.off()

png(filename = "pacf y", width = wd, height = ht)
pacf(y, lag.max = 3*n/4)
dev.off()

png(filename = "pacf ma1", width = wd, height = ht)
pacf(ma1, lag.max = 3*n/4)
dev.off()

png(filename = "pacf ar1", width = wd, height = ht)
pacf(ar1, lag.max = 3*n/4)
dev.off()

png(filename = "y", width = wd, height = ht)
plot(x, y, type="l")
dev.off()

png(filename = "ar1", width = wd, height = ht)
plot(x, ar1, type="l")
dev.off()

png(filename = "ma1", width = wd, height = ht)
plot(x, ma1, type="l")
dev.off()

png(filename = "filename", width = wd, height = ht)
plot(er$Date[-1], diff(er$USD), type="l")
dev.off()

setwd(curwd)