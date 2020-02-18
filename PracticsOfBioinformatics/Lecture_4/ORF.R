library(Biostrings)
sek=DNAString("AAAATATGCAATGCCAGTGAAATAAATGCCCCAGTGAACTCATGAAAATGCCATCTCAGTGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATGA") #zadaná sekvence nukleotidù
L=length(sek) #délka sekvence, pomocná promìnná 
gk=getGeneticCode('SGC0') #chceme mitochondriální gen. kód
a=which(gk=='*') # ptáme se které triplety jsou pøekládány jako STOP
stopK=gk[a] # uloíme vyhledané STOP kodóny pomocí promìnné "a"
stopK=DNAStringSet(names(stopK)) # Tyhle STOP kodóny uloíme pod triplety a jako DNAstring, aby se s nìmi dalo pracovat dále
p = matchPDict(stopK,sek,fixed=F) # Vyhledáváme pozice STOP kodónu v sekvenci, vyhodí pozièní indexy pro kadı pattern zvláš
k=end(p) # Chceme pouze pozici, kde konèí triplet STOP, proto end 
pozice=c(k[[1]],k[[2]],k[[3]]) #a chceme tyhle pozice dát do vektoru 1,2,3 jsou jednotlivé STOP kodóny
pozice=sort(pozice) # seøadíme se vzestupnì
kam=length(pozice) # poèet pozic
nova=DNAStringSet(sek[1:pozice[1]]) # iniciace prvního úseku


for (q in 2:kam) {
  if (length(sek[(pozice[(q-1)]+1):(pozice[q])])<50) # bude øešit subsekvence kratší jak 50 nukleotidù
  {
  nova=append(nova,DNAStringSet(sek[(pozice[(q-1)]+1):(pozice[q])])) # pøidávání stringù, +1 z dùvodu, e se nacházíme na nukleotidu pøedchozího STOP
  pryc=length(nova[[q-1]])%%3 #opravení ètecího rámce modulem, kolik písmen na zaèátku pøebıvá? .. zaèínám od stop kodónu a jdu po tøech na zaèátek ... zbytek vyhodím
  # modulo == x%%y
  }
  if (pryc>0)  # pokud je po dìlení 3 zbytek
  {
  nova[[q-1]]=nova[[q-1]][-(1:pryc)]  # v dané subsekvenci odstraòuji pøebyteèné nukleotidy
  }
}

#získání subsekvencí se start kodonem
DNA=DNAStringSet()

for(g in 1:length(nova))
{
pom=seq(from=1,to=length(nova[[g]]),by=3)
for (t in pom)
{
if (nova[[g]][t:(t+2)]==DNAString("ATG")& length(nova[[g]]) <= 15)  #beru zároveò ty které obsahují ATG a ty které jsou kratší ne 15 nukleotidù  
{
DNA = append(DNA,DNAStringSet(nova[[g]])) 
}
}
}


# Odstranìní nukleotidù pøed START kodónem
DNA_v=DNAStringSet()
for (d in 1:length(DNA)) {
pom1=matchPattern("ATG",DNA[[d]])
pom1=start(pom1[1])-1 #místo kde zaèíná START kodón, tedy "A", -1 abychom byli pøed tímto START kodónem
if (pom1>1)
{
  DNA[[d]]=DNA[[d]][-(1:pom1)]
}
}

# Pøeklad
proteins=translate(DNA)
