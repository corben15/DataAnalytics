# Nicholas Corbett Data Analytics Final Project 
# Develope Second Model: Support Vector Machine


library(linkcomm)
library(plyr)
library(dplyr)
library(class)
library(e1071)

side_effect_matrix <- side_effect_data <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/sideEffectMatrix.csv", 
                                                     sep=",", header = TRUE)

#View(side_effect_matrix)

sample_matrix <- sample(616, 500)
train_matrix <- side_effect_matrix[sample_matrix,]
test_matrix <- side_effect_matrix[-sample_matrix,]

View(train_svm)
train_svm <- dplyr::select(train_matrix, -CID000003449)
test_svm <- dplyr::select(test_matrix, -CID000003449)
train_svm <- dplyr::filter(train_svm, Drug != 'CID000003449')
test_svm <- dplyr::filter(test_svm, Drug != 'CID000003449')

train_validation <- dplyr::select(train_matrix, Drug, CID000003449)
test_validation <- dplyr::select(test_matrix, Drug, CID000003449)
train_validation <- dplyr::filter(train_validation, Drug != 'CID000003449')
test_validation <- dplyr::filter(test_validation, Drug != 'CID000003449')

################################# DEVELOPE MODEL FOR ! Drug ###################################
library(e1071)

SVMmodel <- svm(as.formula(paste("CID000003449", "~ .")), train_matrix, kernel = "linear", cost = 10, scale = FALSE)
SVMmodel

SVMpred <- predict(SVMmodel, test_svm)


View(test_validation$CID000003449)
View(test_svm$CID000003449)

# TEST ACCURACY 
table_svm <- table(Predicted = SVMpred, Actual = test_validation$CID000003449)
table_svm  

#We can calculate the model1 accuracy
Model_knn_accuracyRate = sum(diag(table_svm))/sum(table_svm)
Model_knn_accuracyRate

########################## Develope Model For all Drugs ########################## 
# Above I tested the model on one Drug now I will test it for each Drug and cross validate 


