# https://www.youtube.com/watch?v=5mlth-yM2NE

######        K Means clustering            #####

#Question:

##|- 1) Randomly assign a number from 1 to K, to each of the observations. 
###########|- These serve as initial cluster assignments for the observations.
##|- 2) Iterate until the cluster assignments stop changing:
######|- a) For each of the K clusters, compute the cluster centroid. 
#############|- The kth cluster centroid is the vector of the p feature means for the observations in the kth clutser
######|- b) Assign each observation to the cluster whose centroid is closest (where closest is defined using the euclidean distance)

rm(list = ls())
library(readr)
Wine <- read_csv("Wine.csv")


######          ****ALL MY TRIAL****          #####
str(Wine)
test.z <- Wine[, -c(1,8)]

m <- apply(test.z, 2, mean)     
s <- apply(test.z,2,sd)

test.nor <- scale(test.z,center = m, scale = s)

distance = dist(test.nor)     
      
print(distance,digits = 3)
?kmeans
set.seed(123)
test.kmeans <- kmeans(test.nor,3)

test.kmeans
test.kmeans$centers

ot<- test.nor
datadistshortset <- dist(ot, method = "euclidean")
hc1 <- hclust(datadistshortset, method = "complete")
hc1
hc2 <- hclust(distance, method = "single")

plot(hc1)      #You can see compactness due to the use of method ="complete"
plot(hc1,labels=Wine$Country,main='Default from hclust')

plot(hc2)     # You can see elongation due to the use of method ="single"
plot(hc2,labels=Wine$Country,main='Default from hclust')

pamvshortset <- pam(datadistshortset, 4, diss = FALSE)

library(cluster)
clusplot(pamvshortset, shade = FALSE, labels = 2, col.clus = "blue", col.p ="red", span = FALSE, main = "Cluster Mapping", cex =1.2)


library(factoextra)
k2 <- kmeans(test.nor, centers = 3, nstart = 25)

str(k2)

fviz_cluster(k2, data = test.nor)


#####        Optimal Clusters         #####

fviz_nbclust(test.nor, kmeans, method = "wss")    # 3 is optimal cluster


## Average silhouette method
?fviz_nbclust


fviz_nbclust(test.nor, kmeans, method = "silhouette")        #This suggests as before that 3 is the optimal number of clusters


## Gap Statistic method
?fviz_nbclust

fviz_nbclust(test.nor, kmeans, method = "gap_stat")     # still dont fully know how to interpret this


#####         ****END  OF MY TRIAL****        #####

#####       K means from link at the top          #####

library(tidyverse)

#standardize continuos variables:

data_1 <- Wine %>% select(-Obs,-Country) %>% scale()          #note here: the same normalisation steps I take above, removing 1st (index) and last (character) column
#  Diff. here is that they have not normalised using mean and std.dev  => I believe normalising arnd mean and std . dev is probably default when center and scale = True

#create clusters w/ kmeans:
kmeans(data_1,centers = 3, iter.max = 100, nstart = 100)   # in keeping with the tasks in the Q; we have a, specified, high number of iterations
#added difference in "nstart" +> set to 100 here

#In output: each row of "cluster means" (The centroid) is one cluster.
##|- the "w/in cluster sum of squares by cluster": 114.3882, 119.1354, 156.1271 => can be used to det. the best value for k

library(factoextra)

fviz_nbclust(data_1, kmeans, method = "wss")      #We can see in output that 3 is optimal; this corresponds to the sum of the numbers (114.3882, 119.1354, and 156.1271)
# Where total wss (y-axis) correspnds to ~389 (114.3882 + 119.1354 + 156.1271) at k=3

fviz_nbclust(data_1, kmeans, method = "silhouette")  
fviz_nbclust(data_1, kmeans, method = "gap_stat")  # With this method, we try to pick the number for k that maximises the gap statistic. 
#THEREFORE the optimal number for k with this method is k=1


# We can also create a cluster bi-plot:
fviz_cluster(kmeans(data_1,centers = 3, iter.max = 100, nstart = 100), data = data_1)      #output: Dim1 and 2 are 1st and 2nd PCs respectively. 
# 31.2% and 23.7% are the amt of variability each PC contributes

#We can also visualise clusters usinng orginial variables:

data.clusters <- kmeans(data_1, centers = 3, iter.max = 100, nstart = 100)
data.clusters
Wine_1 <- Wine
Wine_1 <- Wine_1 |> mutate(cluster = data.clusters$cluster)

library(ggplot2)
Wine_1 |> ggplot(aes(x= Rating, y= Price, col = as.factor(cluster)))+ geom_point()

#Output: we see that elements with higher rating and higher price are assigned to cluster 1; 
#while, those with lower ratinf and lower price are assigned to cluster 3 
