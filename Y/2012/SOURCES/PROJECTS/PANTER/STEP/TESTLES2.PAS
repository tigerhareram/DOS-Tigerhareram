Function TestVLese2(X,Y:Word): Boolean;
Begin
  If ((GetPole(X,Y)=24) or
      (GetPole(X,Y)=33) or
      (GetPole(X,Y)=34) or
      (GetPole(X,Y)=35) or
      (GetPole(X,Y)=44)) then TestVLese2:=True
                         else TestVLese2:=False;
End;