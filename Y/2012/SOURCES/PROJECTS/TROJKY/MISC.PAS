Procedure FillBrickFallCounter;
Begin
  BrickFallCounter:=20-(Level*2);
  If Level=9 then BrickFallCounter:=3;
End;


Procedure WaitButton(Klavesa,Speed: Byte);
Begin
  Inc(ButtonDelay);
  If ButtonDelay<Speed
  then Wait(1)
  else Begin
         Key[Klavesa]:=False;
         ButtonDelay:=0;
       End;
End;