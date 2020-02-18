# 4_cvièení

# TEORIE *****************************************************************************************************************
#TSS ... transkription start side; trojice, kde zaèíná transkripce, ještì pøed ATG (Mají eukaryota)
#TTS ... transkription termination side; na konci za STOP kodonem (STOP kodon mùže chybìt, ale TTS nechybí)
#UTR ... nepøekládaná oblast, nìjaká èást(krátká oblast která se vystøihuje) za star kodonem a pøed stop kodonem 
#Star kodon ... pro rùzné genetické kódy jsou rùzné
#Stop kodon ... ve vìtšinì pøípadu je, ale má dost vyjímek tøeba u eukaryot nebývá

#CDS je pouze jen to kódující, není tam žádná èást navíc X Exon není jen kodující èást 
#Oblast regulaèní .. øíká kdy se bude dít translakce, kdy transkripce atd.
#Promotor ... má dvì vazebné místa; -35bp (záporný èíslo, øíká, že je to pøed kódující oblastí) 

#Takže krom toho, že se vyhladává v eukaryotách START a STOP kodon
# Mám tøeba tuto sekvenci 
# A A/TG A/TC CTA TGA CA     ("první TGA nejde pokraèovat <-")
# Jako první si najdu STOP kodon TGA
# Ted hledám Startovací kodon, tím, že jdu po ètecím rámci od STOP kodonu do pøedu a hledám ATG  <-

#U EUKARYOT
# První je STRAT kodon .. pak mùže být STOP kodon 
# není problém urèit START a STOP kodon, problém je urèit kodovací kodony uvnitø
# Problém je i ten,že se geny mohou pøekrývat, což bývá u bakterií -> že máme jeden gen v jednom ètecím rámci a ve druhém 
# druhy gen

#Mitochondriální genom 
# vypadá tak nìjak kruhovì má 13 kódujících oblastí a .... dohromady 37 kódujících oblastí

# E hodnota je statistická hodnota, jak je vysoká pravdìpodobnost... 0 nejde o náhodnou zmìnu  BACHA BLÍŽÍ SE STÁTNICE 3:)

#*************************************************************************************************************************

# Praktická èást *********************************************************************************************************

#První vìc naèíst si správnou složku 
setwd("~/R/4_cv")

#Dále NEZAPOMENOUT naèíst si knihovnu 
library('Biostrings')

#Naèíst si stažené sekvence
sek1 = readDNAStringSet('all_Echinosorex_gymnura_mitochondrion.FASTA')
sek2 = readDNAStringSet('all _Terebratalia transversa mitochondrion.FASTA')

# Zvolím si libovolnì, které chci 
orf1 = sek1[[4]]
orf2 = sek2[[12]]

#Zarovnávání 

#První potøebujeme substituèní matici
nucmat = nucleotideSubstitutionMatrix(match = 5, mismatch = 4, baseOnly = T, type = 'DNA')
nucmat
#Zarovnáme
align = pairwiseAlignment(orf1,orf2,substitutionMatrix = nucmat, gapOpening = 10, gapExtension = 4, type = 'global')
align 

# Pøevedení na proteiny a zarovnání proteinù
data('BLOSUM62')  #Potøebujeme matici na proteiny
gk = getGeneticCode('SGC1') #Potøebujeme si naèíst správný genetický kód 
prot1 = translate(orf1,genetic.code = gk)
prot2 = translate(orf2,genetic.code = gk)
align = pairwiseAlignment(prot1, prot2, substitutionMatrix = BLOSUM62, gapOpening = 10, gapExtension = 4, type='global')

# Výpoèet skóre zarovnání 
L = length(sek2)
sc = rep(0,L)  #Pøeddefinuji si matici, do které následnì dosazuji skore
for (k in 1:L){
  orf2 = sek2[[k]]
  align = pairwiseAlignment(orf1,orf2,substitutionMatrix = nucmat, gapOpening = 10, gapExtension = 4, type = 'global')
  sc[k] = score(align) #Výsledná matice skóre
}
#**********************************************************************************************************************

#*********************************************************************************************************************
# ÚKOL ****************************************************************************************************************
# Zadání: 
# Vytvoøte funkci, která v zadané sekvenci (vstupní parametr funkce), najde exony.
# Doporuèený postup:
# 1) Sekvence je rozdìlena na úseky konèící na stop kodon 
#    (berte v úvahu všechny tøi stop kodony standartního genetického kódu). 
#    Subsekvence jsou uloženy v promìnné typu DNAStringSet.
# 2) Ze subsekvencí jsou odstranìny ty, které jsou kratší než 50 nukleotidù.
# 3) Ze subsekvencí jsou odstranìny ty, které neobsahují žádný start kodon. 
#    Start kodon se musí nacházet ve stejném ètecím rámci jako stop kodon.
# 4) Ze subsekvencí se odstraní nukleotidy pøed start kodonem.
# 5) Ze subsekvencí se odstraní ty, které jsou kratší než 15 kodonù.
# 6) Subsekvence (exony) se pøeloží do proteinù.
# 7) Výstupem z funkce jsou exony a proteiny.

# ****************************************NÁPOVÌDA*******************************************************************
#Vyhledání STOP kodonù

gk = getGeneticCode('SGC0')
gk

#Ukázka jak vyhledat stop kodon 
which(gk=='*') 
names(which(gk=='*')) #musíme pøetypovat na DNAStringSet =>
stopk = DNAStringSet(names(which(gk=='*')))
sek = DNAString('ATATGCAATGCCAGTGAAATAAATGCCCCAGTGAACTCATGAAAATGCCATCTCAGTGAA')
kodon = stopk[[1]]
kodon 
matchPattern(kodon,sek)
mp = matchPattern(kodon,sek)
start(mp)
end(mp)             # Vlastnì nalezneme sekvenci  
                    # end(mp) = 22 proto, z toho vybírám následnì tuto subsekvenci:
subsek = DNAString()
subsek = c(subsek, DNAStringSet(sek[1:22]))

#Zbytek po celoèíselném dìlení:   17%%3
#********************************************************************************************************************

# 1) Sekvence je rozdìlena na úseky konèící na stop kodon 

#Naètení sekvence
sek = DNAString('ATATGCAATGCCAGTGAAATAAATGCCCCAGTGAACTCATGAAAATGCCATCTCAGTGAA')

gk = getGeneticCode('SGC0')
stopk = DNAStringSet(names(which(gk=='*'))) #všechny tøi stop kodony standartního genetického kódu

N = length(stopk)

for (n in 1:N) {
  kodon = stopk[[n]] #Pro první, druhý... až n-tý stop kodon
  mp = matchPattern(kodon,sek)
  subsek = DNAString()
  M = length(mp)
  for (m in 1:M) {
  end_sek = end(mp)
  pom_end = end_sek[m]
  subsek = DNAString()
  subsek = c(subsek, DNAStringSet(sek[1:pom_end])) 
  subsek
  }
}


#***********************************************************************************
#funkce pro nalezení ORF
FindORF = function(sek,ind_gk){
  #priklad volani
  #FindORF(DNAString('ATATGCACCAATGCCAGTGAAATAATCAATGCCCCAGTGAACTCATGAAAATGCCATCTCAGTGAA'),'SGC0')

  gk = getGeneticCode(ind_gk) #nacteni genetickeho kodu
  stopk = DNAStringSet(names(which(gk=='*'))) #nalezeni stop kodonu pro zadany geneticky kod
  kodon_end = c() #prazdny vektor pro indexy pozice kodonu
  
  
  for (k in 1:length(stopk)){ #vyhledani jednotlivych stop kodonu
    mp = matchPattern(stopk[[k]],sek)
    kodon_end = c(kodon_end,end(mp)) #koncove indexy stop kodunu se pripoji k predchozim
  }
  kodon_end = sort(kodon_end) #setrideni indexu stop kodonu
  
  ind = 1
  subsek = DNAStringSet() #prazdny vektor subsekvenci
  for (k in 1:length(kodon_end)){
    subsek = c(subsek,DNAStringSet(sek[ind:kodon_end[k]])) #vybirani subsekvenci
    ind = kodon_end[k]+1
  }
  
  for (k in 1:length(subsek)){ #odstaneni pocatecnich indexu aby odpovidal cteci ramec
    W = width(subsek[k])
    pom = W%%3
    subsek[k] = DNAStringSet(subsek[[k]][(pom+1):W])
  }
  
  #filtrovani prilis kratkych sekvenci
  pom = width(subsek)
  subsek = subsek[which(pom>=9)] #sekvence majici alespon 3 kodony
  
  
  #nalezeni nejblizsiho start kodonu
  startk = DNAString('ATG')
  for (k in 1:length(subsek)){
    pomsek = subsek[[k]]
    ind = seq(from=1,to=(length(pomsek)-5),by=3) #-5 = neberu v potaz stop kodon a 2 nukleotidy pred nim
    for (r in ind){
      kodon = pomsek[r:(r+2)]
      if (kodon==startk){
        ind_start=r
        break #nalezeni pozice start kodonu a cyklus pro r predcasne konci
      }
    }
    if (ind_start>1){
      subsek[k]=DNAStringSet(pomsek[-(1:(ind_start-1))]) #ze sekvence odstranim nukleotidy pred start kodonem
    }
  }
  
  return(subsek)
}