rm(list = c("g", "trg", "tst", "mymodel", "pc", "testing", "training","p", "ind", "p1", "tab", "tab1"))

# https://www.youtube.com/watch?v=kbJMz0KzMnI

#Factanalysis essentially tries to find the covariance and variance within an overall dataset, basically searching for relationships
#Factanalysis can achieve the goals of PCA, but PCA cannot fulfill that of Factanal
#Factanal requires more assumptions and is more stringent on assumptions e.g normality in linear rel. among variables
#MUST have >= 100 obs.

####        Assumptions         #####

##|- (1) Factors are centered (means at 0? like PCA)
##|- (2) Cov. of the factors (Cov(factors)) are independent
##|- (3) Factors and Errors are independent
##|- (4) Factors are randomly distributed

#####------------------------------------------#####

### PCA identifies var. very well but doesn't do as good a job with Cov.

#####         TERMINOLOGY OF FACTANAL         #####

##|- COMMUNALITY: Similar to R^2 term (ranges from 0 to 1)
##|- PATTERN: Estimate of weights in a factanalysis (we can think of it as coefficients in a regression-type model)
##|- LOADINGS: AKA Factor loading is the correlation coefficient for the variable end factor (kind of like a corr. b/w factor and feature). 
#########|-It shows the variance explained by the variable on that particular factor.
#########|- Most loadings on any factor showuld be small, whereas a few should be relatively larger
#########|- A large factor loading can be interpreted to be >0.7. But this is mostly subjective.
#########|- A specific row of a loadings matrix should display non-zero loadings on a few factors
#########|- Any pair of factors should have different patterns of loading.
##|- SCORES: AKA factor scores are the value retrieved after applying a func.
#########| It can be interpreted from the factor loadings where you apply an optimisation method to retrieve some value.
#########|- The value can be retrieved by using a variety of methods such as Regression, barlett's and Anderson-Rubin's methods.
#########|


#####------------------------------------------#####

### In Factanal, the rotational aspect is incredibly imp. It doesn't change the dist. metrics in the overall data set
### It does however, change the distrbn. of the data to get the overall view of the dataset while maintaining the variance



library(psych)
install.packages("foreign")
library(foreign)
data <- read.arff("places.arff")
View(data)
data1 <- data[,-10]

head(data1)
data1$siten <- seq.int(nrow(data1))
names(data1)
View(data1)

# fm is a factoring mthd
# "Data1" that i have created here is a raw data matrix of numerical values. However we can also use a data of Corr. or Cov. matrices.
?fa
pa <- fa(r = data1,
         nfactors = 3,
         rotate = "varimax",
         fm = "pa",
         residuals = TRUE)

# fm="pa" will do the principal factor solution (principal axis value).

ml <- fa(r = data1,
         nfactors = 3,
         rotate = "varimax",
         fm = "ml",
         residuals = TRUE)

#fm="ml" will do a maximum likelihood factor analysis

pa
ml

#####         Understanding Output          #####

#running both above give outputs showing cum var. of the "ml" method (0.48) is higher than that of the "pa" method (0.45)

# Tutorial chose to run with the "ml' mthd.
#judging from the standardized loadings (pattern matrix) output of Corr. (Corr. matrix)

##|- ML1 is related to the housing, Recreation, climate and economics variable (can be corresponded to a liveability factor)
##|- ML2 is related to the Health, arts, education, and transportation ( Can correspond the factor loading as a quality of life factor)
##|- ML3 is rel. to Crime (an aspect of quality of life)
##|
##|- Assessments here are highly subjective.
##|
##|- h2: h2 values display how much of the var. is explained by a given factor/feature and its loadings.
######|- It is the sum of the squared loadings, a.k.a. communality.
######|- e.g. Housing (and its factors under ML1, 2 and 3) contributes the most variance
##|- u2: is pretty much 1-h2 -> its the amt of variance NOT explained by a feauture and its loadings
######|- a.k.a. uniqueness

##### Typically we look under "h2" and which ever feature has a "h2" value closest to 1 is the feature whose var. contribution is best explained by the Factanal exercise
##### Conversely, we can tell that Economy is the factor least explained by the factanal due to its low "h2" (siten had lower scores but was simly an index, so ignored)
#########|- therefore, it would make sense to take economy out of the model

##|- com: The complexity term indicates how many factors contribute to a specific variable. 
######|- It equals one if an item loads only on one factor, 2 if evenly loads on two factors, etc. 
######|- Basically it tells you how much an item reflects a single construct. It will be lower for relatively lower loadings.
######|- If we want one factor to underline one variable, then the desired com value should be very close to 1
#
#
#
#### Variance accounted for:
##|- SS loadings: These are the eigenvalues, the sum of the squared loadings. In this case where we are using a correlation matrix, summing across all factors would equal the number of variables used in the analysis.
##|- Proportion Var: tells us how much of the overall variance the factor accounts for out of all the variables.
##|- Cumulative Var: the cumulative sum of Proportion Var.
##|Proportion Explained: The relative amount of variance explained- Proportion Var/sum(Proportion Var).
##|Cumulative Proportion: the cumulative sum of Proportion Explained.
#
#### TLI: Tucker Lewis fit index, typically reported in SEM. Generally want > .9
#
#
#
### Further down the output, we have the BIC (Bayesian info. criterion) value, of which we take the absolute value.
##|- compared to that of the "pa" methd, the abs(BIC) of ml is 29.72 vs that of pa at 3.25 (we can use this as a justification for "pa" if we wished)
##|- The lower BIC means that it would be a better fit to the model.


?sem
?sem.diagram
structure.diagram(pa)
structure.diagram(ml)
structure.sem(pa)
structure.sem(ml)
library(sem)
?sem
View(pa)
