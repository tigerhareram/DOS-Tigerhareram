Procedure WriteSipka(X,Y: Word);
Var I: Byte;
Begin
  For I:=0 to 1 do WritePixel(X+I+1,Y,Graphics.FontColor,Buffer[3]);
  For I:=0 to 2 do WritePixel(X+I+2,Y+1,Graphics.FontColor,Buffer[3]);
  For I:=0 to 3 do WritePixel(X+I+3,Y+2,Graphics.FontColor,Buffer[3]);
  For I:=0 to 7 do WritePixel(X+I,Y+3,Graphics.FontColor,Buffer[3]);
  For I:=0 to 7 do WritePixel(X+I,Y+4,Graphics.FontColor,Buffer[3]);
  For I:=0 to 3 do WritePixel(X+I+3,Y+5,Graphics.FontColor,Buffer[3]);
  For I:=0 to 2 do WritePixel(X+I+2,Y+6,Graphics.FontColor,Buffer[3]);
  For I:=0 to 1 do WritePixel(X+I+1,Y+7,Graphics.FontColor,Buffer[3]);
End;