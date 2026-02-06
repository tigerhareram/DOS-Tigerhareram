{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x08_maps;
 {Mapy}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga, x06_3dfx, x07_text,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{08-Maps}    Procedure Map_Sqr(Xr,Yr,Number:Word;Mode:TMode);
             Function  Map_GetSqr(Xr,Yr: Word): Word;
             Procedure Map_WriteVGASegment(X,Y,X1,Y1,X2,Y2,BufferTo:Word;Rect1,Rect2:Byte);
             Procedure Map_WriteSVGASegment(X,Y,X1,Y1,X2,Y2:Word;Rect1,Rect2:Byte);
             Procedure Map_WriteSVGAComplet(BufferFrom:Word);


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{08-Maps}    {$I ..\SOURCES\Litex\STORE\08-MAPS\mapgetb.pas}
             {$I ..\SOURCES\Litex\STORE\08-MAPS\mapsqr0.pas}
             {$I ..\SOURCES\Litex\STORE\08-MAPS\mapsqr1.pas}
             {$I ..\SOURCES\Litex\STORE\08-MAPS\mapsqr2.pas}
             {$I ..\SOURCES\Litex\STORE\08-MAPS\mapsegm1.pas}
             {$I ..\SOURCES\Litex\STORE\08-MAPS\mapsegm2.pas}
             {$I ..\SOURCES\Litex\STORE\08-MAPS\mapsegm3.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
