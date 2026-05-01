Procedure SetupScreen;
Begin
  VGA_ClearPage(ColX[0],Buffer[3]);

{ VGA_FlipPage(Buffer[1],Buffer[3]); { test grafiky Buf1}


{ VGA_WaitRetrace; }
  VGA_FlipPage(Buffer[3],Buffer[4]);
End;