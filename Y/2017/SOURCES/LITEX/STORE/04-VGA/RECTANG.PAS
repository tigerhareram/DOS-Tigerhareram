Procedure VGA_Rectangle(X1,Y1,X2,Y2,Barva,BufferTo:Word);
Var i: Word;
Begin
  For i:= X1 to X2 do mem[BufferTo:(Y1*320+i)]:=Barva;
  For i:= X1 to X2 do mem[BufferTo:(Y2*320+i)]:=Barva;
  For i:= Y1 to Y2 do mem[BufferTo:(i*320+X1)]:=Barva;
  For i:= Y1 to Y2 do mem[BufferTo:(i*320+X2)]:=Barva;
End;