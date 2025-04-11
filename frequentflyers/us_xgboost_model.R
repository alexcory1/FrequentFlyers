library(xgboost)
library(caret)
library(dplyr)

df <- read.csv("./data/raw/US_Airline_Flight.csv", stringsAsFactors = FALSE)

#Drops useless columns
df <- df[, !names(df) %in% c("tbl", "X", "tbl1apk", "fare_lg", "fare_low")]


#Converts categories to factors
cat_cols <- names(df)[sapply(df, is.character)]
# Implement level mapping
factor_mappings <- list()
for (col in cat_cols) {
  df[[col]] <- factor(df[[col]])
  factor_mappings[[col]] <- levels(df[[col]])
}

#XGBoost needs numerics, cast from factor to numeric
for (col in cat_cols) {
  df[[col]] <- as.numeric(df[[col]])
}

X <- as.matrix(df[, !names(df) %in% "fare"])
y <- df$fare

#Test/train split
set.seed(123)
train_indices <- sample(seq_len(nrow(df)), size = round(0.8 * nrow(df)))

X_train <- X[train_indices, ]
y_train <- y[train_indices]

X_test <- X[-train_indices, ]
y_test <- y[-train_indices]


#K fold CV
k_values <- c(50)
rmse_results <- list()

for (k in k_values) {
  cat("Running cross-validation with k =", k, "\n")
  
  cat("X_train dimensions:", dim(X_train), "\n")
  cat("y_train length:", length(y_train), "\n")
  
  
  dtrain <- xgb.DMatrix(data = X_train, label = y_train)
  
  cv_results <- xgb.cv(
    params = list(
      objective = "reg:squarederror",
      eval_metric = "rmse",
      eta = 0.1,
      max_depth = 6
    ),
    data = dtrain, 
    nfold = k,
    nrounds = 100,
    verbose = FALSE
  )
  
  mean_rmse <- min(cv_results$evaluation_log$test_rmse_mean)
  rmse_results[[as.character(k)]] <- mean_rmse
  print(paste("k =", k, "Mean RMSE:", mean_rmse))
}

#Find optimal k and train final model
optimal_k <- as.integer(names(which.min(unlist(rmse_results))))
dtrain_final <- xgb.DMatrix(data = X_train, label = y_train)

final_model <- xgboost(
  data = dtrain_final,
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

saveRDS(final_model, "flight_price_model.rds")
saveRDS(list(
  cat_cols = cat_cols,
  factor_mappings = factor_mappings,
  feature_names = colnames(X)
), "model_metadata.rds")

## To prevent irreversible changes, both .rds files are renamed with "final_" prefix and used in app.R 
## So changing stuff here won't affect the running app until you rename the rds files
