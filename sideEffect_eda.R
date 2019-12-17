# Nicholas Corbett Data Analytics Final Project 
# eda.R -> Exploratory Data Analytics 


install.packages("linkcomm")
library(linkcomm)
library(plyr)
library(dplyr)

side_effect_data <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/datasets/ChChSe-Decagon_polypharmacy.csv", 
                               sep=",", header = TRUE)

View(side_effect_data)

side_effects <- summary(side_effect_data$Side.Effect.Name)

side_effect_matrix <- side_effect_data <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/sideEffectMatrix.csv", 
                               sep=",", header = TRUE)
View(side_effect_matrix)








