# Load necessary libraries
library(dplyr)
library(readr)
library(haven)

# 1. Read the data
setwd("/Users/liuyunyi/Documents/CRRA_Research")
df <- read_dta("data/raw/new_data.dta")

# 2. Shift all payoffs (e.g. +21, so the minimum is 1)
offset <- 21
df <- df %>%
  mutate(
    lot_low_pos = lottery_low + offset,
    lot_high_pos = lottery_high + offset,
    sure_pos = sure + offset
  )

# 3. CRRA utility function
crra_utility <- function(x, r) {
  if (abs(r - 1) < 1e-6) {
    return(log(x))
  } else {
    return((x^(1 - r) - 1) / (1 - r))
  }
}

# 4. Negative log-likelihood function for one participant
neg_log_lik <- function(r, data, lambda = 1) {
  # Avoid negative or zero values by ensuring positive payoffs
  if (any(data$lot_low_pos <= 0) || any(data$lot_high_pos <= 0) || any(data$sure_pos <= 0)) return(Inf)
  # Calculate expected utility difference
  util_lot <- 0.5 * crra_utility(data$lot_high_pos, r) + 0.5 * crra_utility(data$lot_low_pos, r)
  util_sure <- crra_utility(data$sure_pos, r)
  diff <- util_lot - util_sure
  p_lottery <- 1 / (1 + exp(-lambda * diff))
  # Avoid log(0)
  p_lottery <- pmin(pmax(p_lottery, 1e-8), 1 - 1e-8)
  # Log-likelihood
  loglik <- data$choice * log(p_lottery) + (1 - data$choice) * log(1 - p_lottery)
  return(-sum(loglik))
}

# 5. Estimate CRRA for each participant
results <- df %>%
  group_by(id) %>%
  group_modify(~{
    res <- optim(par = 0.5, fn = neg_log_lik, data = ., method = "Brent", lower = -2, upper = 2)
    tibble(crra = res$par, negloglik = res$value)
  })

# 6. Show results
write.csv(results, "crra_results.csv1", row.names = FALSE)
