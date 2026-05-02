Procedure Str80BMP(Cesta:String);
Begin
  LoadBMPFile(Cesta,0,0,0,0,Buffer[3]);
  VGA_SprZ(160,0,0,0,159,199,1,Buffer[3],Buffer[1]);
End;
