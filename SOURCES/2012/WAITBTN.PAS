Procedure WaitButton(Klavesa: Byte);
Begin
  Inc(ButtonDelay);
  If ButtonDelay<ButtonSpeed
  then Wait(1) else Begin Key[Klavesa]:=False; ButtonDelay:=0; End;
End;