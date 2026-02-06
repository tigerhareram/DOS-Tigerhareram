Procedure VGA_Bar(X,Y,Barva,BufferTo:Word);
Var Xa,Ya: Word;
Begin
  For Ya:=Y to Y+7 do
  For Xa:=X to X+7 do mem[BufferTo:(Ya*320+Xa)]:=Barva;
End;