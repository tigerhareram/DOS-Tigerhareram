Procedure Initialize;
Begin
  SetPal(ColorRed,40,5,5);
  SetPal(ColorBlack,0,0,0);
  SetPal(ColorWhite,63,63,63);

  LoadDefaultFont(160,0,ColorRed,Buffer[2]);

  fps.trvaniTarget:=400; {20fps}
End;