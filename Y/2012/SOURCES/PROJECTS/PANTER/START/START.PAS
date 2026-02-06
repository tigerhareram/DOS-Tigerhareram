Procedure WriteStartGameScreen(VolbaMenu:Byte);
Var
  I: Byte;
  X,Y: Word;
Begin
  ClearPage(Buffer[3]);
  For I:=1 to 4 do
  Begin
    Blok(12,(I-1)*50,182,(I-1)*50+48,Graphics.WindowsColor,Buffer[3]);
    Ramecek(12,(I-1)*50,182,(I-1)*50+48,Graphics.FontColor,Buffer[3]);
    Ramecek(17,(I-1)*50+5,42,(I-1)*50+43,Graphics.FontColor,Buffer[3]);
    WriteSprite(20,(I-1)*50+8,(Player[I].Job-1)*20,148,(Player[I].Job-1)*20+19,179,Buffer[1],Buffer[3]);
    WriteText(58,(I-1)*50+12,'Jm‚no:',Buffer[3]);
    WriteText(96,(I-1)*50+12,Player[I].Jmeno,Buffer[3]);
    WriteText(58,(I-1)*50+25,'Povol n¡:',Buffer[3]);
    Case Player[I].Job of
      1: WriteText(110,(I-1)*50+25,'V leŸn¡k',Buffer[3]);
      2: WriteText(110,(I-1)*50+25,'ZlodØj',Buffer[3]);
      3: WriteText(110,(I-1)*50+25,'Ninja',Buffer[3]);
      4: WriteText(110,(I-1)*50+25,'¬ernì m g',Buffer[3]);
      5: WriteText(110,(I-1)*50+25,'B¡lì m g',Buffer[3]);
      6: WriteText(110,(I-1)*50+25,'¬ervenì m g',Buffer[3]);
    End; {Case End}
  End;
  WriteSipka(2,(VolbaMenu-1)*50+22);
  Blok(264,189,319,199,Graphics.WindowsColor,Buffer[3]);
  Ramecek(264,189,319,199,Graphics.FontColor,Buffer[3]);
  WriteText(266,190,'F4=Hotovo',Buffer[3]);
  ShowFPS(10,180);
  If Graphics.Vsync=True then WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure StartNew;
Var
  Ending: Boolean;
  Volba: Byte;
Begin
  StartGame:=False;
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  Volba:=1;
  Repeat
    Stopky_Start;
    WriteStartGameScreen(Volba);
    WaitMenu(fps.prodlevamenu);
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
          EditPlayer(Volba);
        End;
{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          WaitRelease;
          While Key[Ovladani.KeyBack]=True do WaitButton(Ovladani.KeyBack);
          Ending:=True;
        End;
{F4}    If Key[62]=True then
        Begin
          StartSetup;
          SaveLoad(1);
          StartGame:=True;
          Ending:=True;
        End;
  Until Ending=True;
End;
