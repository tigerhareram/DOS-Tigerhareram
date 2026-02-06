Program HareCat;
Uses Lite;
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Const
  ColorPlice  = 255;
  ColorPozadi = 254;
  ColorTexter = 253;
  ColorRed    = 252;
  ColorWhite  = 251;

Var
  Nadech: Boolean;
  Vydech: Boolean;
  Breath: Word;
  Japa: Word;
  Hare: Word;
  Krishna: Word;
  Rama: Word;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{$I C:\SOURCES\STORE2\HARECAT\default.pas}
{$I C:\SOURCES\STORE2\HARECAT\loading.pas}
{$I C:\SOURCES\STORE2\HARECAT\maincat.pas}
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  Init320x200;
  InitBuffers;
  InitKeyboard;
  InitSB;
  InitTimer;
  InitRawBuffers;
  InitTexter(ColorTexter);

  Default;
  Loading;
  MainCat;

  ShutdownTexter;
  ShutdownRawBuffers;
  ShutdownTimer;
  ShutdownSB;
  ShutdownKeyboard;
  ShutdownBuffers;
  Init80x25;
End.