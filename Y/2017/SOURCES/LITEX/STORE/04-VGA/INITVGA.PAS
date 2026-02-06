Procedure VGA_Init; Assembler;
Asm
    mov AX,$13
    int $10
End;
