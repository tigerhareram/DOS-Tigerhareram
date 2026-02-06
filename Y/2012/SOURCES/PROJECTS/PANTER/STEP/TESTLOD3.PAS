Procedure TestLod3(X,Y:Word);
Begin
  If ((Parta.Pesky=True) and (Parta.X=Lod2.X) and (Parta.Y=Lod2.Y)) then
  Begin
    If Lod2.Obtain=True then
    Begin
      Parta.VLodi2:=True;
      Parta.Pesky:=False;
      Lod2.Klesani:=False;
    End;
  End;
End;