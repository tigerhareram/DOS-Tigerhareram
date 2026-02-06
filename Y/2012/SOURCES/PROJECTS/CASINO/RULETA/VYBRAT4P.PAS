Procedure Vybrat1B4P;
Begin
  Repeat
    Dec(Score4,5);
    Inc(Credit4,5);
    StopPlay;
    PlaySound(4);
    Wait(35);
    WriteAutomatScreen4;
  Until Score4=0;
End;


Procedure Vybrat2B4P;
Begin
  Repeat
    Dec(Score4,50);
    Inc(Credit4,50);
    StopPlay;
    PlaySound(4);
    Wait(35);
    WriteAutomatScreen4;
  Until Score4<=1000;
End;


Procedure Vybrat3B4P;
Begin
  Repeat
    Dec(Score4,100);
    Inc(Credit4,100);
    StopPlay;
    PlaySound(4);
    Wait(35);
    WriteAutomatScreen4;
  Until Score4<=10000;
End;


Procedure Vybrat4P;
Begin
  If ((Score4<=1000) and (Score4>0)) then
  Begin
    Vybrat1B4P; Wait(350);
  End;

  If ((Score4>=1000) and (Score4<=10000)) then
  Begin
    Vybrat2B4P; Wait(350);
    Vybrat1B4P; Wait(350);
  End;

  If Score4>10000 then
  Begin
    Vybrat3B4P; Wait(350);
    Vybrat2B4P; Wait(350);
    Vybrat1B4P; Wait(350);
  End;
End;
