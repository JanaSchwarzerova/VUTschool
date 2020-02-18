setwd('C:/Users/Jana/Desktop/Diplomová práce/data_SRA')

source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")
library(Biostrings)

source("http://www.bioconductor.org/biocLite.R")
biocLite("msa")
library(msa)
options(max.print=1000000) 

gk=getGeneticCode('SGC1')
GK=names(gk)

#2 
NC002808=readDNAStringSet('NC_002808.fasta',format = 'fasta')
NC003039=readDNAStringSet('NC_003039.fasta',format = 'fasta')
NC020141=readDNAStringSet('NC_020141.fasta',format = 'fasta')

## grep nefunguje na toto dobre tak nam M povedala si to najst manualne v nazvoch
names(NC002808)
names(NC003039)
names(NC020141)

CDS_NC_002808=NC002808[97]
CDS_NC_003039=NC003039[98]
CDS_NC_020141=NC020141[118]

CDS=c(DNAStringSet(CDS_NC_002808),DNAStringSet(CDS_NC_003039),DNAStringSet(CDS_NC_020141))
## kontrola ci to je protein kodujuci je iba translate(CDS)
translate(CDS)

matica=trinucleotideFrequency(CDS)
Freq_NC_002808=matica[1,]
Freq_NC_003039=matica[2,]
Freq_NC_020141=matica[3,]

# RSCU je tusim 2 prednaska 
## cele RSCU sa da pocitat pre kazdy kodon amk co ona nespomina v zadani ale dohodli 
## sme sa na jednom kodone, zistujem teda iba jeden, ten s najmensim indexom = pI/L[1]
L=c()
pL=grep('L',gk)
dL=length(pL)
LK=c()

I=c()
pI=grep('I',gk)
dI=length(pI)
IK=c()

for (o in 1:length(CDS)){
     L=c(L,matica[o,][grep(GK[pL[1]],names(matica[o,]))]) 
     Lk=0
     for (u in 1:dL){
          Lk= Lk+matica[o,][grep(GK[pL[u]],names(matica[o,]))]}
     LK=c(LK,Lk)
     
     I=c(I,matica[o,][grep(GK[pI[1]],names(matica[o,]))]) 
     Ik=0
     for (u in 1:dI){
          Ik= Ik+matica[o,][grep(GK[pI[u]],names(matica[o,]))]}
     IK=c(IK,Ik)}

IL_NC_002808=c(((dL*L[1])/LK[1]),((dI*I[1])/IK[1]))
IL_NC_003039=c(((dL*L[2])/LK[2]),((dI*I[2])/IK[2]))
IL_NC_020141=c(((dL*L[3])/LK[3]),((dI*I[3])/IK[3]))

#3
alig=msaClustalOmega(CDS)
alig=as(alig,'DNAStringSet')
writeXStringSet(alig,'alignCDS_CYTB.fasta',format = 'fasta')

#4

prot=translate(CDS)
names(prot)=c() # Clustal omega na stranke chce rozlisne names tak som ich odstranil
writeXStringSet(prot,'prot_CYTB.fasta',format='fasta')


#6 
# funkciu stringDist v tejto podobe najdete v help pre XstringSet

AliClu=readAAMultipleAlignment('alignProt_CYTB.clustal_num',format='clustal')
AliClu=as(AliClu,'XStringSet')
distMat=stringDist(AliClu, method = "levenshtein", ignoreCase = FALSE, diag = FALSE,
           upper = FALSE, type = "global", quality = PhredQuality(22L),
           substitutionMatrix = NULL, fuzzyMatrix = NULL, gapOpening = 0,
           gapExtension = 1)
#            EMBOSS_003 EMBOSS_001
# EMBOSS_001        119           
# EMBOSS_002        105         71
## najmensi pocet rozdielov medzi 2808-EMBOSS_001 a 3039-EMBOSS_002

#7

GOR2808=read.table('GOR002808.txt')
##neviem ako to pretypovat 
## A=as(GOR2808,'BStringSet')
## ale takto by to fungovalo ak by sa to pretypovalo na nieco ine nez tabulka
#coil=length(grep('C',A[1]))/length(A[1])

