install.packages("psych")
library(psych)
data1 <- data.frame(
  auto1 = c(2,2,2,1,2),
  auto2 = c(4,2,1,2,3),
  auto3 = c(2,1,2,2,3),
  auto4 = c(2,2,2,2,3)
)

alpha_result<- alpha(data1)
print(alpha_result)
View(data1)


