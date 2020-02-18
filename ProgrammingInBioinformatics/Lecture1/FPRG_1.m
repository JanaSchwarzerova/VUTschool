%% Regul�rn� v�razy
% TEORIE
% Regul�rn� v�raz dok�e podchytit hodn� podm�nky (p��klad v�b�r pacientu se za��te�n�m p�smenem S)
% atd. v jednom v�razu
% v R grep; v Matlabu regexp
% Na elearningu je odkaz  (vyukov� materi�l) na str�nky + shrnut� v pdf
% V podstat� je regul�rn� v�raz �et�zec, a v tom �et�zci jsou jednotliv�
% znaky, kter� maj� n�jak� v�znam.. 
% v�t�ina funkc� je case senstive (rozli�uje velk� mal� p�smena)

% abc       efabc2a -> v�sledek z grep by byl 4
% . libovoln� znak a.c -> abc, a2c, axc, a_c
% ^ za��tek ^a. 
% $         a$  ^a$
% *     � vstahuje se na jeden znak p�edt�m 
%       p�. ^a.*  -> a, ab, abb, ac2
% +     p�. ^a.+  -> ab, ac, axx ...
% ?     p�. ^a.?  -> a, ax, a3

%{n}   ^a.{2
%{m,n} {m,} minim�ln�; {,n} maxim�ln�
% []   [abc]

% ^P[aeiou].+ova$ ... rozk�duj: Budu hledat slova, mus� za��nat p�smenem P
%                               

% seznamy: 
% [a-z][A-Z] [0-9]
% [^ ] ... seznam toho, co nechci aby tam bylo 
% [1-9] [0-9] (1-99 pomoc� ?... [1-9][0-9]?)
%    10-99

% libovoln� t�i znaky ^.{3}$
% [a-z A-Z 0-9]
% ^ko[sz].*              kos, kost, kosa, koza
% (ba)* pokud m�m speci�ln� v�raz, t�eba * a chci aby se to stahovalo k
%  v�ce znak�m, d�m je do kulat�ch z�vorek
%  p�. (ab){3} ababab

%  NEBO ...  ^P.{3}|^S.{4}
%             (a|b)
%             [ab]
%             (abc|efg)

% \ je p�edznakem, kter� n�jak modifikuje jeho v�znam 
%                 p��klad. \?
%                          \.
%                          \n 

% P��klady:  

% ^AT.*A{2,4}.*[CG]$     ATAAC
%                            G
%                        ATCAGAAAACTG

% ^C.*(TAC){2}A+[^CT].*(AAC|AAG)$   CTACTACAGAAC

%PRAKTICK� ��ST
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
 
 % Sekvenov�n� sekvenc� akvarijn�ch ryb 
 fMID = AGGCT; %Ve sm�ru 5->3 forward
 rMID = CAATG; %Ve sm�ru 5->3 revers 
       % 5' -> 3'
   % AGCCT ATCG CATTG
   % TCCGA TAGC GTAAC
       % 3' -> 5'
       
   % forward MID
   %             revers MID
   
   
   % AGGCT ATCG CATTG
   % CAATG CGAT AGCCT
   
   % (to uprost�ed nev�me, to je n�jak� na�e sekvence )
   
   % regul�ren� v�raz tedy bude vypadat:                  rc = reverzn� komplement
   %                                                      seqrcomplement
   %                                       ^fMID.*rcrMID$
   %                                       ^rMID.*rcfMID$                                       
 
   [h,sek] = fastaread('ryby2.fna'); %Na�ten� fasta souboru
   sek(1)
   
   fMID = 'ACGAGTGCGT';
   rMID = 'ACGAGTGCGT';
   
   regular_vyraz = [ '^' fMID '.*' seqrcomplement(rMID) '$'];
   i = regexp(sek, regular_vyraz);
   
   isempty(i{1}) % je pr�zdn� 
   
   % �kol vytvo�it cyklus, abychom projeli ka�d� prvek ��slo i, pokud
   % nebude pr�zdn� tak ji znovu ulo�it 
   
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
   
   
   
   %Na��t�n� EXCELU 
   tab = xlsread('ryby2_MIDy.xls');
   %[m,t,r]= xlsread m=matrix, t=text, r= 
   [m,t,r] = xlsread('ryby2_MIDy.xls');
   
   
   %Posledn� �kol__________________________________________________________
   %Projet to sam� co ted ale z excelu cel� a zabalit do funkce 
   
   %Na�ten� dat
   [m,t,r] = xlsread('ryby2_MIDy.xls');
   [h,sek] = fastaread('ryby2.fna'); %Na�ten� fasta souboru
   
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
   
   