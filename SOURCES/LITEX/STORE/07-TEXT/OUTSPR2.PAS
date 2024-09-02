Procedure WriteTexterSprite2SVGA(x,y,x1,y1,x2,y2,Lenght:Word);
Var Xa,Ya: Word;
    Xlen: Word;
    Ylen: Word;
Begin
  Case Lenght of
    132: Begin
           Xlen:=x2-x1;
           Ylen:=y2-y1;
           For Ya:=0 to Ylen do
           For Xa:=0 to Xlen do
           If mem[BufferC3:((y1+Ya)*132+(x1+Xa))]>0 then
           SVGA_Pixel(x+Xa,y+Ya,mem[BufferC3:((y1+Ya)*132+(x1+Xa))]);
         End;
    205: Begin
           Xlen:=x2-x1;
           Ylen:=y2-y1;
           For Ya:=0 to Ylen do
           For Xa:=0 to Xlen do
           If mem[BufferC:((y1+Ya)*205+(x1+Xa))]>0 then
           SVGA_Pixel(x+Xa,y+Ya,mem[BufferC:((y1+Ya)*205+(x1+Xa))]);
         End;
  End; {Case End}
End;
