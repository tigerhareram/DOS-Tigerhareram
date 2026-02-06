{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x03_dos;
 {Nahrada DOSu a CRT}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{03-DOS}     Procedure GetIntVec(Prerus : byte; var Rutina:pointer);
             Procedure SetIntVec(Prerus : byte; Rutina : pointer);
             Procedure FindFirst(Cesta : string; Atribut : word; var InfoSoub : SearchRec);
             Procedure FindNext(var InfoSoub : SearchRec);


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{03-DOS}     {$I ..\SOURCES\Litex\STORE\03-DOS\ascii.pas}
             {$I ..\SOURCES\Litex\STORE\03-DOS\asciiz.pas}
             {$I ..\SOURCES\Litex\STORE\03-DOS\findf.pas}
             {$I ..\SOURCES\Litex\STORE\03-DOS\findn.pas}
             {$I ..\SOURCES\Litex\STORE\03-DOS\getenva.pas}
             {$I ..\SOURCES\Litex\STORE\03-DOS\intvecg.pas}
             {$I ..\SOURCES\Litex\STORE\03-DOS\intvecs.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
