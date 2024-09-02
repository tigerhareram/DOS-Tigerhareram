{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X-,F+}

Unit x02_ram;
 {MEMORY MODEL}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{02-RAM}     Procedure RAM_MoveToXMS(Handle: Word; XMSOffset: LongInt; Var Source; BlockLength: LongInt);
             Procedure RAM_MoveFromXMS(Handle: Word; XMSOffset: LongInt; Var Dest; BlockLength: LongInt);
             Procedure RAM_Init;
             Procedure RAM_Done;


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{02-RAM}     {$I ..\SOURCES\Litex\STORE\02-RAM\xmsdet.pas}
             {$I ..\SOURCES\Litex\STORE\02-RAM\xmssize.pas}
             {$I ..\SOURCES\Litex\STORE\02-RAM\xmsget.pas}
             {$I ..\SOURCES\Litex\STORE\02-RAM\xmsfree.pas}
             {$I ..\SOURCES\Litex\STORE\02-RAM\movtoxms.pas}
             {$I ..\SOURCES\Litex\STORE\02-RAM\movfrxms.pas}
             {$I ..\SOURCES\Litex\STORE\02-RAM\bufinit.pas}
             {$I ..\SOURCES\Litex\STORE\02-RAM\bufdone.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
