function varargout = prisera_te_dohoni_jeden_za_dva(varargin)
% PRISERA_TE_DOHONI_JEDEN_ZA_DVA MATLAB code for prisera_te_dohoni_jeden_za_dva.fig
%      PRISERA_TE_DOHONI_JEDEN_ZA_DVA, by itself, creates a new PRISERA_TE_DOHONI_JEDEN_ZA_DVA or raises the existing
%      singleton*.
%
%      H = PRISERA_TE_DOHONI_JEDEN_ZA_DVA returns the handle to a new PRISERA_TE_DOHONI_JEDEN_ZA_DVA or the handle to
%      the existing singleton*.
%
%      PRISERA_TE_DOHONI_JEDEN_ZA_DVA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRISERA_TE_DOHONI_JEDEN_ZA_DVA.M with the given input arguments.
%
%      PRISERA_TE_DOHONI_JEDEN_ZA_DVA('Property','Value',...) creates a new PRISERA_TE_DOHONI_JEDEN_ZA_DVA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prisera_te_dohoni_jeden_za_dva_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prisera_te_dohoni_jeden_za_dva_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prisera_te_dohoni_jeden_za_dva

% Last Modified by GUIDE v2.5 23-Apr-2016 15:50:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prisera_te_dohoni_jeden_za_dva_OpeningFcn, ...
                   'gui_OutputFcn',  @prisera_te_dohoni_jeden_za_dva_OutputFcn, ...
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


% --- Executes just before prisera_te_dohoni_jeden_za_dva is made visible.
function prisera_te_dohoni_jeden_za_dva_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prisera_te_dohoni_jeden_za_dva (see VARARGIN)

% Choose default command line output for prisera_te_dohoni_jeden_za_dva
handles.output = hObject;
handles.hodpredtim = 0;          %Promìná pomocí níž se budou mazat políèka minulého hodu
handles.aktualni_tah = 0;        %Promìná, která symbolizuje aktuální tah
handles.hodpredtim_prisery = 0;  
handles.aktualni_tah_prisery = 0;     
handles.hractahne_prisera = 0;   %Promìná pomocí, které se pøemìòují tahy hráèù, když bude roven 1 tahne pøíšera
handles.hractahne = 1;           %Promìná pomocí, které se pøemìòují tahy hráèù, když bude roven 1 tahne hráè
handles.pocet_tahu = 0;          %Promìná do níž ukládáme poèet tahù hráèe
handles.konec = 0;               %Pomocná promìná pro ukonèení programu, ukonèení hry
handles.v = 0;                   %Promìná pro grafické znázornìní hodu kostkou
handles.hractahne2 = 0;          %Promìná pomocí, které se pøemìòují tahy hráèù, když bude roven 1 tahne hráè
handles.zivoty = 3;              %Promìná pro urèování kolik má hráè životù 
handles.hodpredtim2 = 0;         %Promìná pomocí níž se budou mazat políèka minulého hodu druhého hráèe
handles.aktualni_tah2 = 0;       %Promìná, která symbolizuje aktuální tah druhého hráèe
handles.pocet_tahu2 = 0;         %Promìná do níž ukládáme poèet tahù druhého hráèe
handles.zivoty2 = 3;             %Promìná pro urèování kolik má druhý hráè životù 
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prisera_te_dohoni_jeden_za_dva wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = prisera_te_dohoni_jeden_za_dva_OutputFcn(hObject, eventdata, handles) 
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
    [ hod ] = hod_kostkou( x ); %Funkce hod kostkou
    [ v ] = hod_kostkou_graficky( hod ); %Funkce pro zobrazení hodu kostkou graficky
    handles.v = set(handles.pushbutton0,'cdata',imread(v)); %Zobrazení hodu kostkou graficky
    handles.aktualni_tah = handles.aktualni_tah + hod; %Uložení èísla aktuálního tahu
    handles.pocet_tahu = handles.pocet_tahu + 1; %Poèítadlo tahù
    
    %Pøemazání pøedchozího tahu + ošetøení vybarvených polí (jako
    %èerveného, žlutého a modrého) + když se potká holka s klukem a se navzájem nepøemažou
    if (handles.hodpredtim == 11) || (handles.hodpredtim == 15) || (handles.hodpredtim == 30)  || (handles.hodpredtim == 34)
       if handles.hodpredtim == handles.hodpredtim2 %Když se potká holka s klukem a se navzájem nepøemažou
         set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\holka_modry.jpg'));  
       else
          set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko_modry.jpg'));
       end
    elseif (handles.hodpredtim == 20) || (handles.hodpredtim == 25) || (handles.hodpredtim == 41) || (handles.hodpredtim == 43)
       if handles.hodpredtim == handles.hodpredtim2 %Když se potká holka s klukem a se navzájem nepøemažou
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\holka_cerveny.jpg')); 
       else
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg'));
       end
    elseif (handles.hodpredtim == 48) || (handles.hodpredtim == 49)|| (handles.hodpredtim == 50)
       if handles.hodpredtim == handles.hodpredtim2 %Když se potká holka s klukem a se navzájem nepøemažou
         set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\holka_zluty.jpg'));  
       else
         set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko_zluty.jpg'));
       end
    elseif handles.hodpredtim == 51
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\cilove_policko.jpg'))
    elseif handles.hodpredtim == 0 %pro ošetøení prvního hodu, aby se nezmìnila kostka na políèko
    elseif handles.hodpredtim == handles.hodpredtim2 
     set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\holka.jpg'));
    else
     set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\policko.jpg'))
    end
    
    if handles.aktualni_tah > 51 %Ošetøení, aby mi nepøešel panáèek pole
    handles.aktualni_tah = handles.hodpredtim;
    end
    
    %Zobrazení aktuálního tahu + ošetøení políèek, èervený, modrých a
    %žlutých a pokládání otázek bìhem hry + ošetøení když se budou hráèi pøekrývat
    if (handles.aktualni_tah == 11) || (handles.aktualni_tah == 15) || (handles.aktualni_tah == 30)  || (handles.aktualni_tah == 34)
     if handles.aktualni_tah == handles.aktualni_tah2 %ošetøení, když se hráèi pøekrývají
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek_holka_modry.jpg'));
     else
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek_modry.jpg'));
     end
     vstup_aj = 1;
     [ otazka_aj, odpoved1_aj, odpoved2_aj, odpoved3_aj, vysledek_aj ] = generovani_mod_otazek( vstup_aj ); %funkce pro generování otázek na modrých políèkách
     otazka_mod = questdlg(otazka_aj,'Otázky z angliètiny',odpoved1_aj,odpoved2_aj,odpoved3_aj,odpoved3_aj); % otázka na modrém polièku
       switch (otazka_mod)
           case vysledek_aj %když hráè odpoví správnì zùstane na místì
           handles.aktualni_tah = handles.aktualni_tah; 
           otherwise %když odpoví špatnì posune se o 3 políèka zpìt
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\policko_modry.jpg')); %pøemazání políèka
           handles.aktualni_tah = handles.aktualni_tah - 3;
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek.jpg')); %pøesunutí panáèka o 3 místa zpìt
       end
    elseif (handles.aktualni_tah == 20) || (handles.aktualni_tah == 25) || (handles.aktualni_tah == 41) || (handles.aktualni_tah == 43)
       if handles.aktualni_tah == handles.aktualni_tah2 %ošetøení, když se hráèi pøekrývají
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek_holka_cerveny.jpg'));
       else
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek_cerveny.jpg'));
       end
        vstup_mat = 1;
        [ otazka_mat, vysledek_mat ] = generovani_cer_otazek( vstup_mat ); %funkce pro generování pøíkladù na èervených políèkách
        otazka_cer = inputdlg( otazka_mat, 'Vypoèti',[1 50]); % vyhození otázky na èerveném polièku
        pomocna_cer = double(otazka_cer{1,1}); % pøevedení z bunìèného pole na vektor
        if pomocna_cer == vysledek_mat %když hráè odpoví správnì zùstane na místì
          handles.aktualni_tah = handles.aktualni_tah; 
        else %když odpoví špatnì posune se o 3 políèka zpìt
          set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg')); %pøemazání políèka
          handles.aktualni_tah = handles.aktualni_tah - 3;
          set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek.jpg')); %pøesunutí panáèka o 3 místa zpìt
        end
    elseif (handles.aktualni_tah == 48) || (handles.aktualni_tah == 49)|| (handles.aktualni_tah == 50)
       if handles.aktualni_tah == handles.aktualni_tah2 %ošetøení, když se hráèi pøekrývají
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek_holka_zlutyy.jpg'));
       else
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek_zluty.jpg'));
       end        
        vstup_bonus = 1;
        [ otazka_bonus, odpoved1_bonus, odpoved2_bonus, odpoved3_bonus, vysledek_bonus ] = generovani_zlu_otazek( vstup_bonus ); %funkce pro generování otázek na žlutých políèkách
       otazka_zlu = questdlg(otazka_bonus,'BONUSOVÉ otázky týkající se programování v Matlabu',odpoved1_bonus,odpoved2_bonus,odpoved3_bonus,odpoved3_bonus); % otázka na žlutém polièku
       switch (otazka_zlu)
           case vysledek_bonus %když hráè odpoví správnì zùstane na místì
           handles.aktualni_tah = handles.aktualni_tah; 
           otherwise %když odpoví špatnì posune se o 10 políèka zpìt
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\policko_zluty.jpg')); %pøemazání políèka
           handles.aktualni_tah = handles.aktualni_tah - 10;
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek.jpg')); %pøesunutí panáèka o 10 místa zpìt
       end
    elseif handles.aktualni_tah == 51 %Když se splní tato podmínka, tak hráè se dostává na políèko domeèku
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\cilove_policko_panacek.jpg'))
        handles.hractahne  = 0;
        handles.hractahne2 = 1;
    else 
       if handles.aktualni_tah == handles.aktualni_tah2 %ošetøení, když se hráèi pøekrývají
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek_holka.jpg'));
       else
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah)),'cdata',imread('obrazky_projekt\panacek.jpg'));
       end
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
           disp('Prohrál jsi pøíšera ti sežrala kluka.');
       end
       set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg'))
   end
   
elseif handles.hractahne2 == 1 %Tahne druhý hráè
    x = 1; 
    [ hod ] = hod_kostkou( x );  %Funkce hod kostkou
    [ v ] = hod_kostkou_graficky( hod ); %Funkce pro zobrazení hodu kostkou graficky
    handles.v = set(handles.pushbutton0,'cdata',imread(v)); %Zobrazení hodu kostkou graficky
    handles.aktualni_tah2 = handles.aktualni_tah2 + hod; %Uložení èísla aktuálního tahu
    handles.pocet_tahu2 = handles.pocet_tahu2 + 1; %Poèítadlo tahù
    
    %Pøemazání pøedchozího tahu + ošetøení vybarvených polí (jako
    %èerveného, žlutého a modrého)+ když se potká holka s klukem a se navzájem nepøemažou
    if (handles.hodpredtim2 == 11) || (handles.hodpredtim2 == 15) ||  (handles.hodpredtim2 == 30)  || (handles.hodpredtim2 == 34)
        if handles.hodpredtim == handles.hodpredtim2 %Když se potká holka s klukem a se navzájem nepøemažou
         set(handles.(sprintf('pushbutton%d',handles.hodpredtim2)),'cdata',imread('obrazky_projekt\panacek_modry.jpg'));  
        else
         set(handles.(sprintf('pushbutton%d',handles.hodpredtim2)),'cdata',imread('obrazky_projekt\policko_modry.jpg'));
        end
    elseif (handles.hodpredtim2 == 20) || (handles.hodpredtim2 == 25) ||(handles.hodpredtim2 == 41) || (handles.hodpredtim2 == 43)
        if handles.hodpredtim == handles.hodpredtim2 %Když se potká holka s klukem a se navzájem nepøemažou
         set(handles.(sprintf('pushbutton%d',handles.hodpredtim2)),'cdata',imread('obrazky_projekt\panacek_cerveny.jpg'));  
        else
         set(handles.(sprintf('pushbutton%d',handles.hodpredtim2)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg'));
        end
    elseif (handles.hodpredtim2 == 48) || (handles.hodpredtim2 == 49)|| (handles.hodpredtim2 == 50)
        if handles.hodpredtim == handles.hodpredtim2 %Když se potká holka s klukem a se navzájem nepøemažou
         set(handles.(sprintf('pushbutton%d',handles.hodpredtim2)),'cdata',imread('obrazky_projekt\panacek_zluty.jpg'));  
        else
         set(handles.(sprintf('pushbutton%d',handles.hodpredtim2)),'cdata',imread('obrazky_projekt\policko_zluty.jpg'));
        end
    elseif handles.hodpredtim2 == 0 %pro ošetøení prvního hodu, aby se nezmìnila kostka na políèko
    elseif handles.hodpredtim2 == 51
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\cilove_policko.jpg'))
    elseif handles.hodpredtim == handles.hodpredtim2 
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim)),'cdata',imread('obrazky_projekt\panacek.jpg'));
    else
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim2)),'cdata',imread('obrazky_projekt\policko.jpg'))
    end
    
    if handles.aktualni_tah2 > 51 %Ošetøení, aby mi nepøešel panáèek pole
    handles.aktualni_tah2 = handles.hodpredtim2;
    end
    
    %Zobrazení aktuálního tahu + ošetøení políèek, èervený, modrých a
    %žlutých a pokládání otázek bìhem hry
    if (handles.aktualni_tah2 == 11) || (handles.aktualni_tah2 == 15) || (handles.aktualni_tah2 == 30)  || (handles.aktualni_tah2 == 34)
       if handles.aktualni_tah == handles.aktualni_tah2 %ošetøení, když se hráèi pøekrývají
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\panacek_holka_modry.jpg'));
       else
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\holka_modry.jpg'));
       end          
     vstup_aj = 1;
     [ otazka_aj, odpoved1_aj, odpoved2_aj, odpoved3_aj, vysledek_aj ] = generovani_mod_otazek( vstup_aj ); %funkce pro generování otázek na modrých políèkách
     otazka_mod = questdlg(otazka_aj,'Otázky z angliètiny',odpoved1_aj,odpoved2_aj,odpoved3_aj, odpoved3_aj); % otázka na modrém polièku
       switch (otazka_mod)
           case vysledek_aj %když hráè odpoví správnì zùstane na místì
           handles.aktualni_tah2 = handles.aktualni_tah2; 
           otherwise %když odpoví špatnì posune se o 3 políèka zpìt
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\policko_modry.jpg')); %pøemazání políèka
           handles.aktualni_tah = handles.aktualni_tah2 - 3;
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\holka.jpg')); %pøesunutí panáèka o 3 místa zpìt
       end
    elseif (handles.aktualni_tah2 == 20) || (handles.aktualni_tah2 == 25) || (handles.aktualni_tah2 == 41) || (handles.aktualni_tah2 == 43)
       if handles.aktualni_tah == handles.aktualni_tah2 %ošetøení, když se hráèi pøekrývají
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\panacek_holka_cerveny.jpg'));
       else
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\holka_cerveny.jpg'));
       end   
        vstup_mat = 1;
        [ otazka_mat, vysledek_mat ] = generovani_cer_otazek( vstup_mat ); %funkce pro generování pøíkladù na èervených políèkách
        otazka_cer = inputdlg( otazka_mat, 'Vypoèti',[1 50]); % vyhození otázky na èerveném polièku
        pomocna_cer = double(otazka_cer{1,1}); % pøevedení z bunìèného pole na vektor
        if pomocna_cer == vysledek_mat %když hráè odpoví správnì zùstane na místì
          handles.aktualni_tah2 = handles.aktualni_tah2; 
        else %když odpoví špatnì posune se o 3 políèka zpìt
          set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg')); %pøemazání políèka
          handles.aktualni_tah2 = handles.aktualni_tah2 - 3;
          set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\holka.jpg')); %pøesunutí panáèka o 3 místa zpìt
        end
    elseif (handles.aktualni_tah2 == 48) || (handles.aktualni_tah2 == 49)|| (handles.aktualni_tah2 == 50)
       if handles.aktualni_tah == handles.aktualni_tah2 %ošetøení, když se hráèi pøekrývají
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\panacek_holka_zluty.jpg'));
       else
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\holka_zluty.jpg'));
       end   
        vstup_bonus = 1;
        [ otazka_bonus, odpoved1_bonus, odpoved2_bonus, odpoved3_bonus, vysledek_bonus ] = generovani_zlu_otazek( vstup_bonus ); %funkce pro generování otázek na žlutých políèkách
       otazka_zlu = questdlg(otazka_bonus,'BONUSOVÉ otázky týkající se programování v Matlabu',odpoved1_bonus,odpoved2_bonus,odpoved3_bonus,odpoved3_bonus); % otázka na žlutém polièku
       switch (otazka_zlu)
           case vysledek_bonus %když hráè odpoví správnì zùstane na místì
           handles.aktualni_tah2 = handles.aktualni_tah2; 
           otherwise %když odpoví špatnì posune se o 10 políèka zpìt
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\policko_zluty.jpg')); %pøemazání políèka
           handles.aktualni_tah2 = handles.aktualni_tah2 - 10;
           set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\holka.jpg')); %pøesunutí panáèka o 10 místa zpìt
       end
    elseif handles.aktualni_tah2 == 51 %Když se splní tato podmínka, tak hráè se dostává na políèko domeèku
        set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\cilove_policko_holka.jpg'))
        handles.hractahne = 1; 
        handles.hractahne2 = 0;    
    else
       if handles.aktualni_tah == handles.aktualni_tah2 %ošetøení, když se hráèi pøekrývají
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\panacek_holka.jpg'));
       else
         set(handles.(sprintf('pushbutton%d',handles.aktualni_tah2)),'cdata',imread('obrazky_projekt\holka.jpg'));
       end   
    end
    
    handles.hodpredtim2 = handles.aktualni_tah2;
    
     if handles.aktualni_tah2 == handles.hodpredtim_prisery %Podmínka pro vyhazování, když stoupne hráè na pøíšeru
       handles.aktualni_tah2 = 0;
       handles.zivoty2 = handles.zivoty2 - 1; %Odeèítání životù
       if handles.zivoty2 == 2 %Odeèítání životù graficky
           set(handles.pushbutton58,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty2 == 1
           set(handles.pushbutton57,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty2 == 0
           set(handles.pushbutton56,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
           handles.konec = 1; 
           disp('Prohrál jsi pøíšera ti sežrala holku.');
       end
       set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg'))
     end 

end

if (handles.pocet_tahu + handles.pocet_tahu2) > 6 ; %Podmínka, že když hráè tahne tøikrát, až pak vyjede pøíšera
   handles.hractahne_prisera = 1;
end

if handles.hractahne_prisera == 1
     x = 1; 
    [ hod ] = hod_kostkou( x );  %Funkce hod kostkou
    handles.aktualni_tah_prisery = handles.aktualni_tah_prisery + hod; %Uložení èísla aktuálního tahu
    
    %Pøemazání pøedchozího tahu + ošetøení vybarvených polí (jako
    %èerveného, žlutého a modrého)
    if handles.hodpredtim_prisery == 51
    set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\cilove_policko.jpg'));
    elseif(handles.hodpredtim_prisery == 11) || (handles.hodpredtim_prisery == 15) || (handles.hodpredtim_prisery == 30)  || (handles.hodpredtim_prisery == 34)
        set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko_modry.jpg'));
    elseif (handles.hodpredtim_prisery == 20) || (handles.hodpredtim_prisery == 25) || (handles.hodpredtim_prisery == 41) || (handles.hodpredtim_prisery == 43)
            set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko_cerveny.jpg'));
    elseif (handles.hodpredtim_prisery == 48) || (handles.hodpredtim_prisery == 49)|| (handles.hodpredtim_prisery == 50)
            set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko_zluty.jpg'));
    elseif handles.hodpredtim_prisery == 0 %pro ošetøení prvního hodu, aby se nezmìnila kostka na políèko
    else 
     set(handles.(sprintf('pushbutton%d',handles.hodpredtim_prisery)),'cdata',imread('obrazky_projekt\policko.jpg'));
    end
    
    if handles.aktualni_tah_prisery > 50 %Ošetøení, aby mi nepøešela pøíšera pole
       handles.aktualni_tah_prisery = handles.aktualni_tah_prisery -50;

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
           disp('Prohrál jsi pøíšera ti sežrala kluka.');
       end
       set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg'))
    elseif handles.aktualni_tah2 == handles.aktualni_tah_prisery %Podmínka pro vyhazování druhého hráèe
       handles.aktualni_tah2 = 0;
       handles.zivoty2 = handles.zivoty2 - 1; %Odeèítání životù
       if handles.zivoty2 == 2 %Odeèítání životù graficky
           set(handles.pushbutton58,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty2 == 1
           set(handles.pushbutton57,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
       elseif handles.zivoty2 == 0
           set(handles.pushbutton56,'cdata',imread('obrazky_projekt\srdce_neni.jpg'));
           handles.konec = 1; 
           disp('Prohrál jsi pøíšera ti sežrala holku.');
       end
       set(handles.(sprintf('pushbutton%d',handles.aktualni_tah_prisery)),'cdata',imread('obrazky_projekt\prisera.jpg'))
    end 
    
        %Zobrazení aktuálního tahu + ošetøení políèek, èervený, modrých a
        %žlutých a vypis otázek pøi šlápnutí na obarvené políèko
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
    handles.hractahne_prisera = 0;
end

if handles.aktualni_tah == 51 && handles.aktualni_tah2 == 51
    handles.konec = 2;
end

guidata(hObject, handles);
if handles.konec == 1
    close all
elseif handles.konec == 2
    close all
    disp(['Vyhrál jsi zvládnul jsi dovést všechny figurky do domeèku. Holka mìla ', num2str(handles.zivoty2), ' život/y a kluk mìl ', num2str(handles.zivoty),' život/y.' ])
end

% --- Executes on button press in pushbutton59.
function pushbutton59_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.hractahne = 0;  %Aby hrála holka
    handles.hractahne2 = 1; 
    guidata(hObject, handles);


% --- Executes on button press in pushbutton60.
function pushbutton60_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.hractahne = 1;  %Aby hrál kluk
    handles.hractahne2 = 0; 
    guidata(hObject, handles);
