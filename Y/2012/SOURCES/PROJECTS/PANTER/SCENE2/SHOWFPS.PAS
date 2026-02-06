Procedure ShowFPS(X,Y: Word);
Begin
  If fps.zobrazovat=True then
  Begin
    Blok(X,Y,X+12,Y+8,Graphics.WindowsColor,Buffer[3]);
    Ramecek(X,Y,X+12,Y+8,Graphics.FontColor,Buffer[3]);
    WriteNumber(X+2,Y+2,fps.count,True,Buffer[3]);
  End;
End;
