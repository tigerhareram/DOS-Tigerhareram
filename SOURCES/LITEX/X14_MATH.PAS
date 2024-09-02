{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x14_Math;
 {Math}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{14-Math}    Function  Math_Inside(x,y,x1,y1,x2,y2: LongInt): Boolean;
             Function  Math_Plosina(x,y,x1,x2,plosinaY: LongInt): Boolean;
             Function  Math_GetLineX(a,b,c,d:integer;Vzdalenost:Word): Word;
             Function  Math_GetLineY(a,b,c,d:integer;Vzdalenost:Word): Word;


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{14-Math}    {$I ..\SOURCES\Litex\STORE\14-MATH\inside.pas}
             {$I ..\SOURCES\Litex\STORE\14-MATH\plosina.pas}
             {$I ..\SOURCES\Litex\STORE\14-MATH\getlinex.pas}
             {$I ..\SOURCES\Litex\STORE\14-MATH\getliney.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
