Procedure SaveBMPFile(filename:String; StartColor:Byte);
Var
  F: File;
  I,N: Word;
  Pixel: array[0..1] of Byte;
  Offset: Word;

  X,Y: Word;

Begin
  Assign(F,filename);
  ReWrite(F,1);

  BMP.Header.Id:=0;
  BMP.Header.Reserved:=0;
  BMP.Header.HeaderSize:=108;
  BMP.Header.RozsahX:=160;
  BMP.Header.RozsahY:=200;
  BMP.Header.BPP:=4;
  BMP.Header.BitPlanes:=1;
  BMP.Header.Komprese:=0;
  BMP.Header.HorizontalRes:=0;
  BMP.Header.VerticalRes:=0;
  BMP.Header.Colors:=16;
  BMP.Header.ImportantColors:=16;
  BMP.Header.ImageSize:=160*200 div 2;
  BMP.Header.Velikost:=108+14+64+16000;
  BMP.Header.DataOffset:=186;

  {Header}
  BlockWrite(F,BMP.Header,108);

  BMP.DataByte:=0;
  BlockWrite(F,BMP.DataByte,14);

  {Palette}
  For I:=0 to 15 do
  Begin
    P16_GetPal(StartColor+I,
               BMP.Palette[I].R,
               BMP.Palette[I].G,
               BMP.Palette[I].B);

    BMP.Palette[I].R:=BMP.Palette[I].R * 4;
    BMP.Palette[I].G:=BMP.Palette[I].G * 4;
    BMP.Palette[I].B:=BMP.Palette[I].B * 4;

    BlockWrite(F,BMP.Palette[I].B,1);
    BlockWrite(F,BMP.Palette[I].G,1);
    BlockWrite(F,BMP.Palette[I].R,1);
    BlockWrite(F,BMP.Palette[I].Res,1);
  End;

  Offset:=0;
  For Y:=199 downto 0 do
  For X:=0 to 159 do
  Begin
    mem[Buffer[0]:Offset]:=mem[Buffer[3]:(Y*320+X)]-StartColor;
    Inc(Offset)
  End;

  N:=0;
  For I:=0 to (BMP.Header.ImageSize-1) do
  Begin
    BMP.DataByte := mem[Buffer[0]:N+0];
    BMP.DataByte := BMP.DataByte SHL 4;
    BMP.DataByte := BMP.DataByte OR mem[Buffer[0]:N+1];
    BlockWrite(F,BMP.DataByte,1);
    Inc(N,2);
  End;

  Close(F);
End;