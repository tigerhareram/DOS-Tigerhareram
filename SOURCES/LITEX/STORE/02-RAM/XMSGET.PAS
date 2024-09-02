{ Kolik je v Kb. Vraci handle (rukojet) alokovaneho bloku. }
Function RAM_GetXMS(kolik: Word): Word; Assembler;
Var vrat:word;
Asm
    mov  ah,09h          {alokuj XMS}
    mov  dx,[kolik]
    call [xmsadr]
    mov  [vrat],dx
    mov  [xmsChyba],bl   { chyba? }
    mov  ax, vrat
End;