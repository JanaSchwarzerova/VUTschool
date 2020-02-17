clear all; close all; clc;
%% Vykreslen� Trajektorie pohybu pro jednu bu�ku 
%  V�voj kulovitosti a velikosti plochy bu�ky

stat = {};
for k = 3:39
    if k < 10
    obr = imread(['MSC-CMFDA-migrace-6h-23-1-2018.lif_Series011_t0', num2str(k),'_z2_ch00.tif']); 
    obr = imcrop(obr,[674 347 392 451]); %O��znut� jedn� vybran� bu�ky
    level = graythresh(obr); BW = im2bw(obr,level); %Segmentace pomoc� graythresh
    %BW = ukol1_fce( obr ); %Mo�nosti vyzkou�en� segmentace pomoc� ukol1_fce
    %BW = ukol2_fce(obr);   %Mo�nosti vyzkou�en� segmentace pomoc� ukol2_fce (POZOR! Fce na n�kter�ch verz�ch matlabu nejedou)    
    stats = regionprops('table',BW,'Centroid','Area','Eccentricity');    
    stat = [stat {stats}];
    figure(1)
    imshow(obr) 
    else       
    obr = imread(['MSC-CMFDA-migrace-6h-23-1-2018.lif_Series011_t', num2str(k) ,'_z2_ch00.tif']); 
    obr = imcrop(obr,[674 347 392 451]); %O��znut� jedn� vybran� bu�ky
    level = graythresh(obr); BW = im2bw(obr,level); %Segmentace pomoc� graythresh
    %BW = ukol1_fce( obr ); %Mo�nosti vyzkou�en� segmentace pomoc� ukol1_fce
    %BW = ukol2_fce(obr);   %Mo�nosti vyzkou�en� segmentace pomoc� ukol2_fce (POZOR! Fce na n�kter�ch verz�ch matlabu nejedou) 
    stats = regionprops('table',BW,'Centroid','Area','Eccentricity');
    stat = [stat {stats}];
    figure(1)
    imshow(obr) 
    end
end

%Vybr�n� maxim�ln� bu�ky v obraze
for i = 1:37
    Area = stat{1, i}.Area(:);
    [~, pozice1]= max(Area);
    pom_Area(i) = max(Area); %Velikost plochy bu�ky 
    Eccentricity(i) = stat{1, i}.Eccentricity(pozice1); %Kulovitost bu�ky 
    bod1(i,:) = stat{1, i}.Centroid(pozice1,:);
end

% Vykreslen� trajektorie
figure(1)
imshow(obr)    
hold on 
plot(bod1(:,1),bod1(:,2),'bx')
title('Vykreslen� trajektorie pohybu bu�ky')
hold off

%  V�voj kulovitosti a velikosti plochy bu�ky
figure(2)
plot([1:1:37],pom_Area,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
hold on 
ylabel('Plocha bu�ky [px]')
xlabel('Po�ad� sn�mku [�]')
title('Vykreslen� velikosti plochy bu�ky')
hold off

figure(3)
plot([1:1:37],Eccentricity,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
hold on 
ylabel('Kolovitost [�]')
xlabel('Po�ad� sn�mku [�]')
title('Vykreslen� velikosti Kulovitosti bu�ky')
hold off