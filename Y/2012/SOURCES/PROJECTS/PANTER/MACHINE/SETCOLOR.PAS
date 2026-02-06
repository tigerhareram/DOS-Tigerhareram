Procedure SetupColors;
Begin
  GetPal(255,Graphics.FontColorR,Graphics.FontColorG,Graphics.FontColorB);
  GetPal(254,Graphics.WindowsColorR,Graphics.WindowsColorG,Graphics.WindowsColorB);
  ChangeTexterColor(Graphics.FontColor);
End;