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
  TLenght: Record
             BMP = LongInt;
             MAP = LongInt;
             TXT = LongInt;
             GRAA = LongInt;
             GRAB = LongInt;
             GRAC = LongInt;
             GRAD = LongInt;
           End;


Const
  ColX: array[0..15] of Byte =(240,241,242,243,244,245,246,247,
                               248,249,250,251,252,253,254,255);

  IndexKonce =80*25-1; {xxx index posledniho znaku linearni stranky}

  {sizes of dat files , example -> LL[12].BMP , LL[9].TXT}
  LL : array[1..20] of TLenght = (
  (BMP: 16186; MAP: 705; TXT: 2000; GRAA: 453; GRAB: 370; GRAC: 367; GRAD: 367), {index  1}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index  2}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index  3}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index  4}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index  5}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index  6}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index  7}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index  8}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index  9}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 10}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 11}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 12}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 13}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 14}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 15}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 16}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 17}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 18}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 19}
  (BMP: 0; MAP: 0; TXT: 0; GRAA: 0; GRAB: 0; GRAC: 0; GRAD: 0), {index 20}
  );

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

Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.