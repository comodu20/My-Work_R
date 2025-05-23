#####       imp. R stuff from Intro to R book by crawley        #####

# remove everything in the object window
rm(list = ls())

# shows how to cite the R software in your written work
citation()

# find function tells you what package something is in:
  
find("lowess")

# while apropos returns a character vector giving the names of all objects in the search list that match your (potentially partial) enquiry:

apropos("lm")

# installing some packages used here
install.packages("akima")
install.packages("boot")
install.packages("car")
install.packages("lme4")
install.packages("meta")
install.packages("mgcv")
install.packages("nlme")
install.packages("deSolve")
install.packages("R2jags")
install.packages("RColorBrewer")
install.packages("RODBC")
install.packages("rpart")
install.packages("spatstat")
install.packages("spdep")
install.packages("tree")

####    Data editor       ####
# There is a data editor within R that can be accessed from the menu bar by selecting Edit/Data editor . . . .
# You provide the name of the matrix or dataframe containing the material you want to edit (this has to be a dataframe that is active in the current R session, rather than one which is stored on file), and a Data
# Editor window appears. Alternatively, you can do this from the command line using the fix function (e.g. fix(data.frame.name)).

# Suppose you want to edit the bacteria dataframe which is part of the MASS                                                                                                     
library:
library(MASS)
attach(bacteria)
fix(bacteria)
rm(bacteria)

# The window has the look of a spreadsheet, and you can change the contents of the cells, navigating with the cursor or with the arrow keys.

# Suppose we want to know the integer part of a division: say, how many 13s in 119 ( the Integer Quotient)
119 %/% 13

# Modulo is very useful for testing whether numbers are odd or even: ODD numbers have modulo 2 value 1 and EVEN numbers have modulo 2 value 0:
  9 %% 2

8 %% 2

# Likewise, you use modulo to test if one number is an exact multiple of some other number. For instance, to find out whether 15421 is a multiple of 7 (which it is), then ask:
  15421 %% 7 == 0
  
####        INTEGERS          #####
  
# Integer vectors exist so that data can be passed to C or Fortran code which expects them, and so that small integer data can be represented exactly and compactly. 
# The range of integers is from −2 000 000 000 to + 2 000 000 000 (-2*10ˆ9 to +2*10ˆ9, which R could portray as -2e+09 to 2e+09).
# Be careful. Do not try to change the class of a vector by using the integer function. 
# Here is a numeric vector of whole numbers that you want to convert into a vector of integers:

x <- c(5,3,7,8)
is.integer(x)
is.numeric(x)

# Applying the integer function to it replaces all your numbers with zeros; definitely not what you intended.

x <- integer(x)  #won't even let you, "Error in integer(x) : invalid 'length' argument"


# Make the numeric object first, then convert the object to integer using the as.integer function like this:

x <- c(5,3,7,8)
x <- as.integer(x)
  is.integer(x)     #now outputs "TRUE"

# The integer function works as trunc when applied to real numbers, and removes the imaginary part when applied to complex numbers:

as.integer(5.7)       #output = 5

as.integer(5.7 -3i)     #output = 5



#####       FACTORS         ######

# Factors are CATEGORICAL variables that have a fixed number of levels. A simple example of a factor might be a variable called gender with two levels: ‘female’ and ‘male’. 
# If you had three females and two males, you could create the factor like this:

gender <- factor(c("female", "male", "female", "male", "female"))

class(gender)   # gives the class of the object
mode(gender)
##|- Factors are stored internally as integers, so their mode = numeric (i.e. gender, here, has levels 1 and 2)

detach(data)

?read.table

data <- read.table("~/UK - UEL_UNICAF/Module 1 - Data Ecology/WK3-practice R/Practicing R/Intro to R - tips from crawley book/daphnia.txt",header=T)
attach(data)
head(data)
View(data)

# R imports the data with strings as text (i.e. stringsAsFactors=False). Need to make certain columns factors

data$Water <- as.factor(data$Water)
data$Detergent <- as.factor(data$Detergent)
data$Daphnia <- as.factor(data$Daphnia)


# This dataframe ("data") contains a continuous response variable ([Growth rate]) and three categorical explanatory variables ([Water], [Detergent], and [Daphnia]), all of which are Factors.

# We can check that a variable is a factor (esp. if factor levels are No.s rather than xters)

is.factor(Water)    #gives false, but txtbook says true
is.factor(Detergent)  #       """""
is.factor(Daphnia)    #       """""
is.factor(data$Water)
is.factor(data$Detergent)     #for some reason, it wants me to specify the dataframe
is.factor(data$Daphnia)
is.factor(Growth.rate)
#To discover the names and number of the factor levels, we use the levels and nlevels functions, respectively
levels(data$Water)
levels(data$Detergent)
nlevels(Detergent)
nlevels(data$Detergent)

#We can get same result as nlevels using length and levels:

length(levels(data$Detergent))

#By default, factor levels are treated in alphabetical order.
?tapply
tapply(Growth.rate,Detergent,mean)  #Output is in alphabetical order.

# (I'm going to make a copy of the dataset for this) to order it the way we want:
data1 <- data.frame(data)
data1$Detergent <- factor(data1$Detergent,levels = c("BrandB","BrandA","BrandD","BrandC"))

#Now we get the order we want:
tapply(Growth.rate,data1$Detergent,mean)



#Only == and != can be used for factors. 
#Note, also, that a factor can only be compared to another factor with an identical set of levels (not necessarily in the same ordering) or to a character vector.
#For example, you cannot ask quantitative questions about factor levels, like > or <=, even if these levels are numeric.


#Turn factor levels into numbers (integers) using the unclass function like this:
as.vector(unclass(data1$Daphnia))


#####          Logical operations       #####

TRUE == FALSE
T==F

#while you can use T for TRUE, and F for FALSE, take care that they aren't already allocated as variables.
#Here's a weird situation:

T<-0
T==FALSE     #True?
F<- 1
TRUE == F    #True?

##*****personal thought: is logical TRUE and FALSE equal to 1 and 0, respectively?

#now, of course, T is not equal to F:

T!=F     # with new theme "!" and "=" typed with no space = !=

#To be sure, ALWAYS write TRUE and FALSE in full, and NEVER use T or F as variable names


##|- Testing for equality of real numbers
##|
##|- There are international standards for carrying out floating point arithmetic, but these stds are beyond the ctrl of R. 
##|- Roughly speaking, integer arithmetic will be exact between –10E16and 10E16
##|- for fractions and other real numbers we lose accuracy because of round-off error. 
##|- This is only likely to become a real problem in practice if you have to subtract similarly sized but very large numbers. 
##|- A dramatic loss in accuracy under these circumstances is called ‘catastrophic cancellation error’. 
########|It occurs when an operation on two numbers increases relative error substantially more than it increases absolute error.
##|
##|- When programming in R, and testing whether two computed numbers are equal, it will assume that you mean ‘exactly equal’, and what that means depends upon machine precision.
##|- Most numbers are rounded to an accuracy of 53 binary digits. 
##|- Typically therefore, two floating point numbers will not reliably be equal unless they were computed by the same algorithm, and not always even then. 
##|
##|- You can see this by squaring the square root of 2: surely these values are the same?

x <- sqrt(2)
x*x == 2
#result is false. Why? - as stated above. We can also see below, that they are not the same in R

x*x - 2    #result is 4.440892e-16. not a big number, but it is not zero either. 

##|- So how do we test for equality of real numbers? The best advice is not to do it. 
##|- Try instead to use the alternatives ‘less than’ with ‘greater than or equal to’, or conversely ‘greater than’ with ‘less than or equal to’

x*x<=2    #False
x*x>=2    #True
##|
##|- Sometimes, however, you really do want to test for equality. In those circumstances, do not use double equals to test for equality 
##|- But use the all.equal function instead:
##|
##|- more exmples of the issue below:

x <- 0.3 - 0.2
y <- 0.1
x == y    #False. Again, baffling with R (not really. see explanation abt float numbers above)

#usng the func. "identical()" gives same result

identical(x,y)


##  HAVE to use all.equal func. as it allows for insignificant differences:

all.equal(x,y)        #Finally true

##|- Do not use "all.equal" directly in IF expressions. 
##|- Either use isTRUE(all.equal( ....)) or "identical" as appropriate.
##|


###     Using All.equal()

# all.equal is very useful in programming for checking that objects are as you expect them to be. 
# Where differences occur, all.equal does a useful job in describing all the differences it finds.
#in all.equal func. the argument on the left is called the target while the one on the right is called current:

a <- c("cat", "dog", "goldfish")
b<- factor(a)

all.equal(a,b)      #so a is target, and b is current

#in the output, the reason why 'current is list' in line[2] 
##|- is that factors have two attributes and these are stored as a list – namely, their levels and their class:

attributes(b)

# can also use all.euqal to obtain feedback on differences like vector lengths:

n1 <- c(1,2,3,4)
n2 <- c(1,2,3)
all.equal(n1,n2)

#also, in multiple differences....
n2 <- as.character(n2)
all.equal(n1,n2)

### Note that if you supply more than two objects to be compared, the third and subsequent objects are simply ignored.

###  Evaluation of combinations of TRUE and FALSE   ###
##|- It is important to understand how combinations of logical variables evaluate, 
##|- and to appreciate how logical operations work when there are missing values, NA. 

x <- c(NA, FALSE, TRUE)
names(x) <- as.character(x)

# To see the logical combinations of & (logical AND) we can use the outer function with x to evaluate all nine combinations of NA, FALSE and TRUE

?outer
outer(x,x,"&")
#
##|- Only TRUE & TRUE evaluates to TRUE. 
##|- Note the behaviour of NA & NA and NA & TRUE. Where one of the two components is NA, the result will be NA if the outcome is ambiguous. 
##|- Thus, NA & TRUE evaluates to NA, but NA & FALSE evaluates to FALSE. 
##|

# To see the logical combinations of | (logical OR) write:

outer(x,x,"|")
#
##|- Only FALSE | FALSE evaluates to FALSE. Note the behaviour of NA | NA and NA | FALSE.


##*****personal thought: With the logical operators & and |:
#
##* in an "&" operation = FALSE >> NA >> True ("true" is the weakest lil bitch)
##* in an "|" operation = TRUE >> NA >> FALSE ("false" is the weakest lil bitch)


###   Logical arithmetic   ###

# The key thing to understand is that logical expressions evaluate to either true or false (represented in R by TRUE or FALSE), 
##|- and that R can coerce TRUE or FALSE into numerical values: 1 for TRUE and 0 for FALSE.

rm(list = c("x","y"))
x <- 0:6

#Now, we can ask questions about the vector, x

x < 4       # The answer is yes for the first four values (0, 1, 2 and 3) and no for the last three (4, 5 and 6)

#We can use func.s "all" and "any" to check an entire vector and return a single logical value: T or F

# are ALL x values bigger than 0?

all(x>0)      #- No. The first x value is a zero

#Are ANY of the x values negative?

any(x<0)      #- No. The smallest x value is a zero

##|- We can use the ANSWERS of logical functions in arithmetic. 
##|- We can count the true values of (x<4), using sum:

sum(x<4)  #i.e. all x < 4 -> 0,1,2,3 => T,T,T,T (all less than 4) => so, 4 T's (recall, T=1, F=0)
?sum

# We can multiply (x<4) by other vectors:
?runif

runif(7)
(x<4)*runif(7)    #****personal: well, 4 values are multiplied by 1 (True), the remaining 3 random values multiply 0 (false)

(x<4)*runif(6)    #fails because mismatch in vector length

# Logical arithmetic is particularly useful in generating simplified factor levels during statistical modelling.
##|- Suppose we want to reduce a five-level factor (a, b, c, d, e) called treatment to a three-level factor called
####|- t2 by lumping together the levels a and e (new factor level 1) and c and d (new factor level 3) while leaving
#######|- b distinct (with new factor level 2):

(treatment <- letters[1:5])
ber <- letters[1:6]       #What is the significance of brackets here? diff w/ this and above is the above gives an output w/o calling (i.e. i need no further entries to see results in the above line). 
rm("ber")

(treatment=="b")  #- output: F,T,F,F,F => (0,1,0,0,0)
##|***similar output as above for (treatment=="c") => (0,0,1,0,0) and (treatment=="d")  => (0,0,0,1,0)
##|***testing cuz I'm confused:
2*(treatment=="c")    #pass => (0,0,2,0,0)
1+(treatment=="b")    #as suspected; the number "1" is read as (1,1,1,1,1). So output = (1,2,1,1,1)

factor(1+(treatment=="b")+2)        #gives output (=> (3,4,3,3,3)), and Levels (=> 3 and 4) 



(t2 <- factor(1+(treatment=="b")+2*(treatment=="c")+2*(treatment=="d")))

#output = 1 2 3 3 1; Levels = 1 2 3           #**** based on prior results, I'm a little confused


##|- The new factor t2 gets a value 1 as default for all the factors levels (due to the addition of 1 at the start), and we want to leave this as it is for levels a and e. 
##|-****testing:
(test <- letters[1:5])

(d2 <- factor((test=="b")+(test=="c")+(test=="d")))   #output = (0,1,1,1,0) -> makes sense((01000)+(00100)+(00010))

(d2 <- factor(1+(test=="b")+(test=="c")+(test=="d")))    #output = (1 2 2 2 1) -> makes sense((12111)+(00100)+(00010))

(d2 <- factor((test=="b")+2*(test=="c")+2*(test=="d")))     #output = (0 1 2 2 0) -> makes sense((01000)+(00200)+(00020))

#****maybe I see it now. The below statement is: ((11111) + (01000) + (00200) +(00020)) = (1,2,3,3,1)
(d2 <- factor(1+(test=="b")+2*(test=="c")+2*(test=="d")))
##|
##|
##|- We do not add anything to the 1 if the old factor level is a or e. 
##|- For old factor level b, however, we want the result that t2=2 so we add 1 (treatment=="b") to the original 1 to get the answer we require. 
##|- This works because the logical expression evaluates to 1 (TRUE) for every case in which the old factor level is b and to 0 (FALSE) in all other cases.
##|- For old factor levels c and d we want the result that t2=3 so we add 2 to the baseline value of 1 if the original factor level is either c (2*(treatment=="c")) or d (2*(treatment=="d"))


#####         Generating Sequences          #####

#starting simple

0:10

15:5

# To generate a sequence in steps other than 1, you use the seq function

?seq

seq(0, 1.5, 0.1)

#If the initial value is larger than the final value, the increment should be negative, like this:

seq(6, 4, -0.2)

##|- In many cases, you want to generate a sequence to match an existing vector in length. 
##|- Rather than having to figure out the increment that will get from the initial to the final value...
##|- ..... and produce a vector of exactly the appropriate length, R provides the along and length options:

#suppose you have a vector of population sizes:
N <- c(55,76,92,103,84,88,121,91,65,77,99)

length(N)

#You need to plot this against a sequence that starts at 0.04 in steps of 0.01:

seq(from = 0.04, by = 0.01, length = length(N))

#OR
seq(from = 0.04, by = 0.01, along = N)

#OR, if you already know the end value
seq(from = 0.04, to = 0.14, along = N)      #An important application of this last option is to get the x values for drawing smooth lines through a scatterplot of data using predicted values from a model 

###NOTE: when the increment does not match the final value, then the generated sequence stops....
####|- .....short of the last value (rather than overstepping it):

seq(1.4,2.1,0.3)   #output = 1.4 1.7 2.0 <-

##|- If you want a vector made up of sequences of unequal lengths, then use the sequence function. 
##|- Suppose that most of the five sequences you want to string together are from 1 to 4, but the second one is 1 to 3 and the last one is 1 to 5, then:
?sequence
?c
sequence(c(4,3,4,4,4,5)) # the concatenated sequences 1:4, 1:3, 1:4, 1:4, 1:4, and 1:5; i.e each number in c() specifies the length of the sequence

#also:
sequence(c(3, 2), from=2L)
##|- c(3, 2): A vector specifying the lengths of the individual sequences to be created. 
########|- In this case, it will create two sequences: one of length 3 and another of length 2.
##|- from=2L: An integer indicating the starting value for the sequence. All sequences will begin from 2.

#last examples:
sequence(c(3, 2), from=2L, by=2L)   #Same issues as above; but with "by" we are specifying the stepsize

sequence(nvec = c(3, 2), by=c(-1L, 1L))    # can use "by" argument with c() to specify stepsizes for each prior specified vector length in the "nvac" argument

sequence(nvec = c(3, 2), from = c(2L, 5L), by=c(-1L, 1L))   #***just me going wild with it


###     Generating Repeats

?rep

#e.g.

rep(9,5)

rep(1:4, 5)

rep(1:4, each = 2)

rep(1:4, each = 5)

rep(1:4, each = 2, times = 3)

#also

rep(1:4, 1:4)     #i.e. rep 1 to 4, each = 1:4 => repeat 1 once, 2 twice, 3 thrice and so on.
#HOWEVER, second argument must have same length as array in first argument

#we can also, use a vector of the specific times we need repititions:

rep(1:4,c(4,3,5,2))

#finally, most complex case:

rep(c("cat", "dog", "gerbil", "rat", "goldfish"), 1:5)

rep(c("cat", "dog", "gerbil", "rat", "goldfish"), c(2,3,2,4,1))      #most general, and useful form of the rep function.


###     Generating factor levels

#The function gl (‘generate levels’) is useful when you want to encode long vectors of factor levels.

?gl

gl(4,3)

gl(4,3,12)    ##output same as above, because default "length" when not entered as an argument is = n*k

gl(4,3,24)    ##so basically this gives the output at twice its normally expected lenght => n*k*2. ****I can use this knowledge to determine the multiplication factor for length


#if you want text for factor levels in place of numbers:
##|
##|
#Note the consistency in their lengths

Temp <- gl(2, 2, 24, labels = c("Low", "High"))
Soft <- gl(3, 8, 24, labels = c("Hard", "Medium", "Soft"))
M.user <- gl(2, 4, 24, labels = c("N","Y"))
Brand <- gl(2, 1, 24, labels = c("X", "M"))

data.frame(c("Temp","Soft","M.user","Brand"))     #Weird output => it was because i made them into vector w/ c()

?data.frame
data.frame(Temp, Soft, M.user, Brand)



#####        Membership: Testing and coercing in R          #####

