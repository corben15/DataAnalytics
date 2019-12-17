# Nicholas Corbett Data Analytics Final Project 
# Develope First model 

library(linkcomm)
library(plyr)
library(dplyr)
library(class)

interaction_matrix <-read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/interactionMatrix.csv", 
                                sep=",", header = TRUE)
interaction_count <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/interactionCount.csv", 
                                sep=",")


#View(interaction_matrix)
dim(interaction_matrix)

# Separate train and test sets:
dim(interaction_matrix)
sample_matrix <- sample(1514, 1000)
train_matrix <- interaction_matrix[sample_matrix,]
test_matrix <- interaction_matrix[-sample_matrix,]

############################## K-NEAREST-NEIGHBORS #########################################
train_knn <- dplyr::select(train_matrix, -DB01176)
test_knn <- dplyr::select(test_matrix, -DB01176)
train_knn <- dplyr::filter(train_knn, DRUG != 'DB01176')
test_knn <- dplyr::filter(test_knn, DRUG != 'DB01176')

train_validation <- dplyr::select(train_matrix, DRUG, DB01176)
test_validation <- dplyr::select(test_matrix, DRUG, DB01176)
train_validation <- dplyr::filter(train_validation, DRUG != 'DB01176')
test_validation <- dplyr::filter(test_validation, DRUG != 'DB01176')

dim(train_knn)
dim(test_knn)
dim(train_validation)
dim(test_validation)
View(train_validation)


View(train_knn)

KNNpred <- class::knn(train=train_knn[2:1514],test=test_knn[2:1514], cl=train_validation$DB01176, k = 10)
KNNpred


table_knn <- table(Predicted = KNNpred, Actual = test_validation$DB01176)
table_knn  

#We can calculate the model1 accuracy
Model_knn_accuracyRate = sum(diag(table_knn))/sum(table_knn)
Model_knn_accuracyRate
# We can calcuate the missclassification rate 
Model_knn_MissClassificationRate = 1 - Model_knn_accuracyRate
Model_knn_MissClassificationRate

# Calculate accuracy for different values of k
k_accuracy <- setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("kValue", "accuracy"))

for(drug in ordered_interaction_count$V1){
  for(k in 1:20){
    KNNpred <- class::knn(train=train_knn[2:1514],test=test_knn[2:1514], cl=train_validation$DB01176, k = k)
    table_knn <- table(Predicted = KNNpred, Actual = test_validation$DB01176)
    Model_knn_accuracyRate = sum(diag(table_knn))/sum(table_knn)
    
    k_accuracy <- dplyr::add_row(k_accuracy, kValue = k, accuracy =Model_knn_accuracyRate )
    
  }
}

View(k_accuracy)




plot(k_accuracy)

#################################### WEIGHTED KNN #################################
require(kknn)

interaction_matrix.learn <- interaction_matrix[sample_matrix,]
interaction_matrix.valid <- interaction_matrix[-sample_matrix,]

fit.kknn <- kknn( DB01176~., interaction_matrix.learn, interaction_matrix.valid, k=5, kernel = "gaussian")
table_kknn <- table(interaction_matrix.valid$DB01176, round(fit.kknn$fit))
table_kknn

#We can calculate the model1 accuracy
Model_knn_accuracyRate = sum(diag(table_kknn))/sum(table_kknn)
Model_knn_accuracyRate
# We can calcuate the missclassification rate 
Model_knn_MissClassificationRate = 1 - Model_kknn_accuracyRate
Model_knn_MissClassificationRate

################################# DEVELOPE MODEL FOR ALL DRUGS ###################################
# Above I tested the model on one drug now I will test it for each drug and cross validate 
help(knn)
# ordered_interaction_count is used to plot the accurracy for each drug
ordered_interaction_count <- arrange(interaction_count, desc(V2))
#View(ordered_interaction_count)

previous_drug_count = 0
current_drug_count = ordered_interaction_count$V2[1]

prediction_accuracy <- setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("interactionCount", "accuracy"))
#View(prediction_accuracy)
i = 0
for(drug in ordered_interaction_count$V1){
  print(drug)

  row <- filter(ordered_interaction_count,V1==drug)
  #View(row)
  current_drug_count = row$V2
  if(current_drug_count == previous_drug_count){
    next
  }
  
  train_knn <- dplyr::filter(train_matrix, DRUG != drug)
  test_knn <- dplyr::filter(test_matrix, DRUG != drug)
  
  
  KNNpred <- knn(train= dplyr::select(train_knn,-drug)[2:1514],
                 test = dplyr::select(test_knn,-drug)[2:1514],
                 cl = dplyr::select(train_knn,drug)[,1],
                 k = 5)

  table_knn <- table(Predicted = KNNpred, Actual = dplyr::select(test_knn, drug)[,1])
  table_knn  
  
  #We can calculate the model1 accuracy
  Model_knn_accuracyRate = sum(diag(table_knn))/sum(table_knn)
  Model_knn_accuracyRate
  # We can calcuate the missclassification rate 
  # Model_knn_MissClassificationRate = 1 - Model_knn_accuracyRate
  # Model_knn_MissClassificationRate
  
  prediction_accuracy <- dplyr::add_row(prediction_accuracy, interactionCount = current_drug_count, accuracy =Model_knn_accuracyRate )
  
  previous_drug_count = current_drug_count
  i = i + 1
  if(i==10){
    print(i)
  }
}
  

plot(prediction_accuracy$interactionCount, prediction_accuracy$accuracy,
     main = "Interaction Count vs Prediction Accuracy KNN",
     ylab = "Prediction Accuracy(%)",
     xlab = "Number of Drug Interactions",
     col = "blue")





