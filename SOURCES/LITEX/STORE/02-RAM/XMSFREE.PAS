{ Vsechny bloky, ktere jsme si alokovali bychom meli uvolnit. }
{ Jinak budou az do restartu systemu nepouzitelne pro jine aplikace. }
Procedure RAM_FreeXMS(handle: Word); Assembler;
Asm
    mov  ah,0ah
    mov  dx,[handle]
    call [xmsadr]
    mov  [xmsChyba],bl    { chyba? }
End;