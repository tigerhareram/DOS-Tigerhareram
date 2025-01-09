Procedure Init;
Var I: Byte;
Begin
  {SetPal}
  SetPalette;

  {LoadSounds}
  If ZvukKarta=True then LoadSounds;

  {LoadFonts}
  LoadFonts;

  {Grafika LEGO vesmir}
  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);

  {ServerIPX}
  For I:=0 to 30 do AdresaServeru[I]:=' ';

  {Jmena v knihovne}
  For I:=0 to 9 do KnihovnaInfo.JmenaSesitu[I]:='';
  For I:=0 to 4 do KnihovnaInfo.JmenaBloku[I] :='';
  For I:=0 to 4 do KnihovnaInfo.JmenaKnih[I]:='';

  {Default Planetarium}
  TextD:='28121982';
  TextDny:=28;
  TextMesice:=12;
  TextRoky:=1982;

  {Texter}
  Text_Init(ColX[15]);
End;