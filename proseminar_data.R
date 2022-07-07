data <- read.csv("Data/Bot-IoT/All-features/All-features/combined.csv")

#===================================================================================================
# Data Cleaning
#===================================================================================================
# drop invalid packets 
data$pkSeqID <- NULL
data$seq <- NULL
data$stime <- NULL
data$ltime <- NULL
data$saddr <- NULL
data$daddr <- NULL

# drop all instances of ICMP and ARP data 
data = data[data$proto != 'icmp',]
data = data[data$proto != 'arp',]

# convert remaining columns to their proper data types 
nums <- c(2, 4:8, 10:38)
data[nums] = lapply(data[nums], FUN= function(y) {
  as.numeric(y)
})

# check number of observations in data 
nrow(data)

# create first subset of dataset only containing normal traffic and reconnaissance traffic
# n = 82,412
normal_recon <- data[(data$category == 'Normal') | (data$category == 'Reconnaissance'),]

# even still, this dataset is too large for in-memory
# let's down sample just for the purposes of building this test model
normal_recon_sample <- normal_recon[sample(1:nrow(normal_recon), 5000),]

# output this downsized dataset as a csv
write.csv(normal_recon_sample, "normal_recon_sample.csv")

#===================================================================================================
# Model Specification and Fitting  
#===================================================================================================
# build a test model to see if it works in general 
model <- glm(
  attack ~ pkts + bytes + state_number + dur + mean + stddev + sum + min + max + spkts + dpkts + sbytes +
    dbytes + rate + srate + drate,
  data = normal_recon_sample,
  family = 'binomial'
)

# possible issue, with quasi-complete separation, let's check it out though 
summary(model)

# Another possible issue that seems to be occurring is that dbytes is "not defined because of 
# singularities". This is likely occuring because there may be some very strong correlation between 
# two or more of the variables. 

# In order to see, let's check out the correlation matrix by first extracting the subset of 
# numeric variables.
x = subset(normal_recon_sample, select = c("pkts", "bytes", "state_number", "dur", "mean", "stddev", 
                                           "sum", "min", "max", "spkts", "dpkts", "sbytes", 
                                           "dbytes", "rate", "srate", "drate"))


































































































