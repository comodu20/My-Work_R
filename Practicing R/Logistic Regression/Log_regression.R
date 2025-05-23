# https://www.youtube.com/watch?v=_yNWzP5HfGw

rm(list=ls())
library(tidymodels)


# We will look at the iris dataset and attempt to classify flowers as setosa's (1) or not setosas (0)
# The feature we intend to use is the sepal length

######   Prep data    #####


iris1 <- iris %>%
  mutate(setosa = as.integer(Species == "setosa"))    #NOTE that with the theme change the double equal (= =) looks like this "=="
View(iris)                                            # basically we are adding a column to iris called "setosa"
                                                      # the "as.integer" function assigns "1" to each row here the Species column has setosa

### *** MY WORK *** ###
# understanding the piping above
#iris2 <- iris
#iris3<- mutate(iris2, Setosa= as.integer(Species == "setosa"))

#rm(list = ls())
#### *** END OF MY WORK *** ###


#####  Splitting the data   #####

#We want to split this data into 2 pieces:

set.seed(2)

?initial_split
split <- initial_split(iris1,
                       prop = .80,
                       strata = setosa)   #we are stratifying the data by the column entry "Setosa" (with species = setosas, coded as 1s and non setosas coded as 0s)
                                          ###|- This is so that we get EQUAL proportions of setosas and non-setosas in both the training and testing data

iris1_train <- training(split)
iris1_test <- testing(split)
                                    
#Visualise the data
library(ggplot2)

ggplot(iris1_train,  
       aes(x =Sepal.Length,
           y =setosa)) + 
  geom_jitter(height = .05,
              alpha = .5)        # We can see from output that setosas are likely (~1) when sepal length is 0 - 5.5
                                 # And they are less likely (~0) when sepal length is >6

#Lets try again with a smoothing method

ggplot(iris1_train,  
       aes(x =Sepal.Length,
           y =setosa)) + 
  geom_jitter(height = .05,
              alpha = .5) + 
  geom_smooth(method = "glm", 
              method.args = list(family = "binomial"),
              se = FALSE) + 
  theme_minimal()         # theme_minimal() removes the ashen background.  I dont like it


# Building the model

model1 <- glm(setosa ~ Sepal.Length,
             data = iris1_train, 
             family = "binomial")

summary(model1)    # Output: The intercept (B0 = 29.210) and slope (B1 = -5.413) are the intercept and slope on the logit scale (log reg. formula => logit(p) = B0 + B1x), and not the actual intercept on the x-y plot
                  # Note: logit(p) = ln (p/(1-p))
                  # so, p = (e^(29.2 + (-5.4 * Sepal length))/(1 + e^(29.2 + (-5.4 * Sepal length))
                  # So if we chose to be manual for a sepal length  of 5mm, p = ~90%


# evaluate the model on the testing set

# We could in theory do the processes below on the training set, BUT it would paint an over optimistic picture
###|- the coefficients we have obtained (B0 and B1) were specifically calculated to "best-fit" the curve (output of line 52)
###|- So the model is more than likely to be overfit on the training set
###|- So its better to evaluate with unseen (testing) data

?predict
iris1_test <- iris1_test %>% 
  mutate(setosa_prob = predict(model1,
                               iris1_test,
                               type = "response"),
         setosa_pred = ifelse(setosa_prob > .5, 1, 0))    # As you know, mutate() is a function from dplyr that adds new columns to a data frame or modifies existing ones.
                                                          # setosa_prob = ...: This creates a new column named setosa_prob and assigns the result of the predict() function to it.
                                                          # predict(model1, iris1_test, type = "response"):
                                                          ###|- predict(): This is a generic function in R for making predictions from a fitted model.
                                                          ###|- model1: This is the fitted model object (likely a logistic regression or similar classification model, see above) that you want to use for prediction.
                                                          ###|iris1_test: This is the data frame (unseen data) containing the data for which you want to make predictions.
                                                          ###|-type = "response": This argument is crucial. It tells predict() to return the predicted probabilities (or "response") for the outcome, rather than the linear predictors. 
                                                          #######|- This is typical for logistic regression or other classification models where you want the probability of belonging to a certain class. In this case, it's the probability of being "setosa."


View(iris1_test)

# Lets see how good our model performed with the use of a confusion matrix

?table
t <- table (iris1_test$setosa, 
       iris1_test$setosa_pred)
t

# Output: so for 30 test samples, the model predicts 0 = Not setosa | 0 = Not setosa => 17 (True negative)
# 1 = setosa | 0 = Not setosa => 3 (false positive)
# 0 = Not setosa | 1 = setosa => 2 (False negative)
# 1 = setosa | 1 = setosa => 8 (True positive)

# see em as percentages:

sum(diag(t))/sum(t)   # 83% accuracy


# Lets assess sensitivity / True positive rate

# TPR = TP / TP + FN

8/(8+2)

# False negative rate

# FNR = FN / TP + FN
2/10

# True negative rate / Specificity
17/20

# false positive rate / Type I
3/20
