Function Bin2Dec(b7,b6,b5,b4,b3,b2,b1,b0: Byte): Byte;
Var I: Byte;
Begin
  I:=0;
  If b7=1 then Inc(I,128);
  If b6=1 then Inc(I,64);
  If b5=1 then Inc(I,32);
  If b4=1 then Inc(I,16);
  If b3=1 then Inc(I,8);
  If b2=1 then Inc(I,4);
  If b1=1 then Inc(I,2);
  If b0=1 then Inc(I,1);
  Bin2Dec:=I;
End;