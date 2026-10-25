Procedure WaitButton(Klavesa: Byte);
Begin
  Inc(ButtonDelay);
  If ButtonDelay<ButtonSpeed
  then Wait(1) else Begin Key[Klavesa]:=False; ButtonDelay:=0; End;
End;


Procedure WaitMouseButton1;
Begin
  Inc(ButtonDelay);
  If ButtonDelay<ButtonSpeed
  then Wait(1) else Begin StahovaniMultiwinu1:=0; ButtonDelay:=0; End;
End;


Procedure WaitMouseButton11;
Begin
  Inc(ButtonDelay);
  If ButtonDelay<ButtonSpeed
  then Wait(1) else Begin StahovaniKasy1:=0; ButtonDelay:=0; End;
End;


Procedure WaitButton1;
Begin
  Inc(ButtonDelay);
  If ButtonDelay<ButtonSpeed
  then Wait(1) else Begin Button1Waiting:=0; ButtonDelay:=0; End;
End;