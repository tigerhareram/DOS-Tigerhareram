Procedure Timer_StopInit;
Var Ending: Boolean;
Begin
  Ending:=False;
  Repeat
    If Timer_Watch_GetTime>InitLimit-1 then
    Begin
      Timer_Watch_Stop;
      InitLoading:=False;
      Text_WriteText(Buffer[4],270,180,5,5,1,8,24,'ok',Buffer[2],VGA);
      Ending:=True;
    End;
  Until Ending=True;
  Timer_Wait(1000); {view ok result}
  VGA_BarZ(270,180,319,199,0,Buffer[2]);
End;