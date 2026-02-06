Procedure TestLod(X,Y: Word);
Begin
  If ((Parta.Pesky=True) and (Parta.X=Lod1.X) and (Parta.Y=Lod1.Y)) then
  Begin
    Parta.VLodi1:=True;
    Parta.Pesky:=False;
  End;

  If ((Parta.VLodi1=True) and ((Parta.X<>Lod1.X) or (Parta.Y<>Lod1.Y))) then
  Begin
    Parta.VLodi1:=False;
    Parta.Pesky:=True;
  End;
End;