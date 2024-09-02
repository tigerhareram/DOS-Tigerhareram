Procedure Init;
Begin
  MainMenu:=0;
  MainMenuSel:=0;
  MainMenuMax:=8;
  P16_SetPal(ColX[0],0,0,0);   {Black}
  P16_SetPal(ColX[15],5,35,8); {Dark Green}
End;