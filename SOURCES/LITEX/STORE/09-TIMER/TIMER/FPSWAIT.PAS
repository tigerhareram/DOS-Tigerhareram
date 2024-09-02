Procedure Timer_fps_Wait(tics: Word);
Begin
  If fps_Waiting=False then
  Begin
    clock7:=0;
    fps_Waiting_ct:=0;
    fps_Waiting:=True;
    Repeat Until fps_Waiting_ct>=tics;
    fps_Waiting:=False;
  End;
End;