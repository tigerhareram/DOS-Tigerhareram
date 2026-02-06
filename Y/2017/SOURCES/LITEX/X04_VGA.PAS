{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x04_vga;
 {VGA}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{04-VGA}     Procedure VGA_WaitRetrace;
             Procedure VGA_ClearPage(Barva,Buffer:Word);
             Procedure VGA_FlipPage(BufferFrom,BufferTo:Word);
             Procedure VGA_Pixel(X,Y,Barva,BufferTo:Word);
             Procedure VGA_Rectangle(X1,Y1,X2,Y2,Barva,BufferTo:Word);
             Procedure VGA_Bar(X,Y,Barva,BufferTo:Word);
             Procedure VGA_Spr(X,Y,X1,Y1,Transp,BufferFrom,BufferTo:Word);
             Procedure VGA_BarZ(x1,y1,x2,y2,Barva,BufferTo:Word);
             Procedure VGA_SprZ(x,y,x1,y1,x2,y2,Transp,BufferFrom,BufferTo:Word);
             Procedure VGA_Init;
             Procedure VGA_Done;


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{04-VGA}     {$I ..\SOURCES\Litex\STORE\04-VGA\waitr.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\clearpg.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\flip.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\pixel.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\rectang.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\bar.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\spr.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\barz.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\sprz.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\initvga.pas}
             {$I ..\SOURCES\Litex\STORE\04-VGA\donevga.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
