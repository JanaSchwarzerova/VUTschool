library(Biostrings)
library(msa)
sek1=readDNAStringSet('MNCN.fas',format='fasta')

# 2) Ze sekvenc� odstra�te p��padn� mezery nebo znaky N. P��kazem, ��dn� ru�n� maz�n�.

cistaSek=DNAStringSet()

for (ii in 1:length(sek1)){
  sek =sek1[[ii]]
  mp = matchPattern('-',sek)
  mp2 = matchPattern('N',sek,fixed = T)
  rem=c((start(mp)),(start(mp2)))
  sek2=sek[-rem]
  cistaSek = c(cistaSek,DNAStringSet(sek2))
  
}

# 3) Z�skejte latinsk� n�zvy organism� - extrahovat spr�vn� ��sti �et�zce z hlavi�ek.

nazvy = BStringSet()
for (m in 1:length(sek1)) {
  pom2 = names(sek1)[m]
  pom2 = BString(pom2)
  mp = matchPattern('|',names(sek1)[m])
  nazvy = c(nazvy,BStringSet(pom2[(start(mp)[3]+1):(end(mp)[4]-1)]))
}
nazvy

# 4) Spo��tejte kolik r�zn�ch druh� se v souboru nach�z�.
druh=unique(nazvy)
pocet_druhov=length(druh)

# 5)Spo��tejte po�et jedinc� ka�d�ho druhu.
pocty=matrix(0,nrow=0,ncol=pocet_druhov)
for (x in 1:pocet_druhov) {
  pom=start(vmatchPattern(druh[[x]],nazvy))
  pocty[x]=length(grep(druh[[x]],nazvy))
}

kontrola=sum(pocty)==length(nazvy)
kon_sek=DNAStringSet()
index=1
poc=1
#6) Pro druhy maj�c� alespo� 3 sekvence, prove�te jejich v�cen�sobn�zarovn�n�.
for (jj in 1: pocet_druhov) {
  index2=sum(pocty[1:jj])
  if(pocty[jj]>2) {
    sekvencie=cistaSek[index:index2]
    align=msa(sekvencie)
    
    # 7) Z v�cen�sobn�ho zarovn�n� vytvo�te konsenzu�ln� sekvenci pro ka�d� druh.
    kon_sek2=consensusString(align) 
    kon_sek=c(kon_sek,DNAStringSet(kon_sek2))
    # 8) Konsenzu�ln� druhov� sekvence m�jte v DNAStringSetu v�etn� n�zvu druhu, kter�mu p��slu�� = druhov� reference.
    names(kon_sek)[poc]="ptak"
    names(kon_sek)[poc]=druh[jj]
    poc=poc+1
  }
  index=index2+1
}
