#2_cv

#V�t�ina knihoven se instaluje pomoc� p��kaz� 
install.packages()  #nebo "Tools" a kliknout na Install Packeages

#p��klad: 
#Knihovna seqinr 
# "Tools" a kliknout na Install Packeages .... kliknout na instal ...
# vyjede n�m v Console toto: 
install.packages("seqinr")
# viz Console



#Instalace knihovny biostrings
#slo�it�j�� instalov�n�; 

source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")

library(Biostrings) #T�mto zp�sobem na�teme tuto knihovnu pro tuto relaci a kdy� shod�me Rko mus�me to znovu zaj�t, ale 
                    #pouze u� jen to "library" (tu knihovnu tam u� nahranou m�me t�m source)


## Knihovna Biostrings m� sv� datov� typy: 

#P��klad v Console: 
> a = 'retezec'
> a[2:5]
[1] NA NA NA NA #to nechceme 
> b = BString("Takto je obecn� �et�tez") #toto je String co chceme
> b
23-letter "BString" instance
seq: Takto je obecn� �et�tez
> b[2:6]
5-letter "BString" instance
seq: akto


> dna = DNAString("ACGTACGT")  #Specifikum DNAString -> m��eme pou��vat pouze DNA znaky: ACGTRYSWMKNBDHV-L
> dna
8-letter "DNAString" instance
seq: ACGTACGT

#Vsuvka - vyps�n� prvn� a posledn� ��sti a n�sledn� spojen� 
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
#Zji��uje povolen� znaky 

letterFrequency(dna, 'C')
#C 1 .... zji��uje �etnost znak�


reverse(dna)
#Pokud chceme sekvenci pouze p�evr�tit zleva dopravda
complement(dna)
#Vytvo�en� komplement�rn� sekvence 
reverseComplement(dna)
#Reverzn� komplement
#P�. 
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

#P�eps�n� t�et�ho znaku z G na C pro jen tento konkr�tn� p��kaz
> dna
8-letter "DNAString" instance
seq: ACGTACGT  
replaceLetterAt(dna,3,"C")
8-letter "DNAString" instance
seq: ACCTACGT

#Mo�nost po��tat dinukleotidy, trinukleotidy �i oligonucleotidy
dinucleotideFrequency(dna)
trinucleotideFrequency(dna)
oligonucleotideFrequency(dna,4,step = 2) #step = 2 viz se�it 


#Vyhled�v�n� ur�it�ch znak� v sekvenci 
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
> dna[start(mp)[1]:end(mp)[2]]  #Naro�n� indexov�n�, ale lze to vyhledat 
6-letter "DNAString" instance
seq: TAGCTA

# m�m TAC a TAG, C a G jsou S, tak zkus�me vyhledat TAS 
mp = matchPattern('TAS',dna,fixed = F) #Mus�me d�t False, �e se to nefixuje
> mp
Views on a 11-letter DNAString subject
subject: ACGTAGCTANG
views:
  start end width
[1]     4   6     3 [TAG]
[2]     8  10     3 [TAN]

#Sekvence mus�me ukladat pomoc� spojen� vektor�, tedy p�es "c"
> sek = DNAStringSet(c('CGATAG','ATGCA','AGT'))
> sek
A DNAStringSet instance of length 3
width seq
[1]     6 CGATAG
[2]     5 ATGCA
[3]     3 AGT
> sek[2] #M��eme to takto indexovat
A DNAStringSet instance of length 1
width seq
[1]     5 ATGCA
#Ale nemu�eme to indexovat takto 
> pom = sek[2]
> pom 
A DNAStringSet instance of length 1
width seq
[1]     5 ATGCA
> pom[1:3]
Error: subscript contains out-of-bounds indices
#Proto�e to tam tak nem�m, mus�m to indexovat jinak pomoc� hrozn�ho indexovan�
> sek[[2]][1:3]
3-letter "DNAString" instance
seq: ATG
#dvojty hranat� z�vorky ��kam kterou sekvenci a pak kterou ��st sekvence


#Kdykoli v�me, �e m�me specifick� �et�zec mus�me to napsat 
#p�.

> dna = DNAString('ACGT')
#�patn�
> dna[1]=='A'
Error in (function (classes, fdef, mtable)  : 
            unable to find an inherited method for function �pcompare� for signature �"DNAString", "character"�
#Spr�vn�
> dna[1]==DNAString('A') #Ov��en�, jestli je prvn� p�smeno A
[1] TRUE

#Podobn� jde nadefinovat pr�zdnou sekvenci 
sek = DNAStringSet()
#P�id�v�n� p�smen do sekvence
dna = c(sek,DNAStringSet('MKL'))

#Paterny - viz mobil 





## GENETICK� K�DY

> dna = DNAString('ATGCGCAACTCATGA')
> prot = translate(dna)
> prot
5-letter "AAString" instance
seq: MRNS*

> GENETIC_CODE_TABLE #Tabulka genetickych k�d�
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

                                                      #V Matlabu byla bakterie 11 tady je po�adov� ��slo 9

#Nastaven� genetick�ho k�du
  #Nejprve pot�ebujeme genetick� k�d na��st do prom�nn�ch
sqc0 = getGeneticCode('SGC0') #standartn� genetick� k�d
sqc1 = getGeneticCode('SGC1') #mitochondri�ln� genetick� k�d

> prot = translate(dna,genetic.code = sqc0)
> prot
5-letter "AAString" instance
seq: MRNS
> prot2 = translate(dna,genetic.code = sqc1)
> prot2
5-letter "AAString" instance
seq: MRNSW

#Na�ten� souboru priklad.fasta
> sek = readDNAStringSet('priklad.fasta',format = 'fasta')
> sek
A DNAStringSet instance of length 2
width seq                                      
[1]   300 ATGATTTCACAAATCGCAAACTCCTTACTTACTTTTATTATAGT...
[2]   540 GTTGATGTAGCTTAAACTAAAGCGTAGCACTGAAAATGCTTGTA...

#length je po�et sekvenc�
> length(sek)
[1] 2
#jejich ���ka je ten width
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

> writeXStringSet(prot,'pokus.fas') #Uklad�n� ulo�eno ve slo�ce jako pokus.fas



#Se�ten� frekvenc� ... ponz (sta�� vlastn� p�esdvojt� z�vorky)
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


#Na�ten� substitu�n�ch matic
#Vz�sad� se porovn�v� podle BLOSUM62 ... n�co hodn� podobn�ho �lov�k/�impanz BLOSUM80, �impanz/my� BLOUSUM45

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

#Zarovn�n� 
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

#Pozn. i kdy� penalizace zad�me kladn� a n� zaporn�, R to bere tak, �e se m� skore sni�ovat.

#VIZ MOBIL  (zkusit local)



#�KOL: Vybrat si sympatick�ho �ivo�icha (aspo� t�i �ivo�ichy)
#      Na�teme GenBank soubor, v elearnignu zkop�rovat a on n�m vyhod� fasta soubor 
#      Odkaz na elearningu ... Sequence Manipulation Suite -> GenBank Feature Extractor
#           pozor textov� soubor fasta mus� za��nat ">source"


