Procedure ShowBMP640(filename:String; Pozice:LongInt; X,Y:Word; StartColor: Byte);
Var
  F: File;
  I,N: Word;
  Radek: array[0..639] of Byte;

Begin
  Assign(F,filename);
  Reset(F,1);
  Seek(F,Pozice);

  {Header}
  BlockRead(F,BMP.Header,108);

  Seek(F,BMP.Header.DataOffset-Bmp.Header.Colors*4);

  {Palette}
  For I:=0 to Bmp.Header.Colors-1 do
  Begin
    BlockRead(F,BMP.Palette[I].B,1);
    BlockRead(F,BMP.Palette[I].G,1);
    BlockRead(F,BMP.Palette[I].R,1);
    BlockRead(F,BMP.Palette[I].Res,1);
    BMP.Palette[I].B:=BMP.Palette[I].B DIV 4;
    BMP.Palette[I].G:=BMP.Palette[I].G DIV 4;
    BMP.Palette[I].R:=BMP.Palette[I].R DIV 4;
    P16_SetPal(StartColor+I,BMP.Palette[I].R,BMP.Palette[I].G,BMP.Palette[I].B);
  End;

  Seek(F,BMP.Header.DataOffset);

  {Data}
  For N:=BMP.Header.RozsahY-1 downto 0 do
  Begin
    BlockRead(F,Radek,BMP.Header.RozsahX div 2);
    _PutLine(X,Y+N,(BMP.Header.RozsahX div 2),@Radek);
    BlockRead(F,Radek,BMP.Header.RozsahX div 2);
    _PutLine(X+(BMP.Header.RozsahX div 2),Y+N,(BMP.Header.RozsahX div 2),@Radek);
  End;

  Close(F);
End;