#https://www.datacamp.com/tutorial/decision-trees-R

##### MAIN IDEAS       #####

# A Decision trees is a SUPERVISED machine learning algorithm that can be used for both regression (predicting continuous values)..
###|- ... and classification (predicting categorical values) problems. 
###|- Moreover, they serve as the foundation for more advanced techniques, such as bagging, boosting, and random forests.

#A decision tree starts with a root node that signifies the whole population or sample,..
###|- ... which then separates into two or more uniform groups via a method called splitting. 
###|- When sub-nodes undergo further division, they are identified as decision nodes,..
###|- ... while the ones that don't divide are called terminal nodes or leaves. 
###|- A segment of a complete tree is referred to as a branch.

##    Popular Types of Decision Trees Algorithms    ##

# (1) Regression trees (works with numeric/quantitative target variable; more infor in webpage):
###|-  In order to build a regression tree, you first use recursive binary splitting to grow a large tree...
###|- ... on the training data, stopping only when each terminal node has fewer than some minimum number of observations. 
###|- Recursive Binary Splitting is a greedy and top-down algorithm used to minimize the Residual Sum of Squares (RSS)- an error measure also used in linear regression settings.

## Steps:
###|- Beginning at the top of the tree, you split it into 2 branches, creating a partition of 2 spaces. 
###|- You then carry out this particular split at the top of the tree multiple times and choose the split of the features that minimizes the (current) RSS.
###|- Next, you apply cost complexity pruning to the large tree in order to obtain a sequence of best subtrees, as a function of $\alpha$. 
###|- The basic idea here is to introduce an additional tuning parameter, denoted by $\alpha$ that balances the depth of the tree and its goodness of fit to the training data.
###|- You can use K-fold cross-validation to choose $\alpha$. This technique simply involves dividing the training observations into K folds to estimate the test error rate of the subtrees. 
###|- Your goal is to select the one that leads to the lowest error rate.


# (2) Classification Trees (more infor in webpage):

# A classification tree is very similar to a regression tree, except that it is used to predict a QUALITATIVE (eg. email spam detection) response variable rather than a quantitative one.
###|- Recall that for a regression tree, the predicted response for an observation is given by the mean response of the training observations that belong to the same terminal node. 
###|- In contrast, for a classification tree, you predict that each observation belongs to the most commonly occurring class of training observations in the region to which it belongs.
###|- In interpreting the results of a classification tree, you are often interested not only in the class prediction corresponding to a particular terminal node region,...
###|- ... but also in the class proportions among the training observations that fall into that region.

## Just as in the regression setting, you use recursive binary splitting to grow a classification tree. 
###|- However, in the classification setting, the Residual Sum of Squares cannot be used as a criterion for making the binary splits. 
###|- Instead, you can use either of these 3 methods: a) classification error rate b) Gini index c) Cross entropy


### Advantages of Decison trees (more infor in webpage):
#1- Easy to understand and interpret
#2- Can handle both continuous and categorical variables
#3- Minimal data preprocessing is required
#4- Can be used for feature selection and identifying important variables. 

### Disadvantages of Decison trees (more infor in webpage):
#1- Prone to overfitting
#2- Sensitive to small changes in the data
#3- Decision tree models are often not as accurate as other machine learning methods.
#4- Biased towards dominant classes.

###       Advanced Tree-Based Machine Learning Algorithms     ###

# BAGGING (more info on webpage):

###|- decision trees discussed above suffer from high variance,...
###|- ... meaning if you split the training data into 2 parts at random, and fit a decision tree to both halves,...
###|- ... the results that you get could be quite different. 
###|- In contrast, a procedure with low variance will yield similar results if applied repeatedly to distinct dataset.

## Bagging, or bootstrap aggregation, is a technique used to reduce the variance of your predictions by...
##... combining the result of multiple classifiers modeled on different sub-samples of the same dataset

## Basically, you use the equation to generate diff. bootstrapped training datasets
###|- You then train your method on the $bth$ bootstrapped training set in order to get the function (see web page), and finally average the predictions.

## Steps:

###|- 1) replace the original data with new data. The new data usually have a fraction of the original data's columns and rows,....
##########|- ... which then can be used as hyper-parameters in the bagging model.

###|- 2) build classifiers on each dataset. Generally, you can use the same classifier for making models and predictions.

###|-3) Lastly, you use an average value to combine the predictions of all the classifiers, depending on the problem. 
#########|- Generally, these combined values are more robust than a single model.


###|- While bagging can improve predictions for many regression and classification methods, it is particularly useful for decision trees. 
###|- To apply bagging to regression/classification trees, you simply construct $B$ regression/classification trees using $B$ bootstrapped training sets, and AVERAGE the resulting predictions. 
###|- These trees are grown deep, and are not pruned. Hence each individual tree has high variance, but low bias. 
###|- Averaging these $B$ trees reduces the variance.

### Broadly speaking, bagging has been demonstrated to give impressive improvements in accuracy by combining together hundreds or even thousands of trees into a single procedure.



# RANDOM FOREST (more info on webpage):

###|- Random Forests is a versatile machine learning method capable of performing both regression and classification tasks. 
###|- It also undertakes dimensional reduction methods, treats missing values, outlier values, and other essential steps of data exploration, and does a fairly good job.
###|- Random Forests improves bagged trees by a small tweak that decorrelates the trees. As in bagging, you build a number of decision trees on bootstrapped training samples.... 
###|- .....But when building these decision trees, each time a split in a tree is considered, a random sample of m predictors is chosen as split candidates from the full set of $p$ predictors. 
###|- The split is allowed to use only one of those $m$ predictors. This is the main difference between random forests and bagging; because as in bagging, the choice of predictor $m = p$.

## Steps:

###|- 1) assume that the number of cases in the training set is K. Then, take a random sample of these K cases, and then use this sample as the training set for growing the tree.
###|- 2) If there are $p$ input variables, specify a number $m < p$ such that at each node, you can select $m$ random variables out of the $p$. 
###########|- The best split on these $m$ is used to split the node.
###|- 3) Each tree is subsequently grown to the largest extent possible and no pruning is needed.
###|- 4) Finally, aggregate the predictions of the target trees to predict new data.

###|- Random Forests is very effective at estimating missing data and maintaining accuracy when a large proportions of the data is missing. 
###|- It can also balance errors in datasets where the classes are imbalanced. Most importantly, it can handle massive datasets with large dimensionality. 
###|- However, one disadvantage of using Random Forests is that you might easily overfit noisy datasets, especially in the case of doing regression.


# BOOSTING

###|- Boosting is another approach to improve the predictions resulting from a decision tree. 
###|- Like bagging and random forests, it is a general approach that can be applied to many statistical learning methods for regression or classification. 
###|- Recall that bagging involves creating multiple copies of the original training dataset using the bootstrap, fitting a separate decision tree to each copy, and then combining all of the trees in order to create a single predictive model. 
###|- Notably, each tree is built on a bootstrapped dataset, independent of the other trees.
###|- Boosting works in a similar way, except that the trees are grown sequentially: each tree is grown using information from previously grown trees. Boosting does not involve bootstrap sampling; instead, each tree is fitted on a modified version of the original dataset.

## How it works:

###|- 1) Unlike fitting a single large decision tree to the data, which amounts to fitting the data hard and potentially overfitting, the boosting approach instead learns slowly.
###|- 2) Given the current model, you fit a decision tree to the residuals from the model. That is, you fit a tree using the current residuals, rather than the outcome $Y$, as the response.
###|- 3) You then add this new decision tree into the fitted function in order to update the residuals. Each of these trees can be rather small, with just a few terminal nodes,...
###########|- .... determined by the parameter $d$ in the algorithm. By fitting small trees to the residuals, you slowly improve the function (see webpage) in areas where it does not perform well.
###|- 4) The shrinkage parameter $\nu$ slows the process down even further, allowing more and different shaped trees to attack the residuals.
 

###|- Boosting is very useful when you have a lot of data and you expect the decision trees to be very complex. 
###|- It has been used to solve many challenging classification and regression problems, including risk analysis, sentiment analysis, predictive advertising, price modeling, sales estimation, and patient diagnosis, among others.



#####         Decision trees in R         #####
data()      #Lists all internal datasets in R
library(readr)
library(MASS)

# We are using the boston housing data set (see webpage for description)
# The goal is to predict the target variable (MEDV) based on the 13 features (independent variables)

data("Boston")
View(Boston)

#lets explore the data thru viz and perform some preprocessing steps:

library(tidyr)
library(tidymodels)

## Prepare the dataset for ggplot2:
?pivot_longer
boston_data_long <- Boston %>%
  pivot_longer(cols =everything(),
               names_to = "variable",
               values_to ="value")                                 #This step is same as unpivoting a column in Power Query and naming columns "variable" and "value"

## Create a histogram for all numeric variables in one plot:

boston_hist <- ggplot(boston_data_long, aes(x = value)) +
  geom_histogram(bins = 30, color = "black", fill = "lightblue") +
  facet_wrap(~variable, scales = "free", ncol = 4) +
  labs(title = "Histograms of Numeric Variables in the Boston Housing Dataset",
       x = "Value",
       y = "Frequency") +
  theme_minimal()

print(boston_hist)

# We do notice some outliers, especially in the columns such as RAD, TAX and NOX. 
# Our goal for this tutorial is to focus on the decision tree modeling phase; hence let’s split the dataset into training and testing sets.

## Split the data into training and testing sets:

set.seed(123)
?initial_split
data_split <- initial_split(Boston, prop = 0.75)      # 75% of the data will be "retained" for training
train_data <- training(data_split)
test_data <- testing(data_split)


###     Simple Decision Tree Modelling      ###

?decision_tree
?set_engine
?set_mode
tree_spec <- decision_tree() %>%
  set_engine("rpart") %>%
  set_mode("regression")

## Fit the model to the training data:

tree_fit <- tree_spec %>%
  fit(medv ~ ., data = train_data)          # "medv ~ ." => is the formula, specifying the target variable (medv) to be predicted based on ALL other features (represented by the dot ".").
                                            ####|- so kinda like the regression models in spatial "practice", where census.data$qualification~ Census.data$employment(except here we use "." like "*" in SQL to rep all other data)
                                    

###         Evaluating the Decision Treel Modelling Performance         ###

# we will use the Tidymodels package to calculate the root mean squared error (RMSE)...
# ... and the R-squared value for our decision tree model on the testing data.

## Make predictions on the testing data:

predictions <- tree_fit %>%
  predict(test_data) %>%
  pull(.pred)             # usin "predict()" func. and pull here is same as using predict(test_data)$.pred => that is predict(test_data) has an output with a column/variable called .pred

## Calculate RMSE and R-squared:

metrics <- metric_set(rmse,rsq)
model_performance <- test_data %>%
  mutate(predictions = predictions) %>%
  metrics(truth = medv, estimate = predictions)

print(model_performance)

###|- So, are our model results good enough?
###|- RMSE: This measures the avg diff. b/w the predicted and true values. 
###|- In our case, the RMSE is 4.74, which means that, on average, the predictions made by the decision tree model are off by approximately 4.74 units from the true values. 
###|- A lower RMSE value is generally better, as it indicates smaller prediction errors.
###|- R²: This measures how well the model explains the variance in the target variable. It ranges from 0 to 1, with a higher value indicating a better fit. 
###|- In our case, the R² is 0.689, meaning the model explains approximately 68.9% of the variance in the target variable (MEDV).

### We can also optimize the hyper-parameters to squeeze out performance...
###... or go for more complex models such as Random Forests and XGBoost at the cost of model interpretability.


###       Predicting Outcomes Using the Decision Tree Model       ###

# If we're happy with the model, it's time to make predictions
# This is same as using the predict() func. but we’ll have to provide a new set of data mimicking info. abt a new house in Boston.

## Make predictions on new data:

new_data <- tribble(
  ~crim, ~zn, ~indus, ~chas, ~nox, ~rm, ~age, ~dis, ~rad, ~tax, ~ptratio, ~black, ~lstat,
  0.03237, 0, 2.18, 0, 0.458, 6.998, 45.8, 6.0622, 3, 222, 18.7, 394.63, 2.94
  )                                                                                       #Note: no tarhet variable here, (medv)

predictions <- predict(tree_fit, new_data)

print(predictions)

### We get the predicted medium value (in $1000s) of this particular house (with the stats provided in new_data)


###       Interpreting the Decision Tree            ###

install.packages("rpart.plot")

library(rpart.plot)

## Plot decision tree:

?rpart.plot
rpart.plot(tree_fit$fit, type = 4, extra = 101, under = TRUE, cex = 0.8, box.palette = "auto")

###|- The output diagram of the rpart.plot function shows a decision tree representation of the model. 
###|- In this diagram, each node represents a split in the decision tree based on the predictor variables.
###|
###|  UNDERSTANDING THE TREE:
###|  
###|- The tree diagrams start with the node => The nodes are represented by circles and are connected by lines,...
###|- ... showing the hierarchical structure of the decision tree. 
###|- The tree starts with a root node at the top, and it branches into internal nodes, ultimately leading to the terminal nodes or leaves at the bottom.
###|
###|- The splitting criteria for each internal node => Each internal node displays the splitting criterion, which is the predictor variable and the value used to split the data into two subsets.
###|- For example, a node might show “RM < 6.8”, indicating that observations with an average number of rooms per dwelling (RM) less than 6.8 will follow the left branch, while observations with RM greater than or equal to 6.8 will follow the right branch.
###|
###|- N: Number of observations after the split => The n value in each node represents the number of observations in the dataset that fall into that particular node.
###|- For example, if a node shows "n = 100", it means that 100 observations in the dataset meet the criteria of that node's parent nodes.
###|
###|- X% => The proportion of the total dataset observations that reached the particular node.
###|- The percentage value helps understand the relative size of each node compared to the entire dataset, showing how the data is being split and distributed across the tree. 
###|- A higher percentage means a larger proportion of the data has followed the decision path leading to the specific node, while a lower percentage indicates a smaller proportion of the data reaching that node.
###|
###|- The predicted value for each node => The predicted value at each node is displayed as a number in a colored circle (node). 
###|- In a regression tree, this is the average target variable value for all observations that fall into that node.
###|- For example, the last lead node showing 45 means that the average target variable value (in our case, the median value of owner-occupied homes) for all observations in that node is 47.


### Start at the root node and follow the branches => So when interpreting any outcomes, you start at the root node and follow the branches based on the splitting criteria until you reach a terminal node. 
### The predicted value in the terminal node gives the model’s prediction for a given observation and the rationale behind the decision.


## if we prefer to extract the rules in text form:

rules <- rpart.rules(tree_fit$fit)
print(rules)


### We might wonder how the decision can be made with 3–4 variables when we feed many more variables to the decision tree.

#**** my personal thought => this is due to PCA


###      Understanding the Important Variables from Decision Trees     ###

###|- Feature selection => Identifying important variables can help you focus on relevant features and potentially remove less important ones, simplifying your model and reducing noise.
###|- Domain knowledge => Gaining insights into which features are most important can help you better understand the relationships between variables and the target variable in the context of your specific problem.
###|- Model interpretation => Understanding the key features driving the model’s predictions can provide valuable insights into the decision-making process.

### So: In decision trees, variable imp. is usually det'd by the features used for splitting at the nodes. 
### Features that are used for splitting higher up in the tree or used more frequently can be considered MORE imp.

### We can quantify the imp. of variables by reducing the impurity measure (e.g., Gini index or mean squared error) it brings when used for splitting.

# quantifying imp. of variables:

install.packages("vip")
library(vip)

var_importance <- vip::vip(tree_fit, num_features = 10)
print(var_importance)

### The output makes sense considering the decisions in outree.
###|- RM: The average number of rooms per dwelling is a highly crucial feature, suggesting that houses with more rooms tend to have higher median values.
###|- LSTAT: The percentage of the population with lower socioeconomic status is another significant variable, indicating that lower-status neighborhoods are likely to have lower median home values.
###|- DIS: The weighted distance to employment centers is a vital variable, showing that houses closer to major employment centers are likely to have higher median values.