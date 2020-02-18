library(Biostrings)
library(msa)
sek1=readDNAStringSet('MNCN.fas',format='fasta')

# 2) Ze sekvencí odstraòte pøípadné mezery nebo znaky N. Pøíkazem, žádné ruèní mazání.

cistaSek=DNAStringSet()

for (ii in 1:length(sek1)){
  sek =sek1[[ii]]
  mp = matchPattern('-',sek)
  mp2 = matchPattern('N',sek,fixed = T)
  rem=c((start(mp)),(start(mp2)))
  sek2=sek[-rem]
  cistaSek = c(cistaSek,DNAStringSet(sek2))
  
}

# 3) Získejte latinské názvy organismù - extrahovat správné èásti øetìzce z hlavièek.

nazvy = BStringSet()
for (m in 1:length(sek1)) {
  pom2 = names(sek1)[m]
  pom2 = BString(pom2)
  mp = matchPattern('|',names(sek1)[m])
  nazvy = c(nazvy,BStringSet(pom2[(start(mp)[3]+1):(end(mp)[4]-1)]))
}
nazvy

# 4) Spoèítejte kolik rùzných druhù se v souboru nachází.
druh=unique(nazvy)
pocet_druhov=length(druh)

# 5)Spoèítejte poèet jedincù každého druhu.
pocty=matrix(0,nrow=0,ncol=pocet_druhov)
for (x in 1:pocet_druhov) {
  pom=start(vmatchPattern(druh[[x]],nazvy))
  pocty[x]=length(grep(druh[[x]],nazvy))
}

kontrola=sum(pocty)==length(nazvy)
kon_sek=DNAStringSet()
index=1
poc=1
#6) Pro druhy mající alespoò 3 sekvence, proveïte jejich vícenásobnézarovnání.
for (jj in 1: pocet_druhov) {
  index2=sum(pocty[1:jj])
  if(pocty[jj]>2) {
    sekvencie=cistaSek[index:index2]
    align=msa(sekvencie)
    
    # 7) Z vícenásobného zarovnání vytvoøte konsenzuální sekvenci pro každý druh.
    kon_sek2=consensusString(align) 
    kon_sek=c(kon_sek,DNAStringSet(kon_sek2))
    # 8) Konsenzuální druhové sekvence mìjte v DNAStringSetu vèetnì názvu druhu, kterému pøísluší = druhové reference.
    names(kon_sek)[poc]="ptak"
    names(kon_sek)[poc]=druh[jj]
    poc=poc+1
  }
  index=index2+1
}
