Procedure WriteSetupScreen(VolbaMenu: Byte);
Begin
  ClearPage(Buffer[3]);
  Blok(0,0,63,35,Graphics.WindowsColor,Buffer[3]);
  Ramecek(0,0,63,35,Graphics.FontColor,Buffer[3]);
  WriteText(13, 3,'Ovl d n¡',Buffer[3]);
  WriteText(13,13,'Barvy',Buffer[3]);
  WriteText(13,23,'Ostatn¡',Buffer[3]);
  WriteSipka(3,(VolbaMenu-1)*10+3);
  WriteSetupOvladaniScreen(69,0,1);
  WriteSetupBarvyScreen(195,40,1);
  WriteSetupOstatniScreen(69,125,1);
  Blok(70,1,80,13,Graphics.WindowsColor,Buffer[3]);
  Blok(196,41,206,53,Graphics.WindowsColor,Buffer[3]);
  Blok(70,126,81,136,Graphics.WindowsColor,Buffer[3]);
End;


Procedure Setup;
Var
  Ending: Boolean;
  Volba: Byte;
Begin
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  Volba:=1;
  Repeat
    Stopky_Start;
    If Graphics.vSync=True then WaitRetrace;
    WriteSetupScreen(Volba);
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
          If Volba<3 then Inc(Volba) else Volba:=3;
        End;
{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
          Case Volba Of
            1: SetupOvladani;
            2: SetupBarvy;
            3: SetupOstatni;
          End; {Case End}
        End;
{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          While Key[Ovladani.KeyBack]=True do WaitButton(Ovladani.KeyBack);
          Ending:=True;
        End;
  Until Ending=True;
End;
