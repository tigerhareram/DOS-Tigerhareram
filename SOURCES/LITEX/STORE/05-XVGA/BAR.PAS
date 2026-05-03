procedure XVGA_Bar(x,y,barva:word);
Begin
  XVGA_BarZ(x,y,x+7,y+7,barva);
End;