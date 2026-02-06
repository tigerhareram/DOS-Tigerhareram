Procedure SetDefault;
Begin
  LoadGraphicsA;

  SetPal(255,63,63,63); Graphics.FontColor:=255;
  SetPal(254,0,0,63);   Graphics.WindowsColor:=254;
  SetPal(253,63,0,0);   Graphics.ButtonColor:=253;
  SetPal(252,0,0,0);    Graphics.BlackColor:=252;
  SetPal(251,63,63,63); Graphics.WhiteColor:=251;
  SetupColors;

  Graphics.vSync:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  fps.limit:=20;
  fps.prodleva:=1000 div fps.limit;
  fps.prodlevamenu:=1000 div fps.limit;
  fps.trvaniTarget:=fps.prodleva;
  fps.zobrazovat:=False;
  menu.Speed:=100;

  Ovladani.KeyUp:=72;
  Ovladani.KeyDown:=80;
  Ovladani.KeyLeft:=75;
  Ovladani.KeyRight:=77;
  Ovladani.KeyOK:=28;
  Ovladani.KeyBack:=1;

  Player[1].Job:=1; Player[1].Jmeno:='';
  Player[2].Job:=1; Player[2].Jmeno:='';
  Player[3].Job:=1; Player[3].Jmeno:='';
  Player[4].Job:=1; Player[4].Jmeno:='';
End;
