{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Program VGA_Demo;
Uses
 CRT, DOS, VGA_lib,

{LiteX}
x01_glob, x02_ram,  x03_dos,  x04_vga,  x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,  x16_misc,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin

 PowerOn;
 VGA_Init;

  Init;
  Main;
  Ending;

 VGA_Done;
 PowerOff;

End.