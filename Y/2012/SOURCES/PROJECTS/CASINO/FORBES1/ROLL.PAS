Procedure Roll;
Begin
  AllStoped:=False;
  RollSetup;
  Repeat
    ProcessRoll;
    KresliValce;
    UpdateValce;
  Until AllStoped=True;
  TestWin;
  If Vyhra>0 then Begin
                    WinConf.Nasobitel:=Vyhra;
                    WinBlink;
                    If WinConf.Nasobitel<20 then Wait(1000);
                    If ((WinConf.Nasobitel>=20) and (WinConf.Nasobitel<50)) then Wait(1500);
                    If WinConf.Nasobitel>=50 then Wait(2500);
                    ScorePlus;
                  End;
  If RollCounter2<MaxRolls then Inc(RollCounter2)
                           else Begin
                                  RollCounter2:=0;
                                  StopPlay;
                                  PlaySound(6);
                                  ValecCFG;
                                End;
  If RollCounter3<5 then Inc(RollCounter3)
                    else RollCounter3:=0;
End;