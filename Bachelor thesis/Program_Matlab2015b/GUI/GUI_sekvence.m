function varargout = GUI_sekvence(varargin)
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
% Posledn� �pravy: v GUIDE 17-04-2018 10:57:39

%Za��tek inicializa�n�ho k�du � NEUPRAVOVAT: 
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
%Konce inicializa�n�ho k�du.


% Spust� se t�sn� p�edt�m, ne� je grafick� u�ivatelsk� rozhran� viditeln�.
function GUI_sekvence_OpeningFcn(hObject, eventdata, handles, varargin)
% Tato funkce nem� v�stupn� argumenty, viz OutputFcn.
% hObject    "handle" k zobrazen�
% eventdata  reserved - kter� budou definov�ny v budouc� verzi MATLABu
% handles    struktura s "handles" a u�ivatelsk� data (viz GUIDATA)
% varargin   argumenty p��kazov�ch ��dk� k GUI (viz VARARGIN)

% Zvolen� v�choz�ho v�stupu p��kazov�ho ��dku pro GUI
handles.output = hObject;

handles.pom_vyber_metody = 0;             %Pomocn� pro v�b�r segmenta�n� metody
handles.pom_vyber_filtr = 0;              %Pomocn� pro v�b�r filtrace
handles.pom_vyber_dat = 0;                %Pomocn� pro v�b�r vstupn�ch dat
handles.pom = 0;                          %Pomocn� pro o�et�en�, aby v�dy byly vlo�eny vstupn� data
handles.Vstupni_data =[];                 %P�eddefinovan� prom�nn� pro vstupn� data
handles.vyber_filtr = 0;                  %P�eddefinovan� prom�nn� pro v�b�r filtru
handles.Filtr_data = [];                  %P�eddefinovan� prom�nn� pro Filtrovac� data, k n�sledn�mu ulo�en�
handles.Vstup_pom = {};                   %P�eddefinovan� prom�nn� pro Vstupn� data, k n�sledn�mu ulo�en� do struktury
handles.Filtr_pom = {};                   %P�eddefinovan� prom�nn� pro Filtrovac� data, k n�sledn�mu ulo�en� do struktury
handles.Vystup_data_narust_oblast = {};   %P�eddefinovan� prom�nn� pro V�stupn� data z nar�stan� oblast�, k n�sledn�mu ulo�en� do struktury
handles.Vystup_data_aktiv_kontur={};      %P�eddefinovan� prom�nn� pro V�stupn� data z aktivn�ch kontur, k n�sledn�mu ulo�en� do struktury
handles.pocitadlo = 0;                    %Pomocn� po��tadlo, kolikr�t prob�hne for cyklus
handles.pom_zacatek = 0;                  %Pomocn� prom�nn� k for cyklu pro re�ln� data, od kter�ch dat bude for cyklus za��nan
handles.pom_konec = 0;                    %Pomocn� prom�nn� k for cyklu pro re�ln� data, do kter�ch dat bude for cyklus kon�it
handles.pom_real_data = 0;                %Pomocn� pro spr�vn� ur�en�, re�ln�ch dat v segementaci

%Aktualizace; popisuj�c� strukturu:
guidata(hObject, handles);

% UIWAIT d�l� GUI �ekat na odpov�� u�ivatele (viz UIRESUME)
% uiwait(handles.figure1);

% --- V�stupy z t�to funkce se vr�t� do p��kazov�ho ��dku.
function varargout = GUI_sekvence_OutputFcn(hObject, eventdata, handles) 
% varargout  bun��n� pole pro n�vrat v�stupn�ch argument� (viz VARARGOUT);
% hObject    "handle" k zobrazen�
% eventdata  reserved - kter� budou definov�ny v budouc� verzi MATLABu
% handles    struktura s "handles" a u�ivatelsk� data (viz GUIDATA)

% Z�sk�n� v�choz�ho v�stupu p��kazov�ho ��dku ze struktury �chyt�
varargout{1} = handles.output;

%**************************************************************************
%____________________________Vybr�n� dat___________________________________
% Provede se p�i zm�n� v�b�ru v vybrat_data.
function popupmenu_vstup_data_Callback(hObject, eventdata, handles)

vyber_dat = get(hObject,'Value'); %Vybere se konkr�tn� typ dat pomoc� "Pop-up Menu"

switch vyber_dat 
     case 1 %Bez dat.......................................................
       
      %Pokud u�ivatel d� bez dat, vyjede mu varov�n�, �e nejsou vybr�na ��dn� data
      warndlg('Nejsou vybr�na vstupn� data','Varov�n�')
       
      %Pomocn� pro v�ber vstupn�ch dat � nejsou vybr�na ��dn� data (pro pozd�j�� o�et�en�)
      handles.pom_vyber_dat = 0;
              
     case 2  %Fantomov� data................................................ 
         
      %Pomocn� pro v�ber vstupn�ch dat � je vybr�n Fantomov� obraz (pro pozd�j�� o�et�en�)    
      handles.pom_vyber_dat = 1;         
      handles.Vstupni_data = imread('sedy_0.bmp');  %Na�ten� fantomov�ch dat
      axes(handles.Vstupni_obraz)
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
            
     case 3 %Re�ln� data 1.................................................
       
     %Pomocn� pro v�ber vstupn�ch dat � je vybr�n Re�ln� obraz (pro pozd�j�� o�et�en�)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 1; 
     %Na�ten� re�ln�ho obrazu
     load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
     handles.Vstupni_data = data1{100};
     axes(handles.Vstupni_obraz)
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

     case 4 %Re�ln� data 2.................................................
       
     %Pomocn� pro v�ber vstupn�ch dat � je vybr�n Re�ln� obraz (pro pozd�j�� o�et�en�)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 2; 
     %Na�ten� re�ln�ho obrazu
     load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
     handles.Vstupni_data = data2{100};
     axes(handles.Vstupni_obraz)
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
 
     case 5 %Re�ln� data 3.................................................
       
     %Pomocn� pro v�ber vstupn�ch dat � je vybr�n Re�ln� obraz (pro pozd�j�� o�et�en�)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 3;
     
     %Na�ten� re�ln�ho obrazu
     load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') 
     handles.Vstupni_data = data1{100};
     axes(handles.Vstupni_obraz)
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
     
     case 6 %Re�ln� data 4.................................................
       
     %Pomocn� pro v�ber vstupn�ch dat � je vybr�n Re�ln� obraz (pro pozd�j�� o�et�en�)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 4;
     
     %Na�ten� re�ln�ho obrazu
     load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') 
     handles.Vstupni_data = data2{100};
     axes(handles.Vstupni_obraz)
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
     
     case 7 %Re�ln� data 5.................................................
       
     %Pomocn� pro v�ber vstupn�ch dat � je vybr�n Re�ln� obraz (pro pozd�j�� o�et�en�)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 5;
     
     %Na�ten� re�ln�ho obrazu
     load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat')
     handles.Vstupni_data = data1{100};
     axes(handles.Vstupni_obraz)
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

     case 8 %Re�ln� data 6.................................................
       
     %Pomocn� pro v�ber vstupn�ch dat � je vybr�n Re�ln� obraz (pro pozd�j�� o�et�en�)   
     handles.pom_vyber_dat = 2; 
     handles.pom_real_data = 6;
     
     %Na�ten� re�ln�ho obrazu
     load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat')
     handles.Vstupni_data = data2{100};
     axes(handles.Vstupni_obraz)
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
     
     case 9 %Co si bude cht�t nahr�t u�ivatel.................................
      
    %Pomocn� pro v�ber vstupn�ch dat � je vybr�n libovoln� obraz (pro pozd�j�� o�et�en�)   
    handles.pom_vyber_dat = 2;   
    
    %V�b�r libovoln�ho obr�zku u�ivatelem s doporu�en�mi konocovkami souboru
    [handles.nazev_souboru, cesta] = uigetfile({'*.mat'},'Vyber soubor');
    if isequal (handles.nazev_souboru,0)||isequal(cesta,0)
       warndlg('Nejsou vybr�na vstupn� data','Varov�n�')
    else
       handles.nazev_souboru = strcat(cesta,handles.nazev_souboru);
       axes(handles.Vstupni_obraz)
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{1};
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
     end
     otherwise %Pokud se vybere cokoli jin�ho, v tomto p��pad� sp�e nevybere
           %tak program nic neud�l�
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
  
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function popupmenu_vstup_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%**************************************************************************
%_______________________________Filtrace___________________________________

% Provede p�i zm�n� v�b�ru v souboru:  vybrat_filtr
function popmenu_filtrace_Callback(hObject, eventdata, handles)

 handles.vyber_filtr = get(hObject,'Value'); %Vybere se konkr�tn� typ filtrace pomoc� "Pop-up Menu"

%Hodnota filtrovac�ho okna (tato hodnota se nastavuje stejn� pro v�echny filtry)
%defuatn� nastaven� na hodnot� 5 v GUI se d� ov�em i p�epsat 
x = get(handles.filtr_okno,'string'); 
handles.x_filtr = str2num(x);

switch  handles.vyber_filtr
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
       handles.Filtr_data = imread('GUI_bez_filtrace.png'); 
       
       %Filtr nebyl pou�it� � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne        
       handles.pom_vyber_filtr = 0; 
        
     case 2 %Medi�nov� filtr...............................................
       
       %Zviditeln�n� vstupn�ho okna do filtru, hodnota je defuatln�
       %nastaven� na 5; v GUI se d� ov�em i p�epsat
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')
       set(handles.filtr_button,'visible','on');         
       
        if handles.pom == 1 %Pokud byly na�teny vstupn� data, provede se medi�nov� filtrace
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[handles.x_filtr handles.x_filtr]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1 %Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                              %pro bezchybn� zobrazen�
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[handles.x_filtr handles.x_filtr]);
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
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, handles.x_filtr);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                             %pro bezchybn� zobrazen�
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, handles.x_filtr);
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
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',handles.x_filtr,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data)
       elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                            %pro bezchybn� zobrazen� 
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',handles.x_filtr,0)));
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
       handles.Filtr_data = imread('GUI_bez_filtrace.png');       
end
         
guidata(hObject, handles)

% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function popmenu_filtrace_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%**************************************************************************
%______________________Vybr�n� segmenta�n� metody__________________________
% Provede se p�i zm�n� v�b�ru popmenut_seg_metoda.
function popmenu_seg_metoda_Callback(hObject, eventdata, handles)

vyber_metody = get(hObject,'Value'); %Vybere se konkr�tn� typ segmenta�n� metody pomoc� "Pop-up Menu"

switch vyber_metody 
    
  case 1 %Bez segmenta�n� metody...........................................
      
    %Pomocn� pro v�ber segmeta�n� metody � nen� vybr�na segmenta�n� metoda (pro pozd�j�� o�et�en�)  
    handles.pom_vyber_metody = 1;  
                
    %Zneviditeln�n� ostatn�ch v�c� (texty k dan�m hodnot�m atd.)
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
    %Zneviditeln� pot�ebn�ch parametr� na aktivn� kontury
    set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
    set(handles.text_max_it,'visible','off')
    set(handles.max_iterace,'visible','off')
    set(handles.text_posled_snimek,'visible','off')
    set(handles.text_pocatec_snimek,'visible','off')
    set(handles.edit_zacatek,'visible','off')
    set(handles.edit_konec,'visible','off')
   
  case 2  %V�b�r metody NAR�ST�N� OBLAST�...................................

  %Zneviditeln�n� ostatn�ch v�c� (texty k dan�m hodnot�m atd.)     
  %Zneviditeln� pot�ebn�ch parametr� na aktivn� kontury
  set(handles.nastaveni_hodnot_aktiv_kontur,'visible','off') 
  set(handles.text_max_it,'visible','off')
  set(handles.max_iterace,'visible','off')   
 
   if  handles.pom_vyber_dat ~= 2; 
   set(handles.text_posled_snimek,'visible','off')
   set(handles.text_pocatec_snimek,'visible','off')
   set(handles.edit_zacatek,'visible','off')
   set(handles.edit_konec,'visible','off')
   end
  
  %Pomocn� pro v�ber segmeta�n� metody � segmenta�n� metoda nar�st�n� oblast� (pro pozd�j�� o�et�en�)    
  handles.pom_vyber_metody = 2; 
              
  %Zviditeln�n� nastaviteln�ch vstupn�ch parametr�
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
  
  %P�i v�b�ru Lee a Frost filtru se defualtn� nastav� hodnota maxim�ln�ho intervalu 
  %intenzity na 0.1 v jin�ch p��padech 0.2
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
              
    %Pou�it� filtrace po zm�n�n� segmenta�n� metody, aby se zobrazila v GUI
    if handles.pom_vyber_filtr == 1 %Medianov� filtrace
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
                errordlg('Pro tento v�b�r mus� m�t filtrovan� obraz','Chyba')   
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
                               
 case 3 %V�b�r metody AKTIVN� KONTURY......................................

  %Zneviditeln�n� ostatn�ch v�c� (texty k dan�m hodnot�m atd.)     
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
 
   if  handles.pom_vyber_dat ~= 2; 
   set(handles.text_posled_snimek,'visible','off')
   set(handles.text_pocatec_snimek,'visible','off')
   set(handles.edit_zacatek,'visible','off')
   set(handles.edit_konec,'visible','off')
   end
  
  
  %Pomocn� pro v�ber segmeta�n� metody � segmenta�n� metoda aktivn� kontury (pro pozd�j�� o�et�en�) 
  handles.pom_vyber_metody = 3;
                
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
   
   %Zviditeln� pot�ebn�ch parametr� na aktivn� kontury
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
  
   
   %Nastaven� parametr� pro pozd�j�� pou�it� v segmentaci metodou aktivn�ch kontur
   if handles.pom == 1                      %Pokud jsou vybr�na data prove�
          otazka = questdlg('Bude� cht�t naj�t manu�ln� hodnotu ve Vstupn�ch datech nebo ve Filtrovan�m obrazu?','V�b�r',...
                            'Vstupn� data','Filtrovan� obraz','Filtrovan� obraz');
         switch otazka
           case 'Vstupn� data' %Pokud vybere�, �e chce� ur�it vstupn� hodnoty ze vstupn�ho obrazu
            axes(handles.Vstupni_obraz)   
            handles.pocatecni_maska=roipoly(handles.Vstupni_data); %ur�en� vstupn� masky do metody segmentace aktivn�ch kontur pomoc� funkce roipoly
           case 'Filtrovan� obraz' %Pokud vybere�, �e chce� ur�it vstupn� hodnoty z filtrovan�ho obrazu
            if handles.pom_vyber_filtr == 0; %mus� b�t p�edem provedena filtrace, jinak se vyp�e chybov� hl�ka
               errordlg('Pro tento v�b�r mus� m�t filtrovan� obraz','Chyba')   
            else
               axes(handles.Filtr_obr)
               handles.pocatecni_maska=roipoly(handles.Filtr_data); %ur�en� vstupn� masky do metody segmentace aktivn�ch kontur pomoc� funkce roipoly
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
function popmenu_seg_metoda_CreateFcn(hObject, eventdata, ~)
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
      
   elseif handles.pom_vyber_metody == 2; %NAR�ST�N� OBLAST�...............
     
    if handles.pom_vyber_dat == 1; %FANTOMOV� DATA
     for i = 0:4 
       if handles.pocitadlo == 0   
          axes(handles.Vstupni_obraz)
          imshow(handles.Vstupni_data,[])
       else
          s  = regionprops(handles.Vystup,'centroid');
          handles.y = round(s(1).Centroid(1));
          handles.x = round(s(1).Centroid(2));

       %Zobrazen� aktu�ln�ho sn�mku 
       handles.Vstupni_data = imread(['sedy_',num2str(i),'.bmp']);  %fantom   
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data,[])
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       
       %Pokud je obraz p�efiltrov�n, zobrazen� aktu�ln� filtrace
       if handles.pom_vyber_filtr ~= 0
            if handles.pom_vyber_filtr == 1 %Medianov� filtrace
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
           %Na�ten� obr�zku bez filtrace        
           bez_filtr = imread('GUI_bez_filtrace.png');  
           axes(handles.Filtr_obr)
           imshow(bez_filtr)  
       end
      end 
       
      %Vypsan� hodnoty maxim�ln�ho intrevalu intenzity 
      reg_max = get(handles.max_interval,'String');
      reg_max = str2num(reg_max);
      
      %Zavol�n� funkce, kter� provede segmentovac� metodu nar�st�n� oblast�        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl pou�it�
         [handles.Vystup] = Narust_oblast(handles.Vstupni_data, handles.x, handles.y, reg_max);
         
         %Pou�it� morfologick�ch operac�
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
      else %Filtr byl pou�it�
         [handles.Vystup] = Narust_oblast(handles.Filtr_data, handles.x, handles.y, reg_max);
     
         %Pou�it� morfologick�ch operac�
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
        
      %Ulo�en� v�stupu do matice, z kter� se po vykon�n� segmentace bude
      %d�t v�stup znovu zobrazovat: 
       handles.Vystup_data_narust_oblast = [handles.Vystup_data_narust_oblast,handles.Vystup];
       handles.Vstup_pom = [handles.Vstup_pom,handles.Vstupni_data];
       handles.Filtr_pom = [handles.Filtr_pom,handles.Filtr_data];
       
       handles.pocitadlo = handles.pocitadlo + 1; %Po��tadlo se inkrementuje 
       pause(.01); 
     end
     
    elseif handles.pom_vyber_dat == 2 %RE�LN� DATA
        
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
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
         if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
         else
         handles.Vstupni_data = data1{handles.pom_zacatek};
        [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
         end
       elseif  handles.pom_real_data == 2
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
         if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
         else
          handles.Vstupni_data = data2{handles.pom_zacatek};   
         [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
        end
       elseif  handles.pom_real_data == 3  
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazen� aktu�ln�ho sn�mku
        if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
        else
        handles.Vstupni_data = data1{handles.pom_zacatek};   
        [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
        end
       elseif  handles.pom_real_data == 4 
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazen� aktu�ln�ho sn�mku
        if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data2)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data2{handles.pom_zacatek}; 
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       end
       elseif  handles.pom_real_data == 5
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data1{handles.pom_zacatek}; 
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       end
       elseif  handles.pom_real_data == 6
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data2)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data2{handles.pom_zacatek};           
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       end
       elseif  handles.pom_real_data == 0 %Data vybr�n� od u�ivatele
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{handles.pom_zacatek};
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       end
       
     for i = handles.pom_zacatek :handles.pom_krok: handles.pom_konec
       if handles.pocitadlo == 0   
          axes(handles.Vstupni_obraz)
          imshow(handles.Vstupni_data,[])
       else
          s  = regionprops(handles.Vystup,'centroid');
          handles.y = round(s(1).Centroid(1));
          handles.x = round(s(1).Centroid(2));
       
       %Zobrazen� aktu�ln�ho sn�mku 
       if handles.pom_real_data == 1 
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data1{i};
       elseif  handles.pom_real_data == 2
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data2{i};          
       elseif  handles.pom_real_data == 3  
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data1{i};           
       elseif  handles.pom_real_data == 4 
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data2{i};           
       elseif  handles.pom_real_data == 5
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data1{i};           
       elseif  handles.pom_real_data == 6
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data2{i};           
       elseif  handles.pom_real_data == 0 %Data vybr�n� od u�ivatele
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{i};
       end
       
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data,[])
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       
       %Pokud je obraz p�efiltrov�n, zobrazen� aktu�ln� filtrace
       if handles.pom_vyber_filtr ~= 0
            if handles.pom_vyber_filtr == 1 %Medianov� filtrace
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
           %Na�ten� obr�zku bez filtrace        
           bez_filtr = imread('GUI_bez_filtrace.png');  
           axes(handles.Filtr_obr)
           imshow(bez_filtr)  
       end
      end 
      
      %Vypsan� hodnoty maxim�ln�ho intrevalu intenzity 
      reg_max = get(handles.max_interval,'String');
      reg_max = str2num(reg_max);
      
      %Zavol�n� funkce, kter� provede segmentovac� metodu nar�st�n� oblast�        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl pou�it�
         [handles.Vystup] = Narust_oblast(handles.Vstupni_data, handles.x, handles.y, reg_max);
         %Pou�it� morfologick�ch operac�
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
      else %Filtr byl pou�it�
         [handles.Vystup] = Narust_oblast(handles.Filtr_data, handles.x, handles.y, reg_max);
         
         %Pou�it� morfologick�ch operac�
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
        
      %Ulo�en� v�stupu do matice, z kter� se po vykon�n� segmentace bude
      %d�t v�stup znovu zobrazovat: 
       handles.Vystup_data_narust_oblast = [handles.Vystup_data_narust_oblast,handles.Vystup];
       handles.Vstup_pom = [handles.Vstup_pom,handles.Vstupni_data];
       handles.Filtr_pom = [handles.Filtr_pom,handles.Filtr_data];      
       
       handles.pocitadlo = handles.pocitadlo + 1; %Po��tadlo se inkrementuje 
       pause(.01); 
     end        
        
    else 
     errordlg('CHYBA - zkontroluj zda m� vybran� vstupn� data','Chyba!')
    end
    
   elseif handles.pom_vyber_metody == 3;  %AKTIVN� KONTURY.................

      max_it = get(handles.max_iterace,'String'); 
      max_it= str2num(max_it);
        
    if handles.pom_vyber_dat == 1; %FANTOMOV� DATA
     for i = 0:4 
       if handles.pocitadlo == 0   
          axes(handles.Vstupni_obraz)
          imshow(handles.Vstupni_data,[])
       else
         handles.pocatecni_maska = handles.Vystup;

       %Zobrazen� aktu�ln�ho sn�mku 
       handles.Vstupni_data = imread(['sedy_',num2str(i),'.bmp']);  %fantom   
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data,[])
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       
       %Pokud je obraz p�efiltrov�n, zobrazen� aktu�ln� filtrace
       if handles.pom_vyber_filtr ~= 0
            if handles.pom_vyber_filtr == 1 %Medianov� filtrace
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
           %Na�ten� obr�zku bez filtrace        
           bez_filtr = imread('GUI_bez_filtrace.png');  
           axes(handles.Filtr_obr)
           imshow(bez_filtr)  
       end
       
      end 
      
      %Zavol�n� funkce, kter� provede segmentovac� metodu nar�st�n� oblast�        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl pou�it�
         [handles.Vystup] = Aktiv_kontur(handles.Vstupni_data, handles.pocatecni_maska, max_it);
         
         %Pou�it� morfologick�ch operac�
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
         
      else %Filtr byl pou�it�
         [handles.Vystup] = Aktiv_kontur(handles.Filtr_data, handles.pocatecni_maska, max_it);
         
         %Pou�it� morfologick�ch operac�
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
        
      %Ulo�en� v�stupu do matice, z kter� se po vykon�n� segmentace bude
      %d�t v�stup znovu zobrazovat: 
      handles.Vystup_data_aktiv_kontur = [handles.Vystup_data_aktiv_kontur,handles.Vystup];
       handles.Vstup_pom = [handles.Vstup_pom,handles.Vstupni_data];
       handles.Filtr_pom = [handles.Filtr_pom,handles.Filtr_data];
       
       handles.pocitadlo = handles.pocitadlo + 1; %Po��tadlo se inkrementuje 
       pause(.01); 
       
     end
    elseif handles.pom_vyber_dat == 2 %RE�LN� DATA
  
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
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
         if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
         else
         handles.Vstupni_data = data1{handles.pom_zacatek};
        [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
         end
       elseif  handles.pom_real_data == 2
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
         if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
         else
          handles.Vstupni_data = data2{handles.pom_zacatek};   
         [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
        end
       elseif  handles.pom_real_data == 3  
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazen� aktu�ln�ho sn�mku
        if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
        else
        handles.Vstupni_data = data1{handles.pom_zacatek};   
        [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
        end
       elseif  handles.pom_real_data == 4 
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazen� aktu�ln�ho sn�mku
        if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data2)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data2{handles.pom_zacatek}; 
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       end
       elseif  handles.pom_real_data == 5
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       if handles.pom_zacatek > length(data1) || handles.pom_konec > length(data1)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data1{handles.pom_zacatek}; 
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       end
       elseif  handles.pom_real_data == 6
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       if handles.pom_zacatek > length(data2) || handles.pom_konec > length(data2)
          errordlg('CHYBA sekvence je pouze do ��sla 257, pou�il si v�t�� rozsah, za 15 sekund se automaticky tento program restartuje','Chyba!')
          pause(15);
          OrigDlgH = ancestor(hObject, 'figure');
          delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
          GUI_sekvence  
       else
       handles.Vstupni_data = data2{handles.pom_zacatek};           
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       end
       elseif  handles.pom_real_data == 0 %Data vybr�n� od u�ivatele
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{handles.pom_zacatek};
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       end
       
     for i = handles.pom_zacatek : handles.pom_krok :handles.pom_konec
       if handles.pocitadlo == 0   
          axes(handles.Vstupni_obraz)
          imshow(handles.Vstupni_data,[])
       else
         handles.pocatecni_maska = handles.Vystup;
       
       %Zobrazen� aktu�ln�ho sn�mku 
 
       if handles.pom_real_data == 1 
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data1{i};
       elseif  handles.pom_real_data == 2
       load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data2{i};          
       elseif  handles.pom_real_data == 3  
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data1{i};           
       elseif  handles.pom_real_data == 4 
       load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data2{i};           
       elseif  handles.pom_real_data == 5
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data1{i};           
       elseif  handles.pom_real_data == 6
       load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat') %Zobrazen� aktu�ln�ho sn�mku
       handles.Vstupni_data = data2{i};           
       elseif  handles.pom_real_data == 0 %Data vybr�n� od u�ivatele
       load(num2str(handles.nazev_souboru))
       handles.Vstupni_data = data{i};
       end
       
       axes(handles.Vstupni_obraz)
       imshow(handles.Vstupni_data,[])
       [handles.Vstupni_data] = Osetreni_obr(handles.Vstupni_data); %O�et�en� spr�vn�ho form�tov�n�
       
       %Pokud je obraz p�efiltrov�n, zobrazen� aktu�ln� filtrace
       if handles.pom_vyber_filtr ~= 0
            if handles.pom_vyber_filtr == 1 %Medianov� filtrace
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
           %Na�ten� obr�zku bez filtrace        
           bez_filtr = imread('GUI_bez_filtrace.png');  
           axes(handles.Filtr_obr)
           imshow(bez_filtr)  
       end
      end 
       
           %Zavol�n� funkce, kter� provede segmentovac� metodu nar�st�n� oblast�        
      if handles.pom_vyber_filtr == 0; %Filtr nebyl pou�it�
         [handles.Vystup] = Aktiv_kontur(handles.Vstupni_data, handles.pocatecni_maska, max_it);
         
         %Pou�it� morfologick�ch operac�
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
         
      else %Filtr byl pou�it�
         [handles.Vystup] = Aktiv_kontur(handles.Filtr_data, handles.pocatecni_maska, max_it);
         
         %Pou�it� morfologick�ch operac�
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
        
      %Ulo�en� v�stupu do matice, z kter� se po vykon�n� segmentace bude
      %d�t v�stup znovu zobrazovat: 
       handles.Vystup_data_aktiv_kontur = [handles.Vystup_data_aktiv_kontur,handles.Vystup];
       handles.Vstup_pom = [handles.Vstup_pom,handles.Vstupni_data];
       handles.Filtr_pom = [handles.Filtr_pom,handles.Filtr_data];
       
       handles.pocitadlo = handles.pocitadlo + 1; %Po��tadlo se inkrementuje 
       pause(.01); 
     end
        
    else 
     errordlg('CHYBA - zkontroluj zda m� vybran� vstupn� data','Chyba!')
    end
   end
   
 set(handles.filtr_button,'visible','off');
 set(handles.reset,'visible','on');
 set(handles.slider,'visible','on');
 set(handles.slider,'Value',(handles.pocitadlo-1)); 
 set(handles.slider,'Max',(handles.pocitadlo-1)); 
 set(handles.slider,'SliderStep', [1/(handles.pocitadlo-1), 1 ]);

 else %Pokud cokoli jin�ho vyhod� se chybov� hl�ka: 
   errordlg('CHYBA - zkontroluj zda m� vybranou metodu segmentov�n� a vstupn� data','Chyba!')
 end
 

 guidata(hObject, handles);


 %%
%*************************************************************************
%_________________________Ostatn� pomocn� funkce___________________________

function filtr_okno_Callback(hObject, eventdata, handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�..
function filtr_okno_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function max_iterace_Callback(hObject, eventdata, handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function max_iterace_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sourad_x_Callback(hObject, eventdata, handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function sourad_x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sourad_y_Callback(hObject, eventdata, handles)
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function sourad_y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function max_interval_Callback(hObject, eventdata, handles)

% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function nastav_hodnot_narust_oblast_CreateFcn(hObject, eventdata, handles)

% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function max_interval_CreateFcn(hObject, eventdata, handles)
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
            errordlg('Pro tento v�b�r mus� m�t filtrovan� obraz','Chyba')   
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


function edit_zacatek_Callback(hObject, eventdata, handles)
handles.pom_zacatek = get(hObject,'value');
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function edit_zacatek_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_konec_Callback(hObject, eventdata, handles)
handles.pom_konec = get(hObject,'value');
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function edit_konec_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function text_pocatec_snimek_CreateFcn(hObject, eventdata, handles)

% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function text_posled_snimek_CreateFcn(hObject, eventdata, handles)


% Provede se, kdy� se stiskne tla��tko Prove� filtraci: 
function filtr_button_Callback(hObject, eventdata, handles)

x_filter = get(handles.filtr_okno,'string'); 
x_filter = str2num(x_filter);
handles.x_filter = x_filter;

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
       handles.Filtr_data = imread('GUI_bez_filtrace.png'); 
       
       %Filtr nebyl pou�it� � pomocn� prom�nn� pro to zda byl pou�it� filtr, �i ne        
       handles.pom_vyber_filtr = 0; 
        
     case 2 %Medi�nov� filtr...............................................
       
       %Zviditeln�n� vstupn�ho okna do filtru, hodnota je defuatln�
       %nastaven� na 5; v GUI se d� ov�em i p�epsat
       set(handles.filtr_okno_text,'visible','on') 
       set(handles.filtr_okno,'visible','on')
       set(handles.filtr_button,'visible','on');
                 
        if handles.pom == 1 %Pokud byly na�teny vstupn� data, provede se medi�nov� filtrace
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x_filter x_filter]);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1 %Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                              %pro bezchybn� zobrazen�
            handles.Filtr_data = medfilt2(handles.Vstupni_data,[x_filter x_filter]);
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
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x_filter);
            axes(handles.Filtr_obr)
            imshow(handles.Filtr_data)
        elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                             %pro bezchybn� zobrazen�
            handles.Filtr_data = Lee_Filtr(handles.Vstupni_data, x_filter);
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
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x_filter,0)));
          axes(handles.Filtr_obr)
          imshow(handles.Filtr_data)
       elseif handles.pom_vyber_dat == 2 && handles.pom == 1%Pokud byla na�ten� re�lna data, provede se o�et�en� 
                                                            %pro bezchybn� zobrazen� 
          handles.Filtr_data = Frost_Filtr(handles.Vstupni_data,getnhood(strel('disk',x_filter,0)));
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

% Provede se kdy� se kline na tla��tko Restartovat: 
function reset_Callback(hObject, eventdata, handles)

OrigDlgH = ancestor(hObject, 'figure');
delete(OrigDlgH); %Vymaz�n� nyn�j��ch hodot a zav�en� sou�asn�ho GUI
GUI_sekvence      %Otev�en� nov�ho GUI  


% Provede se p�i pohybu slideru: 
function slider_Callback(hObject, eventdata, handles)

if handles.pom_vyber_metody == 2 %Kdy� je vybr�na metoda 2 (tedy metoda Nar�st�n� oblast�)
     j = get(hObject,'value');   %Vezme se aktu�ln� hodnota slideru
     pom = ceil(j);              %O�et�en� hodnoty, aby slider postupoval v�dy po jednom obrazu v sekvenci
     if j == pom && j ~= 1
         j = j+1;
     else
         j = pom;
     end
     
     %Zobrazen� ur�it� hodnoty slideru jako obraz (filtrovan�, vstupn� �i v�stupn�) v ��seln�m po�ad� v sekvenci
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
      
elseif handles.pom_vyber_metody == 3 %Kdy� je vybr�na metoda 3 (tedy metoda Aktivn�ch kontur)
     j = get(hObject,'value');       %Vezme se aktu�ln� hodnota slideru
     pom = ceil(j);                  %O�et�en� hodnoty, aby slider postupoval v�dy po jednom obrazu v sekvenci 
     if j == pom && j ~= 1
         j = j+1;
     else
         j = pom;
     end
     
     %Zobrazen� ur�it� hodnoty slideru jako obraz (filtrovan�, vstupn� �i v�stupn�) v ��seln�m po�ad� v sekvenci         
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
% Prov�d� se p�i vytv��en� objekt� po nastaven� v�ech vlastnost�.
function slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
