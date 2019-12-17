# Nicholas Corbett Data Analytics Final Project 
# Drug interaction dataset
# Develope First model

side_effect_matrix <- side_effect_data <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/sideEffectMatrix.csv", 
                                                     sep=",", header = TRUE)

#View(side_effect_matrix)

dim(side_effect_matrix)
sample_matrix <- sample(616, 500)
train_matrix <- side_effect_matrix[sample_matrix,]
test_matrix <- side_effect_matrix[-sample_matrix,]




############################## K-NEAREST-NEIGHBORS #########################################
require(kknn)
library(dplyr)

train_knn <- dplyr::select(train_matrix, -CID000003449)
test_knn <- dplyr::select(test_matrix, -CID000003449)
train_knn <- dplyr::filter(train_knn, Drug != 'CID000003449')
test_knn <- dplyr::filter(test_knn, Drug != 'CID000003449')

train_validation <- dplyr::select(train_matrix, Drug, CID000003449)
test_validation <- dplyr::select(test_matrix, Drug, CID000003449)
train_validation <- dplyr::filter(train_validation, Drug != 'CID000003449')
test_validation <- dplyr::filter(test_validation, Drug != 'CID000003449')

dim(train_knn)
dim(test_knn)
dim(train_validation)
dim(test_validation)
View(train_validation)


View(train_knn)

KNNpred <- knn(train=train_knn[2:616],test=test_knn[2:616], cl=train_validation$CID000003449, k = 10)
KNNpred


table_knn <- table(Predicted = KNNpred, Actual = test_validation$CID000003449)
table_knn  

#We can calculate the model1 accuracy
Model_knn_accuracyRate = sum(diag(table_knn))/sum(table_knn)
Model_knn_accuracyRate
# We can calcuate the missclassification rate 
Model_knn_MissClassificationRate = 1 - Model_knn_accuracyRate
Model_knn_MissClassificationRate


################################# DEVELOPE MODEL FOR ALL DrugS ###################################
# Above I tested the model on one Drug now I will test it for each Drug and cross validate 
help(knn)



previous_Drug_count = 0
current_Drug_count = ordered_interaction_count$V2[1]

prediction_accuracy <- setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("interactionCount", "accuracy"))
#View(prediction_accuracy)
i = 0
for(Drug in ordered_interaction_count$V1){
  print(Drug)
  
  row <- filter(ordered_interaction_count,V1==Drug)
  #View(row)
  current_Drug_count = row$V2
  if(current_Drug_count == previous_Drug_count){
    next
  }
  
  train_knn <- dplyr::filter(train_matrix, Drug != Drug)
  test_knn <- dplyr::filter(test_matrix, Drug != Drug)
  
  
  KNNpred <- knn(train= dplyr::select(train_knn,-Drug)[2:1514],
                 test = dplyr::select(test_knn,-Drug)[2:1514],
                 cl = dplyr::select(train_knn,Drug)[,1],
                 k = 5)
  
  table_knn <- table(Predicted = KNNpred, Actual = dplyr::select(test_knn, Drug)[,1])
  table_knn  
  
  #We can calculate the model1 accuracy
  Model_knn_accuracyRate = sum(diag(table_knn))/sum(table_knn)
  Model_knn_accuracyRate
  # We can calcuate the missclassification rate 
  # Model_knn_MissClassificationRate = 1 - Model_knn_accuracyRate
  # Model_knn_MissClassificationRate
  
  prediction_accuracy <- dplyr::add_row(prediction_accuracy, interactionCount = current_Drug_count, accuracy =Model_knn_accuracyRate )
  
  previous_Drug_count = current_Drug_count
  i = i + 1
  if(i==10){
    print(i)
  }
}
