clear all 
close all 
clc 

%% Vykreslen� pomocn�ho grafu intenzit jednotliv�ch obraz� v sekvenci

% %load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
% load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') 
% %load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') 
% 
% Obr = data1{105};
% %O�et�en� v��i 3D obraz�m a spr�vn�mu form�tov�n�  
% [Obr] = Osetreni_obr(Obr);
% mask = roipoly(Obr);
% 
%   for i=1:length(data1)
%       obr = data1{i}; %mo�nost zadat i data2{}
%       [obr] = Osetreni_obr(obr);
%       obr = obr*255;
% 
%       prumer_jas(i)= (sum(sum(obr.*mask)));                   %Pr�m�rn� intenzite jasu
%       vysledek_intenzita(i) = prumer_jas(i)/(sum(sum(mask))); %vyd�len� po�tem pixel� v masce
%   end
% 
%   figure
%   plot(vysledek_intenzita)
%   xlabel('Po�ad� obrazu v sekvenci v �ase')
%   ylabel('Pr�m�rn� intenzita jasu v oblast z�jmu')
% 
% %Ulo�eni grafu:
% %   print('Graf_intenzit.png','-dpng','-r300') 
  
%% Mo�nost vykreslen� v�ech v sekvenc� do jednoho grafu: 
load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 

Obr1 = data1{105};
%O�et�en� v��i 3D obraz�m a spr�vn�mu form�tov�n�  
[Obr1] = Osetreni_obr(Obr1);
mask1 = roipoly(Obr1);

  for i=1:length(data1)
      obr = data1{i}; %mo�nost zadat i data2{}
      [obr] = Osetreni_obr(obr);
      obr = obr*255;

      prumer_jas1(i)= (sum(sum(obr.*mask1)));                    %Pr�m�rn� intenzite jasu
      vysledek_intenzita1(i) = prumer_jas1(i)/(sum(sum(mask1))); %vyd�len� po�tem pixel� v masce
  end
  
Obr2 = data2{105};
%O�et�en� v��i 3D obraz�m a spr�vn�mu form�tov�n�  
[Obr2] = Osetreni_obr(Obr2);
mask2 = roipoly(Obr2);

  for i=1:length(data2)
      obr = data2{i}; %mo�nost zadat i data2{}
      [obr] = Osetreni_obr(obr);
      obr = obr*255;

      prumer_jas2(i)= (sum(sum(obr.*mask2)));                    %Pr�m�rn� intenzite jasu
      vysledek_intenzita2(i) = prumer_jas2(i)/(sum(sum(mask2))); %vyd�len� po�tem pixel� v masce
  end
  
load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') 

Obr3 = data1{105};
%O�et�en� v��i 3D obraz�m a spr�vn�mu form�tov�n�  
[Obr3] = Osetreni_obr(Obr3);
mask3 = roipoly(Obr3);

  for i=1:length(data1)
      obr = data1{i}; %mo�nost zadat i data2{}
      [obr] = Osetreni_obr(obr);
      obr = obr*255;

      prumer_jas3(i)= (sum(sum(obr.*mask3)));                    %Pr�m�rn� intenzite jasu
      vysledek_intenzita3(i) = prumer_jas3(i)/(sum(sum(mask3))); %vyd�len� po�tem pixel� v masce
  end

Obr4 = data2{105};
%O�et�en� v��i 3D obraz�m a spr�vn�mu form�tov�n�  
[Obr4] = Osetreni_obr(Obr4);
mask4= roipoly(Obr4);

  for i=1:length(data2)
      obr = data2{i}; %mo�nost zadat i data2{}
      [obr] = Osetreni_obr(obr);
      obr = obr*255;

      prumer_jas4(i)= (sum(sum(obr.*mask4)));                    %Pr�m�rn� intenzite jasu
      vysledek_intenzita4(i) = prumer_jas4(i)/(sum(sum(mask4))); %vyd�len� po�tem pixel� v masce
  end
  
load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') 

Obr5 = data1{105};
%O�et�en� v��i 3D obraz�m a spr�vn�mu form�tov�n�  
[Obr5] = Osetreni_obr(Obr5);
mask5 = roipoly(Obr5);

  for i=1:length(data1)
      obr = data1{i}; %mo�nost zadat i data2{}
      [obr] = Osetreni_obr(obr);
      obr = obr*255;

      prumer_jas5(i)= (sum(sum(obr.*mask5)));                    %Pr�m�rn� intenzite jasu
      vysledek_intenzita5(i) = prumer_jas5(i)/(sum(sum(mask5))); %vyd�len� po�tem pixel� v masce
  end

Obr6 = data2{105};
%O�et�en� v��i 3D obraz�m a spr�vn�mu form�tov�n�  
[Obr6] = Osetreni_obr(Obr6);
mask6 = roipoly(Obr6);

  for i=1:length(data2)
      obr = data2{i}; %mo�nost zadat i data2{}
      [obr] = Osetreni_obr(obr);
      obr = obr*255;

      prumer_jas6(i)= (sum(sum(obr.*mask6)));                    %Pr�m�rn� intenzite jasu
      vysledek_intenzita6(i) = prumer_jas6(i)/(sum(sum(mask6))); %vyd�len� po�tem pixel� v masce
  end
  
% Vykreslen�: 
  figure
  plot(vysledek_intenzita1)
  xlabel('Po�ad� obrazu v sekvenci v �ase')
  ylabel('Pr�m�rn� intenzita jasu v oblast z�jmu')
  hold on
  plot(vysledek_intenzita2)
  plot(vysledek_intenzita3)
  plot(vysledek_intenzita4)
  plot(vysledek_intenzita5)
  plot(vysledek_intenzita6)
  hold off