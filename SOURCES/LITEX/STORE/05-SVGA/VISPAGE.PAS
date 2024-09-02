procedure _SetVisiblePage(kterou:byte);
{Danou stranku zobrazi na monitoru. Parametr viz vyse.}
Begin
_setdisplayorigin(0,(_maxy+1)*kterou);
End;{_setvisiblepage}
