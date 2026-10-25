 {+++ JACKPOT +++}
Procedure JackPotWin;
Begin
  If DatRec2.JackPotCounter>0 then Begin
                                     Dec(DatRec2.JackPotCounter);
                                     MainGameScreen;
                                   End
                              else Begin
                                     Inc(DatRec2.Hotovost,DatRec2.JackPot);
                                     Inc(VyplacenoTMP,DatRec2.JackPot);
                                     Inc(DatRec2.Pub.Vyplaceno,DatRec2.JackPot);
                                     MainGameScreen;
                                     DatRec2.JackPotCounter:=9;
                                     DatRec2.JackPot:=0;
                                   End;
  JackPotPadl:=False; {Set Ready}
End;