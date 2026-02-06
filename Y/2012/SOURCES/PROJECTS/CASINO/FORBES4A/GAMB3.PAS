Unit Gamb3;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Interface
Uses DOS,Lite,Gamb1,Gamb2;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

{winblink}
Procedure Blinking;
Procedure KresliBlikani(S1,S2,S3,S4,S5,S6,S7,S8,S9:Byte;BufferTo:Word);
Procedure WinBlink;


{testwin}
Procedure SetWildJoker;
Procedure JokerSetup;
Procedure WaitJokerPlus;
Procedure IncVyhra(I,N: Byte);
Procedure TestWin;


{rollproc}
Procedure SetupSymboly(I: Byte);
Procedure RollProc;


{rollpre}
Procedure RollPre;


{rolsetup}
Procedure VyhraStorno;
Procedure RollSetup;


{rskhorni}
Procedure RiskDohra;
Procedure RiskHorni;
Procedure RiskHorniNahodny;


{rskdolni}
Procedure RiskDolni;
Procedure RiskDolniNahodny;


{automark}
Procedure AutoMark;


{roll}
Procedure HorseSound;
Procedure RiskniXkrat(horni: Boolean;start: Byte);
Procedure Roll;


{plusbank}
Procedure PlusBankovka(Cislo: Byte);


{maingame}
Procedure StopBlinkingButtons;
Procedure MakeButtons;
Procedure MakeThrill;
Procedure MainGame;


{prodat}
Procedure Prodat;


{ovladani}
Procedure OvladaniScreen;
Procedure Ovladani;


{setup1}
Procedure ServisScreen;
Procedure Servis;


{main}
Procedure MainScreen;
Procedure Main;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Implementation

{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\winblink.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\testwin.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\rollproc.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\rollpre.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\rolsetup.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\rskhorni.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\rskdolni.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\automark.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\roll.pas}

{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\plusbank.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\maingame.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\prodat.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\ovladani.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\setup1.pas}
{$I C:\SOURCES\PROJECTS\CASINO\FORBES4A\main.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
