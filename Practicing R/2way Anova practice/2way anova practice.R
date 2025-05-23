# https://www.youtube.com/watch?v=7uR9c_yA0pE


data()
## There are three hypotheses in a 2 way anova

# H0: There is no interaction between the two factors
# H0_1: The means of observations grouped by one factor are the same
# H0_2: The means of observations grouped by the other factor are the same

# H1: reject?

# Aplha = 0.05

View(ToothGrowth)

plot(len ~ supp + factor(dose), data = ToothGrowth)

#two way anova

twoANOVA <- aov(len ~ supp * factor(dose), data = ToothGrowth)

summary(twoANOVA)

#in console we see the output: for the supplement, we can see a high f-value = 15.572, and a p-value = 0.000231 which is less than the significance level of 0.001
####|- So there IS a diff. b/w means of VC nd Orange juice supplements. Reject H0_1
# Also, we see a high f statistic for factor (dose), and a tiny p-value, less than 0.001, showing that there is a difference b/w the three doses. reject H0_2

# FINALLY, the interaction supp:factor (dose), shows p value < 0.05. so we can reject H0_3


