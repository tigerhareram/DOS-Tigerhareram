Procedure World;
Var
  Ending: Boolean;
Begin
  Ending:=False;
  Graphics.ShowMenu:=False;
  Graphics.ShowGame:=True;
  Mapa.Xview:=Parta.X-152;
  Mapa.Yview:=Parta.Y-96;
  WriteWaitScreen;
  LoadMapFile('world.map',0);
  LoadGraphicsB;
  Mapa.WorldMapOnScreen:=True;
  Mapa.Id:=0; {World Map}
  Repeat
    Stopky_Start;
    If Parta.Krok=True then StepMain;
    If Parta.VLodi2 then Vrtulky;

    WaterBlinker;
    WriteWorldScreen;

    If Parta.VLodi1=False then WriteObject(Lod1.X,Lod1.Y,'B',0,96,Lod1.Smer,0,Buffer[1]);

    If Parta.Y<Lod2.Y then Begin
                             WriteParta;
                             If Parta.VLodi2=False
                             then WriteObject(Lod2.X,Lod2.Y,'B',0,112,Lod2.Smer,0,Buffer[1]);
                           End;

    If Parta.Y>=Lod2.Y then Begin
                              If Parta.VLodi2=False
                              then WriteObject(Lod2.X,Lod2.Y,'B',0,112,Lod2.Smer,0,Buffer[1]);
                              WriteParta;
                            End;

    If Graphics.vSync=True then WaitRetrace;
    ShowFPS(10,180);
    FlipPage(Buffer[3],Buffer[4]);
    Wait(fps.prodleva);
    Stopky_Stop;
    FPSTrigg;

{Up}    If Key[Ovladani.KeyUp]=True then
        Begin
          If ((Parta.Krok=False) and (Lod2.Klesani=False)) then
          Begin
            Parta.Smer:=1;
            If PreStep=True then Parta.Krok:=True;
          End;
        End;

{Down}  If Key[Ovladani.KeyDown]=True then
        Begin
          If ((Parta.Krok=False) and (Lod2.Klesani=False)) then
          Begin
            Parta.Smer:=0;
            If PreStep=True then Parta.Krok:=True;
          End;
        End;

{Left}  If Key[Ovladani.KeyLeft]=True then
        Begin
          If ((Parta.Krok=False) and (Lod2.Klesani=False)) then
          Begin
            Parta.Smer:=3;
            If PreStep=True then Parta.Krok:=True;
          End;
        End;

{Right} If Key[Ovladani.KeyRight]=True then
        Begin
          If ((Parta.Krok=False) and (Lod2.Klesani=False)) then
          Begin
            Parta.Smer:=2;
            If PreStep=True then Parta.Krok:=True;
          End;
        End;

{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          If ((Parta.Krok=False) and (Parta.VLodi2=True) and (Pristani=True))
          then Lod2.Klesani:=True;
        End;

{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          If Parta.Krok=False then
          Begin
            WaitRelease;
            Key[Ovladani.KeyBack]:=False;
            GameMenu;
            Graphics.ShowMenu:=False;
            Graphics.ShowGame:=True;
          End;
        End;

{F10}   If Key[68]=True then
        Begin
          Mapa.WorldMapOnScreen:=False;
          Ending:=True;
          WaitRelease;
          Key[68]:=False;
        End;

  Until Ending=True;
  LoadGraphicsA;
End;
