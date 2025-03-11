
#CatBoost Install Guide: https://catboost.ai/docs/en/installation/r-installation-binary-installation

#MacOS Installation
#install.packages('remotes')
#remotes::install_url('https://github.com/catboost/catboost/releases/download/v1.2.7/catboost-R-darwin-universal2-1.2.7.tgz', INSTALL_opts = c("--no-multiarch", "--no-test-load"))

library(catboost)
library(dplyr)

df <- read.csv("./data/raw/Clean_Dataset.csv", stringsAsFactors = FALSE)

#Convert rupees to dollars
df <- mutate(df, price = price / 87)

#Drop useless columns
df <- df[, !names(df) %in% c("Unnamed_0", "flight")]

#Convert categorical columns to factors
cat_cols <- names(df)[sapply(df, is.character)]
df[cat_cols] <- lapply(df[cat_cols], as.factor)

X <- df[, !names(df) %in% "price"]
y <- df$price

set.seed(123)

k <- 5
#Assign each row to a fold
fold_indices <- sample(1:k, nrow(X), replace = TRUE)  

rmse_results <- numeric(k)

#k fold CV
for (i in 1:k) {
  cat("Running fold", i, "of", k, "\n")
  
  val_indices <- which(fold_indices == i)
  train_indices <- which(fold_indices != i)
  
  X_train <- X[train_indices, ]
  y_train <- y[train_indices]
  X_val <- X[val_indices, ]
  y_val <- y[val_indices]
  
  #CatBoost pools (Test/Train split)
  train_pool <- catboost.load_pool(data = X_train, label = y_train)
  val_pool <- catboost.load_pool(data = X_val, label = y_val)
  
    #Hyperparameters
    params <- list(
    iterations = 100,          # Number of trees
    learning_rate = 0.1,       # Step size
    depth = 6,                 # Tree depth
    loss_function = "RMSE",    # Loss function
    verbose = 0                # Suppress output
  )
  
  
  model <- catboost.train(train_pool, params = params)
  
  #Make predictions on the validation set
  preds <- catboost.predict(model, val_pool)
  
  #Calculate RMSE for this fold
  rmse <- sqrt(mean((preds - y_val)^2))
  rmse_results[i] <- rmse
  cat("Fold", i, "RMSE:", rmse, "\n")
}

#Calculate RMSE
mean_rmse <- mean(rmse_results)
cat("Mean RMSE across", k, "folds:", mean_rmse, "\n")