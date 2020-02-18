Globalni_mezery <- function(sek2,sek1,pom){
  
  # sek1 ; sek2 .. sekvence, které zarovnáváme
  # pom jsou zadáné match, mismatch, alfa a beta;
  # pø. 
  # pom = c(5,1,-5,-2) # match = 5
                       # mismatch = 1
                       # alfa = -5
                       # beta = -2
  match = pom[1]
  mismatch =  pom[2]
  alfa = pom[3]
  beta = pom[4]
  
  delka_sek1 = length(sek1)
  delka_sek2 = length(sek2)
  
  sek2_matice = delka_sek2 + 1
  sek1_matice = delka_sek1 + 1
  
  D = matrix(data =rep(0), sek2_matice, sek1_matice)
  I = matrix(data =rep(0), sek2_matice, sek1_matice)
  S = matrix(data =rep(0), sek2_matice, sek1_matice)
  
  D[1,2:sek1_matice] = c(rep(-Inf))
  I[2:sek2_matice,1] = c(rep(-Inf))
  
  pom_alfa_beta = alfa + beta
  for (k in 2:sek2_matice){
    S[k,1] = pom_alfa_beta 
    pom_alfa_beta = pom_alfa_beta + beta
  }

  pom_alfa_beta = alfa + beta
  for (k in 2:sek1_matice){
   S[1,k] = pom_alfa_beta
   pom_alfa_beta = pom_alfa_beta + beta
  }

  
  #Pøeddefinované matice: 
  D
  I
  S
  
 for (n in 2:sek2_matice) {
  for (m in 2:sek1_matice){
    D[m,n] = max(D[m-1,n]-beta,S[m-1,n]-alfa-beta)
    I[m,n] = max(I[m,n-1]-beta,S[m,n-1]-alfa-beta)
    if (sek1[n]==sek2[m]){
    sigma = match  
    }else{
    sigma = mismatch  
    }
    S[m,n] = max(D[m,n],I[m,n],S[m-1,n-1]+sigma)
  }  
 }

S  

}