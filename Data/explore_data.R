training <- read.csv("Data/training_set.csv")

# Let's try to address the issue of singularities (highly correlated variables)
nums <- c(2:23)
cor(training[nums])
