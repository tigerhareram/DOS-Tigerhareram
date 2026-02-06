Procedure WaterBlinker;
Begin
  If Water.WaterCounter<9 then Inc(Water.WaterCounter)
                          else
  Begin
  Water.WaterCounter:=0;
    Case Water.WaterBlink of
      0: Water.WaterBlink:=1;
      1: Water.WaterBlink:=2;
      2: Water.WaterBlink:=3;
      3: Water.WaterBlink:=0;
    End; {Case End}
  End;
End;
