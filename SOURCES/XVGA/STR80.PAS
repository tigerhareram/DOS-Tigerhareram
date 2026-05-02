Procedure Str80(Cesta:String);
Var Fi: Text;
    X,Y: Byte;
Begin
  Assign(Fi,Cesta);
  Reset(Fi);
  For Y:=0 to 24 do
  For X:=0 to 79 do Read(Fi,stranka[Y,X]);
  Close(Fi);

  For Y:=0 to 24 do
  For X:=0 to 79 do Begin
                  { _Print(X*8,Y*16,1,Stranka[Y,X]); }
                    writexy(X*8,Y*8,Stranka[Y,X]); {GrafX Stefans text}
                    End;

End;
