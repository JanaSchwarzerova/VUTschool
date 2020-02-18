function varargout = GUI_sekvence(varargin)
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
% Poslední úpravy: v GUIDE 17-04-2018 10:57:39

%Zaèátek inicializaèního kódu – NEUPRAVOVAT: 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_sekvence_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_sekvence_OutputFcn, ...
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
function GUI_sekvence_OpeningFcn(hObject, eventdata, handles, varargin)
% Tato funkce nemá výstupní argumenty, viz OutputFcn.
% hObject    "handle" k zobrazení
% eventdata  reserved - které budou definovány v budoucí verzi MATLABu
% handles    struktura s "handles" a uživatelská data (viz GUIDATA)
% varargin   argumenty pøíkazových øádkù k GUI (viz VARARGIN)

% Zvolení výchozího výstupu pøíkazového øádku pro GUI
handles.output = hObject;

handles.pom_vyber_metody = 0;             %Pomocná pro výbìr segmentaèní metody
handles.pom_vyber_filtr = 0;              %Pomocná pro výbìr filtrace
handles.pom_vyber_dat = 0;                %Pomocná pro výbìr vstupních dat
handles.pom = 0;                          %Pomocná pro ošetøení, aby vždy byly vloženy vstupní data
handles.Vstupni_data =[];                 %Pøeddefinovaná promìnná pro vstupní data
handles.vyber_filtr = 0;                  %Pøeddefinovaná promìnná pro výbìr filtru
handles.Filtr_data = [];                  %Pøeddefinovaná promìnná pro Filtrovací data, k následnému uložení
handles.Vstup_pom = {};                   %Pøeddefinovaná promìnná pro Vstupní data, k následnému uložení do struktury
handles.Filtr_pom = {};                   %Pøeddefinovaná promìnná pro Filtrovací data, k následnému uložení do struktury
handles.Vystup_data_narust_oblast = {};   %Pøeddefinovaná promìnná pro Výstupní data z narùstaní oblastí, k následnému uložení do struktury
handles.Vystup_data_aktiv_kontur={};      %Pøeddefinovaná promìnná pro Výstupní data z aktivních kontur, k následnému uložení do struktury
handles.pocitadlo = 0;                    %Pomocné poèítadlo, kolikrát probìhne for cyklus
handles.pom_zacatek = 0;                  %Pomocná promìnná k for cyklu pro reálná data, od kterých dat bude for cyklus zaèínan
handles.pom_konec = 0;                    %Pomocná promìnná k for cyklu pro reálná data, do kterých dat bude for cyklus konèit
handles.pom_real_data = 0;                %Pomocná pro správné urèení, reálných dat v segementaci

%Aktualizace; popisující strukturu:
guidata(hObject, handles);

% UIWAIT dìlá GUI èekat na odpovìï uživatele (viz UIRESUME)
% uiwait(handles.figure1);

% --- Výstupy z této funkce se vrátí do pøíkazového øádku.
function varargout = GUI_sekvence_OutputFcn(hObject, eventdata, handles) 
% varargout  bunìèné pole pro návrat výstupních argumentù (viz VARARGOUT);
% hObject    "handle" k zobrazení
% eventdata  reserved - které budou definovány v budoucí verzi MATLABu
% handles    struktura s "handles" a uživatelská data (viz GUIDATA)

% Získání výchozího výstupu pøíkazového øádku ze struktury úchytù
varargout{1} = handles.output;

%**************************************************************************
%____________________________Vybrání dat___________________________________
% Provede se pøi zmìnì výbìru v vybrat_data.
function popupmenu_vstup_data_Callback(hObject, eventdata, handles)

vyber_dat = get(hObject,'Value'); %Vybere se konkrétní typ dat pomocí "Pop-up Menu"

switch vyber_dat 
     case 1 %Bez dat.......................................................
       
      %Pokud uživatel dá bez dat, vyjede mu varování, že nejsou vybrána žádná data
      warndlg('Nejsou vybrána vstupní data','Varování')
       
      %Pomocná pro výber vstupních dat – nejsou vybrána žádná data (pro pozdìjší ošetøení)
      handles.pom_vyber_dat = 0;
              
     case 2  %Fantomové data................................................ 
         
      %Pomocná pro výber vstupních dat – je vybrán Fantomový obraz (pro pozdìjší ošetøení)    
      handles.pom_vyber_dat = 1;         
      handles.Vstupni_data = imread('sedy_0.bmp');  %Naètení fantomových dat
      axes(handles.Vstupni_obraz)
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
            
     case 3 %Reálné data 1.................................................
       
     %Pomocná pro výber vstupních dat – je vybrán Reálný obraz (pro pozdìjší ošetøení)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 1; 
     %Naètení reálného obrazu
     load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
     handles.Vstupni_data = data1{100};
     axes(handles.Vstupni_obraz)
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

     case 4 %Reálné data 2.................................................
       
     %Pomocná pro výber vstupních dat – je vybrán Reálný obraz (pro pozdìjší ošetøení)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 2; 
     %Naètení reálného obrazu
     load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
     handles.Vstupni_data = data2{100};
     axes(handles.Vstupni_obraz)
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
 
     case 5 %Reálné data 3.................................................
       
     %Pomocná pro výber vstupních dat – je vybrán Reálný obraz (pro pozdìjší ošetøení)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 3;
     
     %Naètení reálného obrazu
     load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') 
     handles.Vstupni_data = data1{100};
     axes(handles.Vstupni_obraz)
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
     
     case 6 %Reálné data 4.................................................
       
     %Pomocná pro výber vstupních dat – je vybrán Reálný obraz (pro pozdìjší ošetøení)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 4;
     
     %Naètení reálného obrazu
     load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') 
     handles.Vstupni_data = data2{100};
     axes(handles.Vstupni_obraz)
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
     
     case 7 %Reálné data 5.................................................
       
     %Pomocná pro výber vstupních dat – je vybrán Reálný obraz (pro pozdìjší ošetøení)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 5;
     
     %Naètení reálného obrazu
     load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat')
     handles.Vstupni_data = data1{100};
     axes(handles.Vstupni_obraz)
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

     case 8 %Reálné data 6.................................................
       
     %Pomocná pro výber vstupních dat – je vybrán Reálný obraz (pro pozdìjší ošetøení)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 6;
     
     %Naètení reálného obrazu
     load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat')
     handles.Vstupni_data = data2{100};
     axes(handles.Vstupni_obraz)
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
     
     case 9 %Co si bude chtít nahrát uživatel.................................
      
    %Pomocná pro výber vstupních dat – je vybrán libovolný obraz (pro pozdìjší ošetøení)   
    handles.pom_vyber_dat = 2;   
    
    %Výbìr libovolného obrázku uživatelem s doporuèenými konocovkami souboru
    [handles.nazev_souboru, cesta] = uigetfile({'*.mat'},'Vyber soubor');
    if isequal (handles.nazev_souboru,0)||isequal(cesta,0)
       warndlg('Nejsou vybrána vstupní data','Varování')
    else
       handles.nazev_souboru = strcat(cesta,handles.nazev_souboru);
       axes(handles.Vstupni_obraz)
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{1};
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
     end
     otherwise %Pokud se vybere cokoli jiného, v tomto pøípadì spíše nevybere
           %tak program nic neudìlá
end
 
if handles.pom_vyber_metody == 2
    if  handles.pom_vyber_dat == 1  
        
        set(handles.text_posled_snimek,'visible','off')
        set(handles.text_pocatec_snimek,'visible','off')
        set(handles.edit_zacatek,'visible','off')
        set(handles.edit_konec,'visible','off')
        
        rozmery = size(handles.Vstupni_data);
        handles.x=round(rozmery(1)/2); 
        handles.y=round(rozmery(2)/2);
        set(handles.sourad_x,'Value',handles.x);
        set(handles.sourad_y,'Value',handles.y);
        set(handles.sourad_x,'String',num2str(handles.x));
        set(handles.sourad_y,'String',num2str(handles.y));   
    else 
        set(handles.text_posled_snimek,'visible','on')
        set(handles.text_pocatec_snimek,'visible','on')
        set(handles.edit_zacatek,'visible','on')
        set(handles.edit_konec,'visible','on')
        set(handles.edit_zacatek,'Value',105)
        set(handles.edit_zacatek,'String','105')
        set(handles.edit_konec,'Value',120)
        set(handles.edit_konec,'String','120')
   
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
function popupmenu_vstup_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
%_______________________________Filtrace___________________________________

% Provede pøi zmìnì výbìru v souboru:  vybrat_filtr
function popmenu_filtrace_Callback(hObject, eventdata, handles)

 handles.vyber_filtr = get(hObject,'Value'); %Vybere se konkrétní typ filtrace pomocí "Pop-up Menu"

%Hodnota filtrovacího okna (tato hodnota se nastavuje stejnì pro všechny filtry)
%defuatnì nastavená na hodnotì 5 v GUI se dá ovšem i pøepsat 
x = get(handles.filtr_okno,'string'); 
handles.x_filtr = str2num(x);

switch  handles.vyber_filtr
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
       handles.Filtr_data = imread('GUI_bez_filtrace.png'); 
       
       %Filtr nebyl použitý – pomocná promìnná pro to zda byl použitý filtr, èi ne        
       handles.pom_vyber_filtr = 0; 
        
     case 2 %Mediánový filtr...............................................
       
       %Zviditelnìní vstupního okna do filtru, hodnota je defuatlnì
       %nastavená na 5; v GUI se dá ovšem i pøepsat
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')
       set(handles.filtr_button,'visible','on');         
       
        if handles.pom == 1 %Pokud byly naèteny vstupní data, provede se mediánová filtrace
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[handles.x_filtr handles.x_filtr]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1 %Pokud byla naètená reálna data, provede se ošetøení 
                                                              %pro bezchybné zobrazení
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[handles.x_filtr handles.x_filtr]);
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
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, handles.x_filtr);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla naètená reálna data, provede se ošetøení 
                                                             %pro bezchybné zobrazení
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, handles.x_filtr);
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
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',handles.x_filtr,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data)
       elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla naètená reálna data, provede se ošetøení 
                                                            %pro bezchybné zobrazení 
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',handles.x_filtr,0)));
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
       handles.Filtr_data = imread('GUI_bez_filtrace.png');       
end
         
guidata(hObject, handles)

% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function popmenu_filtrace_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%**************************************************************************
%______________________Vybrání segmentaèní metody__________________________
% Provede se pøi zmìnì výbìru popmenut_seg_metoda.
function popmenu_seg_metoda_Callback(hObject, eventdata, handles)

vyber_metody = get(hObject,'Value'); %Vybere se konkrétní typ segmentaèní metody pomocí "Pop-up Menu"

switch vyber_metody 
    
  case 1 %Bez segmentaèní metody...........................................
      
    %Pomocná pro výber segmetaèní metody – není vybrána segmentaèní metoda (pro pozdìjší ošetøení)  
    handles.pom_vyber_metody = 1;  
                
    %Zneviditelnìní ostatních vìcí (texty k daným hodnotám atd.)
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
    %Zneviditelní potøebných parametrù na aktivní kontury
    set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
    set(handles.text_max_it,'visible','off')
    set(handles.max_iterace,'visible','off')
    set(handles.text_posled_snimek,'visible','off')
    set(handles.text_pocatec_snimek,'visible','off')
    set(handles.edit_zacatek,'visible','off')
    set(handles.edit_konec,'visible','off')
   
  case 2  %Výbìr metody NARÙSTÁNÍ OBLASTÍ...................................

  %Zneviditelnìní ostatních vìcí (texty k daným hodnotám atd.)     
  %Zneviditelní potøebných parametrù na aktivní kontury
  set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
  set(handles.text_max_it,'visible','off')
  set(handles.max_iterace,'visible','off')   
 
   if  handles.pom_vyber_dat ~= 2; 
   set(handles.text_posled_snimek,'visible','off')
   set(handles.text_pocatec_snimek,'visible','off')
   set(handles.edit_zacatek,'visible','off')
   set(handles.edit_konec,'visible','off')
   end
  
  %Pomocná pro výber segmetaèní metody – segmentaèní metoda narùstání oblastí (pro pozdìjší ošetøení)    
  handles.pom_vyber_metody = 2; 
              
  %Zviditelnìní nastavitelných vstupních parametrù
  set(handles.nastav_hodnot_narust_oblast,'visible','on') 
  set(handles.text_max_interval,'visible','on')
  set(handles.max_interval,'visible','on')
  
  
   if  handles.pom_vyber_dat == 2; 
   set(handles.text_posled_snimek,'visible','on')
   set(handles.text_pocatec_snimek,'visible','on')
   set(handles.edit_zacatek,'visible','on')
   set(handles.edit_konec,'visible','on')
   set(handles.edit_zacatek,'Value',105)
   set(handles.edit_zacatek,'String','105')
   set(handles.edit_konec,'Value',120)
   set(handles.edit_konec,'String','120')
   end
  
  %Pøi výbìru Lee a Frost filtru se defualtnì nastaví hodnota maximálního intervalu 
  %intenzity na 0.1 v jiných pøípadech 0.2
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
              
    %Použití filtrace po zmìnìní segmentaèní metody, aby se zobrazila v GUI
    if handles.pom_vyber_filtr == 1 %Medianová filtrace
      handles.Filtr_data = medfilt2(handles.Vstupni_data,[handles.x_filtr, handles.x_filtr]);
      axes(handles.Filtr_obr)
      imshow(handles.Filtr_data)    
    elseif handles.pom_vyber_filtr == 2 %Lee
      handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, handles.x_filtr);
      axes(handles.Filtr_obr)
      imshow(handles.Filtr_data)                
    elseif handles.pom_vyber_filtr == 3 %Frost
      handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',handles.x_filtr,0)));
      axes(handles.Filtr_obr)
      imshow(handles.Filtr_data)                
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
                errordlg('Pro tento výbìr musíš mít filtrovaný obraz','Chyba')   
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
                               
 case 3 %Výbìr metody AKTIVNÍ KONTURY......................................

  %Zneviditelnìní ostatních vìcí (texty k daným hodnotám atd.)     
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
 
   if  handles.pom_vyber_dat ~= 2; 
   set(handles.text_posled_snimek,'visible','off')
   set(handles.text_pocatec_snimek,'visible','off')
   set(handles.edit_zacatek,'visible','off')
   set(handles.edit_konec,'visible','off')
   end
  
  
  %Pomocná pro výber segmetaèní metody – segmentaèní metoda aktivní kontury (pro pozdìjší ošetøení) 
  handles.pom_vyber_metody = 3;
                
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
   
   %Zviditelní potøebných parametrù na aktivní kontury
   set(handles.nastaveni_hodnot_aktiv_kontur,'visible','on') 
   set(handles.text_max_it,'visible','on')
   set(handles.max_iterace,'visible','on')
   set(handles.max_iterace,'Value',400)   
   set(handles.max_iterace,'String','400')    
 
   if  handles.pom_vyber_dat == 2; 
   set(handles.text_posled_snimek,'visible','on')
   set(handles.text_pocatec_snimek,'visible','on')
   set(handles.edit_zacatek,'visible','on')
   set(handles.edit_konec,'visible','on')
   set(handles.edit_zacatek,'Value',105)
   set(handles.edit_zacatek,'String','105')
   set(handles.edit_konec,'Value',120)
   set(handles.edit_konec,'String','120')    
   end
  
   
   %Nastavení parametrù pro pozdìjší použití v segmentaci metodou aktivních kontur
   if handles.pom == 1                      %Pokud jsou vybrána data proveï
          otazka = questdlg('Budeš chtít najít manuálnì hodnotu ve Vstupních datech nebo ve Filtrovaném obrazu?','Výbìr',...
                            'Vstupní data','Filtrovaný obraz','Filtrovaný obraz');
         switch otazka
           case 'Vstupní data' %Pokud vybereš, že chceš urèit vstupní hodnoty ze vstupního obrazu
            axes(handles.Vstupni_obraz)   
            handles.pocatecni_maska=roipoly(handles.Vstupni_data); %urèení vstupní masky do metody segmentace aktivních kontur pomocí funkce roipoly
           case 'Filtrovaný obraz' %Pokud vybereš, že chceš urèit vstupní hodnoty z filtrovaného obrazu
            if handles.pom_vyber_filtr == 0; %musí být pøedem provedena filtrace, jinak se vypíše chybová hláška
               errordlg('Pro tento výbìr musíš mít filtrovaný obraz','Chyba')   
            else
               axes(handles.Filtr_obr)
               handles.pocatecni_maska=roipoly(handles.Filtr_data); %urèení vstupní masky do metody segmentace aktivních kontur pomocí funkce roipoly
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
function popmenu_seg_metoda_CreateFcn(hObject, eventdata, ~)
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
      
   elseif handles.pom_vyber_metody == 2; %NARÙSTÁNÍ OBLASTÍ...............
     
    if handles.pom_vyber_dat == 1; %FANTOMOVÉ DATA
     for i = 0:4 
       if handles.pocitadlo == 0   
          axes(handles.Vstupni_obraz)
          imshow(handles.Vstupni_data,[])
       else
          s  = regionprops(handles.Vystup,'centroid');
          handles.y = round(s(1).Centroid(1));
          handles.x = round(s(1).Centroid(2));

       %Zobrazení aktuálního snímku 
       handles.Vstupni_data = imread(['sedy_',num2str(i),'.bmp']);  %fantom   
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data,[])
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       
       %Pokud je obraz pøefiltrován, zobrazení aktuální filtrace
       if handles.pom_vyber_filtr ~= 0
            if handles.pom_vyber_filtr == 1 %Medianová filtrace
                  handles.Filtr_data = medfilt2(handles.Vstupni_data,[handles.x_filtr handles.x_filtr]);
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)    
           elseif handles.pom_vyber_filtr == 2 %Lee
                  handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, handles.x_filtr);
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)                
           elseif handles.pom_vyber_filtr == 3 %Frost
                  handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',handles.x_filtr,0)));
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)                
           end 
       else
           %Naètení obrázku bez filtrace        
           bez_filtr = imread('GUI_bez_filtrace.png');  
           axes(handles.Filtr_obr)
           imshow(bez_filtr)  
       end
      end 
       
      %Vypsaní hodnoty maximálního intrevalu intenzity 
      reg_max = get(handles.max_interval,'String');
      reg_max = str2num(reg_max);
      
      %Zavolání funkce, která provede segmentovací metodu narùstání oblastí        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl použitý
         [handles.Vystup] = Narust_oblast(handles.Vstupni_data, handles.x, handles.y, reg_max);
         
         %Použití morfologických operací
         Vystup_1 = im2double(handles.Vystup);
         r  = regionprops(Vystup_1,'MinorAxisLength');
         r = round(r.MinorAxisLength(1)/15);  
         SE = strel('diamond',r);
         Vystup_1 = imclose(handles.Vystup,SE);
         Vystup_1 = imopen(Vystup_1,SE);
         
         handles.Vystup = Vystup_1;
         
         axes(handles.Segment_Obraz)        
         imshow(handles.Vstupni_data,[])
         hold on;
         contour(Vystup_1, 'g','LineWidth',4);
         contour(Vystup_1, 'k','LineWidth',2);
         hold off;
      else %Filtr byl použitý
         [handles.Vystup] = Narust_oblast(handles.Filtr_data, handles.x, handles.y, reg_max);
     
         %Použití morfologických operací
         Vystup_1 = im2double(handles.Vystup);
         r  = regionprops(Vystup_1,'MinorAxisLength');
         r = round(r.MinorAxisLength(1)/15);  
         SE = strel('diamond',r);
         Vystup_1 = imclose(handles.Vystup,SE);
         Vystup_1 = imopen(Vystup_1,SE);
         handles.Vystup = Vystup_1;
         
         axes(handles.Segment_Obraz)        
         imshow(handles.Vstupni_data,[])
         hold on;
         contour(Vystup_1, 'g','LineWidth',4);
         contour(Vystup_1, 'k','LineWidth',2);
         hold off;
      end
        
      %Uložení výstupu do matice, z které se po vykonání segmentace bude
      %dát výstup znovu zobrazovat: 
       handles.Vystup_data_narust_oblast = [handles.Vystup_data_narust_oblast,handles.Vystup];
       handles.Vstup_pom = [handles.Vstup_pom,handles.Vstupni_data];
       handles.Filtr_pom = [handles.Filtr_pom,handles.Filtr_data];
       
       handles.pocitadlo = handles.pocitadlo + 1; %Poèítadlo se inkrementuje 
       pause(.01); 
     end
     
    elseif handles.pom_vyber_dat == 2 %REÁLNÉ DATA
        
         handles.pom_zacatek = get(handles.edit_zacatek,'String');
         handles.pom_zacatek = str2num(handles.pom_zacatek);
         handles.pom_konec = get(handles.edit_konec,'String');
         handles.pom_konec = str2num(handles.pom_konec);

         if handles.pom_zacatek>handles.pom_konec
             handles.pom_krok = -1;
         else
             handles.pom_krok = 1;
         end

       if handles.pom_real_data == 1 
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
         if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
         else
         handles.Vstupni_data = data1{handles.pom_zacatek};
        [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
         end
       elseif  handles.pom_real_data == 2
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
         if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
         else
          handles.Vstupni_data = data2{handles.pom_zacatek};   
         [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
        end
       elseif  handles.pom_real_data == 3  
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazení aktuálního snímku
        if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
        else
        handles.Vstupni_data = data1{handles.pom_zacatek};   
        [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
        end
       elseif  handles.pom_real_data == 4 
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazení aktuálního snímku
        if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data2)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data2{handles.pom_zacatek}; 
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       end
       elseif  handles.pom_real_data == 5
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data1{handles.pom_zacatek}; 
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       end
       elseif  handles.pom_real_data == 6
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data2)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data2{handles.pom_zacatek};           
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       end
       elseif  handles.pom_real_data == 0 %Data vybrání od uživatele
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{handles.pom_zacatek};
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       end
       
     for i = handles.pom_zacatek :handles.pom_krok: handles.pom_konec
       if handles.pocitadlo == 0   
          axes(handles.Vstupni_obraz)
          imshow(handles.Vstupni_data,[])
       else
          s  = regionprops(handles.Vystup,'centroid');
          handles.y = round(s(1).Centroid(1));
          handles.x = round(s(1).Centroid(2));
       
       %Zobrazení aktuálního snímku 
       if handles.pom_real_data == 1 
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data1{i};
       elseif  handles.pom_real_data == 2
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data2{i};          
       elseif  handles.pom_real_data == 3  
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data1{i};           
       elseif  handles.pom_real_data == 4 
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data2{i};           
       elseif  handles.pom_real_data == 5
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data1{i};           
       elseif  handles.pom_real_data == 6
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data2{i};           
       elseif  handles.pom_real_data == 0 %Data vybrání od uživatele
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{i};
       end
       
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data,[])
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       
       %Pokud je obraz pøefiltrován, zobrazení aktuální filtrace
       if handles.pom_vyber_filtr ~= 0
            if handles.pom_vyber_filtr == 1 %Medianová filtrace
                  handles.Filtr_data = medfilt2(handles.Vstupni_data,[handles.x_filtr handles.x_filtr]);
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)    
           elseif handles.pom_vyber_filtr == 2 %Lee
                  handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, handles.x_filtr);
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)                
           elseif handles.pom_vyber_filtr == 3 %Frost
                  handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',handles.x_filtr,0)));
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)                
           end 
       else
           %Naètení obrázku bez filtrace        
           bez_filtr = imread('GUI_bez_filtrace.png');  
           axes(handles.Filtr_obr)
           imshow(bez_filtr)  
       end
      end 
      
      %Vypsaní hodnoty maximálního intrevalu intenzity 
      reg_max = get(handles.max_interval,'String');
      reg_max = str2num(reg_max);
      
      %Zavolání funkce, která provede segmentovací metodu narùstání oblastí        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl použitý
         [handles.Vystup] = Narust_oblast(handles.Vstupni_data, handles.x, handles.y, reg_max);
         %Použití morfologických operací
         Vystup_1 = im2double(handles.Vystup);
         r  = regionprops(Vystup_1,'MinorAxisLength');
         r = round(r.MinorAxisLength(1)/15);  
         SE = strel('diamond',r);
         Vystup_1 = imclose(handles.Vystup,SE);
         Vystup_1 = imopen(Vystup_1,SE);
         handles.Vystup = Vystup_1;
         
         axes(handles.Segment_Obraz)        
         imshow(handles.Vstupni_data,[])
         hold on;
         contour(Vystup_1, 'g','LineWidth',4);
         contour(Vystup_1, 'k','LineWidth',2);
         hold off;
      else %Filtr byl použitý
         [handles.Vystup] = Narust_oblast(handles.Filtr_data, handles.x, handles.y, reg_max);
         
         %Použití morfologických operací
         Vystup_1 = im2double(handles.Vystup);
         r  = regionprops(Vystup_1,'MinorAxisLength');
         r = round(r.MinorAxisLength(1)/15);  
         SE = strel('diamond',r);
         Vystup_1 = imclose(handles.Vystup,SE);
         Vystup_1 = imopen(Vystup_1,SE);
         handles.Vystup = Vystup_1;
         
         axes(handles.Segment_Obraz)        
         imshow(handles.Vstupni_data,[])
         hold on;
         contour(Vystup_1, 'g','LineWidth',4);
         contour(Vystup_1, 'k','LineWidth',2);
         hold off;
      end
        
      %Uložení výstupu do matice, z které se po vykonání segmentace bude
      %dát výstup znovu zobrazovat: 
       handles.Vystup_data_narust_oblast = [handles.Vystup_data_narust_oblast,handles.Vystup];
       handles.Vstup_pom = [handles.Vstup_pom,handles.Vstupni_data];
       handles.Filtr_pom = [handles.Filtr_pom,handles.Filtr_data];      
       
       handles.pocitadlo = handles.pocitadlo + 1; %Poèítadlo se inkrementuje 
       pause(.01); 
     end        
        
    else 
     errordlg('CHYBA - zkontroluj zda máš vybrané vstupní data','Chyba!')
    end
    
   elseif handles.pom_vyber_metody == 3;  %AKTIVNÍ KONTURY.................

      max_it = get(handles.max_iterace,'String'); 
      max_it= str2num(max_it);
        
    if handles.pom_vyber_dat == 1; %FANTOMOVÉ DATA
     for i = 0:4 
       if handles.pocitadlo == 0   
          axes(handles.Vstupni_obraz)
          imshow(handles.Vstupni_data,[])
       else
         handles.pocatecni_maska = handles.Vystup;

       %Zobrazení aktuálního snímku 
       handles.Vstupni_data = imread(['sedy_',num2str(i),'.bmp']);  %fantom   
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data,[])
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       
       %Pokud je obraz pøefiltrován, zobrazení aktuální filtrace
       if handles.pom_vyber_filtr ~= 0
            if handles.pom_vyber_filtr == 1 %Medianová filtrace
                  handles.Filtr_data = medfilt2(handles.Vstupni_data,[handles.x_filtr handles.x_filtr]);
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)    
           elseif handles.pom_vyber_filtr == 2 %Lee
                  handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, handles.x_filtr);
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)                
           elseif handles.pom_vyber_filtr == 3 %Frost
                  handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',handles.x_filtr,0)));
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)                
           end 
       else
           %Naètení obrázku bez filtrace        
           bez_filtr = imread('GUI_bez_filtrace.png');  
           axes(handles.Filtr_obr)
           imshow(bez_filtr)  
       end
       
      end 
      
      %Zavolání funkce, která provede segmentovací metodu narùstání oblastí        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl použitý
         [handles.Vystup] = Aktiv_kontur(handles.Vstupni_data, handles.pocatecni_maska, max_it);
         
         %Použití morfologických operací
         Vystup = im2double(handles.Vystup);
         r  = regionprops(Vystup,'MinorAxisLength');
         pom_max = max([r.MinorAxisLength]);
         r = round(pom_max/50);  
         SE = strel('diamond',r);
         handles.Vystup = imopen(Vystup,SE);

         axes(handles.Segment_Obraz)        
         imshow(handles.Vstupni_data,[])
         hold on;
         contour(handles.Vystup,[0 0], 'g','LineWidth',4);
         contour(handles.Vystup,[0 0], 'k','LineWidth',2);
         hold off;
         
      else %Filtr byl použitý
         [handles.Vystup] = Aktiv_kontur(handles.Filtr_data, handles.pocatecni_maska, max_it);
         
         %Použití morfologických operací
         Vystup = im2double(handles.Vystup);
         r  = regionprops(Vystup,'MinorAxisLength');
         pom_max = max([r.MinorAxisLength]);
         r = round(pom_max/50);  
         SE = strel('diamond',r);
         handles.Vystup = imopen(Vystup,SE);

         axes(handles.Segment_Obraz)        
         imshow(handles.Vstupni_data,[])
         hold on;
         contour(handles.Vystup,[0 0], 'g','LineWidth',4);
         contour(handles.Vystup,[0 0], 'k','LineWidth',2);
         hold off;
      end
        
      %Uložení výstupu do matice, z které se po vykonání segmentace bude
      %dát výstup znovu zobrazovat: 
      handles.Vystup_data_aktiv_kontur = [handles.Vystup_data_aktiv_kontur,handles.Vystup];
       handles.Vstup_pom = [handles.Vstup_pom,handles.Vstupni_data];
       handles.Filtr_pom = [handles.Filtr_pom,handles.Filtr_data];
       
       handles.pocitadlo = handles.pocitadlo + 1; %Poèítadlo se inkrementuje 
       pause(.01); 
       
     end
    elseif handles.pom_vyber_dat == 2 %REÁLNÉ DATA
  
      max_it = get(handles.max_iterace,'String'); 
      max_it= str2num(max_it);
      
      handles.pom_zacatek = get(handles.edit_zacatek,'String');
      handles.pom_zacatek = str2num(handles.pom_zacatek);
      handles.pom_konec = get(handles.edit_konec,'String');
      handles.pom_konec = str2num(handles.pom_konec);     
  
      if handles.pom_zacatek > handles.pom_konec
          handles.pom_krok = -1;
      else 
          handles.pom_krok = 1;
      end
      
      if handles.pom_real_data == 1 
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
         if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
         else
         handles.Vstupni_data = data1{handles.pom_zacatek};
        [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
         end
       elseif  handles.pom_real_data == 2
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
         if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
         else
          handles.Vstupni_data = data2{handles.pom_zacatek};   
         [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
        end
       elseif  handles.pom_real_data == 3  
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazení aktuálního snímku
        if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
        else
        handles.Vstupni_data = data1{handles.pom_zacatek};   
        [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
        end
       elseif  handles.pom_real_data == 4 
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazení aktuálního snímku
        if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data2)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data2{handles.pom_zacatek}; 
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       end
       elseif  handles.pom_real_data == 5
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data1{handles.pom_zacatek}; 
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       end
       elseif  handles.pom_real_data == 6
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data2)
          errordlg('CHYBA sekvence je pouze do èísla 257, použil si vìtší rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data2{handles.pom_zacatek};           
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       end
       elseif  handles.pom_real_data == 0 %Data vybrání od uživatele
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{handles.pom_zacatek};
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       end
       
     for i = handles.pom_zacatek : handles.pom_krok :handles.pom_konec
       if handles.pocitadlo == 0   
          axes(handles.Vstupni_obraz)
          imshow(handles.Vstupni_data,[])
       else
         handles.pocatecni_maska = handles.Vystup;
       
       %Zobrazení aktuálního snímku 
 
       if handles.pom_real_data == 1 
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data1{i};
       elseif  handles.pom_real_data == 2
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data2{i};          
       elseif  handles.pom_real_data == 3  
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data1{i};           
       elseif  handles.pom_real_data == 4 
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data2{i};           
       elseif  handles.pom_real_data == 5
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data1{i};           
       elseif  handles.pom_real_data == 6
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazení aktuálního snímku
       handles.Vstupni_data = data2{i};           
       elseif  handles.pom_real_data == 0 %Data vybrání od uživatele
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{i};
       end
       
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data,[])
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %Ošetøení správného formátování
       
       %Pokud je obraz pøefiltrován, zobrazení aktuální filtrace
       if handles.pom_vyber_filtr ~= 0
            if handles.pom_vyber_filtr == 1 %Medianová filtrace
                  handles.Filtr_data = medfilt2(handles.Vstupni_data,[handles.x_filtr handles.x_filtr]);
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)    
           elseif handles.pom_vyber_filtr == 2 %Lee
                  handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, handles.x_filtr);
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)                
           elseif handles.pom_vyber_filtr == 3 %Frost
                  handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',handles.x_filtr,0)));
                  axes(handles.Filtr_obr)
                  imshow(handles.Filtr_data)                
           end 
       else
           %Naètení obrázku bez filtrace        
           bez_filtr = imread('GUI_bez_filtrace.png');  
           axes(handles.Filtr_obr)
           imshow(bez_filtr)  
       end
      end 
       
           %Zavolání funkce, která provede segmentovací metodu narùstání oblastí        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl použitý
         [handles.Vystup] = Aktiv_kontur(handles.Vstupni_data, handles.pocatecni_maska, max_it);
         
         %Použití morfologických operací
         Vystup = im2double(handles.Vystup);
         r  = regionprops(Vystup,'MinorAxisLength');
         pom_max = max([r.MinorAxisLength]);
         r = round(pom_max/50);  
         SE = strel('diamond',r);
         handles.Vystup = imopen(Vystup,SE);

         axes(handles.Segment_Obraz)        
         imshow(handles.Vstupni_data,[])
         hold on;
         contour(handles.Vystup,[0 0], 'g','LineWidth',4);
         contour(handles.Vystup,[0 0], 'k','LineWidth',2);
         hold off;
         
      else %Filtr byl použitý
         [handles.Vystup] = Aktiv_kontur(handles.Filtr_data, handles.pocatecni_maska, max_it);
         
         %Použití morfologických operací
         Vystup = im2double(handles.Vystup);
         r  = regionprops(Vystup,'MinorAxisLength');
         pom_max = max([r.MinorAxisLength]);
         r = round(pom_max/50);  
         SE = strel('diamond',r);
         handles.Vystup = imopen(Vystup,SE);

         axes(handles.Segment_Obraz)        
         imshow(handles.Vstupni_data,[])
         hold on;
         contour(handles.Vystup,[0 0], 'g','LineWidth',4);
         contour(handles.Vystup,[0 0], 'k','LineWidth',2);
         hold off;
      end
        
      %Uložení výstupu do matice, z které se po vykonání segmentace bude
      %dát výstup znovu zobrazovat: 
       handles.Vystup_data_aktiv_kontur = [handles.Vystup_data_aktiv_kontur,handles.Vystup];
       handles.Vstup_pom = [handles.Vstup_pom,handles.Vstupni_data];
       handles.Filtr_pom = [handles.Filtr_pom,handles.Filtr_data];
       
       handles.pocitadlo = handles.pocitadlo + 1; %Poèítadlo se inkrementuje 
       pause(.01); 
     end
        
    else 
     errordlg('CHYBA - zkontroluj zda máš vybrané vstupní data','Chyba!')
    end
   end
   
 set(handles.filtr_button,'visible','off');
 set(handles.reset,'visible','on');
 set(handles.slider,'visible','on');
 set(handles.slider,'Value',(handles.pocitadlo-1)); 
 set(handles.slider,'Max',(handles.pocitadlo-1)); 
 set(handles.slider,'SliderStep', [1/(handles.pocitadlo-1), 1 ]);

 else %Pokud cokoli jiného vyhodí se chybová hláška: 
   errordlg('CHYBA - zkontroluj zda máš vybranou metodu segmentování a vstupní data','Chyba!')
 end
 

 guidata(hObject, handles);


 %%
%*************************************************************************
%_________________________Ostatní pomocné funkce___________________________

function filtr_okno_Callback(hObject, eventdata, handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností..
function filtr_okno_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function max_iterace_Callback(hObject, eventdata, handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function max_iterace_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sourad_x_Callback(hObject, eventdata, handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function sourad_x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sourad_y_Callback(hObject, eventdata, handles)
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function sourad_y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function max_interval_Callback(hObject, eventdata, handles)

% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function nastav_hodnot_narust_oblast_CreateFcn(hObject, eventdata, handles)

% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function max_interval_CreateFcn(hObject, eventdata, handles)
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
            errordlg('Pro tento výbìr musíš mít filtrovaný obraz','Chyba')   
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


function edit_zacatek_Callback(hObject, eventdata, handles)
handles.pom_zacatek = get(hObject,'value');
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function edit_zacatek_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_konec_Callback(hObject, eventdata, handles)
handles.pom_konec = get(hObject,'value');
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function edit_konec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function text_pocatec_snimek_CreateFcn(hObject, eventdata, handles)

% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function text_posled_snimek_CreateFcn(hObject, eventdata, handles)


% Provede se, když se stiskne tlaèítko Proveï filtraci: 
function filtr_button_Callback(hObject, eventdata, handles)

x_filter = get(handles.filtr_okno,'string'); 
x_filter = str2num(x_filter);
handles.x_filter = x_filter;

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
       handles.Filtr_data = imread('GUI_bez_filtrace.png'); 
       
       %Filtr nebyl použitý – pomocná promìnná pro to zda byl použitý filtr, èi ne        
       handles.pom_vyber_filtr = 0; 
        
     case 2 %Mediánový filtr...............................................
       
       %Zviditelnìní vstupního okna do filtru, hodnota je defuatlnì
       %nastavená na 5; v GUI se dá ovšem i pøepsat
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')
       set(handles.filtr_button,'visible','on');
                 
        if handles.pom == 1 %Pokud byly naèteny vstupní data, provede se mediánová filtrace
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x_filter x_filter]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1 %Pokud byla naètená reálna data, provede se ošetøení 
                                                              %pro bezchybné zobrazení
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x_filter x_filter]);
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
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x_filter);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla naètená reálna data, provede se ošetøení 
                                                             %pro bezchybné zobrazení
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x_filter);
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
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x_filter,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data)
       elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla naètená reálna data, provede se ošetøení 
                                                            %pro bezchybné zobrazení 
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x_filter,0)));
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

% Provede se když se kline na tlaèítko Restartovat: 
function reset_Callback(hObject, eventdata, handles)

OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH); %Vymazání nynìjších hodot a zavøení souèasného GUI
GUI_sekvence      %Otevøení nového GUI  


% Provede se pøi pohybu slideru: 
function slider_Callback(hObject, eventdata, handles)

if handles.pom_vyber_metody == 2 %Když je vybrána metoda 2 (tedy metoda Narùstání oblastí)
     j = get(hObject,'value');   %Vezme se aktuální hodnota slideru
     pom = ceil(j);              %Ošetøení hodnoty, aby slider postupoval vždy po jednom obrazu v sekvenci
     if j == pom && j ~= 1
         j = j+1;
     else
         j = pom;
     end
     
     %Zobrazení urèité hodnoty slideru jako obraz (filtrovaný, vstupní èi výstupní) v èíselném poøadí v sekvenci
     axes(handles.Vstupni_obraz)  
     imshow(handles.Vstup_pom{j} ,[]) 
     if handles.pom_vyber_filtr ~= 0
     axes(handles.Filtr_obr)
     imshow(handles.Filtr_pom{j})
     end
     axes(handles.Segment_Obraz)        
     imshow(handles.Vstup_pom{j});
     hold on;
     contour(handles.Vystup_data_narust_oblast{j}, 'g','LineWidth',4);
     contour(handles.Vystup_data_narust_oblast{j}, 'k','LineWidth',2);
     hold off;
      
elseif handles.pom_vyber_metody == 3 %Když je vybrána metoda 3 (tedy metoda Aktivních kontur)
     j = get(hObject,'value');       %Vezme se aktuální hodnota slideru
     pom = ceil(j);                  %Ošetøení hodnoty, aby slider postupoval vždy po jednom obrazu v sekvenci 
     if j == pom && j ~= 1
         j = j+1;
     else
         j = pom;
     end
     
     %Zobrazení urèité hodnoty slideru jako obraz (filtrovaný, vstupní èi výstupní) v èíselném poøadí v sekvenci         
     axes(handles.Vstupni_obraz)
     imshow(handles.Vstup_pom{j} ,[]) 
     if handles.pom_vyber_filtr ~= 0
     axes(handles.Filtr_obr)
     imshow(handles.Filtr_pom{j})
     end
     axes(handles.Segment_Obraz)        
     imshow(handles.Vstup_pom{j});
     hold on;
     contour(handles.Vystup_data_aktiv_kontur{j},[0 0], 'g','LineWidth',4);
     contour(handles.Vystup_data_aktiv_kontur{j},[0 0], 'k','LineWidth',2);
     hold off;
       
end
% Provádí se pøi vytváøení objektù po nastavení všech vlastností.
function slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
