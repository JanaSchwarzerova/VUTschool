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
handles.hodpredtim = 0;  %Promìná pomocí níž se budou mazat políèka minulého hodu
handles.aktualni_tah = 0;       %Promìná, která symbolizuje aktuální tah
handles.hodpredtim_prisery = 0;  
handles.aktualni_tah_prisery = 0;     
handles.hractahne = 1;    %Promìná pomocí, které se pøemìòují tahy hráèù, když bude roven 1 tahne hráè, když bude roven 0 tahne pøíšera
handles.pocet_tahu = 0;   %Promìná do níž ukládáme poèet tahù hráèe
handles.konec = 0; %pomocná promìná pro ukonèení programu, když panáèeka nesežere pøíšera
handles.v = 0;            %Promìná pro grafické znázornìní hodu kostkou
handles.zivoty = 3;       %Promìná pro urèování kolik má hráè životù 

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
    [ v ] = hod_kostkou_graficky( hod ); %Funkce pro zobrazení hodu kostkou graficky
    handles.v = set(handles.pushbutton0,'cdata',imread(v)); %Zobrazení hodu kostkou graficky
    handles.aktualni_tah = handles.aktualni_tah + hod; %Uložení èísla aktuálního tahu
    handles.pocet_tahu = handles.pocet_tahu + 1; %Poèítadlo tahù
    
    %Pøemazání pøedchozího tahu + ošetøení vybarvených polí (jako
    %èerveného, žlutého a modrého)
    if (handles.hodpredtim == 11) || (handles.hodpredtim == 15) ||  (handles.hodpredtim == 30)  || (handles.hodpredtim == 34)
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko_modry.jpg'));
    elseif (handles.hodpredtim == 20) || (handles.hodpredtim == 25) ||(handles.hodpredtim == 41) || (handles.hodpredtim == 43)
            set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg'));
    elseif (handles.hodpredtim == 48) || (handles.hodpredtim == 49)|| (handles.hodpredtim == 50)
                set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko_zluty.jpg'));
    elseif handles.hodpredtim == 0 %pro ošetøení prvního hodu, aby se nezmìnila kostka na políèko
    else
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko.jpg'))
    end
    
    if handles.aktualni_tah > 51 %Ošetøení, aby mi nepøešel panáèek pole
    handles.aktualni_tah = handles.hodpredtim;
    elseif handles.aktualni_tah == 51 %Když se splní tato podmínka, tak hráè se dostává na políèko domeèku
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\cilove_policko.jpg'))
        handles.konec = 1;
        if handles.zivoty > 1 %Podmínka pro správný pravopis na konci 
        disp(['Vyhrál jsi se ', num2str(handles.zivoty),' životy.']);
        else
        disp(['Vyhrál jsi s ', num2str(handles.zivoty),' životem.']);    
        end
    end
    
     %Zobrazení aktuálního tahu + ošetøení políèek, èervený, modrých a
    %žlutých a pokládání otázek bìhem hry
    if (handles.aktualni_tah == 11) || (handles.aktualni_tah == 15) || (handles.aktualni_tah == 30)  || (handles.aktualni_tah == 34)
     set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka_modry.jpg'));       
     vstup_aj = 1;
     [ otazka_aj, odpoved1_aj, odpoved2_aj, odpoved3_aj, vysledek_aj ] = generovani_mod_otazek( vstup_aj ); %funkce pro generování otázek na modrých políèkách
     otazka_mod = questdlg(otazka_aj,'Otázky z angliètiny',odpoved1_aj,odpoved2_aj,odpoved3_aj, odpoved3_aj); % otázka na modrém polièku
       switch (otazka_mod)
           case vysledek_aj %když hráè odpoví správnì zùstane na místì
           handles.aktualni_tah = handles.aktualni_tah; 
           otherwise %když odpoví špatnì posune se o 3 políèka zpìt
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\policko_modry.jpg')); %pøemazání políèka
           handles.aktualni_tah = handles.aktualni_tah - 3;
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka.jpg')); %pøesunutí panáèka o 3 místa zpìt
       end
    elseif (handles.aktualni_tah == 20) || (handles.aktualni_tah == 25) || (handles.aktualni_tah == 41) || (handles.aktualni_tah == 43)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka_cerveny.jpg'));       
        vstup_mat = 1;
        [ otazka_mat, vysledek_mat ] = generovani_cer_otazek( vstup_mat ); %funkce pro generování pøíkladù na èervených políèkách
        otazka_cer = inputdlg( otazka_mat, 'Vypoèti',[1 50]); % vyhození otázky na èerveném polièku
        pomocna_cer = double(otazka_cer{1,1}); % pøevedení z bunìèného pole na vektor
        if pomocna_cer == vysledek_mat %když hráè odpoví správnì zùstane na místì
          handles.aktualni_tah = handles.aktualni_tah; 
        else %když odpoví špatnì posune se o 3 políèka zpìt
          set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg')); %pøemazání políèka
          handles.aktualni_tah = handles.aktualni_tah - 3;
          set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka.jpg')); %pøesunutí panáèka o 3 místa zpìt
        end
    elseif (handles.aktualni_tah == 48) || (handles.aktualni_tah == 49)|| (handles.aktualni_tah == 50)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka_zluty.jpg')); 
        vstup_bonus = 1;
        [ otazka_bonus, odpoved1_bonus, odpoved2_bonus, odpoved3_bonus, vysledek_bonus ] = generovani_zlu_otazek( vstup_bonus ); %funkce pro generování otázek na žlutých políèkách
       otazka_zlu = questdlg(otazka_bonus,'BONUSOVÉ otázky týkající se programování v Matlabu',odpoved1_bonus,odpoved2_bonus,odpoved3_bonus,odpoved3_bonus); % otázka na žlutém polièku
       switch (otazka_zlu)
           case vysledek_bonus %když hráè odpoví správnì zùstane na místì
           handles.aktualni_tah = handles.aktualni_tah; 
           otherwise %když odpoví špatnì posune se o 10 políèka zpìt
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\policko_zluty.jpg')); %pøemazání políèka
           handles.aktualni_tah = handles.aktualni_tah - 10;
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka.jpg')); %pøesunutí panáèka o 10 místa zpìt
       end
    else
     set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\holka.jpg')) 
    end
    
    handles.hodpredtim = handles.aktualni_tah;
    
     if handles.aktualni_tah == handles.hodpredtim_prisery %Podmínka pro vyhazování, když stoupne hráè na pøíšeru
       handles.aktualni_tah = 0;
       handles.zivoty = handles.zivoty - 1; %Odeèítání životù
       if handles.zivoty == 2 %Odeèítání životù graficky
           set(handles.pushbutton55,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty == 1
           set(handles.pushbutton54,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty == 0
           set(handles.pushbutton53,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
           handles.konec = 1; 
           disp('Prohrál jsi! Ztratil jsi všechny životy. Pøíšera tì sežrala.');
       end
       set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg'))
    end 
end
if handles.pocet_tahu > 3;  %Podmínka, že když hráè tahne tøikrát, až pak vyjede pøíšera
    handles.hractahne = 0;
end

if handles.hractahne == 0
     x = 1; 
    [ hod ] = hod_kostkou( x );  %Funkce hod kostkou
    handles.aktualni_tah_prisery = handles.aktualni_tah_prisery + hod; %Uložení èísla aktuálního tahu
    
    %Pøemazání pøedchozího tahu + ošetøení vybarvených polí (jako
    %èerveného, žlutého a modrého)
    if handles.hodpredtim_prisery == 51
    set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\cilove_policko.jpg'));
    elseif(handles.hodpredtim_prisery == 11) || (handles.hodpredtim_prisery == 15) || (handles.hodpredtim_prisery == 30)  || (handles.hodpredtim_prisery == 34)
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko_modry.jpg'));
    elseif (handles.hodpredtim_prisery == 20) || (handles.hodpredtim_prisery == 25) ||(handles.hodpredtim_prisery == 41) || (handles.hodpredtim_prisery == 43)
            set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg'));
    elseif (handles.hodpredtim_prisery == 48) || (handles.hodpredtim_prisery == 49)|| (handles.hodpredtim_prisery == 50)
            set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko_zluty.jpg'));
    elseif handles.hodpredtim_prisery == 0 %pro ošetøení prvního hodu, aby se nezmìnila kostka na políèko
    else 
     set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko.jpg'));
    end
    
    if handles.aktualni_tah_prisery > 51 %Ošetøení, aby mi nepøešela pøíšera pole
       handles.aktualni_tah_prisery = handles.aktualni_tah_prisery - 51;

    end
    
    if handles.aktualni_tah == handles.aktualni_tah_prisery %Podmínka pro vyhazování
       handles.aktualni_tah = 0;
       handles.zivoty = handles.zivoty - 1; %Odeèítání životù
       if handles.zivoty == 2 %Odeèítání životù graficky
           set(handles.pushbutton55,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty == 1
           set(handles.pushbutton54,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty == 0
           set(handles.pushbutton53,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
           handles.konec = 1; 
           disp('Prohrál jsi! Ztratil jsi všechny životy. Pøíšera tì sežrala.');
       end
       set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg'))
    end 
    
        %Zobrazení aktuálního tahu + ošetøení políèek, èervený, modrých a
        %žlutých
        if (handles.aktualni_tah_prisery == 11) || (handles.aktualni_tah_prisery == 15) || (handles.aktualni_tah_prisery == 30)  || (handles.aktualni_tah_prisery == 34)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera_modry.jpg'));       
        elseif (handles.aktualni_tah_prisery == 20) || (handles.aktualni_tah_prisery == 25) ||(handles.aktualni_tah_prisery == 41) || (handles.aktualni_tah_prisery == 43)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera_cerveny.jpg'));       
        elseif (handles.aktualni_tah_prisery == 48) || (handles.aktualni_tah_prisery == 49)|| (handles.aktualni_tah_prisery == 50)
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera_zluty.jpg'));    
        else
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg')) 
        end
        
     handles.hodpredtim_prisery = handles.aktualni_tah_prisery; %uložení aktuálního hodu do hodu pøedtím
     handles.hractahne = 1;  %Pokyn, že táhne zase hráè
     
 end
guidata(hObject, handles);
if handles.konec == 1
    close all
end
