function _GetRBank:word; assembler;
{promenna Curbank plati pouze pro zapisovaci okno, u cteciho musime banku
zjistit "poctive", volanim prislusne VESA sluzby:}
Asm
mov AX,$4F05           {kod sluzby - "ovladani pristupu k obrazovce"}
mov BX,_cteciokno      {do BL kod cteciho okna}
or  BX,$0100           {do BH kod podsluzby "zjisti banku"}
call __switchbank      {do toho!}
mov AX,DX              {v DX se nam vratilo cislo banky}
xor DX,DX              {DX bude vyssi word delence, tak musi byt 0}
div _granularity       {vydelime AX granularitou; v DX zustane zbytek, ale ten nas nezajima}
End;{_getrbank}        {v AX se vrati vysledek}
