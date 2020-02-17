clear all; close all; clc
%% Projekt �. 10 Detekce na normalizovan�ch datech pomoc� l�cov�n�
Shoda = 0;
Neshoda = 0;

for i = 1:224
   for n =1:4
        %Na��t�n� obraz�
        if i < 10
           I1 = imread(['00',num2str(i),'_',num2str(n),'.bmp']);
        elseif i < 100
           I1 = imread(['0',num2str(i),'_',num2str(n),'.bmp']); 
        else
           I1 = imread([num2str(i),'_',num2str(n),'.bmp']);  
        end
        
        %V�dy posledn� obraz v s�rii, bereme jako referne�n�
        if i < 10
           I2 = imread(['00',num2str(i),'_5.bmp']);
        elseif i < 100
           I2 = imread(['0',num2str(i),'_5.bmp']); 
        else
           I2 = imread([num2str(i),'_5.bmp']);  
        end
        
%% L�cov�n�
    [matchedPoints1,matchedPoints2] = funkce_licovani(I1,I2);

%% ROZHODOVAC� PRAVIDLO PRO DETEKCI ***************************************
        if matchedPoints1.Count>=5
        % Jestli�e bude po�et nalezen�ch shodn�ch bod� v�t�� nebo roven 5, nalezli
        % jsme shodu - oko stejn�ho �lov�ka; 
        % pokud ne, shoda nebyla nalezena a o�i jsou od dvou r�zn�ch lid�  
         Shoda = Shoda +1;
        else
         Neshoda = Neshoda +1;    
        end
        
    end 
end

disp(['Po�et spr�vn� detekce je roven ',num2str(Shoda), ' fale�n� negativn�ch ',num2str(Neshoda)])


%% V�po�et senzitivity testu

senzitivita = (Shoda + Neshoda)/((Shoda + Neshoda)+Neshoda);

disp(['Sezitivita detektoru vy�la: ', num2str(senzitivita)])