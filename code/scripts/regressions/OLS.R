
# import data
credit = read.csv("data/scaled-credit.csv")
source("code/functions/regression-functions.R")
source("code/scripts/Train-Test.R")

# OLS regression
y.test = credit[test_set_indices,]$Balance
OLS_reg = lm(Balance ~., data = credit[train_set_indices,])
OLS_pred = predict(OLS_reg, credit[test_set_indices,])
OLS_tMSE = mean((OLS_pred-y.test)^2)

OLS_final = lm(Balance~., data = credit)

# table summary
library(pander)
sink("data/ols-results.txt")
cat("MSE:\n")
OLS_tMSE
cat("\n Official Coefficients:\n")
pander(OLS_final)
sink()

save(OLS_reg, OLS_tMSE, OLS_final, file ="data/OLS-Regression.RData")

