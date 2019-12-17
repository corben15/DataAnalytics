# Nicholas Corbett Data Analytics Final Project 
# Develope First model: Random Forrest

library(dplyr)
library(randomForest)
help("randomForest")

interaction_matrix <-read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/interactionMatrix.csv", 
                                sep=",", header = TRUE)

interaction_count <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/interactionCount.csv", 
                                sep=",")

ordered_interaction_count <- arrange(interaction_count, desc(V2))
View(ordered_interaction_count)

#View(interaction_matrix)
dim(interaction_matrix)


# Separate train and test sets:
dim(interaction_matrix)
sample_matrix <- sample(1514, 1000)
train_matrix <- interaction_matrix[sample_matrix,]
test_matrix <- interaction_matrix[-sample_matrix,]

train_rf <- dplyr::select(train_matrix, -DB00465)
test_rf <- dplyr::select(test_matrix, -DB00465)
train_rf <- dplyr::filter(train_rf, DRUG != 'DB00465')
test_rf <- dplyr::filter(test_rf, DRUG != 'DB00465')

train_validation <- dplyr::select(train_matrix, DRUG, DB00465)
test_validation <- dplyr::select(test_matrix, DRUG, DB00465)
train_validation <- dplyr::filter(train_validation, DRUG != 'DB00465')
test_validation <- dplyr::filter(test_validation, DRUG != 'DB00465')


for(i in 1:50){
  print(ordered_interaction_count$V1[i])
}





