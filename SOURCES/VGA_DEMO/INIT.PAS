Procedure Init;
Var R,G,B : Byte;

Begin

  Col[0]:=240;
  P16_SetPal(Col[0],0,0,0);

  {fonty}
  _nactifont(FFont,'INT21H\space.fnt');
  _NastavFont(FFont,True);

  {klavesnice}
  NactiRozlozeni2('INT21H\en_std.rk');
  NactiRozlozeni2('INT21H\cz_std.rk');

  Col[0]:=0;
  P16_SetPal(Col[0],0,0,0);

  Col[1]:=255;
  P16_SetPal(Col[1],10,46,5);

  Text_WriteDefaultFont(160,0,Col[1],Col[0],Buffer[1],VGA);

  selection:=1;

  LoadGRAFile('DATA\data.gra',0,1);
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);       {LOAD}

  LoadMAPFile('DATA\level.map',0);
  X1:=0;
  Y1:=0;
  X2:=319;
  Y2:=199;

End;