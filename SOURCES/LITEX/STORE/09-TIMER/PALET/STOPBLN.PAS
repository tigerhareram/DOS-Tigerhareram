Procedure P16_StopBlink;
Begin
  blinking:=False;
  If XVGA_Enabled = False then P16_SetPal(blinkCol,PalBack[blinkCol].R,PalBack[blinkCol].G,PalBack[blinkCol].B)
                          else setrgbpalette(blinkCol,PalBack[blinkCol].R,PalBack[blinkCol].G,PalBack[blinkCol].B);
End;