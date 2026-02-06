Program Palette;
Uses Lite;
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Main;
Var X,Y,I: Word;
Begin
  LoadDefaultFont(160,0,255,Buffer[2]);
  SetBlinkingTempo(10);
  For I:=0 to 255 do
  Begin
    SavePal(I);
    BlackPal(I);
  End;
  SetPal(255,40,63,20);
  SetPal(254,63,63,63);
  ClearPage(Buffer[3]);
  Ramecek(0,0,319,199,255,Buffer[3]);
  For Y:=2 to 197 do
  For X:=2 to 317 do
  WritePixel(X,Y,Random(253),Buffer[3]);
  Blok(260,6,315,19,0,Buffer[3]);
  WriteText(Buffer[2],160,0,5,5,1,265,10,'esc=exit',Buffer[3]);
  Blok(70,10,247,187,254,Buffer[3]);
  FlipPage(Buffer[3],Buffer[4]);
  FadeIn;
  For I:=0 to 39 do StartBlinking(I);
  For I:=56 to 254 do StartBlinking(I);
  I:=40;
  For Y:=0 to 3 do
  For X:=0 to 3 do
  Begin
    Blok(80+X*40,20+Y*40,80+X*40+37,20+Y*40+37,I,Buffer[3]);
    StartBlinking(I);
    Inc(I);
    Wait(120);
    WaitRetrace;
    FlipPage(Buffer[3],Buffer[4]);
  End;
  Repeat Until Key[1]=True;
  For I:=40 to 55 do StopBlinking(I);
  StopBlinking(254);
  FadeOut;
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin
  Init320x200;
  InitBuffers;
  InitKeyboard;
  InitTimer;

  Main;

  ShutdownTimer;
  ShutdownKeyboard;
  ShutdownBuffers;
  Init80x25;
End.