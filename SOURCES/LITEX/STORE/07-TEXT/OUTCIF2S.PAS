Procedure OutSmallCifra2SVGA(x,y:Word;Cislo:Byte);
Var xa,ya,Offset:Word;
Begin
    For ya:=0 to 4 do
    Begin
      For xa:=0 to 3 do
      Begin
        Offset:=ya*40+((Cislo*4)+xa);
        If mem[BufferC2:Offset]>0 then
        SVGA_Pixel(x+xa,y+ya,TexterColor);
      End;
    End;
End;