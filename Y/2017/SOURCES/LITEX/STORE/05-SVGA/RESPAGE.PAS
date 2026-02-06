procedure SVGA_ResetPages;
{Natvrdo nastavi aktivni i viditelnou stranku na 0. Obvykle neni potreba,
slouzi jenom jako nouzovka pro pripad zmatku.}
Begin
__lhy:=0;
_setdisplayorigin(0,0);
_pagingactive:=false;
End;{svga_resetpages}
