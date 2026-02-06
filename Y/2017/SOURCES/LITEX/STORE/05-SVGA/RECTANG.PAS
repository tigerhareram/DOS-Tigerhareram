procedure SVGA_Rectangle(x1,y1,x2,y2:word; barva:byte);
{Prazdny obdelnik. x1,y1 = levy horni roh, x2,y2 = pravy dolni roh.}
Begin
svga_hline(x1,x2,y1,barva);
svga_vline(x1,y1,y2,barva);
svga_vline(x2,y1,y2,barva);
svga_hline(x1,x2,y2,barva);
End;{svga_rectangle}
