Procedure Init;
Var I: Byte;
Begin
  P16_SetPal(ColX[0],0,0,0);   {Black}
  P16_SetPal(ColX[15],5,35,8); {Dark Green}

  {fonty}
  _nactifont(FFont,'INT21H\space.fnt');
  _NastavFont(FFont,True);


End;