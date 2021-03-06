library(Biostrings)
sek=DNAString("AAAATATGCAATGCCAGTGAAATAAATGCCCCAGTGAACTCATGAAAATGCCATCTCAGTGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATGA") #zadan� sekvence nukleotid�
L=length(sek) #d�lka sekvence, pomocn� prom�nn� 
gk=getGeneticCode('SGC0') #chceme mitochondri�ln� gen. k�d
a=which(gk=='*') # pt�me se kter� triplety jsou p�ekl�d�ny jako STOP
stopK=gk[a] # ulo��me vyhledan� STOP kod�ny pomoc� prom�nn� "a"
stopK=DNAStringSet(names(stopK)) # Tyhle STOP kod�ny ulo��me pod triplety a jako DNAstring, aby se s n�mi dalo pracovat d�le
p = matchPDict(stopK,sek,fixed=F) # Vyhled�v�me pozice STOP kod�nu v sekvenci, vyhod� pozi�n� indexy pro ka�d� pattern zvl᚝
k=end(p) # Chceme pouze pozici, kde kon�� triplet STOP, proto end 
pozice=c(k[[1]],k[[2]],k[[3]]) #a chceme tyhle pozice d�t do vektoru 1,2,3 jsou jednotliv� STOP kod�ny
pozice=sort(pozice) # se�ad�me se vzestupn�
kam=length(pozice) # po�et pozic
nova=DNAStringSet(sek[1:pozice[1]]) # iniciace prvn�ho �seku


for (q in 2:kam) {
  if (length(sek[(pozice[(q-1)]+1):(pozice[q])])<50) # bude �e�it subsekvence krat�� jak 50 nukleotid�
  {
  nova=append(nova,DNAStringSet(sek[(pozice[(q-1)]+1):(pozice[q])])) # p�id�v�n� string�, +1 z d�vodu, �e se nach�z�me na nukleotidu p�edchoz�ho STOP
  pryc=length(nova[[q-1]])%%3 #opraven� �tec�ho r�mce modulem, kolik p�smen na za��tku p�eb�v�? .. za��n�m od stop kod�nu a jdu po t�ech na za��tek ... zbytek vyhod�m
  # modulo == x%%y
  }
  if (pryc>0)  # pokud je po d�len� 3 zbytek
  {
  nova[[q-1]]=nova[[q-1]][-(1:pryc)]  # v dan� subsekvenci odstra�uji p�ebyte�n� nukleotidy
  }
}

#z�sk�n� subsekvenc� se start kodonem
DNA=DNAStringSet()

for(g in 1:length(nova))
{
pom=seq(from=1,to=length(nova[[g]]),by=3)
for (t in pom)
{
if (nova[[g]][t:(t+2)]==DNAString("ATG")& length(nova[[g]]) <= 15)  #beru z�rove� ty kter� obsahuj� ATG a ty kter� jsou krat�� ne� 15 nukleotid�  
{
DNA = append(DNA,DNAStringSet(nova[[g]])) 
}
}
}


# Odstran�n� nukleotid� p�ed START kod�nem
DNA_v=DNAStringSet()
for (d in 1:length(DNA)) {
pom1=matchPattern("ATG",DNA[[d]])
pom1=start(pom1[1])-1 #m�sto kde za��n� START kod�n, tedy "A", -1 abychom byli p�ed t�mto START kod�nem
if (pom1>1)
{
  DNA[[d]]=DNA[[d]][-(1:pom1)]
}
}

# P�eklad
proteins=translate(DNA)
