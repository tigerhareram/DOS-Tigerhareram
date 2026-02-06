Procedure GM_Save;
Begin
  If Mapa.WorldMapOnScreen=True then SaveLoad(1)
                                else Begin
                                     End;
End;