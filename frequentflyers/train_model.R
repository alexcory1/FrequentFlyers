# train_model.R
library(xgboost)
library(caret)
library(dplyr)

train_and_save_model <- function() {
  df <- read.csv("./data/raw/Clean_Dataset.csv", stringsAsFactors = FALSE)
  
  #Converts rupees to dollars, as of the conversion rate on 3/3/25
  df <- mutate(df, price = price /87)
  
  #Drops useless columns
  df <- df[, !names(df) %in% c("Unnamed_0", "flight")]
  
  
  #Converts categories to factors
  cat_cols <- names(df)[sapply(df, is.character)]
  df[cat_cols] <- lapply(df[cat_cols], as.factor)
  
  #XGBoost needs numerics, cast from factor to numeric
  for (col in cat_cols) {
    df[[col]] <- as.numeric(as.factor(df[[col]]))
  }
  
  X <- as.matrix(df[, !names(df) %in% "price"])
  y <- df$price
  
  #Test/train split
  set.seed(123)
  train_indices <- createDataPartition(y, p = 0.8, list = FALSE)
  X_train <- X[train_indices, ]
  y_train <- y[train_indices]
  X_test <- X[-train_indices, ]
  y_test <- y[-train_indices]
  
  #K fold CV
  k_values <- c(5)
  rmse_results <- list()
  
  for (k in k_values) {
    cat("Running cross-validation with k =", k, "\n")
    
    cv_results <- xgb.cv(
      params = list(
        objective = "reg:squarederror",
        eval_metric = "rmse",
        eta = 0.1,
        max_depth = 6
      ),
      data = X_train,
      label = y_train,
      nfold = k,
      nrounds = 100,
      metrics = "rmse",
      verbose = FALSE
    )
    
    mean_rmse <- min(cv_results$evaluation_log$test_rmse_mean)
    rmse_results[[as.character(k)]] <- mean_rmse
    print(paste("k =", k, "Mean RMSE:", mean_rmse))
  }
  
  #Find optimal k and train final model
  optimal_k <- as.integer(names(which.min(unlist(rmse_results))))
  final_model <- xgboost(
    data = X_train,
    label = y_train,
    params = list(
      objective = "reg:squarederror",
      eval_metric = "rmse",
      eta = 0.1,
      max_depth = 6
    ),
    nrounds = 100,
    verbose = FALSE
  )
  
  
  preds <- predict(final_model, X_test)
  test_rmse <- sqrt(mean((preds - y_test)^2))
  print(paste("Test RMSE:", test_rmse))
  
  
  rmse_df <- data.frame(
    k = factor(names(rmse_results)),
    RMSE = unlist(rmse_results)
  )
  
  xgb.save(final_model, "model/final_model.xgb")  
  saveRDS(
    list(
      final_model = NULL, 
      model_path = "model/final_model.xgb", 
      rmse_df = rmse_df,
      test_rmse = test_rmse,
      feature_names = colnames(X)
    ),
    "model/flight_price_model.rds"
  )
}

train_and_save_model()