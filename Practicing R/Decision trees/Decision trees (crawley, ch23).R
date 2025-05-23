###|- Often there are so many explanatory variables that we simply could not test them all,..
###|- ... even if we wanted to invest the huge amount of time that would be necessary to complete such a complicated multiple regression exercise
###|
###|-----Benefits of tree models:
###|1) They are very simple.
###|2) They are excellent for initial data inspection.
###|3) They give a very clear picture of the structure of the data.
###|4) They provide a highly intuitive insight into the kinds of interactions between variables.

library(tree)
library(tidyverse)
Pollute <- read.table("Pollute.txt", header = TRUE)
?attach
attach(Pollute)
names(Pollute)

model <- tree(Pollute)
plot(model)
text(model)  

#****My work:

  tree(Pollute) %>%
  plot() %>%
  text()        #doesn't work well
  
#*** End of my work

###|- You follow a path from the top of the tree (called, in defiance of gravity,THE ROOT) and proceed to one of the...
###|- ...terminal nodes (called a leaf) by following a succession of rules (called splits). 
###|- The numbers at the tips of the leaves are the mean values in that subset of the data (mean SO2 concentration - Pollution -  in this case).


###  Background (explaining the output) ###

  ###|-  The model is fitted using BINARY RECURSIVE PARTITIONING  (rpart), whereby the data are successively split along...
  ###|- ...coordinate axes of the explanatory variables so that, at any node, the split which maximally distinguishes the...
  ###|- ...response variable in the left and the right branches is selected. Splitting continues until nodes are pure or the data are too sparse (fewer than six cases, by default)
  ###|
  ###|- Each explanatory variable is assessed in turn, and the variable explaining the greatest amount of the deviance in y is selected. 
  ###|- Deviance is calculated on the basis of a threshold in the explanatory variable; 
  ###|- this threshold produces two mean values for the response (one mean above the threshold, the other below the threshold).


# See first level of output:

low <- (Industry<748)
tapply(Pollution, low, mean)  
?tapply

plot(Industry, Pollution, pch = 16)
abline(v=748, lty=2)
lines(c(0,748), c(24.92, 24.92))                  #24.92 =>from output of the tapply above
lines(c(748, max(Industry)), c(67,67))            #67 =>from output of the tapply above

 ###|- The procedure works like this. For a given explanatory variable (say, Industry above):
 ###|- 1) Select a threshold value of the explanatory variable (the vertical dotted line at Industry = 748).
 ###|- 2) Calculate the mean value of the response variable above and below this threshold (the two horizontal solid lines).
 ###|- 3) Use the two means to calculate the deviance (as with SSE, see p. 500).
 ###|- 4) Go through all possible values of the threshold (values on the x axis).
 ###|- 5) Look to see which value of the threshold gives the lowest deviance.
 ###|- 6) Split the data into high and low subsets on the basis of the threshold for this variable.
 ###|- 7) Repeat the whole procedure on each subset of the data on either side of the threshold.
 ###|- 8) Keep going until no further reduction in deviance is obtained, or there are too few data points to merit further subdivision (e.g. the right-hand side of the Industry split, above, is too sparse to allow further subdivision).

### The value of any split is defined as the reduction in this residual sum of squares. 
### The probability model used in R is that the values of the response variable are normally distributed within each leaf of the tree with mean µi and variance σ2. 
### Note that because this assumption applies to the terminal nodes, the interior nodes represent a mixture of different normal distributions, so the deviance is only appropriate at the terminal nodes

### If the twigs of the tree are categorical (i.e. levels of a factor like names of particular species) then we have a classification tree. 
### On the other hand, if the terminal nodes of the tree are predicted values of a continuous variable, then we have a regression tree

# KEY QUESTIONS:
###|- Which variables to use for the division.
###|- How best to achieve the splits for each selected variable.
###|
###|It is important to understand that tree models have a tendency to over-interpret the data: for instance, the occasional ‘ups’ in a generally negative correlation probably do not mean anything substantial.


#####           REGRESSION TREES          #####

###|- In this case the response variable is a continuous measurement, but the explanatory variables can be any mix of continuous and categorical variables. 
###|- You can think of regression trees as analogous to multiple regression models. 
###|- The difference is that a regression tree works by forward selection of variables, whereas we have been used to carrying out regression analysis by deletion (backward selection).

model <- tree(Pollution ~ ., Pollute)   #the regression tree is fitted by stating that the continuous response variable...
                                        #...Pollution is to be estimated as a function of all of the explanatory variables in the dataframe called Pollute
print(model)

### in the output:
 ###|- Terminal nodes are denoted by * (there are six of them)
 ###|- The node number is on the left (1, 2, 4, 5, 10,...,3), labelled by the variable on which the split at that node was made. 
 ###|- Next comes the ‘split criterion’ (<748, <190, ...,>748) which shows the threshold value of the variable that was used to create the split. 
 ###|- The number of cases going into the split (or into the terminal node) comes next (41, 36, 7, 29,...,5). 
 ###|The penultimate figure (22040, 11260, 4096,..., 3002) is the deviance at that node. Notice how the deviance goes down as non-terminal nodes are split. 
 ###|- In the root, based on all n = 41 data points, the deviance is SSY (22040) (see p. 499) and the y value (30.05) is the overall mean for Pollution. 
 ###|- The last figure on the right (30.05,24.92,43.43,20.45,...,67.00) is the mean value of the response variable within that node or at that that leaf. 
 ###|- The highest mean pollution (67.00) was in node 3 and the lowest (12.00) was in node 10.

### Note how the nodes are nested: within node 2, for example, node 4 is terminal but node 5 is not; within node 5 node 10 is terminal but node 11 is not; within node 11, node 23 is terminal but node 22 is not, and so on.


### Tree models lend themselves to circumspect and critical analysis of complex dataframes. 
### In the present example, the aim is to understand the causes of variation in air pollution levels from case to case. 

### The interpretation of the regression tree would proceed something like this:
 ###|- The five most extreme cases of Industry stand out (mean = 67.00) and need to be considered separately (i.e. 5 cases going into the split with 67 at terminal node).
 ###|- For the rest, Population is the most important variable but, interestingly, it is low populations that are associated with the highest levels of pollution (mean = 43.43). 
 ###|- Ask yourself which might be cause, and which might be effect.
 ###|- For high levels of population (greater than 190), the number of wet days is a key determinant of pollution;...
 ###|- ...the places with the fewest wet days (less than 108 per year) have the lowest pollution levels of anywhere in the dataframe (mean = 12.00).
 ###|- For those places with more than 108 wet days, it is temperature that is most important in explaining variation in pollution levels; the warmest places have the lowest air pollution levels (mean = 15.00).
 ###|- For the cooler places with lots of wet days, it is wind speed that matters: the windier places are less polluted than the still places.


#####         Using rpart (recursive partitioning) to fit tree models          #####
# More modern way of making trees

### We can compare the outputs of rpart and tree  for the pollution data:
?par
par(mfrow=c(1,2))
library(rpart)
model2<- rpart(Pollution ~ ., data = Pollute) %>%
  plot() %>%
  text()                      #only gives nodes

model2<- rpart(Pollution ~ ., data = Pollute)
plot(model2)
text(model2)  

###  The new function rpart is much better at anticipating the results of model simplification,...
###... because it carries out analysis of variance with the two-level factors associated with each split. 
### Thus, for temperature and industry:

t2 <- factor(Temp >= 56.25)
i2 <- factor(Industry <597)
mod <- lm(Pollution~t2*i2)
summary(mod)

### in output we see that it produces a significant interaction (shown by the split on right branch the tree diagram)....
###... and this model does not allow the inclusion of any other significant terms. 

##If population is added, it is marginally significant, but the original interaction between temperature and industry disappears:

mod2 <- lm(Pollution~t2*i2+Population)
summary(mod2)
