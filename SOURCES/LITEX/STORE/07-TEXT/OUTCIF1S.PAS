Procedure OutSmallCifra1VGA(x,y:Word; {LH roh cifry v cili}
                            Cislo:Word; {cifra k vypsani (0..9)}
                            BufferTo:Word); assembler;
Asm
mov BL,textercolor
mov ES,bufferto
mov AX,320
mul y
add AX,x
mov DI,AX
push DS
mov DS,bufferc2
mov SI,cislo
shl SI,2 {*4}
mov DX,5
 @radek:
 mov CX,4
  @pixel:
  lodsb
  cmp BL,AL
  jnz @nic
   mov [ES:DI],BL
  @nic:
  inc DI
  loop @pixel
 add SI,36
 add DI,316
 dec DX
 jnz @radek
pop DS
End;
