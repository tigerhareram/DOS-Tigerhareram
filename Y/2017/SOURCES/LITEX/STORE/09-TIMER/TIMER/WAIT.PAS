Procedure Timer_Wait(ms: LongInt);
Begin
  wait_counter:=0;
  wait_enable:=True;
  Repeat Until wait_counter=ms-1;
  wait_enable:=False;
End;