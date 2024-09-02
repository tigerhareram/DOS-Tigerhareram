Procedure SVGA_SprZ(x,y, {LH roh na obrazovce}
                    x1,y1, {LH roh ve zdroji}
                    x2,y2, {PD roh ve zdroji (pozor: musi byt vetsi nez x1,y1)}
                    Transp, {0=nepruhledne, 1=barva 0 je pruhledna}
                    BufferFrom:Word);
Var i,j:word;
Begin
If Transp=0
  then for i:=y1 to y2 do _putline(x,y+i-y1,x2-x1+1,ptr(bufferfrom,i*320+x1))
  else for i:=y1 to y2 do
        for j:=x1 to x2 do svga_pixel(x+j-x1,y+i-y1,mem[bufferfrom:i*320+j]);
End;{svga_sprz}
