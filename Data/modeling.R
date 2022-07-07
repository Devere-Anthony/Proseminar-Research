training <- read.csv("Data/training_set.csv")
# Just build a "test" model using all the variables to just to check out the results

# m1 contains all 22 variables; however, getting perfect prediction results
m1 <- glm(
   attack ~ flgs_number + pkts + bytes + state_number + dur + mean + stddev +
     sum + min + max + spkts + dpkts + sbytes + dbytes + rate + srate + drate +
     TnP_PDstIP + TnP_PerProto + AR_P_Proto_P_SrcIP + N_IN_Conn_P_DstIP +
     AR_P_Proto_P_Dport,
   data = training,
   family = "binomial"
)

summary(m1)

# try a model without the highly correlated ones
m2 <- glm(
   attack ~ flgs_number + pkts + bytes + state_number + dur + mean + stddev +
     sum + min + max + spkts +  sbytes + rate + srate + drate +
     TnP_PDstIP + TnP_PerProto + AR_P_Proto_P_SrcIP + N_IN_Conn_P_DstIP +
     AR_P_Proto_P_Dport,
   data = training,
   family = "binomial"
)
summary(m2)
