Procedure IncVyhra(Walec,Symb: Byte);
Begin
  Case Valec[Walec].Symbol[Symb] of
    1: Begin Inc(Vyhra,1); Inc(WinInfo.Vyher[1]); End;
    2: Begin Inc(Vyhra,2); Inc(WinInfo.Vyher[2]); End;
    3: Begin Inc(Vyhra,4); Inc(WinInfo.Vyher[3]); End;
    4: Begin Inc(Vyhra,6); Inc(WinInfo.Vyher[4]); End;
    5: Begin Inc(Vyhra,10); Inc(WinInfo.Vyher[5]); End;
    6: Begin Inc(Vyhra,20); Inc(WinInfo.Vyher[6]); End;
    7: Begin Inc(Vyhra,40); Inc(WinInfo.Vyher[7]); End;
    8: Begin Inc(Vyhra,60); Inc(WinInfo.Vyher[8]); End;
    9: Begin Inc(Vyhra,100); Inc(WinInfo.Vyher[9]); End;
    0: Begin Inc(Vyhra,200); Inc(WinInfo.Vyher[0]); End;
  End; {Case End}
End;


Procedure TestWin;
Begin
  If ((Valec[0].Symbol[1]>0) and (Valec[0].Symbol[1]=Valec[1].Symbol[1]) and (Valec[1].Symbol[1]=Valec[2].Symbol[1])) then
  Begin
    IncVyhra(0,1);
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[2]:=1;
    WinConf.Symbol[3]:=1;
    WinConf.Vyhra[1]:=True;
  End;

  If ((Valec[0].Symbol[2]>0) and (Valec[0].Symbol[2]=Valec[1].Symbol[2]) and (Valec[1].Symbol[2]=Valec[2].Symbol[2])) then
  Begin
    IncVyhra(0,2);
    WinConf.Symbol[4]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[6]:=1;
    WinConf.Vyhra[2]:=True;
  End;

  If ((Valec[0].Symbol[3]>0) and (Valec[0].Symbol[3]=Valec[1].Symbol[3]) and (Valec[1].Symbol[3]=Valec[2].Symbol[3])) then
  Begin
    IncVyhra(0,3);
    WinConf.Symbol[7]:=1;
    WinConf.Symbol[8]:=1;
    WinConf.Symbol[9]:=1;
    WinConf.Vyhra[3]:=True;
  End;

  If ((Valec[0].Symbol[1]>0) and (Valec[0].Symbol[1]=Valec[1].Symbol[2]) and (Valec[1].Symbol[2]=Valec[2].Symbol[3])) then
  Begin
    IncVyhra(0,1);
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[9]:=1;
    WinConf.Vyhra[4]:=True;
  End;

  If ((Valec[0].Symbol[3]>0) and (Valec[0].Symbol[3]=Valec[1].Symbol[2]) and (Valec[1].Symbol[2]=Valec[2].Symbol[1])) then
  Begin
    IncVyhra(0,3);
    WinConf.Symbol[7]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[3]:=1;
    WinConf.Vyhra[5]:=True;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[1]=Valec[2].Symbol[1])) or
     ((Valec[1].Symbol[1]=0) and (Valec[0].Symbol[1]=Valec[2].Symbol[1])) or
     ((Valec[2].Symbol[1]=0) and (Valec[0].Symbol[1]=Valec[1].Symbol[1])) then
  Begin
    If ((Valec[0].Symbol[1]=0) and (WinConf.Vyhra[1]=False)) then Begin IncVyhra(1,1); WinConf.Vyhra[1]:=True; End;
    If ((Valec[1].Symbol[1]=0) and (WinConf.Vyhra[1]=False)) then Begin IncVyhra(2,1); WinConf.Vyhra[1]:=True; End;
    If ((Valec[2].Symbol[1]=0) and (WinConf.Vyhra[1]=False)) then Begin IncVyhra(0,1); WinConf.Vyhra[1]:=True; End;
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[2]:=1;
    WinConf.Symbol[3]:=1;
  End;

  If ((Valec[0].Symbol[2]=0) and (Valec[1].Symbol[2]=Valec[2].Symbol[2])) or
     ((Valec[1].Symbol[2]=0) and (Valec[0].Symbol[2]=Valec[2].Symbol[2])) or
     ((Valec[2].Symbol[2]=0) and (Valec[0].Symbol[2]=Valec[1].Symbol[2])) then
  Begin
    If ((Valec[0].Symbol[2]=0) and (WinConf.Vyhra[2]=False)) then Begin IncVyhra(1,2); WinConf.Vyhra[2]:=True; End;
    If ((Valec[1].Symbol[2]=0) and (WinConf.Vyhra[2]=False)) then Begin IncVyhra(2,2); WinConf.Vyhra[2]:=True; End;
    If ((Valec[2].Symbol[2]=0) and (WinConf.Vyhra[2]=False)) then Begin IncVyhra(0,2); WinConf.Vyhra[2]:=True; End;
    WinConf.Symbol[4]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[6]:=1;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[3]=Valec[2].Symbol[3])) or
     ((Valec[1].Symbol[3]=0) and (Valec[0].Symbol[3]=Valec[2].Symbol[3])) or
     ((Valec[2].Symbol[3]=0) and (Valec[0].Symbol[3]=Valec[1].Symbol[3])) then
  Begin
    If ((Valec[0].Symbol[3]=0) and (WinConf.Vyhra[3]=False)) then Begin IncVyhra(1,3); WinConf.Vyhra[3]:=True; End;
    If ((Valec[1].Symbol[3]=0) and (WinConf.Vyhra[3]=False)) then Begin IncVyhra(2,3); WinConf.Vyhra[3]:=True; End;
    If ((Valec[2].Symbol[3]=0) and (WinConf.Vyhra[3]=False)) then Begin IncVyhra(0,3); WinConf.Vyhra[3]:=True; End;
    WinConf.Symbol[7]:=1;
    WinConf.Symbol[8]:=1;
    WinConf.Symbol[9]:=1;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[2]=Valec[2].Symbol[3])) or
     ((Valec[1].Symbol[2]=0) and (Valec[0].Symbol[1]=Valec[2].Symbol[3])) or
     ((Valec[2].Symbol[3]=0) and (Valec[0].Symbol[1]=Valec[1].Symbol[2])) then
  Begin
    If ((Valec[0].Symbol[1]=0) and (WinConf.Vyhra[4]=False)) then Begin IncVyhra(1,2); WinConf.Vyhra[4]:=True; End;
    If ((Valec[1].Symbol[2]=0) and (WinConf.Vyhra[4]=False)) then Begin IncVyhra(2,3); WinConf.Vyhra[4]:=True; End;
    If ((Valec[2].Symbol[3]=0) and (WinConf.Vyhra[4]=False)) then Begin IncVyhra(0,1); WinConf.Vyhra[4]:=True; End;
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[9]:=1;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[2]=Valec[2].Symbol[1])) or
     ((Valec[1].Symbol[2]=0) and (Valec[0].Symbol[3]=Valec[2].Symbol[1])) or
     ((Valec[2].Symbol[1]=0) and (Valec[0].Symbol[3]=Valec[1].Symbol[2])) then
  Begin
    If ((Valec[0].Symbol[3]=0) and (WinConf.Vyhra[5]=False)) then Begin IncVyhra(1,2); WinConf.Vyhra[5]:=True; End;
    If ((Valec[1].Symbol[2]=0) and (WinConf.Vyhra[5]=False)) then Begin IncVyhra(2,1); WinConf.Vyhra[5]:=True; End;
    If ((Valec[2].Symbol[1]=0) and (WinConf.Vyhra[5]=False)) then Begin IncVyhra(0,3); WinConf.Vyhra[5]:=True; End;
    WinConf.Symbol[3]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[7]:=1;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[1]=0) and (Valec[2].Symbol[1]>0)) then
  Begin
    IncVyhra(2,1);
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[2]:=1;
    WinConf.Symbol[3]:=1;
    WinConf.Vyhra[1]:=True;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[2].Symbol[1]=0) and (Valec[1].Symbol[1]>0)) then
  Begin
    IncVyhra(1,1);
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[2]:=1;
    WinConf.Symbol[3]:=1;
    WinConf.Vyhra[1]:=True;
  End;

  If ((Valec[1].Symbol[1]=0) and (Valec[2].Symbol[1]=0) and (Valec[0].Symbol[1]>0)) then
  Begin
    IncVyhra(0,1);
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[2]:=1;
    WinConf.Symbol[3]:=1;
    WinConf.Vyhra[1]:=True;
  End;

  If ((Valec[0].Symbol[2]=0) and (Valec[1].Symbol[2]=0) and (Valec[2].Symbol[2]>0)) then
  Begin
    IncVyhra(2,2);
    WinConf.Symbol[4]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[6]:=1;
    WinConf.Vyhra[2]:=True;
  End;

  If ((Valec[0].Symbol[2]=0) and (Valec[2].Symbol[2]=0) and (Valec[1].Symbol[2]>0)) then
  Begin
    IncVyhra(1,2);
    WinConf.Symbol[4]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[6]:=1;
    WinConf.Vyhra[2]:=True;
  End;

  If ((Valec[1].Symbol[2]=0) and (Valec[2].Symbol[2]=0) and (Valec[0].Symbol[2]>0)) then
  Begin
    IncVyhra(0,2);
    WinConf.Symbol[4]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[6]:=1;
    WinConf.Vyhra[2]:=True;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[3]=0) and (Valec[2].Symbol[3]>0)) then
  Begin
    IncVyhra(2,3);
    WinConf.Symbol[7]:=1;
    WinConf.Symbol[8]:=1;
    WinConf.Symbol[9]:=1;
    WinConf.Vyhra[3]:=True;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[2].Symbol[3]=0) and (Valec[1].Symbol[3]>0)) then
  Begin
    IncVyhra(1,3);
    WinConf.Symbol[7]:=1;
    WinConf.Symbol[8]:=1;
    WinConf.Symbol[9]:=1;
    WinConf.Vyhra[3]:=True;
  End;

  If ((Valec[1].Symbol[3]=0) and (Valec[2].Symbol[3]=0) and (Valec[0].Symbol[3]>0)) then
  Begin
    IncVyhra(0,3);
    WinConf.Symbol[7]:=1;
    WinConf.Symbol[8]:=1;
    WinConf.Symbol[9]:=1;
    WinConf.Vyhra[3]:=True;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[2]=0) and (Valec[2].Symbol[3]>0)) then
  Begin
    IncVyhra(2,3);
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[9]:=1;
    WinConf.Vyhra[4]:=True;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[2].Symbol[3]=0) and (Valec[1].Symbol[2]>0)) then
  Begin
    IncVyhra(1,2);
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[9]:=1;
    WinConf.Vyhra[4]:=True;
  End;

  If ((Valec[1].Symbol[2]=0) and (Valec[2].Symbol[3]=0) and (Valec[0].Symbol[1]>0)) then
  Begin
    IncVyhra(0,1);
    WinConf.Symbol[1]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[9]:=1;
    WinConf.Vyhra[4]:=True;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[2]=0) and (Valec[2].Symbol[1]>0)) then
  Begin
    IncVyhra(2,1);
    WinConf.Symbol[7]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[3]:=1;
    WinConf.Vyhra[5]:=True;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[2].Symbol[1]=0) and (Valec[1].Symbol[2]>0)) then
  Begin
    IncVyhra(1,2);
    WinConf.Symbol[7]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[3]:=1;
    WinConf.Vyhra[5]:=True;
  End;

  If ((Valec[1].Symbol[2]=0) and (Valec[2].Symbol[1]=0) and (Valec[0].Symbol[3]>0)) then
  Begin
    IncVyhra(0,3);
    WinConf.Symbol[7]:=1;
    WinConf.Symbol[5]:=1;
    WinConf.Symbol[3]:=1;
    WinConf.Vyhra[5]:=True;
  End;
End;