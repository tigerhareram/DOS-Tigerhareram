Program Test1;
Uses Engine;
Type
  TPanak = Record
             X,Y: Word;   {souradnice pro pohyb chozeni}
             X2,Y2: Word; {souradnice pro bojove pohyby}
             frame: Byte;
             frame2: Byte;
           End;

Var
  Panak: array [0..5] of TPanak;
  prodleva: Word;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure WriteTestScreen;
Var
  I: Byte;
Begin
  ClearPage(Buffer[3]);
  Ramecek(0,0,319,199,50,Buffer[3]);
  WriteText(10,10,'Esc=Exit',Buffer[3]);

  For I:=0 to 5 do
  Begin
    If Panak[I].frame=0
    then Begin
           Panak[I].frame:=1;
           WriteSprite(Panak[I].X,Panak[I].Y,0,I*32,19,I*32+31,Buffer[1],Buffer[3]);
           WriteSprite(Panak[I].X2,Panak[I].Y2,40,I*32,59,I*32+31,Buffer[1],Buffer[3]);
           WriteSprite(Panak[I].X2+25,Panak[I].Y2,0,I*32,19,I*32+31,Buffer[1],Buffer[3]);
           If Panak[I].frame2>3 then WriteSprite(Panak[I].X2+50,Panak[I].Y2,20,I*32,39,I*32+31,Buffer[1],Buffer[3])
                                else WriteSprite(Panak[I].X2+50,Panak[I].Y2,100,I*32,119,I*32+31,Buffer[1],Buffer[3]);
         End
    else Begin
           Panak[I].frame:=0;
           WriteSprite(Panak[I].X,Panak[I].Y,20,I*32,39,I*32+31,Buffer[1],Buffer[3]);
           WriteSprite(Panak[I].X2,Panak[I].Y2,60,I*32,79,I*32+31,Buffer[1],Buffer[3]);
           WriteSprite(Panak[I].X2+25,Panak[I].Y2,80,I*32,99,I*32+31,Buffer[1],Buffer[3]);
           If Panak[I].frame2>3 then WriteSprite(Panak[I].X2+50,Panak[I].Y2,20,I*32,39,I*32+31,Buffer[1],Buffer[3])
                                else WriteSprite(Panak[I].X2+50,Panak[I].Y2,100,I*32,119,I*32+31,Buffer[1],Buffer[3]);
         End;
    If Panak[I].X>10 then Dec(Panak[I].X,8) else Panak[I].X:=290;
    If Panak[I].frame2>0 then Dec(Panak[I].frame2) else Panak[I].frame2:=6;
  End;

  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure Maintest;
Var
  Ending: Boolean;
  I,ErrorCode: Integer;
Begin
  Ending:=False;
  LoadGrPage('C:\SOURCES\PROJECTS\GAMES\PANTER\TESTY\panter1.gra',0);
  LoadBlok(0,0,0,0,159,199,Buffer[1]);

  If ParamCount>0
  then Begin
         Val(ParamStr(1), prodleva, ErrorCode);
         If ErrorCode<>0 then Begin Writeln('Chyba'); Halt; End;
       End
  else prodleva:=120;

  For I:=0 to 5 do
  Begin
    Panak[I].X:=140+I*20+I*5;
    Panak[I].Y:=25;
  End;

  For I:=0 to 2 do
  Begin
    Panak[I].X2:=10;
    Panak[I].Y2:=70+I*32+I*5;
  End;

  For I:=3 to 5 do
  Begin
    Panak[I].X2:=170;
    Panak[I].Y2:=70+(I-3)*32+(I-3)*5;
  End;


  Repeat
    Wait(prodleva);
    WriteTestScreen;
    If Key[1]=True then Ending:=True;
  Until Ending=True;
End;


Procedure Main;
Begin
  InitBuffers;
  Init320x200;
  InitTexter(50);
  InitTimer;
  InitKeyboard;

  MainTest;

  ShutdownKeyboard;
  ShutdownTimer;
  Init80x25;
  ShutdownBuffers;
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin Main; End.
