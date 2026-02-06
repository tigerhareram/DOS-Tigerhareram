Procedure OutCifra1VGA(x,y:Word; {souradnice LH rohu cifry v cilovem bufferu}
                       Cislo:Word; {cifra k vykresleni (0..9)}
                       BufferTo:Word); assembler;
Asm
mov BL,textercolor
{adresa leveho horniho rohu cifry v cilovem bufferu:}
mov ES,bufferto
mov AX,320
mul y
add AX,x
mov DI,AX
{adresa LH rohu cifry ve zdrojovem bufferu:}
push DS
mov DS,bufferc1
mov AX,5
mul cislo
mov SI,AX
mov DX,7 {pocitadlo vysky}
 @radek: {cyklus pro kazdy radek cifry}
 mov CX,5 {sirka}
  @pixel:
  lodsb
  cmp BL,AL
  jnz @nic
   mov [ES:DI],BL
  @nic:
  inc DI
  loop @pixel
 {radek je dokresleny, posuneme se v obou bufferech na dalsi:}
 add SI,45
 add DI,315
 dec DX
 jnz @radek
pop DS
End;
