# https://www.youtube.com/watch?v=s4ZeRL-HeSs     #for time varying death model
# https://www.youtube.com/watch?v=9BXCl3Iwf4M     # for time varying payoff model



#let's use and adapt the death model script

n_t <- 40       #number of cycles
n_s <- 3        #number os states - healthy, diseased, dead
n_c <- 1000     #cohort size - number of people in a group being simulated over time
v_state_names <- c("Healthy", "Diseased", "Dead")
trans_mat <- array(NA_real_, 
                   dim = c(n_s, n_s, n_t),               #ist dim is the one coming from (n_s) and 2nd dim is the one we're going to (also n_s), and then we need number of cycles (remember 3D -> x, y and t)
                   dimnames = list(v_state_names, 
                                   v_state_names,
                                   cylce = 1:n_t))

trans_mat

trans_mat[2, 1, 1:n_t] <- 0                     #we know we can't go from state 2 (diseased) to state 1 (healthy) at any time point, so the third entry here for time could be 1:n_t or just left out i.e. [2, 1, ], in any case we equate to 0 for that entry
trans_mat[3, 1, ] <- 0                          #left time entry empty here s explained above
trans_mat[3, 2, ] <- 0

trans_mat[1, 2, ] <- 0.03                  #we know this from the arbirary assignment in 2_2 of this series. Also, we left time entry empty because it applies to all times
trans_mat[3, 3, ] <- 1                    # same as above. Also, dead to dead is for sure duh!

trans_mat[1, 3,  1:10] <- .01          # Prb of dying after being healthy. choosing times 1-10 (imagine that they're age) here and equating to .01 makes sense as if you're young you hve a lower prb
trans_mat[1, 3, 11:20] <- .02
trans_mat[1, 3, 21:30] <- .04
trans_mat[1, 3, 31:40] <- .08

trans_mat[2, 3, ] <- trans_mat[1, 3, ] + .04          #Prb of going from diseased to healthy is same as healthy to dead + 4% 

trans_mat  #still have NAs, ***my guess is due to having no assignments for healthy to healthy and diseased to diseased

trans_mat[2, 2, ] <- 1 - trans_mat[2, 3, ]     #P(remaining diseased) = 1 - P(dying|diseased), I'd imagine same for P(healthy), with adjustments ofcourse! -> I'd be WRONGGGG!!!!!

#trans_mat[1, 1, ] <- 1 - trans_mat[1, 3, ]   #WRONG!!!!, we need to consider both dead and diseased 

###|- How can we add up all Prb except the one we need to find out 
###|- We want to go from the healthy state and iterate over all the states we could go to and all the diff. cycles

trans_mat[1, , ]   # when we run this we see the Prob of going to each of the states, Healthy is still NA; but we see that dead increases over time 

###|- What we want to do is add up each column in the put put above but ignore NAs -> we want to find P(healthy|healthy) = 1 - sum 
###|- Why? see directly below

trans_mat[1, , 40]    #run this, and get 1 line 

#Say we try to directly sum up

sum(trans_mat[1, , 40])   #output is NA

###|- What we actually want to see:

sum(trans_mat[1, , 40], na.rm = TRUE)    #works fine. However, we want something more efficient than typing so many lines of code

###|To avoid the problem above, we Use the apply() func
?apply

trans_mat[1, 1, ] <- 1 - apply(trans_mat[1, , ], 2, sum, na.rm = TRUE)  #See ?apply above. We use 2 as Margin to apply to columns -> think about it we are adding diseased values to dead values across columns

trans_mat                      #No NAs

state_membership <- array(NA_real_,
                          dim = c(n_t, n_s),
                          dimnames = list(cycle = 1:n_t, 
                                          state = v_state_names))     #we fill the arrays with NAs at the start bcos we want the first dimension to be the number of cycles and the second to be the number of states
View(state_membership)

state_membership[1,] <- c(n_c, 0, 0)  # basically row 1, col 1 is set to n_c = 1000

for (i in 2:n_t) 
{
  state_membership[i,] <- state_membership[i - 1, ] %*% trans_mat[ , , i - 1]
}
state_membership  # We use state membership to iterate to the nth step. 
                  ##|--if you look at the output, you will see that using ...
                  ####|-...state_membership[1,] <- c(n_c, 0, 0),...
                  ####|-... essentially means we are setting row 1 to be...
                  ####|-... (1000, 0, 0) accounting for cohort size.
                  ##|---When we matrix multiply by the transition matrix we...
                  ####|-...get the current output in row 1. 
                  ##|---So here, specifically, we used the for loop to ...
                  ####|-...iterate, in the first instance [row 2]...
                  ####|-... (recall: for i in 2:n_t -->ignoring row 1 which we...
                  ####|-... had set to (1000, 0, 0))
                  # So when we say state_membership[i,] <- state_membership[i - 1, ] %*% trans_mat[ , , i - 1]
                  ##|---We are saying that: for example in step 2 (row 2),...
                  ####|-...use the value of matrix multiplication of...
                  ####|-... (state_membership[i - 1, ] = state_membership[(i=2) - 1, ] = state_membership[1, ] = (1000, 0, 0)) %*% (trans_mat[ , , i - 1] = trans_mat[ , , n_t = i - 1] = trans_mat[ , , n_t = (2) - 1] = trans_mat[ , , n_t = 1] ---> basically iteration 1 of the time based tpm)
                  # From the output of the trans_mat(tpm) we can see that the 1st row corresponds to (.96, .03, .01)
                  # so when we matrix multiply (1000, 0, 0) %*% (tpm at n_t = 1), we get the 2nd row of the state_membership = (960, 30, 10)



#We can show in a plot
?matplot

matplot(1:n_t, state_membership, type = "l")

#Now we need to apply some payoffs for this model

payoffs <- array(NA_real_,
                   dim = c(n_s, 2, n_t),                 #recall, its 3D, so we consider the states (x1 to x3), two (2) pay offs, "cost" , and "QALY" (y1 and y2), and number of steps (t1 to t40)   
                   dimnames = list(state = v_state_names, 
                                   payoff = c("Cost", "QALY"),
                                   cycle = 1:n_t))

payoffs

#Now lest fill in the NAs in the payoff matrices (1:n_t)

payoffs[ , , 1:10] <- c(10, 800, 0, .95, .65, .00) # so we're filling arrays for cycles 1:10, by column. e.g., the cost of healthy is 10, diseased is 800, dead is 0, the Qualy for healthy is .95, diseased is .65, dead is 0
payoffs[ , , 11:20] <- c(25, 1000, 0, .92, .60, .00)
payoffs[ , , 21:30] <- c(40, 1200, 0, .88, .55, .00)
payoffs[ , , 31:40] <- c(80, 1000, 0, .85, .50, .00)


#Now for the pay off trace

payoff_trace <- array(NA_real_,
                      dim = c(n_t, 2),
                      dimnames = list(cycle = 1:n_t,
                                      payoff = c("Cost", "QALY"))) 
  
  
payoff_trace


#Lets fill it up iteratively with the for loop

for (i in 1:n_t) {
  payoff_trace[i, ] <- state_membership[i, ] %*% payoffs[ , , i]
}

payoff_trace



#We can do another plot

matplot(1:n_t, payoff_trace, type = "l", xlab = "Time (steps)", ylab = "Pay off trace")

#QALYs look like a str8 line because they are much smaller and belong on a sparate scale

plot(1:n_t, payoff_trace[ , 2])

#final steps

colSums(payoff_trace)/n_c       #for avg cost and QALY
