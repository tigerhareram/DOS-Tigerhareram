Procedure Str80(Cesta:String);
Var Fi: Text;
    X,Y: Byte;
Begin
  Assign(Fi,Cesta);
  Reset(Fi);
  For Y:=0 to 24 do
  For X:=0 to 79 do Read(Fi,stranka[Y,X]);
  Close(Fi);
End;
