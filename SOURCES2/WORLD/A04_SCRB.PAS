{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X-,F+}

Unit a04_ScrB;

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram,  x03_dos,  x04_vga,  x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,  x16_misc,

{World}
a01_Vari, a02_Init, a03_ScrA,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


  Procedure PlanetScreen(planeta,mesic: Word);        {Soustava}

  Procedure ShowGenerBMP(I: Byte);                    {Generic BMP}
  Procedure ShowGenerBMPSeq(I: Byte);                 {Generic BMP Sequ.}

  Procedure WriteStranka;                             {STR80.PAS Kniha}
  Procedure WriteStrankaChat(Y1: Word);               {STR80.PAS Chat}
  Procedure WriteStrankaPlanet(Y1: Word);             {STR80.PAS Planety}

  Procedure Doprava;                                  {Memo writer}
  Procedure Doleva;
  Procedure SmazZnak;
  Procedure ZalomRadek;

  Procedure Doprava2;                                 {Chat lobby}
  Procedure Doleva2;
  Procedure SmazZnak2(Y1: Word);
  Procedure ZalomRadek2(Y1: Word);

  Procedure Doprava3;                                 {Soustava psani}
  Procedure Doleva3;
  Procedure SmazZnak3(Y1: Word);
  Procedure ZalomRadek3(Y1: Word);

  Procedure WriterPlanet(Y1,Soubor: Word);


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXxXXXXX}

   {$I ..\SOURCES\WORLD\STORE\A04_SCRB\str80.pas}
   {$I ..\SOURCES\WORLD\STORE\A04_SCRB\memo.pas}

   {$I ..\SOURCES\WORLD\STORE\A04_SCRB\writerpl.pas}

   {$I ..\SOURCES\WORLD\STORE\A04_SCRB\gener.pas}
   {$I ..\SOURCES\WORLD\STORE\A04_SCRB\planescr.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
