#2_cv

#Vìtšina knihoven se instaluje pomocí pøíkazù 
install.packages()  #nebo "Tools" a kliknout na Install Packeages

#pøíklad: 
#Knihovna seqinr 
# "Tools" a kliknout na Install Packeages .... kliknout na instal ...
# vyjede nám v Console toto: 
install.packages("seqinr")
# viz Console



#Instalace knihovny biostrings
#složitìjší instalování; 

source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")

library(Biostrings) #Tímto zpùsobem naèteme tuto knihovnu pro tuto relaci a když shodíme Rko musíme to znovu zajít, ale 
                    #pouze už jen to "library" (tu knihovnu tam už nahranou máme tím source)


## Knihovna Biostrings má své datové typy: 

#Pøíklad v Console: 
> a = 'retezec'
> a[2:5]
[1] NA NA NA NA #to nechceme 
> b = BString("Takto je obecný øetìtez") #toto je String co chceme
> b
23-letter "BString" instance
seq: Takto je obecný øetìtez
> b[2:6]
5-letter "BString" instance
seq: akto


> dna = DNAString("ACGTACGT")  #Specifikum DNAString -> mùžeme používat pouze DNA znaky: ACGTRYSWMKNBDHV-L
> dna
8-letter "DNAString" instance
seq: ACGTACGT

#Vsuvka - vypsání první a poslední èásti a následné spojení 
> dna
8-letter "DNAString" instance
seq: ACGTACGT
> head(dna,3)
3-letter "DNAString" instance
seq: ACG
> tail(dna,2)
2-letter "DNAString" instance

> rna = RNAString("ACGURYSWMKNBVDH-")
> aa = AAString("ACGTRYSWMKNBDHV-")
> aa
16-letter "AAString" instance
seq: ACGTRYSWMKNBDHV-

alphabetFrequency(aa)
#Zjišuje povolené znaky 

letterFrequency(dna, 'C')
#C 1 .... zjišuje èetnost znakù


reverse(dna)
#Pokud chceme sekvenci pouze pøevrátit zleva dopravda
complement(dna)
#Vytvoøení komplementární sekvence 
reverseComplement(dna)
#Reverzní komplement
#Pø. 
> dna
8-letter "DNAString" instance
seq: ACGTACGT
> reverse(dna)
8-letter "DNAString" instance
seq: TGCATGCA
> complement(dna)
8-letter "DNAString" instance
seq: TGCATGCA
> reverseComplement(dna)
8-letter "DNAString" instance
seq: ACGTACGT

hasOnlyBaseLetters(dna)
[1] TRUE
uniqueLetters(dna)
[1] "A" "C" "G" "T"

#Pøepsání tøetího znaku z G na C pro jen tento konkrétní pøíkaz
> dna
8-letter "DNAString" instance
seq: ACGTACGT  
replaceLetterAt(dna,3,"C")
8-letter "DNAString" instance
seq: ACCTACGT

#Možnost poèítat dinukleotidy, trinukleotidy èi oligonucleotidy
dinucleotideFrequency(dna)
trinucleotideFrequency(dna)
oligonucleotideFrequency(dna,4,step = 2) #step = 2 viz sešit 


#Vyhledávání urèitých znakù v sekvenci 
> dna = DNAString('ACGTAGCTANG')
> matchPattern("TA",dna)
Views on a 11-letter DNAString subject
subject: ACGTAGCTANG
views:
  start end width
[1]     4   5     2 [TA]
[2]     8   9     2 [TA]
> mp = matchPattern("TA",dna)
> start(mp)
[1] 4 8
> end(mp)
[1] 5 9
> dna[start(mp)[1]:end(mp)[2]]  #Naroèné indexování, ale lze to vyhledat 
6-letter "DNAString" instance
seq: TAGCTA

# mám TAC a TAG, C a G jsou S, tak zkusíme vyhledat TAS 
mp = matchPattern('TAS',dna,fixed = F) #Musíme dát False, že se to nefixuje
> mp
Views on a 11-letter DNAString subject
subject: ACGTAGCTANG
views:
  start end width
[1]     4   6     3 [TAG]
[2]     8  10     3 [TAN]

#Sekvence musíme ukladat pomocí spojení vektorù, tedy pøes "c"
> sek = DNAStringSet(c('CGATAG','ATGCA','AGT'))
> sek
A DNAStringSet instance of length 3
width seq
[1]     6 CGATAG
[2]     5 ATGCA
[3]     3 AGT
> sek[2] #Mùžeme to takto indexovat
A DNAStringSet instance of length 1
width seq
[1]     5 ATGCA
#Ale nemužeme to indexovat takto 
> pom = sek[2]
> pom 
A DNAStringSet instance of length 1
width seq
[1]     5 ATGCA
> pom[1:3]
Error: subscript contains out-of-bounds indices
#Protože to tam tak nemám, musím to indexovat jinak pomocí hrozného indexovaní
> sek[[2]][1:3]
3-letter "DNAString" instance
seq: ATG
#dvojty hranatý závorky øíkam kterou sekvenci a pak kterou èást sekvence


#Kdykoli víme, že máme specifický øetìzec musíme to napsat 
#pø.

> dna = DNAString('ACGT')
#Špatnì
> dna[1]=='A'
Error in (function (classes, fdef, mtable)  : 
            unable to find an inherited method for function ‘pcompare’ for signature ‘"DNAString", "character"’
#Správnì
> dna[1]==DNAString('A') #Ovìøení, jestli je první písmeno A
[1] TRUE

#Podobnì jde nadefinovat prázdnou sekvenci 
sek = DNAStringSet()
#Pøidávání písmen do sekvence
dna = c(sek,DNAStringSet('MKL'))

#Paterny - viz mobil 





## GENETICKÉ KÓDY

> dna = DNAString('ATGCGCAACTCATGA')
> prot = translate(dna)
> prot
5-letter "AAString" instance
seq: MRNS*

> GENETIC_CODE_TABLE #Tabulka genetickych kódù
1                                                                                          Standard  SGC0  1
2                                                                          Vertebrate Mitochondrial  SGC1  2
3                                                                               Yeast Mitochondrial  SGC2  3
4  Mold Mitochondrial; Protozoan Mitochondrial; Coelenterate Mitochondrial; Mycoplasma; Spiroplasma  SGC3  4
5                                                                        Invertebrate Mitochondrial  SGC4  5
6                                          Ciliate Nuclear; Dasycladacean Nuclear; Hexamita Nuclear  SGC5  6
7                                                  Echinoderm Mitochondrial; Flatworm Mitochondrial  SGC8  9
8                                                                                  Euplotid Nuclear  SGC9 10
9                                                             Bacterial, Archaeal and Plant Plastid  <NA> 11
10                                                                        Alternative Yeast Nuclear  <NA> 12
11                                                                           Ascidian Mitochondrial  <NA> 13
12                                                               Alternative Flatworm Mitochondrial  <NA> 14
13                                                                         Blepharisma Macronuclear  <NA> 15
14                                                                      Chlorophycean Mitochondrial  <NA> 16
15                                                                          Trematode Mitochondrial  <NA> 21
16                                                               Scenedesmus obliquus Mitochondrial  <NA> 22
17                                                                   Thraustochytrium Mitochondrial  <NA> 23
18                                                                      Pterobranchia Mitochondrial  <NA> 24
AAs
1  FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
2  FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSS**VVVVAAAADDEEGGGG
3  FFLLSSSSYY**CCWWTTTTPPPPHHQQRRRRIIMMTTTTNNKKSSRRVVVVAAAADDEEGGGG
4  FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
5  FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSSSVVVVAAAADDEEGGGG
6  FFLLSSSSYYQQCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
7  FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG
8  FFLLSSSSYY**CCCWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
9  FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
10 FFLLSSSSYY**CC*WLLLSPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
11 FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSGGVVVVAAAADDEEGGGG
12 FFLLSSSSYYY*CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG
13 FFLLSSSSYY*QCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
14 FFLLSSSSYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
15 FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNNKSSSSVVVVAAAADDEEGGGG
16 FFLLSS*SYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
17 FF*LSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG
18 FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSSKVVVVAAAADDEEGGGG

                                                      #V Matlabu byla bakterie 11 tady je poøadové èíslo 9

#Nastavení genetického kódu
  #Nejprve potøebujeme genetický kód naèíst do promìnných
sqc0 = getGeneticCode('SGC0') #standartní genetický kód
sqc1 = getGeneticCode('SGC1') #mitochondriální genetický kód

> prot = translate(dna,genetic.code = sqc0)
> prot
5-letter "AAString" instance
seq: MRNS
> prot2 = translate(dna,genetic.code = sqc1)
> prot2
5-letter "AAString" instance
seq: MRNSW

#Naètení souboru priklad.fasta
> sek = readDNAStringSet('priklad.fasta',format = 'fasta')
> sek
A DNAStringSet instance of length 2
width seq                                      
[1]   300 ATGATTTCACAAATCGCAAACTCCTTACTTACTTTTATTATAGT...
[2]   540 GTTGATGTAGCTTAAACTAAAGCGTAGCACTGAAAATGCTTGTA...

#length je poèet sekvencí
> length(sek)
[1] 2
#jejich šíøka je ten width
> width(sek[2])
[1] 540

> names(sek)
[1] "NC_002807_Eptatretus_burgeri" "NC_003159_Chauliodus_sloani" 
> names(sek[1])='Eptatretus_burgeri'
> names(sek[2])='Chauliodus_sloani'

> sek
A DNAStringSet instance of length 2
width seq                                                                                         names               
[1]   300 ATGATTTCACAAATCGCAAACTCCTTACTTACTTTTATTATAGT...TTTTATGAATTTCCCTTCCTTTACCCCTGTCTCTTTCAGACATA NC_002807_Eptatre...
[2]   540 GTTGATGTAGCTTAAACTAAAGCGTAGCACTGAAAATGCTTGTA...TGAAGCCCCCTTACGAAAGTAGCTTTACGCCACCCGAACCCACG NC_003159_Chaulio...
> prot = translate(sek,genetic.code = sqc1)
> prot
A AAStringSet instance of length 2
width seq                                                                                         names               
[1]   100 MISQIANSLLTFIMVLIAVAFLTLVERKVLGYMQLRKGPNIVGP...LFIKEPVQPSHASIFMFIFAPTLAISLSLILWISLPLPLSLSDM NC_002807_Eptatre...
[2]   180 VDVA*TKA*HWKCLYEP**APPTTMDVCATRG*HWKAAKTGLTS...QVDTRGVKSG*GQDN*SRTSPKPLHAYGGMKPPYESSFTPPEPT NC_003159_Chaulio...

> writeXStringSet(prot,'pokus.fas') #Ukladání uloženo ve složce jako pokus.fas



#Seštení frekvencí ... ponz (staèí vlastnì pøesdvojté závorky)
> sek = DNAString('ACGTAG')
> af = alphabetFrequency(sek)
> af
A C G T M R W S Y K V H D B N - + . 
2 1 2 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
> names(af)
[1] "A" "C" "G" "T" "M" "R" "W" "S" "Y" "K" "V" "H" "D" "B" "N" "-" "+" "."
> names(af)[3]
[1] "G"
> af[[3]]
[1] 2
> af[[3]]+af[[4]]
[1] 3


#Naètení substituèních matic
#Vzásadì se porovnává podle BLOSUM62 ... nìco hodnì podobného èlovìk/šimpanz BLOSUM80, šimpanz/myš BLOUSUM45

> data(BLOSUM80)
> View(BLOSUM80)

> data("PAM30")
> View(PAM30)
> mat = nucleotideSubstitutionMatrix(match = 6, mismatch = 1, baseOnly = TRUE, type = 'DNA')
> mat
A  C  G  T
A  6 -1 -1 -1
C -1  6 -1 -1
G -1 -1  6 -1
T -1 -1 -1  6

#Zarovnání 
> dna1 = DNAString('ACGTGAC')
> dna2 = DNAString('CGGCC')
> pairwiseAlignment(dna1,dna2,substitutionMatrix= mat, gapOpening = -5, gapExtension=-2, type = 'global')
Global PairwiseAlignmentsSingleSubject (1 of 1)
pattern: [2] CGTGAC 
subject: [1] CG-GCC 
score: 9 

> glob = pairwiseAlignment(dna1,dna2,substitutionMatrix= mat, gapOpening = -5, gapExtension=-2, type = 'global')
> pattern(glob)
[2] CGTGAC 
> subject(glob)
[1] CG-GCC 
> score(glob)
[1] 9

#Pozn. i když penalizace zadáme kladnì a né zapornì, R to bere tak, že se má skore snižovat.

#VIZ MOBIL  (zkusit local)



#ÚKOL: Vybrat si sympatického živoèicha (aspoò tøi živoèichy)
#      Naèteme GenBank soubor, v elearnignu zkopírovat a on nám vyhodí fasta soubor 
#      Odkaz na elearningu ... Sequence Manipulation Suite -> GenBank Feature Extractor
#           pozor textový soubor fasta musí zaèínat ">source"


