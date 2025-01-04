Procedure LoadFonts; {int21h}
Begin

  {fonty}
  _nactifont(FFont,'INT21H\space.fnt');
  _NastavFont(FFont,True);

  {klavesnice}
  NactiRozlozeni2('INT21H\en_std.rk');
  NactiRozlozeni2('INT21H\cz_std.rk');

End;