# https://www.geeksforgeeks.org/factor-analysis-in-r-programming/

rm(list = c("data", "data1", 'ml', 'pa'))

####        IRIS data set         #####

### Factor analysis involves several steps:
  
##|- Data preparation: The data are usually standardized (i.e., scaled) to make sure that the variables are on a common scale and have equal weight in the analysis.
##|- Factor Extraction: The factors are identified based on their ability to explain the variance in the data. There are several methods for extracting factors, including principal components analysis (PCA), maximum likelihood estimate(MLE), and minimum residuals (MR).
##|- Factor Rotation: The factors are usually rotated to make their interpretation easier. The most common method of rotation is Varimax rotation, which tries to maximize the variance of the factor loadings.
##|- Factor interpretation: The final step involves interpreting the factors and their loadings (i.e., the correlation between each variable and each factor). The loadings represent the degree to which each variable is associated with each factor.

#### Data prep

#i.e. we need to prep the data by scaling the variables to have a mean of 0 and std dev (equals var., in this case, right?) = 1.
# This is imp. bcos factanal is sensitive to diff. in scale b/w variables.


iris_scaled <- scale(iris[, -5])


#### Factor extraction & rotation

# This can be done using a variety of methods, such as the Kaiser criterion, scree plot, or parallel analysis. 
# In this example, we will use the Kaiser criterion, which suggests extracting factors with eigenvalues greater than one.
# rotation is performed using the "rotate" argument

library(psych)
library(tidyverse)
?fa
fa_anal <- fa(r = iris_scaled,
              nfactors = 4,
              rotate = "varimax")
fa_anal %>% summary()

#### Factor interpretation

# Once the factor analysis is complete, we can interpret the results by examining the factor loadings, which represent the correlations between the observed variables and the extracted factors. 
# In general, loadings greater than 0.4 or 0.5 are considered significant.

fa_anal$loadings


####      Validating the Results of Factor Analysis         #####

# it is important to validate the results of the factor analysis by checking the assumptions of the technique, such as normality and linearity. 
# Additionally, it is important to examine the factor structure for different subsets of the data to ensure that the results are consistent and stable.

?subset
subset1 <- subset(iris[,-5],
                  iris$Sepal.Length < mean(iris$Sepal.Length))
fa_anal1 <- fa(subset1, nfactors = 4)
print(fa_anal1)

subset2 <- subset(iris[,-5],
                  iris$Sepal.Length >= mean(iris$Sepal.Length))
fa_anal2 <- fa(subset2,4)
print(fa_anal2)


# display variance explained by each factor 
print(fa_anal$Vaccounted)
