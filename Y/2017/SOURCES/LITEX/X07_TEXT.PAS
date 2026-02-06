{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x07_text;
 {Texty}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga, x06_3dfx,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{07-Texts}   Procedure Text_OutText(X,Y:Word;retezec:string;BufferTo:Word;Mode:TMode); { constant CZ font A }
             Procedure Text_OutNumber(X,Y:Word;Cislo:Longint;Small:Boolean;BufferTo:Word;Mode:TMode);
             Procedure Text_WriteText(FontBuffer,FontX,FontY,FontDelka,FontVyska,      { constant CZ font B }
                            mezera,x,y:Word;retezec:string;BufferTo:Word;Mode:TMode);
             Procedure Text_WriteNumber(FontBuffer,FontX,FontY,FontDelka,FontVyska,
                            mezera,x,y:Word;Cislo:Longint;BufferTo:Word;Mode:TMode);
             Procedure Text_WriteDefaultFont(x1,y1,Color,ColorBack,BufferTo: Word;Mode:TMode); { 5x5 pixel default }
             Procedure Text_Init(Barva:Byte);
             Procedure Text_Done;

             procedure _NactiFont(var FN:_font; JmenoSouboru:string);
             procedure _ZrusFont(var fn:_font);
             procedure _NastavText(velikostX,velikostY,roztec:byte);
             procedure _NastavFont(var fn:_font; NastavDoporucene:boolean);
             procedure _print(ix,iy:integer; barva:byte; textik:string);
             function  _SirkaTextu(PocetZnaku:byte):word;
             function  _VyskaTextu:word;


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{07-Texts}   {$I ..\SOURCES\Litex\STORE\07-TEXT\dec2bin.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\bin2dec.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\wrloadd.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\wrznak1.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\wrznak2.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\wrtext.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\wrnumb.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outcif1.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outcif1s.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outcif2.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outcif2s.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outspr1.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outspr2.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outzn1.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outzn2.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outtext.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\outnumb.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\inittext.pas}
             {$I ..\SOURCES\Litex\STORE\07-TEXT\donetext.pas}

             {$I ..\SOURCES\Litex\STORE\07-TEXT\print.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
