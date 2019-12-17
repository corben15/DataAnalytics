# Nicholas Corbett Data Analytics Final Project 
# eda.R -> Exploratory Data Analytics 


install.packages("linkcomm")
library(linkcomm)
library(plyr)
library(ggplot2)

interaction_data <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/datasets/ChCh-Miner_durgbank-chem-chem.tsv", 
                            sep="\t")
View(interaction_data)

interaction_count <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/interactionCount.csv", 
                                sep=",")
interaction_matrix <-read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/interactionMatrix.csv", 
                                sep=",", header = TRUE)



############################# Exploratory Data Analytics ################################### 


# Interaction Data
summary(interaction_data)

# Interaction Count 
View(interaction_count)
summary(interaction_count)
dim(interaction_count)
sd(interaction_count$V2)

ordered_interaction_count <- arrange(interaction_count, V2)
View(ordered_interaction_count$V1)

set.seed(1)
x <- interaction_count$V2
h <- hist(x, breaks=200, plot=FALSE)
cuts <- cut(h$breaks, c(-Inf,20,150,Inf))
par(bg="white")
grid(lty = 5,col = "white")
plot(h, col=c("white","green","red")[cuts],
     main = "Interaction Counts",
     xlab = "Interaction Count")

hist(interaction_count$V2,breaks=445,
     main = "Interaction Counts",
     xlab = "Interaction Count")

ggplot(data=interaction_count$V2, aes("Interaction Count")) + 
  geom_histogram()

boxplot(interaction_count$V2, 
        main="Interaction Count",
        ylab="Number of Interactions"
        col = "lightblue",
        outcol = "red")

# Interaction Matrix
View(interaction_matrix)
summary(interaction_matrix)



############################### MODEL DEVELOPEMENT ##################################

# Separate train and test sets:
dim(interaction_matrix)
sample_matrix <- sample(1514, 1000)
train_matrix <- interaction_matrix[sample_matrix,]
test_matrix <- interaction_matrix[-sample_matrix,]

View(train_matrix)
View(test_matrix)

dim(train_matrix)

############################# MODEL 1: K-NEAREST-NEIGHBORS ###########################

# For testing one drugs interactions
train_knn <- select(train_matrix, -DB00740)
test_knn <- select(test_matrix, -DB00740)

train_validation_knn <- select(train_matrix, DB00740)
test_validation_knn <- select(test_matrix, DB00740)


dim(train_validation_knn)
View(train_validation_knn)

dim()




KNNpred <- knn(train=train_knn[2:1514],test=test_knn[2:1514], cl=train_matrix$DB00740, k = 10)
KNNpred

table_knn <- table(Predicted = KNNpred, Actual = test_validation_knn)
table_knn  

#We can calculate the model1 accuracy
Model_knn_accuracyRate = sum(diag(table_knn))/sum(table_knn)
Model_knn_accuracyRate
# We can calcuate the missclassification rate 
Model_knn_MissClassificationRate = 1 - Model_knn_accuracyRate
Model_knn_MissClassificationRate

# For predictiong all the drugs interactions
a<- c(0)
b<- c(0)
interaction_prediction_accuracy <- data_frame(a,b)
names(interaction_prediction_accuracy) <- c("interactions", "pred_accuraccy")
print(interaction_prediction_accuracy)


i_count = 1
percent_accuracy = 0
sum_of_accuracy = 0
number_of_drugs = 0

for(drug in ordered_interaction_count$V1){
  print("HI")
  row <- filter(ordered_interaction_count,V1==drug)
  if(row$V2 == i_count){
    next
  }
  
  #else{
  #  i_count <- row$V2
  #  print(number_of_drugs)
  #  interaction_prediction_accuracy %>%
  #    mutate(interactions=i_count, pred_accuraccy=sum_of_accuracy/number_of_drugs)
  #  number_of_drugs <- 0
  #  sum_of_accuracy <- 0
    
  #}
  
  #number_of_drugs <- number_of_drugs + 1
  i_count <- row$V2
  train_knn <- select(train_matrix, -drug)
  test_knn <- select(test_matrix, -drug)
  
  KNNpred <- knn(train=train_knn[2:1514],test=test_knn[2:1514], cl=train_matrix[,drug], k = 10)
  
  table_knn <- table(Predicted = KNNpred, Actual = test_matrix[,drug])
  
  #We can calculate the model1 accuracy
  Model_knn_accuracyRate = sum(diag(table_knn))/sum(table_knn)
  #sum_of_accuracy <- sum_of_accuracy + Model_knn_accuracyRate
  
  interaction_prediction_accuracy %>%
    mutate(interactions=row$V2, pred_accuraccy=sum_of_accuracy/number_of_drugs)

}

i_count

View(interaction_prediction_accuracy)


############################# STATISTICAL NETWORK ANALYSIS ###########################



