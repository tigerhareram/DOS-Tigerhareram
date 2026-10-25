Procedure SetBet0;
Begin
  Bet:=2;
  BetMulti:=0;
  BetCounter:=0;
  If DatRec.SBEnable=True then else PlaySound(10);
  Nasobic:=0;
  Lista[0].Enable:=True;
  Lista[1].Enable:=False;
  Lista[0].Sazka[0]:=True;
  Lista[0].Sazka[1]:=False;
End;


Procedure SetBet;
Begin
  Case BetCounter of
    0: Begin
         If Credit>=4 then Begin
                             Bet:=4;
                             BetMulti:=0;
                             Inc(BetCounter);
                             If DatRec.SBEnable=True then else PlaySound(10);
                             Nasobic:=0;
                             Lista[0].Enable:=True;
                             Lista[1].Enable:=False;
                             Lista[0].Sazka[0]:=False;
                             Lista[0].Sazka[1]:=True;
                           End
                      else SetBet0;

       End;
    1: Begin
         If ((Credit>=5) and (MultiWin>=5))
         then Begin
                Bet:=5;
                BetMulti:=5;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=1;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
    2: Begin
         If ((Credit>=5) and (MultiWin>=15))
         then Begin
                Bet:=5;
                BetMulti:=15;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=2;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
    3: Begin
         If ((Credit>=5) and (MultiWin>=25))
         then Begin
                Bet:=5;
                BetMulti:=25;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=3;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
    4: Begin
         If ((Credit>=5) and (MultiWin>=35))
         then Begin
                Bet:=5;
                BetMulti:=35;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=4;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
    5: Begin
         If ((Credit>=5) and (MultiWin>=45))
         then Begin
                Bet:=5;
                BetMulti:=45;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=5;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
    6: Begin
         If ((Credit>=5) and (MultiWin>=55))
         then Begin
                Bet:=5;
                BetMulti:=55;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=6;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
    7: Begin
         If ((Credit>=5) and (MultiWin>=65))
         then Begin
                Bet:=5;
                BetMulti:=65;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=7;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
    8: Begin
         If ((Credit>=5) and (MultiWin>=75))
         then Begin
                Bet:=5;
                BetMulti:=75;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=8;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
    9: Begin
         If ((Credit>=5) and (MultiWin>=85))
         then Begin
                Bet:=5;
                BetMulti:=85;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=9;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
   10: Begin
         If ((Credit>=5) and (MultiWin>=95))
         then Begin
                Bet:=5;
                BetMulti:=95;
                Inc(BetCounter);
                If DatRec.SBEnable=True then else PlaySound(10);
                Nasobic:=10;
                Lista[0].Enable:=False;
                Lista[1].Enable:=True;
                Lista[0].Sazka[0]:=False;
                Lista[0].Sazka[1]:=False;
              End
         else SetBet0;
       End;
   11: SetBet0;
  End; {Case End}
End;