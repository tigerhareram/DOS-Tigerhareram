Function TestVyhry: Boolean; {True=nastane vyhra}
Begin
  TestVyhry:=False;

  If ((PS[0].Symbol[1]=PS[1].Symbol[1]) and (PS[1].Symbol[1]=PS[2].Symbol[1]) and
     (PS[0].Symbol[1]>5)) then TestVyhry:=True;

  If ((PS[0].Symbol[2]=PS[1].Symbol[2]) and (PS[1].Symbol[2]=PS[2].Symbol[2]) and
     (PS[0].Symbol[2]>5)) then TestVyhry:=True;

  If ((PS[0].Symbol[3]=PS[1].Symbol[3]) and (PS[1].Symbol[3]=PS[2].Symbol[3]) and
     (PS[0].Symbol[3]>5)) then TestVyhry:=True;

  If ((PS[0].Symbol[1]=PS[1].Symbol[2]) and (PS[1].Symbol[2]=PS[2].Symbol[3]) and
     (PS[0].Symbol[1]>5)) then TestVyhry:=True;

  If ((PS[0].Symbol[3]=PS[1].Symbol[2]) and (PS[1].Symbol[2]=PS[2].Symbol[1]) and
     (PS[0].Symbol[3]>5)) then TestVyhry:=True;

  If ((PS[0].Symbol[1]=0) and (PS[1].Symbol[1]=PS[2].Symbol[1]) and (PS[1].Symbol[1]>5)) or
     ((PS[1].Symbol[1]=0) and (PS[0].Symbol[1]=PS[2].Symbol[1]) and (PS[0].Symbol[1]>5)) or
     ((PS[2].Symbol[1]=0) and (PS[0].Symbol[1]=PS[1].Symbol[1]) and (PS[0].Symbol[1]>5)) then
  TestVyhry:=True;

  If ((PS[0].Symbol[2]=0) and (PS[1].Symbol[2]=PS[2].Symbol[2]) and (PS[1].Symbol[2]>5)) or
     ((PS[1].Symbol[2]=0) and (PS[0].Symbol[2]=PS[2].Symbol[2]) and (PS[0].Symbol[2]>5)) or
     ((PS[2].Symbol[2]=0) and (PS[0].Symbol[2]=PS[1].Symbol[2]) and (PS[0].Symbol[2]>5)) then
  TestVyhry:=True;

  If ((PS[0].Symbol[3]=0) and (PS[1].Symbol[3]=PS[2].Symbol[3]) and (PS[1].Symbol[3]>5)) or
     ((PS[1].Symbol[3]=0) and (PS[0].Symbol[3]=PS[2].Symbol[3]) and (PS[0].Symbol[3]>5)) or
     ((PS[2].Symbol[3]=0) and (PS[0].Symbol[3]=PS[1].Symbol[3]) and (PS[0].Symbol[3]>5)) then
  TestVyhry:=True;

  If ((PS[0].Symbol[1]=0) and (PS[1].Symbol[2]=PS[2].Symbol[3]) and (PS[1].Symbol[2]>5)) or
     ((PS[1].Symbol[2]=0) and (PS[0].Symbol[1]=PS[2].Symbol[3]) and (PS[0].Symbol[2]>5)) or
     ((PS[2].Symbol[3]=0) and (PS[0].Symbol[1]=PS[1].Symbol[2]) and (PS[0].Symbol[1]>5)) then
  TestVyhry:=True;

  If ((PS[0].Symbol[3]=0) and (PS[1].Symbol[2]=PS[2].Symbol[1]) and (PS[1].Symbol[2]>5)) or
     ((PS[1].Symbol[2]=0) and (PS[0].Symbol[3]=PS[2].Symbol[1]) and (PS[0].Symbol[3]>5)) or
     ((PS[2].Symbol[1]=0) and (PS[0].Symbol[3]=PS[1].Symbol[2]) and (PS[0].Symbol[3]>5)) then
  TestVyhry:=True;

  If ((PS[0].Symbol[1]=0) and (PS[1].Symbol[1]=0) and (PS[2].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[0].Symbol[1]=0) and (PS[2].Symbol[1]=0) and (PS[1].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[1].Symbol[1]=0) and (PS[2].Symbol[1]=0) and (PS[0].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[0].Symbol[2]=0) and (PS[1].Symbol[2]=0) and (PS[2].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[0].Symbol[2]=0) and (PS[2].Symbol[2]=0) and (PS[1].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[1].Symbol[2]=0) and (PS[2].Symbol[2]=0) and (PS[0].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[0].Symbol[3]=0) and (PS[1].Symbol[3]=0) and (PS[2].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[0].Symbol[3]=0) and (PS[2].Symbol[3]=0) and (PS[1].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[1].Symbol[3]=0) and (PS[2].Symbol[3]=0) and (PS[0].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[0].Symbol[1]=0) and (PS[1].Symbol[2]=0) and (PS[2].Symbol[3]>5)) then TestVyhry:=True;
  If ((PS[0].Symbol[1]=0) and (PS[2].Symbol[3]=0) and (PS[1].Symbol[2]>5)) then TestVyhry:=True;
  If ((PS[1].Symbol[2]=0) and (PS[2].Symbol[3]=0) and (PS[0].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[0].Symbol[3]=0) and (PS[1].Symbol[2]=0) and (PS[2].Symbol[1]>5)) then TestVyhry:=True;
  If ((PS[0].Symbol[3]=0) and (PS[2].Symbol[1]=0) and (PS[1].Symbol[2]>5)) then TestVyhry:=True;
  If ((PS[1].Symbol[2]=0) and (PS[2].Symbol[1]=0) and (PS[0].Symbol[3]>5)) then TestVyhry:=True;

End;


Procedure WinCore;
Var
  I,N: Byte;
  PosunValce: array[0..2] of Word;
Begin
  For I:=0 to 2 do
  Begin
    PosunValce[I]:=Valec[I].Counter div 32; {pocet symbolu ktere odroluji}
    If Valec[I].SCounter>PosunValce[I] then
    Begin
      Korigovat:=True;
      PS[I].Symbol[1]:=Symboly[Valec[I].SCounter-PosunValce[I]+1];
      PS[I].Symbol[2]:=Symboly[Valec[I].SCounter-PosunValce[I]+2];
      PS[I].Symbol[3]:=Symboly[Valec[I].SCounter-PosunValce[I]+3];
    End else
    Begin
      Korigovat:=False;
      For N:=1 to 3 do PS[I].Symbol[N]:=0;
    End;
  End;
  If Korigovat=True then
  If TestVyhry=True then Inc(Valec[Random(3)].Counter,32);
End;