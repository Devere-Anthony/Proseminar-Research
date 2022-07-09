# Let's work on building the model to start eliminating variables 
library(car)
training <- read.csv("Data/training_set.csv")

# Try the first model to see any issues 
m1 <- glm(
   attack ~ flgs_number + pkts + bytes + state_number + dur + mean + stddev +
     sum + min + max + spkts + dpkts + sbytes + dbytes + rate + srate + drate +
     TnP_PDstIP + TnP_PerProto + AR_P_Proto_P_SrcIP + N_IN_Conn_P_DstIP +
     AR_P_Proto_P_Dport,
   data = training,
   family = "binomial"
)
summary(m1)

# In this first model, there are two undefined coefficients which means these two variables have perfect correlation 


# m2 - drop the two perfectly correlated variables 
m2 <- glm(
   attack ~ flgs_number + pkts + bytes + state_number + dur + mean + stddev +
     sum + min + max + spkts +  sbytes + rate + srate + drate +
     TnP_PDstIP + TnP_PerProto + AR_P_Proto_P_SrcIP + N_IN_Conn_P_DstIP + AR_P_Proto_P_Dport,
   data = training,
   family = "binomial"
)
summary(m2)

# Were able to get rid of the two perfectly correlated variables such that all the coefficients are computed. 
# However, there are still some possible issues given the warning that are returned. These warnings often happen when there are 
# still highly correlated predictors. Let's take a look at the remaining variables to see what can be eliminated.

# check out VIF to get a clue as to what variables are possibly troublesome, for good measures we'll use the
# cutoff of 10 
m2.vif <- vif(m2)  
m2.vif

# check out correlations 
nums <- c(2:23)
cor(training[nums])

# let's create a model that doesn't include the high VIF variables
m3 <- glm(
  attack ~ flgs_number + state_number + dur + min + rate + srate + drate + TnP_PDstIP + TnP_PerProto +
    AR_P_Proto_P_SrcIP + N_IN_Conn_P_DstIP + AR_P_Proto_P_Dport,
  data = training, 
  family = "binomial"
)
summary(m3)
vif(m3)    # check out vif values for this model 

# These all seem to be fairly reasonable for my purposes (vif < 10). There are two that are over 5, but I'll keep them.

# TO DO: Read up on literature to understand these test statistics and other values that are computed along with 
# the diagnostics for logistic regression.


# Still getting the "algorithm did not converge error. This is possibly due to one or more of the variables perfectly 
# predicting the response. Let's build the model step-wise to try and figure out which one is possibly the problem. 
m4 <- glm(
  attack ~ flgs_number + state_number + min + srate + TnP_PDstIP,
  data = training, 
  family = "binomial"
)
summary(m4)

# Drop statistically insignificant variables 
m5 <- glm(
  attack ~ flgs_number + state_number + srate + TnP_PDstIP, 
  data = training, 
  family = "binomial"
)
summary(m5)
vif(m5)

# This is a little strange to me, but go ahead and use this methodology to go forward with analysis. This ultimately ended
# up giving me a model that only have four predictors. 

# At this point I'm not entirely sure how to interpet all the results, so take this time to go ahead and read up on 
# some of the material before proceeding. 





















