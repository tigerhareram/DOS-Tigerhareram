{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X-,F+}

Unit a01_Vari; {global variables}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{Lite}
x01_glob, x02_ram,  x03_dos,  x04_vga,  x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,  x16_misc,

{World}

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


Type
{Sun}  RGBPal256=array[0..255,1..3] of Byte;

{Save} TSave = Record
                 Hodnota: Byte;
               End;

{Save} TKnihovnaInfo = Record
                         JmenaSesitu: array[0..9] of String[50];
                         JmenaBloku:  array[0..4] of String[50];
                         JmenaKnih:   array[0..4] of String[50];
                       End;
{Planetarium}
       teleso = record {obecna definice pro slunce, planety i mesice}
                  Jmeno:string[7]; {jestli chces neco delsiho nez 'Jupiter', prodluz to}
                  Barva:byte; {jakou barvou se ma teleso vykreslit}
                  Polomer:word; {polomer telesa [px]}
                  PolomerDrahy:word; {polomer obezne drahy [px]}
                  VychoziUhel, {kde se teleso nachazi v den 0, [rad], 0 = napravo od Slunce, + je po smeru hodin}
                  DobaObehu:real; {za kolik let obehne kolem dokola}
                  KolemCehoObiha:word; {index telesa, kolem ktereho tohle obiha, 0 = kolem niceho}
                end;


Const
{Sun} MaxRGB=63; {Nejvetsi mozna hodnota slozky barvy palety. Pri vychozim
                  nastaveni VGA je to 63, po prepnuti karty do 8bitoveho
                  rezimu muze byt 255.}

      prvni=224;  {prvni vyhrazena barva}
      sirka=16;   {sirka prouzku v palete}

      IndexKonce =80*25-1; {xxx index posledniho znaku linearni stranky}
      IndexKonce2=80*5 -1;  {xxx index posledniho znaku linearni stranky}
      IndexKonce3=40*20-1; {xxx index posledniho znaku linearni stranky}

{Planetarium}
      PocetTeles=10; {kolik teles mame v tabulce (lze zmenit, kdyz pak prislusne upravis i tabulku Telesa)}

      km=0.001; {konstanta pro prepocet skutecnych kilometru na pixely na monitoru}

      {definice vsech kosmickych teles:}
      Telesa:array[1..PocetTeles] of teleso =
             (
             (Jmeno:'Slunce'; {1}
              Barva:245;          Polomer:30{round(695700*km)}; PolomerDrahy:0;
              VychoziUhel:0;     DobaObehu:0;         KolemCehoObiha:0),
             (Jmeno:'Merkur'; {2}
              Barva:246;           Polomer:round(2440*km);   PolomerDrahy:35;
              VychoziUhel:100*pi/180;     DobaObehu:0.240846;  KolemCehoObiha:1),
             (Jmeno:'Venuse'; {3}
              Barva:247;          Polomer:round(6052*km);   PolomerDrahy:50;
              VychoziUhel:25*pi/180;     DobaObehu:0.615198;  KolemCehoObiha:1),
             (Jmeno:'Zeme'; {4}
              Barva:248;           Polomer:round(6371*km);   PolomerDrahy:70;
              VychoziUhel:-50*pi/180;     DobaObehu:1.00001742096;  KolemCehoObiha:1),
             (Jmeno:'Mars'; {5}
              Barva:249;           Polomer:round(3390*km);   PolomerDrahy:90;
              VychoziUhel:20*pi/180;     DobaObehu:1.8808;    KolemCehoObiha:1),
             (Jmeno:'Jupiter'; {6}     {obri od Jupitera dal jsou moc velci, proto delim polomer tremi}
              Barva:250;          Polomer:round(69911*km/3);  PolomerDrahy:123;
              VychoziUhel:175*pi/180;     DobaObehu:11.8618;   KolemCehoObiha:1),
             (Jmeno:'Saturn'; {7}
              Barva:251;          Polomer:round(58232*km/3);  PolomerDrahy:170;
              VychoziUhel:100*pi/180;     DobaObehu:29.4571;   KolemCehoObiha:1),
             (Jmeno:'Uran'; {8}
              Barva:252;           Polomer:round(25362*km/3);  PolomerDrahy:200;
              VychoziUhel:-25*pi/180;     DobaObehu:84.0205;   KolemCehoObiha:1),
             (Jmeno:'Neptun'; {9}
              Barva:253;           Polomer:round(24622*km/3);  PolomerDrahy:220;
              VychoziUhel:20*pi/180;     DobaObehu:164.8;     KolemCehoObiha:1),
             (Jmeno:'Mesic'; {10}
              Barva:254;          Polomer:round(1737*km);   PolomerDrahy:10;
              VychoziUhel:40*pi/180;     DobaObehu:27.321661/365.25; KolemCehoObiha:4)
             );

             SpolecnyUhel=pi/4; {hodnotu si zvol podle toho, kde ten uhel chces mit}

Var
{Exit}       KonecProgramu: Boolean;
{Planety}    Planeta: Byte;
{Font}       FFont: _font;

{Sun}        pal:rgbpal256;
             mircosoftSmer: Byte;

{Generator}  GeneratorSwitch: array[0..14] of Byte;
             LenghtF: array[0..9] of LongInt;
             ZvukRaw: array[0..120] of PSound;

{Network}    ServerPripojen: Boolean;
             IPXTransmit: Transmit;
             recNode_Backup: nodeaddr;
             AdresaServeru: string[30];
             AdresaZadana: Boolean;
             {9 = ping}
             PingBajt,PingBajt1,PingBajt2: Byte;
             {seznam klientu}
             recNode_klient: array[0..2] of nodeaddr;
             CisloKlienta: Byte;
             PocetKlientu: Byte;

{Kniha}      stranka:array[0..25,0..79] of char; {xxx 2D pole je pro vetsinu ukonu pohodlnejsi na obsluhu}
             LinearniStranka:array[0..IndexKonce] of char absolute stranka; {xxx nekdy se ale puvodni linearni pristup hodi}

             stranka2:array[0..5,0..79] of char; {xxx 2D pole je pro vetsinu ukonu pohodlnejsi na obsluhu}
             LinearniStranka2:array[0..IndexKonce2] of char absolute stranka2; {xxx nekdy se ale puvodni linearni pristup hodi}

             stranka3:array[0..20,0..39] of char; {xxx 2D pole je pro vetsinu ukonu pohodlnejsi na obsluhu}
             LinearniStranka3:array[0..IndexKonce3] of char absolute stranka3; {xxx nekdy se ale puvodni linearni pristup hodi}

             znak: char;
             znakW: Word;
             KurzX,KurzY: Byte;
             InsertMode: Boolean;
             Cteni,Psani: Boolean;
             SouborKnih: Word;
             strankovaniloadu: Word;

{Tarot}      PocetKaret:Byte;
             CestaCard1: String;
             CestaCard2: String;
             CestaCard3: String;

{Planetarium}
             datum:real;
             fn:_font;
             tocit_planetami: Boolean;
             TextD: String[8];
             TextCode: Integer;
             TextDny: Word;
             TextDnyVMesici: Word;
             TextMesice: Word;
             TextRoky: Word;

{MainMenu}   MainMenu: Byte;
             MainMenuSel: Word;
             MainMenuMax: Word;
             MainMenuSelSave: Word;
             MainMenuSelSave2: Word;
             MainMenuSelSave3: Word;

{Save}       F: File;
             Fi: Text;
             FileName: String;
             DirInfo: SearchRec;
             FileExist: Boolean;
             Save: TSave;
             KnihovnaInfo: TKnihovnaInfo;

Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.