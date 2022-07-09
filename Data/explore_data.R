training <- read.csv("Data/training_set.csv")
library(car)

# Let's try to address the issue of singularities (highly correlated variables)
nums <- c(2:23)
cor(training[nums])
 

plot(m2, which = 4, id.n=2)
vif(m2)
