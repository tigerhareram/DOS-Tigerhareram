Procedure LoadGFX;
Var I: Byte;
Begin
  LoadGrPage('font2.gra',0);
  LoadBlok(160,136,0,0,159,63,Buffer[1]);
  LoadGrPage('trojky.gra',0);
  For I:=0 to 6 do
  Begin
    LoadBlok(172+I*12,0,I*16,0,I*16+11,11,Buffer[1]);
    LoadBlok(172+I*12,12,I*16,16,I*16+11,27,Buffer[1]);
  End;
  LoadGrPage('logo.gra',0);
  For I:=0 to 3 do LoadBlok(10+I*50,68,I*40,0,I*40+39,63,Buffer[2]);
  For I:=0 to 1 do LoadBlok(210+I*50,68,I*40,64,I*40+39,127,Buffer[2]);
End;