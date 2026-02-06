{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x11_kbd1;
 {Keyboard 1}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{11-Keyb.1}  Function  Kbd_RKey: Byte;             {wait press any key}
             Procedure Kbd_RPush(Klavesa: Byte);   {wait free pressed key}
             Procedure Kbd_Init;
             Procedure Kbd_Done;


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{11-Keyb.1}  {$I ..\SOURCES\Litex\STORE\11-KEYB1\rkey.pas}
             {$I ..\SOURCES\Litex\STORE\11-KEYB1\rpush.pas}
             {$I ..\SOURCES\Litex\STORE\11-KEYB1\handler.pas}
             {$I ..\SOURCES\Litex\STORE\11-KEYB1\initkeyb.pas}
             {$I ..\SOURCES\Litex\STORE\11-KEYB1\donekeyb.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
