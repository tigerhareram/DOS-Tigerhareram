Procedure EditPlayer(CisloPlayera: Byte);
Var
  Ending: Boolean;
  Volba: Byte;
Begin
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  Volba:=1;
  Blok(0,0,10,199,Graphics.BlackColor,Buffer[3]);
  Blok(264,189,319,199,Graphics.BlackColor,Buffer[3]);
  Repeat
    Stopky_Start;
    Blok(20,(CisloPlayera-1)*50+8,39,(CisloPlayera-1)*50+39,Graphics.WindowsColor,Buffer[3]);
    WriteSprite(20,(CisloPlayera-1)*50+8,(Player[CisloPlayera].Job-1)*20,148,(Player[CisloPlayera].Job-1)*20+19,179,
    Buffer[1],Buffer[3]);

    Blok(47,(CisloPlayera-1)*50+10,55,(CisloPlayera-1)*50+40,Graphics.WindowsColor,Buffer[3]);
    If Volba=1 then WriteSipka(47,(CisloPlayera-1)*50+13)
               else WriteSipka(47,(CisloPlayera-1)*50+26);
    ShowFPS(10,180);
    If Graphics.vSync=True then WaitRetrace;
    FlipPage(Buffer[3],Buffer[4]);
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
          If Volba<2 then Inc(Volba) else Volba:=2;
        End;
{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
          Case Volba of
            1: Begin
                 Player[CisloPlayera].Jmeno:=EditPlayerName(CisloPlayera);
                 WriteText(96,(CisloPlayera-1)*50+12,Player[CisloPlayera].Jmeno,Buffer[3]);
               End;
            2: Begin
                 Blok(110,(CisloPlayera-1)*50+23,178,(CisloPlayera-1)*50+37,Graphics.WindowsColor,Buffer[3]);
                 Player[CisloPlayera].Job:=EditPlayerJob(CisloPlayera);
                 Case Player[CisloPlayera].Job of
                   1: WriteText(110,(CisloPlayera-1)*50+25,'V leŸn¡k',Buffer[3]);
                   2: WriteText(110,(CisloPlayera-1)*50+25,'ZlodØj',Buffer[3]);
                   3: WriteText(110,(CisloPlayera-1)*50+25,'Ninja',Buffer[3]);
                   4: WriteText(110,(CisloPlayera-1)*50+25,'¬ernì m g',Buffer[3]);
                   5: WriteText(110,(CisloPlayera-1)*50+25,'B¡lì m g',Buffer[3]);
                   6: WriteText(110,(CisloPlayera-1)*50+25,'¬ervenì m g',Buffer[3]);
                 End; {Case End}
               End;
          End; {Case End}
        End;
{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          WaitRelease;
          While Key[Ovladani.KeyBack]=True do WaitButton(Ovladani.KeyBack);
          Ending:=True;
        End;
  Until Ending=True;
End;
