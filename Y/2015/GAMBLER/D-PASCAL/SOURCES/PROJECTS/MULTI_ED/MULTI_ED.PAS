Program Multi_ED;
Uses DOS,Lite;
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Const
  priponaGRA: string = '.gra';
  priponaSND: string = '.snd';
  priponaMEL: string = '.mel';
  priponaTXT: string = '.txt';
  priponaBMP: string = '.bmp';
  ButtonSpeed: Byte = 50;

Var
  TABGrafika: Boolean;
  TABGrafikaG0: Boolean;
  TABGrafikaG1: Boolean;
  TABGrafikaG2: Boolean;
  TABGrafikaG3: Boolean;
  EndingEditG: Boolean;
  VybranaBarva: Byte;
  VybranaBarva2: Byte;

  TABZvuky: Boolean;
  TABZvukyT: Boolean;
  TABZvukyE: Boolean;
  EndingEditZ: Boolean;
  ZvukIndex: Word;
  ZvukSelect: Byte;
  ZvukSelect1: Byte;
  ZvukY: Byte;
  TABZacatky: Boolean;
  TABDelky: Boolean;
  ZvukPosunX: Word;

  TABMelodie: Boolean;
  MelSelectX0: Word;
  MelSelectX1: Word;
  MelSelectX2: Word;
  MelSelectY: Byte;
  Cis: Boolean;
  Dis: Boolean;
  Fis: Boolean;
  Gis: Boolean;
  His: Boolean;
  NastrojY: Byte;
  NastrojDrum: Byte;
  DrumNote: Byte;
  MezeraCounter: Byte;
  RepNum: array[0..7] of LongInt;
  StartNum: Word;
  ShowHelp1: Boolean;
  ShowHelp2: Boolean;

  filename: string[12];
  readname: string[8];
  readnameZbyva: Byte;
  readnamePos: Byte;
  DirInfo: SearchRec;

  ButtonDelay: Byte;
  X4B,Y4B: Byte;
  X4B1,Y4B1: Byte;
  Xe,Ye: Byte;
  Xe1,Ye1: Byte;
  Xs1,Ys1: Byte;
  Schranka: array[0..63] of Byte;
  Schranka4Barvy: array[0..3] of Byte;
  Progress: Word;

  MouseColor: Byte;
  MouseX,MouseY: Word;

  filenametext: string[12];
  FText: Text;
  KanalVolba: Byte;
  ZalohaDrumNote: Byte;
  ZalohaNastroj0: Byte;

  filenameBMP: string[12];
  ImportBarva1: Byte;
  ImportBarva2: Byte;
  ImportBarva3: Byte;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{$I F:\SOURCES\PROJECTS\MULTI_ED\sounds.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\default.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\waitkey.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\waitbtn.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\readtext.pas}

{$I F:\SOURCES\PROJECTS\MULTI_ED\GRAFIKA\bmp2gra.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\GRAFIKA\bmp.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\GRAFIKA\editg0.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\GRAFIKA\editg1.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\GRAFIKA\editg2.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\GRAFIKA\editg3.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\GRAFIKA\editg.pas}

{$I F:\SOURCES\PROJECTS\MULTI_ED\ZVUKY\play.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\ZVUKY\editz1.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\ZVUKY\editz2.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\ZVUKY\editz0.pas}

{$I F:\SOURCES\PROJECTS\MULTI_ED\MELODIE\rtttl.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\MELODIE\editchan.pas}
{$I F:\SOURCES\PROJECTS\MULTI_ED\MELODIE\editmel.pas}

{$I F:\SOURCES\PROJECTS\MULTI_ED\mainmenu.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  InitBuffers;
  Init320x200;
  InitTexter(253);
  InitKeyboard;
  InitTimer;
  InitGM;

  InitMouse;
  SetMouseRozsah(160,0,479,159);
  SetMouseXY(160,0);

  SetDefaults;
  MainMenu;

  ShutdownGM;
  ShutdownTimer;
  ShutdownKeyboard;
  ShutdownTexter;
  Init80x25;
  ShutdownBuffers;
End.