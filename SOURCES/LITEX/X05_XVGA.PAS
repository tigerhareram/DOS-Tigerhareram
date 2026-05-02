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

     Procedure XVGA_SprZ(x,y,x1,y1,x2,y2,Transp,BufferFrom:Word);


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{05-XVGA}


    {$I ..\SOURCES\Litex\STORE\05-XVGA\sprz.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
