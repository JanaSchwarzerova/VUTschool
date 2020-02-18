#nastaveni pracovniho adresare
setwd("D:/VYUKA/APBI/APBI_2014_2015/01_cviceni")

#datove typy
a <- 1.234
b <- 2+1i
c <- F
d <- 'string'
e <- "string"

#vektory
v <- c(1,2,3,4,5) #vektor cisel
c(1,2,3,4,5) -> v #lze i opacne
assign('v',c(5,4,3,2))
y <- c(3+2i, -8-1i, 3+0i) #vektor komplexnich cisel
z <- (v<5 & v>=3) #vektor cisel splnujicich podminku
zelenina <- c('mrkev', 'zeli', 'celer') #vektor retezcu
x <- c(7, 3+1i, T, 'a') #pretypovani vektoru na retezce
s <- vector(mode='integer', length=5)
s <- vector(mode='logical', length=5)
s <- vector(mode='complex', length=5)
s <- vector(mode='character', length=5)
v <- c(5,4,3,2,1)
y <- as.vector(v,mode='character')
is.vector(y,mode='integer')
is.vector(y,mode='character')
5:15 #posloupnost cisel od:kam s krokem 1
5.1:15
sequence(5) #posloupnost cisel do zadane hodnoty s krokem 1
sequence(c(2,3))
seq(7,11) #posloupnost cisel s ruznymi parametry
seq(from=3, to=10, by=2)
seq(along.with=v)
seq(to=7, length=3)
v <- c(1,2,3)
rep(v,times=3) #replikace hodnoty nebo vektoru
rep(v,each=3)
rep(v,length=5)
runif(10,2,6) #generovani nahodnych cisel pocet, od, kam
round(runif(10,2,8))
x <- c(1,2,3,4,5,6,7,8,9,10)
sample(x,5) #nahodna permutace casti vektoru
sample(x,15,replace=T) #umoznene opakovani hodnot
x[3:5] #indexovani od:kam
x[7:11]
x[c(2,5,1,7)] #indexovani vektorem
x[0]
x[c(1,0)] #vynechava nulovy index
head(x,5) #zacatek vektoru
tail(x,3) #konec vektoru
x[-3] #vynechani prvku
x[-c(2,4,6)]
x[c(rep(T,3),T,F,rep(F,4),T)] #indexovani logickym vektorem
x[x>3 & x<=8] #podminkove indexovani
subset(x, x<5) #vybere cast vektoru, ktery odpovida podmince
length(x) #zjisteni delky vektoru
length(x)<-15 #prodlouzeni vektrou o hodnoty NA
x[11:15] <- 1:5
x[16]
x[16]<-2
length(x)<-10 #zkraceni vektoru

#matice
u <- 1:10
dim(u) <- c(2,5) #preusporadani vektoru na matici dle zadanych dimenzi
matrix(u,4,5) #vytvoreni matice o poctu radku a sloupcu
matrix(u,ncol=4) #vytvoreni matice o poctu sloupcu
matrix(u,ncol=4,byrow=T) #vytvoreni matice o postu sloupcu s usporadanim prvku podle radku
v <- matrix(u,5)
t <- matrix(u,4)
t<-as.matrix(v) #uprava matice na dimenze jine matice
is.matrix(t) #kontrola jestli je promenna typu matice
array(x,c(2,2,2)) #vytvoreni vicerozmerneho pole
nrow(t) #zjisteni poctu radku
ncol(t) #zjisteni poctu sloupcu
dim(t) #zjisteni dimenzi matice a pole
t <- u[1:2,3:4] #indexovani matice
t <- u[-c(3,4),3:4] #lze vyuzit i vynechani prvku
diag(u) #vypis diagonalnich prvku matice
u <- matrix(c(1,2,3,4),nrow=2)
v <- matrix(c(5,6,7,8),nrow=2)
u*v #prvkove nasobeni matic, matice musi mit stejny rozmer
u <- matrix(c(1,2,3,4,5,6),nrow=2)
v <- c(1,2,3)
u*v #nasobeni matice vektorem a recycling rule

#operace
1+2 #scitani
2-1 #odecitani
2*3 #nasobeni
6/3 #deleni
3^2 #umocneni
u <- matrix(c(1,2,3,4),nrow=2)
v <- matrix(c(5,6,7,8),nrow=2)
u%*%v #maticove nasobeni
11%%2 #zbytek po celociselnem deleni
11%/%2 #cela cast po celociselnem deleni
t(u) #transpozice matice
1 == 1 #rovna se
1 < 2 #mensi
2 > 1 #vetsi
2 <= 2 #mensi nebo rovno
2 >= 1 #vetsi nebo rovno
1 != 2 #neni rovno
a <- c(2,1,4,5,6)
b <- c(4,1,2,2,3)
a>=4 & b<3 #logicke AND
a>=4 | b<3 #logicke OR
!(a>=4 & b<3) #negace
all(a<7) #jestli splnuji vsechny prvky podminku
any(a==4) #splnuje alespon nektery prvek podminku
which(a==2) #ktery z prvku splnuje podminku
is.element(3,a) #patri prvek do promenne
is.element(2,a)
is.element(a,2)

#dalsi funkce
v <- c(4,7,5,12,6,48,1)
min(v) #minimum
max(v) #maximum
range(v) #rozsah
sum(v) #suma
prod(v) #produkt
abs(c(-3,2,-7,-1)) #absolutni hodnota
sqrt(9) #odmocnina
sqrt(v)
exp(2) #exponent
sort(c(-5,1,-8,45,3,2,-2,0,9)) #trideni
order(c(-5,1,-8,45,3,2,-2,0,9)) #poradi prvku
ceiling(5.3) #zaokrouhleni nahoru
floor(5.3) #zaokrouhleni dolu
round(5.3) #zaokrouhleni