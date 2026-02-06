Program Forbes1;
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses Lite;
Type
  TButton = Record
              Open: Boolean;
              Pressed: Boolean;
              Blink1: Boolean;
              Blink2: Boolean;
              Phase: Byte;
              Counter: Word;
            End;

  TValec = Record
             Rotate: Boolean;
             Scroll: Byte;
             Symbol: array [0..4] of Byte;
             SlowMotion: Boolean;
             SlowCounter1: Word;
             SlowCounter2: Word;
             Counter: Word;
             SCounter: Word;
           End;

  TVyhra = Record
             Nasobitel: Word;
             Counter1: Word;
             Counter2: Word;
             Counter3: Word;
             Symbol: array [1..9] of Byte;
             Vyhra: array [1..5] of Boolean;
           End;

  TWinLog = Record
              Vyher: array[0..9] of LongInt;
            End;

  TKorekce = Record
               Symbol: array[1..3] of Byte;
             End;

  TRGB= Record
          R: Byte;
          G: Byte;
          B: Byte;
        End;

Var
  Hotovost1: LongInt;
  Ending: Boolean;
  Score: LongInt;
  Credit: LongInt;
  Vyhra: LongInt;
  AddFundDiag: Boolean;
  AddFundSelect: Byte;
  BlikInfo: Boolean;
  Sazka: Word;
  BetCounter: Byte;
  Button: array[0..4] of TButton;
  Valec: array[0..2] of TValec;
  PS: array[0..2] of TKorekce;
  Palette: array[16..79] of TRGB;
  AllStoped: Boolean;
  Korigovat: Boolean;
  Korigovat2: Boolean;
  WinConf: TVyhra;
  WinInfo: TWinLog;
  RollCounter: Byte;
  RollCounter2: Word;
  RollCounter3: Byte;

Const
  MaxRolls = 99;
  MaxSymbolu = 120;
  BulletTimeConst = 9;
  Symboly: array[0..120] of Byte = (
7,1,3,3,9,9,3,5,5,8,8,4,3,0,6,6,6,1,3,5,
1,3,2,1,1,1,8,3,4,4,1,7,7,7,8,1,6,2,5,4,
7,1,1,2,2,2,3,3,3,1,4,8,8,8,5,4,1,2,5,4,
6,6,1,3,3,3,2,2,1,1,6,9,9,9,1,2,5,4,2,6,
6,3,3,4,4,4,7,7,6,2,2,2,3,1,2,5,4,2,6,2,
5,4,5,5,5,2,2,1,1,1,7,0,9,8,7,6,5,4,3,2,
1); { J=2x  9=6x  8=8x  7=9x  6=12x  5=13x  4=14x  3=17x  2=19x  1=21x }


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\number.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\update1.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\update2.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\screen.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\stopblik.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\imput2.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\wsymbol.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\winwrite.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\winblink.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\score.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\testwin.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\rolwrite.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\rollproc.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\wincore2.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\wincore.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\rolsetup.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\valeccfg.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\roll.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\setbet.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\vybrat.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\funddiag.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\procest.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\imput.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\default.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\prepare.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\loadsnd.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\loadgfx.pas}
{$I C:\SOURCES\PROJECTS\GAMES\FORBES1\automat.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  InitBuffers;
  Init320x200;
  InitKeyboard;
  InitTimer;

  If DetekujXMS=0 then
  Begin
    Hotovost1:=8850;
    Automat;
  End;

  ShutdownTimer;
  ShutdownKeyboard;
  Init80x25;
  ShutdownBuffers;
  Silence;
End.
