{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit a10_ProW;

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram,  x03_dos,  x04_vga,  x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,  x16_misc,

{World}
a01_Vari, a02_Init, a03_ScrA, a04_ScrB, a05_ScrC, a06_ScrD, a07_Edt1, a08_Edt2,
a09_ProS,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


   Procedure Hit100A;
   Procedure Hit100B;
   Procedure Hit100C;
   Procedure Hit100D;
   Procedure Hit50;
   Procedure Hit25A;
   Procedure Hit25B;
   Procedure ALL15Min;


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

  {$I ..\SOURCES\WORLD\STORE\A10_PROW\1hit100A.pas}
  {$I ..\SOURCES\WORLD\STORE\A10_PROW\2hit100B.pas}
  {$I ..\SOURCES\WORLD\STORE\A10_PROW\3hit100C.pas}
  {$I ..\SOURCES\WORLD\STORE\A10_PROW\4hit100D.pas}
  {$I ..\SOURCES\WORLD\STORE\A10_PROW\5hit50.pas}
  {$I ..\SOURCES\WORLD\STORE\A10_PROW\6hit25A.pas}
  {$I ..\SOURCES\WORLD\STORE\A10_PROW\7hit25B.pas}
  {$I ..\SOURCES\WORLD\STORE\A10_PROW\8ALL15M.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.