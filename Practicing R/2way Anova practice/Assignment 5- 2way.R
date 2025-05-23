set.seed(123)
book <- c("Romance", "Crime", "Science Fiction")
shop <- c(1, 2) 


#randomly generate data
?as.character
book <- sample(book, 50, replace = TRUE)
shop <- sample(shop, 50, replace = TRUE)
units <- sample(1:100, size = 50, replace = TRUE)

Book_sales <- data.frame(shop, book, units)


#plot#visualise the dataset

plot(units ~ factor(book) + factor(shop) , data = Book_sales, ylab = "Units sold", xlab="Shop")
#books seem to have different in mean units sold when shop is factored

#Two way anova

Twoway2 <- aov(units~factor(book)*factor(shop), data = Book_sales)
summary(Twoway2)
summary(lm(Twoway2))
 
