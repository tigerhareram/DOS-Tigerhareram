Procedure LoadBMPFile(filename:String; Pozice:LongInt; X,Y:Word; StartColor:Byte; BufferTo:Word);
Var
  F: File;
  I,N: Word;
  Pixel: array[0..7] of Byte;
  ColorsN: Word;

  xa,ya: Word;
  Offset1: Word;
  Offset2: Word;

Begin
  Assign(F,filename);
  Reset(F,1);
  Seek(F,Pozice);

  {Header}
  BlockRead(F,BMP.Header,108);
  Seek(F,BMP.Header.DataOffset-Bmp.Header.Colors*4);

  {ColorsN}
  ColorsN:=0;
  Case BMP.Header.BPP Of
    1: ColorsN:=2;   {   2 Colors }
    4: ColorsN:=16;  {  16 Colors }
    8: ColorsN:=256; { 256 Colors }
  End; {Case End}

  If ((Bmp.Header.Colors<>2) and
      (Bmp.Header.Colors<>16) and
      (Bmp.Header.Colors<>256))
  then Begin {pocet barev nestandardni}
        For I:=0 to Bmp.Header.Colors-1 do {Palette}
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
       End
  else Begin {standardni barevne hloubky}
        For I:=0 to ColorsN-1 do {Palette 2 16 256}
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
       End;

  {Data}
  Case BMP.Header.BPP Of                             { 128 64 32 16 8 4 2 1 }

    1: Begin {2 colors}
         N:=0;
         For I:=0 to (BMP.Header.ImageSize-1) do
         Begin
           BlockRead(F,BMP.DataByte,1);
           Pixel[0]:=(BMP.DataByte AND 128);
           Pixel[0]:=(Pixel[0] SHR 7);
           mem[Buffer[0]:N+0]:=StartColor+Pixel[0];
           Pixel[1]:=(BMP.DataByte AND 64);
           Pixel[1]:=(Pixel[1] SHR 6);
           mem[Buffer[0]:N+1]:=StartColor+Pixel[1];
           Pixel[2]:=(BMP.DataByte AND 32);
           Pixel[2]:=(Pixel[2] SHR 5);
           mem[Buffer[0]:N+2]:=StartColor+Pixel[2];
           Pixel[3]:=(BMP.DataByte AND 16);
           Pixel[3]:=(Pixel[3] SHR 4);
           mem[Buffer[0]:N+3]:=StartColor+Pixel[3];
           Pixel[4]:=(BMP.DataByte AND 8);
           Pixel[4]:=(Pixel[4] SHR 3);
           mem[Buffer[0]:N+4]:=StartColor+Pixel[4];
           Pixel[5]:=(BMP.DataByte AND 4);
           Pixel[5]:=(Pixel[5] SHR 2);
           mem[Buffer[0]:N+5]:=StartColor+Pixel[5];
           Pixel[6]:=(BMP.DataByte AND 2);
           Pixel[6]:=(Pixel[6] SHR 1);
           mem[Buffer[0]:N+6]:=StartColor+Pixel[6];
           Pixel[7]:=(BMP.DataByte AND 1);
           mem[Buffer[0]:N+7]:=StartColor+Pixel[7];
           Inc(N,8);
         End;
       End;

    4: Begin {16 colors}
        N:=0;
         For I:=0 to (BMP.Header.ImageSize-1) do
         Begin
           BlockRead(F,BMP.DataByte,1);
           Pixel[0]:=(BMP.DataByte SHR 4);
           mem[Buffer[0]:N+0]:=StartColor+Pixel[0];
           Pixel[1]:=(BMP.DataByte AND 15);
           mem[Buffer[0]:N+1]:=StartColor+Pixel[1];
           Inc(N,2);
         End;
       End;

    8: Begin {256 colors}
         N:=0;
         For I:=0 to (BMP.Header.ImageSize-1) do
         Begin
           BlockRead(F,BMP.DataByte,1);
           mem[Buffer[0]:N]:=StartColor+BMP.DataByte;
           Inc(N);
         End;
       End;

  End; {Case End}

  {BufferTo}
  Offset2:=0;
  For ya:=(BMP.Header.RozsahY-1) downto 0 do
  For xa:=0 to (BMP.Header.RozsahX-1) do
  Begin
    Offset1:=((Y+ya)*320+(X+xa));
    mem[BufferTo:Offset1]:=mem[Buffer[0]:Offset2];
    Inc(Offset2);
  End;

  Close(F);
End;