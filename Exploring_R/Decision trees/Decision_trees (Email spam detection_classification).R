# https://www.r-bloggers.com/2021/04/decision-trees-in-r/

library(DAAG)
library(party)
library(rpart)
library(rpart.plot)
library(mlbench)
library(caret)
library(pROC)
library(tree)


spam7
str(spam7)

mydata <- spam7


#Partition data:

set.seed(1234)
?sample
ind <- sample(2, nrow(mydata), replace = T, prob = c(0.5, 0.5))
train_1 <- mydata[ind == 1, ]
test_1 <- mydata[ind == 2, ]

# Tree classification
?rpart
tree_1 <- rpart(yesno ~., data = train_1)

rpart.plot(tree_1)

printcp(tree_1)
plotcp(tree_1)      # plots complexity parameter table for a decision tree model (tree_1)

### You can change the cp value according to your data set. 
### Please note lower cp value means bigger the tree. If you are using too lower cp that leads to overfitting also.

tree_1 <- rpart(yesno ~ ., data=train_1, cp = 0.07444)  #0.07444 from printcp(tree_1) output


###     Confusion matrix -train     ###

p <- predict(tree_1, train_1, type = 'class')
confusionMatrix(p, train_1$yesno, positive = 'y')       # be sure to mention positive classes in the confusion matrix


###      ROC (Receiver Operating Characteristic)   ###

# An ROC curve can help to find a balance between false negatives and false positives
# The context of the test is also imp. as some situations may req. a higher tolerance for false +ves to avoid missing any true +ves

p1 <- predict(tree_1, test_1, type = 'prob')
p1 <- p1[,2]
r <- multiclass.roc(test_1$yesno, p1, percent = TRUE)
roc <- r[['rocs']]
r1 <- roc[[1]]

plot.roc(r1,
         print.auc = TRUE,
         auc.polygon = TRUE,
         grid = c(0.1,0.2),
         grid.col = c("green", "red"),
         max.auc.polygon = TRUE,
         auc.polygon.col = "lightblue",
         print.thres = TRUE,
         main = 'ROC Curve')
