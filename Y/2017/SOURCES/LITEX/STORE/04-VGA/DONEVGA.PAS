Procedure VGA_Done; Assembler;
Asm
    mov AX,$3
    int $10
End;
