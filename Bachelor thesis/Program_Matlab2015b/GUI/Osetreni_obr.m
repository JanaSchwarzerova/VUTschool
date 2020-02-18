function [Vstup_obraz] = Osetreni_obr(Obr)

% Osetreni_obr je funkce, ve kter� jsou o�et�eny obrazy v��i spravn�mu
% form�tu
% Obr ... vstupn� obraz libovoln�ho form�tu
% Vstup_obraz .. obraz ve spr�vn�m form�tu do n�sleduj�c�ho zpracov�n�

%O�et�en� v��i 3D obr�zk�m
          if ndims(Obr)== 3            % ndims � ur�� dimenzi Obr
          Vstup_obraz = rgb2gray(Obr); % P�eveden� obr�zku na �edotonovy
          elseif ndims(Obr)== 2
          Vstup_obraz = Obr; 
          end
          
%O�et�en� v��i spr�vn�mu form�tu vlo�en�ch dat
          typ = class(Vstup_obraz);
          switch typ 
              case 'double'
              Rozmery = size(Vstup_obraz);
              for i = 1:Rozmery(1)           %for cyklus po projet� cel�ho obrazu na ���ku
                  for j = 1:Rozmery(2)       %for cyklus po projet� cel�ho obrazu na d�lku
                      if Vstup_obraz(i,j)>1  %�patn� naform�tovn� data
                         Vstup_obraz =(Vstup_obraz)./255;
                      end
                  end
              end
              otherwise
              Vstup_obraz = im2double(Vstup_obraz);
   
          end
