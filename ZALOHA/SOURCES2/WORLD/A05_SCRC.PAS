{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X-,F+}

Unit a05_ScrC;

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram,  x03_dos,  x04_vga,  x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,  x16_misc,

{World}
a01_Vari, a02_Init, a03_ScrA, a04_ScrB,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

  procedure PripravPaletu(var p:rgbpal256; {pole, do ktereho se barvy ulozi (vystup)}
                          PrvniBarva, {index prvni barvy, ktera se pro animaci v palete vyhradi}
                          SirkaProuzku:byte); {pocet vyhrazenych barev v palete
                                               a zaroven sirka viditelnych prouzku na obrazovce}
  procedure RotujPaletuDoleva(var p:rgbpal256; PrvniBarva,SirkaProuzku:byte);
  procedure RotujPaletuDoprava(var p:rgbpal256; PrvniBarva,SirkaProuzku:byte);
  procedure VykresliObrazec(xStredu,yStredu, {kde na obrazovce ma byt stred obrazce}
                            Sirka,Vyska, {celkove rozmery obrazce}
                            PocetPaprsku:integer; {pri hodnotach nad cca 100 se pixely kolem stredu slevaji
                                                   a vznikaji zajimave interferencni vzory, }
                            PrvniBarva,SirkaProuzku:byte);{stejne hodnoty jako pri priprave palety}
  procedure NastavCelouPaletu(var pal:rgbpal256); {by Asp / VR group}


  Procedure TripSeq(CasMinut: Byte);                      {Generator}

  Procedure LobbyScreen;                                  {Network}

  Procedure ServerScreen;                                 {Server App Screen}


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

   {$I ..\SOURCES\WORLD\STORE\A05_SCRC\sun.pas}
   {$I ..\SOURCES\WORLD\STORE\A05_SCRC\tripseq.pas}
   {$I ..\SOURCES\WORLD\STORE\A05_SCRC\lobbyscr.pas}
   {$I ..\SOURCES\WORLD\STORE\A05_SCRC\servscr.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
