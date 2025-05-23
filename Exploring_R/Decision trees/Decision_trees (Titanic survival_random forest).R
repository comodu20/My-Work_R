# https://www.youtube.com/watch?v=uXIIk7suD6c




#contains shit from the youtube content first, then there's a web page directive after

install.packages("randomForest")
library(readr)
library(plyr) # means
library(dplyr) # data-cleaning
library(stringr) # data-cleaning
library(naniar) # missing data visualisation
library(ggplot2) # visualising predictors
library(rpart) # decision trees
library(rattle) # visualise decision trees
library(rpart.plot) # visualise decision trees
library(randomForest) # random forests
library(recipes) # random forests
library(caret) # model tuning
library(caTools) # cross validation 
library(pROC) # ROC curves
library(RColorBrewer)
library(Hmisc)
library(kableExtra) # markdown tables


###    FROM YOUTUBE
New_titanic <- read_csv("train.csv")

New_titanic_train <- New_titanic

?ordered

#coverting Pclass variable to ordered factor:
New_titanic_train$Pclass <- ordered(New_titanic_train$Pclass, levels = c("3", "2", "1"))

#There are missing values under the age column in the dataset, so;
?preProcess
impute <- preProcess(as.data.frame(New_titanic_train[, c(6:8,  10)]),           
                     method = c("knnImpute"))                                               ###*** needed to make input for preProcess a data.frame
?predict
New_titanic_train_imp <- predict(impute, New_titanic_train[, c(6:8, 10)])

New_titanic_train <- cbind(New_titanic_train[, -c(6:8, 10)], New_titanic_train_imp)  # fill in missing data ( -c(6:8, 10) -> exclude columns 6:8, and 10 with missing data); replace them with data from New_titanic_train_imp 
                                                                                    #*** filled in data looks completely diff. tho, how does this affect outcomes


New_titanic_train$Survived <- as.factor(New_titanic_train$Survived)           ### convert survived variable to a factor


#  Building the RF model:
?randomForest
set.seed(12)
rf_model <- randomForest(Survived ~ Sex + Pclass + Age + SibSp + Fare,
                         data = New_titanic_train,
                         ntree = 1000,
                         mtry = 2,
                         ) 

rf_model             #output shows OOB (Out of Bag) estimate - some data is left out when making each of the 1000 tress, the left out samples are used to estimate tha quality of the tree that is grown....
                    #....- error rate of 17.06%

# Output also shws confusion matrix of true +ves and -ves, as well as things the model got wrong.


### Now for the test dataset:

New_titanic_test <- read_csv("test.csv")

New_titanic_test$Pclass <- ordered(New_titanic_test$Pclass, levels = c("3", "2", "1"))

impute2 <- preProcess(as.data.frame(New_titanic_test[, c(5:7,  9)]),           
                     method = c("knnImpute"))

New_titanic_test_imp <- predict(impute2, New_titanic_test[, c(5:7,  9)])

New_titanic_test <- cbind(New_titanic_test[, -c(5:7, 9)], New_titanic_test_imp)

#Generate predictions:

test_preds <- predict(rf_model,
                      newdata = New_titanic_test,
                      type = "class")          #we are predicting class- 0 for died, 1 for survived

#This vid was for a kaggle competition, however;

pred_titanic <- data.frame(PassengerID = New_titanic_test$PassengerId, Survived = test_preds)
 pred_titanic
