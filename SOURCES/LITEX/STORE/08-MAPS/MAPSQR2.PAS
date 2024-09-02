Procedure Map_SqrSVGA(X,Y,Number:Word;BufferFrom:Word);
Var Xa,Ya: Word;
Begin
  Ya:=Number div 20;
  Xa:=Number mod 20;
  SVGA_SprZ(X,Y,Xa*8,Ya*8,Xa*8+7,Ya*8+7,0,BufferFrom);
End;
