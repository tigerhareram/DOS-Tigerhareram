Procedure XVGA_BarZ( x1,y1,
                     x2,y2: Integer;
                     Barva: Byte );
Begin
  setfillcolor(Barva);
  bar(x1,y1,x2,y2);
End;


