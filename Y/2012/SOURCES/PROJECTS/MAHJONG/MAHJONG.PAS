Program Mahjong;
Uses DOS,Lite;
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

Const
  ColorTexter = 255;
  ColorGreen  = 254;
  ColorBlack  = 253;
  ColorKamen  = 252;

Var
  MainVolba: Byte;
  DirInfo: SearchRec;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

{$I C:\SOURCES\PROJECTS\GAMES\MAHJONG\default.pas}
{$I C:\SOURCES\PROJECTS\GAMES\MAHJONG\loading.pas}
{$I C:\SOURCES\PROJECTS\GAMES\MAHJONG\newgame.pas}
{$I C:\SOURCES\PROJECTS\GAMES\MAHJONG\database.pas}
{$I C:\SOURCES\PROJECTS\GAMES\MAHJONG\main.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  InitBuffers;
  Init320x200;
  InitKeyboard;
  InitTimer;
  InitTexter(ColorTexter);

  Default;
  Loading;
  Main;

  ShutdownTexter;
  ShutdownTimer;
  ShutdownKeyboard;
  Init80x25;
  ShutdownBuffers;
End.