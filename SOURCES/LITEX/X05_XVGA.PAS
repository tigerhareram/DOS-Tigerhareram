{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x05_xvga; {Stefan GrafX egavga.bgi compatible fast gfx library}
 {XVGA user rutines}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga,

{GrafX}
adler32, crc32, gr_vars, gr_8bit, gr_hicol, grafx, fadelib,
inflate, mousedr7, pngunit,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{05-XSVGA}

     Procedure XVGA_WaitRetrace; {duplicit VGA,SVGA,XVGA WaitRetrace}

     Procedure XVGA_Pixel(x,y:integer; barva:byte);
     Procedure XVGA_Rectangle(x1,y1,x2,y2:Integer; barva:byte);

     Procedure XVGA_BarZ(x1,y1,x2,y2:Integer; Barva:Byte);
     Procedure XVGA_SprZ(x,y,x1,y1,x2,y2,Transp,BufferFrom:Word);

     Procedure XVGA_Bar(x,y,barva:word);
     Procedure XVGA_Spr(x,y,x1,y1,Transp,BufferFrom:Word);

     Procedure XVGA_ClearPage(barva:word); {SLOW}
     Procedure XVGA_SetActivePage(page: word);
     Procedure XVGA_SetVisualPage(page: word);
     Procedure XVGA_FlipPage(Source,Destination: Word); {4 pages}

     Procedure XVGA_ClearViewport;
{    Procedure XVGA_SetViewport(x1,y1,x2,y2 : integer;clip : boolean); } {ERROR NEVIM}

     Procedure XVGA_Init;
     Procedure XVGA_Done;

Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{05-XVGA}

    {$I ..\SOURCES\Litex\STORE\05-XVGA\waitr.pas}
    {$I ..\SOURCES\Litex\STORE\05-XVGA\pixel.pas}
    {$I ..\SOURCES\Litex\STORE\05-XVGA\rectang.pas}

    {$I ..\SOURCES\Litex\STORE\05-XVGA\barz.pas}
    {$I ..\SOURCES\Litex\STORE\05-XVGA\sprz.pas}

    {$I ..\SOURCES\Litex\STORE\05-XVGA\bar.pas}
    {$I ..\SOURCES\Litex\STORE\05-XVGA\spr.pas}

    {$I ..\SOURCES\Litex\STORE\05-XVGA\clearpg.pas}
    {$I ..\SOURCES\Litex\STORE\05-XVGA\setapage.pas}
    {$I ..\SOURCES\Litex\STORE\05-XVGA\setvpage.pas}
    {$I ..\SOURCES\Litex\STORE\05-XVGA\flip.pas}


    {$I ..\SOURCES\Litex\STORE\05-XVGA\viewprt1.pas}
{   {$I ..\SOURCES\Litex\STORE\05-XVGA\viewprt2.pas }

    {$I ..\SOURCES\Litex\STORE\05-XVGA\init.pas}
    {$I ..\SOURCES\Litex\STORE\05-XVGA\done.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
