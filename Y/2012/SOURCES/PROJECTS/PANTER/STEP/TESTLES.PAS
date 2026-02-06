Procedure TestVLese(X,Y:Word);
Begin
  If ((GetPole(X,Y)=24) or
      (GetPole(X,Y)=33) or
      (GetPole(X,Y)=34) or
      (GetPole(X,Y)=35) or
      (GetPole(X,Y)=44)) then Parta.VLese:=True
                         else Parta.VLese:=False;
End;