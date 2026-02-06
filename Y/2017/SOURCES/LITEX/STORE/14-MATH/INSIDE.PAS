Function Math_Inside(x,y,x1,y1,x2,y2: LongInt): Boolean;
Begin
  Math_Inside:=False;
  If (((x>=x1) and (x<=x2)) and ((y>=y1) and (y<=y2))) then Math_Inside:=True;
End;