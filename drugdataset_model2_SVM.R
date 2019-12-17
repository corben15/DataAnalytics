# Nicholas Corbett Data Analytics Final Project 
# Develope Second Model: Support Vector Machine


library(linkcomm)
library(plyr)
library(dplyr)
library(class)

interaction_matrix <-read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/interactionMatrix.csv", 
                                sep=",", header = TRUE)
#View(interaction_matrix)
dim(interaction_matrix)


# Separate train and test sets:
dim(interaction_matrix)
sample_matrix <- sample(1514, 1000)
train_matrix <- interaction_matrix[sample_matrix,]
test_matrix <- interaction_matrix[-sample_matrix,]

train_svm <- dplyr::select(train_matrix, -DB00465)
test_svm <- dplyr::select(test_matrix, -DB00465)
train_svm <- dplyr::filter(train_svm, DRUG != 'DB00465')
test_svm <- dplyr::filter(test_svm, DRUG != 'DB00465')

train_validation <- dplyr::select(train_matrix, DRUG, DB00465)
test_validation <- dplyr::select(test_matrix, DRUG, DB00465)
train_validation <- dplyr::filter(train_validation, DRUG != 'DB00465')
test_validation <- dplyr::filter(test_validation, DRUG != 'DB00465')

################################# DEVELOPE MODEL FOR ! DRUG ###################################
library(e1071)

SVMmodel <- svm(as.formula(paste("DB00465", "~ .")), train_matrix, kernel = "linear", cost = 10, scale = FALSE)
SVMmodel

SVMpred <- predict(SVMmodel, test_svm)


View(test_validation$DB00465)
View(test_svm$DB00465)

# TEST ACCURACY 
table_svm <- table(Predicted = round(SVMpred), Actual = test_validation$DB00465)
table_svm  

#We can calculate the model1 accuracy
Model_knn_accuracyRate = sum(diag(table_svm))/sum(table_svm)
Model_knn_accuracyRate


########################## Develope Model For all Drugs ########################## 
# Above I tested the model on one drug now I will test it for each drug and cross validate 

# ordered_interaction_count is used to plot the accurracy for each drug
ordered_interaction_count <- arrange(interaction_count, V2)
#View(ordered_interaction_count)

previous_drug_count = 0
current_drug_count = ordered_interaction_count$V2[1]

prediction_accuracy_svm <- setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("interactionCount", "accuracy"))
#View(prediction_accuracy)

drug_accuracy_sum = 1
same_interaction_count = 0
individual_accuracy_svm <- setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("interactionCount", "accuracy"))


i = 0
notfirst = FALSE
for(drug in ordered_interaction_count$V1){
  print(drug)
  
  row <- filter(ordered_interaction_count,V1==drug)
  #View(row)
  current_drug_count = row$V2
  if(current_drug_count == previous_drug_count){
    drug_accuracy_sum <- drug_accuracy_sum + Model_knn_accuracyRate 
    drug_accuracy_sum = drug_accuracy_sum + 1
    individual_accuracy_svm <- dplyr::add_row(individual_accuracy_svm, interactionCount = current_drug_count, accuracy=Model_knn_accuracyRate )
  }
  else{
    print("HI")
    individual_accuracy_svm <- dplyr::add_row(individual_accuracy_svm, interactionCount = current_drug_count, accuracy=Model_knn_accuracyRate )
    
    Model_knn_accuracyRate <- drug_accuracy_sum + Model_knn_accuracyRate 
    Model_knn_accuracyRate <- Model_knn_accuracyRate/same_interaction_count
    
    prediction_accuracy_svm <- dplyr::add_row(prediction_accuracy_svm, interactionCount = current_drug_count, accuracy=Model_knn_accuracyRate )
    drug_accuracy_sum = 0
    same_interaction_count = 0
    #if(notfirst){
    #  break
    #}
    notfirst = TRUE
  }
  
  train_svm <- dplyr::select(train_matrix, -drug)

  dim(train_svm)
  test_svm <- dplyr::select(test_matrix, -drug)
  train_svm <- dplyr::filter(train_svm, DRUG != drug)
  test_svm <- dplyr::filter(test_svm, DRUG != drug)
  
  train_validation <- dplyr::select(train_matrix, DRUG, drug)
  test_validation <- dplyr::select(test_matrix, DRUG, drug)
  train_validation <- dplyr::filter(train_validation, DRUG != drug)
  test_validation <- dplyr::filter(test_validation, DRUG != drug)

  result <- tryCatch({
      SVMmodel <- svm(as.formula(paste(drug, "~ .")), train_matrix,
                                      type = 'C-classification', 
                                      kernel = 'linear',
                                      cost = 10, scale = FALSE) 
    
      SVMpred <- predict(SVMmodel, test_svm)
      
      # TEST ACCURACY 
      table_svm <- table(Predicted = SVMpred, Actual=dplyr::select(test_validation,drug)[,1])
      table_svm  
      #We can calculate the model1 accuracy
      Model_knn_accuracyRate = sum(diag(table_svm))/sum(table_svm)
      Model_knn_accuracyRate
      
      previous_drug_count = current_drug_count
      i = i + 1
      if(i%%10 == 0){
        print(i)
      }
    },
    warning = function(war){
   
    },
    error = function(err){
      previous_drug_count = current_drug_count
    },finally = {
      next})

}

View(prediction_accuracy_svm) # for some reason the values are infinity
View(individual_accuracy_svm) # values are correct

plot(individual_accuracy_svm$interactionCount, individual_accuracy_svm$accuracy,
     main = "Interaction Count vs Prediction Accuracy SVM ",
     ylab = "Prediction Accuracy(%)",
     xlab = "Number of Drug Interactions",
     col = "red")

prediction_accuracy_svm <- setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("interactionCount", "accuracy"))


for( i in 1:443){
  if( i %in% individual_accuracy_svm$interactionCount){
    same_interaction_count <- dplyr::filter(individual_accuracy_svm, interactionCount==i)
    View(same_interaction_count)
    sum_same_interaction_count <- sum(same_interaction_count$accuracy)
    avg <- sum_same_interaction_count/dim(same_interaction_count)[1]
    prediction_accuracy_svm <- dplyr::add_row(prediction_accuracy_svm, interactionCount = i, accuracy=avg )
  }
}


plot(prediction_accuracy_svm$interactionCount, prediction_accuracy_svm$accuracy,
     main = "Interaction Count vs Prediction Accuracy SVM Cross Validation",
     ylab = "Prediction Accuracy(%)",
     xlab = "Number of Drug Interactions",
     col = "blue")



