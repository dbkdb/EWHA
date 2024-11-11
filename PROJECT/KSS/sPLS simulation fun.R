
generate_data <- function(var_H, n, p, q, p1){
  n0 <- 0
  n1 <- p1
  n2 <- 2*p1 # number of true nonzero elements of B
  n3 <- p
  
  ##latent variables(H1,H2,H3)
  library(MASS)
  H <- mvrnorm(n, mu = rep(0,3), Sigma = diag(3)*var_H)
  H1 <- H[,1]; H2 <- H[,2]; H3 <- H[,3]
  
  ##model matrix X
  X <- matrix(0, ncol = p, nrow = n)
  E <- mvrnorm(n, mu = rep(0,p), Sigma = diag(p))
  
  for(i in 1:p) {
    if (i <= n1) {
      X[,i] <- H1 + E[,i]
    }
    else if (i >= (n1+1) & i <= n2 ) {
      X[,i] <- H2 + E[,i]
    }
    else {
      X[,i] <- H3 + E[,i]
    }
  }
  
  ## response matrix Y
  
  var_f <- var_H * 2.5
  
  Y <- matrix(0, nrow = n, ncol = q)
  f <- mvrnorm(n, mu = rep(0,q), Sigma = diag(q)*var_f )
  for(i in 1:q) {
    Y[,i] <- 3*H1 - 4*H2 + f[,i]   
    
  }
  
  ## test data
  
  H <- mvrnorm(n, mu = rep(0,3), Sigma = diag(3)*var_H)
  H1 <- H[,1]; H2 <- H[,2]; H3 <- H[,3]
  X_test <- matrix(0, ncol = p, nrow = n)
  E <- mvrnorm(n, mu = rep(0,p), Sigma = diag(p))
  for(i in 1:n3) {
    if (i <= n1) {
      X_test[,i] <- H1 + E[,i]
    }
    else if (i >= (n1+1) & i <= n2 ) {
      X_test[,i] <- H2 + E[,i]
    }
    else {
      X_test[,i] <- H3 + E[,i]
    }
  }
  Y_test <- matrix(0, nrow = n, ncol = q)
  f <- mvrnorm(n, mu = rep(0,q), Sigma = diag(q)*var_f )
  for(i in 1:q) {
    Y_test[,i] <- 3*H1 - 4*H2 + f[,i]   
    
  }
  
  return(list(X = X, Y = Y, X_test = X_test, Y_test = Y_test,
              H = H))
  
}


Data_pls_1 <- generate_data(var_H, n,p,q,p1)
X <- Data_pls_1$X
X_test <- Data_pls_1$X_test
Y <- Data_pls_1$Y
Y_test <- Data_pls_1$Y_test

