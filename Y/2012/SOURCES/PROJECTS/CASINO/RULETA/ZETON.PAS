Procedure WriteZeton(X,Y:Word);
Var polomer,Xz,Yz,Uhel: Word;
Begin
  For polomer:=0 to 1 do
  Begin
    For Uhel:=0 to 359 do
    Begin
      Xz:=Round(polomer*Sin(Pi*Uhel/180));
      Yz:=Round(polomer*Cos(Pi*Uhel/180));
      WritePixel(X+Xz,Y+Yz,160+8,Buffer[1]);
    End;
  End;

  For polomer:=2 to 7 do
  Begin
    For Uhel:=0 to 359 do
    Begin
      Xz:=Round(polomer*Sin(Pi*Uhel/180));
      Yz:=Round(polomer*Cos(Pi*Uhel/180));
      WritePixel(X+Xz,Y+Yz,160+9,Buffer[1]);
    End;
  End;

  For polomer:=8 to 9 do
  Begin
    For Uhel:=0 to 359 do
    Begin
      Xz:=Round(polomer*Sin(Pi*Uhel/180));
      Yz:=Round(polomer*Cos(Pi*Uhel/180));
      WritePixel(X+Xz,Y+Yz,160+8,Buffer[1]);
    End;
  End;

End;