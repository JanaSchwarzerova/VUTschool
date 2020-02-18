function [mapa] = Aktiv_kontur(Vstup_obraz, pocatecni_maska, max_it)

% Aktiv_kontur je funkce/algoritmus pro segmeta�n� metodu aktivn�ch hranov�ch kontur. 

% Vstup_obraz ... vstupn� obraz, na kter�m se provede segmentace 
% pocatecni_maska ... kter� je ur�ena manu�ln�
% max_it ... maxim�ln� po�et iterac� (��m v�c t�m p�esn�j��, ale pomalej��)
% mapa ... v�stup funkce, tedy mapa, kde je ohrani�ena oblast z�jmu


%% __________________________________________________________________________
% Flexibiln� kontury - Aktivn� hranov� kontury

%************************************************************************** 
% K�d p�evzan� z: 
%     -> https://www.mathworks.com/matlabcentral/fileexchange/19567-active-contour-segmentation?s_tid=srchtitle
%     -> Shawn Lankton

% Tato technika deformuje po��te�n� k�ivku tak, �e odd�luje pop�ed� od pozad� 
% na z�klad� prost�edk� obou oblast�. Technika je velmi robustn� k inicializaci 
% a d�v� velmi p�kn� v�sledky.

%P�eddefinov�n� prom�nn�ch
alpha = 0.2; 
display = true;
mapa = mask2phi(pocatecni_maska); % Vytvo�en� zv�razn�n� mapy z po��te�n� masky
  
%Hlavn� cyklus
for its = 1:max_it   
    idx = find(mapa <= 1.2 & mapa >= -1.2);  %nalezneme k�ivku �zk�ho p�sma
    
    %Nalezen� vn�t�n�ho a vn�j��ho pr�m�ru
    vnejsi_body = find(mapa<=0);           %vn�j�� body
    vnitrni_body = find(mapa>0);           %vn�t�n� body    
    u = sum(Vstup_obraz(vnejsi_body))/(length(vnejsi_body)+ eps);   % vn�t�n�_pr�m�r
    v = sum(Vstup_obraz(vnitrni_body))/(length(vnitrni_body)+ eps); % vn�j�� pr�m�r
                                                            % eps ... relativn� p�esnost prom�nliv�ho bodu    
    F = (Vstup_obraz(idx)-u).^2-(Vstup_obraz(idx)-v).^2;    % s�la/v�ha obrazov� informace
    curvature = get_curvature(mapa,idx);  % s�la od zak�iven� (penalizace)
    dphidt = F./max(abs(F)) + alpha*curvature;  %stoup�n� gradientu pro minimalizaci energie
    
    dt = .45/(max(abs(dphidt))+eps);  %Udr�ov�n� Courant�Friedrichs�Lewy (CFL) stavu
    mapa(idx) = mapa(idx) + dt.*dphidt; %Rozv�jen� k�ivky
    mapa = sussman(mapa, .5); %Udr�uje SDF hladk� 
                              % SDF =  the Shape Diameter Function
    %Prost�edn� v�stup
%     if((display>0)&&(mod(its,20) == 0)) 
%       showCurveAndPhi(Vstup_obraz,mapa,its);  
%     end
end
  
  %Vytvo�en� masky pro SDF
  seg = mapa<=0; % Z�sk�n� masky z nastaven� �rovn�
  

%__________________________POMOCN� FUNKCE _________________________________

%Zobrazen�
% function showCurveAndPhi(Vystup, phi, i)
%   imshow(Vstup_obraz,'initialmagnification',200,'displayrange',[0 255]); hold on;
%   contour(phi, [0 0], 'g','LineWidth',4);
%   contour(phi, [0 0], 'k','LineWidth',2);
%   hold off; title([num2str(i) ' Iterations']); drawnow;
  
%P�evede masku na SDF
function phi = mask2phi(init_a)
  phi=bwdist(init_a)-bwdist(1-init_a)+im2double(init_a)-.5;
  
%Vypo��t� zak�iven� pod�l SDF
function zakriveni = get_curvature(phi,idx)
    [dimy, dimx] = size(phi);        
    [y x] = ind2sub([dimy,dimx],idx);  % z�sk�n� p��slu�n�ch index�

    %z�sk�n� doln�ch index� soused�
    ym1 = y-1; xm1 = x-1; yp1 = y+1; xp1 = x+1;

    %Kontrola hranic
    ym1(ym1<1) = 1; xm1(xm1<1) = 1;              
    yp1(yp1>dimy)=dimy; xp1(xp1>dimx) = dimx;    

    %Z�k�n� index� pro 8 soused�
    idup = sub2ind(size(phi),yp1,x);    
    iddn = sub2ind(size(phi),ym1,x);
    idlt = sub2ind(size(phi),y,xm1);
    idrt = sub2ind(size(phi),y,xp1);
    idul = sub2ind(size(phi),yp1,xm1);
    idur = sub2ind(size(phi),yp1,xp1);
    iddl = sub2ind(size(phi),ym1,xm1);
    iddr = sub2ind(size(phi),ym1,xp1);
    
    %Z�sk�n� centr�ln�ch deriv�t� SDF na x, y
    phi_x  = -phi(idlt)+phi(idrt);
    phi_y  = -phi(iddn)+phi(idup);
    phi_xx = phi(idlt)-2*phi(idx)+phi(idrt);
    phi_yy = phi(iddn)-2*phi(idx)+phi(idup);
    phi_xy = -0.25*phi(iddl)-0.25*phi(idur)...
             +0.25*phi(iddr)+0.25*phi(idul);
    phi_x2 = phi_x.^2;
    phi_y2 = phi_y.^2;
    
    %V�po�et zak�iven� (Kappa)
    zakriveni = ((phi_x2.*phi_yy + phi_y2.*phi_xx - 2*phi_x.*phi_y.*phi_xy)./...
              (phi_x2 + phi_y2 +eps).^(3/2)).*(phi_x2 + phi_y2).^(1/2);        

%Na �rovni re-inicializace pomoc� sussman method
function D = sussman(D, dt)
  % dop�edu/dozadu rozd�ly (diference)
  a = D - shiftR(D); % zp�t
  b = shiftL(D) - D; % vp�ed
  c = D - shiftD(D); % zp�t
  d = shiftU(D) - D; % vp�ed
  
  a_p = a;  a_n = a; % a+ and a-
  b_p = b;  b_n = b;
  c_p = c;  c_n = c;
  d_p = d;  d_n = d;
  
  a_p(a < 0) = 0;
  a_n(a > 0) = 0;
  b_p(b < 0) = 0;
  b_n(b > 0) = 0;
  c_p(c < 0) = 0;
  c_n(c > 0) = 0;
  d_p(d < 0) = 0;
  d_n(d > 0) = 0;
  
  dD = zeros(size(D));
  D_neg_ind = find(D < 0);
  D_pos_ind = find(D > 0);
  dD(D_pos_ind) = sqrt(max(a_p(D_pos_ind).^2, b_n(D_pos_ind).^2) ...
                       + max(c_p(D_pos_ind).^2, d_n(D_pos_ind).^2)) - 1;
  dD(D_neg_ind) = sqrt(max(a_n(D_neg_ind).^2, b_p(D_neg_ind).^2) ...
                       + max(c_n(D_neg_ind).^2, d_p(D_neg_ind).^2)) - 1;
  
  D = D - dt .* sussman_sign(D) .* dD;
  
%Cel� maticov� derivace
function shift = shiftD(M)
  shift = shiftR(M')';

function shift = shiftL(M)
  shift = [ M(:,2:size(M,2)) M(:,size(M,2)) ];

function shift = shiftR(M)
  shift = [ M(:,1) M(:,1:size(M,2)-1) ];

function shift = shiftU(M)
  shift = shiftL(M')';
  
function S = sussman_sign(D)
  S = D ./ sqrt(D.^2 + 1);    


