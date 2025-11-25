{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}
Unit VGA_lib;

Interface

Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram,  x03_dos,  x04_vga,  x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math, x15_ipx,  x16_misc,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


Var
{Font}
 FFont: _font;

{Colors}
 Col: array[0..15] of Byte;

{Main Menu}
 cursorX,cursorY: Word;
 selection: Byte;

{Map}
 X1,Y1,X2,Y2 : Word;

{fps}
 fps: Integer;
 fps_counter: Integer;
 frame_counter: Word;

 Procedure Init;
 Procedure Screen;
 Procedure MainGame;
 Procedure Setup;
 Procedure MainScreen;
 Procedure Main;
 Procedure Ending;

Implementation

 {$I ..\SOURCES\VGA_DEMO\init.pas}
 {$I ..\SOURCES\VGA_DEMO\screen.pas}
 {$I ..\SOURCES\VGA_DEMO\maingame.pas}
 {$I ..\SOURCES\VGA_DEMO\setup.pas}
 {$I ..\SOURCES\VGA_DEMO\mainscr.pas}
 {$I ..\SOURCES\VGA_DEMO\main.pas}
 {$I ..\SOURCES\VGA_DEMO\ending.pas}

Begin End.