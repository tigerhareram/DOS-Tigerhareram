Procedure Text_WriteDefaultFont(x1,y1,Color,ColorBack,BufferTo:Word;Mode:TMode);
Var
  FontBufP: Pointer;
  FontBufSeg: Word;
  A,I,N: Word;
  X,Y: Word;
Begin
  GetMem(FontBufP,1024);
  FontBufSeg:=Seg(FontBufP^);

  A:=0;
  For I:=0 to 124 do
  Begin
    Dec2Bin(DefaultFont[I]);
    For N:=0 to 7 do
    If b[N]>0 then mem[FontBufSeg:A+(7-N)]:=Color
              else mem[FontBufSeg:A+(7-N)]:=ColorBack;
    Inc(A,8);
  End;
  I:=0;
  For Y:=0 to 19 do
  For X:=0 to 49 do
  Begin
    If Mode=VGA   then Begin
                          VGA_Pixel(x1+X,y1+Y,mem[FontBufSeg:I],BufferTo);
                       End;
    If Mode=SVGA  then Begin
                         VGA_Pixel(x1+X,y1+Y,mem[FontBufSeg:I],BufferTo);
                       End;
    Inc(I);
  End;
  FreeMem(FontBufP,1024);
End;