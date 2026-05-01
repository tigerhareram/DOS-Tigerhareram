{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X-,F+}

Unit a01_Vari; {global variables}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{Lite}
x01_glob, x02_ram,  x03_dos,  x04_vga,  x05_svga, x05_xvga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,  x16_misc,

{World}

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


Const
  ColX: array[0..15] of Byte =(240,241,242,243,244,245,246,247,
                               248,249,250,251,252,253,254,255);

  IndexKonce =80*25-1; {xxx index posledniho znaku linearni stranky}

Var
{Font}       FFont: _font;

{Kniha}      stranka:array[0..25,0..79] of char; {xxx 2D pole je pro vetsinu ukonu pohodlnejsi na obsluhu}
             LinearniStranka:array[0..IndexKonce] of char absolute stranka; {xxx nekdy se ale puvodni linearni pristup hodi}

             StranaCis: LongInt;
             StranaMin: LongInt;
             StranaMax: LongInt;
             ObrPosX,ObrPosY,X1,Y1,X2,Y2: Word;

             Scan_Toggle: Boolean;
             ScanX,ScanY,ScanSizeX1,ScanSizeY1,ScanSizeX2,ScanSizeY2: Word;

             VisiblePage: Word;
             VisibleBMP: Word;

             X1map,Y1map,X2map,Y2map:Word;
             Rect1map,Rect2map:Byte;

Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.