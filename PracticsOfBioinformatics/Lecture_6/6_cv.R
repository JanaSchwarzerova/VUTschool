# CVI�EN�_6

sek = readDNAStringSet('cox1_gene.fasta',format = 'fasta')
sek 

sek4 = readDNAStringSet('Terebratalia transversa mitochondrion.fasta',format = 'fasta')
sek4

grep('COX1',names(sek4)) #Grep pro vyhled�n� COXS v sekvenci sek4 v n�zvech "names"
grep('CDS',names(sek4))  #Grep pro vyhled�n� CDS v sekvenci sek4 v n�zvech "names"

#sejn� ��slo -> 3
#proto si tuto sekvenci na 3 p�id�m do toho souboru cox1_gene.fasta (tedy ulo�eno pro prom�nou sek) , 
#kde ji� m�m 3 -> budu m�t 4

names(sek)[3] #najdu sekvenci - stejn� ��slo je na 3 proto 3
sek = c(sek,sek4[3]) #spoj�m ji 
                      # v sek ... m�m ulo�en� ty t�i sekvence 
                      # v sek2... m�m tu co chci k nim p�idat 
names(sek)[4]='Terebratalia transversa'

sek # V�sledek 

#Zopakuji pro p��d�n� dal�� sekvence, at v sek m�m 5 sekvenc�
sek5 = readDNAStringSet('Papio kindae mitochondrion.fasta',format = 'fasta')
grep('COX1',names(sek5))
grep('CDS',names(sek5)) 

names(sek)[24] 
sek = c(sek,sek5[24])
names(sek)[5]='Papio kindae'

sek # V�sledek 

#Zopakuji pro p��d�n� dal�� sekvence, at v sek m�m 6 sekvenc�
sek6 = readDNAStringSet('Echinosorex_gymnura_mitochondrion.fasta',format = 'fasta')
grep('COX1',names(sek6))
grep('CDS',names(sek6)) 

names(sek)[25] 
sek = c(sek,sek6[25])
names(sek)[6]='Echinosorex gymnura'

sek # V�sledek 

#Na�ten� genetick�ho k�du pro mitochondrii
gk = getGeneticCode('SGC1') #mitochondri�ln� genetick� k�d
prot = translate(sek,genetic.code = gk)

alphabetFrequency(prot) #Zkontroluji

writeXStringSet(sek,'dna.fasta')
writeXStringSet(prot,'prot.fasta')


#Pr�ce v web strank�ch

#***************************************************************************************************************PAUZA

#na�ten� toho co jsme vytvo�ili/st�hli 
sek = readDNAMultipleAlignment('dna_zarovnani.mfa',format = 'fasta')

rownames(sek)
sek2=as(sek,'DNAStringSet') #Zm�n�m datov� form�t
sek2 #u� to je to na co jsme zvykl� 

detail(sek)  #Naho�e je po�et sekvenc� a potom jejich d�lka  (1. ��dek "vlevo naho�e")
alphabetFrequency(sek) #Vyhod� n�m to kolik �eho je 

#Vytvo�en� koncensu�ln� sekvence 
consensusString(sek)

#Na�ten� clustal souboru
sek = readDNAMultipleAlignment('dna_zarovnani.clustal', format = 'clustal') 
sek 

#Na�ten� clustal souboru, zarovn�n� proteinu
sek = readAAMultipleAlignment('prot_zarovnani.clustal',format = 'clustal')
sek 
sek2 = as(sek,'AAStringSet')
sek2
detail(sek)

#*********************************************************************************************************************

#Nainstalov�n� knihovny MSA 
# MSA um� jen zarovn�vat a p�ev�d�t i do 
source("http://www.bioconductor.org/biocLite.R")
biocLite("msa")
library(msa)

#Nyn� si zkus�me zarovnat sekvence pomoc� zarovn�n� v Rku 

sek = readAAStringSet('prot.fasta',format='fasta') #Na�ten� nezarovan�ch sekvenc� protein�
sek
align = msa(sek) #Zarovnani  (vid�me jen kousek, p�es detail, se zase dostaneme na to cel�)

detail(align)
# Pokud to chceme vypsat cel� v okn� na obrazovce tak m��eme vypsat pomoc� p��kazu: 
# print(align,show='complete')

pom = as(align,'AAStringSet')
pom 

#Pokud se n�m hodn� zm�n� zarovn�n� ta m��ene napsat 
#align = msa(sek_method = 'ClustalOmega') # ... ��m� zm�n�m metodu zarovn�n� (sp�e zm�na u nukleotidu, ne� u protein�)


