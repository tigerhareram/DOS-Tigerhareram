Procedure WriteKurzor(X,Y: Word);
Var I: Byte;
Begin
  For I:=2 to 4 do WritePixel(X,Y+I,Graphics.FontColor,Buffer[3]);
  For I:=1 to 5 do WritePixel(X+1,Y+I,Graphics.FontColor,Buffer[3]);
  For I:=2 to 4 do WritePixel(X+2,Y+I,Graphics.FontColor,Buffer[3]);
End;
