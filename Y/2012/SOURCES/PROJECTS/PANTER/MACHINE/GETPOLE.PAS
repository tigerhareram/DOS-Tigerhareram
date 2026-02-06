Function GetPole(X,Y: Word): Byte;
Begin
  X:=X div 16;
  Y:=Y div 16;
  GetPole:=GetMapByte(Y*320+X);
End;