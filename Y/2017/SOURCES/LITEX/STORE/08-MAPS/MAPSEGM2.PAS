Procedure Map_WriteSVGASegment(X,Y,X1,Y1,X2,Y2:Word;Rect1,Rect2:Byte);
Var xL1,yL1,xL2,yL2,xL3,yL3: Word;
    xLenght,yLenght: Word;
    StartX,StartY: Word;
    Xa,Ya,xd,yd,xs,ys: Word;
    MapWord: Word;
    Rect:Byte;
Begin
  xs:=X1 div 8;
  xs:=xs*8;
  xL1:=X1-xs;

  ys:=Y1 div 8;
  ys:=ys*8;
  yL1:=Y1-ys;

  xs:=X2 div 8;
  xs:=xs*8+8;
  xL2:=8-(xs-X2);

  ys:=Y2 div 8;
  ys:=ys*8+8;
  yL2:=8-(ys-Y2);

  xLenght:=X2-X1;
  yLenght:=Y2-Y1;

  xL3:=xLenght-xL1-xL2;
  yL3:=yLenght-yL1-yL2;

  If (xL1+xL2)>=8 then Inc(xL3,8);
  If (yL1+yL2)>=8 then Inc(yL3,8);

  StartX:=X1 div 8;
  StartX:=StartX*8+8;

  StartY:=Y1 div 8;
  StartY:=StartY*8+8;

  Xa:=0;
  Ya:=0;
  If ((xL3>0) and (yL3>0)) then
  For yd:=(StartY div 8) to (StartY div 8)+(yL3 div 8)-1 do
  Begin
    For xd:=(StartX div 8) to (StartX div 8)+(xL3 div 8)-1 do
    Begin
      MapWord:=memW[BufferMap:(yd*80+xd)*2];
      Map_SqrSVGA(X+Xa*8+(8-xL1),Y+Ya*8+(8-yL1),MapWord,Buffer[2]);
      Inc(Xa);
    End;
    Inc(Ya);
    Xa:=0;
  End;

  SVGA_Rectangle(X,Y,X+xLenght,Y+yLenght,Rect1);
  SVGA_Rectangle(X+7,Y+7,X+xLenght-7,Y+yLenght-7,Rect1);
  For Rect:=1 to 6 do
  SVGA_Rectangle(X+Rect,Y+Rect,X+xLenght-Rect,Y+yLenght-Rect,Rect2);

End;
