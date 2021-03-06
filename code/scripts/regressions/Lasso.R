# import csv
credit = read.csv("data/scaled-credit.csv")

# set seed
set.seed(159)

# lasso regression
source("code/scripts/Train-Test.R")
library(glmnet)
grid <- 10^seq(10, -2, length = 100)
lasso_reg = cv.glmnet(as.matrix(credit[train_set_indices, 1:11]), 
                      as.vector(credit[train_set_indices, 12]), 
                      intercept = FALSE,
                      standardize = FALSE, 
                      lambda = grid)
# min lambda
lasso_best = lasso_reg$lambda.min

# plot CV errors MSEP
png("images/reg-plots/lasso-validation.png")
plot(lasso_reg)
dev.off()


# prediction plot ================================================
png("images/reg-plots/lasso-prediction-plot.png")
plot(predict(lasso_reg, as.matrix(credit[test_set_indices, 1:11]), s = "lambda.min"), type = "l"
     , col = "red",main = "Predicted and Actual Credit Balances", 
     ylab = "Normalized Credit Balance")

lines(credit[test_set_indices, 12], col = "black")

legend(0, 3, legend = c("Predicted", "Actual"), fill = c("red", "black"), bty = "n")
dev.off()
# ================================================
  

lasso_pred = predict(lasso_reg, as.matrix(credit[test_set_indices, 1:11]), s = lasso_best)

# test MSE
lasso_tMSE = mean((lasso_pred - credit[test_set_indices, 12])^2) 

# refit model on full data set
lasso_final_reg= glmnet(as.matrix(credit[ ,1:11]), as.matrix(credit[12]), 
                         intercept = FALSE, standardize = FALSE, lambda = lasso_best)
lasso_final = predict(lasso_final_reg,type="coefficients")
#predict(lasso_reg, as.matrix(credit[ , 1:11]), s = "lambda.min")

# save to RData
save(lasso_reg, lasso_best, lasso_tMSE, lasso_final, file = "data/Lasso-Regression.RData")

library(pander)

# save to textfile
sink("data/lasso-results.txt")
cat("\n Best Lamba:")
lasso_best
cat("\n Lasso test MSE:")
lasso_tMSE
cat("\n Official Coefficients")
coef(lasso_final_reg)
sink()



        