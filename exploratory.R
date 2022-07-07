#===============================================================================
# Exploration of Downsampled Dataset
#===============================================================================
data <- read.csv("normal_recon_sample.csv")

# Current size of dataset is 5000 obs. and 41 variables
dim(data)

# Break down of dataset response variable 
nrow(data[data$category == "Normal",])
nrow(data[data$category == "Reconnaissance",])

# FML, need to go back and fix this. There are only 29 observations that are 
# normal traffic. This needs to be adjusted to inluded ALL of the normal
# observations in this smaller data set.











































