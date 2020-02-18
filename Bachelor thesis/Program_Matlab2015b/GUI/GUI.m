function varargout = GUI(varargin)
% GUI MATLAB k�d pro GUI.fig
%      GUI, s�m o sob� vytv��� nov� grafick� u�ivatelsk� rozhran� 
%
%      H = GUI vr�t� "handle" k nov�mu GUI nebo "handle" k existuj�c�
%      jednotce/prom�nn�
%
%      GUI('CALLBACK',hObject,eventData,handles,...) zavol�n� lok�ln�
%      funkce jm�nem CALL BACK V GUI.M s dan�mi vstupn�mi argumenty
%
%      GUI('Property','Value',...) vytvo�� nov� GUI nebo zavede
%      existuj�c� jedntoku/prom�nou. Za��na z leva, vlastnosti/hodnoty argument� 
%      jsou aplikov�ny do GUI p�ed GUI_OpeningFcn z�skan� zavol�n�m.
%      Nerozpoznan� vlastnosti jmena nebo neplatn� hodnoty vytv���
%      vlastnosti stopov�ch aplikac� (chybov�ch hl�ek).
%      V�echny vstupy jsou p�ed�v�ny do GUI_OpeningFcn p�es varargin.
%
% Posledn� �pravy: v GUIDE 14-04-2018 10:57:39

%Za��tek inicializa�n�ho k�du � NEUPRAVOVAT: 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
%Konce inicializa�n�ho k�du.


% Spust� se t�sn� p�edt�m, ne� je grafick� u�ivatelsk� rozhran� viditeln�.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Tato funkce nem� v�stupn� argumenty, viz OutputFcn.
% hObject    "handle" k zobrazen�
% eventdata  reserved - kter� budou definov�ny v budouc� verzi MATLABu
% handles    struktura s "handles" a u�ivatelsk� data (viz GUIDATA)
% varargin   argumenty p��kazov�ch ��dk� k GUI (viz VARARGIN)

% Zvolen� v�choz�ho v�stupu p��kazov�ho ��dku pro GUI
handles.output = hObject;

handles.pom_vyber_metody = 0;    %Pomocn� pro v�b�r segmenta�n� metody
handles.pom_vyber_filtr = 0;     %Pomocn� pro v�b�r filtrace
handles.pom_vyber_dat = 0;       %Pomocn� pro v�b�r vstupn�ch dat
handles.pom = 0;                 %Pomocn� pro o�et�en�, aby v�dy byly vlo�eny vstupn� data
handles.Vstupni_data =[];        %P�eddefinovan� prom�nn� pro vstupn� data
handles.vyber_filtr = 0;         %P�eddefinovan� prom�nn� pro v�b�r filtru

%Aktualizace; popisuj�c� strukturu:
guidata(hObject, handles); 

% UIWAIT d�l� GUI �ekat na odpov�� u�ivatele (viz UIRESUME)
% uiwait(handles.figure1);

% --- V�stupy z t�to funkce se vr�t� do p��kazov�ho ��dku.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  bun��n� pole pro n�vrat v�stupn�ch argument� (viz VARARGOUT);
% hObject    "handle" k zobrazen�
% eventdata  reserved - kter� budou definov�ny v budouc� verzi MATLABu
% handles    struktura s "handles" a u�ivatelsk� data (viz GUIDATA)

% Z�sk�n� v�choz�ho v�stupu p��kazov�ho ��dku ze struktury �chyt�
varargout{1} = handles.output;

%**************************************************************************
%_______________________________Filtrace___________________________________

% Provede p�i zm�n� v�b�ru v souboru:  vybrat_filtr
function vybrat_filtr_Callback(hObject, eventdata, handles)

handles.vyber_filtr = get(hObject,'Value'); %Vybere se konkr�tn� typ filtrace pomoc� "Pop-up Menu"

%Hodnota filtrovac�ho okna (tato hodnota se nastavuje stejn� pro v�echny filtry)
%defuatn� nastaven� na hodnot� 5 v GUI se d� ov�em i p�epsat 
x = get(handles.filtr_okno,'string'); 
x = str2num(x);

switch handles.vyber_filtr
     case 1 %Bez filtrace..................................................
       
       %Zneviditeln�ch zbyte�n�ch argument� pro tuto akci: 
       set(handles.filtr_okno_text,'visible','off') 
       set(handles.filtr_okno,'visible','off')
       set(handles.text_median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','off')
       set(handles.filtr_button,'visible','off');
       
       %Na�ten� obr�zku bez filtrace        
       bez_filtr = imread('GUI_bez_filtrace.png');  
       axes(handles.Filtr_obr)
       imshow(bez_filtr)  
       handles.Filtr_data = handles.Vstupni_data; 
       
       %Filtr nebyl pou�it� � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne        
       handles.pom_vyber_filtr = 0; 
        
     case 2 %Medi�nov� filtr...............................................
       
       %Zviditeln�n� vstupn�ho okna do filtru, hodnota je defuatln�
       %nastaven� na 5; v GUI se d� ov�em i p�epsat
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')
       set(handles.filtr_button,'visible','on');
                 
        if handles.pom == 1 %Pokud byly na�teny vstupn� data, provede se medi�nov� filtrace
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1 %Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                              %pro bezchybn� zobrazen�
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data,[])                    
        else %Pokud nebyla na�ten� ��dn� vstupn� data, vyhod� se chybov� hl�ka
            errordlg('CHYBA - zkontroluj zda m� vybran� vstupn� data','Chyba!')    
        end
        
        %Zobrazen� popisku dole, pro ov��en�, �e cyklus dojel
        set(handles.text_Lee,'visible','off')
        set(handles.text_Frost,'visible','off')                
        set(handles.text_median,'visible','on')
        
        %Byl pou�it� Median_filtr � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne 
        handles.pom_vyber_filtr = 1; 
                
     case 3 %Lee filtr.....................................................
         
        %Zviditeln�n� vstupn�ho okna do filtru, hodnota je defuatln�
        %nastaven� na 5; v GUI se d� ov�em i p�epsat         
        set(handles.filtr_okno_text,'visible','on') 
        set(handles.filtr_okno,'visible','on') 
        set(handles.filtr_button,'visible','on');     
        
        if handles.pom == 1 %Pokud byly na�teny vstupn� data, provede se Lee filtrace
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                             %pro bezchybn� zobrazen�
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data,[])        
        else %Pokud nebyla na�ten� ��dn� vstupn� data, vyhod� se chybov� hl�ka
            errordlg('CHYBA - zkontroluj zda m� vybran� vstupn� data','Chyba!')    
        end
        
        %Zobrazen� popisku dole, pro ov��en�, �e cyklus dojel        
        set(handles.text_median,'visible','off')
        set(handles.text_Frost,'visible','off')
        set(handles.text_Lee,'visible','on')

        %Byl pou�it� Lee filtr � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne       
        handles.pom_vyber_filtr = 2; 
        
     case 4 %Frost filtr...................................................

       %Zviditeln�n� vstupn�ho okna do filtru, hodnota je defuatln�
       %nastaven� na 5; v GUI se d� ov�em i p�epsat  
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')  
       set(handles.filtr_button,'visible','on');
       
       if handles.pom == 1 %Pokud byly na�teny vstupn� data, provede se Frost filtrace
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data)
       elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                            %pro bezchybn� zobrazen� 
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data,[])        
       else  %Pokud nebyla na�ten� ��dn� vstupn� data, vyhod� se chybov� hl�ka
          errordlg('CHYBA - zkontroluj zda m� vybran� vstupn� data','Chyba!')    
       end  

       %Zobrazen� popisku dole, pro ov��en�, �e cyklus dojel  
       set(handles.text_median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','on')    

       %Byl pou�it� Frost filtr � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne 
       handles.pom_vyber_filtr = 3; 
        
otherwise %Pokud se vybere cokoli jin�ho, v tomto p��pad� sp�e nevybere
       
       %Nezobraz� se ��dn� texty ani "edit"
       set(handles.filtr_okno_text,'visible','off') 
       set(handles.filtr_okno,'visible','off')
       set(handles.text_Median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','off') 
       set(handles.filtr_button,'visible','off');
       
       %Filtr nebyl pou�it� � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne     
       handles.pom_vyber_filtr = 0;    
       
end
         
guidata(hObject, handles)

% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function vybrat_filtr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
%____________________________Vybr�n� dat___________________________________
% Provede se p�i zm�n� v�b�ru v vybrat_data.
function vybrat_data_Callback(hObject, eventdata, handles)

vyber_dat = get(hObject,'Value'); %Vybere se konkr�tn� typ dat pomoc� "Pop-up Menu"
axes(handles.Vstupni_obraz) %Data se zobraz� na "Axes" co nejv�c vlevo

switch vyber_dat 
     case 1 %Bez dat.......................................................
       
      %Pokud u�ivatel d� bez dat, vyjede mu varov�n�, �e nejsou vybr�na ��dn� data
      warndlg('Nejsou vybr�na vstupn� data','Varov�n�')
       
      %Pomocn� pro v�ber vstupn�ch dat � nejsou vybr�na ��dn� data (pro pozd�j�� o�et�en�)
      handles.pom_vyber_dat = 0;
       
      %Zneviditeln�n� pomocn�ch tla��tek pro segmentov�n� metodou prahov�n�
      set(handles.jedno_prah,'visible','off')
      set(handles.gray_prah,'visible','off')
      set(handles.dvoj_prah,'visible','off')
      %Zneviditeln�n� parametr� pro Rozvod�
      set(handles.sobel,'visible','off')
      set(handles.robin,'visible','off')
      set(handles.prewitt,'visible','off')
              
     case 2 %Um�l� obraz...................................................
        
      %Pomocn� pro v�ber vstupn�ch dat � je vybr�n um�l� obraz (pro pozd�j�� o�et�en�)  
      handles.pom_vyber_dat = 1; 
       
      %Um�l� obraz byl vytvo�en pro r�zn� metody r�zn�, tak aby na n�m
      %bylo vid�t co nejoptim�ln�ji funk�nost algoritmu
      if handles.pom_vyber_metody == 2; % Um�l� obraz pro PRAHOV�N�
          handles.Vstupni_data = imread('obr_prahovani_1.png'); %Na�ten� obrazu
          imshow(handles.Vstupni_data)
          [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
          handles.pom = 1; %Pro pozd�j�� o�et�en�, jestli existuj� n�jak� vstupn� data a program m��e 
                           %v po��dku pokra�ovat 

          %Pou�it� filtrace po zm�n�n� vstupn�ch dat, aby se zobrazila v GUI
          x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
          x = str2num(x);
          if handles.pom_vyber_filtr == 1 %Medianov� filtrace
             handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
             axes(handles.Filtr_obr)
             imshow(handles.Filtr_data)    
          elseif handles.pom_vyber_filtr == 2 %Lee
             handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
             axes(handles.Filtr_obr)
             imshow(handles.Filtr_data)                
          elseif handles.pom_vyber_filtr == 3 %Frost
             handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
             axes(handles.Filtr_obr)
             imshow(handles.Filtr_data)                
          end 
          
          % Defuatln� nastaven� doporu�en� hodnoty pro segmentaci metodou
          % prahov�n� na um�le vytvo�en�ch obr�zc�ch
          % pozd�j�� vyu�it� t�chto hodnot bude ve funkci "Segmentace"
          if handles.pom_vyber_metody == 2;
          set(handles.hodnota_Prah,'Value',130) 
          set(handles.hodnota_Prah,'String','130') 
          set(handles.hodnota_PrahD,'Value',20) 
          set(handles.hodnota_PrahD,'String','20') 
          set(handles.hodnota_PrahH,'Value',200) 
          set(handles.hodnota_PrahH,'String','200') 
          set(handles.Prah,'Value',130)   
          set(handles.PrahD,'Value',20)  
          set(handles.PrahH,'Value',200)
          end
          
      elseif handles.pom_vyber_metody == 3; %Um�l� obraz pro NAR�ST�N� OBLAST�
          handles.Vstupni_data = imread('obr_narustani_oblasti.png'); %Na�ten� obrazu 
          imshow(handles.Vstupni_data)
          [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
          handles.pom = 1; %Pro pozd�j�� o�et�en�, jestli existuj� n�jak� vstupn� data a program m��e 
                           %v po��dku pokra�ovat
                                 
          %Pou�it� filtrace po zm�n�n� vstupn�ch dat, aby se zobrazila v GUI
          x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
          x = str2num(x);
          if handles.pom_vyber_filtr == 1 %Medianov� filtrace
             handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
             axes(handles.Filtr_obr)
             imshow(handles.Filtr_data)    
          elseif handles.pom_vyber_filtr == 2 %Lee
             handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
             axes(handles.Filtr_obr)
             imshow(handles.Filtr_data)                
          elseif handles.pom_vyber_filtr == 3 %Frost
             handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
             axes(handles.Filtr_obr)
             imshow(handles.Filtr_data)                
          end
       elseif handles.pom_vyber_metody == 4; %Um�l� obraz pro ROZVOD�
           handles.Vstupni_data = imread('obr_rozvodi_2.png'); %Na�ten� obrazu
           imshow(handles.Vstupni_data)
           [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
           handles.pom = 1; %Pro pozd�j�� o�et�en�, jestli existuj� n�jak� vstupn� data a program m��e 
                            %v po��dku pokra�ovat
                                 
           %Pou�it� filtrace po zm�n�n� vstupn�ch dat, aby se zobrazila v GUI
           x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
           x = str2num(x);
           if handles.pom_vyber_filtr == 1 %Medianov� filtrace
             handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
             axes(handles.Filtr_obr)
             imshow(handles.Filtr_data)    
           elseif handles.pom_vyber_filtr == 2 %Lee
             handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
             axes(handles.Filtr_obr)
             imshow(handles.Filtr_data)                
           elseif handles.pom_vyber_filtr == 3 %Frost
             handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
             axes(handles.Filtr_obr)
             imshow(handles.Filtr_data)                
           end
      elseif handles.pom_vyber_metody == 5; %Um�l� obraz pro AKTIVN� KONTURY
         %Pro aktivn� kontury nebyl vytvo�en um�l� obraz, proto se vyhod� chybov� hl�ka
         errordlg('Pro tuto segmenta�n� metodu nebyl vytvo�en� um�l� obraz, zadej rovnou fantomov� nebo re�ln� data','Chyba!')
      else
          %Toto zobrazen� jak ji� bylo uvedeno z�le�� na vybran� metod� segmentov�n�, 
          %proto pokud nen� vybran� metoda se vyhod� chybov� hl�ka
          errordlg('Pro toto zobrazen�, je d�le�it� aby byla tak� vybr�na metoda segmentov�n�!','Chyba!')
      end
            
      %Zneviditeln�n� pomocn�ch tla��tek po segmentov�n� metodou prahov�n�
      set(handles.jedno_prah,'visible','off')
      set(handles.gray_prah,'visible','off')
      set(handles.dvoj_prah,'visible','off') 
      %Zneviditeln�n� parametr� pro Rozvod�
      set(handles.sobel,'visible','off')
      set(handles.robin,'visible','off')
      set(handles.prewitt,'visible','off')                  
            
     case 3 %Fantomov� data................................................ 
         
      %Pomocn� pro v�ber vstupn�ch dat � je vybr�n Fantomov� obraz (pro pozd�j�� o�et�en�)    
      handles.pom_vyber_dat = 3;         
      handles.Vstupni_data = imread('koncentrace_sem_1.bmp');  %Na�ten� fantomov�ch dat
      imshow(handles.Vstupni_data)
      [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
      handles.pom = 1; %Pro pozd�j�� o�et�en�, jestli existuj� n�jak� vstupn� data a program m��e 
                       %v po��dku pokra�ovat
                                 
      %Pou�it� filtrace po zm�n�n� vstupn�ch dat, aby se zobrazila v GUI
      x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
      x = str2num(x);
      if handles.pom_vyber_filtr == 1 %Medianov� filtrace
         handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
         axes(handles.Filtr_obr)
         imshow(handles.Filtr_data)    
      elseif handles.pom_vyber_filtr == 2 %Lee
         handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
         axes(handles.Filtr_obr)
         imshow(handles.Filtr_data)                
      elseif handles.pom_vyber_filtr == 3 %Frost
         handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
         axes(handles.Filtr_obr)
         imshow(handles.Filtr_data)                
      end
                                
      % Defuatln� nastaven� doporu�en� hodnoty pro segmentaci metodou
      % prahov�n� na fantomov� data
      % pozd�j�� vyu�it� t�chto hodnot bude ve funkci "Segmentace"
      if handles.pom_vyber_metody == 2;               
        set(handles.hodnota_Prah,'Value',80) 
        set(handles.hodnota_Prah,'String','80') 
        set(handles.hodnota_PrahD,'Value',20) 
        set(handles.hodnota_PrahD,'String','20') 
        set(handles.hodnota_PrahH,'Value',200) 
        set(handles.hodnota_PrahH,'String','200') 
        set(handles.Prah,'Value',80)   
        set(handles.PrahD,'Value',20)  
        set(handles.PrahH,'Value',200)
      end
                 
     %Zneviditeln�n� pomocn�ch tla��tek po segmentov�n� metodou prahov�n�
     set(handles.jedno_prah,'visible','off')
     set(handles.gray_prah,'visible','off')
     set(handles.dvoj_prah,'visible','off')
     %Zneviditeln�n� parametr� pro Rozvod�
     set(handles.sobel,'visible','off')
     set(handles.robin,'visible','off')
     set(handles.prewitt,'visible','off')
            
   case 4 %Re�ln� data...................................................
       
     %Pomocn� pro v�ber vstupn�ch dat � je vybr�n Re�ln� obraz (pro pozd�j�� o�et�en�)   
     handles.pom_vyber_dat = 2; 
     %Na�ten� re�ln�ho obrazu
     load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
     handles.Vstupni_data = data1{100};
     imshow(handles.Vstupni_data,[])
     [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
     handles.pom = 1; %Pro pozd�j�� o�et�en�, jestli existuj� n�jak� vstupn� data a program m��e 
                      %v po��dku pokra�ovat
                                 
     %Pou�it� filtrace po zm�n�n� vstupn�ch dat, aby se zobrazila v GUI
     x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
     x = str2num(x);
     if handles.pom_vyber_filtr == 1 %Medianov� filtrace
        handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
        axes(handles.Filtr_obr)
        imshow(handles.Filtr_data)    
     elseif handles.pom_vyber_filtr == 2 %Lee
        handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
        axes(handles.Filtr_obr)
        imshow(handles.Filtr_data)                
     elseif handles.pom_vyber_filtr == 3 %Frost
        handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
        axes(handles.Filtr_obr)
        imshow(handles.Filtr_data)                
     end
                                
     % Defuatln� nastaven� doporu�en� hodnoty pro segmentaci metodou
     % prahov�n� na re�ln� data
     % pozd�j�� vyu�it� t�chto hodnot bude ve funkci "Segmentace"
     if handles.pom_vyber_metody == 2;                                    
       set(handles.hodnota_Prah,'Value',130) 
       set(handles.hodnota_Prah,'String','130') 
       set(handles.hodnota_PrahD,'Value',5) 
       set(handles.hodnota_PrahD,'String','5') 
       set(handles.hodnota_PrahH,'Value',100) 
       set(handles.hodnota_PrahH,'String','100') 
       set(handles.Prah,'Value',130)   
       set(handles.PrahD,'Value',5)  
       set(handles.PrahH,'Value',100)
     end
                 
     %Zneviditeln�n� pomocn�ch tla��tek po segmentov�n� metodou prahov�n�
     set(handles.jedno_prah,'visible','off')
     set(handles.gray_prah,'visible','off')
     set(handles.dvoj_prah,'visible','off')
     %Zneviditeln�n� parametr� pro Rozvod�
     set(handles.sobel,'visible','off')
     set(handles.robin,'visible','off')
     set(handles.prewitt,'visible','off')
  
  case 5 %Co si bude cht�t nahr�t u�ivatel.................................
      
    %Pomocn� pro v�ber vstupn�ch dat � je vybr�n libovoln� obraz (pro pozd�j�� o�et�en�)   
    handles.pom_vyber_dat = 4;   
    
    %V�b�r libovoln�ho obr�zku u�ivatelem s doporu�en�mi konocovkami souboru
    [nazev_souboru, cesta] = uigetfile({'*.bmp';'*.jpg';'*.png'},'Vyber soubor');
    if isequal (nazev_souboru,0)||isequal(cesta,0)
       warndlg('Nejsou vybr�na vstupn� data','Varov�n�')
    else
       nazev_souboru = strcat(cesta,nazev_souboru);
       handles.Vstupni_data = imread(nazev_souboru);
       imshow(handles.Vstupni_data)
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       handles.pom = 1; %Pro pozd�j�� o�et�en�, jestli existuj� n�jak� vstupn� data a program m��e 
                        %v po��dku pokra�ovat
                        
      %Pou�it� filtrace po zm�n�n� vstupn�ch dat, aby se zobrazila v GUI
      x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
      x = str2num(x);
      if handles.pom_vyber_filtr == 1 %Medianov� filtrace
        handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
        axes(handles.Filtr_obr)
        imshow(handles.Filtr_data)    
      elseif handles.pom_vyber_filtr == 2 %Lee
        handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
        axes(handles.Filtr_obr)
        imshow(handles.Filtr_data)                
      elseif handles.pom_vyber_filtr == 3 %Frost
        handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
        axes(handles.Filtr_obr)
        imshow(handles.Filtr_data)                
      end
    
     % Defuatln� nastaven� doporu�en� hodnoty pro segmentaci metodou
     % prahov�n� na libovoln� data
     % pozd�j�� vyu�it� t�chto hodnot bude ve funkci "Segmentace"
     if handles.pom_vyber_metody == 2%defuatln� nastaven� doporu�en� hodnoty pro prahov�n�                
        set(handles.hodnota_Prah,'Value',0) 
        set(handles.hodnota_Prah,'String','0') 
        set(handles.hodnota_PrahD,'Value',0) 
        set(handles.hodnota_PrahD,'String','0') 
        set(handles.hodnota_PrahH,'Value',0) 
        set(handles.hodnota_PrahH,'String','0') 
        set(handles.Prah,'Value',0)   
        set(handles.PrahD,'Value',0)  
        set(handles.PrahH,'Value',0)
      end
    end
        
   %Zneviditeln�n� pomocn�ch tla��tek po segmentov�n� metodou prahov�n�
   set(handles.jedno_prah,'visible','off')
   set(handles.gray_prah,'visible','off')
   set(handles.dvoj_prah,'visible','off')
   %Zneviditeln�n� parametr� pro Rozvod�
   set(handles.sobel,'visible','off')
   set(handles.robin,'visible','off')
   set(handles.prewitt,'visible','off')              
                  
 otherwise %Pokud se vybere cokoli jin�ho, v tomto p��pad� sp�e nevybere
           %tak program nic neud�l�
end

if handles.pom_vyber_metody == 3
    if  handles.pom_vyber_dat == 1 ||  handles.pom_vyber_dat == 3  
        rozmery = size(handles.Vstupni_data);
        handles.x=round(rozmery(1)/2); 
        handles.y=round(rozmery(2)/2);
        set(handles.sourad_x,'Value',handles.x);
        set(handles.sourad_y,'Value',handles.y);
        set(handles.sourad_x,'String',num2str(handles.x));
        set(handles.sourad_y,'String',num2str(handles.y));   
    else  
         rozmery = size(handles.Vstupni_data);
         handles.x=round(rozmery(1)/2); 
         handles.y=round(rozmery(2)/2);
         set(handles.sourad_x,'Value',handles.x);
         set(handles.sourad_y,'Value',handles.y);
         set(handles.sourad_x,'String',num2str(handles.x));
         set(handles.sourad_y,'String',num2str(handles.y));   
    end
  if handles.pom_vyber_filtr == 2 || handles.pom_vyber_filtr == 3
     set(handles.max_interval,'Value',0.1)       
     set(handles.max_interval,'String',0.1)   
  elseif  handles.pom_vyber_dat == 2; 
         set(handles.max_interval,'Value',0.1)                     
         set(handles.max_interval,'String',0.1)  
  else
     set(handles.max_interval,'Value',0.2)       
     set(handles.max_interval,'String',0.2)   
  end
         
end


  guidata(hObject, handles);
  
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function vybrat_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
%______________________Vybr�n� segmenta�n� metody__________________________
% Provede se p�i zm�n� v�b�ru v vybrat_seg_metodu.
function vybrat_seg_metodu_Callback(hObject, eventdata, handles)

vyber_metody = get(hObject,'Value'); %Vybere se konkr�tn� typ segmenta�n� metody pomoc� "Pop-up Menu"

switch vyber_metody 
    
  case 1 %Bez segmenta�n� metody...........................................
      
    %Pomocn� pro v�ber segmeta�n� metody � nen� vybr�na segmenta�n� metoda (pro pozd�j�� o�et�en�)  
    handles.pom_vyber_metody = 1;  
                
    %Zneviditeln�n� ostatn�ch v�c� (texty k dan�m hodnot�m atd.)
    %Zneviditeln�n� vstupn�ch parametr� pro metodu segmentov�n�
    set(handles.Prah,'visible','off') 
    set(handles.PrahH,'visible','off')
    set(handles.PrahD,'visible','off')
    set(handles.hodnota_Prah,'visible','off')
    set(handles.hodnota_PrahH,'visible','off')
    set(handles.hodnota_PrahD,'visible','off')
    set(handles.text_Prah,'visible','off')
    set(handles.text_PrahH,'visible','off')
    set(handles.text_PrahD,'visible','off') 
    %Zneviditeln�n� pomocn�ch tla��tek pro segmentov�n� metodou prahov�n�
    set(handles.jedno_prah,'visible','off')
    set(handles.gray_prah,'visible','off')
    set(handles.dvoj_prah,'visible','off')
    %Zneviditeln�n� vstupn�ch parametr� pro Nar�st�n� oblast�
    set(handles.nastav_hodnot_narust_oblast,'visible','off')               
    set(handles.text_max_interval,'visible','off')
    set(handles.max_interval,'visible','off')
    set(handles.text_defualt_nastav,'visible','off')               
    set(handles.text_souradnice,'visible','off')
    set(handles.text_x,'visible','off')
    set(handles.text_y,'visible','off')
    set(handles.sourad_x,'visible','off')
    set(handles.sourad_y,'visible','off')
    %Zneviditeln�n� parametr� pro Rozvod�
    set(handles.sobel,'visible','off')
    set(handles.robin,'visible','off')
    set(handles.prewitt,'visible','off')
    %Zneviditeln� pot�ebn�ch parametr� na aktivn� kontury
    set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
    set(handles.text_max_it,'visible','off')
    set(handles.max_iterace,'visible','off')
    
  case 2 %V�b�r metody PRAHOV�N� ..........................................

  %Zneviditeln�n� ostatn�ch v�c� (texty k dan�m hodnot�m atd.)     
  %Zneviditeln�n� pomocn�ch tla��tek po segmentov�n� metodou prahov�n�
  set(handles.jedno_prah,'visible','off')
  set(handles.gray_prah,'visible','off')
  set(handles.dvoj_prah,'visible','off')  
  %Zneviditeln�n� vstupn�ch parametr� pro Nar�st�n� oblast�
  set(handles.nastav_hodnot_narust_oblast,'visible','off')               
  set(handles.text_max_interval,'visible','off')
  set(handles.max_interval,'visible','off')
  set(handles.text_defualt_nastav,'visible','off')               
  set(handles.text_souradnice,'visible','off')
  set(handles.text_x,'visible','off')
  set(handles.text_y,'visible','off')
  set(handles.sourad_x,'visible','off')
  set(handles.sourad_y,'visible','off')          
  %Zneviditeln�n� parametr� pro Rozvod�
  set(handles.sobel,'visible','off')
  set(handles.robin,'visible','off')
  set(handles.prewitt,'visible','off')
  %Zneviditeln� pot�ebn�ch parametr� na aktivn� kontury
  set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
  set(handles.text_max_it,'visible','off')
  set(handles.max_iterace,'visible','off')
    
    %Pomocn� pro v�ber segmeta�n� metody � segmenta�n� metoda prahov�n� (pro pozd�j�� o�et�en�)       
    handles.pom_vyber_metody = 2;  
                
    %Zviditeln�n� hodnot a parametr� vstupuj�c� do segemta�n� metody prahov�n�
    set(handles.Prah,'visible','on') 
    set(handles.PrahH,'visible','on')
    set(handles.PrahD,'visible','on')
    set(handles.hodnota_Prah,'visible','on')
    set(handles.hodnota_PrahH,'visible','on')
    set(handles.hodnota_PrahD,'visible','on')
    set(handles.text_Prah,'visible','on')
    set(handles.text_PrahH,'visible','on')
    set(handles.text_PrahD,'visible','on') 
                
    if handles.pom_vyber_dat == 1 %Zobrazen� v GUI um�l�ho obr�zu, po vybr�n� metody segmentace
       handles.Vstupni_data = imread('obr_prahovani_1.png');
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data)
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       handles.pom = 1;%Pro pozd�j�� o�et�en�, jestli existuj� n�jak� vstupn� data a program m��e 
                       %v po��dku pokra�ovat
                       
       %Pou�it� filtrace po zm�n�n� segmenta�n� metody, aby se zobrazila v GUI
       x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
       x = str2num(x);
       if handles.pom_vyber_filtr == 1 %Medianov� filtrace
        handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
        axes(handles.Filtr_obr)
        imshow(handles.Filtr_data)    
       elseif handles.pom_vyber_filtr == 2 %Lee
         handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
         axes(handles.Filtr_obr)
         imshow(handles.Filtr_data)                
       elseif handles.pom_vyber_filtr == 3 %Frost
         handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
         axes(handles.Filtr_obr)
         imshow(handles.Filtr_data)                
      end
      
      % Defuatln� nastaven� doporu�en� hodnoty pro segmentaci metodou
      % prahov�n� na um�l�m obr�zku
      % pozd�j�� vyu�it� t�chto hodnot bude ve funkci "Segmentace"                                       
      set(handles.hodnota_Prah,'Value',130) 
      set(handles.hodnota_Prah,'String','130') 
      set(handles.hodnota_PrahD,'Value',20) 
      set(handles.hodnota_PrahD,'String','20') 
      set(handles.hodnota_PrahH,'Value',200) 
      set(handles.hodnota_PrahH,'String','200') 
      set(handles.Prah,'Value',130)   
      set(handles.PrahD,'Value',20)  
      set(handles.PrahH,'Value',200)
      
    elseif handles.pom_vyber_dat == 2 %Zobrazen� v GUI Re�ln�ho obr�zu, po vybr�n� metody segmentace
      % Defuatln� nastaven� doporu�en� hodnoty pro segmentaci metodou
      % prahov�n� na Re�ln� obraz
      % pozd�j�� vyu�it� t�chto hodnot bude ve funkci "Segmentace"                  
      set(handles.hodnota_Prah,'Value',130) 
      set(handles.hodnota_Prah,'String','130') 
      set(handles.hodnota_PrahD,'Value',5) 
      set(handles.hodnota_PrahD,'String','5') 
      set(handles.hodnota_PrahH,'Value',100) 
      set(handles.hodnota_PrahH,'String','100') 
      set(handles.Prah,'Value',130)   
      set(handles.PrahD,'Value',5)  
      set(handles.PrahH,'Value',100)
                 
    elseif handles.pom_vyber_dat == 3 %Zobrazen� v GUI Fantomov�ho obr�zu, po vybr�n� metody segmentace
      % Defuatln� nastaven� doporu�en� hodnoty pro segmentaci metodou
      % prahov�n� na Fantomov� obraz
      % pozd�j�� vyu�it� t�chto hodnot bude ve funkci "Segmentace"         
      set(handles.hodnota_Prah,'Value',80) 
      set(handles.hodnota_Prah,'String','80') 
      set(handles.hodnota_PrahD,'Value',20) 
      set(handles.hodnota_PrahD,'String','20') 
      set(handles.hodnota_PrahH,'Value',200) 
      set(handles.hodnota_PrahH,'String','200') 
      set(handles.Prah,'Value',80)   
      set(handles.PrahD,'Value',20)  
      set(handles.PrahH,'Value',200)
                 
   elseif handles.pom_vyber_dat == 4
      % Defuatln� nastaven� doporu�en� hodnoty pro segmentaci metodou
      % prahov�n� na libovoln� obraz
      % pozd�j�� vyu�it� t�chto hodnot bude ve funkci "Segmentace"                    
      set(handles.hodnota_Prah,'Value',0) 
      set(handles.hodnota_Prah,'String','0') 
      set(handles.hodnota_PrahD,'Value',0) 
      set(handles.hodnota_PrahD,'String','0') 
      set(handles.hodnota_PrahH,'Value',0) 
      set(handles.hodnota_PrahH,'String','0') 
      set(handles.Prah,'Value',0)   
      set(handles.PrahD,'Value',0)  
      set(handles.PrahH,'Value',0)
      
   else %Pokud nejsou vybr�na ��dn� vstupn� data, vychod� se chybov� hl�ka
     warndlg('Nejsou vybr�na vstupn� data','Varov�n�')
    end
   
 case 3 %V�b�r metody NAR�ST�N� OBLAST�...................................

  %Zneviditeln�n� ostatn�ch v�c� (texty k dan�m hodnot�m atd.)     
  %Zneviditeln�n� parametr� pro prahov�n�
  set(handles.Prah,'visible','off') 
  set(handles.PrahH,'visible','off')
  set(handles.PrahD,'visible','off')
  set(handles.hodnota_Prah,'visible','off')
  set(handles.hodnota_PrahH,'visible','off')
  set(handles.hodnota_PrahD,'visible','off')
  set(handles.text_Prah,'visible','off')
  set(handles.text_PrahH,'visible','off')
  set(handles.text_PrahD,'visible','off')
  %Zneviditeln�n� pomocn�ch tla��tek po segmentov�n� metodou prahov�n�
  set(handles.jedno_prah,'visible','off')
  set(handles.gray_prah,'visible','off')
  set(handles.dvoj_prah,'visible','off')  
  %Zneviditeln�n� parametr� pro Rozvod�
  set(handles.sobel,'visible','off')
  set(handles.robin,'visible','off')
  set(handles.prewitt,'visible','off')
  %Zneviditeln� pot�ebn�ch parametr� na aktivn� kontury
  set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
  set(handles.text_max_it,'visible','off')
  set(handles.max_iterace,'visible','off')
  
  %Pomocn� pro v�ber segmeta�n� metody � segmenta�n� metoda nar�st�n� oblast� (pro pozd�j�� o�et�en�)    
  handles.pom_vyber_metody = 3; 
              
  %Zviditeln�n� nastaviteln�ch vstupn�ch parametr�
  set(handles.nastav_hodnot_narust_oblast,'visible','on') 
  set(handles.text_max_interval,'visible','on')
  set(handles.max_interval,'visible','on')
              
  %P�i v�b�ru Lee a Frost filtru se defualtn� nastav� hodnota maxim�ln�ho intervalu 
  %intenzity na 0.1 v jin�ch p��padech 0.2
  if handles.pom_vyber_filtr == 2 || handles.pom_vyber_filtr == 3
     set(handles.max_interval,'Value',0.1)       
     set(handles.max_interval,'String',0.1)   
  else
     set(handles.max_interval,'Value',0.2)       
     set(handles.max_interval,'String',0.2)   
  end
              
  if handles.pom_vyber_dat == 1 %Zobrazen� pro um�l� obraz, po vybr�n� metody segmentace
     handles.Vstupni_data = imread('obr_narustani_oblasti.png');
     axes(handles.Vstupni_obraz)
     imshow(handles.Vstupni_data)
     [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
     handles.pom = 1;%Pro pozd�j�� o�et�en�, jestli existuj� n�jak� vstupn� data a program m��e 
                     %v po��dku pokra�ovat 
                     
    %Pou�it� filtrace po zm�n�n� segmenta�n� metody, aby se zobrazila v GUI
    x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
    x = str2num(x);
    if handles.pom_vyber_filtr == 1 %Medianov� filtrace
      handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
      axes(handles.Filtr_obr)
      imshow(handles.Filtr_data)    
    elseif handles.pom_vyber_filtr == 2 %Lee
      handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
      axes(handles.Filtr_obr)
      imshow(handles.Filtr_data)                
    elseif handles.pom_vyber_filtr == 3 %Frost
      handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
      axes(handles.Filtr_obr)
      imshow(handles.Filtr_data)                
    end                 
  end
  
  %Nastaven� parametr� pro pozd�j�� pou�it� v segmentaci metodou nar�st�n� oblast�
  if handles.pom == 1                      %Pokud jsou vybr�na data prove�
     if get(handles.manual,'Value') == 1;  %jestli je zakliknut�, �e chce� prov�st manu�ln� v�b�r vstupn�ch hodnot, tak
                                           %se polo�� ot�zka: 
        otazka = questdlg('Bude� cht�t naj�t manu�ln� hodnotu ve Vstupn�ch datech nebo ve Filtrovan�m obrazu?','V�b�r',...
                           'Vstupn� data','Filtrovan� obraz','Defualtn�','Defualtn�');
        switch otazka
          case 'Vstupn� data' %Pokud vybere�, �e chce� ur�it vstupn� hodnoty ze vstupn�ho obrazu
             axes(handles.Vstupni_obraz)   
             [y,x]=getpts; %ur�en� vstupn�ch hodnot do metody segmentace nar�st�n� oblast� manu�ln� pomoc� funkce getpts
             handles.y=round(y(1));
             handles.x=round(x(1));
          case 'Filtrovan� obraz' %Pokud vybere�, �e chce� ur�it vstupn� hodnoty z filtrovan�ho obrazu
             if handles.pom_vyber_filtr == 0; %mus� b�t p�edem provedena filtrace, jinak se vyp�e chybov� hl�ka
                errordlg('Pro tento v�b�r mus� m�t filtrovan� obraz,znovu vyber filtrovac� metodu','Chyba')   
             else
               axes(handles.Filtr_obr)  
               [y,x]=getpts; %ur�en� vstupn�ch hodnot do metody segmentace nar�st�n� oblast� manu�ln� pomoc� funkce getpts
               handles.y=round(y(1));
               handles.x=round(x(1));  
             end
          case 'Defualtn�' %Pokud vybere�, �e chce� ur�it hodnoty defualtn�
             handles.manual.Value = 0; %Automatick� p�epnut� na v�b�r defualtn�ho nastaven�
             handles.defualt.Value = 1; 
             
             %Zobrazen� pot�ebn�ch vstupn�ch hodnot, kter� jsou defualtn�
             %nastaven� ale v GUI se daj� libovoln� m�nit
             set(handles.text_defualt_nastav,'visible','on'); 
             set(handles.text_souradnice,'visible','on'); 
             set(handles.text_x,'visible','on');
             set(handles.text_y,'visible','on');
             set(handles.sourad_x,'visible','on');
             set(handles.sourad_y,'visible','on');
                       
            %Defualtn� nastaven� sou�adnic (defualtn� se bude vych�zet ze st�edu obrazu)
             rozmery = size(handles.Vstupni_data);
             handles.x=round(rozmery(1)/2); 
             handles.y=round(rozmery(2)/2);
             set(handles.sourad_x,'Value',handles.x);
             set(handles.sourad_y,'Value',handles.y);
             set(handles.sourad_x,'String',num2str(handles.x));
             set(handles.sourad_y,'String',num2str(handles.y));                       
        end
        
     elseif get(handles.defualt,'Value') == 1; %jestli je zakliknut�, �e chce� prov�st defualtn� v�b�r vstupn�ch hodnot

        %Automatick� p�epnut� na v�b�r defualtn�ho nastaven�   
        handles.manual.Value = 0; 
        handles.deufalt.Value = 1; 
        
        %Zobrazen� pot�ebn�ch vstupn�ch hodnot, kter� jsou defualtn�
        %nastaven� ale v GUI se daj� libovoln� m�nit        
        set(handles.text_defualt_nastav,'visible','on');
        set(handles.text_souradnice,'visible','on'); 
        set(handles.text_x,'visible','on');
        set(handles.text_y,'visible','on');
        set(handles.sourad_x,'visible','on');
        set(handles.sourad_y,'visible','on');
                       
        %Defualtn� nastaven� sou�adnic (defualtn� se bude vych�zet ze st�edu obrazu)
        rozmery = size(handles.Vstupni_data);
        handles.x=round(rozmery(1)/2); 
        handles.y=round(rozmery(2)/2);
        set(handles.sourad_x,'Value',handles.x);
        set(handles.sourad_y,'Value',handles.y);
        set(handles.sourad_x,'String',num2str(handles.x));
        set(handles.sourad_y,'String',num2str(handles.y));                          
     else %Pokud cokoli jin�ho vyhod� se chybov� hl�ka
        warndlg('Zkontroluj zda m� nastaven� v�echny pot�ebn� atributy','Varov�n�')  
     end
  else %Pokud nejsou vybran� vstupn� data vyhod� se chybov� hl�ka 
     errordlg('CHYBA - zkontroluj zda m� vybran� vstupn� data','Chyba!')
  end
                               
 case 4%V�b�r metody ROZVOD�...............................................
     
  %Zneviditeln�n� ostatn�ch v�c� (texty k dan�m hodnot�m atd.)     
  %Zneviditeln�n� parametr� pro prahov�n�
  set(handles.Prah,'visible','off') 
  set(handles.PrahH,'visible','off')
  set(handles.PrahD,'visible','off')
  set(handles.hodnota_Prah,'visible','off')
  set(handles.hodnota_PrahH,'visible','off')
  set(handles.hodnota_PrahD,'visible','off')
  set(handles.text_Prah,'visible','off')
  set(handles.text_PrahH,'visible','off')
  set(handles.text_PrahD,'visible','off')
  %Zneviditeln�n� vstupn�ch parametr� pro Nar�st�n� oblast�
  set(handles.nastav_hodnot_narust_oblast,'visible','off')               
  set(handles.text_max_interval,'visible','off')
  set(handles.max_interval,'visible','off')
  set(handles.text_defualt_nastav,'visible','off')               
  set(handles.text_souradnice,'visible','off')
  set(handles.text_x,'visible','off')
  set(handles.text_y,'visible','off')
  set(handles.sourad_x,'visible','off')
  set(handles.sourad_y,'visible','off')  
  %Zneviditeln�n� pomocn�ch tla��tek po segmentov�n� metodou prahov�n�
  set(handles.jedno_prah,'visible','off')
  set(handles.gray_prah,'visible','off')
  set(handles.dvoj_prah,'visible','off')  
  %Zneviditeln�n� parametr� pro Rozvod�
  set(handles.sobel,'visible','off')
  set(handles.robin,'visible','off')
  set(handles.prewitt,'visible','off')
  %Zneviditeln� pot�ebn�ch parametr� na aktivn� kontury
  set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
  set(handles.text_max_it,'visible','off')
  set(handles.max_iterace,'visible','off')
  
  %Pomocn� pro v�ber segmeta�n� metody � segmenta�n� metodu Rozvod� (pro pozd�j�� o�et�en�)
  handles.pom_vyber_metody = 4;  
                
  if handles.pom_vyber_dat == 1 %Zobrazen� pro um�l� obr�zky, po vybr�n� metody segmentace
     handles.Vstupni_data = imread('obr_rozvodi_2.png');
     axes(handles.Vstupni_obraz)
     imshow(handles.Vstupni_data)
     [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
     handles.pom = 1; %Pro pozd�j�� o�et�en�, jestli existuj� n�jak� vstupn� data a program m��e 
                     %v po��dku pokra�ovat 
  end 
              
    %Pou�it� filtrace po zm�n�n� segmenta�n� metody, aby se zobrazila v GUI
    x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
    x = str2num(x);
    if handles.pom_vyber_filtr == 1 %Medianov� filtrace
      handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
      axes(handles.Filtr_obr)
      imshow(handles.Filtr_data)    
    elseif handles.pom_vyber_filtr == 2 %Lee
      handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
      axes(handles.Filtr_obr)
      imshow(handles.Filtr_data)                
    elseif handles.pom_vyber_filtr == 3 %Frost
      handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
      axes(handles.Filtr_obr)
      imshow(handles.Filtr_data)                
    end                          
                         
 case 5 %V�b�r metody AKTIVN� KONTURY......................................

  %Zneviditeln�n� ostatn�ch v�c� (texty k dan�m hodnot�m atd.)     
  %Zneviditeln�n� parametr� pro prahov�n�
  set(handles.Prah,'visible','off') 
  set(handles.PrahH,'visible','off')
  set(handles.PrahD,'visible','off')
  set(handles.hodnota_Prah,'visible','off')
  set(handles.hodnota_PrahH,'visible','off')
  set(handles.hodnota_PrahD,'visible','off')
  set(handles.text_Prah,'visible','off')
  set(handles.text_PrahH,'visible','off')
  set(handles.text_PrahD,'visible','off')
  %Zneviditeln�n� vstupn�ch parametr� pro Nar�st�n� oblast�
  set(handles.nastav_hodnot_narust_oblast,'visible','off')               
  set(handles.text_max_interval,'visible','off')
  set(handles.max_interval,'visible','off')
  set(handles.text_defualt_nastav,'visible','off')               
  set(handles.text_souradnice,'visible','off')
  set(handles.text_x,'visible','off')
  set(handles.text_y,'visible','off')
  set(handles.sourad_x,'visible','off')
  set(handles.sourad_y,'visible','off')  
  %Zneviditeln�n� pomocn�ch tla��tek po segmentov�n� metodou prahov�n�
  set(handles.jedno_prah,'visible','off')
  set(handles.gray_prah,'visible','off')
  set(handles.dvoj_prah,'visible','off')  
  %Zneviditeln�n� parametr� pro Rozvod�
  set(handles.sobel,'visible','off')
  set(handles.robin,'visible','off')
  set(handles.prewitt,'visible','off')
  
  %Pomocn� pro v�ber segmeta�n� metody � segmenta�n� metoda aktivn� kontury (pro pozd�j�� o�et�en�) 
  handles.pom_vyber_metody = 5;
                
   if handles.pom_vyber_dat == 1 %Pokud se vybere metoda segmentovan� aktivn� kontury, kdy� budou vybr�na vstupn� data 
                                 %jako um�l� obraz, vyhod� se chybov� hl�ka
      warndlg('Po vybr�n� jin�ch atribut� zadej znovu segmenta�n� metodu','Varov�n�')  
      errordlg('Pro tuto segmenta�n� metodu nebyl vytvo�en� um�l� obraz, zadej rovnou fantomov� nebo re�ln� data','Chyba!')

   else %Pokud cokoli jin�ho
    %Pou�it� filtrace po zm�n�n� segmenta�n� metody, aby se zobrazila v GUI
     x = get(handles.filtr_okno,'string'); %Hodnota filtrovac�ho okna
     x = str2num(x);
     if handles.pom_vyber_filtr == 1 %Medianov� filtrace
       handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
       axes(handles.Filtr_obr)
       imshow(handles.Filtr_data)    
     elseif handles.pom_vyber_filtr == 2 %Lee
       handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
       axes(handles.Filtr_obr)
       imshow(handles.Filtr_data)                
     elseif handles.pom_vyber_filtr == 3 %Frost
       handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
       axes(handles.Filtr_obr)
       imshow(handles.Filtr_data)                
     end     
   end
   
   %Zviditeln� pot�ebn�ch parametr� na aktivn� kontury
   set(handles.nastaveni_hodnot_aktiv_kontur,'visible','on') 
   set(handles.text_max_it,'visible','on')
   set(handles.max_iterace,'visible','on')
   set(handles.max_iterace,'Value',800)   
   set(handles.max_iterace,'String','800')  
   
   %Nastaven� parametr� pro pozd�j�� pou�it� v segmentaci metodou aktivn�ch kontur
   if handles.pom == 1 && handles.pom_vyber_dat ~= 1 %Pokud jsou vybr�na data prove� a nejsou vybr�na data um�l�
          otazka = questdlg('Bude� cht�t naj�t manu�ln� hodnotu ve Vstupn�ch datech nebo ve Filtrovan�m obrazu?','V�b�r',...
                            'Vstupn� data','Filtrovan� obraz','Filtrovan� obraz');
         switch otazka
           case 'Vstupn� data' %Pokud vybere�, �e chce� ur�it vstupn� hodnoty ze vstupn�ho obrazu
            axes(handles.Vstupni_obraz)   
            handles.pocatecni_maska=roipoly(handles.Vstupni_data); %ur�en� vstupn� masky do metody segmentace aktivn�ch kontur pomoc� funkce roipoly
           case 'Filtrovan� obraz' %Pokud vybere�, �e chce� ur�it vstupn� hodnoty z filtrovan�ho obrazu
            if handles.pom_vyber_filtr == 0; %mus� b�t p�edem provedena filtrace, jinak se vyp�e chybov� hl�ka
               errordlg('Pro tento v�b�r mus� m�t filtrovan� obraz, znovu vyber filtrovac� metodu','Chyba')   
            else
               axes(handles.Filtr_obr)
               handles.pocatecni_maska=roipoly(handles.Vstupni_data); %ur�en� vstupn� masky do metody segmentace aktivn�ch kontur pomoc� funkce roipoly
            end
         end
         handles.manual_AK.Value = 0; %Automatick� p�epnut� na v�b�r defualtn�ho nastaven�
         handles.defualt_AK.Value = 1; 
                  
     else %Pokud cokoli jin�ho vyhod� se chybov� hl�ka
        warndlg('Zkontroluj zda m� nastaven� v�echny pot�ebn� atributy','Varov�n�')  
   end
   
   
    otherwise %Pokud se vybere cokoli jin�ho (�i nevybere)
              %program nic neprovede    
 end
guidata(hObject, handles);

% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function vybrat_seg_metodu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%**************************************************************************
%___________________________SAMOTN� SEGMENTACE_____________________________
% Provede se p�i zm��knut� tla��tka "segmentace".
function segmentace_Callback(hObject, eventdata, handles)

%SEGMENTOV�N�:
 if handles.pom == 1; %Provede se pokud jsou nahran� data
   if handles.pom_vyber_metody == 1; %��dn� metoda vyp�e se chybov� hl�ka
      errordlg('Mus� vybrat metodu segmentov�n�','Chyba!')    
      
   elseif handles.pom_vyber_metody == 2; %PRAHOV�N�.......................
      Prah = get(handles.hodnota_Prah,'string'); %Hodnota z�kladn�ho prahu
      Prah = str2num(Prah)/255;
      PrahD = get(handles.hodnota_PrahD,'string'); %Hodnota doln�ho prahu
      PrahD = str2num(PrahD)/255;
      PrahH = get(handles.hodnota_PrahH,'string'); %Hodnota horn�ho prahu
      PrahH = str2num(PrahH)/255;
      %Zavol�n� funkce, kter� provede segmentovac� metodu prahov�n�
      if handles.pom_vyber_filtr == 0; %Filtr nebyl pou�it�
         [handles.Vystup_1,handles.Vystup_2,handles.Vystup_3] = Prahovani(handles.Vstupni_data,Prah,PrahD,PrahH);
         axes(handles.Segmen_Obraz)
         imshow(handles.Vystup_1) 
      else %Filtr byl pou�it�
         [handles.Vystup_1,handles.Vystup_2,handles.Vystup_3] = Prahovani(handles.Filtr_data,Prah,PrahD,PrahH);
         axes(handles.Segmen_Obraz)
         imshow(handles.Vystup_1) 
      end
      %Zobrazen� pomocn�ch tal��tek 
      set(handles.jedno_prah,'visible','on')
      set(handles.gray_prah,'visible','on')
      set(handles.dvoj_prah,'visible','on')
      set(handles.reset,'visible','on');
      
   elseif handles.pom_vyber_metody == 3; %NAR�ST�N� OBLAST�...............
      %Vypsan� hodnoty maxim�ln�ho intrevalu intenzity 
      reg_max = get(handles.max_interval,'String');
      reg_max = str2num(reg_max);
      %Zavol�n� funkce, kter� provede segmentovac� metodu nar�st�n� oblast�        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl pou�it�
         [handles.Vystup] = Narust_oblast(handles.Vstupni_data, handles.x, handles.y, reg_max);
         axes(handles.Segmen_Obraz)
         imshow(handles.Vystup)
      else %Filtr byl pou�it�
         [handles.Vystup] = Narust_oblast(handles.Filtr_data, handles.x, handles.y, reg_max);
         axes(handles.Segmen_Obraz)
         imshow(handles.Vystup)
      end
      set(handles.reset,'visible','on');
      
   elseif handles.pom_vyber_metody == 4; %ROZVOD�..........................
     %Zavol�n� funkce, kter� provede segmentovac� metodu rozvod�
     if handles.pom_vyber_filtr == 0; %Filtr nebyl pou�it�
        [handles.Vystup_Sobel, handles.Vystup_Robin, handles.Vystup_Prewitt] = Rozvodi(handles.Vstupni_data);
        axes(handles.Segmen_Obraz)
        imshow(handles.Vystup_Sobel)
     else %Filtr byl pou�it�
        [handles.Vystup_Sobel, handles.Vystup_Robin, handles.Vystup_Prewitt] = Rozvodi(handles.Filtr_data);
        axes(handles.Segmen_Obraz)
        imshow(handles.Vystup_Sobel)
     end
     %Zobrazen� pomocn�ch tal��tek        
     set(handles.sobel,'visible','on')
     set(handles.robin,'visible','on')
     set(handles.prewitt,'visible','on')
     set(handles.reset,'visible','on');  
     
   elseif handles.pom_vyber_metody == 5; %AKTIVN� KONTURY..................
     max_it = get(handles.max_iterace,'String'); 
     max_it= str2num(max_it);
     %Zavol�n� funkce, kter� provede segmentovac� metodu rozvod�           
     if handles.pom_vyber_filtr == 0; %Filtr nebyl pou�it�
        [Vystup] = Aktiv_kontur(handles.Vstupni_data, handles.pocatecni_maska, max_it);
         axes(handles.Segmen_Obraz) 
         imshow(handles.Vstupni_data)
         hold on
         contour(Vystup, [0 0], 'g','LineWidth',4);
         contour(Vystup, [0 0], 'k','LineWidth',2);
         hold off;
         set(handles.reset,'visible','on');
 
     else %Filtr byl pou�it�
         [Vystup] = Aktiv_kontur(handles.Filtr_data, handles.pocatecni_maska, max_it);
         axes(handles.Segmen_Obraz) 
         imshow(handles.Vstupni_data)
         hold on
         contour(Vystup, [0 0], 'g','LineWidth',4);
         contour(Vystup, [0 0], 'k','LineWidth',2);
         hold off;
         
         set(handles.reset,'visible','on');
     end
   else %Pokud cokoli jin�ho vyhod� se chybov� hl�ka: 
     errordlg('CHYBA - zkontroluj zda m� vybranou metodu segmentov�n� a vstupn� data','Chyba!')
   end
 else %Pokud cokoli jin�ho vyhod� se chybov� hl�ka: 
   errordlg('CHYBA - zkontroluj zda m� vybranou metodu segmentov�n� a vstupn� data','Chyba!')
 end
 guidata(hObject, handles);


 %%
%*************************************************************************
%_________________________Ostatn� pomocn� funkce___________________________

%Ostatn� pot�ebn� funkce/tla��tka/parametry pro spr�vn� vlo�en� ur�it�ch
%paremetr� do ur�it�ch segmenta�n�ch metod

 
% Provede se kdy� se "slider" pohne ... ur�uj�c� hodnotu horn�ho prahu
function PrahH_Callback(hObject, eventdata, handles)
pom_slider_prahH = get(hObject,'value'); %Do pomocn� prom�nn� se ulo�� hodnota na posuvn�ku "slider"
set(handles.hodnota_PrahH,'String',num2str(pom_slider_prahH)); %ta se zobraz� do "edit" p��slu�n�ho posuvn�ku "slideru"
guidata(hObject,handles);
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function PrahH_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Provede se kdy� se "slider" pohne ... ur�uj�c� hodnotu z�kadn�ho prahu
function Prah_Callback(hObject, eventdata, handles)
pom_slider_prah = get(hObject,'value'); %Do pomocn� prom�nn� se ulo�� hodnota na posuvn�ku "slider"
set(handles.hodnota_Prah,'String',num2str(pom_slider_prah)); %ta se zobraz� do "edit" p��slu�n�ho posuvn�ku "slideru"
guidata(hObject,handles);
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function Prah_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Provede se kdy� se "slider" pohne ... ur�uj�c� hodnotu doln�ho prahu
function PrahD_Callback(hObject, eventdata, handles)
pom_slider_prahD = get(hObject,'value'); %Do pomocn� prom�nn� se ulo�� hodnota na posuvn�ku "slider"
set(handles.hodnota_PrahD,'String',num2str(pom_slider_prahD)); %ta se zobraz� do "edit" p��slu�n�ho posuvn�ku "slideru"
guidata(hObject,handles);
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function PrahD_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function hodnota_Prah_Callback(hObject, eventdata, handles)
%Pokud se p�enastav� hodnota zakladn�ho prahu ru�n� v tla��tku "edit" je
%nutn� aby se posunul posuvn�k "slider" 
pom_edit_prah = get(hObject,'String');
set(handles.Prah,'value',str2num(pom_edit_prah));
guidata(hObject,handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function hodnota_Prah_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function hodnota_PrahD_Callback(hObject, eventdata, handles)
%Pokud se p�enastav� hodnota doln�ho prahu ru�n� v tla��tku "edit" je
%nutn� aby se posunul posuvn�k "slider" pom_edit_prahD = get(hObject,'String');
set(handles.PrahD,'value',str2num(pom_edit_prahD));
guidata(hObject,handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function hodnota_PrahD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function hodnota_PrahH_Callback(hObject, eventdata, handles)
%Pokud se p�enastav� hodnota horn�ho prahu ru�n� v tla��tku "edit" je
%nutn� aby se posunul posuvn�k "slider" pom_edit_prahD = get(hObject,'String');
pom_edit_prahH = get(hObject,'String');
set(handles.PrahH,'value',str2num(pom_edit_prahH));
guidata(hObject,handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function hodnota_PrahH_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 

%Funkce pro vol�n� hodnoty z "edit" filtrovac�ho okna
function filtr_okno_Callback(hObject, eventdata, handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function filtr_okno_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Kdy� se zm��kn� tla��tko jedno_prah provede se.
function jedno_prah_Callback(hObject, eventdata, handles)
%P�ep�e se Vystup z prahov�n� na z�kladn� prahov�n�
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_1) 

%Kdy� se zm��kn� tla��tko  gray_prah provede se.
function gray_prah_Callback(hObject, eventdata, handles)
%P�ep�e se Vystup z prahov�n� na prahov�n� pomoc� funkce graythresh
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_2) 

%Kdy� se zm��kn� tla��tko dvoj_prah provede se.
function dvoj_prah_Callback(hObject, eventdata, handles)
%P�ep�e se Vystup z prahov�n� na dvojt� prahov�n�
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_3) 

%Funkce pro vol�n� hodnoty z "edit" sou�adnice x
function sourad_x_Callback(hObject, eventdata, handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function sourad_x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Funkce pro vol�n� hodnoty z "edit" sou�adnice y
function sourad_y_Callback(hObject, eventdata, handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function sourad_y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Pokud se stiskne tla��tko manualn� provede se.
function manual_Callback(hObject, eventdata, handles)
%Pokud je vybr�no tla��tko manu�ln�
if get(hObject,'Value')== 1
    %P�epsan� aktu�ln�ch hodnot:
    handles.manual.Value = 1;
    handles.defualt.Value = 0; 
    otazka = questdlg('Bude� cht�t naj�t manu�ln� hodnotu ve Vstupn�ch datech nebo ve Filtrovan�m obrazu?','V�b�r',...
                      'Vstupn� data','Filtrovan� obraz','Defualtn�','Defualtn�');
    switch otazka
      case 'Vstupn� data' %Pokud vybere�, �e chce� ur�it vstupn� hodnoty ze vstupn�ho obrazu
         axes(handles.Vstupni_obraz)   
         [y,x]=getpts; %ur�en� vstupn�ch hodnot do metody segmentace nar�st�n� oblast� manu�ln� pomoc� funkce getpts
         handles.y=round(y(1));
         handles.x=round(x(1));
      case 'Filtrovan� obraz' %Pokud vybere�, �e chce� ur�it vstupn� hodnoty z filtrovan�ho obrazu
         if handles.pom_vyber_filtr == 0; %mus� b�t p�edem provedena filtrace, jinak se vyp�e chybov� hl�ka
            errordlg('Pro tento v�b�r mus� m�t filtrovan� obraz, znovu vyber filtrovac� metodu','Chyba')
         else
            axes(handles.Filtr_obr)  
            [y,x]=getpts; %ur�en� vstupn�ch hodnot do metody segmentace nar�st�n� oblast� manu�ln� pomoc� funkce getpts
            handles.y=round(y(1));
            handles.x=round(x(1));  
         end
      case 'Defualtn�' %Pokud vybere�, �e chce� ur�it hodnoty defualtn�
         handles.manual.Value = 0; %Automatick� p�epnut� na v�b�r defualtn�ho nastaven�
         handles.defualt.Value = 1; 
             
         %Zobrazen� pot�ebn�ch vstupn�ch hodnot, kter� jsou defualtn�
         %nastaven� ale v GUI se daj� libovoln� m�nit
         set(handles.text_defualt_nastav,'visible','on'); 
         set(handles.text_souradnice,'visible','on'); 
         set(handles.text_x,'visible','on');
         set(handles.text_y,'visible','on');
         set(handles.sourad_x,'visible','on');
         set(handles.sourad_y,'visible','on');
                       
         %Defualtn� nastaven� sou�adnic (defualtn� se bude vych�zet ze st�edu obrazu)
         rozmery = size(handles.Vstupni_data);
         handles.x=round(rozmery(1)/2); 
         handles.y=round(rozmery(2)/2);
         set(handles.sourad_x,'Value',handles.x);
         set(handles.sourad_y,'Value',handles.y);
         set(handles.sourad_x,'String',num2str(handles.x));
         set(handles.sourad_y,'String',num2str(handles.y));                       
    end
else
    handles.manual.Value = 0; 
end
guidata(hObject, handles);

% Pokud se stiskne tla��tko defualtn� provede se.
function defualt_Callback(hObject, eventdata, handles)
%Pokud je vybr�no tla��tko defualtn�
if get(hObject,'Value')== 1
    
         handles.manual.Value = 0; %Automatick� p�epnut� na v�b�r defualtn�ho nastaven�
         handles.defualt.Value = 1; 
             
         %Zobrazen� pot�ebn�ch vstupn�ch hodnot, kter� jsou defualtn�
         %nastaven� ale v GUI se daj� libovoln� m�nit
         set(handles.text_defualt_nastav,'visible','on'); 
         set(handles.text_souradnice,'visible','on'); 
         set(handles.text_x,'visible','on');
         set(handles.text_y,'visible','on');
         set(handles.sourad_x,'visible','on');
         set(handles.sourad_y,'visible','on');
                       
         %Defualtn� nastaven� sou�adnic (defualtn� se bude vych�zet ze st�edu obrazu)
         rozmery = size(handles.Vstupni_data);
         handles.x=round(rozmery(1)/2); 
         handles.y=round(rozmery(2)/2);
         set(handles.sourad_x,'Value',handles.x);
         set(handles.sourad_y,'Value',handles.y);
         set(handles.sourad_x,'String',num2str(handles.x));
         set(handles.sourad_y,'String',num2str(handles.y));  
   
else %Pokud cokoli jin�ho - nen� vybr�no spr�vn� tla��tko
    handles.defualt.Value = 0; 
end
guidata(hObject, handles);

%Funkce pro vol�n� hodnoty z maximal_interval
function max_interval_Callback(hObject, eventdata, handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function max_interval_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Funkce pro vol�n� hodnoty z sobel
function sobel_Callback(hObject, eventdata, handles)
%Vykreslen� segmentace rozvod� pomoc� sobelovy masky
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_Sobel) 

%Funkce pro vol�n� hodnoty z robin
function robin_Callback(hObject, eventdata, handles)
%Vykreslen� segmentace rozvod� pomoc� robinsonovy masky
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_Robin) 

%Funkce pro vol�n� Prewitt
function prewitt_Callback(hObject, eventdata, handles)
%Vykreslen� segmentace rozvod� pomoc� Prewittovy masky
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_Prewitt) 

function max_iterace_Callback(hObject, eventdata, handles)

% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function max_iterace_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Pokud se stiskne tla��tko Prove� filtraci provede se:
function filtr_button_Callback(hObject, eventdata, handles)

x = get(handles.filtr_okno,'string'); 
x = str2num(x);

switch handles.vyber_filtr
     case 1 %Bez filtrace..................................................
       
       %Zneviditeln�ch zbyte�n�ch argument� pro tuto akci: 
       set(handles.filtr_okno_text,'visible','off') 
       set(handles.filtr_okno,'visible','off')
       set(handles.text_median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','off')
       set(handles.filtr_button,'visible','off');
       
       %Na�ten� obr�zku bez filtrace        
       bez_filtr = imread('GUI_bez_filtrace.png');  
       axes(handles.Filtr_obr)
       imshow(bez_filtr)  
       handles.Filtr_data = handles.Vstupni_data; 
       
       %Filtr nebyl pou�it� � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne        
       handles.pom_vyber_filtr = 0; 
        
     case 2 %Medi�nov� filtr...............................................
       
       %Zviditeln�n� vstupn�ho okna do filtru, hodnota je defuatln�
       %nastaven� na 5; v GUI se d� ov�em i p�epsat
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')
       set(handles.filtr_button,'visible','on');
                 
        if handles.pom == 1 %Pokud byly na�teny vstupn� data, provede se medi�nov� filtrace
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1 %Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                              %pro bezchybn� zobrazen�
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data,[])                    
        else %Pokud nebyla na�ten� ��dn� vstupn� data, vyhod� se chybov� hl�ka
            errordlg('CHYBA - zkontroluj zda m� vybran� vstupn� data','Chyba!')    
        end
        
        %Zobrazen� popisku dole, pro ov��en�, �e cyklus dojel
        set(handles.text_Lee,'visible','off')
        set(handles.text_Frost,'visible','off')                
        set(handles.text_median,'visible','on')
        
        %Byl pou�it� Median_filtr � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne 
        handles.pom_vyber_filtr = 1; 
                
     case 3 %Lee filtr.....................................................
         
        %Zviditeln�n� vstupn�ho okna do filtru, hodnota je defuatln�
        %nastaven� na 5; v GUI se d� ov�em i p�epsat         
        set(handles.filtr_okno_text,'visible','on') 
        set(handles.filtr_okno,'visible','on') 
        set(handles.filtr_button,'visible','on');     
        
        if handles.pom == 1 %Pokud byly na�teny vstupn� data, provede se Lee filtrace
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                             %pro bezchybn� zobrazen�
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data,[])        
        else %Pokud nebyla na�ten� ��dn� vstupn� data, vyhod� se chybov� hl�ka
            errordlg('CHYBA - zkontroluj zda m� vybran� vstupn� data','Chyba!')    
        end
        
        %Zobrazen� popisku dole, pro ov��en�, �e cyklus dojel        
        set(handles.text_median,'visible','off')
        set(handles.text_Frost,'visible','off')
        set(handles.text_Lee,'visible','on')

        %Byl pou�it� Lee filtr � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne       
        handles.pom_vyber_filtr = 2; 
        
     case 4 %Frost filtr...................................................

       %Zviditeln�n� vstupn�ho okna do filtru, hodnota je defuatln�
       %nastaven� na 5; v GUI se d� ov�em i p�epsat  
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')  
       set(handles.filtr_button,'visible','on');
       
       if handles.pom == 1 %Pokud byly na�teny vstupn� data, provede se Frost filtrace
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data)
       elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                            %pro bezchybn� zobrazen� 
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data,[])        
       else  %Pokud nebyla na�ten� ��dn� vstupn� data, vyhod� se chybov� hl�ka
          errordlg('CHYBA - zkontroluj zda m� vybran� vstupn� data','Chyba!')    
       end  

       %Zobrazen� popisku dole, pro ov��en�, �e cyklus dojel  
       set(handles.text_median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','on')    

       %Byl pou�it� Frost filtr � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne 
       handles.pom_vyber_filtr = 3; 
        
otherwise %Pokud se vybere cokoli jin�ho, v tomto p��pad� sp�e nevybere
       
       %Nezobraz� se ��dn� texty ani "edit"
       set(handles.filtr_okno_text,'visible','off') 
       set(handles.filtr_okno,'visible','off')
       set(handles.text_Median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','off') 
       set(handles.filtr_button,'visible','off');
       
       %Filtr nebyl pou�it� � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne     
       handles.pom_vyber_filtr = 0;    
       
end
         
guidata(hObject, handles)

% Pokud se klikne na tla��tko Restartovat,provede se:   (v�e se restartuje)
function reset_Callback(hObject, eventdata, handles)
OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
GUI               %Otev�en� nov�ho GUI 
