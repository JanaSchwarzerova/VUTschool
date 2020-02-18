#cvièení_1
#___________________________SEZNÁMENÍ S JAZYKEM R________________________________


a = 4
b = 5
c = b-a

if (a == 4 & b>3){
  c = a*b
} else if (a>1){
  c = a/b
}  else {c=b-a}

v = seq(from=1, to=10, by=2)
v
v = c(5,2,3,4)
    for (k in 1:10){
    a = a+k
    }

#Cyklus while
while (k<10){
b = k*a
k=k+1
}

#Cyklus repeat
repeat{
  c = a-b
  if (c>10){break}
}

#FUNKCE

Cv_1 <- function(a,b){
  c=a+b
}
            #Zadávat do Source, zaškrtnout Source on Save a uložit

# VIZ Console
# source('~/R/1_cv/cv_1.R')
# Cv_1(4,2)
# c = Cv_1(4,2)
# c

#Samostatný úkol
# Vytvoøit funkci vektoru èísel v = 3,5,2,4,1,6 a pùjde nám o to vektor setøídit 
# najít minimální hodnotu a tu pøesunout na zaèátek vektoru a tento zpùsob budeme 
# opakovat v cyklu
v = c(3,5,2,4,1,6)
serazovani <- function(v){
  vysledek = c(rep(0,length(v)))
  for (k in 1:length(v)) {
    minimum = min(v)
    pozice = which.min(v)
    vysledek[k]=minimum
    vysledek
    v=v[-pozice]
  }
  print(vysledek)
}
vysledek = serazovani(v)



#Její øešení: 
#**************************************************************************************
x = 6
Eratosthen <- function(X){
  # Eratosthenovo síto je jednoduchý algoritmus pro nalezení
  # všech prvoèísel nižších, než je daná horní mez.
  A <- rep(1,X)
  A[1] <- 0
  for (k in 1:sqrt(X)){
    if (A[k]==1){
      temp <- 2*k
      repeat {
        A[temp] <- 0
        temp <- temp+k
        if (temp>X){break}
      }
    }
  }
  for (k in 1:X){
    if (A[k]==1){print(k)}
  }
}
