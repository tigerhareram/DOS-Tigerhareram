Program EditMap1;
Uses DOS,Lite;

Const
  ButtonSpeed: Byte = 40;


Var
  MapName: String[12];
  GraName: String[12];
  rozmerX: LongInt;
  rozmerY: LongInt;

  readname: string[8];
  readnameZbyva: Byte;
  readnamePos: Byte;
  DirInfo: SearchRec;

  ViewZ: Boolean;

  Xm0,Ym0: Word;
  Xm1,Ym1: Word;
  Xm,Ym: Word;
  Xg,Yg: Byte;
  ButtonDelay: Byte;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{$I C:\SOURCES\PROJECTS\EDITMAP1\sounds.pas}
{$I C:\SOURCES\PROJECTS\EDITMAP1\default.pas}
{$I C:\SOURCES\PROJECTS\EDITMAP1\waitkey.pas}
{$I C:\SOURCES\PROJECTS\EDITMAP1\waitbtn.pas}

{$I C:\SOURCES\PROJECTS\EDITMAP1\editmap.pas}
{$I C:\SOURCES\PROJECTS\EDITMAP1\mainmenu.pas}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Main;
Begin
  InitBuffers;
  Init320x200;
  InitTexter(255);
  InitKeyboard;
  InitTimer;

  SetDefaults;
  MainMenu;
  If rozmerX*rozmerY>0 then ShutdownMapBuffers;

  ShutdownTimer;
  ShutdownKeyboard;
  ShutdownTexter;
  Init80x25;
  ShutdownBuffers;
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin Main; End.