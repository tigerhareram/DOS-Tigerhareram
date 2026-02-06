Procedure WriteMainScreen;
Begin
  ClearPage(Buffer[3]);
  WriteNumber(Buffer[1],160,184,16,16,1,10,10,HiScore,Buffer[3]);
  If FPS2s=True then WriteText(Buffer[1],160,136,16,16,1,75,180,'press enter',Buffer[3]);
  WriteBlok(10,68,10,68,309,135,Buffer[2],Buffer[3]);
  WriteText(Buffer[1],0,180,5,5,1,277,195,'s=setup',Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure Main;
Begin
  Konec:=False;
  Randomize;
  HiScoreSaveLoad(False); {LOAD}
  LoadDefaultFont(0,180,ColorRed,Buffer[1]);
  Repeat
    WriteMainScreen;
    Wait(fps.prodleva);
    If Key[28]=True then
    Begin
      While Key[28]=True do Begin End;
      If SB=False then PlaySound(2) else SBPlayRaw(2);
      MainGame;
    End;
    If Key[31]=True then
    Begin
      While Key[31]=True do Begin End;
      Setup;
    End;
    If Key[1]=True then Konec:=True;
  Until Konec=True;
End;