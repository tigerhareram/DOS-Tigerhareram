Procedure Init;
Var I: Byte;
Begin
  MainMenu:=0;
  MainMenuSel:=0;
  MainMenuMax:=9;
  P16_SetPal(ColX[0],0,0,0);   {Black}
  P16_SetPal(ColX[15],5,35,8); {Dark Green}

  {Jmena v knihovne}
  For I:=0 to 9 do KnihovnaInfo.JmenaSesitu[I]:='';
  For I:=0 to 4 do KnihovnaInfo.JmenaBloku[I] :='';
  For I:=0 to 4 do KnihovnaInfo.JmenaKnih[I]:='';

  {fonty}
   LoadFonts;
  _nactifont(FFont,'INT21H\space.fnt');
  _NastavFont(FFont,True);

  {klavesnice}
  NactiRozlozeni2('INT21H\en_std.rk');
  NactiRozlozeni2('INT21H\cz_std.rk');

End;