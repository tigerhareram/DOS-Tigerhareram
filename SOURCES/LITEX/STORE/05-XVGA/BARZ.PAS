Procedure XVGA_BarZ( x1,y1,
                     x2,y2: Integer;
                     Barva: Byte );
Var i,j: Integer;
Begin
  for i:=y1 to y2 do
  for j:=x1 to x2 do putpixel(j,i,Barva);
End;


