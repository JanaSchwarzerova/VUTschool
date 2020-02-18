%% Regulérní výrazy
% TEORIE
% Regulérní výraz dokáže podchytit hodnì podmínky (pøíklad výbìr pacientu se zaèáteèním písmenem S)
% atd. v jednom výrazu
% v R grep; v Matlabu regexp
% Na elearningu je odkaz  (vyukový materiál) na stránky + shrnutí v pdf
% V podstatì je regulérní výraz øetìzec, a v tom øetìzci jsou jednotlivé
% znaky, které mají nìjaký význam.. 
% vìtšina funkcí je case senstive (rozlišuje velké malé písmena)

% abc       efabc2a -> výsledek z grep by byl 4
% . libovolný znak a.c -> abc, a2c, axc, a_c
% ^ zaèátek ^a. 
% $         a$  ^a$
% *     – vstahuje se na jeden znak pøedtím 
%       pø. ^a.*  -> a, ab, abb, ac2
% +     pø. ^a.+  -> ab, ac, axx ...
% ?     pø. ^a.?  -> a, ax, a3

%{n}   ^a.{2
%{m,n} {m,} minimální; {,n} maximální
% []   [abc]

% ^P[aeiou].+ova$ ... rozkóduj: Budu hledat slova, musí zaèínat písmenem P
%                               

% seznamy: 
% [a-z][A-Z] [0-9]
% [^ ] ... seznam toho, co nechci aby tam bylo 
% [1-9] [0-9] (1-99 pomocí ?... [1-9][0-9]?)
%    10-99

% libovolný tøi znaky ^.{3}$
% [a-z A-Z 0-9]
% ^ko[sz].*              kos, kost, kosa, koza
% (ba)* pokud mám speciální výraz, tøeba * a chci aby se to stahovalo k
%  více znakùm, dám je do kulatých závorek
%  pø. (ab){3} ababab

%  NEBO ...  ^P.{3}|^S.{4}
%             (a|b)
%             [ab]
%             (abc|efg)

% \ je pøedznakem, který nìjak modifikuje jeho význam 
%                 pøíklad. \?
%                          \.
%                          \n 

% Pøíklady:  

% ^AT.*A{2,4}.*[CG]$     ATAAC
%                            G
%                        ATCAGAAAACTG

% ^C.*(TAC){2}A+[^CT].*(AAC|AAG)$   CTACTACAGAAC

%PRAKTICKÁ ÈÁST
 a = 'Toto je retezec.';
 regexp(a,'to')
 regexpi(a,'to')
 regexpi(a,'^to')
 
 vyraz = '^to';
 regexpi(a,vyraz)
 
 regexpi(a,[vyraz '.*'])
 
 b{1} = 'jedna';
 b{2} = 'dva';
 b{3} = 'dvacet';
 i = regexp(b,'a');
 
 % Sekvenování sekvencí akvarijních ryb 
 fMID = AGGCT; %Ve smìru 5->3 forward
 rMID = CAATG; %Ve smìru 5->3 revers 
       % 5' -> 3'
   % AGCCT ATCG CATTG
   % TCCGA TAGC GTAAC
       % 3' -> 5'
       
   % forward MID
   %             revers MID
   
   
   % AGGCT ATCG CATTG
   % CAATG CGAT AGCCT
   
   % (to uprostøed nevíme, to je nìjaká naše sekvence )
   
   % regulárení výraz tedy bude vypadat:                  rc = reverzní komplement
   %                                                      seqrcomplement
   %                                       ^fMID.*rcrMID$
   %                                       ^rMID.*rcfMID$                                       
 
   [h,sek] = fastaread('ryby2.fna'); %Naètení fasta souboru
   sek(1)
   
   fMID = 'ACGAGTGCGT';
   rMID = 'ACGAGTGCGT';
   
   regular_vyraz = [ '^' fMID '.*' seqrcomplement(rMID) '$'];
   i = regexp(sek, regular_vyraz);
   
   isempty(i{1}) % je prázdná 
   
   % Úkol vytvoøit cyklus, abychom projeli každý prvek èíslo i, pokud
   % nebude prázdný tak ji znovu uložit 
   
   sekvence = [];
   index = [];
   
   for j = 1:length(i)
       
       if isempty(i{j}) == 0
          sekvence = [ sekvence, sek(j)];
          index = [index,j];
       end
       
   end
   
   
   
   % DOPLNIT SVISLICI, "NEBO" .... regular_vyraz = [ '^' fMID '.*' seqrcomplement(rMID) '$'];
   regular_vyraz_cely = [ ('^' fMID '.*' seqrcomplement(rMID) '$' | '^' rMID '.*' seqrcomplement(fMID) '$')];
   
   
   
   %Naèítání EXCELU 
   tab = xlsread('ryby2_MIDy.xls');
   %[m,t,r]= xlsread m=matrix, t=text, r= 
   [m,t,r] = xlsread('ryby2_MIDy.xls');
   
   
   %Poslední úkol__________________________________________________________
   %Projet to samé co ted ale z excelu celé a zabalit do funkce 
   
   %Naètení dat
   [m,t,r] = xlsread('ryby2_MIDy.xls');
   [h,sek] = fastaread('ryby2.fna'); %Naètení fasta souboru
   
   sekvence = [];
   index = [];
   Vysledek = [];
   
for k = 2:length(r)      
   fMID = r{k,2};
   rMID = r{k,3};  
   i = sekvenator(fMID,rMID,sek);
      for j = 1:length(i)      
          if isempty(i{j}) == 0
             index = [index,j];
          end 
      end
      Vysledek = [Vysledek, length(index)];
      index = [];
end 
   
   