procedure XVGA_Rectangle(x1,y1,x2,y2:Integer; barva:byte);
{Prazdny obdelnik. x1,y1 = levy horni roh, x2,y2 = pravy dolni roh.}
Begin
hline(x1,x2,y1,barva);
vline(x1,y1,y2,barva);
vline(x2,y1,y2,barva);
hline(x1,x2,y2,barva);
End;{xvga_rectangle}