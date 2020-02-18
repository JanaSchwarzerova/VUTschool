# CVIÈENÍ_6

sek = readDNAStringSet('cox1_gene.fasta',format = 'fasta')
sek 

sek4 = readDNAStringSet('Terebratalia transversa mitochondrion.fasta',format = 'fasta')
sek4

grep('COX1',names(sek4)) #Grep pro vyhledání COXS v sekvenci sek4 v názvech "names"
grep('CDS',names(sek4))  #Grep pro vyhledání CDS v sekvenci sek4 v názvech "names"

#sejné èíslo -> 3
#proto si tuto sekvenci na 3 pøidám do toho souboru cox1_gene.fasta (tedy uloženo pro promìnou sek) , 
#kde již mám 3 -> budu mít 4

names(sek)[3] #najdu sekvenci - stejné èíslo je na 3 proto 3
sek = c(sek,sek4[3]) #spojím ji 
                      # v sek ... mám uložené ty tøi sekvence 
                      # v sek2... mám tu co chci k nim pøidat 
names(sek)[4]='Terebratalia transversa'

sek # Výsledek 

#Zopakuji pro pøídání další sekvence, at v sek mám 5 sekvencí
sek5 = readDNAStringSet('Papio kindae mitochondrion.fasta',format = 'fasta')
grep('COX1',names(sek5))
grep('CDS',names(sek5)) 

names(sek)[24] 
sek = c(sek,sek5[24])
names(sek)[5]='Papio kindae'

sek # Výsledek 

#Zopakuji pro pøídání další sekvence, at v sek mám 6 sekvencí
sek6 = readDNAStringSet('Echinosorex_gymnura_mitochondrion.fasta',format = 'fasta')
grep('COX1',names(sek6))
grep('CDS',names(sek6)) 

names(sek)[25] 
sek = c(sek,sek6[25])
names(sek)[6]='Echinosorex gymnura'

sek # Výsledek 

#Naètení genetického kódu pro mitochondrii
gk = getGeneticCode('SGC1') #mitochondriální genetický kód
prot = translate(sek,genetic.code = gk)

alphabetFrequency(prot) #Zkontroluji

writeXStringSet(sek,'dna.fasta')
writeXStringSet(prot,'prot.fasta')


#Práce v web strankách

#***************************************************************************************************************PAUZA

#naètení toho co jsme vytvoøili/stáhli 
sek = readDNAMultipleAlignment('dna_zarovnani.mfa',format = 'fasta')

rownames(sek)
sek2=as(sek,'DNAStringSet') #Zmìním datový formát
sek2 #už to je to na co jsme zvyklí 

detail(sek)  #Nahoøe je poèet sekvencí a potom jejich délka  (1. øádek "vlevo nahoøe")
alphabetFrequency(sek) #Vyhodí nám to kolik èeho je 

#Vytvoøení koncensuální sekvence 
consensusString(sek)

#Naètení clustal souboru
sek = readDNAMultipleAlignment('dna_zarovnani.clustal', format = 'clustal') 
sek 

#Naètení clustal souboru, zarovnání proteinu
sek = readAAMultipleAlignment('prot_zarovnani.clustal',format = 'clustal')
sek 
sek2 = as(sek,'AAStringSet')
sek2
detail(sek)

#*********************************************************************************************************************

#Nainstalování knihovny MSA 
# MSA umí jen zarovnávat a pøevádìt i do 
source("http://www.bioconductor.org/biocLite.R")
biocLite("msa")
library(msa)

#Nyní si zkusíme zarovnat sekvence pomocí zarovnání v Rku 

sek = readAAStringSet('prot.fasta',format='fasta') #Naètení nezarovaných sekvencí proteinù
sek
align = msa(sek) #Zarovnani  (vidíme jen kousek, pøes detail, se zase dostaneme na to celé)

detail(align)
# Pokud to chceme vypsat celé v oknì na obrazovce tak mùžeme vypsat pomocí pøíkazu: 
# print(align,show='complete')

pom = as(align,'AAStringSet')
pom 

#Pokud se nám hodnì zmìní zarovnání ta mùžene napsat 
#align = msa(sek_method = 'ClustalOmega') # ... èímž zmìním metodu zarovnání (spíše zmìna u nukleotidu, než u proteinù)


