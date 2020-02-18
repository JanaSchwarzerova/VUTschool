function varargout = GUI(varargin)
% GUI MATLAB kód pro GUI.fig
%      GUI, sám o sobì vytváøí nové grafické uživatelské rozhraní 
%
%      H = GUI vrátí "handle" k novému GUI nebo "handle" k existující
%      jednotce/promìnné
%
%      GUI('CALLBACK',hObject,eventData,handles,...) zavolání lokální
%      funkce jménem CALL BACK V GUI.M s danými vstupními argumenty
%
%      GUI('Property','Value',...) vytvoøí nové GUI nebo zavede
%      existující jedntoku/promìnou. Zaèína z leva, vlastnosti/hodnoty argumentù 
%      jsou aplikovány do GUI pøed GUI_OpeningFcn získané zavoláním.
%      Nerozpoznané vlastnosti jmena nebo neplatné hodnoty vytváøí
%      vlastnosti stopových aplikací (chybových hlášek).
%      Všechny vstupy jsou pøedávány do GUI_OpeningFcn pøes varargin.
%
% Poslední úpravy: v GUIDE 14-04-2018 10:57:39

%Zaèátek inicializaèního kódu – NEUPRAVOVAT: 
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
%Konce inicializaèního kódu.


% Spustí se tìsnì pøedtím, než je grafické uživatelské rozhraní viditelné.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% Tato funkce nemá výstupní argumenty, viz OutputFcn.
% hObject    "handle" k zobrazení
% eventdata  reserved - které budou definovány v budoucí verzi MATLABu
% handles    struktura s "handles" a uživatelská data (viz GUIDATA)
% varargin   argumenty pøíkazových øádkù k GUI (viz VARARGIN)

% Zvolení výchozího výstupu pøíkazového øádku pro GUI
handles.output = hObject;

handles.pom_vyber_metody = 0;    %Pomocná pro výbìr segmentaèní metody
handles.pom_vyber_filtr = 0;     %Pomocná pro výbìr filtrace
handles.pom_vyber_dat = 0;       %Pomocná pro výbìr vstupních dat
handles.pom = 0;                 %Pomocná pro ošetøení, aby vždy byly vloženy vstupní data
handles.Vstupni_data =[];        %Pøeddefinovaná promìnná pro vstupní data
handles.vyber_filtr = 0;         %Pøeddefinovaná promìnná pro výbìr filtru

%Aktualizace; popisující strukturu:
guidata(hObject, handles); 

% UIWAIT dìlá GUI èekat na odpovìï uživatele (viz UIRESUME)
% uiwait(handles.figure1);

% --- Výstupy z této funkce se vrátí do pøíkazového øádku.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  bunìèné pole pro návrat výstupních argumentù (viz VARARGOUT);
% hObject    "handle" k zobrazení
% eventdata  reserved - které budou definovány v budoucí verzi MATLABu
% handles    struktura s "handles" a uživatelská data (viz GUIDATA)

% Získání výchozího výstupu pøíkazového øádku ze struktury úchytù
varargout{1} = handles.output;

%**************************************************************************
%_______________________________Filtrace___________________________________

% Provede pøi zmìnì výbìru v souboru:  vybrat_filtr
function vybrat_filtr_Callback(hObject, eventdata, handles)

handles.vyber_filtr = get(hObject,'Value'); %Vybere se konkrétní typ filtrace pomocí "Pop-up Menu"

%Hodnota filtrovacího okna (tato hodnota se nastavuje stejnì pro všechny filtry)
%defuatnì nastavená na hodnotì 5 v GUI se dá ovšem i pøepsat 
x = get(handles.filtr_okno,'string'); 
x = str2num(x);

switch handles.vyber_filtr
     case 1 %Bez filtrace..................................................
       
       %Zneviditelných zbyteèných argumentù pro tuto akci: 
       set(handles.filtr_okno_text,'visible','off') 
       set(handles.filtr_okno,'visible','off')
       set(handles.text_median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','off')
       set(handles.filtr_button,'visible','off');
       
       %Naètení obrázku bez filtrace        
       bez_filtr = imread('GUI_bez_filtrace.png');  
       axes(handles.Filtr_obr)
       imshow(bez_filtr)  
       handles.Filtr_data = handles.Vstupni_data; 
       
       %Filtr nebyl použitý – pomocná promìnná pro to zda byl použitý filtr, èi ne        
       handles.pom_vyber_filtr = 0; 
        
     case 2 %Mediánový filtr...............................................
       
       %Zviditelnìní vstupního okna do filtru, hodnota je defuatlnì
       %nastavená na 5; v GUI se dá ovšem i pøepsat
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')
       set(handles.filtr_button,'visible','on');
                 
        if handles.pom == 1 %Pokud byly naèteny vstupní data, provede se mediánová filtrace
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1 %Pokud byla naètená reálna data, provede se ošetøení 
                                                              %pro bezchybné zobrazení
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data,[])                    
        else %Pokud nebyla naètená žádná vstupní data, vyhodí se chybová hláška
            errordlg('CHYBA - zkontroluj zda máš vybrané vstupní data','Chyba!')    
        end
        
        %Zobrazení popisku dole, pro ovìøení, že cyklus dojel
        set(handles.text_Lee,'visible','off')
        set(handles.text_Frost,'visible','off')                
        set(handles.text_median,'visible','on')
        
        %Byl použitý Median_filtr – pomocná promìnná pro to zda byl použitý filtr, èi ne 
        handles.pom_vyber_filtr = 1; 
                
     case 3 %Lee filtr.....................................................
         
        %Zviditelnìní vstupního okna do filtru, hodnota je defuatlnì
        %nastavená na 5; v GUI se dá ovšem i pøepsat         
        set(handles.filtr_okno_text,'visible','on') 
        set(handles.filtr_okno,'visible','on') 
        set(handles.filtr_button,'visible','on');     
        
        if handles.pom == 1 %Pokud byly naèteny vstupní data, provede se Lee filtrace
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla naètená reálna data, provede se ošetøení 
                                                             %pro bezchybné zobrazení
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data,[])        
        else %Pokud nebyla naètená žádná vstupní data, vyhodí se chybová hláška
            errordlg('CHYBA - zkontroluj zda máš vybrané vstupní data','Chyba!')    
        end
        
        %Zobrazení popisku dole, pro ovìøení, že cyklus dojel        
        set(handles.text_median,'visible','off')
        set(handles.text_Frost,'visible','off')
        set(handles.text_Lee,'visible','on')

        %Byl použitý Lee filtr – pomocná promìnná pro to zda byl použitý filtr, èi ne       
        handles.pom_vyber_filtr = 2; 
        
     case 4 %Frost filtr...................................................

       %Zviditelnìní vstupního okna do filtru, hodnota je defuatlnì
       %nastavená na 5; v GUI se dá ovšem i pøepsat  
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')  
       set(handles.filtr_button,'visible','on');
       
       if handles.pom == 1 %Pokud byly naèteny vstupní data, provede se Frost filtrace
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data)
       elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla naètená reálna data, provede se ošetøení 
                                                            %pro bezchybné zobrazení 
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data,[])        
       else  %Pokud nebyla naètená žádná vstupní data, vyhodí se chybová hláška
          errordlg('CHYBA - zkontroluj zda máš vybrané vstupní data','Chyba!')    
       end  

       %Zobrazení popisku dole, pro ovìøení, že cyklus dojel  
       set(handles.text_median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','on')    

       %Byl použitý Frost filtr – pomocná promìnná pro to zda byl použitý filtr, èi ne 
       handles.pom_vyber_filtr = 3; 
        
otherwise %Pokud se vybere cokoli jiného, v tomto pøípadì spíše nevybere
       
       %Nezobrazí se žádné texty ani "edit"
       set(handles.filtr_okno_text,'visible','off') 
       set(handles.filtr_okno,'visible','off')
       set(handles.text_Median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','off') 
       set(handles.filtr_button,'visible','off');
       
       %Filtr nebyl použitý – pomocná promìnná pro to zda byl použitý filtr, èi ne     
       handles.pom_vyber_filtr = 0;    
       
end
         
guidata(hObject, handles)

% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function vybrat_filtr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
%____________________________Vybrání dat___________________________________
% Provede se pøi zmìnì výbìru v vybrat_data.
function vybrat_data_Callback(hObject, eventdata, handles)

vyber_dat = get(hObject,'Value'); %Vybere se konkrétní typ dat pomocí "Pop-up Menu"
axes(handles.Vstupni_obraz) %Data se zobrazí na "Axes" co nejvíc vlevo

switch vyber_dat 
     case 1 %Bez dat.......................................................
       
      %Pokud uživatel dá bez dat, vyjede mu varování, že nejsou vybrána žádná data
      warndlg('Nejsou vybrána vstupní data','Varování')
       
      %Pomocná pro výber vstupních dat – nejsou vybrána žádná data (pro pozdìjší ošetøení)
      handles.pom_vyber_dat = 0;
       
      %Zneviditelnìní pomocných tlaèítek pro segmentování metodou prahování
      set(handles.jedno_prah,'visible','off')
      set(handles.gray_prah,'visible','off')
      set(handles.dvoj_prah,'visible','off')
      %Zneviditelnìní parametrù pro Rozvodí
      set(handles.sobel,'visible','off')
      set(handles.robin,'visible','off')
      set(handles.prewitt,'visible','off')
              
     case 2 %Umìlý obraz...................................................
        
      %Pomocná pro výber vstupních dat – je vybrán umìlý obraz (pro pozdìjší ošetøení)  
      handles.pom_vyber_dat = 1; 
       
      %Umìlý obraz byl vytvoøen pro rùzné metody rùzný, tak aby na nìm
      %bylo vidìt co nejoptimálnìji funkènost algoritmu
      if handles.pom_vyber_metody == 2; % Umìlý obraz pro PRAHOVÁNÍ
          handles.Vstupni_data = imread('obr_prahovani_1.png'); %Naètení obrazu
          imshow(handles.Vstupni_data)
          [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
          handles.pom = 1; %Pro pozdìjší ošetøení, jestli existují nìjaké vstupní data a program mùže 
                           %v poøádku pokraèovat 

          %Použití filtrace po zmìnìní vstupních dat, aby se zobrazila v GUI
          x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
          x = str2num(x);
          if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
          
          % Defuatlnì nastavené doporuèené hodnoty pro segmentaci metodou
          % prahování na umìle vytvoøených obrázcích
          % pozdìjší využití tìchto hodnot bude ve funkci "Segmentace"
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
          
      elseif handles.pom_vyber_metody == 3; %Umìlý obraz pro NARÙSTÁNÍ OBLASTÍ
          handles.Vstupni_data = imread('obr_narustani_oblasti.png'); %Naètení obrazu 
          imshow(handles.Vstupni_data)
          [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
          handles.pom = 1; %Pro pozdìjší ošetøení, jestli existují nìjaké vstupní data a program mùže 
                           %v poøádku pokraèovat
                                 
          %Použití filtrace po zmìnìní vstupních dat, aby se zobrazila v GUI
          x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
          x = str2num(x);
          if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
       elseif handles.pom_vyber_metody == 4; %Umìlý obraz pro ROZVODÍ
           handles.Vstupni_data = imread('obr_rozvodi_2.png'); %Naètení obrazu
           imshow(handles.Vstupni_data)
           [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
           handles.pom = 1; %Pro pozdìjší ošetøení, jestli existují nìjaké vstupní data a program mùže 
                            %v poøádku pokraèovat
                                 
           %Použití filtrace po zmìnìní vstupních dat, aby se zobrazila v GUI
           x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
           x = str2num(x);
           if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
      elseif handles.pom_vyber_metody == 5; %Umìlý obraz pro AKTIVNÍ KONTURY
         %Pro aktivní kontury nebyl vytvoøen umìlý obraz, proto se vyhodí chybová hláška
         errordlg('Pro tuto segmentaèní metodu nebyl vytvoøený umìlý obraz, zadej rovnou fantomové nebo reálné data','Chyba!')
      else
          %Toto zobrazení jak již bylo uvedeno záleží na vybrané metodì segmentování, 
          %proto pokud není vybraná metoda se vyhodí chybová hláška
          errordlg('Pro toto zobrazení, je dùležité aby byla také vybrána metoda segmentování!','Chyba!')
      end
            
      %Zneviditelnìní pomocných tlaèítek po segmentování metodou prahování
      set(handles.jedno_prah,'visible','off')
      set(handles.gray_prah,'visible','off')
      set(handles.dvoj_prah,'visible','off') 
      %Zneviditelnìní parametrù pro Rozvodí
      set(handles.sobel,'visible','off')
      set(handles.robin,'visible','off')
      set(handles.prewitt,'visible','off')                  
            
     case 3 %Fantomové data................................................ 
         
      %Pomocná pro výber vstupních dat – je vybrán Fantomový obraz (pro pozdìjší ošetøení)    
      handles.pom_vyber_dat = 3;         
      handles.Vstupni_data = imread('koncentrace_sem_1.bmp');  %Naètení fantomových dat
      imshow(handles.Vstupni_data)
      [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
      handles.pom = 1; %Pro pozdìjší ošetøení, jestli existují nìjaké vstupní data a program mùže 
                       %v poøádku pokraèovat
                                 
      %Použití filtrace po zmìnìní vstupních dat, aby se zobrazila v GUI
      x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
      x = str2num(x);
      if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
                                
      % Defuatlnì nastavené doporuèené hodnoty pro segmentaci metodou
      % prahování na fantomové data
      % pozdìjší využití tìchto hodnot bude ve funkci "Segmentace"
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
                 
     %Zneviditelnìní pomocných tlaèítek po segmentování metodou prahování
     set(handles.jedno_prah,'visible','off')
     set(handles.gray_prah,'visible','off')
     set(handles.dvoj_prah,'visible','off')
     %Zneviditelnìní parametrù pro Rozvodí
     set(handles.sobel,'visible','off')
     set(handles.robin,'visible','off')
     set(handles.prewitt,'visible','off')
            
   case 4 %Reálné data...................................................
       
     %Pomocná pro výber vstupních dat – je vybrán Reálný obraz (pro pozdìjší ošetøení)   
     handles.pom_vyber_dat = 2; 
     %Naètení reálného obrazu
     load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
     handles.Vstupni_data = data1{100};
     imshow(handles.Vstupni_data,[])
     [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
     handles.pom = 1; %Pro pozdìjší ošetøení, jestli existují nìjaké vstupní data a program mùže 
                      %v poøádku pokraèovat
                                 
     %Použití filtrace po zmìnìní vstupních dat, aby se zobrazila v GUI
     x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
     x = str2num(x);
     if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
                                
     % Defuatlnì nastavené doporuèené hodnoty pro segmentaci metodou
     % prahování na reálné data
     % pozdìjší využití tìchto hodnot bude ve funkci "Segmentace"
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
                 
     %Zneviditelnìní pomocných tlaèítek po segmentování metodou prahování
     set(handles.jedno_prah,'visible','off')
     set(handles.gray_prah,'visible','off')
     set(handles.dvoj_prah,'visible','off')
     %Zneviditelnìní parametrù pro Rozvodí
     set(handles.sobel,'visible','off')
     set(handles.robin,'visible','off')
     set(handles.prewitt,'visible','off')
  
  case 5 %Co si bude chtít nahrát uživatel.................................
      
    %Pomocná pro výber vstupních dat – je vybrán libovolný obraz (pro pozdìjší ošetøení)   
    handles.pom_vyber_dat = 4;   
    
    %Výbìr libovolného obrázku uživatelem s doporuèenými konocovkami souboru
    [nazev_souboru, cesta] = uigetfile({'*.bmp';'*.jpg';'*.png'},'Vyber soubor');
    if isequal (nazev_souboru,0)||isequal(cesta,0)
       warndlg('Nejsou vybrána vstupní data','Varování')
    else
       nazev_souboru = strcat(cesta,nazev_souboru);
       handles.Vstupni_data = imread(nazev_souboru);
       imshow(handles.Vstupni_data)
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       handles.pom = 1; %Pro pozdìjší ošetøení, jestli existují nìjaké vstupní data a program mùže 
                        %v poøádku pokraèovat
                        
      %Použití filtrace po zmìnìní vstupních dat, aby se zobrazila v GUI
      x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
      x = str2num(x);
      if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
    
     % Defuatlnì nastavené doporuèené hodnoty pro segmentaci metodou
     % prahování na libovolná data
     % pozdìjší využití tìchto hodnot bude ve funkci "Segmentace"
     if handles.pom_vyber_metody == 2%defuatlnì nastavené doporuèené hodnoty pro prahování                
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
        
   %Zneviditelnìní pomocných tlaèítek po segmentování metodou prahování
   set(handles.jedno_prah,'visible','off')
   set(handles.gray_prah,'visible','off')
   set(handles.dvoj_prah,'visible','off')
   %Zneviditelnìní parametrù pro Rozvodí
   set(handles.sobel,'visible','off')
   set(handles.robin,'visible','off')
   set(handles.prewitt,'visible','off')              
                  
 otherwise %Pokud se vybere cokoli jiného, v tomto pøípadì spíše nevybere
           %tak program nic neudìlá
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
  
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function vybrat_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
%______________________Vybrání segmentaèní metody__________________________
% Provede se pøi zmìnì výbìru v vybrat_seg_metodu.
function vybrat_seg_metodu_Callback(hObject, eventdata, handles)

vyber_metody = get(hObject,'Value'); %Vybere se konkrétní typ segmentaèní metody pomocí "Pop-up Menu"

switch vyber_metody 
    
  case 1 %Bez segmentaèní metody...........................................
      
    %Pomocná pro výber segmetaèní metody – není vybrána segmentaèní metoda (pro pozdìjší ošetøení)  
    handles.pom_vyber_metody = 1;  
                
    %Zneviditelnìní ostatních vìcí (texty k daným hodnotám atd.)
    %Zneviditelnìní vstupních parametrù pro metodu segmentování
    set(handles.Prah,'visible','off') 
    set(handles.PrahH,'visible','off')
    set(handles.PrahD,'visible','off')
    set(handles.hodnota_Prah,'visible','off')
    set(handles.hodnota_PrahH,'visible','off')
    set(handles.hodnota_PrahD,'visible','off')
    set(handles.text_Prah,'visible','off')
    set(handles.text_PrahH,'visible','off')
    set(handles.text_PrahD,'visible','off') 
    %Zneviditelnìní pomocných tlaèítek pro segmentování metodou prahování
    set(handles.jedno_prah,'visible','off')
    set(handles.gray_prah,'visible','off')
    set(handles.dvoj_prah,'visible','off')
    %Zneviditelnìní vstupních parametrù pro Narùstání oblastí
    set(handles.nastav_hodnot_narust_oblast,'visible','off')               
    set(handles.text_max_interval,'visible','off')
    set(handles.max_interval,'visible','off')
    set(handles.text_defualt_nastav,'visible','off')               
    set(handles.text_souradnice,'visible','off')
    set(handles.text_x,'visible','off')
    set(handles.text_y,'visible','off')
    set(handles.sourad_x,'visible','off')
    set(handles.sourad_y,'visible','off')
    %Zneviditelnìní parametrù pro Rozvodí
    set(handles.sobel,'visible','off')
    set(handles.robin,'visible','off')
    set(handles.prewitt,'visible','off')
    %Zneviditelní potøebných parametrù na aktivní kontury
    set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
    set(handles.text_max_it,'visible','off')
    set(handles.max_iterace,'visible','off')
    
  case 2 %Výbìr metody PRAHOVÁNÍ ..........................................

  %Zneviditelnìní ostatních vìcí (texty k daným hodnotám atd.)     
  %Zneviditelnìní pomocných tlaèítek po segmentování metodou prahování
  set(handles.jedno_prah,'visible','off')
  set(handles.gray_prah,'visible','off')
  set(handles.dvoj_prah,'visible','off')  
  %Zneviditelnìní vstupních parametrù pro Narùstání oblastí
  set(handles.nastav_hodnot_narust_oblast,'visible','off')               
  set(handles.text_max_interval,'visible','off')
  set(handles.max_interval,'visible','off')
  set(handles.text_defualt_nastav,'visible','off')               
  set(handles.text_souradnice,'visible','off')
  set(handles.text_x,'visible','off')
  set(handles.text_y,'visible','off')
  set(handles.sourad_x,'visible','off')
  set(handles.sourad_y,'visible','off')          
  %Zneviditelnìní parametrù pro Rozvodí
  set(handles.sobel,'visible','off')
  set(handles.robin,'visible','off')
  set(handles.prewitt,'visible','off')
  %Zneviditelní potøebných parametrù na aktivní kontury
  set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
  set(handles.text_max_it,'visible','off')
  set(handles.max_iterace,'visible','off')
    
    %Pomocná pro výber segmetaèní metody – segmentaèní metoda prahování (pro pozdìjší ošetøení)       
    handles.pom_vyber_metody = 2;  
                
    %Zviditelnìní hodnot a parametrù vstupující do segemtaèní metody prahování
    set(handles.Prah,'visible','on') 
    set(handles.PrahH,'visible','on')
    set(handles.PrahD,'visible','on')
    set(handles.hodnota_Prah,'visible','on')
    set(handles.hodnota_PrahH,'visible','on')
    set(handles.hodnota_PrahD,'visible','on')
    set(handles.text_Prah,'visible','on')
    set(handles.text_PrahH,'visible','on')
    set(handles.text_PrahD,'visible','on') 
                
    if handles.pom_vyber_dat == 1 %Zobrazení v GUI umìlého obrázu, po vybrání metody segmentace
       handles.Vstupni_data = imread('obr_prahovani_1.png');
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data)
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       handles.pom = 1;%Pro pozdìjší ošetøení, jestli existují nìjaké vstupní data a program mùže 
                       %v poøádku pokraèovat
                       
       %Použití filtrace po zmìnìní segmentaèní metody, aby se zobrazila v GUI
       x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
       x = str2num(x);
       if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
      
      % Defuatlnì nastavené doporuèené hodnoty pro segmentaci metodou
      % prahování na umìlém obrázku
      % pozdìjší využití tìchto hodnot bude ve funkci "Segmentace"                                       
      set(handles.hodnota_Prah,'Value',130) 
      set(handles.hodnota_Prah,'String','130') 
      set(handles.hodnota_PrahD,'Value',20) 
      set(handles.hodnota_PrahD,'String','20') 
      set(handles.hodnota_PrahH,'Value',200) 
      set(handles.hodnota_PrahH,'String','200') 
      set(handles.Prah,'Value',130)   
      set(handles.PrahD,'Value',20)  
      set(handles.PrahH,'Value',200)
      
    elseif handles.pom_vyber_dat == 2 %Zobrazení v GUI Reálného obrázu, po vybrání metody segmentace
      % Defuatlnì nastavené doporuèené hodnoty pro segmentaci metodou
      % prahování na Reálný obraz
      % pozdìjší využití tìchto hodnot bude ve funkci "Segmentace"                  
      set(handles.hodnota_Prah,'Value',130) 
      set(handles.hodnota_Prah,'String','130') 
      set(handles.hodnota_PrahD,'Value',5) 
      set(handles.hodnota_PrahD,'String','5') 
      set(handles.hodnota_PrahH,'Value',100) 
      set(handles.hodnota_PrahH,'String','100') 
      set(handles.Prah,'Value',130)   
      set(handles.PrahD,'Value',5)  
      set(handles.PrahH,'Value',100)
                 
    elseif handles.pom_vyber_dat == 3 %Zobrazení v GUI Fantomového obrázu, po vybrání metody segmentace
      % Defuatlnì nastavené doporuèené hodnoty pro segmentaci metodou
      % prahování na Fantomový obraz
      % pozdìjší využití tìchto hodnot bude ve funkci "Segmentace"         
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
      % Defuatlnì nastavené doporuèené hodnoty pro segmentaci metodou
      % prahování na libovolný obraz
      % pozdìjší využití tìchto hodnot bude ve funkci "Segmentace"                    
      set(handles.hodnota_Prah,'Value',0) 
      set(handles.hodnota_Prah,'String','0') 
      set(handles.hodnota_PrahD,'Value',0) 
      set(handles.hodnota_PrahD,'String','0') 
      set(handles.hodnota_PrahH,'Value',0) 
      set(handles.hodnota_PrahH,'String','0') 
      set(handles.Prah,'Value',0)   
      set(handles.PrahD,'Value',0)  
      set(handles.PrahH,'Value',0)
      
   else %Pokud nejsou vybrána žádná vstupní data, vychodí se chybová hláška
     warndlg('Nejsou vybrána vstupní data','Varování')
    end
   
 case 3 %Výbìr metody NARÙSTÁNÍ OBLASTÍ...................................

  %Zneviditelnìní ostatních vìcí (texty k daným hodnotám atd.)     
  %Zneviditelnìní parametrù pro prahování
  set(handles.Prah,'visible','off') 
  set(handles.PrahH,'visible','off')
  set(handles.PrahD,'visible','off')
  set(handles.hodnota_Prah,'visible','off')
  set(handles.hodnota_PrahH,'visible','off')
  set(handles.hodnota_PrahD,'visible','off')
  set(handles.text_Prah,'visible','off')
  set(handles.text_PrahH,'visible','off')
  set(handles.text_PrahD,'visible','off')
  %Zneviditelnìní pomocných tlaèítek po segmentování metodou prahování
  set(handles.jedno_prah,'visible','off')
  set(handles.gray_prah,'visible','off')
  set(handles.dvoj_prah,'visible','off')  
  %Zneviditelnìní parametrù pro Rozvodí
  set(handles.sobel,'visible','off')
  set(handles.robin,'visible','off')
  set(handles.prewitt,'visible','off')
  %Zneviditelní potøebných parametrù na aktivní kontury
  set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
  set(handles.text_max_it,'visible','off')
  set(handles.max_iterace,'visible','off')
  
  %Pomocná pro výber segmetaèní metody – segmentaèní metoda narùstání oblastí (pro pozdìjší ošetøení)    
  handles.pom_vyber_metody = 3; 
              
  %Zviditelnìní nastavitelných vstupních parametrù
  set(handles.nastav_hodnot_narust_oblast,'visible','on') 
  set(handles.text_max_interval,'visible','on')
  set(handles.max_interval,'visible','on')
              
  %Pøi výbìru Lee a Frost filtru se defualtnì nastaví hodnota maximálního intervalu 
  %intenzity na 0.1 v jiných pøípadech 0.2
  if handles.pom_vyber_filtr == 2 || handles.pom_vyber_filtr == 3
     set(handles.max_interval,'Value',0.1)       
     set(handles.max_interval,'String',0.1)   
  else
     set(handles.max_interval,'Value',0.2)       
     set(handles.max_interval,'String',0.2)   
  end
              
  if handles.pom_vyber_dat == 1 %Zobrazení pro umìlý obraz, po vybrání metody segmentace
     handles.Vstupni_data = imread('obr_narustani_oblasti.png');
     axes(handles.Vstupni_obraz)
     imshow(handles.Vstupni_data)
     [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
     handles.pom = 1;%Pro pozdìjší ošetøení, jestli existují nìjaké vstupní data a program mùže 
                     %v poøádku pokraèovat 
                     
    %Použití filtrace po zmìnìní segmentaèní metody, aby se zobrazila v GUI
    x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
    x = str2num(x);
    if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
  
  %Nastavení parametrù pro pozdìjší použití v segmentaci metodou narùstání oblastí
  if handles.pom == 1                      %Pokud jsou vybrána data proveï
     if get(handles.manual,'Value') == 1;  %jestli je zakliknuté, že chceš provést manuální výbìr vstupních hodnot, tak
                                           %se položí otázka: 
        otazka = questdlg('Budeš chtít najít manuálnì hodnotu ve Vstupních datech nebo ve Filtrovaném obrazu?','Výbìr',...
                           'Vstupní data','Filtrovaný obraz','Defualtnì','Defualtnì');
        switch otazka
          case 'Vstupní data' %Pokud vybereš, že chceš urèit vstupní hodnoty ze vstupního obrazu
             axes(handles.Vstupni_obraz)   
             [y,x]=getpts; %urèení vstupních hodnot do metody segmentace narùstání oblastí manuálnì pomocí funkce getpts
             handles.y=round(y(1));
             handles.x=round(x(1));
          case 'Filtrovaný obraz' %Pokud vybereš, že chceš urèit vstupní hodnoty z filtrovaného obrazu
             if handles.pom_vyber_filtr == 0; %musí být pøedem provedena filtrace, jinak se vypíše chybová hláška
                errordlg('Pro tento výbìr musíš mít filtrovaný obraz,znovu vyber filtrovací metodu','Chyba')   
             else
               axes(handles.Filtr_obr)  
               [y,x]=getpts; %urèení vstupních hodnot do metody segmentace narùstání oblastí manuálnì pomocí funkce getpts
               handles.y=round(y(1));
               handles.x=round(x(1));  
             end
          case 'Defualtnì' %Pokud vybereš, že chceš urèit hodnoty defualtnì
             handles.manual.Value = 0; %Automatické pøepnutí na výbìr defualtního nastavení
             handles.defualt.Value = 1; 
             
             %Zobrazení potøebných vstupních hodnot, které jsou defualtnì
             %nastavené ale v GUI se dají libovolnì mìnit
             set(handles.text_defualt_nastav,'visible','on'); 
             set(handles.text_souradnice,'visible','on'); 
             set(handles.text_x,'visible','on');
             set(handles.text_y,'visible','on');
             set(handles.sourad_x,'visible','on');
             set(handles.sourad_y,'visible','on');
                       
            %Defualtní nastavení souøadnic (defualtnì se bude vycházet ze støedu obrazu)
             rozmery = size(handles.Vstupni_data);
             handles.x=round(rozmery(1)/2); 
             handles.y=round(rozmery(2)/2);
             set(handles.sourad_x,'Value',handles.x);
             set(handles.sourad_y,'Value',handles.y);
             set(handles.sourad_x,'String',num2str(handles.x));
             set(handles.sourad_y,'String',num2str(handles.y));                       
        end
        
     elseif get(handles.defualt,'Value') == 1; %jestli je zakliknuté, že chceš provést defualtní výbìr vstupních hodnot

        %Automatické pøepnutí na výbìr defualtního nastavení   
        handles.manual.Value = 0; 
        handles.deufalt.Value = 1; 
        
        %Zobrazení potøebných vstupních hodnot, které jsou defualtnì
        %nastavené ale v GUI se dají libovolnì mìnit        
        set(handles.text_defualt_nastav,'visible','on');
        set(handles.text_souradnice,'visible','on'); 
        set(handles.text_x,'visible','on');
        set(handles.text_y,'visible','on');
        set(handles.sourad_x,'visible','on');
        set(handles.sourad_y,'visible','on');
                       
        %Defualtní nastavení souøadnic (defualtnì se bude vycházet ze støedu obrazu)
        rozmery = size(handles.Vstupni_data);
        handles.x=round(rozmery(1)/2); 
        handles.y=round(rozmery(2)/2);
        set(handles.sourad_x,'Value',handles.x);
        set(handles.sourad_y,'Value',handles.y);
        set(handles.sourad_x,'String',num2str(handles.x));
        set(handles.sourad_y,'String',num2str(handles.y));                          
     else %Pokud cokoli jiného vyhodí se chybová hláška
        warndlg('Zkontroluj zda máš nastavené všechny potøebné atributy','Varování')  
     end
  else %Pokud nejsou vybrané vstupní data vyhodí se chybová hláška 
     errordlg('CHYBA - zkontroluj zda máš vybrané vstupní data','Chyba!')
  end
                               
 case 4%Výbìr metody ROZVODÍ...............................................
     
  %Zneviditelnìní ostatních vìcí (texty k daným hodnotám atd.)     
  %Zneviditelnìní parametrù pro prahování
  set(handles.Prah,'visible','off') 
  set(handles.PrahH,'visible','off')
  set(handles.PrahD,'visible','off')
  set(handles.hodnota_Prah,'visible','off')
  set(handles.hodnota_PrahH,'visible','off')
  set(handles.hodnota_PrahD,'visible','off')
  set(handles.text_Prah,'visible','off')
  set(handles.text_PrahH,'visible','off')
  set(handles.text_PrahD,'visible','off')
  %Zneviditelnìní vstupních parametrù pro Narùstání oblastí
  set(handles.nastav_hodnot_narust_oblast,'visible','off')               
  set(handles.text_max_interval,'visible','off')
  set(handles.max_interval,'visible','off')
  set(handles.text_defualt_nastav,'visible','off')               
  set(handles.text_souradnice,'visible','off')
  set(handles.text_x,'visible','off')
  set(handles.text_y,'visible','off')
  set(handles.sourad_x,'visible','off')
  set(handles.sourad_y,'visible','off')  
  %Zneviditelnìní pomocných tlaèítek po segmentování metodou prahování
  set(handles.jedno_prah,'visible','off')
  set(handles.gray_prah,'visible','off')
  set(handles.dvoj_prah,'visible','off')  
  %Zneviditelnìní parametrù pro Rozvodí
  set(handles.sobel,'visible','off')
  set(handles.robin,'visible','off')
  set(handles.prewitt,'visible','off')
  %Zneviditelní potøebných parametrù na aktivní kontury
  set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
  set(handles.text_max_it,'visible','off')
  set(handles.max_iterace,'visible','off')
  
  %Pomocná pro výber segmetaèní metody – segmentaèní metodu Rozvodí (pro pozdìjší ošetøení)
  handles.pom_vyber_metody = 4;  
                
  if handles.pom_vyber_dat == 1 %Zobrazení pro umìlé obrázky, po vybrání metody segmentace
     handles.Vstupni_data = imread('obr_rozvodi_2.png');
     axes(handles.Vstupni_obraz)
     imshow(handles.Vstupni_data)
     [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
     handles.pom = 1; %Pro pozdìjší ošetøení, jestli existují nìjaké vstupní data a program mùže 
                     %v poøádku pokraèovat 
  end 
              
    %Použití filtrace po zmìnìní segmentaèní metody, aby se zobrazila v GUI
    x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
    x = str2num(x);
    if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
                         
 case 5 %Výbìr metody AKTIVNÍ KONTURY......................................

  %Zneviditelnìní ostatních vìcí (texty k daným hodnotám atd.)     
  %Zneviditelnìní parametrù pro prahování
  set(handles.Prah,'visible','off') 
  set(handles.PrahH,'visible','off')
  set(handles.PrahD,'visible','off')
  set(handles.hodnota_Prah,'visible','off')
  set(handles.hodnota_PrahH,'visible','off')
  set(handles.hodnota_PrahD,'visible','off')
  set(handles.text_Prah,'visible','off')
  set(handles.text_PrahH,'visible','off')
  set(handles.text_PrahD,'visible','off')
  %Zneviditelnìní vstupních parametrù pro Narùstání oblastí
  set(handles.nastav_hodnot_narust_oblast,'visible','off')               
  set(handles.text_max_interval,'visible','off')
  set(handles.max_interval,'visible','off')
  set(handles.text_defualt_nastav,'visible','off')               
  set(handles.text_souradnice,'visible','off')
  set(handles.text_x,'visible','off')
  set(handles.text_y,'visible','off')
  set(handles.sourad_x,'visible','off')
  set(handles.sourad_y,'visible','off')  
  %Zneviditelnìní pomocných tlaèítek po segmentování metodou prahování
  set(handles.jedno_prah,'visible','off')
  set(handles.gray_prah,'visible','off')
  set(handles.dvoj_prah,'visible','off')  
  %Zneviditelnìní parametrù pro Rozvodí
  set(handles.sobel,'visible','off')
  set(handles.robin,'visible','off')
  set(handles.prewitt,'visible','off')
  
  %Pomocná pro výber segmetaèní metody – segmentaèní metoda aktivní kontury (pro pozdìjší ošetøení) 
  handles.pom_vyber_metody = 5;
                
   if handles.pom_vyber_dat == 1 %Pokud se vybere metoda segmentovaní aktivní kontury, když budou vybrána vstupní data 
                                 %jako umìlý obraz, vyhodí se chybová hláška
      warndlg('Po vybrání jiných atributù zadej znovu segmentaèní metodu','Varování')  
      errordlg('Pro tuto segmentaèní metodu nebyl vytvoøený umìlý obraz, zadej rovnou fantomové nebo reálné data','Chyba!')

   else %Pokud cokoli jiného
    %Použití filtrace po zmìnìní segmentaèní metody, aby se zobrazila v GUI
     x = get(handles.filtr_okno,'string'); %Hodnota filtrovacího okna
     x = str2num(x);
     if handles.pom_vyber_filtr == 1 %Medianová filtrace
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
   
   %Zviditelní potøebných parametrù na aktivní kontury
   set(handles.nastaveni_hodnot_aktiv_kontur,'visible','on') 
   set(handles.text_max_it,'visible','on')
   set(handles.max_iterace,'visible','on')
   set(handles.max_iterace,'Value',800)   
   set(handles.max_iterace,'String','800')  
   
   %Nastavení parametrù pro pozdìjší použití v segmentaci metodou aktivních kontur
   if handles.pom == 1 && handles.pom_vyber_dat ~= 1 %Pokud jsou vybrána data proveï a nejsou vybrána data umìlá
          otazka = questdlg('Budeš chtít najít manuálnì hodnotu ve Vstupních datech nebo ve Filtrovaném obrazu?','Výbìr',...
                            'Vstupní data','Filtrovaný obraz','Filtrovaný obraz');
         switch otazka
           case 'Vstupní data' %Pokud vybereš, že chceš urèit vstupní hodnoty ze vstupního obrazu
            axes(handles.Vstupni_obraz)   
            handles.pocatecni_maska=roipoly(handles.Vstupni_data); %urèení vstupní masky do metody segmentace aktivních kontur pomocí funkce roipoly
           case 'Filtrovaný obraz' %Pokud vybereš, že chceš urèit vstupní hodnoty z filtrovaného obrazu
            if handles.pom_vyber_filtr == 0; %musí být pøedem provedena filtrace, jinak se vypíše chybová hláška
               errordlg('Pro tento výbìr musíš mít filtrovaný obraz, znovu vyber filtrovací metodu','Chyba')   
            else
               axes(handles.Filtr_obr)
               handles.pocatecni_maska=roipoly(handles.Vstupni_data); %urèení vstupní masky do metody segmentace aktivních kontur pomocí funkce roipoly
            end
         end
         handles.manual_AK.Value = 0; %Automatické pøepnutí na výbìr defualtního nastavení
         handles.defualt_AK.Value = 1; 
                  
     else %Pokud cokoli jiného vyhodí se chybová hláška
        warndlg('Zkontroluj zda máš nastavené všechny potøebné atributy','Varování')  
   end
   
   
    otherwise %Pokud se vybere cokoli jiného (èi nevybere)
              %program nic neprovede    
 end
guidata(hObject, handles);

% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function vybrat_seg_metodu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%**************************************************************************
%___________________________SAMOTNÁ SEGMENTACE_____________________________
% Provede se pøi zmáèknutí tlaèítka "segmentace".
function segmentace_Callback(hObject, eventdata, handles)

%SEGMENTOVÁNÍ:
 if handles.pom == 1; %Provede se pokud jsou nahrané data
   if handles.pom_vyber_metody == 1; %Žádná metoda vypíše se chybová hláška
      errordlg('Musíš vybrat metodu segmentování','Chyba!')    
      
   elseif handles.pom_vyber_metody == 2; %PRAHOVÁNÍ.......................
      Prah = get(handles.hodnota_Prah,'string'); %Hodnota základního prahu
      Prah = str2num(Prah)/255;
      PrahD = get(handles.hodnota_PrahD,'string'); %Hodnota dolního prahu
      PrahD = str2num(PrahD)/255;
      PrahH = get(handles.hodnota_PrahH,'string'); %Hodnota horního prahu
      PrahH = str2num(PrahH)/255;
      %Zavolání funkce, která provede segmentovací metodu prahování
      if handles.pom_vyber_filtr == 0; %Filtr nebyl použitý
         [handles.Vystup_1,handles.Vystup_2,handles.Vystup_3] = Prahovani(handles.Vstupni_data,Prah,PrahD,PrahH);
         axes(handles.Segmen_Obraz)
         imshow(handles.Vystup_1) 
      else %Filtr byl použitý
         [handles.Vystup_1,handles.Vystup_2,handles.Vystup_3] = Prahovani(handles.Filtr_data,Prah,PrahD,PrahH);
         axes(handles.Segmen_Obraz)
         imshow(handles.Vystup_1) 
      end
      %Zobrazení pomocných talèítek 
      set(handles.jedno_prah,'visible','on')
      set(handles.gray_prah,'visible','on')
      set(handles.dvoj_prah,'visible','on')
      set(handles.reset,'visible','on');
      
   elseif handles.pom_vyber_metody == 3; %NARÙSTÁNÍ OBLASTÍ...............
      %Vypsaní hodnoty maximálního intrevalu intenzity 
      reg_max = get(handles.max_interval,'String');
      reg_max = str2num(reg_max);
      %Zavolání funkce, která provede segmentovací metodu narùstání oblastí        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl použitý
         [handles.Vystup] = Narust_oblast(handles.Vstupni_data, handles.x, handles.y, reg_max);
         axes(handles.Segmen_Obraz)
         imshow(handles.Vystup)
      else %Filtr byl použitý
         [handles.Vystup] = Narust_oblast(handles.Filtr_data, handles.x, handles.y, reg_max);
         axes(handles.Segmen_Obraz)
         imshow(handles.Vystup)
      end
      set(handles.reset,'visible','on');
      
   elseif handles.pom_vyber_metody == 4; %ROZVODÍ..........................
     %Zavolání funkce, která provede segmentovací metodu rozvodí
     if handles.pom_vyber_filtr == 0; %Filtr nebyl použitý
        [handles.Vystup_Sobel, handles.Vystup_Robin, handles.Vystup_Prewitt] = Rozvodi(handles.Vstupni_data);
        axes(handles.Segmen_Obraz)
        imshow(handles.Vystup_Sobel)
     else %Filtr byl použitý
        [handles.Vystup_Sobel, handles.Vystup_Robin, handles.Vystup_Prewitt] = Rozvodi(handles.Filtr_data);
        axes(handles.Segmen_Obraz)
        imshow(handles.Vystup_Sobel)
     end
     %Zobrazení pomocných talèítek        
     set(handles.sobel,'visible','on')
     set(handles.robin,'visible','on')
     set(handles.prewitt,'visible','on')
     set(handles.reset,'visible','on');  
     
   elseif handles.pom_vyber_metody == 5; %AKTIVNÍ KONTURY..................
     max_it = get(handles.max_iterace,'String'); 
     max_it= str2num(max_it);
     %Zavolání funkce, která provede segmentovací metodu rozvodí           
     if handles.pom_vyber_filtr == 0; %Filtr nebyl použitý
        [Vystup] = Aktiv_kontur(handles.Vstupni_data, handles.pocatecni_maska, max_it);
         axes(handles.Segmen_Obraz) 
         imshow(handles.Vstupni_data)
         hold on
         contour(Vystup, [0 0], 'g','LineWidth',4);
         contour(Vystup, [0 0], 'k','LineWidth',2);
         hold off;
         set(handles.reset,'visible','on');
 
     else %Filtr byl použitý
         [Vystup] = Aktiv_kontur(handles.Filtr_data, handles.pocatecni_maska, max_it);
         axes(handles.Segmen_Obraz) 
         imshow(handles.Vstupni_data)
         hold on
         contour(Vystup, [0 0], 'g','LineWidth',4);
         contour(Vystup, [0 0], 'k','LineWidth',2);
         hold off;
         
         set(handles.reset,'visible','on');
     end
   else %Pokud cokoli jiného vyhodí se chybová hláška: 
     errordlg('CHYBA - zkontroluj zda máš vybranou metodu segmentování a vstupní data','Chyba!')
   end
 else %Pokud cokoli jiného vyhodí se chybová hláška: 
   errordlg('CHYBA - zkontroluj zda máš vybranou metodu segmentování a vstupní data','Chyba!')
 end
 guidata(hObject, handles);


 %%
%*************************************************************************
%_________________________Ostatní pomocné funkce___________________________

%Ostatní potøebné funkce/tlaèítka/parametry pro správné vložení urèitých
%paremetrù do urèitých segmentaèních metod

 
% Provede se když se "slider" pohne ... urèující hodnotu horního prahu
function PrahH_Callback(hObject, eventdata, handles)
pom_slider_prahH = get(hObject,'value'); %Do pomocné promìnné se uloží hodnota na posuvníku "slider"
set(handles.hodnota_PrahH,'String',num2str(pom_slider_prahH)); %ta se zobrazí do "edit" pøíslušného posuvníku "slideru"
guidata(hObject,handles);
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function PrahH_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Provede se když se "slider" pohne ... urèující hodnotu zákadního prahu
function Prah_Callback(hObject, eventdata, handles)
pom_slider_prah = get(hObject,'value'); %Do pomocné promìnné se uloží hodnota na posuvníku "slider"
set(handles.hodnota_Prah,'String',num2str(pom_slider_prah)); %ta se zobrazí do "edit" pøíslušného posuvníku "slideru"
guidata(hObject,handles);
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function Prah_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Provede se když se "slider" pohne ... urèující hodnotu dolního prahu
function PrahD_Callback(hObject, eventdata, handles)
pom_slider_prahD = get(hObject,'value'); %Do pomocné promìnné se uloží hodnota na posuvníku "slider"
set(handles.hodnota_PrahD,'String',num2str(pom_slider_prahD)); %ta se zobrazí do "edit" pøíslušného posuvníku "slideru"
guidata(hObject,handles);
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function PrahD_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function hodnota_Prah_Callback(hObject, eventdata, handles)
%Pokud se pøenastaví hodnota zakladního prahu ruènì v tlaèítku "edit" je
%nutné aby se posunul posuvník "slider" 
pom_edit_prah = get(hObject,'String');
set(handles.Prah,'value',str2num(pom_edit_prah));
guidata(hObject,handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function hodnota_Prah_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function hodnota_PrahD_Callback(hObject, eventdata, handles)
%Pokud se pøenastaví hodnota dolního prahu ruènì v tlaèítku "edit" je
%nutné aby se posunul posuvník "slider" pom_edit_prahD = get(hObject,'String');
set(handles.PrahD,'value',str2num(pom_edit_prahD));
guidata(hObject,handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function hodnota_PrahD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function hodnota_PrahH_Callback(hObject, eventdata, handles)
%Pokud se pøenastaví hodnota horního prahu ruènì v tlaèítku "edit" je
%nutné aby se posunul posuvník "slider" pom_edit_prahD = get(hObject,'String');
pom_edit_prahH = get(hObject,'String');
set(handles.PrahH,'value',str2num(pom_edit_prahH));
guidata(hObject,handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function hodnota_PrahH_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 

%Funkce pro volání hodnoty z "edit" filtrovacího okna
function filtr_okno_Callback(hObject, eventdata, handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function filtr_okno_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Když se zmáèknì tlaèítko jedno_prah provede se.
function jedno_prah_Callback(hObject, eventdata, handles)
%Pøepíše se Vystup z prahování na základní prahování
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_1) 

%Když se zmáèknì tlaèítko  gray_prah provede se.
function gray_prah_Callback(hObject, eventdata, handles)
%Pøepíše se Vystup z prahování na prahování pomocí funkce graythresh
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_2) 

%Když se zmáèknì tlaèítko dvoj_prah provede se.
function dvoj_prah_Callback(hObject, eventdata, handles)
%Pøepíše se Vystup z prahování na dvojté prahování
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_3) 

%Funkce pro volání hodnoty z "edit" souøadnice x
function sourad_x_Callback(hObject, eventdata, handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function sourad_x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Funkce pro volání hodnoty z "edit" souøadnice y
function sourad_y_Callback(hObject, eventdata, handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function sourad_y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Pokud se stiskne tlaèítko manualnì provede se.
function manual_Callback(hObject, eventdata, handles)
%Pokud je vybráno tlaèítko manuálnì
if get(hObject,'Value')== 1
    %Pøepsaní aktuálních hodnot:
    handles.manual.Value = 1;
    handles.defualt.Value = 0; 
    otazka = questdlg('Budeš chtít najít manuálnì hodnotu ve Vstupních datech nebo ve Filtrovaném obrazu?','Výbìr',...
                      'Vstupní data','Filtrovaný obraz','Defualtnì','Defualtnì');
    switch otazka
      case 'Vstupní data' %Pokud vybereš, že chceš urèit vstupní hodnoty ze vstupního obrazu
         axes(handles.Vstupni_obraz)   
         [y,x]=getpts; %urèení vstupních hodnot do metody segmentace narùstání oblastí manuálnì pomocí funkce getpts
         handles.y=round(y(1));
         handles.x=round(x(1));
      case 'Filtrovaný obraz' %Pokud vybereš, že chceš urèit vstupní hodnoty z filtrovaného obrazu
         if handles.pom_vyber_filtr == 0; %musí být pøedem provedena filtrace, jinak se vypíše chybová hláška
            errordlg('Pro tento výbìr musíš mít filtrovaný obraz, znovu vyber filtrovací metodu','Chyba')
         else
            axes(handles.Filtr_obr)  
            [y,x]=getpts; %urèení vstupních hodnot do metody segmentace narùstání oblastí manuálnì pomocí funkce getpts
            handles.y=round(y(1));
            handles.x=round(x(1));  
         end
      case 'Defualtnì' %Pokud vybereš, že chceš urèit hodnoty defualtnì
         handles.manual.Value = 0; %Automatické pøepnutí na výbìr defualtního nastavení
         handles.defualt.Value = 1; 
             
         %Zobrazení potøebných vstupních hodnot, které jsou defualtnì
         %nastavené ale v GUI se dají libovolnì mìnit
         set(handles.text_defualt_nastav,'visible','on'); 
         set(handles.text_souradnice,'visible','on'); 
         set(handles.text_x,'visible','on');
         set(handles.text_y,'visible','on');
         set(handles.sourad_x,'visible','on');
         set(handles.sourad_y,'visible','on');
                       
         %Defualtní nastavení souøadnic (defualtnì se bude vycházet ze støedu obrazu)
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

% Pokud se stiskne tlaèítko defualtnì provede se.
function defualt_Callback(hObject, eventdata, handles)
%Pokud je vybráno tlaèítko defualtnì
if get(hObject,'Value')== 1
    
         handles.manual.Value = 0; %Automatické pøepnutí na výbìr defualtního nastavení
         handles.defualt.Value = 1; 
             
         %Zobrazení potøebných vstupních hodnot, které jsou defualtnì
         %nastavené ale v GUI se dají libovolnì mìnit
         set(handles.text_defualt_nastav,'visible','on'); 
         set(handles.text_souradnice,'visible','on'); 
         set(handles.text_x,'visible','on');
         set(handles.text_y,'visible','on');
         set(handles.sourad_x,'visible','on');
         set(handles.sourad_y,'visible','on');
                       
         %Defualtní nastavení souøadnic (defualtnì se bude vycházet ze støedu obrazu)
         rozmery = size(handles.Vstupni_data);
         handles.x=round(rozmery(1)/2); 
         handles.y=round(rozmery(2)/2);
         set(handles.sourad_x,'Value',handles.x);
         set(handles.sourad_y,'Value',handles.y);
         set(handles.sourad_x,'String',num2str(handles.x));
         set(handles.sourad_y,'String',num2str(handles.y));  
   
else %Pokud cokoli jiného - není vybráno správné tlaèítko
    handles.defualt.Value = 0; 
end
guidata(hObject, handles);

%Funkce pro volání hodnoty z maximal_interval
function max_interval_Callback(hObject, eventdata, handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function max_interval_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Funkce pro volání hodnoty z sobel
function sobel_Callback(hObject, eventdata, handles)
%Vykreslení segmentace rozvodí pomocí sobelovy masky
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_Sobel) 

%Funkce pro volání hodnoty z robin
function robin_Callback(hObject, eventdata, handles)
%Vykreslení segmentace rozvodí pomocí robinsonovy masky
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_Robin) 

%Funkce pro volání Prewitt
function prewitt_Callback(hObject, eventdata, handles)
%Vykreslení segmentace rozvodí pomocí Prewittovy masky
axes(handles.Segmen_Obraz)
imshow(handles.Vystup_Prewitt) 

function max_iterace_Callback(hObject, eventdata, handles)

% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function max_iterace_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Pokud se stiskne tlaèítko Proveï filtraci provede se:
function filtr_button_Callback(hObject, eventdata, handles)

x = get(handles.filtr_okno,'string'); 
x = str2num(x);

switch handles.vyber_filtr
     case 1 %Bez filtrace..................................................
       
       %Zneviditelných zbyteèných argumentù pro tuto akci: 
       set(handles.filtr_okno_text,'visible','off') 
       set(handles.filtr_okno,'visible','off')
       set(handles.text_median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','off')
       set(handles.filtr_button,'visible','off');
       
       %Naètení obrázku bez filtrace        
       bez_filtr = imread('GUI_bez_filtrace.png');  
       axes(handles.Filtr_obr)
       imshow(bez_filtr)  
       handles.Filtr_data = handles.Vstupni_data; 
       
       %Filtr nebyl použitý – pomocná promìnná pro to zda byl použitý filtr, èi ne        
       handles.pom_vyber_filtr = 0; 
        
     case 2 %Mediánový filtr...............................................
       
       %Zviditelnìní vstupního okna do filtru, hodnota je defuatlnì
       %nastavená na 5; v GUI se dá ovšem i pøepsat
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')
       set(handles.filtr_button,'visible','on');
                 
        if handles.pom == 1 %Pokud byly naèteny vstupní data, provede se mediánová filtrace
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1 %Pokud byla naètená reálna data, provede se ošetøení 
                                                              %pro bezchybné zobrazení
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x x]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data,[])                    
        else %Pokud nebyla naètená žádná vstupní data, vyhodí se chybová hláška
            errordlg('CHYBA - zkontroluj zda máš vybrané vstupní data','Chyba!')    
        end
        
        %Zobrazení popisku dole, pro ovìøení, že cyklus dojel
        set(handles.text_Lee,'visible','off')
        set(handles.text_Frost,'visible','off')                
        set(handles.text_median,'visible','on')
        
        %Byl použitý Median_filtr – pomocná promìnná pro to zda byl použitý filtr, èi ne 
        handles.pom_vyber_filtr = 1; 
                
     case 3 %Lee filtr.....................................................
         
        %Zviditelnìní vstupního okna do filtru, hodnota je defuatlnì
        %nastavená na 5; v GUI se dá ovšem i pøepsat         
        set(handles.filtr_okno_text,'visible','on') 
        set(handles.filtr_okno,'visible','on') 
        set(handles.filtr_button,'visible','on');     
        
        if handles.pom == 1 %Pokud byly naèteny vstupní data, provede se Lee filtrace
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla naètená reálna data, provede se ošetøení 
                                                             %pro bezchybné zobrazení
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data,[])        
        else %Pokud nebyla naètená žádná vstupní data, vyhodí se chybová hláška
            errordlg('CHYBA - zkontroluj zda máš vybrané vstupní data','Chyba!')    
        end
        
        %Zobrazení popisku dole, pro ovìøení, že cyklus dojel        
        set(handles.text_median,'visible','off')
        set(handles.text_Frost,'visible','off')
        set(handles.text_Lee,'visible','on')

        %Byl použitý Lee filtr – pomocná promìnná pro to zda byl použitý filtr, èi ne       
        handles.pom_vyber_filtr = 2; 
        
     case 4 %Frost filtr...................................................

       %Zviditelnìní vstupního okna do filtru, hodnota je defuatlnì
       %nastavená na 5; v GUI se dá ovšem i pøepsat  
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')  
       set(handles.filtr_button,'visible','on');
       
       if handles.pom == 1 %Pokud byly naèteny vstupní data, provede se Frost filtrace
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data)
       elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla naètená reálna data, provede se ošetøení 
                                                            %pro bezchybné zobrazení 
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data,[])        
       else  %Pokud nebyla naètená žádná vstupní data, vyhodí se chybová hláška
          errordlg('CHYBA - zkontroluj zda máš vybrané vstupní data','Chyba!')    
       end  

       %Zobrazení popisku dole, pro ovìøení, že cyklus dojel  
       set(handles.text_median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','on')    

       %Byl použitý Frost filtr – pomocná promìnná pro to zda byl použitý filtr, èi ne 
       handles.pom_vyber_filtr = 3; 
        
otherwise %Pokud se vybere cokoli jiného, v tomto pøípadì spíše nevybere
       
       %Nezobrazí se žádné texty ani "edit"
       set(handles.filtr_okno_text,'visible','off') 
       set(handles.filtr_okno,'visible','off')
       set(handles.text_Median,'visible','off')
       set(handles.text_Lee,'visible','off')
       set(handles.text_Frost,'visible','off') 
       set(handles.filtr_button,'visible','off');
       
       %Filtr nebyl použitý – pomocná promìnná pro to zda byl použitý filtr, èi ne     
       handles.pom_vyber_filtr = 0;    
       
end
         
guidata(hObject, handles)

% Pokud se klikne na tlaèítko Restartovat,provede se:   (vše se restartuje)
function reset_Callback(hObject, eventdata, handles)
OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
GUI               %Otevøení nového GUI 
