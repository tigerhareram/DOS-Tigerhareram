Procedure PrepareGFXPage;
Var I,I2: Byte;
Begin
  Blok(0,32,159,199,15,Buffer[2]);
  WriteSprite(0,0,0,0,319,199,Buffer[1],Buffer[2]);
  For I:=0 to 9 do
  Begin
    WriteSprite(175,I*16,240,184,252,199,Buffer[1],Buffer[2]);
    Case I of
      0: Number(189,I*16-1,1,True,2);
      1: Number(189,I*16-1,2,True,2);
      2: Number(189,I*16-1,4,True,2);
      3: Number(189,I*16-1,6,True,2);
      4: Number(189,I*16-1,10,True,2);
      5: Number(189,I*16-1,20,True,2);
      6: Number(189,I*16-1,40,True,2);
      7: Number(189,I*16-1,60,True,2);
      8: Number(189,I*16-1,100,True,2);
      9: Number(189,I*16-1,200,True,2);
    End; {Case End}
  End;

  I2:=9;
  For I:=0 to 9 do
  Begin
    WriteBlok(260,I2*18,160,I*16,216,I*16+15,Buffer[2],Buffer[2]);
    Dec(I2);
  End;
  Blok(160,0,216,160,0,Buffer[2]);
  WriteBlok(160,0,0,0,79,79,Buffer[3],Buffer[2]);
  WritePixel(264,9,15,Buffer[2]);
  WritePixel(266,9,15,Buffer[2]);
  WritePixel(269,9,15,Buffer[2]);
  WritePixel(271,9,15,Buffer[2]);
  WriteBlok(160,80,80,0,175,15,Buffer[3],Buffer[2]);
  WriteBlok(160,96,80,16,175,31,Buffer[3],Buffer[2]);
  WriteBlok(160,112,0,80,79,111,Buffer[3],Buffer[2]);
  WriteBlok(160,144,0,112,79,127,Buffer[3],Buffer[2]);

  ClearPage(Buffer[1]);
  FlipPage(Buffer[2],Buffer[1]);
  ClearPage(Buffer[2]);
End;