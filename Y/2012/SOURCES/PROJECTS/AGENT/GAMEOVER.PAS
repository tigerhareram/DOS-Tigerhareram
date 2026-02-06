Procedure ShowGameOverA;
Begin
  ClearPage(Buffer[3]);

  WriteText(Buffer[2],160,0,5,5,5,112,98,'game over',Buffer[3]);

  Ramecek(0,0,319,199,ColorRed,Buffer[3]);
  If Fps2s=True then WriteText(Buffer[2],160,0,5,5,5,115,190,'press esc',Buffer[3])
                else Blok(102,190,218,194,ColorBlack,Buffer[3]);

  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure ShowGameOverB;
Begin
  ClearPage(Buffer[3]);

  WriteText(Buffer[2],160,0,5,5,5,80,98,'congratulations',Buffer[3]);

  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure GameOver;
Begin
  Repeat
    If Game.AllClear=True then ShowGameOverB
                          else ShowGameOverA;
  Until Key[1]=True;
  PlaySound(10);
  While Key[1]=True do Begin End;
End;