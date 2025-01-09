Procedure LobbyScreen;
Var I: Byte;
Begin
  SVGA_ClearPage(ColX[0]);
  SVGA_Rectangle(0,0,639,479,ColX[15]);
  SVGA_Rectangle(0,0,639,15,ColX[15]);
  Text_OutText(5,3,'Ovladani: Sipky,Enter,Backspace,Delete,Esc, IJKL+ASQW',Buffer[0],SVGA);
  Text_OutText(420,3,'* W.O.R.L.D. *',Buffer[0],SVGA);
  Text_OutText(590,3,'Esc=Exit',Buffer[0],SVGA);
  {-------------------------------------------------------------------------}
  Text_OutText(20,30,'Network Lobby',Buffer[0],SVGA);

  SVGA_WaitRetrace;
  SVGA_FlipPage;
End;
