# Cvi�en�_3
# Jako prvn� si nastav�m slo�ku: > setwd("~/R/3_cv")
# Pot� budeme pracovat s knihovnou Biostrings tak i tu: library(Biostrings)
sek = readDNAStringSet('Echinosorex_gymnura_mitochondrion.fasta',format='fasta')
sek 

x = grep('CDS',names(sek)) #Vybere n�m to tam, kde jsou ty CDSka
#Ted kdy� to d�me takto names(sek)[x] tak n�m to najde, kde jsou ty CDSka

names(sek)[9]
nd1 = sek[[8]]

#Mus�me zjistit, zda protein nen� reverzni (nebo tak n�co), zjist�me to podle hv�zdi�ek(�i tak n�co)
gk = getGeneticCode('SGC1') # genetick� kod pro mitochondrii
                            #nebo gk = getGeneticCode('S2') Pro mitochondrii

ND1 = translate(nd1,genetic.code = gk)
ND1

#Absolutn� �etnost kodon�

#N�pov�da: 
# Pot�ebujeme vyj�t z tabulky gen. k�du, abychom v�d�li, kter� kod koduje jakou AMK... 
# V prvn�m ��dku jsou ty kodony, kter� koduj� ur�itou AMK a jsou to names (tak�e kdy� nech�m vypsat names(gk) 
#                                                                          tak uvid�m ty kodony)... 
# Pot�ebujeme zjistit to, kter� kodony koduj� kterou AMK,abychom je pak mohli spo��tat...
# Jak spo��tat �etnosti, konkr�tn� kodon t�eba ATC, 
# kter� budeme zjistovat, kde se nach�z� v sekvence (hlavn� d�vat pozor, abychom)
# to vyhled�vali ve spr�vn�m �tec�m r�mci
#
# Nastavit si jako prom�nou kodon, a ten budeme vyhled�vat a ud�lat si k tomu po��tadlo
#
#  > names(alphabetFrequency(AAString()))[1:20]
#
# grep('A',gk) ... d� mi to indexy ve kter�ch se nach�z� to A (tedy Alanin)
# which(gk =='A') ...funguje stejn� jako ten grep

# matice je p��kaz matrix, kdy� ji chceme p�edefinovat, tak j� davat po�et ��dku a po�et sloupc� 

# kodon = names(gk)[1] .. nen� DNAString, je to chart, mus�me to p�ekodovat na DNAString, jinak to nebudem moc porovnat s 
# nd1[4:6]== kodon -> nejde
# mus�me to p�ekodovat! -> nd1[4:6]== DNAString(kodon)

# �koly: 
# V sekvenci nal�st kodony koduj�c�  a spo��tat kolikr�t se v sekvenci vyskytne: 

#sek = readDNAStringSet('Echinosorex_gymnura_mitochondrion.fasta', format = 'fasta')
DNAString('AACAACAAC')
gk = getGeneticCode('SGC1') # genetick� kod pro mitochondrii

Cetnost_Kodonu <- function(sek,gk){
  pom = matrix(rep(0,120),20,6)  #Pomocn� matice (po��tadlo)
  a = grep('CDS',names(sek))
  pom_a = names(sek)[a[1]]  
  nd1 = sek[[pom_a]]        #Vybran� CDSka - ted pouze jen ty koduj�c� �seky ze sekvence

  for (o in 1:20){
    x = grep(names(alphabetFrequency(AAString()))[o],gk) #Indexy, ve kter�ch se nach�z� ur�it� AMK (p�. alanin)
    kodony = names(gk)[x] #Kodony k�duj�c� definovanou AMK (p�. alanin)
      for (m in 1:length(kodony)){
        pom_kodon = kodony[m]
        for (n in 1:(length(nd1)-2)){   #Pro ka�d� triplet si spo��t�m, kolikr�t se v sekvenci nach�z�
          if (nd1[n:(n+2)] == DNAString(pom_kodon)){
          pom[o,m] = pom[o,m] + 1
          }
        }
      }
  }
  print(pom) #V�sledek absolutn� �etnosti kodon�
}



#Verze od Maderankove
CetnostKodonu <- function(sek,gkind){
  #priklad volani CetnostKodonu(DNAString('AACAACAAC'),'1')
  
  nac = matrix(rep(0,120),nrow=20)
  map = getGeneticCode(gkind)
  amk <- names(alphabetFrequency(AAString('')))[1:20]
  
  for (A in 1:20) {
    kodony = names(which(map==amk[A]))
    L = length(kodony)
    for (k in 1:L) {
      pom = seq(from=1,to=(length(sek)-2),by=3)
      for (r in pom) {
        if (sek[r:(r+2)]==DNAString(kodony[k])) {
          nac[A,k] = nac[A,k]+1
        }
      }
    }
  }
  return(nac)
}



