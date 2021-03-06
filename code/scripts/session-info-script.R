library(ggplot2)
library(xtable)
library(glmnet)
library(pls)
library(rmarkdown)
library(pander)
library(tidyr)


sink("../../session-info.txt", append = TRUE)
cat("Session Information\n\n")
print(sessionInfo())
devtools::session_info()
sink()