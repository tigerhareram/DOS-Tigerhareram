Function KostkaPozadi(X,Y: LongInt): Byte;
Begin
  X:=X div 16;
  Y:=Y div 16;
  If GetMapByte(Y*80+X)>=128 then KostkaPozadi:=0
                             else KostkaPozadi:=1;
End;


Function GetPole(X,Y: LongInt): Byte;
Begin
  X:=X div 16;
  Y:=Y div 16;
  GetPole:=GetMapByte(Y*80+X);
End;


Procedure SetPole(X,Y: LongInt;hodnota:Byte);
Begin
  X:=X div 16;
  Y:=Y div 16;
  SetMapByte(Y*80+X,hodnota);
End;


Function Inside(X,Y,xa1,ya1,xa2,ya2: LongInt): Boolean;
Begin
  If (((X>=xa1) and (X<=xa2)) and ((Y>=ya1) and (Y<=ya2))) then Inside:=True
                                                           else Inside:=False;
End;