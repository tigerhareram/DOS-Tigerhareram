Procedure SetBet;
Begin
  Case BetCounter of
    0: Begin
         If Credit>=5 then Begin Sazka:=10; Inc(BetCounter); End
                      else Begin Sazka:=5; BetCounter:=0; End;
       End;
    1: Begin
         If Credit>=20 then Begin Sazka:=20; Inc(BetCounter); End
                       else Begin Sazka:=5;  BetCounter:=0; End;
       End;
    2: Begin
         If Credit>=30 then Begin Sazka:=30; Inc(BetCounter); End
                       else Begin Sazka:=5; BetCounter:=0; End;
       End;
    3: Begin
         If Credit>=40 then Begin Sazka:=40; Inc(BetCounter); End
                       else Begin Sazka:=5; BetCounter:=0; End;
       End;
    4: Begin
         If Credit>=50 then Begin Sazka:=50; Inc(BetCounter); End
                       else Begin Sazka:=5; BetCounter:=0; End;
       End;
    5: Begin
         If Credit>=100 then Begin Sazka:=100; Inc(BetCounter); End
                        else Begin Sazka:=5; BetCounter:=0; End;
       End;
    6: Begin
         If Credit>=200 then Begin Sazka:=200; Inc(BetCounter); End
                        else Begin Sazka:=5; BetCounter:=0; End;
       End;
    7: Begin
         If Credit>=300 then Begin Sazka:=300; Inc(BetCounter); End
                        else Begin Sazka:=5; BetCounter:=0; End;
       End;
    8: Begin
         If Credit>=400 then Begin Sazka:=400; Inc(BetCounter); End
                        else Begin Sazka:=5; BetCounter:=0; End;
       End;
    9: Begin
         If Credit>=500 then Begin Sazka:=500; Inc(BetCounter); End
                        else Begin Sazka:=5; BetCounter:=0; End;
       End;
   10: Begin
         If Credit>=600 then Begin Sazka:=600; Inc(BetCounter); End
                        else Begin Sazka:=5; BetCounter:=0; End;
       End;
   11: Begin
         If Credit>=700 then Begin Sazka:=700; Inc(BetCounter); End
                        else Begin Sazka:=5; BetCounter:=0; End;
       End;
   12: Begin
         If Credit>=800 then Begin Sazka:=800; Inc(BetCounter); End
                        else Begin Sazka:=5; BetCounter:=0; End;
       End;
   13: Begin
         If Credit>=900 then Begin Sazka:=900; Inc(BetCounter); End
                        else Begin Sazka:=5; BetCounter:=0; End;
       End;
   14: Begin
         If Credit>=1000 then Begin Sazka:=1000; Inc(BetCounter); End
                         else Begin Sazka:=5; BetCounter:=0; End;
       End;
   15: Begin
         Sazka:=5;
         BetCounter:=0;
       End;
  End; {Case End}
  StopPlay;
  PlaySound(2);
End;
