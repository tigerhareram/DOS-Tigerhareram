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

{Save} TSave = Record
                 Hodnota: Byte;
               End;

{Save} TKnihovnaInfo = Record
                         JmenaSesitu: array[0..9] of String[50];
                         JmenaBloku:  array[0..4] of String[50];
                         JmenaKnih:   array[0..4] of String[50];
                       End;


Const
  ColX: array[0..15] of Byte =(240,241,242,243,244,245,246,247,
                               248,249,250,251,252,253,254,255);

  IndexKonce =80*25-1; {xxx index posledniho znaku linearni stranky}
  IndexKonce2=80*5 -1;  {xxx index posledniho znaku linearni stranky}
  IndexKonce3=40*20-1; {xxx index posledniho znaku linearni stranky}

  {here is scan object position and size declared 0..639 x 0..399}
  {change numbers}
  ScanX=150;       {0..639} {position on text page X,Y}
  ScanY=250;       {0..399}
  ScanSizeX1=160;  {0..159} {size of image x1..x2 x y1..y2 from Buffer[2]}
  ScanSizeY1=0;    {0..199} {load image scan.bmp from folder SCAN}
  ScanSizeX2=239;  {160..319} {toggle with Enter key on Convert page}
  ScanSizeY2=49;   {0..199} {all manipulations and changes manualy}

Var
{Main Menu}  MainMenu: Byte;
             MainMenuSel: Word;
             MainMenuMax: Word;
             MainMenuSelSave: Byte;
             MainMenuSelSave2: Word;
             MainMenuSelSave3: Word;

{Font}       FFont: _font;

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

             Scan_Toggle: Boolean;

{Save}       F: File;
             Fi: Text;
             FileName: String;
             DirInfo: SearchRec;
             FileExist: Boolean;
             Save: TSave;
             KnihovnaInfo: TKnihovnaInfo;

{Zvuky}      ZvukRaw: array[0..120] of PSound;
             LenghtF: array[0..9] of LongInt;
             Hraje: array[0..7] of Boolean;


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.