#T�ma_10 .... DNA barcoding a proteinov� struktury

#Na�ten� knihovny: 
library(Biostrings)
library(msa)
# 1) P�id�len� fasta soubor ��sti sekvenc� mitochondri�ln�ho genu COX1 na�t�te v R.

#Na��st sekvence
sek = readDNAStringSet('FCFP.fasta',format='fasta')


# 2) Ze sekvenc� odstra�te p��padn� mezery nebo znaky N. P��kazem, ��dn� ru�n� maz�n�.


#Pro jednu sekvenci 
sek_0 = sek[[1]]
mp_0 = matchPattern('-',sek_0,fixed = F)
new_sek_0 =  sek_0[-start(mp_0)]

sek_1 = sek[[76]]
mp_1 = matchPattern('N',sek_1,fixed = T)
if (length(mp_1)>0){
new_sek_1 =  sek_1[-start(mp_1)]
} else {
new_sek_1 =  sek_1
}

#Pro v�echny sekvence
pom_new_sek = DNAStringSet()
new_sek = DNAStringSet()

for (m in 1:length(sek)){
 mp =  matchPattern('-',sek[[m]],fixed = F)
 mp_2 =  matchPattern('N',sek[[m]],fixed = T)
 
  pom_new_sek = c(pom_new_sek,DNAStringSet(sek[[m]][-start(mp)]))
  if (length(mp_2)>0){
  new_sek = c(new_sek,DNAStringSet(pom_new_sek[[m]][-start(mp_2)]))
  } else {
  new_sek = c(new_sek,pom_new_sek)
  }
}

# 3) Z�skejte latinsk� n�zvy organism� - extrahovat spr�vn� ��sti �et�zce z hlavi�ek.


#Pro jednu sekvenci: 
names(sek)[1]
mp = matchPattern('|',names(sek)[1],fixed = F)
pom = names(sek)[1]
pom = BString(pom)

start = start(mp[3])+1
end = start(mp[4])-1

nazev = pom[start:end]

#Pro v�echny sekvence: 

nazev = BStringSet()

for (n in 1:length(sek)){
  names(sek)[n]
  mp = matchPattern('|',names(sek)[n])
  pom = names(sek)[n]
  pom = BString(pom)
  
  start = start(mp[3])+1
  end = start(mp[4])-1
  
  nazev = c(nazev,BStringSet(pom[start:end]))
}


# 4) Spo��tejte kolik r�zn�ch druh� se v souboru nach�z�.

pocitadlo = 0

for (o in 1:(length(nazev)-1)){
 if(nazev[o]=nazev[o+1]){
   pocitadlo = pocitadlo +1
   
 }
  
}

# 5) Spo��tejte po�et jedinc� ka�d�ho druhu.



# 6) Pro druhy maj�c� alespo� 3 sekvence, prove�te jejich v�cen�sobn� zarovn�n�.


# 7) Z v�cen�sobn�ho zarovn�n� vytvo�te konsenzu�ln� sekvenci pro ka�d� druh.

# 8) Konsenzu�ln� druhov� sekvence m�jte v DNAStringSetu v�etn� n�zvu druhu, kter�mu p��slu�� = druhov� reference.

# 9) Pro druh� p�id�len� fasta soubor prove�te kroky 1) a� 5). Tyto sekvence budete identifikovat = p�i�azovat k nim 
#    nejpodobn�j�� druhovou referenci. 

# 10) Ka�dou sekvenci postupn� glob�ln� zarovnejte s ka�dou konsenzu�ln� sekvenc� a p�i�a�te ji k tomu druhu, se kter�m bude m�t nejvy��� sk�re zarovn�n�.

# 11) Vyhodno�te procentu�ln� �sp�nost identifikace sekvenc� = kolik sekvenc� maj�c� referenci (maj� shodn� n�zev druhu ve fasta souborech) bylo p�i�azeno ke spr�vn� referenci.


##
t.jmena = as.charakter(jmena)
write.table(tjmena,file='jmena.txt',row.names = F,col.names=F)

struck = read.table('GOR.txt',header=F)
struck

struck$V1
pom = struck$V1

pom = as.character(pom)
pom 

