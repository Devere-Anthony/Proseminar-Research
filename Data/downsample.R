# Script is meant to recreate a down sampled dataset to work with that includes 
# all the observations for normal traffic. 

data <- read.csv("~/proseminar/Bot-IoT/All-features/All features/merged_data.csv")

# Only keep the normal traffic and reconnaissance traffic
normal <- data[data$category == "Normal",]
nrow(normal)
recon <- data[data$category == "Reconnaissance",]
nrow(recon)

# These numbers are correct. So let's create a dataset only containing these
# observations before filtering further. 
data <- data[data$category == "Normal" | data$category=="Reconnaissance",]
nrow(data)

# Again, the math checks out. So, now I have a data set with 91,559 observations 
# only containing recon and normal traffic to down sample from. 
# Let's output this data set to possibly work with later. 
write.csv(data, "normal-recon-dataset.csv")

# Before down sampling, let's drop all the unnecessary stuff. 
# Drop the invalid features 
data$pkSeqID <- NULL
data$seq <- NULL
data$stime <- NULL
data$ltime <- NULL
data$saddr <- NULL
data$daddr <- NULL

# Drop all instances of ARP and ICMP 
data = data[data$proto != 'icmp',]
data = data[data$proto != 'arp',]

# convert to proper data types 
nums <- c(2, 4:8, 10:38)
data[nums] = lapply(data[nums], FUN= function(y) {
  as.numeric(y)
})

# Now, we need to create a down sampled dataset that contains ALL of the normal 
# observations and the remaining are to be recon. 
normal <- data[data$category == "Normal",]
recon <- data[data$category == "Reconnaissance",]
recon <- recon[sample(1:nrow(recon), 4570),]

# Combine the two dataframes to make the downsized dataframe. 
data <- rbind(normal, recon)
write.csv(data, "downsampled.csv")

# With the downsized dataset, let's only keep the variables we want to use.
data$flgs <- NULL
data$proto <- NULL
data$proto_number <- NULL
data$sport <- NULL
data$dport <- NULL
data$state <- NULL
data$TnBPSrcIP <- NULL
data$TnBPDstIP <- NULL
data$TnP_PSrcIP <- NULL
data$TnP_Per_Dport <-NULL
data$Pkts_P_State_P_Protocol_P_DestIP <- NULL
data$Pkts_P_State_P_Protocol_P_SrcIP <- NULL
data$AR_P_Proto_P_DstIP <- NULL
data$AR_P_Proto_P_Sport <- NULL
data$N_IN_Conn_P_SrcIP <- NULL

write.csv(data, "downsampled.csv")

# Create test-train split 
normal <- data[data$category=="Normal",]
normal_train <- normal[1:344,]
normal_test <- normal[345:nrow(normal) - 1,]

recon <- data[data$category=="Reconnaissance",]
recon_train <- recon[1:3656,]
recon_test <- recon[3657:nrow(recon)-1,]

# Combine to create the two datasets 











































