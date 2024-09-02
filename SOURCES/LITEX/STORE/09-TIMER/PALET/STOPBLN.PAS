Procedure P16_StopBlink;
Begin
  blinking:=False;
  P16_SetPal(blinkCol,PalBack[blinkCol].R,PalBack[blinkCol].G,PalBack[blinkCol].B);
End;