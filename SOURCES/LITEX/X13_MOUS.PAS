{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X-,F+}

Unit x13_mous;
 {Mouse}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{13-Mouse}   Function  Mouse_Btn1: Word;
             Function  Mouse_Btn2: Word;
             Function  Mouse_Btn3: Word;
             Function  Mouse_X: Word;
             Function  Mouse_Y: Word;
             Procedure Mouse_SetXY(X,Y:Word);
             Procedure Mouse_SetXSize(X1,X2:Word);
             Procedure Mouse_SetYSize(Y1,Y2:Word);
             Procedure Mouse_Show;
             Procedure Mouse_Hide;

Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{13-Mouse}   {$I ..\SOURCES\Litex\STORE\13-MOUSE\mchbtn1.pas}
             {$I ..\SOURCES\Litex\STORE\13-MOUSE\mchbtn2.pas}
             {$I ..\SOURCES\Litex\STORE\13-MOUSE\mchbtn3.pas}
             {$I ..\SOURCES\Litex\STORE\13-MOUSE\mchxp.pas}
             {$I ..\SOURCES\Litex\STORE\13-MOUSE\mchyp.pas}
             {$I ..\SOURCES\Litex\STORE\13-MOUSE\msxypos.pas}
             {$I ..\SOURCES\Litex\STORE\13-MOUSE\msxsize.pas}
             {$I ..\SOURCES\Litex\STORE\13-MOUSE\msysize.pas}
             {$I ..\SOURCES\Litex\STORE\13-MOUSE\mshow.pas}
             {$I ..\SOURCES\Litex\STORE\13-MOUSE\mhide.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
