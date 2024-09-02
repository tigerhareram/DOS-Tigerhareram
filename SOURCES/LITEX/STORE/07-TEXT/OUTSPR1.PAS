Procedure WriteTexterSprite1VGA(x,y, {LH roh v cili}
                                x1,y1, {LH roh ve zdroji}
                                x2,y2, {PD roh ve zdroji}
                                BufferTo:Word; {segment cile}
                                Length:Word); {sirka zdroje
                                    (132 pro bufferc3 nebo 205 pro bufferc)}
                                assembler;
var sirka,MezeraVeZdroji,MezeraVCili:word;
Asm
mov BL,textercolor
{adresa leveho horniho rohu cifry v cilovem bufferu:}
mov ES,bufferto
mov AX,320
mul y
add AX,x
mov DI,AX
push DS
{urceni zdrojoveho bufferu:}
cmp length,132
je @132
cmp length,205
je @205
jmp @konec
@132:
 mov DS,bufferc3
 jmp @zacatek
@205:
 mov DS,bufferc
@zacatek:
{ofset LH rohu ve zdroji:}
mov AX,length
mul y1
add AX,x1
mov SI,AX
{sirka, vyska apod.:}
mov CX,x2
sub CX,x1
inc CX
mov sirka,CX
mov DX,y2
sub DX,y1
inc DX
mov AX,length
sub AX,CX
mov mezeravezdroji,AX
mov AX,320
sub AX,CX
mov mezeravcili,AX
{cyklus pro radky a pixely:}
 @radek:
  lodsb
  cmp BL,AL
  jnz @nic
   mov [ES:DI],BL
  @nic:
  inc DI
  loop @radek
 {radek je dokresleny, posuneme se v obou bufferech na dalsi:}
 add SI,mezeravezdroji
 add DI,mezeravcili
 mov CX,sirka
 dec DX
 jnz @radek
@konec:
pop DS
End;
