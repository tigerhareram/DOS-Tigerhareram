Procedure Vybrat1;
Begin
  While Score>0 do
  Begin
    Dec(Score,5);
    Inc(Hotovost1,5);
    PlaySound(4);
    Wait(40);
    WaitRetrace;
    WriteAutomatScreen;
  End;
End;


Procedure Vybrat2;
Begin
  While Score>1000 do
  Begin
    Dec(Score,50);
    Inc(Hotovost1,50);
    PlaySound(4);
    Wait(40);
    WaitRetrace;
    WriteAutomatScreen;
  End;
End;


Procedure Vybrat3;
Begin
  While Score>10000 do
  Begin
    Dec(Score,100);
    Inc(Hotovost1,100);
    PlaySound(4);
    Wait(40);
    WaitRetrace;
    WriteAutomatScreen;
  End;
End;


Procedure Vybrat;
Begin
  StopPlay;

  If Score<1000 then
  Begin
    Vybrat1;
    Wait(350);
  End;

  If (Score>=1000) and (Score<10000) then
  Begin
    Vybrat2;
    Wait(350);
    Vybrat1;
    Wait(350);
  End;

  If Score>=10000 then
  Begin
    Vybrat3;
    Wait(350);
    Vybrat2;
    Wait(350);
    Vybrat1;
    Wait(350);
  End;
End;