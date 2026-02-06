Procedure WaitButton(Klavesa: Byte);
Begin
  Inc(menu.ButtonDelay);
  If menu.ButtonDelay<menu.Speed
  then Wait(1) else Begin Key[Klavesa]:=False; menu.ButtonDelay:=0; End;
End;