library(glmnet)
library(caret)
library(dplyr)


df <- read.csv("./data/raw/Clean_Dataset.csv", stringsAsFactors = FALSE)

#Converts rupees to dollars, as of the conversion rate on 3/3/25
df <- mutate(df, price = price /87)

#Drops useless columns
df <- df[, !names(df) %in% c("Unnamed_0", "flight")]


#Converts categories to factors
cat_cols <- names(df)[sapply(df, is.character)]
df[cat_cols] <- lapply(df[cat_cols], as.factor)

#Model needs numerics, cast from factor to numeric
for (col in cat_cols) {
  df[[col]] <- as.numeric(as.factor(df[[col]]))
}
X <- as.matrix(df[, !names(df) %in% "price"])
y <- df$price

set.seed(123)
train_indices <- createDataPartition(y, p = 0.8, list = FALSE)
X_train <- X[train_indices, ]
y_train <- y[train_indices]
X_test <- X[-train_indices, ]
y_test <- y[-train_indices]

#Fit an elastic net model using cv.glmnet
cv_fit <- cv.glmnet(x = X_train, y = y_train, alpha = 0.5, nfolds = 10)

#Finds best lambda
best_lambda <- cv_fit$lambda.min
cat("Best lambda selected by cross-validation:", best_lambda, "\n")

#Train the final glmnet model using the optimal lambda
final_model <- glmnet(x = X_train, y = y_train, alpha = 0.5, lambda = best_lambda)

#Predict on the test set using the final model
preds <- predict(final_model, newx = X_test, s = best_lambda)

#Final RMSE
test_rmse <- sqrt(mean((preds - y_test)^2))
cat("Test RMSE:", test_rmse, "\n")
