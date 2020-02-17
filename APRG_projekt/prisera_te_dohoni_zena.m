function varargout = prisera_te_dohoni_zena(varargin)
% PRISERA_TE_DOHONI_ZENA MATLAB code for prisera_te_dohoni_zena.fig
%      PRISERA_TE_DOHONI_ZENA, by itself, creates a new PRISERA_TE_DOHONI_ZENA or raises the existing
%      singleton*.
%
%      H = PRISERA_TE_DOHONI_ZENA returns the handle to a new PRISERA_TE_DOHONI_ZENA or the handle to
%      the existing singleton*.
%
%      PRISERA_TE_DOHONI_ZENA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRISERA_TE_DOHONI_ZENA.M with the given input arguments.
%
%      PRISERA_TE_DOHONI_ZENA('Property','Value',...) creates a new PRISERA_TE_DOHONI_ZENA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prisera_te_dohoni_zena_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prisera_te_dohoni_zena_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prisera_te_dohoni_zena

% Last Modified by GUIDE v2.5 23-Apr-2016 00:51:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prisera_te_dohoni_zena_OpeningFcn, ...
                   'gui_OutputFcn',  @prisera_te_dohoni_zena_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before prisera_te_dohoni_zena is made visible.
function prisera_te_dohoni_zena_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prisera_te_dohoni_zena (see VARARGIN)

% Choose default command line output for prisera_te_dohoni_zena
handles.output = hObject;
handles.hodpredtim = 0;  %Prom�n� pomoc� n� se budou mazat pol��ka minul�ho hodu
handles.aktualni_tah = 0;       %Prom�n�, kter� symbolizuje aktu�ln� tah
handles.hodpredtim_prisery = 0;  
handles.aktualni_tah_prisery = 0;     
handles.hractahne = 1;    %Prom�n� pomoc�, kter� se p�em��uj� tahy hr���, kdy� bude roven 1 tahne hr��, kdy� bude roven 0 tahne p��era
handles.pocet_tahu = 0;   %Prom�n� do n� ukl�d�me po�et tah� hr��e
handles.konec = 0; %pomocn� prom�n� pro ukon�en� programu, kdy� pan��eka nese�ere p��era
handles.v = 0;            %Prom�n� pro grafick� zn�zorn�n� hodu kostkou
handles.zivoty = 3;       %Prom�n� pro ur�ov�n� kolik m� hr�� �ivot� 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prisera_te_dohoni_zena wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = prisera_te_dohoni_zena_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton0.
function pushbutton0_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.hractahne == 1
    x = 1; 
    [ hod ] = hod_kostkou( x );  %Funkce hod kostkou
    [ v ] = hod_kostkou_graficky( hod ); %Funkce pro zobrazen� hodu kostkou graficky
    handles.v = set(handles.pushbutton0,'cdata',imread(v)); %Zobrazen� hodu kostkou graficky
    handles.aktualni_tah = handles.aktualni_tah + hod; %Ulo�en� ��sla aktu�ln�ho tahu
    handles.pocet_tahu = handles.pocet_tahu + 1; %Po��tadlo tah�
    
    %P�emaz�n� p�edchoz�ho tahu + o�et�en� vybarven�ch pol� (jako
    %�erven�ho, �lut�ho a modr�ho)
    if (handles.hodpredtim == 11) || (handles.hodpredtim == 15) ||  (handles.hodpredtim == 30)  || (handles.hodpredtim == 34)
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko_modry.jpg'));
    elseif (handles.hodpredtim == 20) || (handles.hodpredtim == 25) ||(handles.hodpredtim == 41) || (handles.hodpredtim == 43)
            set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg'));
    elseif (handles.hodpredtim == 48) || (handles.hodpredtim == 49)|| (handles.hodpredtim == 50)
                set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko_zluty.jpg'));
    elseif handles.hodpredtim == 0 %pro o�et�en� prvn�ho hodu, aby se nezm�nila kostka na pol��ko
    else
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko.jpg'))
    end
    
    if handles.aktualni_tah > 51 %O�et�en�, aby mi nep�e�el pan��ek pole
    handles.aktualni_tah = handles.hodpredtim;
    elseif handles.aktualni_tah == 51 %Kdy� se spln� tato podm�nka, tak hr�� se dost�v� na pol��ko dome�ku
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\cilove_policko.jpg'))
        handles.konec = 1;
        if handles.zivoty > 1 %Podm�nka pro spr�vn� pravopis na konci 
        disp(['Vyhr�l jsi se ', num2str(handles.zivoty),' �ivoty.']);
        else
        disp(['Vyhr�l jsi s ', num2str(handles.zivoty),' �ivotem.']);    
        end
    end
    
     %Zobrazen� aktu�ln�ho tahu + o�et�en� pol��ek, �erven�, modr�ch a
    %�lut�ch a pokl�d�n� ot�zek b�hem hry
    if (handles.aktualni_tah == 11) || (handles.aktualni_tah == 15) || (handles.aktualni_tah == 30)  || (handles.aktualni_tah == 34)
     set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka_modry.jpg'));       
     vstup_aj = 1;
     [ otazka_aj, odpoved1_aj, odpoved2_aj, odpoved3_aj, vysledek_aj ] = generovani_mod_otazek( vstup_aj ); %funkce pro generov�n� ot�zek na modr�ch pol��k�ch
     otazka_mod = questdlg(otazka_aj,'Ot�zky z angli�tiny',odpoved1_aj,odpoved2_aj,odpoved3_aj, odpoved3_aj); % ot�zka na modr�m poli�ku
       switch (otazka_mod)
           case vysledek_aj %kdy� hr�� odpov� spr�vn� z�stane na m�st�
           handles.aktualni_tah = handles.aktualni_tah; 
           otherwise %kdy� odpov� �patn� posune se o 3 pol��ka zp�t
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\policko_modry.jpg')); %p�emaz�n� pol��ka
           handles.aktualni_tah = handles.aktualni_tah - 3;
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka.jpg')); %p�esunut� pan��ka o 3 m�sta zp�t
       end
    elseif (handles.aktualni_tah == 20) || (handles.aktualni_tah == 25) || (handles.aktualni_tah == 41) || (handles.aktualni_tah == 43)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka_cerveny.jpg'));       
        vstup_mat = 1;
        [ otazka_mat, vysledek_mat ] = generovani_cer_otazek( vstup_mat ); %funkce pro generov�n� p��klad� na �erven�ch pol��k�ch
        otazka_cer = inputdlg( otazka_mat, 'Vypo�ti',[1 50]); % vyhozen� ot�zky na �erven�m poli�ku
        pomocna_cer = double(otazka_cer{1,1}); % p�eveden� z bun��n�ho pole na vektor
        if pomocna_cer == vysledek_mat %kdy� hr�� odpov� spr�vn� z�stane na m�st�
          handles.aktualni_tah = handles.aktualni_tah; 
        else %kdy� odpov� �patn� posune se o 3 pol��ka zp�t
          set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg')); %p�emaz�n� pol��ka
          handles.aktualni_tah = handles.aktualni_tah - 3;
          set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka.jpg')); %p�esunut� pan��ka o 3 m�sta zp�t
        end
    elseif (handles.aktualni_tah == 48) || (handles.aktualni_tah == 49)|| (handles.aktualni_tah == 50)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka_zluty.jpg')); 
        vstup_bonus = 1;
        [ otazka_bonus, odpoved1_bonus, odpoved2_bonus, odpoved3_bonus, vysledek_bonus ] = generovani_zlu_otazek( vstup_bonus ); %funkce pro generov�n� ot�zek na �lut�ch pol��k�ch
       otazka_zlu = questdlg(otazka_bonus,'BONUSOV� ot�zky t�kaj�c� se programov�n� v Matlabu',odpoved1_bonus,odpoved2_bonus,odpoved3_bonus,odpoved3_bonus); % ot�zka na �lut�m poli�ku
       switch (otazka_zlu)
           case vysledek_bonus %kdy� hr�� odpov� spr�vn� z�stane na m�st�
           handles.aktualni_tah = handles.aktualni_tah; 
           otherwise %kdy� odpov� �patn� posune se o 10 pol��ka zp�t
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\policko_zluty.jpg')); %p�emaz�n� pol��ka
           handles.aktualni_tah = handles.aktualni_tah - 10;
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka.jpg')); %p�esunut� pan��ka o 10 m�sta zp�t
       end
    else
     set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka.jpg')) 
    end
    
    handles.hodpredtim = handles.aktualni_tah;
    
     if handles.aktualni_tah == handles.hodpredtim_prisery %Podm�nka pro vyhazov�n�, kdy� stoupne hr�� na p��eru
       handles.aktualni_tah = 0;
       handles.zivoty = handles.zivoty - 1; %Ode��t�n� �ivot�
       if handles.zivoty == 2 %Ode��t�n� �ivot� graficky
           set(handles.pushbutton55,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty == 1
           set(handles.pushbutton54,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty == 0
           set(handles.pushbutton53,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
           handles.konec = 1; 
           disp('Prohr�l jsi! Ztratil jsi v�echny �ivoty. P��era t� se�rala.');
       end
       set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg'))
    end 
end
if handles.pocet_tahu > 3;  %Podm�nka, �e kdy� hr�� tahne t�ikr�t, a� pak vyjede p��era
    handles.hractahne = 0;
end

if handles.hractahne == 0
     x = 1; 
    [ hod ] = hod_kostkou( x );  %Funkce hod kostkou
    handles.aktualni_tah_prisery = handles.aktualni_tah_prisery + hod; %Ulo�en� ��sla aktu�ln�ho tahu
    
    %P�emaz�n� p�edchoz�ho tahu + o�et�en� vybarven�ch pol� (jako
    %�erven�ho, �lut�ho a modr�ho)
    if handles.hodpredtim_prisery == 51
    set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\cilove_policko.jpg'));
    elseif(handles.hodpredtim_prisery == 11) || (handles.hodpredtim_prisery == 15) || (handles.hodpredtim_prisery == 30)  || (handles.hodpredtim_prisery == 34)
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko_modry.jpg'));
    elseif (handles.hodpredtim_prisery == 20) || (handles.hodpredtim_prisery == 25) ||(handles.hodpredtim_prisery == 41) || (handles.hodpredtim_prisery == 43)
            set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg'));
    elseif (handles.hodpredtim_prisery == 48) || (handles.hodpredtim_prisery == 49)|| (handles.hodpredtim_prisery == 50)
            set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko_zluty.jpg'));
    elseif handles.hodpredtim_prisery == 0 %pro o�et�en� prvn�ho hodu, aby se nezm�nila kostka na pol��ko
    else 
     set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko.jpg'));
    end
    
    if handles.aktualni_tah_prisery > 51 %O�et�en�, aby mi nep�e�ela p��era pole
       handles.aktualni_tah_prisery = handles.aktualni_tah_prisery - 51;

    end
    
    if handles.aktualni_tah == handles.aktualni_tah_prisery %Podm�nka pro vyhazov�n�
       handles.aktualni_tah = 0;
       handles.zivoty = handles.zivoty - 1; %Ode��t�n� �ivot�
       if handles.zivoty == 2 %Ode��t�n� �ivot� graficky
           set(handles.pushbutton55,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty == 1
           set(handles.pushbutton54,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty == 0
           set(handles.pushbutton53,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
           handles.konec = 1; 
           disp('Prohr�l jsi! Ztratil jsi v�echny �ivoty. P��era t� se�rala.');
       end
       set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg'))
    end 
    
        %Zobrazen� aktu�ln�ho tahu + o�et�en� pol��ek, �erven�, modr�ch a
        %�lut�ch
        if (handles.aktualni_tah_prisery == 11) || (handles.aktualni_tah_prisery == 15) || (handles.aktualni_tah_prisery == 30)  || (handles.aktualni_tah_prisery == 34)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera_modry.jpg'));       
        elseif (handles.aktualni_tah_prisery == 20) || (handles.aktualni_tah_prisery == 25) ||(handles.aktualni_tah_prisery == 41) || (handles.aktualni_tah_prisery == 43)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera_cerveny.jpg'));       
        elseif (handles.aktualni_tah_prisery == 48) || (handles.aktualni_tah_prisery == 49)|| (handles.aktualni_tah_prisery == 50)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera_zluty.jpg'));    
        else
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg')) 
        end
        
     handles.hodpredtim_prisery = handles.aktualni_tah_prisery; %ulo�en� aktu�ln�ho hodu do hodu p�edt�m
     handles.hractahne = 1;  %Pokyn, �e t�hne zase hr��
     
 end
guidata(hObject, handles);
if handles.konec == 1
    close all
end
