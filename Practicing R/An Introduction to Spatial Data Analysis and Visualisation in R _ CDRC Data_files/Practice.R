Ethnicity <- read.csv("camden/tables/KS201EW_oa11.csv")
Rooms <- read.csv("camden/tables/KS403EW_oa11.csv")
Qualifications <- read.csv("camden/tables/KS501EW_oa11.csv")
Employment <- read.csv("camden/tables/KS601EW_oa11.csv")

# to view the top 1000 cases of a data frame
View(Employment)
View(Ethnicity)
View(Rooms)
View(Qualifications)
?View
?Names
??Names
# view column names of a dataframe
names(Employment)
names(Ethnicity)

####            SELECTING SPECIFIC COLUMNS ONLY           ####

# note this action overwrites the labels you made for the original data,
# so if you make a mistake you will need to reload the data into R
#the square brackets allow entry of rows and columns; as there's no row entry in the ff (since we want all rows), we are selecting only columns (multiple by using the concantenate func "c()")
Ethnicity <- Ethnicity[, c(1, 21)]
Rooms <- Rooms[, c(1,13)]
Employment <- Employment[, c(1, 20)]
Qualifications <- Qualifications[, c(1,20)]
View(Ethnicity)
View(Employment)
names(Employment)
?names

# to change a specific column name
names(Employment)[2] <- "Unemployed"

#check
names(Employment)

# to change multiple column names- in order (I think)- using concatenate func.
names(Ethnicity)<- c("OA", "White_British")
names(Rooms)<- c("OA", "Low_Occupancy")
names(Employment)<- c("OA", "Unemployed")
names(Qualifications)<- c("OA", "Qualification")


###           JOINING DATA IN R           ###

#you need a common field or column b/w 2 data sets to join them. in this case we have OA

#step1 Merge Ethnicity and Rooms to create a new object called "merged_data_1"
merged_data_1 <- merge(Ethnicity,Rooms,by="OA")
?merge

#step2 Merge the "merged_data_1" object with Employment to create a new merged data object
merged_data_2 <- merge(merged_data_1,Employment,by="OA")

#step3 Merge the "merged_data_2" object with Qualifications to create a new data object
Census.Data <- merge(merged_data_2,Qualifications,by="OA")

#4 Remove the "merged_data" objects as we won't need them anymore
rm(merged_data_1,merged_data_2)

#just testing out the names func.
names(Census.Data)[3] <- "Occupancy"
names(Census.Data)[3] <- "Low_Occupancy"


###           EXPORTING DATA            ###

# Writes the data to a csv named "practical_data" in your file directory

write.csv(Census.Data, "practical_data.csv", row.names = F)
?write.csv
#row.names= either a logical value indicating whether the row names of x (here, census,data) are to be written along with x, or a character vector of row names to be written. here we don't want row names written, so F = False




#####           DATA EXPLORATION IN R         #####

Census.Data  <- read.csv("practical_data.csv")
# prints the data within the console
print(Census.Data)

# prints the selected data within the console 

print(Census.Data[1:10,1:2])
print(Census.Data[1:20,1:5])   #here rows 1 to 20 and columns 1 to 5
#the above can also be written as:
print(Census.Data[1:20,]) #because we are selecting all columns, just like the "rows" case above, we can use a comma and no info for columns in the argument

# to view the top 1000 cases of a data frame
View(Census.Data)

#when dealing with very large, computationally intensive, data, you could opt to open the top (head() func.) or bottom (tail() func.) n cases.
head(Census.Data) #defaults to first n = 6 rows, same for tail().
head(Census.Data,3) #selecting first 3 rows
tail(Census.Data,2) #selecting bottom 2 rows

#Get the number of columns and rows
ncol(Census.Data)
nrow(Census.Data)

#list the column headings
names(Census.Data)

#To see what variables you have created in the current session, type:
objects()

#To see which packages and dataframes are currently attached:
search()



#####           DESCRIPTIVE STATS         #####
?colMeans
quantile(Census.Data,0.25) #doesn't work
?quantile
summary(Census.Data)[1:5] #gives 1st 5 lines of first column of summary stats
quantile(Census.Data[2])  #doesn't work
summary(Census.Data[3])   #gives the 3rd column of data object "census.data" summary stats
names(Census.Data)
summary(Census.Data)

#Use the "$" symbol to select a single variable from the "Cesnsus.Data" object
quantile(Census.Data$White_British) #finally works
mean(Census.Data$Unemployed)
median(Census.Data$Unemployed)
mode(Census.Data$Unemployed)
?mode
rm(ux)
rm(Mode)

range(Census.Data$Unemployed)
max(Census.Data$Qualification)
min(Census.Data$Qualification)


###        Univariate Plots       ### - they are a useful means of conveying the distribn of a particular variable.

##          Histograms          ##
#-
#perhaps the most informative means of visualising a univariate distribution

?hist
hist(Census.Data$Qualification)
hist(Census.Data$Unemployed)

#we can specify the number of data breaks/columns in the chart (breaks), colour the chart blue (col), create a title (main) and label the x-axis (xlab)
hist(Census.Data$Unemployed, breaks = 20, col = "blue", main = "% in full-time employment", xlab = "Percentage")

#the more the number of breaks, the more intricate and complex a histogram, see example with 50 breaks below
hist(Census.Data$Unemployed, breaks = 50, col = "yellow", border = "blue" , main = "% in full-time employment", xlab = "Percentage")


##          Boxplots          ##
#-
boxplot(Census.Data$Unemployed) #individual columns
boxplot(Census.Data$Unemployed,Census.Data$Qualification, Census.Data$White_British)  #select-multiple columns
boxplot(Census.Data[2:5])  #square brackets next to object inside the argument means we are picking exact columns based on knowledge of the object and its columns


##          Violin plot       ## need to install, see page 16
#-
install.packages()

#need to tell R package will be req'd (basically activate package) when you close and open R
#-
#to load the package
library(vioplot)
?vioplot
vioplot(Census.Data$Unemployed,Census.Data$Qualification,Census.Data$White_British,Census.Data$Low_Occupancy,ylim = c(0,100),col = "dodgerblue",rectCol = "dodgerblue3",colMed = "dodgerblue4")
vioplot(Census.Data$Unemployed,Census.Data$Qualification,Census.Data$White_British,Census.Data$Low_Occupancy,ylim = c(0,100),col = "darkolivegreen1",rectCol = "darkolivegreen4",colMed = "darkolivegreen")

# add names to the plot
vioplot(Census.Data$Unemployed,Census.Data$Qualification,Census.Data$White_British,Census.Data$Low_Occupancy,ylim = c(0,100),col = "darkolivegreen1",rectCol = "darkolivegreen4",colMed = "darkolivegreen",names = c("Unemployed","Qualifications","White British","Occupancy"))




####          Bivariate Plots in R          ####

#left of the comma is the x-axis, right is the y-axis.

plot(Census.Data$Unemployed,Census.Data$Qualification)

?plot
# includes axis labels, fram.plot remove border arnd axes
plot(Census.Data$Unemployed,Census.Data$Qualification, xlab="% in full time employment",
     ylab="% With a Qualification", frame.plot = axes)

#to change the default hollow cicles as markers, use pch

plot(Census.Data$Unemployed,Census.Data$Qualification, xlab="% in full time employment",
     ylab="% With a Qualification", pch = 24)



###         Symbols plot        ###
?symbols
symbols(Census.Data$Unemployed,Census.Data$Qualification, circle = Census.Data$White_British, inches = 0.3, fg = "white", bg= "purple", ylab = "% with at least level 4 Qualification", xlab="% employed" )
min(Census.Data$White_British)
max(Census.Data$Unemployed)


##      Adding a regression line        ## -----This can be done in R by adding (+) a linear model (lm()) function to our plot

#- the regression line is then repped using the abline() func.

#e.g. w/ bubble plot - the statement following "+"  adds a regression line and sets the colour to red
symbols(Census.Data$Unemployed,Census.Data$Qualification, circle = Census.Data$White_British, inches = 0.2, fg = "darkblue", bg= "darkolivegreen1", ylab = "% with at least level 4 Qualification", xlab="% employed") + abline(lm(Census.Data$Qualification~ Census.Data$Unemployed), col="red")

#e.g. w/ default plot func.
plot(Census.Data$Unemployed,Census.Data$Qualification, xlab="% in full time employment",
     ylab="% With a Qualification", pch = 22) + abline(lm(Census.Data$Qualification~ Census.Data$Unemployed), col="pink")
?lm
?abline


#we can also edit the line type using the line type (lty) and line width (lwd) commands from the abline() function
#-
# a bubble plot with a dotted regression line
symbols(Census.Data$Unemployed, Census.Data$Qualification,
        circles = Census.Data$White_British,
        fg="white", bg ="purple", inches = 0.2, xlab="% in full time employmented",
        ylab="% With a Qualification") +
  abline(lm(Census.Data$Qualification~ Census.Data$Unemployed), col="red", lwd=2, lty=2)

#regular plot with dotted regression line
plot(Census.Data$Unemployed,Census.Data$Qualification, xlab="% in full time employment",
     ylab="% With a Qualification", pch = 22) + abline(lm(Census.Data$Qualification~ Census.Data$Unemployed), col="pink", lwd=3, lty=2)


###       Using the ggplot2 package         ###
library("ggplot2")
library("vioplot")
library(vioplot)

#simple scatterplot using ggplot
?ggplot
?geom_point
ggplot(Census.Data, aes(Unemployed,Qualification)) #W/o "geom_point()", it just gives the plot background with no points plotted
p <- ggplot(Census.Data, aes(Unemployed,Qualification))
p + geom_point()


#or if you don't want to declare new object "p"
ggplot(Census.Data, aes(Unemployed,Qualification))+ geom_point()

#more
#-
# can set the size of bubbles and color
ggplot(Census.Data, aes(Unemployed,Qualification))+ geom_point(col="red",size=2)

#let's try adding regression line: geom_smooth()
?geom_smooth
ggplot(Census.Data, aes(Unemployed,Qualification))+ geom_point(col="red",size=2) + geom_smooth(method = "lm", col="darkblue", se = FALSE)

#can set various parameter for size n color, e.g. 4 diff variables below
p + geom_point(aes(colour = White_British, size = Low_Occupancy))

#or

ggplot(Census.Data, aes(Unemployed,Qualification))+ geom_point(aes(col = White_British, size = Low_Occupancy)) + geom_smooth(method = "lm", col="firebrick1", se=FALSE)

#or, i prefer to ignore second "aes" in geom_point() - DOESn'T work, need "aes" = "Aesthetics"
ggplot(Census.Data, aes(Unemployed,Qualification))+ geom_point(col = Census.Data$White_British, size = Census.Data$Low_Occupancy)  #this is a colorful but unseemly representation




####      Finding Relationships in R        ####

#-
###       Bivariate correlations        ###

# to measure  the rel. b/w two variables, we run a correlation using cor()

# PEARSON'S CORRELATION (AKA Product moment correlation) - measures LINEAR assoc. b/w 2 var.
# Greater values represent a stronger relationship between the pair. 
# 1 = perfect positive relationship, 0 = no linear correlation and -1 = perfect negative relationship

cor(Census.Data$Unemployed,Census.Data$Qualification)  #ans: r = -.624431

# ALSO, maybe better pearson stats can be obtained with cor.test() --> also gives the output of t-test
cor.test(Census.Data$Unemployed,Census.Data$Qualification)
#Confidence intervals display the range of values of which there is a defined probability that the coefficient ("r") falls within.


# cor.test() can be modified to spearman ---> good for NON-LINEAR rel.
cor.test(Census.Data$Unemployed,Census.Data$Qualification, method = "spearman")
cor.test(Census.Data$Unemployed,Census.Data$Qualification, method = "k")    #where we have too many rank ties for spearman

#we can also  produce a correlation pair-wise matrix. This will display a correlation coefficient for every possible pairing of variables in the data.
#to do this we need to format the data to get rid of the ID column (geography) as it will not work in a correlation.

data1 <-Census.Data[,2:5] # creates a data1 object which does not include the 1st column from the original data. Note the "," indicating our ignoring row info

#create  correlation matrix
cor(data1)
cor.test(data1) #won't work an an array, argument MUST be numeric vector

#we can round our results to 2 d.p
round(cor(data1),2)

# We can use the qplot() function from the ggplot2 package to create a HEATMAP of this correlation matrix
library(ggplot2)
installed.packages("reshape2")
library(reshape2)

#qplot
?qplot
?melt
?cor 
?fill
?scale_fill_gradient2
?geom
qplot(x=Var1, y=Var2, data=melt(cor(data1, use="p")), fill=value, geom="tile") + scale_fill_gradient2(limits=c(-1, 1)) # use = "p" --> "pairwise"


###       Regression analysis       ###

# R tries to minimise the distance from every point in the scatterplot to the regression line using the METHOD of LEAST SQUARES (MLS)

#typically, you first want to store the regression model in a "variable" 
model_1 <- lm(Census.Data$Qualification~ Census.Data$Unemployed)

#then
plot(Census.Data$Unemployed,Census.Data$Qualification, xlab = "% unemployed", ylab = "% Qualified", pch=22)+abline(model_1, col="darkblue", lty =2,lwd=3)

#to see simple and basic results
summary(model_1)  #this helps us find the y-intercept (at x=0) at 69.77 and the slope to be -4.0672

#we can find all values of y for any specific value of x, with the eqn of the line
predict(model_1,data.frame(Unemployed=c(15)))

head(predict(model_1,data.frame(Unemployed=c(15))))
##      R-SQUARED       ##
#the output from the above (predict) gives us residuals (diff. b/w observed values of Y for each case minus the predicated or expected value of Y - i.e. from the regression line)
# 1)Another way to look at it is that, our regression line is imperfect, as it doesn't cover all points
# 2)there are other factors affecting the dependent  variable (y) besides the dependent variable (x)\
# 3) These, in addition to measurement error and other forms of noise, contribute to the existense of "residuals"

#The distance between the mean and the observed value of Y is what we call the TOTAL VARIATION
#The RESIDUAL is the difference between our predicted value of Y and the observed value of Y
#from the summary func. above, we get an R2 (0<x<1)= .3899 --> model explains about 40% of the variance in the percentage of people with a degree in our study area



##         Inference with regression          ##

#In real world applications, we have access to a set of observations from which we can compute the least squares line, BUT the population regression line is unobserved.
# Therefore, our regression line is one of many that could be estimated
#A diff. set of Output Areas would give a diff. regression line
#If we estimate intercept (b0) and slope (b1) from a particular sample, then our estimates won’t be exactly equal to b0 and b1 in the population.
# However, if we could average the estimates obtained over a very large number of data sets, the average of these estimates would equal the coefficients of the regression line in the population.

# We can produce std errors for regression coeffs to quantify uncertainty abt these estimates
#These std err. can be further used to det. C.I (assuming residuals are normally distributed)
#For a simple regression - we are assuming that Y values are approx. normally distibuted for each level of X.
summary(model_1)
#Note that in the otput here, the p-value assoc. w/ the t value (Pe(>|t|)). And the e t-statistics and p-value are the same as the correlation coefficient.

#We can obtain C.I for our est. coeff. using the confint() func.
confint(model_1, level = 0.95)
#The 95% confidence interval defines a range of values that you can be 95% certain contains the mean slope of the regression line.

objects()

##          Multiple Regression           ##

#We can build BETTER models by using more than one predictor/explanatory/independent variable

#So in this case, we could add more variable than just "Unemployed" in predicting number of ppl with degree-level qualification

#Also, using multiple variables helps control for spurious correlations

#We have seen from the plots above that there are clearly fewer people living in deprivation in areas where more people have a degree, so let’s see if it helps us make better predictions.

#You could, for example, set up a model where you try to predict voting behaviour with an indicator of ethnicity and an indicator of structural disadvantage. 
#If, after controlling for structural disadvantage, you see that the regression coefficient for ethnicity is still significant you may be onto something, particularly if the estimated effect is still large.
#If, on the other hand, the t-test for the regression coefficient of your ethnicity variable is no longer significant, then you may be tempted to think structural disadvantage is a confounder for vote selection.


# runs a model with two independent variables
model_2 <- lm(Census.Data$Qualification~ Census.Data$Unemployed +
                Census.Data$White_British)
summary(model_2)
#Notice that the R-squared vaue has improved slightly compared to the first model.

#testing several variables to see how they affect distribn of qualifications
summary(lm(Census.Data$Qualification~ Census.Data$Unemployed + Census.Data$Low_Occupancy))
cor.test(Census.Data$Unemployed + Census.Data$Low_Occupancy, Census.Data$Qualification)
?cor.test
summary(lm(Census.Data$Qualification~  Census.Data$White_British))
summary(lm(Census.Data$Qualification~ Census.Data$Unemployed + Census.Data$Low_Occupancy + Census.Data$White_British))

rm(model_1)
rm(model_2)
rm(data1)
rm(Census.Data)
####          Making maps in R          ####
#-
# handling and mapping spatial polygon data in R.
#A GIS shapefile is a file format for storing the location, shape, and attributes of geographic features

Census.Data <-read.csv("practical_data.csv")
install.packages("rgeos", repos="http://R-Forge.R-project.org")
library("rgdal")

install.packages("sp")
library(sp)
library(rgeos)     #had issues installing stated packages, using sf and terra
library(sf)
library(terra)
library(sf)



#Next, we load the output area (OA) shapefiles
#We will be using output area boundaries as our data is at that level

# Load the output area shapefiles
Output.Areas<- readOGR(".", "Camden_oa11") #doesn't work as its from sp>rgdal
Output.Areas<- st_read(".", "Camden_oa11")

?st_read
#plot the map
plot(Output.Areas, main = "Output Areas")
?plot


##        Joining Data          ##
#We now need to join our Census.Data to the shapefile so the census attributes can be mapped.
#This is because our census data contains the uniques names of each OA - this can be used as a key to merge the data to our output area file ((which also contains unique names of each output area)

#column headers for our OA are not identical (even though they contain the same data)
#check
names(Census.Data)
names(Output.Areas)
View(Output.Areas)

#THEREFORE, we need to use by.x and by.y so the merge function uses the correct columns to join the data

# joins data to the shapefile
OA.Census <- merge(Census.Data, Output.Areas, by.x="OA11CD", by.y="OA") #will only work in a specific order

OA.Census <- merge(Output.Areas, Census.Data, by.x="OA11CD", by.y="OA") #This works !!!!!

#trying sth out
OA.Census1 <- merge(Census.Data, Output.Areas, by.y="OA", by.x="OA11CD") #Nope


##          Setting a coordinate system         ##
#-
# When mapping multiple and different files it is imp. to set a coordinate system
?proj4string    #Sets or retrieves projection attributes on classes extending SpatialData
?CRS           #Interface class to the PROJ projection and transformation system.
# The above funcs allows us to set the coordinate sys of a shapefile to a predefined sys of our choice.

#Most data from the UK is projected using the British National Grid (EPSG:27700) produced by the Ordnance Survey.
# In this case, the shapefile we originally downloaded from the CDRC Data website already has the correct projection system so we don’t need to run this step for our OA.Census object. 
#However, it is worth taking note of this step for future reference

library(sf)
library(sp)
# sets the coordinate system to the British National Grid
proj4string(OA.Census) <- CRS("+init=EPSG:27700")       #Doesn't work
st_crs(OA.Census) <- CRS("+init=EPSG:27700")         #works - with sp package



##          Mapping data in R       ##

# Several packages allow us to map data relatively easily. 
# They also provide a number of functions to allow us to tailor and alter the graphic
# E.g. the ggplot2() allows spatial data mapping
library(ggplot2)
?ggplot
ggplot(Output.Areas) #no output  # Dunno how to ggplot output.area. I've tried
rlang::last_trace()
rlang::last_trace(drop = FALSE)
rm(OA.Census1)
names(Output.Areas)[2] <- "geometry_2"
names(Output.Areas)[2] <- "geometry"
names(OA.Census)[6] <- "geometry"
geom_map(OA.Census)
plot(Output.Areas, main = "Output Area")

# Probably the easiest to use mapping funcs are found in the tmap library
install.packages("tmap")
library(tmap)
library(leaflet)

##        Creating a quick map        ##

#To create a quick map with a legend, you can use the qtm() func.
#qtm = quick thematic map
?qtm
#  this will produce a quick map of our qualification variable

library(tmap)
qtm(OA.Census, fill = "Qualification")
qtm(OA.Census, fill = "Qualification") + tm_layout(legend.outside.size = 0.5,legend.outside = TRUE)    #My spin

# To create more advanced maps in tmap you bind several funcs of the graphic's aspects, much like the directly above line. 
#i.e. polygon + polygon's symbology + borders + layout


##          Creating a simple map         ##
#tm_shape() = used to call the shapefile
#tm_fill() = used to enter parameters that det. how polygons are filled in the graphic

# Creates a simple choropleth map of our qualification variable
tm_shape(OA.Census) + tm_fill("Qualification")   #the default is a shitty visual for some reason
tm_shape(OA.Census) + tm_fill("Qualification")+ tm_layout(frame.lwd = 1 ,legend.outside.size = 0.5, legend.outside.position = "left", legend.outside = TRUE)
?tm_shape
?tm_layout
?tm_legend
tm_shape(OA.Census) + tm_fill("Qualification")+ tm_layout(legend.height = 0.3, legend.width = 0.5)

#adv. of this method over qtm() is the range of customisation options.

##      Setting the color palette       ##
library(RColorBrewer)
?display.brewer.all() 
display.brewer.all()  #shows a range of previously defined colour ramps

#If you enter a minus sign before the name of the ramp within the brackets (i.e. -Greens), you will invert the order of the colour ramp, i.e. instead of light to dark, it goes the other way
tm_shape(OA.Census) + tm_fill("Qualification", palette = "Greens")
tm_shape(OA.Census) + tm_fill("Qualification", palette = "-Greens") + tm_layout(legend.height = 0.4, legend.width = 0.5)

##        Setting the color intervals       ##
# changing the intervals
tm_shape(OA.Census) + tm_fill("Qualification", style = "equal", palette = "Reds") + tm_layout(legend.height = 0.4, legend.width = 0.5)
tm_shape(OA.Census) + tm_fill("Qualification", style = "pretty", palette = "Reds") + tm_layout(legend.height = 0.4, legend.width = 0.5)
tm_shape(OA.Census) + tm_fill("Qualification", style = "quantile", palette = "Reds") + tm_layout(legend.height = 0.4, legend.width = 0.5)
tm_shape(OA.Census) + tm_fill("Qualification", style = "jenks", palette = "Reds") + tm_layout(legend.height = 0.4, legend.width = 0.5)
tm_shape(OA.Census) + tm_fill("Qualification", style = "Cat", palette = "Reds") + tm_layout(legend.height = 0.4, legend.width = 0.5)
#"Cat" style only works with Categorical data i.e.  when data is not continuous

#We can also chnge the no. of intervals in the color scheme and how they are spaced

# number of levels - i.e. stratification of legend values
tm_shape(OA.Census) + tm_fill("Qualification", style = "quantile", n = 7,
                              palette = "Reds") + tm_layout(legend.height = 0.5, legend.width = 0.5)

#we can also create a histogram within the legend

tm_shape(OA.Census) + tm_fill("Qualification", style = "quantile", n = 5,
                              palette = "Blues", legend.hist = TRUE) + tm_layout(legend.height = 0.4, legend.width = 1)

##    Adding Borders    ##

tm_shape(OA.Census) + tm_fill("Qualification", palette = "Reds") + tm_borders(alpha=.4)
#alpha denotes the level of transparency on a scale from 0 to 1 where 0 is completely transparent.


##   Adding a north arrow   ##

tm_shape(OA.Census) + tm_fill("Qualification", palette = "-Greens") + tm_borders(alpha = 0.5) + tm_compass()


##      Editing the layout of the map     ##

tm_shape(OA.Census) + tm_fill("Qualification", palette = "Reds", style = "pretty", title = "% with a Qualification") +
  tm_borders(alpha =.5) + tm_compass() + tm_layout(title = "Camden, London", legend.text.size = 1.1, legend.title.size = 1.4, legend.position = c("right", "top"), frame = FALSE)

##      Saving the shapefile        ##

writeOGR(OA.Census, dsn = "C:/Users/omodu/OneDrive/Documents/UK - UEL_UNICAF/Module 1 - Data Ecology/WK3/Practicing R/An Introduction to Spatial Data Analysis and Visualisation in R _ CDRC Data_files/camden census data packet",
         layer = "Census_OA_Shapefile", driver="ESRI Shapefile")
# remember writeOGR() like readOGR() doesn't work because we have no rgdal or rgeos package. we are using sf and sp

st_write(OA.Census, dsn = "C:/Users/omodu/OneDrive/Documents/UK - UEL_UNICAF/Module 1 - Data Ecology/WK3/Practicing R/An Introduction to Spatial Data Analysis and Visualisation in R _ CDRC Data_files/camden census data packet",
         layer = "Census_OA_Shapefile", driver="ESRI Shapefile")
#This works



####          MAPPING POINT DATA IN R         ####
Census.Data <- read.csv("Practical_data.csv")
library(sp)
library(sf)
?st_read
Output.Areas <- st_read(".", "Camden_oa11")
OA.Census <- merge(Output.Areas,Census.Data, by.x = "OA11CD", by.y = "OA")

##        Loading point data into R       ##
Houses <- read.csv("camdenhousesales15.csv")

#selecting columns we need
Houses <- Houses[,c(1,2,8,9)]  #comma before c() because we don't want to specify any rows("x")

# While it is possible to plot this data using the standard "plot()" func., it is not being handled as spatial data.
# 2D scatter plot
plot(Houses$oseast1m, Houses$osnrth1m, xlab = "East", ylab = "North")  #R is case sensitive!!! so "houses" won't work but "Houses" will 

#We need to assign spatial attributes to the CSV so it can be mapped properly in R

#The sp package provides classes and methods for handling spatial data.
library(sp)

#Next, we need to convert the CSV into a  SpatialPointsDataFrame.
#To do this we will need to set what the data is to be included i.e., what columns contain the x and y coordinates, and what projection system we are using.

# create a House.Points SpatialPointsDataFrame
House.Points <- SpatialPointsDataFrame(Houses[,3:4], Houses, proj4string = CRS("+init=EPSG:27700"))


##        Mapping Point data        ##
#Before we map the points, we will create a base map using the output area boundaries.
library("tmap")

# This plots a blank base map, I have set the transparency of the borders to 0.5
tm_shape(OA.Census) + tm_borders(alpha=.5)


# We can now add the points as an additional tm_shape layer in our map.
  #- creates a coloured dot map
?tm_dots
tm_shape(OA.Census) + tm_borders(alpha=.4) + tm_shape(House.Points) + tm_layout(legend.height = 0.4, legend.width = 0.5) + tm_credits("By Morgan", size = 0.7, col = "blue") + tm_dots(col = "Price", size = 0.05, scale = 1.5, palette = "Reds", style = "quantile", title = "Price Paid (GBP)")


#we can also add tm_compass() as we did previously.
tm_shape(OA.Census) + tm_borders(alpha=.4) + tm_shape(House.Points) + tm_layout(legend.text.size = 1.1, legend.title.size = 1.4, frame = FALSE) + tm_credits("By Morgan", size = 0.7, col = "blue") + tm_dots(col = "Price", size = 0.05, scale = 1.5, palette = "Purples", style = "quantile", title = "Price Paid (GBP)") + tm_compass()


##        Creating  proportional symbol maps        ##

# to do this in tmap, we replace the tm_dots() function with the tm_bubbles() function
?tm_credits
tm_shape(OA.Census) + tm_borders(alpha=.4) + tm_shape(House.Points) + tm_layout(legend.text.size = 1.1, legend.title.size = 1.4, frame = FALSE) + tm_credits("By Morgan", size = 0.7, col = "blue", align = "left", just = "left") + tm_bubbles(col = "Price", size = "Price", palette = "Blues", style = "quantile", title.col = "Price Paid (GBP)", legend.size.show= FALSE) + tm_compass()

#We can also make the polygon shapefile display one of our census variables as a choropleth map
# creates a proportional symbol map
tm_shape(OA.Census) + tm_fill("Qualification", palette = "Reds",
                              style = "quantile", title = "% Qualification") +
  tm_borders(alpha=.4) +
  tm_shape(House.Points) + tm_bubbles(size = "Price", col = "Price",
                                      palette = "Blues", style = "quantile",
                                      legend.size.show = FALSE,
                                      title.col = "Price Paid (£)",
                                      border.col = "black", border.lwd = 0.1,
                                      border.alpha = 0.1) +
  tm_layout(legend.text.size = 0.8, legend.title.size = 1.1, frame = FALSE)


##        Saving the shapefile      ##
library(sf)
library("sp")
library("rgdal")
install.packages("rgdal", type="source")
st_as_sf(House.Points, dsn = "C:/Users/omodu/OneDrive/Documents/UK - UEL_UNICAF/Module 1 - Data Ecology/WK3/Practicing R/An Introduction to Spatial Data Analysis and Visualisation in R _ CDRC Data_files/camden census data packet",
         layer = "Census_House_Sales", driver="ESRI Shapefile")
st_write(House.Points, dsn = "C:/Users/omodu/OneDrive/Documents/UK - UEL_UNICAF/Module 1 - Data Ecology/WK3/Practicing R/An Introduction to Spatial Data Analysis and Visualisation in R _ CDRC Data_files/camden census data packet",
          layer = "Census_House_Sales", driver="ESRI Shapefile")
View(House.Points)
names(House.Points)
#cant seem to write the data using st_write above, so I've come up w/ a soln to convert a copy ("Hous.points1") to a shapefile (sf), below, and then save
House.points1 <- House.Points 
House.points1 <- st_as_sf(House.points1)
st_write(House.points1, dsn = "C:/Users/omodu/OneDrive/Documents/UK - UEL_UNICAF/Module 1 - Data Ecology/WK3/Practicing R/An Introduction to Spatial Data Analysis and Visualisation in R _ CDRC Data_files/camden census data packet",
         layer = "Census_House_Sales", driver="ESRI Shapefile")
House.Points <- st_read(".", "Census_House_Sales")
Houses <- Houses[,c(1,2,8,9)]  #comma before c() because we don't want to specify any rows("x")
House.Points <- SpatialPointsDataFrame(Houses[,3:4], Houses, proj4string = CRS("+init=EPSG:27700"))



####          Using R as a GIS          ####

#Firstly, we will aim to aggregate our point data into the Output Area polygons using a point in polygon operation.
#As we are commencing a spatial operation, both files need to be projected using the same coordinate reference system. 
#In this case, we have ensured that both spatial files have been set to British National Grid (27700).
#proj4string(OA.Census) <- CRS("+init=EPSG:27700")
st_crs(OA.Census) <- CRS("+init=EPSG:27700") 
proj4string(House.Points) <- CRS("+init=EPSG:27700")      #works with SpatialPointsDataFrame
st_crs(House.Points) <- CRS("+init=EPSG:27700")        #st won't work with SpatialPointsDataFrame
#With the projections set, it is now possible to assign each house point the characteristics of the output area polygon it falls within

library(sf)
library(sp)
# point in polygon. Gives the points the attributes of the polygons that they are in
pip <- sp::over(House.Points, OA.Census, fn = NULL)  #doesn't work
?over
library(spatialEco)                         #####trying a hailmary
pip <- over(House.Points, OA.Census)  #still won't work
library(sf)

#Create a simple feature geometry (polygon) from your polygon
OA.Census1 <- st_as_sf(OA.Census)

#Create a simple feature geometry (point) from your points of interest
House.Pointssf <- st_as_sf(House.Points) %>% st_set_crs(., 27700)



View(OA.Census)
#Keep only the points inside the polygon
pip <- st_intersection(OA.Census1, House.Pointssf)
rm(kept_points)

# need to bind the census data to our original points
House.Points@data <- cbind(House.Points@data, pip)
View(House.Points@data)

# you can Check if the point is inside the polygon
st_contains(OA.Census1, House.Pointssf)

# it is now possible to plot the house prices and local unemployment rates
plot(log(House.Points@data$Price), House.Points@data$Unemployed)
?plot

#We may also want to measure the avg house prices for each OA.
#We don't need another pip operation. INSTEAD, we can reaggregate data by the OA11CD column, so every OA has one record.
#Using the aggregate() func, we can decide what numbers are returned from our house prices (i.e. mean, sum, median)

# first we aggregate the house prices by the OA11CD (OA names) column
# we ask for the mean for each OA
OA <- aggregate(House.Points@data$Price, by = list(House.Points@data$OA11CD), mean)
?aggregate
?list
# change the column names of the aggregated data
View(OA)
names(OA)
names(OA) <- c("OA11CD", "Price")
names(OA)
library(sf)
# join the aggregated data back to the OA.Census polygon
OA.Census@data <- merge(OA.Census@data, OA, by = "OA11CD", all.x = TRUE)    #doesn't work

OA.Census@data <- merge(OA.Census@data, OA, by.x = "OA11CD", by.y = "OA11CD")    #doesn't work
?merge
?`@`

#trying sth else
OA.Census3 <- merge(OA.Census, OA, by.x = "OA11CD", by.y = "OA11CD")     #gives 654 obs. no missing values
OA.Census2 <- merge(OA.Census, OA, by = "OA11CD", all.x = TRUE)     #gives 749 obs. some missing values, will use this as it is same as textbook
rm(OA.Census3)
library(tmap)
tm_shape(OA.Census2) + tm_fill(col = "Price", style = "quantile", title = "Mean House Price (£)")

#we can also now run a linear model b/w our unemployment variable and new avg house price 
lm_census <- lm(OA.Census2$Price~ OA.Census2$Unemployed)
summary(lm_census)


                              ###       Buffers       ###

#Buffering is a GIS process by which we create linear catchments for each data pt.based on dist.
#It is commonly used to det. which areas are proximal to certain objects.

library(sp)
library(sf)
library(rgeos)
#we can us the gbuffer() func.

# create 200m buffers for each house point
house_buffers <- gBuffer(House.Points, width = 200, byid = TRUE)
?gBuffer

# We can plot these in tmap
tm_shape(OA.Census2) + tm_borders() + 
tm_shape(house_buffers) + tm_borders(col = "blue") +                #won't accept tm_borders layer with spatialpolygon data frame
tm_shape(House.Points) + tm_dots(col = "red")

#trying with bubble instead
tm_shape(OA.Census2) + tm_borders() + 
  tm_shape(house_buffers) +                                       #works but not desired output as textbook
  tm_bubbles(size = "Price", col = "Price",
             palette = "Blues", style = "quantile",
             legend.size.show = FALSE,
             title.col = "Price Paid (£)",
             border.col = "black", border.lwd = 0.1,
             border.alpha = 0.1) +
  tm_shape(House.Points) + tm_dots(col = "red")

# trying sth else
tm_shape(OA.Census) + tm_borders() +
  tm_shape(house_buffers) + tm_bubbles(size = 2.5, col = NA) +     #best I can do
  tm_shape(House.Points) + tm_dots(col = "red")
?tmap
?tm_bubbles
?tm_borders

#ALSO
tm_shape(OA.Census) + tm_borders() +
  tm_shape(house_buffers) + tm_squares() +     
  tm_shape(House.Points) + tm_dots(col = "red")


                      ###       Union       ####
#We can merge all the buffers together using a process called UNion. This joins all intersecting geometries

# merges the buffers
union.buffers <- gUnaryUnion(house_buffers)
?gUnaryUnion()

# map in tmap
tm_shape(OA.Census) + tm_borders() +
  tm_shape(union.buffers) + tm_fill(col = "blue", alpha = .4) + tm_borders(col = "blue") +
  tm_shape(House.Points) + tm_dots(col = "red")


###         Adding Backing Maps         ###
#Adding backing maps is sometimes more complicated than it first seems, as each mapping provider may use a different coordinate reference system (CRS). 
#In this example, we will download backing maps from Google and project our data on to them.
library(raster)
library(dismo)
?dismo
?raster
?gmap
google3.map <- gmap("Camden, London", type = "satellite")     #doesn't work
??register_google
library(ggmap)
library(tmap)
register_google(key = "AIzaSyDFzoSU71RIWDyWKGuLQjLyrXOP9hTcpto")
mygoogle_key = "AIzaSyDFzoSU71RIWDyWKGuLQjLyrXOP9hTcpto"
google.map <- get_map(location = c(-0.159445, 51.542780), maptype = "satellite", zoom = 4)       
#latitude and longitude should be switched after copying from google maps (so those numbers are longitude AND latitude copied from a web map of camden)
cam <- ggmap(google.map)
cam                           #sweet!
plot(google.map)
google2.map <- get_map(location = c(-0.159445, 51.542780), maptype = "satellite", zoom = 13) #perfect size, and what I want too (compares well with textbook)
cam2 <- ggmap(google2.map)
cam2


google3.map <- gmap(x="Camden, London", type = 'satellite', scale = 2, zoom = NULL, size=c(640, 640), lonlat = TRUE, map_key = 'AIzaSyDFzoSU71RIWDyWKGuLQjLyrXOP9hTcpto', geocode_key = mygoogle_key)
plot(google3.map)


#save the map
google.map <- get_map(location = c(-0.159445, 51.542780), maptype = "satellite", zoom = 13, filename = "Camden1.gmap") 
google2.map <- get_map(location = c(-0.1618324419716031, 51.54855129110927), maptype = "satellite", zoom = 13, filename = "Camden2.gmap")
google3.map <- gmap(x="Camden, London", type = 'satellite', scale = 2, zoom = NULL, size=c(640, 640), lonlat = TRUE, map_key = 'AIzaSyDFzoSU71RIWDyWKGuLQjLyrXOP9hTcpto', geocode_key = mygoogle_key, filename = "Camden3.gmap")

 

#Next we want to plot our house points on to this map. 
#However, our house data is projected via the British National Grid coordinate system, while Google uses the web Mercator projection
#THEREFORE

# We convert points first
CRS.new <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
reprojected.houses <-spTransform(House.Points, CRS.new)

#we can now map both base map and reprojected house pts in  tmap. 
#we need to treat the backing map as a raster image
?ggmap
# maps the base and reprojected house points in tmap 
google2.map <-`as<-`(tm_raster(col = NA))
tm_shape(google2.map) + tm_raster() + 
tm_shape(reprojected.houses) + tm_dots(col = "Price", style = "quantile",
                                       scale = 2.5, palette = "Greens",
                                       title = "House Prices (£)",
                                       border.col = "black",
                                       border.lwd = 0.1,
                                       border.alpha = 0.4) +
  tm_layout(legend.position = c("left", "bottom"), legend.text.size = 1.1,
            legend.title.size = 1.4, frame = FALSE,
            legend.bg.color = "white", legend.bg.alpha = 0.5)         #finally works -ish

#tm_shape(google2.map) + tm_raster()
?tm_basemap
cam2
 tm_shape(reprojected.houses) + tm_dots(col = "Price", style = "quantile",
                                         scale = 2.5, palette = "Reds",
                                         title = "House Prices (£)",
                                         border.col = "black",
                                         border.lwd = 0.1,
                                         border.alpha = 0.4) +
  tm_layout(legend.position = c("left", "bottom"), legend.text.size = 1.1,
            legend.title.size = 1.4, frame = FALSE,
            legend.bg.color = "white", legend.bg.alpha = 0.5)         #This just plots the dots, no background

ggmap(google2.map)
?ggmap()
#+ tm_raster()

tm_shape(google2.map) + tm_raster() + tm_shape(reprojected.houses) + tm_dots(col = "Price", style = "quantile",
                                         scale = 2.5, palette = "Reds",
                                         title = "House Prices (£)",
                                         border.col = "black",
                                         border.lwd = 0.1,
                                         border.alpha = 0.4) +
    tm_layout(legend.position = c("left", "bottom"), legend.text.size = 1.1,
              legend.title.size = 1.4, frame = FALSE,
              legend.bg.color = "white", legend.bg.alpha = 0.5)         #doesn't work

?ggmap
?ggplot

library(leaflet)
tmap_mode(c("plot","view"))
?tmap_mode
ttm()
tm_shape(House.Points) + tm_dots(title = "House Prices (£)", border.col = "black", border.lwd = 0.1, border.alpha = 0.2, col = "Price", style = "quantile", palette = "Reds") 
