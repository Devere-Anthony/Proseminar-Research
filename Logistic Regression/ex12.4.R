library(ResourceSelection)
library(performance)
# Example: Estimating Probability of Bankruptcies 
# Y = {0:bankruptcy, 1:solvent}
# X1 = retained assets / total assets
# X2 = earnings before interest and taxes / total assets
# X3 = sales / total assets

data <- read.table("P339.txt", header = TRUE)

# call logistic regression function using data
lr_model <- glm(
  Y ~ X1 + X2 + X3,
  data = data,
  family = "binomial"
)

summary(lr_model)

# To compute the odds, simply exp() both sides of the logit form of the model,
# for computation, just simply exp() the coefficients
exp(coefficients(lr_model))

# Compute 95% CI
# be sure to use confint.default() to compute CI for glm
confint.default(lr_model)
exp(confint.default(lr_model))


# Determination of variables to retain 
# using log-likelihood =>    2[L(p+q) - L(p)]
# L(p) is log-likelihood when we have a model with p parameters and a constant
# L(p + q) is lokLik for model with p varaibles with additional q
# variables and a constant
# Compute log-likelihood for our logistic regression model 
lp <- logLik(lr_model)
lp

# Now, let's attempt to figure out if the X3 variable can be deleted
# by creating a second mondel without the last variable. Then,
lr_model2 <- glm(
  Y ~ X1 + X2,
  data = data,
  family = "binomial"
)
summary(lr_model2)

# TO DO: Write all of this down eventually for review and consolidation

# Now, let's get the logLik of this new model 
lpq <- logLik(lr_model2)
lpq

# Compare
lp
lpq

# Compute 2[L(p+q) + L(p)], in this case we have
# 2[L(2+1) - L(2)]
chisqvar <- lpq - lp
chisqvar <- 2 * chisqvar
chisqvar    # this really has one degree of freedom

# Using chi-square table, we see at .05 level and 1 degree of
# freedom, the critical value is 3.84. Our value is well within
# the rejection region, thus we can delete X3 without affecting
# the effectiveness of the model. 


# Next, now that we have dropped variable X3, let's see if we can 
# drop variable X2
lr_model3 <- glm(
  Y ~ X1,
  data = data,
  family = "binomial"
)
summary(lr_model3)
lpq <- logLik(lr_model3)
lpq

# Compute chi-square variable, to do this you use the following:
csv <- 2 * (logLik(lr_model3) - logLik(lr_model2))
csv

# At 0.05 level with degrees of freedom 1, the critical value is
# 3.84. Our chi-squared valued (absolute value) is greater than
# 3.84, thus we keep our X2 variable . 

# Therefore, using this first method, we should keep x1 and 
# at least x2 in our model. 




































































