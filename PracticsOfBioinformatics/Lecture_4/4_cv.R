# 4_cvi�en�

# TEORIE *****************************************************************************************************************
#TSS ... transkription start side; trojice, kde za��n� transkripce, je�t� p�ed ATG (Maj� eukaryota)
#TTS ... transkription termination side; na konci za STOP kodonem (STOP kodon m��e chyb�t, ale TTS nechyb�)
#UTR ... nep�ekl�dan� oblast, n�jak� ��st(kr�tk� oblast kter� se vyst�ihuje) za star kodonem a p�ed stop kodonem 
#Star kodon ... pro r�zn� genetick� k�dy jsou r�zn�
#Stop kodon ... ve v�t�in� p��padu je, ale m� dost vyj�mek t�eba u eukaryot neb�v�

#CDS je pouze jen to k�duj�c�, nen� tam ��dn� ��st nav�c X Exon nen� jen koduj�c� ��st 
#Oblast regula�n� .. ��k� kdy se bude d�t translakce, kdy transkripce atd.
#Promotor ... m� dv� vazebn� m�sta; -35bp (z�porn� ��slo, ��k�, �e je to p�ed k�duj�c� oblast�) 

#Tak�e krom toho, �e se vyhlad�v� v eukaryot�ch START a STOP kodon
# M�m t�eba tuto sekvenci 
# A A/TG A/TC CTA TGA CA     ("prvn� TGA nejde pokra�ovat <-")
# Jako prvn� si najdu STOP kodon TGA
# Ted hled�m Startovac� kodon, t�m, �e jdu po �tec�m r�mci od STOP kodonu do p�edu a hled�m ATG  <-

#U EUKARYOT
# Prvn� je STRAT kodon .. pak m��e b�t STOP kodon 
# nen� probl�m ur�it START a STOP kodon, probl�m je ur�it kodovac� kodony uvnit�
# Probl�m je i ten,�e se geny mohou p�ekr�vat, co� b�v� u bakteri� -> �e m�me jeden gen v jednom �tec�m r�mci a ve druh�m 
# druhy gen

#Mitochondri�ln� genom 
# vypad� tak n�jak kruhov� m� 13 k�duj�c�ch oblast� a .... dohromady 37 k�duj�c�ch oblast�

# E hodnota je statistick� hodnota, jak je vysok� pravd�podobnost... 0 nejde o n�hodnou zm�nu  BACHA BL͎� SE ST�TNICE 3:)

#*************************************************************************************************************************

# Praktick� ��st *********************************************************************************************************

#Prvn� v�c na��st si spr�vnou slo�ku 
setwd("~/R/4_cv")

#D�le NEZAPOMENOUT na��st si knihovnu 
library('Biostrings')

#Na��st si sta�en� sekvence
sek1 = readDNAStringSet('all_Echinosorex_gymnura_mitochondrion.FASTA')
sek2 = readDNAStringSet('all _Terebratalia transversa mitochondrion.FASTA')

# Zvol�m si libovoln�, kter� chci 
orf1 = sek1[[4]]
orf2 = sek2[[12]]

#Zarovn�v�n� 

#Prvn� pot�ebujeme substitu�n� matici
nucmat = nucleotideSubstitutionMatrix(match = 5, mismatch = 4, baseOnly = T, type = 'DNA')
nucmat
#Zarovn�me
align = pairwiseAlignment(orf1,orf2,substitutionMatrix = nucmat, gapOpening = 10, gapExtension = 4, type = 'global')
align 

# P�eveden� na proteiny a zarovn�n� protein�
data('BLOSUM62')  #Pot�ebujeme matici na proteiny
gk = getGeneticCode('SGC1') #Pot�ebujeme si na��st spr�vn� genetick� k�d 
prot1 = translate(orf1,genetic.code = gk)
prot2 = translate(orf2,genetic.code = gk)
align = pairwiseAlignment(prot1, prot2, substitutionMatrix = BLOSUM62, gapOpening = 10, gapExtension = 4, type='global')

# V�po�et sk�re zarovn�n� 
L = length(sek2)
sc = rep(0,L)  #P�eddefinuji si matici, do kter� n�sledn� dosazuji skore
for (k in 1:L){
  orf2 = sek2[[k]]
  align = pairwiseAlignment(orf1,orf2,substitutionMatrix = nucmat, gapOpening = 10, gapExtension = 4, type = 'global')
  sc[k] = score(align) #V�sledn� matice sk�re
}
#**********************************************************************************************************************

#*********************************************************************************************************************
# �KOL ****************************************************************************************************************
# Zad�n�: 
# Vytvo�te funkci, kter� v zadan� sekvenci (vstupn� parametr funkce), najde exony.
# Doporu�en� postup:
# 1) Sekvence je rozd�lena na �seky kon��c� na stop kodon 
#    (berte v �vahu v�echny t�i stop kodony standartn�ho genetick�ho k�du). 
#    Subsekvence jsou ulo�eny v prom�nn� typu DNAStringSet.
# 2) Ze subsekvenc� jsou odstran�ny ty, kter� jsou krat�� ne� 50 nukleotid�.
# 3) Ze subsekvenc� jsou odstran�ny ty, kter� neobsahuj� ��dn� start kodon. 
#    Start kodon se mus� nach�zet ve stejn�m �tec�m r�mci jako stop kodon.
# 4) Ze subsekvenc� se odstran� nukleotidy p�ed start kodonem.
# 5) Ze subsekvenc� se odstran� ty, kter� jsou krat�� ne� 15 kodon�.
# 6) Subsekvence (exony) se p�elo�� do protein�.
# 7) V�stupem z funkce jsou exony a proteiny.

# ****************************************N�POV�DA*******************************************************************
#Vyhled�n� STOP kodon�

gk = getGeneticCode('SGC0')
gk

#Uk�zka jak vyhledat stop kodon 
which(gk=='*') 
names(which(gk=='*')) #mus�me p�etypovat na DNAStringSet =>
stopk = DNAStringSet(names(which(gk=='*')))
sek = DNAString('ATATGCAATGCCAGTGAAATAAATGCCCCAGTGAACTCATGAAAATGCCATCTCAGTGAA')
kodon = stopk[[1]]
kodon 
matchPattern(kodon,sek)
mp = matchPattern(kodon,sek)
start(mp)
end(mp)             # Vlastn� nalezneme sekvenci  
                    # end(mp) = 22 proto, z toho vyb�r�m n�sledn� tuto subsekvenci:
subsek = DNAString()
subsek = c(subsek, DNAStringSet(sek[1:22]))

#Zbytek po celo��seln�m d�len�:   17%%3
#********************************************************************************************************************

# 1) Sekvence je rozd�lena na �seky kon��c� na stop kodon 

#Na�ten� sekvence
sek = DNAString('ATATGCAATGCCAGTGAAATAAATGCCCCAGTGAACTCATGAAAATGCCATCTCAGTGAA')

gk = getGeneticCode('SGC0')
stopk = DNAStringSet(names(which(gk=='*'))) #v�echny t�i stop kodony standartn�ho genetick�ho k�du

N = length(stopk)

for (n in 1:N) {
  kodon = stopk[[n]] #Pro prvn�, druh�... a� n-t� stop kodon
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
#funkce pro nalezen� ORF
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