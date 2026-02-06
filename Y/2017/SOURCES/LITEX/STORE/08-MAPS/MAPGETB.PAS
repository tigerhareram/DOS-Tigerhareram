Function Map_GetSqr(Xr,Yr: Word): Word;
Var X,Y: Word;
Begin
  X:=Xr div 8;
  Y:=Yr div 8;
  Map_GetSqr:=memW[BufferMap:(Y*80+X)*2];
End;
