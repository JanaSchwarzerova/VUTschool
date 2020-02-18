#Téma_10 .... DNA barcoding a proteinové struktury

#Naètení knihovny: 
library(Biostrings)
library(msa)
# 1) Pøidìlenı fasta soubor èásti sekvencí mitochondriálního genu COX1 naètìte v R.

#Naèíst sekvence
sek = readDNAStringSet('FCFP.fasta',format='fasta')


# 2) Ze sekvencí odstraòte pøípadné mezery nebo znaky N. Pøíkazem, ádné ruèní mazání.


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

#Pro všechny sekvence
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

# 3) Získejte latinské názvy organismù - extrahovat správné èásti øetìzce z hlavièek.


#Pro jednu sekvenci: 
names(sek)[1]
mp = matchPattern('|',names(sek)[1],fixed = F)
pom = names(sek)[1]
pom = BString(pom)

start = start(mp[3])+1
end = start(mp[4])-1

nazev = pom[start:end]

#Pro všechny sekvence: 

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


# 4) Spoèítejte kolik rùznıch druhù se v souboru nachází.

pocitadlo = 0

for (o in 1:(length(nazev)-1)){
 if(nazev[o]=nazev[o+1]){
   pocitadlo = pocitadlo +1
   
 }
  
}

# 5) Spoèítejte poèet jedincù kadého druhu.



# 6) Pro druhy mající alespoò 3 sekvence, proveïte jejich vícenásobné zarovnání.


# 7) Z vícenásobného zarovnání vytvoøte konsenzuální sekvenci pro kadı druh.

# 8) Konsenzuální druhové sekvence mìjte v DNAStringSetu vèetnì názvu druhu, kterému pøísluší = druhové reference.

# 9) Pro druhı pøidìlenı fasta soubor proveïte kroky 1) a 5). Tyto sekvence budete identifikovat = pøiøazovat k nim 
#    nejpodobnìjší druhovou referenci. 

# 10) Kadou sekvenci postupnì globálnì zarovnejte s kadou konsenzuální sekvencí a pøiøaïte ji k tomu druhu, se kterım bude mít nejvyšší skóre zarovnání.

# 11) Vyhodnote procentuální úspìšnost identifikace sekvencí = kolik sekvencí mající referenci (mají shodnı název druhu ve fasta souborech) bylo pøiøazeno ke správné referenci.


##
t.jmena = as.charakter(jmena)
write.table(tjmena,file='jmena.txt',row.names = F,col.names=F)

struck = read.table('GOR.txt',header=F)
struck

struck$V1
pom = struck$V1

pom = as.character(pom)
pom 

