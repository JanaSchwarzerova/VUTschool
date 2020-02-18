
# Nezapomenout nastavit cestu ("~/R/5_cv")

# Cvièení  5
# Dynamické programování - afinní penalizace mezer

 #sekvence zadané klasicky dnaString - potøebujeme knihovnu BioString !!!
  ## Poté budeme pracovat s knihovnou Biostrings tak i tu: library(Biostrings)


library(Biostrings)


 #Pozn. musíme si matice pøeddefinovat nulami 

#Stejný pøíklad, který byl na tabuli *************************************************************************************
sek1 = DNAString('AGCCTA')
sek2 = DNAString('AGA')
pom = c(5,1,-5,-2) # match = 5
                   # mismatch = 1
                   # alfa = -5
                   # beta = -2
Globalni_mezery(sek2,sek1,pom)



#*******************************************************************************************
Globalni_mezery <- function(sek1,sek2,D){
  
  match <- D[1] #shoda znaku
  mismatch <- D[2] #neshoda znaku
  gap_o <- D[3] #otevreni mezery
  gap_e <- D[4] #prodlouzeni mezery
  
  m <- length(sek1)
  n <- length(sek2)
  
  #preddefinice matic
  S <- matrix(0,nrow=(m+1),ncol=(n+1))
  S[2:(m+1),1] <- -1*(abs(gap_o)+abs(gap_e)*(1:m))
  S[1,2:(n+1)] <- -1*(abs(gap_o)+abs(gap_e)*(1:n))
  
  I <- matrix(0,nrow=(m+1),ncol=(n+1))
  I[2:(m+1),1] <- -Inf
  I[1,2:(n+1)] <- NA
  
  D <- matrix(0,nrow=(m+1),ncol=(n+1))
  D[2:(m+1),1] <- NA
  D[1,2:(n+1)] <- -Inf
  
  
  #vypocet matic
  for (i in 2:(m+1)){
    for (j in 2:(n+1)){
      if (sek1[i-1]==sek2[j-1]){pom <- match} else {pom <- mismatch }
      D[i,j] <- max(c(D[(i-1),j]-abs(gap_e), S[(i-1),j]-abs(gap_o)-abs(gap_e)))
      I[i,j] <- max(c(I[i,(j-1)]-abs(gap_e), S[i,(j-1)]-abs(gap_o)-abs(gap_e)))
      S[i,j] <- max(c(D[i,j], I[i,j], S[(i-1),(j-1)]+pom))
    }
  }
  
  print('S')
  print(S)
  print('I')
  print(I)
  print('D')
  print(D)
  
  #zpetna cesta
  
  M <- c(S[i,j],I[i,j],D[i,j]) #posledni prvky matic
  m <- which.max(M) #ktery je maximalni
  M <- M[m[1]]
  
  #preddefinice vysledku
  align1 <- DNAString()
  align2 <- DNAString()
  
  while (1) {#nekonecny cyklus
    
    #ukoncovaci podminka
    if (i == 1 && j == 1) { #jsme v levem hornim rohu
      align <- c(DNAStringSet(align1),DNAStringSet(align2))
      return(align) }
    else if (i==1) { #jsme v prvnim radku a musime dojit az k prvnimu prvku
      for (k in j:2) {
        align1 <- c(DNAString('-'), align1)
        align2 <- c(sek2[k-1], align2) }
      align <- c(DNAStringSet(align1),DNAStringSet(align2))
      return(align)
    }
    else if (j==1) { #jsme v prvnim sloupci a musime dojit az k prvnimu prvku
      for (k in i:2) {
        align1 <- c(sek1[k-1], align1)
        align2 <- c(DNAString('-'), align2)}
      align <- c(DNAStringSet(align1),DNAStringSet(align2))
      return(align)
    }
    
    #shodne/neshodne znaky
    if (sek1[i-1]==sek2[j-1]){
      pom <- match }
    else {pom <- mismatch }
    
    #jsme nekde v matici S
    if (m==1) {
      if (M==(S[i-1,j-1]+pom)) { #diagonala v S, zustavame v S
        align1 <- c(sek1[i-1], align1)
        align2 <- c(sek2[j-1], align2)
        M <- S[i-1,j-1]
        m <- 1
        i <- i-1
        j <- j-1 }
      else if (M==I[i,j]) { #presun z S do I
        M <- I[i,j]
        m <- 2 }
      else if (M==D[i,j]) { #presun z S do D
        M <- D[i,j]
        m <- 3 }
    }
    
    #jsme nekde v matici I
    else if (m==2) {
      if (M==(S[i,j-1]+gap_o+gap_e)) { #hodnota prisla z S, presun z I do S
        align1 <- c(DNAString('-'), align1)
        align2 <- c(sek2[j-1], align2)
        M <- S[i,j-1]
        m <- 1
        j <- j-1 }
      else { #zustavame v I
        align1 <- c(DNAString('-'), align1)
        align2 <- c(sek2[j-1], align2)
        M <- I[i,j-1]
        m <- 2
        j <- j-1 }
    }
    
    #jsme v matici D
    else if (m==3) {
      if (M==(S[i-1,j]+gap_o+gap_e)) { #hodnota prisla z S, presun z D do S
        align1 <- c(sek1[i-1], align1)
        align2 <- c(DNAString('-'), align2)
        M <- S[i-1,j]
        m <- 1
        i <- i-1 }
      else { #zustavame v D
        align1 <- c(sek1[i-1], align1)
        align2 <- c(DNAString('-'), align2)
        M <- D[i-1,j]
        m <- 3
        i <- i-1
      }
    }
  }
}