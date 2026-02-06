Procedure ShowLevelStartScreen;
Begin
  ClearPage(Buffer[3]);

  Case Game.Level of
    1: WriteText(Buffer[2],160,0,5,5,5,120,98,'level 1',Buffer[3]);
    2: WriteText(Buffer[2],160,0,5,5,5,120,98,'level 2',Buffer[3]);
  End;

  Ramecek(0,0,319,199,ColorRed,Buffer[3]);
  If Fps2s=True then WriteText(Buffer[2],160,0,5,5,5,102,190,'press enter',Buffer[3])
                else Blok(102,190,218,194,ColorBlack,Buffer[3]);

  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure StartLevelScreen;
Begin
  Repeat
    ShowLevelStartScreen;
  Until ((Key[28]=True) or (Key[1]=True));
  PlaySound(10);
  While Key[28]=True do Begin End;
  If Key[1]=True then Begin
                        Game.LevelFinish:=True;
                        Game.Ending:=True;
                      End;
End;