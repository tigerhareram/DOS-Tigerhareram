{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X-,F+}

Unit x15_ipx;
 {IPX communication}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga, x06_3dfx, x07_text, x08_maps,
x09_time, x10_sb16, x11_kbd1, x12_kbd2, x13_mous, x14_math,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{15-IPX}     Function  setRecNode(adrStr: string): boolean;
             Procedure InitIPX (var Completion:byte);
             Function  IPXgetParams: Boolean; {adresa serveru}
             Procedure GetInterNetAddr (var Net:netaddr;var Node:nodeaddr);

             Procedure InitReceive;                         {prijem - ocekavani dat}
             Procedure TestReceive(Var IPXProm:Transmit);
             Procedure DoneReceive;

             Procedure InitSend;                            {vysilani}
             Procedure TestSend(IPXProm:Transmit);
             Procedure DoneSend;


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{15-IPX}     {$I ..\SOURCES\Litex\STORE\15-IPX\ipx_init.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\getneta.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\opensock.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\closesoc.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\getlocal.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\disconn.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\setecb.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\send.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\listen.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\abort.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\receive.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\send_pac.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\setrecn.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\getparam.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\JIVA\init_rcv.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\JIVA\test_rcv.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\JIVA\done_rcv.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\JIVA\init_snd.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\JIVA\test_snd.pas}
             {$I ..\SOURCES\Litex\STORE\15-IPX\JIVA\done_snd.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
