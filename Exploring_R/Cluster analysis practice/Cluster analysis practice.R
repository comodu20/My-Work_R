#####       imp. R stuff from Intro to R book by crawley        #####

# remove everything in the object window
rm(list = ls())

# Suppose we want to know the integer part of a division: say, how many 13s in 119 ( the Integer Quotient)
119 %/% 13

# Modulo is very useful for testing whether numbers are odd or even: ODD numbers have modulo 2 value 1 and EVEN numbers have modulo 2 value 0:
  9 %% 2

8 %% 2

# Likewise, you use modulo to test if one number is an exact multiple of some other number. For instance, to find out whether 15421 is a multiple of 7 (which it is), then ask:
  15421 %% 7 == 0

  
#####           Cluster Analysis          #####
  
#https://www.r-bloggers.com/2021/04/cluster-analysis-in-r/

#https://www.youtube.com/watch?v=5eDqRysaico
  
##|- when we do data analytics, there are two kinds of approaches one is supervised and another is unsupervised.
##|- Clustering is a method for finding subgroups of observations within a data set.
##|- When we are doing clustering, we need observations in the same group with similar patterns and observations in different groups to be dissimilar.
##|- If there is no response variable, then the dataset is suitable for an unsupervised method, which implies that it seeks to find relationships between the n observations without being trained by a response variable.
##|- Clustering allows us to identify homogenous groups and categorize them from the dataset.
##|- One of the simplest clusterings is K-means, the most commonly used clustering method for splitting a dataset into a set of n groups.

library(readr)
?read_csv()
mydata <- read_csv("ClusterData.csv")

str(mydata)

?pairs

pairs(mydata)     #ERROR:Error in pairs.default(mydata) : non-numeric argument to 'pairs' => This is because there is a char array in the data as is, see below:

head(mydata)

#the first column, "company" is a character array, so we need to specify

pairs(mydata[2:9])   #a pairs plot will provide a scatter plot for all possible combinations

#****my stuff:

library(psych)
pairs.panels(mydata[,-1],
             gap = 0,
             bg = c("red", "yellow", "blue")[mydata$Company],
             pch = 21)
#**** End of my stuff


### We can also look at a scatterplot of the data

?plot
plot(mydata$Fuel_Cost~ mydata$Sales)
?with
with(mydata, text(mydata$Fuel_Cost ~ mydata$Sales, labels = mydata$Company, pos = 4, cex =0.5))

#****So with the above, we can kind of see that the data has 3 clusters based on the two variales (sales and fuel)


### NEXT, we Normalise:

##|- Normalization is very important (mandatory) in cluster analysis.
##|- Sometimes we have variables in different scales, we need to normalized based on scale function before clustering the data sets.
##|- When we normalise, avg of each variable = 0, std. dev ~ 1

z <- mydata[, -c(1,1)]

nasss <- mydata[,-1]    #same output a above
rm("nasss")
?apply
means <- apply(z, 2, mean)     #### 2 here means we are applying the fuction "mean" to columns
sds <- apply(z,2,sd)

?scale
nor <- scale(z, center = means, scale = sds)

### NEXT we can calc. the distance matrix (Euclidean distance)
?dist
distance = dist(nor)     
distance         #output is euclidean distance amongst all records
print(distance,digits = 3)
#e.g for companies repped at col. 6 (coy. 6 - Florida) and row 11 (coy. 11 - Nevada) have very distant values from each other => demonstrated by the high value (6)
# WHILE col. 7 (coy. 7 = Hawaiian) and row 12 (coy. 12 = New England) appear to be quite close due to low value (1.66)

#####          Hierarchical agglomerative clustering using "complete"          #####

?hclust

mydata.hclust = hclust(distance, method = "complete")
plot(mydata.hclust)
plot(mydata.hclust,labels=mydata$Company,main='Default from hclust')

# This is judged by height. So for e.g. at heights less than 2 we observe the same closeness in the "distance" output above....
#.... b/w coy. 10 and 13 (euclidean dist at 1.4)
# And so at abt height 7 everything becomes one big cluster

plot(mydata.hclust,hang=-1, labels=mydata$Company,main='Default from hclust')    # We can make the lines more aligned using "hang"



### Hierarchical agglomerative clustering using “average” linkage

mydata.hclust_avg <- hclust(distance, method = "average")
plot(mydata.hclust_avg, hang = -1)
plot(mydata.hclust_avg,hang=-1, labels=mydata$Company,main='Default from hclust')


###     Cluster Membership
?cutree

member.c = cutree(mydata.hclust,3)
member.a = cutree(mydata.hclust_avg, 3)
table(member.c, member.a)     ###OUTPUT = using avg linkage, there were 18 (13 +5) coys belonging to cluster 1, 1 coy in cluster 2 and so on;
###...Also using the complete linkage, there were 14 (13 + 1) coys belonging to cluster 1, 5 in cluster 2,and so on.
### We can see from the output that both methods are a good match for 13 coys (both listing them at cluster 1), 
### ALSO, there were 3 coys in cluster 3 of the complete method that match in the avg methd
##|
###|-  there are a number of diff. as well however!


### Characterising clusters

aggregate(nor, list(member.c),mean)     # we can check either mthd. let's use complete for now
###OUTPUT - The output shows 3 clusters
##|- we can use the info to xterize the 3 clusters
##|- Where there is minimal variation in averages in a column, we can conclude that that variable does not play a significant role in deciding cluster membership for the coys.
##|- e.g. Sales has a high variation from -ve to +ve: So coys in cluster 3 have higher sales and those in cluster 2 have lower than avg sales
######|- ALso, coys in cluster 2 seem to have higher than avg fuel cost than companies in cluster 3 (quite low)


#We can also observe the aggregate comparisons in non-normalised units:
aggregate(mydata[,-c(1,1)], list(member.c), mean)


### Silhouette plot

library(cluster)
plot(silhouette(cutree(mydata.hclust,3), distance))   #### Based on the plot, if any bar comes on the negative side then we can conclude that that particular data is an outlier and we can remove it from our analysis
##|- Also, if cluster formation has been good or members in a cluster are closer to each other, Silhouette width values will be high (and obvioulsy low values correspond to lack of closeness )



### Scree plot

# The Scree plot will allow us to see the variabilities in clusters
# Suppose we increase the number of clusters, the within-group  sum of squares will come down.

wss <- (nrow(nor)-1) * sum(apply(nor,2,var))

for (i in 2:20) wss[i] <- sum(kmeans(nor,centers = i)$withinss)

plot(1:20,wss,type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")  
#So in this data ideal number of clusters should be 3, 4, or 5. ==> don't understand "the HOW" ===> think the ans lies in where the bend in the curve starts
##|- You can see clearly that the drop in "within group sum of squares" is quite large as you go from 1 cluster to 2 and so on to 3, 4, 5 


### K Means clustering
set.seed(123)
kc <- kmeans(nor,3)
kc      ###***See meaning of output in youtube vid (2nd link at top) from 15:33 mins

ot<-nor
datadistshortset <- dist(ot, method = "euclidean")
hc1 <- hclust(datadistshortset, method = "complete")
?pam
pamvshortset <- pam(datadistshortset, 4, diss = FALSE)
?clusplot
clusplot(pamvshortset, shade = FALSE, labels = 2, col.clus = "blue", col.p ="red", span = FALSE, main = "Cluster Mapping", cex =1.2)

### Cluster Analysis in R

install.packages("factoextra")
library(factoextra)
k2 <- kmeans(nor, centers = 3, nstart = 25)
?kmeans
#The nstart option attempts multiple initial configurations and reports on the best output.
#using 25 initial configs is usually recommended

str(k2)
?fviz_cluster
fviz_cluster(k2, data = nor)

##|- If there are more than two dimensions (variables) fviz_cluster will perform principal component analysis (PCA)....
##|-....and plot the data points according to the first two principal components that explain the majority of the variance.


#####        Optimal Clusters         #####
?fviz_nbclust
fviz_nbclust(nor, kmeans, method = "wss")     #The results suggest that 4 is the optimal number of clusters as it appears to be the bend in the knee.


## Average silhouette method
?fviz_nbclust

# The average silhouette method computes the average silhouette of observations for different values of k.
# This approach measures the quality of a clustering
# It helps det. how well each observtion lies within a cluster
###  A high avg. silhouette with indicates a good clustering

fviz_nbclust(nor, kmeans, method = "silhouette")        #This suggests as before that 5 is the optimal number of clusters


## Gap Statistic method
?fviz_nbclust

# This approach can be utilized in any type of clustering method (i.e. K-means clustering, hierarchical clustering).
# The gap statistic compares the total intracluster variation for different values of k with their expected values under null reference distribution of the data.

fviz_nbclust(nor, kmeans, method = "gap_stat")      # In this method also optimal number of cluster is 5.


rm(list = ls())


######        CONCLUSION          ######

##|- K-means clustering is a very simple and fast algorithm and it can efficiently deal with very large data sets.
##|- K-means clustering needs to provide a number of clusters as an input. 
##|- Hierarchical clustering is an alternative approach that does not require that we commit to a particular choice of clusters.
##|- Hierarchical clustering has an added advantage over K-means clustering because it has an attractive tree-based representation of the observations (dendrogram).