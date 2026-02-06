Program Ruleta;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses Lite;

Type
  TSazPole = Record
               Color: Byte;
               Vsazeno: Boolean;
             End;

  TButton4 = Record
               Blinking: Boolean;
               Phase: Byte;
               Counter: Byte;
               Pressed: Boolean;
             End;

  TKulickaXY = Record
                 X: Word;
                 Y: Word;
               End;

Const
  MaxSazek=157;

Var
  Hotovost4: LongInt;
  TypSazky: Word;
  KulickaXY: array[0..37] of TKulickaXY;
  SazPole: array[0..61] of TSazPole;
  Button4: array[0..7] of TButton4;
  Xzetonu,Yzetonu: Word;
  RuletaStoji: Boolean;
  UhelRulety: Word;
  CisloRulety: Word;
  FundDiag4: Boolean;
  FundSelect4: Byte;
  Kurz: Byte;
  Sazka4: Word;
  BetBT4: Byte;
  Credit4: LongInt;
  Score4: LongInt;
  Ending4: Boolean;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

{$I C:\SOURCES\PROJECTS\GAMES\RULETA\clsazka.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\checkc.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\default4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\segment.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\rulet4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\rullmain.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\zeton.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\screen4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\testwin4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\loadsnd4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\loadgfx4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\setbet4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\vybrat4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\vybrat4p.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\setsazka.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\procest4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\imput4.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\preparer.pas}
{$I C:\SOURCES\PROJECTS\GAMES\RULETA\automat4.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  InitBuffers;
  Init320x200;
  InitKeyboard;
  InitTimer;

  If DetekujXMS=0 then
  Begin
    Hotovost4:=8850;
    Automat4;
  End;

  ShutdownTimer;
  ShutdownKeyboard;
  Init80x25;
  ShutdownBuffers;
  Silence;
End.