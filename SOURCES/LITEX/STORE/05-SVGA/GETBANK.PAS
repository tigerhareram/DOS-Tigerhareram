function _GetBank:word; assembler;
{Vrati cislo aktualne nastavene banky v zapisovacim okne.}
Asm
mov AX,_curbank    {jednoduse opiseme prislusnou globalni promennou}
End;{_getbank}      {v AX se vrati vysledek}
