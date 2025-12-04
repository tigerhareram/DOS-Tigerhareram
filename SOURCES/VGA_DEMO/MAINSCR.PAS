Procedure MainScreen;
Begin
  VGA_ClearPage(Col[0],Buffer[3]);

  VGA_Rectangle(0,0,319,199,Col[1],Buffer[3]);

  Text_OutText(122,100,'key UP',Buffer[3],VGA);
  Text_OutText(160,115,'Start',Buffer[3],VGA);
  Text_OutText(160,130,'Setup',Buffer[3],VGA);
  Text_OutText(160,145,'Exit',Buffer[3],VGA);
  Text_OutText(110,160,'key DOWN',Buffer[3],VGA);

  {cursor}
  Text_OutText(145,100+selection*15,'>>',Buffer[3],VGA);




  VGA_WaitRetrace;
  VGA_FlipPage(Buffer[3],Buffer[4]);
End;