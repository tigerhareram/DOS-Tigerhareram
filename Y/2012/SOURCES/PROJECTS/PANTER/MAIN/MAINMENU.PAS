Procedure WriteMainMenuScreen(VolbaMenu: Byte);
Begin
  ClearPage(Buffer[3]);
  Ramecek(0,0,319,199,Graphics.FontColor,Buffer[3]);
  WriteSprite(90,10,20,40,159,169,Buffer[2],Buffer[3]);
  WritePixel(131,35,Graphics.WhiteColor,Buffer[3]);
  WritePixel(176,35,Graphics.WhiteColor,Buffer[3]);
  Blok(108,147,200,192,Graphics.WindowsColor,Buffer[3]);
  Ramecek(108,147,200,192,Graphics.FontColor,Buffer[3]);
  WriteText(123,150,'Nov  hra',Buffer[3]);
  WriteText(123,160,'NaŸ¡st pozici',Buffer[3]);
  WriteText(123,170,'Nastaven¡',Buffer[3]);
  WriteText(123,180,'Exit',Buffer[3]);
  WriteSipka(112,(VolbaMenu-1)*10+151);
End;


Procedure MainMenu;
Var
  Ending: Boolean;
  Volba: Byte;
Begin
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  Volba:=1; {New Game}
  Repeat
    Stopky_Start;
    If Graphics.vSync=True then WaitRetrace;
    WriteMainMenuScreen(Volba);
    ShowFPS(10,180);
    FlipPage(Buffer[3],Buffer[4]);
    Waitmenu(fps.prodlevamenu);
    Stopky_Stop;
    FPSTrigg;
{Up}    If Key[Ovladani.KeyUp]=True then
        Begin
          While Key[Ovladani.KeyUp]=True do WaitButton(Ovladani.KeyUp);
          If Volba>1 then Dec(Volba) else Volba:=1;
        End;
{Down}  If Key[Ovladani.KeyDown]=True then
        Begin
          While Key[Ovladani.KeyDown]=True do WaitButton(Ovladani.KeyDown);
          If Volba<4 then Inc(Volba) else Volba:=4;
        End;
{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
          Case Volba Of
            1: Begin
                 StartNew;
                 If StartGame=True then World;
                 StartGame:=False;
               End;
            2: Begin
                 SaveLoad(2);
                 If StartGame=True then World;
                 StartGame:=False;
               End;
            3: Setup;
            4: Ending:=True;
          End; {Case End}
        End;
{F10}   If Key[68]=True then Ending:=True;
  Until Ending=True;
End;
