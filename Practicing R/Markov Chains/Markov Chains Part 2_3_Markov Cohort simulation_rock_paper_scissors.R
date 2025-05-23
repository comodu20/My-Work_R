#https://www.youtube.com/watch?v=rwne7EpNduk

rm(list = ls())

n_t <- 20        #number of cycles
n_s <- 3         #number of states = rock, paper, scissors = 3
n_c <- 1000     #cohort size - number of people in a group being simulated over time
v_state_names <- c("Rock", "Paper", "Scissors")
tmp <- matrix(c(.205, .410, .385, .633, .200, 0.167, .400, .267, .333),
              nrow = 3, ncol = 3, byrow = TRUE,
              dimnames = list(from = v_state_names, to = v_state_names))
tmp

#check row sums if you want

rowSums(tmp)

state_membership <- array(NA_real_, dim = c(n_t, n_s), 
                          dimnames = list(cycle = 1:n_t, state = v_state_names))                          ### we start off with an array full of NAs because it makes it clear if an error is made and we've forgotten to calculate some values
state_membership

state_membership[1,] <- c(n_c, 0, 0)          # we know that in the 1st cycle, we have n_c 

#final step
for (i in 2:n_t) {
  state_membership[i,] <- state_membership[i-1,] %*% tmp
}

#Now we need to apply some payoffs for this model (we don't need this, QALY only applies to life-death models)

m_payoffs <- matrix(c(50, 1000, 0, .9, .6, 0),               #costs of the states: here we start with the three states - 50 per cycle in healthy state, 1000 per cycle in diseased,....and so on
                    nrow = 3, ncol = 2, 
                    byrow = FALSE, 
                    dimnames = list(state = v_state_names, payoff = c("Cost", "QALY")))                  
m_payoffs

payoff_trace <- state_membership %*% m_payoffs
payoff_trace


#final steps

colSums(payoff_trace)/n_c       #for avg cost and QALY
