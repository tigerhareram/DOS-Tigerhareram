Procedure WriteRuleta;
Var Color,Color2: Byte;
    N,I: Byte;
Begin
  {okraj}
  WriteSegment(0,359,0,31,14);
  WriteSegment(0,359,0,22,14);

  {ruleta}
  For N:=0 to 37 do
  Begin
    If Color=5 then Color:=3 else Color:=5;
    If N=0 then Color:=1;
    If N=19 then Color:=1;
    For I:=0 to 7 do WriteSegment(0,8,N*9,30-I,Color);
    If N=19 then Color:=5;
  End;
  For I:=0 to 7 do WriteSegment(0,8,N*9,30-I,5); Inc(N);
  For I:=0 to 7 do WriteSegment(0,14,N*9,30-I,0);

End;