Procedure BlikBlik;
Var I: Byte;
Begin
  If WinConf.Vyhra[1]=True then
  Begin
    For I:=1 to 3 do
    If WinConf.Symbol[I]=0 then WinConf.Symbol[I]:=1
                           else WinConf.Symbol[I]:=0;
  End;

  If WinConf.Vyhra[2]=True then
  Begin
    For I:=4 to 6 do
    If WinConf.Symbol[I]=0 then WinConf.Symbol[I]:=1
                           else WinConf.Symbol[I]:=0;
  End;

  If WinConf.Vyhra[3]=True then
  Begin
    For I:=7 to 9 do
    If WinConf.Symbol[I]=0 then WinConf.Symbol[I]:=1
                           else WinConf.Symbol[I]:=0;
  End;

  If WinConf.Vyhra[4]=True then
  Begin
    If WinConf.Vyhra[1]=False then
    If WinConf.Symbol[1]=0 then WinConf.Symbol[1]:=1
                           else WinConf.Symbol[1]:=0;
    If WinConf.Vyhra[2]=False then
    If WinConf.Symbol[5]=0 then WinConf.Symbol[5]:=1
                           else WinConf.Symbol[5]:=0;
    If WinConf.Vyhra[3]=False then
    If WinConf.Symbol[9]=0 then WinConf.Symbol[9]:=1
                           else WinConf.Symbol[9]:=0;
  End;

  If WinConf.Vyhra[5]=True then
  Begin
    If WinConf.Vyhra[3]=False then
    If WinConf.Symbol[7]=0 then WinConf.Symbol[7]:=1
                           else WinConf.Symbol[7]:=0;
    If ((WinConf.Vyhra[2]=False) and (WinConf.Vyhra[4]=False))  then
    If WinConf.Symbol[5]=0 then WinConf.Symbol[5]:=1
                           else WinConf.Symbol[5]:=0;
    If WinConf.Vyhra[1]=False then
    If WinConf.Symbol[3]=0 then WinConf.Symbol[3]:=1
                           else WinConf.Symbol[3]:=0;
  End;
End;


Procedure WinBlink;
Var I: Byte;
Begin
  If WinConf.Nasobitel<20 then
  Begin
    WinConf.Counter1:=200;
    WinConf.Counter2:=0;
    WinConf.Counter3:=0;
    Repeat
      If WinConf.Counter2<10 then Inc(WinConf.Counter2)
                             else Begin
                                    WinConf.Counter2:=0;
                                    If  ((WinConf.Nasobitel>=6) and
                                        (WinConf.Nasobitel<20)) then PlaySound(10)
                                                                else PlaySound(5);
                                  End;

      If WinConf.Counter3<2 then Inc(WinConf.Counter3)
                            else Begin
                                   WinConf.Counter3:=0;
                                   BlikBlik;
                                   KresliValce2;
                                   WaitRetrace;
                                   UpdateValce;
                                 End;
      Wait(10);
      Dec(WinConf.Counter1);
    Until WinConf.Counter1=0;
    For I:=1 to 9 do WinConf.Symbol[I]:=0;
    KresliValce2;
    WaitRetrace;
    UpdateValce;
  End;

  If (WinConf.Nasobitel>=20) and (WinConf.Nasobitel<50) then
  Begin
    WinConf.Counter1:=200;
    WinConf.Counter2:=0;
    WinConf.Counter3:=0;
    Repeat
      If WinConf.Counter2<15 then Inc(WinConf.Counter2)
                             else Begin
                                    WinConf.Counter2:=0;
                                    StopPlay;
                                    PlayRaw(2);
                                  End;

      If WinConf.Counter3<2 then Inc(WinConf.Counter3)
                            else Begin
                                   WinConf.Counter3:=0;
                                   BlikBlik;
                                   KresliValce2;
                                   WaitRetrace;
                                   UpdateValce;
                                 End;
      Wait(10);
      Dec(WinConf.Counter1);
    Until WinConf.Counter1=0;
    For I:=1 to 9 do WinConf.Symbol[I]:=0;
    KresliValce2;
    WaitRetrace;
    UpdateValce;
  End;

  If WinConf.Nasobitel>=50 then
  Begin
    WinConf.Counter1:=200;
    WinConf.Counter2:=0;
    WinConf.Counter3:=0;
    StopPlay;
    PlayRaw(3);
    Repeat
      If WinConf.Counter3<2 then Inc(WinConf.Counter3)
                            else Begin
                                   WinConf.Counter3:=0;
                                   BlikBlik;
                                   KresliValce2;
                                   WaitRetrace;
                                   UpdateValce;
                                 End;
      Wait(10);
      Dec(WinConf.Counter1);
    Until WinConf.Counter1=0;
    For I:=1 to 9 do WinConf.Symbol[I]:=0;
    KresliValce2;
    WaitRetrace;
    UpdateValce;
  End;
End;