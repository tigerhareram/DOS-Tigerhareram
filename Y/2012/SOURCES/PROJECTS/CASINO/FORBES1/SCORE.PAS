Procedure ScorePlus;
Var I: Word;
Begin
  For I:=0 to WinConf.Nasobitel-1 do
  Begin
    Inc(Score,Sazka);
    PlaySound(4);
    Wait(20);
    WaitRetrace;
    WriteAutomatScreen;
  End;
End;