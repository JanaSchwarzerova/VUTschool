clear all; close all; clc;
%% Vykreslení Trajektorie pohybu pro jednu buòku 
%  Vývoj kulovitosti a velikosti plochy buòky

stat = {};
for k = 3:39
    if k < 10
    obr = imread(['MSC-CMFDA-migrace-6h-23-1-2018.lif_Series011_t0', num2str(k),'_z2_ch00.tif']); 
    obr = imcrop(obr,[674 347 392 451]); %Oøíznutí jedné vybrané buòky
    level = graythresh(obr); BW = im2bw(obr,level); %Segmentace pomocí graythresh
    %BW = ukol1_fce( obr ); %Možnosti vyzkoušení segmentace pomocí ukol1_fce
    %BW = ukol2_fce(obr);   %Možnosti vyzkoušení segmentace pomocí ukol2_fce (POZOR! Fce na nìkterých verzích matlabu nejedou)    
    stats = regionprops('table',BW,'Centroid','Area','Eccentricity');    
    stat = [stat {stats}];
    figure(1)
    imshow(obr) 
    else       
    obr = imread(['MSC-CMFDA-migrace-6h-23-1-2018.lif_Series011_t', num2str(k) ,'_z2_ch00.tif']); 
    obr = imcrop(obr,[674 347 392 451]); %Oøíznutí jedné vybrané buòky
    level = graythresh(obr); BW = im2bw(obr,level); %Segmentace pomocí graythresh
    %BW = ukol1_fce( obr ); %Možnosti vyzkoušení segmentace pomocí ukol1_fce
    %BW = ukol2_fce(obr);   %Možnosti vyzkoušení segmentace pomocí ukol2_fce (POZOR! Fce na nìkterých verzích matlabu nejedou) 
    stats = regionprops('table',BW,'Centroid','Area','Eccentricity');
    stat = [stat {stats}];
    figure(1)
    imshow(obr) 
    end
end

%Vybrání maximální buòky v obraze
for i = 1:37
    Area = stat{1, i}.Area(:);
    [~, pozice1]= max(Area);
    pom_Area(i) = max(Area); %Velikost plochy buòky 
    Eccentricity(i) = stat{1, i}.Eccentricity(pozice1); %Kulovitost buòky 
    bod1(i,:) = stat{1, i}.Centroid(pozice1,:);
end

% Vykreslení trajektorie
figure(1)
imshow(obr)    
hold on 
plot(bod1(:,1),bod1(:,2),'bx')
title('Vykreslení trajektorie pohybu buòky')
hold off

%  Vývoj kulovitosti a velikosti plochy buòky
figure(2)
plot([1:1:37],pom_Area,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
hold on 
ylabel('Plocha buòky [px]')
xlabel('Poøadí snímku [–]')
title('Vykreslení velikosti plochy buòky')
hold off

figure(3)
plot([1:1:37],Eccentricity,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
hold on 
ylabel('Kolovitost [–]')
xlabel('Poøadí snímku [–]')
title('Vykreslení velikosti Kulovitosti buòky')
hold off