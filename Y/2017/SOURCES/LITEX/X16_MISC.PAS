{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x16_misc;
 {Data formats}


Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{16-Misc}    Procedure LoadGRAFile(Filename:String; Pozice:LongInt;PageNumber:Byte);
             Procedure LoadMAPFile(filename:String; Pozice:Longint);
             Procedure LoadSNDFile(filename:String; Pozice:Longint);
             Procedure LoadBMPFile(filename:String; Pozice:LongInt; X,Y:Word; StartColor:Byte; BufferTo:Word);
             Procedure ShowBMP640(filename:String; Pozice:LongInt; X,Y:Word; StartColor:Byte);
             Procedure LoadRAWFile(filename:String; Pozice:LongInt; N:Byte); {N=XMS Storage [0..19]}
             Procedure SaveGRAFile(filename:String);
             Procedure SaveMAPFile(filename:String);
             Procedure SaveSNDFile(filename:String);
             Procedure SaveBMPFile(filename:String; StartColor:Byte);
             Procedure PowerOn;  { Init All Engine Sections }
             Procedure PowerOff; { Done All Engine Sections }


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{16-Misc}    {$I ..\SOURCES\Litex\STORE\16-MISC\loadgra.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\loadmap.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\loadsnd.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\loadbmp.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\sbmp640.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\loadraw.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\savegra.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\savemap.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\savesnd.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\savebmp.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\poweron.pas}
             {$I ..\SOURCES\Litex\STORE\16-MISC\poweroff.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
