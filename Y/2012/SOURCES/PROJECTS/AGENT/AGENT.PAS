Program Agent;
Uses DOS,Lite;
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

Type
  Tfps = Record
           Show: Boolean;
           frame: Word;
           fps: Word;
           trvani: LongInt;
           trvaniTarget: LongInt;
           prodleva: Word;
         End;

 TMap = Record
          Xview: LongInt;
          Yview: LongInt;
        End;

 TPlayer = Record
             X: LongInt;
             Y: LongInt;
             SaveX: LongInt;
             SaveY: LongInt;
             Sprite: Byte;
             Smer: Byte;
             KrokCounter: Byte;
             Power1: Byte; {doprava}
             Power2: Byte; {doleva}
             InAir: Boolean;
             Power3: Byte; {pad dolu}
             Jump: Boolean;
             Power4: Byte; {skok}
             Rebrik: Boolean;
             RebrikCounter: Byte;
             Skrceny: Boolean;
             Death: Boolean;
             DeathCounter: Byte;
             Lives: Byte;
           End;

 TEnemy = Record
            Aktive: Boolean;
            Terminated: Boolean;
            Typ: Byte;
            X: LongInt;
            Y: LongInt;
            Sprite: Byte;
            Smer: Byte;
            KrokCounter: Byte;
            Death: Boolean;
            DeathCounter: Byte;
            MoveCounter: Word;
            MoveCounterMax: Word;
            ExpCounter: Byte;
          End;

 TGame = Record
           Level: Byte;
           LevelFinish: Boolean;
           AllClear: Boolean;
           Ending: Boolean;
           Score: LongInt;
         End;

 TBonus = Record
            X: LongInt;
            Y: LongInt;
            Counter: Byte;
            Hide: Boolean;
          End;

 TBox = Record
          Akce: Boolean;
          DelayCounter: Byte;
        End;

 TKop = Record
          Akce: Boolean;
          DelayCounter: Byte;
        End;

 TStrela = Record
             X: LongInt;
             Y: LongInt;
             Akce: Boolean;
             DelayCounter: Byte;
             Leti: Boolean;
             Smer: Byte;
             LetCounter: Byte;
           End;

Const
  ColorRed=255;
  ColorBlack=254;
  ColorWhite=253;

  LastLevel=2;
  DefaultHiScore = 1000;

Var
  fps: Tfps;
  Map: TMap;
  Game: TGame;
  Player: TPlayer;
  Bonus: array[0..9] of TBonus;
  CisloBonusu: Byte;
  Box: TBox;
  Kop: TKop;
  Strela: TStrela;
  Ammo: Word;
  Enemy: array[0..255] of TEnemy;
  TabulkaShow: Boolean;
  PressQCounter: Byte;
  PressWCounter: Byte;

  F: File;
  DirInfo: SearchRec;
  HiScore: LongInt;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{$I C:\SOURCES\PROJECTS\AGENT\fpstrigg.pas}
{$I C:\SOURCES\PROJECTS\AGENT\misc.pas}

{$I C:\SOURCES\PROJECTS\AGENT\saveload.pas}
{$I C:\SOURCES\PROJECTS\AGENT\loading.pas}
{$I C:\SOURCES\PROJECTS\AGENT\init.pas}

{$I C:\SOURCES\PROJECTS\AGENT\gameover.pas}
{$I C:\SOURCES\PROJECTS\AGENT\lvlstart.pas}
{$I C:\SOURCES\PROJECTS\AGENT\inilvl.pas}
{$I C:\SOURCES\PROJECTS\AGENT\gamescr.pas}
{$I C:\SOURCES\PROJECTS\AGENT\enemy.pas}
{$I C:\SOURCES\PROJECTS\AGENT\process.pas}
{$I C:\SOURCES\PROJECTS\AGENT\readkeys.pas}
{$I C:\SOURCES\PROJECTS\AGENT\maingame.pas}

{$I C:\SOURCES\PROJECTS\AGENT\startscr.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Main;
Begin
  Init320x200;
  InitBuffers;
  InitKeyboard;
  InitTimer;
  InitMapBuffers(5760);

  Initialize;
  Loading;
  StartScreen;

  ShutdownMapBuffers;
  ShutdownTimer;
  ShutdownKeyboard;
  ShutdownBuffers;
  Init80x25;
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin Main; End.