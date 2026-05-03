procedure XVGA_ClearPage(barva:word);
{vyplni celou obrazovku danou barvou}
Begin
xvga_barZ(0,0,639,479,barva);
End;{svga_clearpage}
