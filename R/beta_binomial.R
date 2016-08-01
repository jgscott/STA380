n = 20
true_w = 0.3

# Simulate some data
y = rbinom(1, size=n, prob=true_w)

y

# prior and posterior
curve(dbeta(x, 1, 1), from=0, to=1, ylim=c(0, 5))
curve(dbeta(x, 1+y, 1+n-y), col='blue', add=TRUE)

# compare with normal approximation
w_hat = y/n
w_stderr = sqrt(w_hat*(1-w_hat)/n)

curve(dnorm(x, w_hat, w_stderr), add=TRUE, col='red', lty='dotted')

