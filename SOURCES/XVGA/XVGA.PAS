{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Program XVGA;
Uses
 CRT, DOS, XVGA_lib,

{LiteX}
x01_glob, x02_ram,  x03_dos,  x04_vga,  x05_svga, x05_xvga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,  x16_misc,

{GrafX}
adler32, crc32, gr_vars, gr_8bit, gr_hicol, grafx, fadelib,
inflate, mousedr7, pngunit,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
                           {Stefan GrafX}        {Mircosoft}  {JIVA}
 PowerOn; {LiteX PowerOn -< setmode(640,480,8) -< SVGA_Init -< VGA_Init }

  Init;
  Main;
  Ending;
                             {Stefan GrafX} {Mircosoft}  {JIVA}
 PowerOff; {LiteX PowerOff -< closegraph; -< SVGA_Done -< VGA_Done }

End.