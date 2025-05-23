rm(list = c("gene_scores", "gene_scores_ranked", "i", "ko.values", "loading_scores", "pca", "pca.data", "pca.var", "pca.var.per","x",  "y"))
rm("wt.values")
rm(list = c("data1","datamatrix"
            ,"top_10_genes"))

# https://www.r-bloggers.com/2021/05/principal-component-analysis-pca-in-r/
# https://www.youtube.com/watch?v=c_NvVOQK8kk
?iris
data("iris")
?str
str(iris)
View(iris)
summary(iris)
#|
#|- #data sets contains 150 observations with 5 variables 
#|- #PARTITION DATA - lets divide the data sets into training and test data sets

set.seed(111)
ind <- sample(2,nrow(iris),
              replace = TRUE,
              prob = c(0.8, 0.2)) 
#sample(2, nrow(iris), ...): This part of the code uses the sample function to randomly select elements from a vector containing the numbers 1 and 2. The number of elements selected (nrow(iris)) is equal to the number of rows in the iris dataset
#replace = TRUE: This argument allows elements to be chosen more than once during sampling
#prob = c(0.8, 0.2): This argument specifies the probability of selecting each element. In this case, there's an 80% chance of selecting 1 and a 20% chance of selecting 2
View(ind)
?sample
?set.seed()

training <- iris[ind==1,]
testing <- iris[ind==2,]
#ind == 1 filters the iris data to include only rows where the corresponding element in ind is equal to 1 (index contains "1"), same for ind ==2


View(testing)
View(training)
head(training)

### SCatter plots and Correlations
library(psych)

#First will check the correlation between independent variables. 
#Let’s remove the factor variable from the dataset for correlation data analysis.

?pairs.panels
# "[,-5]" below, simply means take all rows and columns, ignore column 5 (which is "Species"- an array of strings)
pairs.panels(training[,-5],
             gap = 0,
             bg = c("red", "yellow", "blue")[training$Species],
             pch = 21)

#Lower triangles provide scatter plots and upper triangles provide correlation values.

#Petal length and petal width are highly correlated (0.97). Same way sepal length and petal length (0.86) , Sepal length, and petal width (0.82) are also highly correlated (draw str8 line from distribution, right and up. intersection is the correlation number).
##|-This leads to multi-collinearity issues. So if we predict the model based on this, dataset may be erroneous.
##|-One way handling these kinds of issues is based on PCA!!!!
##|
##|- PCA is based on only independent variables. so we remove the 5th variable from the data set

pc <- prcomp(training[,-5],
             center = TRUE,     #To center the data so that the means of the variables = 0
             scale. = TRUE)     #Scale func. is used for normalisation (compresses or expands the data range so the variables have unit variance)
attributes(pc)
View(pc)
pc


pc$center


pc$scale

print(pc)       # get std dev. and loadings

#results show that:PC1 increases when Sepal Length, Petal Length, and Petal Width are increased and it is positively correlated 
##|-whereas PC1 increases Sepal Width decrease because these values are negatively correlated.


summary(pc)
#results show that:he first principal components explain the variability around 73% and its captures the majority of the variability.
##|- In this case, the first two components capture the majority of the variability.
##|

####        Orthogonality of PCs        ####

# Let's see whether the multicollinearity issue is addressed or not?.

pairs.panels(pc$x,
             gap = 0,
             bg= c("red", "yellow", "blue")[training$Species],
             pch = 21)
##we see now that the correlation coeff's are 0. So we can get rid of multicollinearity issues


####          Bi-Plot         ####
install.packages("devtools")
library(devtools)

#also install_github("vqv/ggbiplot")
library(ggbiplot)

g <- ggbiplot(pc,
              obs.scale = 1,
              var.scale = 1,
              groups = training$Species,
              ellipse = TRUE,
              circle = TRUE,
              ellipse.prob = 0.68)

#pc contains the dataset which houses our PCs
##|- obs.scale and var.scale are set to 1 so no scale is applied.
##|- we group by species so we can observe the diff. within the iris dataset
##|- ellispe is true so it draws an ellipse arnd the group of points in the plot which rep the prob. density
##|- circle is true for pllotting a unity circle in the plot, which reps the correlation structure of the variables
##|- ellipse.prob is a set parameter to make an ellipse that encompasses arnd 68% of the observations for each group (this varies depending on your project)

g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'horizontal',
               legend.position =  'top')
print(g)

#PC1 explains about 73.7% and PC2 explained about 22.1% of variability.
##|- Arrows are closer to each other indicates the high correlation.
##|- For example correlation between Sepal Width vs other variables is weakly correlated.
##|- Another way interpreting the plot is PC1 is positively correlated with the variables Petal Length, Petal Width, and Sepal Length, and PC1 is negatively correlated with Sepal Width.
##|- PC2 is highly negatively correlated with Sepal Width (can be seen with print (pc) result above where PC2 and sepal width have corr = -0.91).
##|- Bi plot is an important tool in PCA to understand what is going on in the dataset.



####        Prediction with PCs         ####

trg <- predict(pc, training)

#add species column info into trg
trg <- data.frame(trg, training[5])

#for "testing" dataset
tst <- predict(pc, testing)

#add species column info into tst
tst <- data.frame(tst, testing[5])

#Multinomial Logistic regression with First Two PCs
#Because our dependent variable (species) has 3 levels, we will make use of multinomial logistic regression.

install.packages("nnet")
library(nnet)

trg$Species <- relevel(trg$Species, ref = "setosa")
?relevel
mymodel <- multinom(Species~PC1+PC2, data = trg)

summary(mymodel)


####          Confusion Matrix & Misclassification Error – training       ####

p <- predict(mymodel, trg)
tab <- table(p, trg$Species)
tab                       #Confusion matrix

#Lets see the correct classification and misclassifications in training dataset.
1 - sum(diag(tab))/sum(tab)
##|- Misclassification error is 0.067 (6.7%)


####          Confusion Matrix & Misclassification Error – testing       ####

p1 <- predict(mymodel, tst)
tab1 <- table(p1, tst$Species)
tab1                    #Confusion matrixhttp://127.0.0.1:16203/graphics/6c0800d8-64b9-49a0-9778-1dd28fbbe893.png

#correct classification and misclassification in testing dataset.
1 - sum(diag(tab1))/sum(tab1)
##|- Misclassification error is 0.13 (13%)