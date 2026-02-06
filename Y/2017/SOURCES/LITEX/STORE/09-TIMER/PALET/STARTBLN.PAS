Procedure P16_StartBlink(Color,Tempo: Byte);
Begin
  blinkCol:=Color;
  P16_GetPal(blinkCol,PalBack[blinkCol].R,PalBack[blinkCol].G,PalBack[blinkCol].B);
  blinkFreq:=(8000 div (150+(Tempo*10)));
  blinkFade:=0;
  n64:=0;
  blinking:=True;
End;