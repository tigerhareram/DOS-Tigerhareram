{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Program IRENA;
Uses
 CRT, DOS,

{LiteX}
x01_glob, x02_ram,  x03_dos,  x04_vga,  x05_svga, x05_xvga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,  x16_misc,

{GrafX}
adler32, crc32, gr_vars, gr_8bit, gr_hicol, grafx, fadelib,
inflate, mousedr7, pngunit,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

Const
  IndexKonce =80*25-1; {xxx index posledniho znaku linearni stranky}

Var
{Kniha}
 stranka:array[0..25,0..79] of char; {xxx 2D pole je pro vetsinu ukonu pohodlnejsi na obsluhu}
 LinearniStranka:array[0..IndexKonce] of char absolute stranka; {xxx nekdy se ale puvodni linearni pristup hodi}

{fps}
 fps: Integer;
 frame_counter: Word;

 Xsour,Ysour : Byte;
 Cesta: String;

 Fi: Text;      {Text Files}
 XFi,YFi: Byte; {Text Files}



 {$I ..\SOURCES\IRENA\init.pas}
 {$I ..\SOURCES\IRENA\enterf.pas}
 {$I ..\SOURCES\IRENA\screen.pas}
 {$I ..\SOURCES\IRENA\main.pas}
 {$I ..\SOURCES\IRENA\ending.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
                           {Stefan GrafX}        {Mircosoft}  {JIVA}
 PowerOn;
 XVGA_Init;

  Init;
  Main;
  Ending;

 XVGA_Done;
 PowerOff;
End.