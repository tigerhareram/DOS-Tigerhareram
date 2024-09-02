procedure SVGA_ClearPage(barva:word);
{vyplni celou obrazovku danou barvou}
Begin
svga_barz(0,0,_maxx,_maxy,barva);
End;{svga_clearpage}
