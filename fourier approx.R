n <- 200
x <- 1:n
a <- 1

y <- cos(a*x)
plot(x,y, type="l")

raw.fft = fft(y)
plot(abs(raw.fft),type="l")

truncated.fft = raw.fft[seq(1, length(y)/2 - 1)]
truncated.fft[1] = 0

plot(abs(truncated.fft),type="l")
which.max(abs(truncated.fft))*2*pi/length(y)