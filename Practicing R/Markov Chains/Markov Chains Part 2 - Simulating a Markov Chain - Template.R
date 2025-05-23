# https://www.youtube.com/watch?v=OKCx0carr6E

par(col.axis = 'white',col.lab = 'white',col.main = 'white',col.sub = 'white',fg = 'white',bg = 'black', lwd = 2)


# Write a function that simulates a single trajectory for a Markov chain.
# Should take as arguments: the initial state, tpm Gamma, and number of steps
# to simulate. 
MC_simulate = function(X0, Gamma, steps)   #**X0 = initial state; Gamma = one-step transition probability matrix; n = number of step
{       
 U = 1:dim(Gamma)[1]                       # U = a vector which enumerates the statse spaces
 X = rep(NA, steps + 1)                    #  steps + 1  = because we will go from initial state and keep iterating
 X[1] = X0                                 # initialise by equating first element in the vetor U (X[1]) = X0

  # we now need to mimic the mechanics of the markov chain
 #we need a loop to simulate this iterative procedure
 
 for (i in 1:steps)
 {
   X[i+1] = sample(U,1,prob = Gamma[X[i],])
 }
 return(list(X = X, time = 0:steps))
}
#?rep
# Try out an arbitrary tpm (transition probability matrix):

#?rbind

Gamma = rbind(c(0.50, 0.50,0.00),                       #makinhg our arbitrary tpm with rbind func           
              c(0.00, 0.25, 0.75),
              c(0.75, 0.00, 0.25))
Gamma

# Simulate and plot 1000 trajectories of length 11 for the above 
# starting from initial state 1

res = MC_simulate(1, Gamma, 10)        #10 steps from initail state = length 11
plot(res$X~res$time, type = 'b', ylim = c(0,4), ylab = "States (X)", xlab = "Time")
?plot
library(ggplot2)
?ggplot
?geom_point
?geom_path
?geom_line

res2 <- data.frame(res)      #no longer needed, can apply data.frame func directly as below

ggplot(data.frame(res), aes(time,X)) + 
  geom_line( colour = "red") + 
  geom_point(col="blue",size=2) + 
  ylim(0,4) + 
  xlab("Time") + 
  ylab("States (X)")

#Now we can do this for 1000 simulations instead of 1 step

windows()
par(col.axis = 'white',col.lab = 'white',col.main = 'white',col.sub = 'white',fg = 'white',bg = 'black', lwd = 2)

for (i in 1:1000) 
{res_M = MC_simulate(1, Gamma, 10)
ggplot(data.frame(res_M), aes(time,X)) + 
  geom_line( colour = "red") + 
  geom_point(col="blue",size=2) + 
  ylim(0,4) + 
  xlab("Time") + 
  ylab("States (X)")
  
}          #didn't work prolly because of ggplot

windows()
par(col.axis = 'white',col.lab = 'white',col.main = 'white',col.sub = 'white',fg = 'white',bg = 'black', lwd = 2)

for (i in 1:1000)
{
  res_M = MC_simulate(1, Gamma, 10)        
  plot(res_M$X~res_M$time, type = 'b', ylim = c(0,4), ylab = "States (X)", xlab = "Time")
}
###This works!!!