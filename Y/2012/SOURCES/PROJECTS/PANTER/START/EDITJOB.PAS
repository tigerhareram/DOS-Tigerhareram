Procedure WriteEditPlayerJobScreen(VolbaMenu: Byte);
Begin
  Blok(185,0,272,80,Graphics.WindowsColor,Buffer[3]);
  Ramecek(185,0,272,80,Graphics.FontColor,Buffer[3]);
  WriteSipka(189,(VolbaMenu-1)*12+6);
  WriteText(201,6,'V leŸn¡k',Buffer[3]);
  WriteText(201,18,'ZlodØj',Buffer[3]);
  WriteText(201,30,'Ninja',Buffer[3]);
  WriteText(201,42,'¬ernì m g',Buffer[3]);
  WriteText(201,54,'B¡lì m g',Buffer[3]);
  WriteText(201,66,'¬ervenì m g',Buffer[3]);
  ShowFPS(10,180);
  If Graphics.vSync=True then WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Function EditPlayerJob(Number: Byte): Byte;
Var
  Ending: Boolean;
  Volba: Byte;
Begin
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  Volba:=1;
  Player[Number].Job:=Volba;
  Repeat
    Stopky_Start;
    Blok(47,(Number-1)*50+13,55,(Number-1)*50+33,Graphics.WindowsColor,Buffer[3]);
    Blok(20,(Number-1)*50+8,39,(Number-1)*50+39,Graphics.WindowsColor,Buffer[3]);
    WriteSprite(20,(Number-1)*50+8,(Player[Number].Job-1)*20,148,(Player[Number].Job-1)*20+19,179,Buffer[1],Buffer[3]);
    WriteEditPlayerJobScreen(Volba);
    WaitMenu(fps.prodlevamenu);
    Stopky_Stop;
    FPSTrigg;
{Up}    If Key[Ovladani.KeyUp]=True then
        Begin
          While Key[Ovladani.KeyUp]=True do WaitButton(Ovladani.KeyUp);
          If Volba>1 then Dec(Volba) else Volba:=1;
          Player[Number].Job:=Volba;
        End;
{Down}  If Key[Ovladani.KeyDown]=True then
        Begin
          While Key[Ovladani.KeyDown]=True do WaitButton(Ovladani.KeyDown);
          If Volba<6 then Inc(Volba) else Volba:=6;
          Player[Number].Job:=Volba;
        End;
{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          WaitRelease;
          While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
          Player[Number].Job:=Volba;
          Blok(20,(Number-1)*50+8,39,(Number-1)*50+39,Graphics.WindowsColor,Buffer[3]);
          WriteSprite(20,(Number-1)*50+8,0,(Player[Number].Job-1)*32,19,(Player[Number].Job-1)*32+31,Buffer[1],Buffer[3]);
          Ending:=True;
        End;
{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          WaitRelease;
          While Key[Ovladani.KeyBack]=True do WaitButton(Ovladani.KeyBack);
          Player[Number].Job:=Volba;
          Blok(20,(Number-1)*50+8,39,(Number-1)*50+39,Graphics.WindowsColor,Buffer[3]);
          WriteSprite(20,(Number-1)*50+8,0,(Player[Number].Job-1)*32,19,(Player[Number].Job-1)*32+31,Buffer[1],Buffer[3]);
          Ending:=True;
        End;
  Until Ending=True;
  Blok(185,0,272,80,Graphics.BlackColor,Buffer[3]);
  FlipPage(Buffer[3],Buffer[4]);
  EditPlayerJob:=Volba;
End;
