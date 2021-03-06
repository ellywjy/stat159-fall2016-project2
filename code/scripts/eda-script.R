library(ggplot2)
library(dplyr)


source("code/functions/eda-functions.R")
credit <- read.csv("data/Credit.csv")

# Subset by variable type
quant_credit <- credit[,c(2:7,12)]
cat_credit <- credit[,c(8:11)]

# Creating Upper Triangular Correlation Matrix
corr_matrix <- round(cor(quant_credit),4)
lower <- corr_matrix
lower[lower.tri(corr_matrix, diag =FALSE)] <- ""
lower <- data.frame(lower)

sum_df <- t(apply(quant_credit,2,getSummary))

#Save Data to eda-output
sink("data/eda-output.txt")

cat("Summary of Quantiative Variables in Credit:\n")
sum_df

cat("\n Frequency and Relative Frequency:\n")
getFreq(cat_credit)

cat("\n Correlation Matrix:\n")
lower

cat("\n anova output for Balance and Qualitative variables:\n")
aov(Balance~Gender + Student + Married + Ethnicity, credit)
sink()

# Create plots
ggplot(credit) + geom_histogram(aes(Income),binwidth = 10) + 
	labs(title = "Distribution of Income")
ggsave("images/histogram-Income.png")

ggplot(credit) + geom_histogram(aes(Limit),binwidth = 1000)+ 
	labs(title = "Distribution of Limit")
ggsave("images/histogram-Limit.png")

ggplot(credit) + geom_histogram(aes(Rating),binwidth = 50)+ 
	labs(title = "Distribution of Rating")
ggsave("images/histogram-Rating.png")

ggplot(credit) + geom_histogram(aes(Cards),binwidth = 1)+ 
	labs(title = "Distribution of Cards")
ggsave("images/histogram-Cards.png")

ggplot(credit) + geom_histogram(aes(Age),binwidth = 5)+ 
	labs(title = "Distribution of Age")
ggsave("images/histogram-Age.png")

ggplot(credit) + geom_histogram(aes(Education),binwidth=2)+ 
	labs(title = "Distribution of Education")
ggsave("images/histogram-Education.png")

ggplot(credit) + geom_histogram(aes(Balance),binwidth = 100)+ 
	labs(title = "Distribution of Balance")
ggsave("images/histogram-Balance.png")

ggplot(credit, aes(x= Gender, y = Balance))+ geom_boxplot()+ 
	labs(title = "Balance vs. Gender")
ggsave("images/boxplot-Gender.png")

ggplot(credit, aes(x= Married, y = Balance))+ geom_boxplot()+ 
	labs(title = "Balance vs. Married")
ggsave("images/boxplot-Married.png")

ggplot(credit, aes(x= Student, y = Balance))+ geom_boxplot()+ 
	labs(title = "Balance vs. Student")
ggsave("images/boxplot-Student.png")

ggplot(credit, aes(x= Ethnicity, y = Balance))+ geom_boxplot()+ 
	labs(title = "Balance vs. Ethnicity")
ggsave("images/boxplot-Ethnicity.png")

png(filename="images/scatterplot-matrix.png")
pairs(quant_credit,pch=18)
dev.off()



save(lower, file = "data/correlation-matrix.RData")

