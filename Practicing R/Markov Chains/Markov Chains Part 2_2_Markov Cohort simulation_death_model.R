# https://www.youtube.com/watch?v=xxtGOKLdQR0

rm(list = ls())

n_t <- 40       #number of cycles
n_s <- 3        #number os states - healthy, diseased, dead
n_c <- 1000     #cohort size - number of people in a group being simulated over time
v_state_names <- c("Healthy", "Diseased", "Dead")
tpm <- matrix(c(.96, .03, .01,                        #Matrix func. assumes by column as default, so we have to explicitly declare
                .00, .95, .05, 
                .00, .00, 1.00),
              nrow = 3, ncol = 3, 
              byrow = TRUE,
              dimnames = list(v_state_names, 
                              v_state_names)) 
tpm

state_membership <- array(NA_real_,
                          dim = c(n_t, n_s),
                          dimnames = list(cycle = 1:n_t, state = v_state_names))     #we fill the arrays with NAs at the start bcos we want the first dimension to be the number of cycles and the second to be the number of states
View(state_membership)

state_membership[1,] <- c(n_c, 0, 0)  # basically row 1, col 1 is set to n_c = 1000

for (i in 2:n_t) 
  {
  state_membership[i,] <- state_membership[i-1, ] %*% tpm                #basically this is akin to pi * matrix (A) from Markov lecture 2 (Wk3) in module 4 of UEL
}
state_membership

#Now we need to apply some payoffs for this model

m_payoffs <- matrix(c(50, 1000, 0, .9, .6, 0),               #costs of the states: here we start with the three states - 50 per cycle in healthy state, 1000 per cycle in diseased,....and so on
                    nrow = 3, ncol = 2, 
                    byrow = FALSE, 
                    dimnames = list(state = v_state_names, payoff = c("Cost", "QALY")))                  
m_payoffs

payoff_trace <- state_membership %*% m_payoffs
 payoff_trace
 
 
 #final steps
 
 colSums(payoff_trace)/n_c       #for avg cost and QALY
 