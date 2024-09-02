Procedure OutCifra2SVGA(x,y:Word;Cislo:Byte);
Var xa,ya,Offset:Word;
Begin
    For ya:=0 to 6 do
    Begin
      For xa:=0 to 4 do
      Begin
        Offset:=ya*50+((Cislo*5)+xa);
        If mem[BufferC1:Offset]>0 then
        SVGA_Pixel(x+xa,y+ya,TexterColor);
      End;
    End;
End;