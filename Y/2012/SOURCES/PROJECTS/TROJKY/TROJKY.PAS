Program Trojky;
Uses DOS,Lite;

Type
  Tfps = Record
           prodleva: Word;
         End;

  TBrick = Record
             X: Byte;
             Y: Byte;
             N: Byte;
             Mark: Boolean;
             Exp: Boolean;
           End;

  TKostka = Record
              B: array[1..3] of TBrick;
              X: Byte;
              Y: Byte;
              Fall: Boolean;
            End;

  TNext = Record
            B: array[1..3] of TBrick;
          End;

Const
  fps_limit: Byte = 20;
  ColorGreen: Byte = 255;
  ColorRed: Byte = 250;
  ColorBlack: Byte = 253;
  DestroyerTime: Byte = 49;
  DefaultHiScore: LongInt = 10000;

Var
  F: File;
  DirInfo: SearchRec;

  Konec: Boolean;
  StartHry: Boolean;
  GameOver: Boolean;

  fps: Tfps;
  Brick: array[0..150] of TBrick;
  Kostka: TKostka;
  NextKostka: TNext;
  VyskaSloupce: array[0..8] of Byte;

  KostkaCounter: Byte;
  KostkaCounterAll: LongInt;
  DestroyerTarget: Byte;
  BrickFallCounter: Byte;
  ButtonDelay: Byte;
  HoldDown: Boolean;
  Pause: Boolean;
  Score: LongInt;
  HiScore: LongInt;
  SB: Boolean;
  Level: Byte;
  LevelBackup: Byte;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\misc.pas}
{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\scorfile.pas}

{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\screenpl.pas}
{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\reaction.pas}
{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\maingame.pas}

{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\loadgfx.pas}
{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\loadsnds.pas}
{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\default.pas}
{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\setup.pas}
{$I C:\SOURCES\PROJECTS\GAMES\TROJKY\main.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  InitBuffers;
  Init320x200;
  InitKeyboard;
  InitSB;
  InitTimer;
  InitRawBuffers;

  Default;
  LoadDefaultFont(270,180,ColorGreen,Buffer[1]);
  WriteText(Buffer[1],270,180,5,5,1,20,5,'loading',Buffer[4]);
  Start_LoadSymbol(65,5,ColorBlack,ColorGreen);
  LoadGFX;
  LoadSounds;
  Stop_LoadSymbol;
  Main;
  Silence;

  ShutdownRawBuffers;
  ShutdownTimer;
  ShutdownSB;
  ShutdownKeyboard;
  Init80x25;
  ShutdownBuffers;
End.