
# https://www.youtube.com/watch?v=C4N3_XJJ-jU

rm(list = ls())

url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"

heart_data <- read.csv(url, header=FALSE)

head(heart_data,10)

#### *** MY WORK ***  ####

# Handling missing values

library(tidyverse)
library(naniar)     #visualise missing data
library(gtExtras)

miss_var_summary(heart_data) %>%
  gt() %>%                                        # everything from here is just themes
  gt_theme_guardian() %>%                         #...
  tab_header(title = "Missingness of variables")  #...

#plot missing values

gg_miss_var(heart_data)


## Table of observations with missing data
heart_data %>%
  filter(!complete.cases(.)) %>%        # recall ! => NOT complete cases; (.) => ALL of the data
  head(10) %>%
  gt() %>%
  gt_theme_guardian() %>%
  tab_header(title = "Rows that contain missing values")


### The distribn. of the missing data

vis_miss(heart_data)    #numerical distribn of where the values are missing in the number spread


#### ***END OF MY WORK*** #### 

#No missing variables found

#### Assigning column names ####
# No columns are labelled. Therefore we need to name the columns after the names on the UCI website

colnames(heart_data) <- c(
  "age", 
  "sex", 
  "cp", 
  "trestbps",	
  "chol", 
  "fbs", 
  "restecg",
  "thalach",
  "exang",
  "oldpeak", 
  "slope", 
  "ca", 
  "thal", 
  "hd"
)

head(heart_data)

# View structure of data

str(heart_data)

# We see from output that sex is a number => its supposed to be a factor with 2 levels (0 - female and 1 - male)
# This info is available on UCI website (the assignment 1 - male and 0 - female as well) as "categorical" type data
# "cp" (Chest Pain type) as well is listed as a number. In fact, most cases where it should be categorical is listed as number
# "thal" is listed as a character!

# Tutorial is from 2018 and shows that "thal" and "ca" are correctly listed as factors (they're both characters in mine)
# It also shows both having missing values. Mine doesn't BUT i'll follow just to be safe


# replacing some "missing", ;) ,  values, and cleaning the data

#heart_data[heart_data == "?"] <- NA
#heart_data[heart_data$sex == 0,]$sex <- "F"
#heart_data[heart_data$sex == 1,]$sex <- "M"
#heart_data$sex <- as.factor(heart_data$sex)
#heart_data$cp <- as.factor(heart_data$cp)
#heart_data$fbs <- as.factor(heart_data$fbs)
#heart_data$restecg <- as.factor(heart_data$restecg)

# this is LOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOONNNNNNG.

#*** I personally figured out another way

# continue from line 83 above (did not have missing values);
library(tidyverse)
library(dplyr)

?mutate
heart_data <- heart_data %>% 
  mutate(sex = 
           recode(sex, 
                  `0` = "F", 
                  `1` = "M"))         # backticks (``) are used used around the numerical values to ensure R interprets them correctly. 
                                      # This is especially important when you have numerical values that might otherwise be interpreted as variable names.
head(heart_data)
tail(heart_data) 

# converting required data to factors

str(heart_data)

# from the UCI website, we need to change:
# sex, cp, fbs, restecg, exang, slope, and thal to factors (-> I added "ca" because i felt I need some consistency with the tutorial)

#lets view the columns and their numbers

as.data.frame(colnames(heart_data))

# convert to factors
?mutate_at
heart_data <- heart_data %>%
  mutate_at(vars(2, 3, 6, 7, 9, 11, 12, 13), 
            factor)
str(heart_data)


# change "ca" to integer according to UCI website
#basically our op above gives some values ="?", we want to get rid of them
heart_data[heart_data == "?"] <- NA
heart_data$ca <- as.integer(heart_data$ca)
heart_data$ca <- as.factor(heart_data$ca)

heart_data$thal <- as.integer(heart_data$thal)
heart_data$thal <- as.factor(heart_data$thal)

str(heart_data) #output no longer has "?" in the ca and thal sections

# change last column "hd"
# another method that could have been used with changing female (F) and male (M) above

?ifelse
heart_data$hd <- ifelse(
  heart_data ==0, 
  yes = "Healthy", 
  no = "Unhealthy"
)

heart_data$hd <- as.factor(heart_data$hd [, 14])  # I ran the code this way : heart_data$hd <- as.factor(heart_data$hd) -> it failed! I think its because the hd column sectioned off when I ran the ifelse  func.
                                                  # had to use the last column with hd as its tag, that showed both healthy and unhealthy states

str(heart_data)

#check to see NAs in either "ca" or "thal"
nrow(heart_data[is.na(heart_data$ca) | is.na(heart_data$thal),])   # Output shows there are 6 rows with NAs in either of "ca" or "thal"
                                                                    # The comma at the end in nrow(heart_data[is.na(heart_data$ca) | is.na(heart_data$thal), ]) is crucial because it tells R you're subsetting a data frame (or a matrix) and not just a vector.
                                                                   # heart_data[rows, ]: The comma with nothing after it means "select all columns" for the specified rows.
                                                                    # Without the comma, R would treat the expression inside the brackets as a selection of columns (if it's a character or numeric vector) or rows (if it's a logical vector)

#see for example the output of just the logical vectors
is.na(heart_data$ca) | is.na(heart_data$thal)            # 303 outputs of T and F

# SO if we tell R to count the rows in a subset of dataframe (heart_data), we need to specify for "what column"
# in our case we want it for every column so nothing comes after the comma


# lets view the NAs

heart_data[is.na(heart_data$ca) | is.na(heart_data$thal),]

# We see some commonalities where missing values are occuring for males in the rows where ca has NAs
# We can also see that 3 of them have heart disease


# Also

miss_var_summary(heart_data) %>%
  gt() %>%                                        
  gt_theme_guardian() %>%                         
  tab_header(title = "Missingness of variables")  

#plot missing values

gg_miss_var(heart_data)


### Rel. to two variables

heart_data %>%
  select(ca, thal, sex, hd) %>%
  ggplot(aes(x = sex,
             y = hd,
             size = thal,
             colour = is.na(ca))) +
  geom_point(alpha = 0.7) +
  facet_wrap(~is.na(ca)) +
  labs(title = "Missing ca Data by thalach and trestbps",
       color = "Missing ca data",
       y = "hd",
       x = "sex") +
  theme_bw()

# In this case however, we will remmove the NAs and not impute

heart_data <- heart_data[!(is.na(heart_data$ca) | is.na(heart_data$thal)),]

nrow(heart_data)   # output shows 303 - 6 = 297

# Now we need to make sure that healthy and diseased samples come from each gender (female and male)
# so for example, if ONLY male samples have heart disease, we should probably remove all females from the model

?xtabs
xtabs(~ hd + sex, heart_data)  # xtabs(...): xtabs stands for "cross-tabulations." It's a function in R that creates multi-dimensional contingency tables from formula specifications.
                               # ~ hd + sex: This is a formula that specifies the variables to be used in the contingency table.
                               # ~: The tilde symbol indicates that the variables to the right are used to construct the table -> *** recall using y ~ x in practice R scripts.
                               # +: The plus sign indicates that hd and sex should be used together to create the table.


# do same for chest pain and all the categorical and boolean variables
xtabs(~ hd + cp, heart_data)

xtabs(~ hd + fbs, heart_data)
xtabs(~ hd + restecg, heart_data)   # output shows that for restecg value 1 we only have 1 healthy and 3 unhealthy samples
                                    # This could potentially get in the way of finding the best fitting line

# tutorial does this for the remaining 10 columns

#But you can always trust that a lazy guy like me will find a smart shortcut
?spread

### get col names excluding hd

#see col name and number
as.data.frame(colnames(heart_data))

other_cols <- names(heart_data[-14])   # hd is col 14

# Loop through each column and create cross-tabulations

is.vector(other_cols) #its a vector, good to go!

for (i in other_cols) {
  cross_tab <- heart_data %>% 
    group_by(hd, !!sym(i)) %>% # Use !!sym to dynamically reference column names
    tally() %>%
    spread(hd, n, fill = 0) # Fill NA with 0
  
  print(paste("Cross-tabulation of hd and", i, ":"))
  print(cross_tab)                         #`` to see all rows
  cat("\n") # Add a newline for better readability
}
 

##### LOGISTIC REGRESSION #####

# lets try to predict heart disease using only the gender of each patient


#### ***My WORK2***   ####

set.seed(2)      # The Logic (or Lack Thereof) Behind the Number 2:
                 ###|- Arbitrary Choice: The number 2 (or any other integer) you choose for set.seed() is largely arbitrary. Any integer value will initialize the random number generator.
                 ###|- No Special Meaning: There is no inherent meaning or significance to the number 2 in this context. It doesn't affect the quality or randomness of the generated numbers.
                 ###|- Consistency: The only important thing is that you use the same seed if you want to reproduce the exact same sequence of random numbers.

#see for eg;

# Without set.seed()
runif(5)  # Generates 5 random numbers between 0 and 1
runif(5)  # Generates a different set of 5 random numbers

# With set.seed()
set.seed(2)
runif(5)  # Generates a specific set of 5 random numbers
set.seed(2)
runif(5)  # Generates the exact same set of 5 random numbers

set.seed(111)
runif(5)     # generates diff. set of random numbers. Most important thing is keeping the integer the same

library(tidymodels)
set.seed(2)
?initial_split
split <- initial_split(heart_data,
                       prop = .70,
                       strata = hd)   


heart_data_train <- training(split)
heart_data_test <- testing(split)

#Visualise the data
library(ggplot2)

ggplot(heart_data_train,  
       aes(x =sex,
           y =hd)) + 
  geom_jitter(height = .05,
              alpha = .5)       # we can sort of see the same split in the cross tab output from line 244


#Lets try again with a smoothing method

ggplot(heart_data_train,  
       aes(x =sex,
           y =hd)) + 
  geom_jitter(height = .05,
              alpha = .5) + 
  geom_smooth(method = "glm", 
              method.args = list(family = "binomial"),
              se = FALSE)        # This output isn't meaningful because of the nature of the data points in the x axis and the data type in the y axis

#### ***END OF MY WORK2***    ####

# call the glm func
?glm

logistic  <- glm(hd ~ sex,  data = heart_data, family = "binomial")
summary(logistic)

#log reg formula = logit(p) = B0 + B1x)

#### our output gives:
#logit(P(hd)) = -1.0438 + 1.2737 *(Sex = M; where Sex = 0 if patient is female)

#therefore: 

#logit(P(hd)) = -1.0438 (where sex = female)

#and 

#logit(P(hd)) = -1.0438 + 1.2737 = 0.2299 (where sex = male)

#in other words, 1.2737 is the log(odds ratio = p/(1-p)) of the odds that a male will have heart disease over the odds that a female will have heart disease

#### in output: the std error and z value columns for "(intercept)" and "sexM" shows how the Wald's test was computed for both coefficients
# the p-values (to the right) are both much lower than 0.05, showing statistical significance

# But remember, a small p-value alone, isn't interesting, we also want large effect sizes, and thats what the log odds and log(odds ratio) tell us

#### Output: "(Dispersion parameter for binomial family taken to be 1)" :
# When we do "normal" linear reg, we estimate the mean and variance from the data

# in contrast, with log. reg. we estimate the mean of the data, and the variance is derived from the mean

#Since we are not estimating the variance from the data (and instead, just deriving it from the mean), it is possible that the variance is underestimated....
#....if so, we can adjust the dispersion parameter in the summary() command.

#### Output: "Null deviance" and "Residual deviance":

# These can be  used to compare models, compute R-squared and an overall p-value

#### Output: "AIC":

# The "Akaike Information Criterion": in this context, it is just the residual deviance, adjusted for the no. of parameters in the model

# The AIC can be used to compare one model to another

#### Output: "Number of Fisher Scoring iterations":

# this just tells us how quickly the glm() func. converged on the MLE for the coefficients.


# Modeling on all other variables

logistic <- glm(hd ~., data = heart_data, family = "binomial")

summary(logistic)

####Output: we see that age isnt a useful predictor, due to its large p-value.
# However the median age in our dataset was 56, so most of the folks were pretty oldand that explains why it wasnt useful

#Gender however is still a good predictor

# ####Output: Residual deviance and AIV are both much smaller for the comprehensive model as opposed to the previous one with just 2 variables


# We can calc, McFadden's Pseudo R-squared 

# start with using the log-likelihood of the null mode:

ll.null <- logistic$null.deviance/-2  #output = -204.97

# and we can pull the log-likelihood for the comprehensive model by getting the residual deviance and dividing by -2

ll.proposed <- logistic$deviance/-2  #output = 91.551

# calc. McFadden's Pseudo R-squared:

(ll.null - ll.proposed)/ll.null    #output => R-squared = 0.553 (can be interpreted as the overall effect size)

# we can also calc. a p-value for our R-squared:

1-pchisq(2*(ll.proposed - ll.null), df = (length(logistic$coefficients)-1))  # the p-value is so tiny (0), that it (R-squared) must be significant


# Lets draw a grap of possibility of getting heart disease

predicted.data <- data.frame(
  probability.of.hd = logistic$fitted.values,
  hd= heart_data$hd
)                                                  #Create new dataframe containing Prb of having hd along with actual hd status

predicted.data <- predicted.data[
  order(predicted.data$probability.of.hd,
        decreasing = FALSE),
]                                                  # Sort the dataframe from low to high Prb


# then we add a new column, ranking the Prb

predicted.data$rank <- 1:nrow(predicted.data)

library(cowplot)
?ge
ggplot(data = predicted.data, 
       aes(x=rank, y= probability.of.hd)) + 
  geom_point(aes(color = hd), 
             alpha = 1, 
             shape = 4, 
             stroke = 2)+ 
  xlab("Index") + 
  ylab("Predicted probability of getting heart disease")

ggsave("heart_disease_probabilities.pdf") # pdf is shit
