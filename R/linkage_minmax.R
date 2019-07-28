library(mvtnorm)
library(ggplot2)
mu1 = c(-1, 0)
mu2 = c(1, 0)
sigma1 = diag(0.4^2, 2)
sigma2 = diag(0.4^2, 2)


x1 = rmvnorm(250, mu1, sigma1)
x2 = rmvnorm(250, mu2, sigma2)
x = rbind(x1, x2)
plot(x)

# Run hierarchical clustering with single (min) linkage
# here min produces counterintuitive results
x_dist = dist(x)
h1 = hclust(x_dist, method='single')
c1 = cutree(h1, 2)

D = data.frame(x, z = c1)
ggplot(D) + geom_point(aes(x=X1, y=X2, col=factor(z)))

# Run hierarchical clustering with complete (max) linkage
h2 = hclust(x_dist, method='complete')
c2 = cutree(h2, 2)
D2 = data.frame(x, z = c2)
ggplot(D2) + geom_point(aes(x=X1, y=X2, col=factor(z)))


# Run hierarchical clustering with average linkage
h3 = hclust(x_dist, method='average')
c3 = cutree(h3, 2)
D3 = data.frame(x, z = c3)
ggplot(D3) + geom_point(aes(x=X1, y=X2, col=factor(z)))




# But here's a different example where max produces counterintuitive results
set.seed(84958)
mu1 = c(-1, 0)
mu2 = c(1, 0)
sigma1 = diag(0.1^2, 2)
sigma2 = diag(0.45^2, 2)


x1 = rmvnorm(250, mu1, sigma1)
x2 = rmvnorm(250, mu2, sigma2)
x = rbind(x1, x2)
plot(x)

# Run hierarchical clustering with single (min) linkage
x_dist = dist(x)
h1 = hclust(x_dist, method='single')
c1 = cutree(h1, 2)
D = data.frame(x, z = c1)
ggplot(D) + geom_point(aes(x=X1, y=X2, col=factor(z)))

# Run hierarchical clustering with complete (max) linkage
h2 = hclust(x_dist, method='complete')
c2 = cutree(h2, 2)
D2 = data.frame(x, z = c2)
ggplot(D2) + geom_point(aes(x=X1, y=X2, col=factor(z)))


# Run hierarchical clustering with average linkage
h3 = hclust(x_dist, method='average')
c3 = cutree(h3, 2)
D3 = data.frame(x, z = c3)
ggplot(D3) + geom_point(aes(x=X1, y=X2, col=factor(z)))

