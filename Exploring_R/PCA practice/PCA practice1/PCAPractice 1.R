#Need to generate a set of random data for this practice 
datamatrix <- matrix(nrow=100, ncol=10)

#Note: this youtube example  was based on "gene science" or sth. first 5 samples will be wild type (wt)samples- normal every day samples.
#the last 5 samples will be Knockout ("ko") samples - samples missing a gene becasue they were "knocked out" 
colnames(datamatrix) <- c(
    paste("wt", 1:5, sep=""),
    paste("ko", 1:5, sep=""))
?colnames
?paste

#Naming the genes
rownames(datamatrix) <- paste("gene", 1:100, sep="")

#Assign fake read counts to the genes. Basically random number generation in the records of wt and ko fields. we can use poisson distr., here. Typically it might be better to use -ve binomial distr.
for (i in 1:100) {
  wt.values <- rpois(5, lambda = sample(x=10:1000, size=1))
  ko.values <- rpois(5, lambda=sample(x=10:1000, size=1))
  
  datamatrix[i,] <- c(wt.values, ko.values)
  
}
?rpois
head(datamatrix)

#Now we do PCA
?prcomp
install.packages("stats")
library(stats)

#by default, prcomp() expects the samples (vectors) to be rows, and genes (variables) to be columns. i.e. diff from what we have.
#Therefore, we need to transpose the matrix using the t() func. If we don't transpose, we will get a graph showing how the genes are related to eachother. we want to see relation between vectors(samples)
pca <- prcomp(t(datamatrix), scale. = TRUE) 

pca

#prcomp() returns three things: 1) x; 2) sdev; 3) rotation.

#'x' contains the principal components (PCs) for drawing a graph. Here we use the 1st two columns in x to draw a 2D plot that uses the first 2 PCs. There are 10 samples and 10 PCs
plot(pca$x[,1], pca$x[,2])

# the 1st PC a/c for the most variation in the original data. the 2nd PC accounts for 2nd most and so on. --This is reduction in dimension. No?----to plot  the 2D pCA graph, we usually use the 1st 2 PCs. However, sometimes we use PC2 and 3
plot(pca$x[,2], pca$x[,3])

#we can see the amt of variation in the original data each PC a/c for using the sdev output
pca.var <- pca$sdev^2

#converting to percentage
pca.var.per <- round(pca.var/sum(pca.var)*100,1)
barplot(pca.var.per, main="Scree Plot", xlab="Principal Component", ylab="Percentage Variation")  #we can see the big difference in contribution to variance b/w PC1 and the rest of the PCs

#We can use ggplot2 to make a fancy PCA that looks nice and provides us with lots of info.
library(ggplot2)

#First, we format the data to suit ggplot() func.
#one column with sample IDs
#two columns X, Y , for the X and Y coordinates
pca.data <- data.frame(Sample=rownames(pca$x),
  X=pca$x[,1],
  Y=pca$x[,2])
#you can see the one column for ID, two column .... brouhaha here
pca.data

#now we plot
ggplot(data=pca.data, aes(x=X, y=Y, label=Sample)) + 
  geom_text() + xlab(paste("PC1 - ", pca.var.per[1], "%", sep="")) +
  ylab(paste("PC2 - ", pca.var.per[2], "%", sep="")) +
  theme_bw() +
  ggtitle("My PCA Graph")

?geom_text
?theme_bw

#x axis tells us the % of variation in the original data that PC1 accounts for; the y axis does same but for PC2

#Now, we can use loading scores to determine which genes have the largest effect on where the samples are plotted.

#Let's try looking at loading scores for PC1 as it a/c for 92% variation in the data
loading_scores <- pca$rotation[,1]

#genes that push the sample to the left will have large -ve values while genes that push to the right will have large +ve values.
#since we're interested in both sets, we'll use the abs() func.to sprt based on the numbers magnitude rather than high to low
gene_scores<- abs(loading_scores)
gene_scores_ranked <- sort(gene_scores,decreasing = TRUE)
top_10_genes <- names(gene_scores_ranked[1:10])
top_10_genes

#Lastly we can see which of these genes had +ve loading scores
pca$rotation[top_10_genes,1]

#results show -ve scores which push wt to left side of graph and +ve scores pushing ko samples to the right