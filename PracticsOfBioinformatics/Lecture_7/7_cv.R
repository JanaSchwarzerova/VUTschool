setwd("~/R/7_cv")

#****************************************************7.cvi�en�************************************************************
# FYLOGENETICK� STROMY ___________________________________________________________________________________________________
# Morfologick� taxonomie URL - vlo��m do ikony a d�m add
# Commontree-txt ... zaznamenan� taxonomie jednotliv�ch organismu


#Nexus (form�t) - na za��tku je �e�eno, �e se jedn� o nexus, za��n� to begin; kon�� end
#               - pracuje tak 1/3 souboru
# 

#Phylip (form�t) - jen prvn� blok m� n�zvy organismu, ostatn� bez n�zvu, nem� ��dn� ukon�en�
#                - takov� zjednodu�en� nexus


#************************************************************************************************************************
# Praktick� p��klad na zakladn� strom v R:

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
plot(tree) #Zobrazen� stromu

#FASTA soubor nezarovnan�ch nukleotid�_________________________________________________________________________________
sek = readDNAStringSet('dna.fasta',format='fasta')
gk = getGeneticCode('SGC1')
prot = translate(sek,genetic.code = gk)

library(msa)
aligned = msa(prot)
align = as(align,'AAStringSet')                                      
D = stringDist(align)
tree = hclust(D,method = 'average')
plot(tree) #Zobrazen� stromu
#_____________________________________________________________________________________________________________________

#Tree Inference -> NJ -> vybere� soubor 
# newickfile.txt

#Maximum parcialy .. http://www.phylogeny.fr/simple_phylogeny.cgi - dobr� metoda, ale dlouho trv�

#Nahr�t soubor v newick form�tu http://iubio.bio.indiana.edu/treeapp/treeprint-form.html 




#Naprogramovat funkci:        ____________________DISTAN�N� MATICE - v�po�et___________________________
# Do funkce budeme p�edpokladat, �e jdou zarovan� sekvence, a v nich budeme po��tat po�et zm�n, 
# toto ��slo pod�l�me d�lkou sekvenci 
# na konci n�m vyjde distan�n� matice 


#Na�ten� zarovnan�ch sekvenc�, kde spo�teme distan�n� matici: 
sek = readDNAStringSet('dna_zarovnani.mfa',format='fasta')
sek

#po�et sekvenc�, kter� budeme zarovn�vat 
pocet_sek = length(sek)

#Prvn� si d�t do matice na diagon�lu Inf
dist_matice = matrix(data = rep(0),pocet_sek,pocet_sek)
          #Dosazen� "inf" na diagon�lu
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
