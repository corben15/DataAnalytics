# Nicholas Corbett Data Analytics Final Project 
# eda.R -> Exploratory Data Analytics 


interaction_data <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/ChCh-Miner_durgbank-chem-chem.tsv", 
                            sep="\t")
View(interaction_data)

interaction_count <- read.table("/Users/nicholascorbett/Documents/Classes/DataAnalytics/homework/finalProject/code/test.csv", 
                                sep=",")
View(interaction_count)

summary(interaction_count)


hist(interaction_count$V2,breaks=100)
boxplot(interaction_count$V2, main="Boxplot for Interaction Count")





