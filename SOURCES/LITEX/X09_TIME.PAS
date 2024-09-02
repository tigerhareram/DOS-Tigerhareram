{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x09_time;
 {Timer}

Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}
x01_glob, x02_ram, x03_dos, x04_vga, x05_svga, x06_3dfx, x07_text, x08_maps,

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;


{INTERFACE}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{09-Paleta}  Procedure P16_GetPal(Color:Byte; Var PalR,PalG,PalB:Byte);
             Procedure P16_SetPal(Color:Byte; R,G,B:Byte);
             Procedure P16_BlackOut(StartColor:Byte);           { Black Out }
             Procedure P16_FadeOut(StartColor,Tempo:Byte);       { Fade Out }
             Procedure P16_FadeIn(StartColor,Tempo:Byte);         { Fade In }
             Procedure P16_StartBlink(Color,Tempo: Byte); {start fade in/out}
             Procedure P16_StopBlink;                      {stop fade in/out}
             Procedure P16_Init(StartColor:Byte);            { Save Palette }
             Procedure P16_Done(StartColor:Byte);         { Restore Palette }

{09-Speak}   Procedure Spkr_Sound(Hertz: Word);
             Procedure Spkr_Silence;
             Procedure Spkr_PlaySound(Cislo:Byte);                {Play SND}
             Procedure Spkr_PlayRaw(Cislo:Byte;Opakovat:Boolean); {Play RAW}
             Procedure Spkr_StopRaw;
             Procedure Spkr_StartGenerator(Freq:Word);
             Procedure Spkr_StopGenerator;
             Procedure Spkr_Init;
             Procedure Spkr_Done;

{09-Timer}   Procedure Timer_Wait(ms: LongInt);             {?? milisecond delay}
             Procedure Timer_Watch_Start;                   {Watches start track time}
             Procedure Timer_Watch_Stop;                    {Watches stop track time}
             Function  Timer_Watch_GetTime: LongInt;        {Watches see result}
             Function  Timer_Second: Boolean;               {1Hz generator flipflop}
             Procedure Timer_StartInit(Limit: Word);        {loading start}
             Procedure Timer_StopInit;                      {loading stop}
             Procedure Timer_Init;
             Procedure Timer_Done;

Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{09-Paleta}  {$I ..\SOURCES\Litex\STORE\09-TIMER\PALET\p16getp.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\PALET\p16setp.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\PALET\p16black.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\PALET\p16fdout.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\PALET\p16fdin.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\PALET\stopbln.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\PALET\startbln.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\PALET\p16init.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\PALET\p16done.pas}

{09-Speak}   {$I ..\SOURCES\Litex\STORE\09-TIMER\SPEAK\sound.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\SPEAK\silence.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\SPEAK\playsnd.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\SPEAK\playraw.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\SPEAK\stopraw.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\SPEAK\stgener.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\SPEAK\stopgen.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\SPEAK\initspk.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\SPEAK\donespk.pas}

{09-Timer}   {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\wait.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\watch1.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\watch2.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\watch3.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\second.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\handler.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\initinit.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\doneinit.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\inittim.pas}
             {$I ..\SOURCES\Litex\STORE\09-TIMER\TIMER\donetim.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
