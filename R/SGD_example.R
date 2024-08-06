# Load necessary libraries
library(ggplot2)
library(dplyr)
library(plotly)

# Set seed for reproducibility
set.seed(123)

# Number of observations
n <- 100

# Generate predictor variable x
x <- rnorm(n, mean = 0, sd = 1)

# Define coefficients
beta_0 <- 2  # Intercept
beta_1 <- 3  # Slope

# Generate response variable y with some random noise
y <- beta_0 + beta_1 * x + rnorm(n, mean = 0, sd = 1)

# Combine into a data frame
data <- data.frame(x = x, y = y)

# Display the first few rows of the data
head(data)
plot(data)

# Mean Squared Error function
mse <- function(y, y_pred) {
  mean((y - y_pred)^2)
}

# Initialize parameters
beta_0_hat <- 0
beta_1_hat <- 0

# Learning rate
learning_rate <- 0.01

# Number of epochs
epochs <- 1000

# Track loss and parameter trajectory
loss_history <- numeric(epochs)
beta_0_history <- numeric(epochs)
beta_1_history <- numeric(epochs)

# Perform SGD
for (epoch in 1:epochs) {
  for (i in 1:n) {
    # Predict the response
    y_pred <- beta_0_hat + beta_1_hat * x[i]
    
    # Calculate gradients
    gradient_0 <- -(2 / n) * (y[i] - y_pred)
    gradient_1 <- -(2 / n) * (y[i] - y_pred) * x[i]
    
    # Update parameters
    beta_0_hat <- beta_0_hat - learning_rate * gradient_0
    beta_1_hat <- beta_1_hat - learning_rate * gradient_1
  }
  
  # Calculate and store the loss for the current epoch
  y_pred_all <- beta_0_hat + beta_1_hat * x
  current_loss <- mse(y, y_pred_all)
  loss_history[epoch] <- current_loss
  beta_0_history[epoch] <- beta_0_hat
  beta_1_history[epoch] <- beta_1_hat
  
  # Optionally, print the loss every 100 epochs
  if (epoch %% 100 == 0) {
    cat("Epoch:", epoch, "Loss:", current_loss, "\n")
  }
}

# Print final parameter estimates
cat("Estimated beta_0:", beta_0_hat, "\n")
cat("Estimated beta_1:", beta_1_hat, "\n")

# Generate grid for contour plot
beta_0_seq <- seq(-1, 5, length.out = 100)
beta_1_seq <- seq(1, 5, length.out = 100)
loss_grid <- expand.grid(beta_0 = beta_0_seq, beta_1 = beta_1_seq)
loss_grid$Loss <- mapply(function(b0, b1) {
  y_pred <- b0 + b1 * x
  mse(y, y_pred)
}, loss_grid$beta_0, loss_grid$beta_1)

# Interpolate the loss grid for smoother contour lines
interp_loss <- with(loss_grid, akima::interp(x = beta_0, y = beta_1, z = Loss, duplicate = "mean"))

# Convert interpolated data to a data frame for ggplot2
interp_loss_df <- data.frame(expand.grid(beta_0 = interp_loss$x, beta_1 = interp_loss$y), Loss = as.vector(interp_loss$z))

# Convert trajectory history to data frame
trajectory_data <- data.frame(beta_0 = beta_0_history, beta_1 = beta_1_history, Loss = loss_history)

# Create a 3D plot using plotly
fig <- plot_ly() %>%
  # Add loss surface
  add_surface(
    x = ~interp_loss$x,
    y = ~interp_loss$y,
    z = ~interp_loss$z,
    colorscale = list(c(0, 0.5, 1), c('blue', 'yellow', 'red')),
    showscale = TRUE,
    name = "Loss Surface"
  ) %>%
  # Add the trajectory of SGD updates
  add_trace(
    x = trajectory_data$beta_0,
    y = trajectory_data$beta_1,
    z = trajectory_data$Loss,
    mode = 'lines+markers',
    type = 'scatter3d',
    marker = list(color = 'red', size = 3),
    line = list(color = 'red', width = 2),
    name = 'SGD Trajectory'
  ) %>%
  layout(
    title = "3D Plot of Loss Function with SGD Trajectory",
    scene = list(
      xaxis = list(title = 'Beta 0'),
      yaxis = list(title = 'Beta 1'),
      zaxis = list(title = 'Loss')
    )
  )

# Display the plot
fig
