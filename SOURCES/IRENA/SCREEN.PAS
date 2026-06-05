Procedure Screen;
Var s: string;
    Xs,Ys : Integer;
    N: Byte;
Begin
{ XVGA_Rectangle(0,0,639,399,ColX[1]); }
  XVGA_Rectangle(0,400,639,412,ColX[1]);
  XVGA_Rectangle(0,412,639,479,ColX[1]);

  {fps counter}
  Str(fps,s);
  XVGA_BarZ(3,403,52,410,ColX[0]); {clear fps space wirh color 0} {Init define}
  writexy(3,403,'fps='+s);

  {souradnice X}
  Str(Xsour+1,s);
  XVGA_BarZ(60,403,91,410,ColX[0]);
  writexy(60,403,'X='+s);

  {souradnice Y}
  Str(Ysour+1,s);
  XVGA_BarZ(100,403,131,410,ColX[0]);
  writexy(100,403,'Y='+s);

  {Planeta}
  Str(Xsour+1,s);
  XVGA_BarZ(140,403,219,410,ColX[0]);
  writexy(140,403,'Planeta='+s);

  XVGA_BarZ(240,403,638,410,ColX[0]); {clear loading}
  writexy(240,403,'IRENA v640 - GFX & ASCII ART SHOW TOOL');
  writexy(598,403,'Ready');

  {txt 1-6}
  N:=0;
  for Ys:=1 to 6 do
  begin
    for Xs:=0 to 19 do
    begin
      XVGA_BarZ(3+(32*Xs),407+(7*Ys),3+(32*Xs)+23,407+(7*Ys)+7,ColX[0]); Inc(N);
      Str(Ys,s); writexy(3+32*Xs,407+(7*Ys),'T0'+s);
    end;
  end;

  {map}
  Ys:=7;
  begin
    for Xs:=0 to 19 do
    begin
      XVGA_BarZ(3+(32*Xs),407+(7*Ys),3+(32*Xs)+23,407+(7*Ys)+7,ColX[0]); Inc(N);
      writexy(3+32*Xs,407+(7*Ys),'MAP');
    end;
  end;

  {gra 0-7}
  Ys:=8;
  begin
    for Xs:=0 to 19 do
    begin
      XVGA_BarZ(3+(32*Xs),407+(7*Ys),3+(32*Xs)+23,407+(7*Ys)+7,ColX[0]); Inc(N);
      writexy(3+32*Xs,407+(7*Ys),'GRA');
    end;
  end;

  {gra 8-15}
  Ys:=9;
  begin
    for Xs:=0 to 19 do
    begin
      XVGA_BarZ(3+(32*Xs),407+(7*Ys),3+(32*Xs)+23,407+(7*Ys)+7,ColX[0]); Inc(N);
      writexy(3+32*Xs,407+(7*Ys),'GRA');
    end;
  end;

  {cursor selected button}
  Case Ysour of
   0..5: Begin
           XVGA_BarZ(3+(32*Xsour),407+(7*(Ysour+1)),3+(32*Xsour)+23,407+(7*(Ysour+1))+6,ColX[2]);
           Str((Ysour+1),s); writexy(3+32*Xsour,407+(7*(Ysour+1)),'T0'+s);
         End;
      6: Begin
           XVGA_BarZ(3+(32*Xsour),407+(7*(Ysour+1)),3+(32*Xsour)+23,407+(7*(Ysour+1))+6,ColX[2]);
           writexy(3+32*Xsour,407+(7*(Ysour+1)),'MAP');
         End;
      7: Begin
           XVGA_BarZ(3+(32*Xsour),407+(7*(Ysour+1)),3+(32*Xsour)+23,407+(7*(Ysour+1))+6,ColX[2]);
           writexy(3+32*Xsour,407+(7*(Ysour+1)),'GRA');
         End;
      8: Begin
           XVGA_BarZ(3+(32*Xsour),407+(7*(Ysour+1)),3+(32*Xsour)+23,407+(7*(Ysour+1))+6,ColX[2]);
           writexy(3+32*Xsour,407+(7*(Ysour+1)),'GRA');
         End;
  End; {Case End}


  WaitRetrace;
  XVGA_FlipPage(1,0);       {background layer map and txt -> to page 0}
End;