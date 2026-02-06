{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x05_svga;
 {SVGA}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{05-SVGA}    Procedure SVGA_WaitRetrace;
             Procedure SVGA_ClearPage(barva:word);
             Procedure SVGA_FlipPage;
             Procedure SVGA_Pixel(x,y:word; barva:byte);
             Procedure SVGA_Rectangle(x1,y1,x2,y2:word; barva:byte);
             Procedure SVGA_Bar(x,y,barva:word);
             Procedure SVGA_Spr(x,y,x1,y1,Transp,BufferFrom:Word);
             Procedure SVGA_BarZ(x1,y1,x2,y2:word; barva:word);
             Procedure SVGA_SprZ(x,y,x1,y1,x2,y2,Transp,BufferFrom:Word);
             Procedure SVGA_TogglePaging;
             procedure SVGA_ResetPages;
             Procedure SVGA_Init;
             Procedure SVGA_Done;
             procedure SVGA_HLine(x1,x2,y:word; barva:word);
             procedure SVGA_VLine(x,y1,y2:word; barva:byte);
             procedure SVGA_Line(x1,y1,x2,y2:word; barva:byte);

             procedure _SwitchBank(bank:word);
             function  _GetBank:word;
             procedure _SwitchRBank(bank:word);
             function  _GetRBank:word;
             procedure _SetDisplayOrigin(x,y:word);
             procedure _SetActivePage(kterou:byte);
             procedure _SetVisiblePage(kterou:byte);
             function  _GetPixel(x,y:word):byte;
{ShowBMP}    procedure _PutLine(x,y,delka:word; zdroj:pointer);


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{05-SVGA}    {$I ..\SOURCES\Litex\STORE\05-SVGA\chcipni.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\nswbank.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\swbank.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\getbank.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\swrbank.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\getrbank.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\sdorig.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\actpage.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\vispage.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\togpage.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\respage.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\flip.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\pixel.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\getpix.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\hline.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\vline.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\line.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\rectang.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\barz.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\bar.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\clearpg.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\putline.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\sprz.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\spr.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\waitr.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\init.pas}
             {$I ..\SOURCES\Litex\STORE\05-SVGA\done.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
