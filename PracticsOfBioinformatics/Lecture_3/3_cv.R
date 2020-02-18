# Cvièení_3
# Jako první si nastavím složku: > setwd("~/R/3_cv")
# Poté budeme pracovat s knihovnou Biostrings tak i tu: library(Biostrings)
sek = readDNAStringSet('Echinosorex_gymnura_mitochondrion.fasta',format='fasta')
sek 

x = grep('CDS',names(sek)) #Vybere nám to tam, kde jsou ty CDSka
#Ted když to dáme takto names(sek)[x] tak nám to najde, kde jsou ty CDSka

names(sek)[9]
nd1 = sek[[8]]

#Musíme zjistit, zda protein není reverzni (nebo tak nìco), zjistíme to podle hvìzdièek(èi tak nìco)
gk = getGeneticCode('SGC1') # genetický kod pro mitochondrii
                            #nebo gk = getGeneticCode('S2') Pro mitochondrii

ND1 = translate(nd1,genetic.code = gk)
ND1

#Absolutní èetnost kodonù

#Nápovìda: 
# Potøebujeme vyjít z tabulky gen. kódu, abychom vìdìli, který kod koduje jakou AMK... 
# V prvním øádku jsou ty kodony, které kodují urèitou AMK a jsou to names (takže když nechám vypsat names(gk) 
#                                                                          tak uvidím ty kodony)... 
# Potøebujeme zjistit to, které kodony kodují kterou AMK,abychom je pak mohli spoèítat...
# Jak spoèítat èetnosti, konkrétní kodon tøeba ATC, 
# který budeme zjistovat, kde se nachází v sekvence (hlavnì dávat pozor, abychom)
# to vyhledávali ve správném ètecím rámci
#
# Nastavit si jako promìnou kodon, a ten budeme vyhledávat a udìlat si k tomu poèítadlo
#
#  > names(alphabetFrequency(AAString()))[1:20]
#
# grep('A',gk) ... dá mi to indexy ve kterých se nachází to A (tedy Alanin)
# which(gk =='A') ...funguje stejnì jako ten grep

# matice je pøíkaz matrix, když ji chceme pøedefinovat, tak jí davat poèet øádku a poèet sloupcù 

# kodon = names(gk)[1] .. není DNAString, je to chart, musíme to pøekodovat na DNAString, jinak to nebudem moc porovnat s 
# nd1[4:6]== kodon -> nejde
# musíme to pøekodovat! -> nd1[4:6]== DNAString(kodon)

# Úkoly: 
# V sekvenci nalést kodony kodující  a spoèítat kolikrát se v sekvenci vyskytne: 

#sek = readDNAStringSet('Echinosorex_gymnura_mitochondrion.fasta', format = 'fasta')
DNAString('AACAACAAC')
gk = getGeneticCode('SGC1') # genetický kod pro mitochondrii

Cetnost_Kodonu <- function(sek,gk){
  pom = matrix(rep(0,120),20,6)  #Pomocná matice (poèítadlo)
  a = grep('CDS',names(sek))
  pom_a = names(sek)[a[1]]  
  nd1 = sek[[pom_a]]        #Vybrané CDSka - ted pouze jen ty kodující úseky ze sekvence

  for (o in 1:20){
    x = grep(names(alphabetFrequency(AAString()))[o],gk) #Indexy, ve kterých se nachází urèitá AMK (pø. alanin)
    kodony = names(gk)[x] #Kodony kódující definovanou AMK (pø. alanin)
      for (m in 1:length(kodony)){
        pom_kodon = kodony[m]
        for (n in 1:(length(nd1)-2)){   #Pro každý triplet si spoèítám, kolikrát se v sekvenci nachází
          if (nd1[n:(n+2)] == DNAString(pom_kodon)){
          pom[o,m] = pom[o,m] + 1
          }
        }
      }
  }
  print(pom) #Výsledek absolutní èetnosti kodonù
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



