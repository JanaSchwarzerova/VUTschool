function [Vstup_obraz] = Osetreni_obr(Obr)

% Osetreni_obr je funkce, ve které jsou ošetøeny obrazy vùèi spravnému
% formátu
% Obr ... vstupní obraz libovolného formátu
% Vstup_obraz .. obraz ve správném formátu do následujícího zpracování

%Ošetøení vùèi 3D obrázkùm
          if ndims(Obr)== 3            % ndims – urèí dimenzi Obr
          Vstup_obraz = rgb2gray(Obr); % Pøevedení obrázku na šedotonovy
          elseif ndims(Obr)== 2
          Vstup_obraz = Obr; 
          end
          
%Ošetøení vùèi správnému formátu vložených dat
          typ = class(Vstup_obraz);
          switch typ 
              case 'double'
              Rozmery = size(Vstup_obraz);
              for i = 1:Rozmery(1)           %for cyklus po projetí celého obrazu na šíøku
                  for j = 1:Rozmery(2)       %for cyklus po projetí celého obrazu na délku
                      if Vstup_obraz(i,j)>1  %špatnì naformátovné data
                         Vstup_obraz =(Vstup_obraz)./255;
                      end
                  end
              end
              otherwise
              Vstup_obraz = im2double(Vstup_obraz);
   
          end
