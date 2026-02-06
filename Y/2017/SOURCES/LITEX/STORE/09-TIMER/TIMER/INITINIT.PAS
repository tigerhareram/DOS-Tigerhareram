Procedure Timer_StartInit(Limit: Word);
Begin
  InitLoading:=True;
  LoadingPhase:=0;
  InitLimit:=Limit;
  Timer_Watch_Start;
  P16_SetPal(ColX[1],0,25,0);
End;