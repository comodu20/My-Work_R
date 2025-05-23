# https://www.youtube.com/watch?app=desktop&v=KubK6hgMbvg

?tidyverse
library(tidyverse)
install.packages("tidyverse")
install.packages("patchwork")
library(tidyverse)
library(patchwork)

data()
head(iris)
View(iris)

?mutate
?cut

#converting the numeric variable (sepal length) into a categorical variable (size)
#pipe operator (%>%) also means "and then"
##|- So, we have the iris data piped into the mutate func.( to modify, create, delete) which creates the "Size" column (breaking sepal lentgth into 3 intervals, subsequently named)
##|- All piped into the select() func. which basically picks the specific columns/vectors we want in our "Flowers" dataframe
Flowers <- iris %>%
  mutate(Size = cut(Sepal.Length, 
                    breaks = 3, 
                    labels = c("Small", "Medium", "Large"))) %>%
                    select(Species, Size)
rm(flowers)
View(Flowers)
table(Flowers)

####          Chi Goodness of Fit Test  (One categorical variable; it tests distrbn.)        #####

# Q: Is there a statitically significant diff. in the proportion of flowers that are small, medium, and large (alpha = 0.05)
##|
##|
##|- H0 = The proportion of the flowers that are small, medium and large are equal
##|- H1 = The proportion of the flowers that are small, medium and large are NOT equal

table(Flowers$Size)

#We only want goodness of fit of just the "size"
Flowers %>%
  select(Size) %>%
  table() %>%
  chisq.test()

# Answer is p-value = 6.673e-07, -> Reject that muhfuckin null!

?chisq.test
# we could alternatively use the following below, but i think I prefer the piping method
chisq.test(table(Flowers$Size))


#####         Chi Squared test of independence  (2 categorical variables; it tests rel. b/w both)        #####
##|
##|
##|- H0 = The variables are independent
##|- H1 = The variables are ARE DEPENDENT


#multiple ways
#1
Flowers %>%
  select(Species, Size) %>%
  table() %>%
  chisq.test()
#2
 
  table(Flowers) %>%
  chisq.test()

#3
  chisq.test(table(Flowers))
  
## reject the null at p-value < 2.2e-16
  
  

######        Fisher test     (To find the expected values)    #####
##|
##|
##|
##|- Fishers exact test checks if >20% of expected values are <5 OR all are if any values of <5 in a 2x2
  
#we can see how expected values can be got generally using the $expected

  Flowers%>%
    table() %>%
    chisq.test() %>%
    .$expected
  