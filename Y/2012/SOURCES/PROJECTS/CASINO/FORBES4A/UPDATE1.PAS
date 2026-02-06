Procedure UpdateGamble;
Begin
  If WinGamble.Enable=True then
  Begin
    If WinGamble.Blinking=False then
    Begin
      WriteSprite(28,114,100,166,132,181,Buffer[1],Buffer[3]); {WIN}
      WriteSprite(74,114,137,166,148,181,Buffer[1],Buffer[3]); { - }
      WriteBlok(30,132,250,0,282,18,Buffer[1],Buffer[3]); {GREEN SVETLA}
      WriteBlok(64,132,210,0,242,18,Buffer[1],Buffer[3]); {RED SVETLA}
    End else
    Begin
      If WinGambleGreen.Enable=True
      then Begin
             WriteSprite(28,114,100,166,132,181,Buffer[1],Buffer[3]);
             WriteBlok(30,132,250,0,282,18,Buffer[1],Buffer[3]);
           End
      else Begin
             WriteSprite(28,114,100,150,132,165,Buffer[1],Buffer[3]);
             WriteBlok(30,132,250,20,282,38,Buffer[1],Buffer[3]);
           End;
      If WinGambleRed.Enable=True
      then Begin
             WriteSprite(74,114,137,166,148,181,Buffer[1],Buffer[3]);
             WriteBlok(64,132,210,0,242,18,Buffer[1],Buffer[3]);
           End
      else Begin
             WriteSprite(74,114,137,150,148,165,Buffer[1],Buffer[3]);
             WriteBlok(64,132,210,20,242,38,Buffer[1],Buffer[3]);
           End;
    End;
  End;
  Blok(30,150,96,151,ColorUnknown,Buffer[3]);
  HideMouse;
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
  ShowMouse;
End;