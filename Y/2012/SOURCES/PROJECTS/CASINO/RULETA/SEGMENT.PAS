Procedure WriteSegment(del1,del2,uhel2,polomer: Word; Barva: Byte);
Var Xr,Yr,Uhel,I: Word;
Begin
  For I:=del1 to del2 do
  Begin
    Uhel:=(I+uhel2) mod 360;
    Xr:=Round(polomer*Sin(Pi*Uhel/180));
    Yr:=Round(polomer*Cos(Pi*Uhel/180));
    WritePixel(283+Xr,164+Yr,160+Barva,Buffer[1]);
  End;
End;