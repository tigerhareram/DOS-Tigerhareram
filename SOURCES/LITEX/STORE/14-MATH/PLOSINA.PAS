Function Math_Plosina(x,y,x1,x2,plosinaY: LongInt): Boolean;
Begin
  If (((x>=x1) and (x<=x2)) and (y=plosinaY)) then Math_Plosina:=True;
End;
