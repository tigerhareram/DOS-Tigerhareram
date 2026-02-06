Procedure PrepareMapaScreen(CisloMapy:Byte);
Var
  X,Y: Word;
Begin
  WriteWaitScreen;
  ClearPage(Buffer[3]);
  For Y:=0 to 199 do
  For X:=0 to 319 do
  Begin
    Case CisloMapy of
      0: WritePixel(X,Y,MapId0(Y*320+X),Buffer[3]); {World Map}
    End; {Case End}
  End;
End;


Procedure WriteMapaScreen;
Begin
  If FPS2s=True then WritePixel(Parta.X div 16,Parta.Y div 16,Graphics.FontColor,Buffer[3])
                else WritePixel(Parta.X div 16,Parta.Y div 16,Graphics.WindowsColor,Buffer[3]);
  ShowFPS(10,180);
  If Graphics.Vsync=True then WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure GM_Mapa;
Var
  Ending: Boolean;
Begin
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  PrepareMapaScreen(Mapa.Id);
  Repeat
    Stopky_Start;
    WriteMapaScreen;
    WaitMenu(fps.prodlevamenu);
    Stopky_Stop;
    FPSTrigg;

{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          WaitRelease;
          Key[Ovladani.KeyBack]:=False;
          Ending:=True;
        End;

{F10}   If Key[68]=True then
        Begin
          Ending:=True;
        End;

  Until Ending=True;
End;
