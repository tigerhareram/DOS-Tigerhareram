Procedure Map_SqrVGA(X,Y,Number,BufferTo:Word);
Var Xa,Ya: Word;
Begin
  Ya:=Number div 20;
  Xa:=Number mod 20;
  VGA_SprZ(X,Y,Xa*8,Ya*8,Xa*8+7,Ya*8+7,0,Buffer[2],BufferTo);
End;
