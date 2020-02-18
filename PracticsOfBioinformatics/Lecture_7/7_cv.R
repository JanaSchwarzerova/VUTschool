setwd("~/R/7_cv")

#****************************************************7.cvièení************************************************************
# FYLOGENETICKÉ STROMY ___________________________________________________________________________________________________
# Morfologická taxonomie URL - vložím do ikony a dám add
# Commontree-txt ... zaznamenaní taxonomie jednotlivých organismu


#Nexus (formát) - na zaèátku je øeèeno, že se jedná o nexus, zaèíná to begin; konèí end
#               - pracuje tak 1/3 souboru
# 

#Phylip (formát) - jen první blok má názvy organismu, ostatní bez názvu, nemá žádné ukonèení
#                - takový zjednodušený nexus


#************************************************************************************************************************
# Praktický pøíklad na zakladní strom v R:

library('Biostrings')

sek = readDNAMultipleAlignment('dna_zarovnani.clustal',format = 'clustal')
sek 
sek = as(sek,'DNAStringSet')
sek 
D = stringDist(sek,method = 'levenshtein')
D
D = stringDist(sek,method = 'hamming')
D
tree = hclust(D,method = 'average')
plot(tree) #Zobrazení stromu

#FASTA soubor nezarovnaných nukleotidù_________________________________________________________________________________
sek = readDNAStringSet('dna.fasta',format='fasta')
gk = getGeneticCode('SGC1')
prot = translate(sek,genetic.code = gk)

library(msa)
aligned = msa(prot)
align = as(align,'AAStringSet')                                      
D = stringDist(align)
tree = hclust(D,method = 'average')
plot(tree) #Zobrazení stromu
#_____________________________________________________________________________________________________________________

#Tree Inference -> NJ -> vybereš soubor 
# newickfile.txt

#Maximum parcialy .. http://www.phylogeny.fr/simple_phylogeny.cgi - dobrá metoda, ale dlouho trvá

#Nahrát soubor v newick formátu http://iubio.bio.indiana.edu/treeapp/treeprint-form.html 




#Naprogramovat funkci:        ____________________DISTANÈNÍ MATICE - výpoèet___________________________
# Do funkce budeme pøedpokladat, že jdou zarované sekvence, a v nich budeme poèítat poèet zmìn, 
# toto èíslo podìlíme délkou sekvenci 
# na konci nám vyjde distanèní matice 


#Naètení zarovnaných sekvencí, kde spoèteme distanèní matici: 
sek = readDNAStringSet('dna_zarovnani.mfa',format='fasta')
sek

#poèet sekvencí, které budeme zarovnávat 
pocet_sek = length(sek)

#První si dát do matice na diagonálu Inf
dist_matice = matrix(data = rep(0),pocet_sek,pocet_sek)
          #Dosazení "inf" na diagonálu
          for (k in 1:pocet_sek){     
            dist_matice[k,k] = Inf
            }

delka_sek = length(sek[[1]])
shoda_n = 0
zmena_n = 0

for (n in 1:(pocet_sek-1)){ 
     for (m in 1:delka_sek){   
       for(o in 1:(pocet_sek-1)){ 
         
        if (sek[[n]][m]==sek[[n+1]][m]){
          shoda_n = shoda_n +1}
          else{
          zmena_n = zmena_n + 1 
          }
        dist_matice[n,n+1]=zmena_n/delka_sek
       }
    }
}
dist_matice
