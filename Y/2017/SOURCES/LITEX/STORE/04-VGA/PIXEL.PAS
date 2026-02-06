Procedure VGA_Pixel(X,Y,Barva,BufferTo:Word); assembler;
Asm
mov ES,bufferto
mov AX,320
mul y
add AX,x
mov DI,AX
mov AX,barva
mov [ES:DI],AL
End;

{Na starych procesorech (8086) byla instrukce mul tak pomala, ze se vyplatilo
provest misto ni nekolik jednodussich instrukci. Protoze plati:
 n*320 = n*(256+64) = n*256+n*64 = n shl 8 + n shl 6
da se ten vypocet prepsat takhle:

Asm
mov ES,bufferto
mov DI,y
mov AX,y
shl DI,8
shl AX,6
add DI,AX
add DI,x
mov AX,barva
mov [ES:DI],AL
End

Na Pentiu (a v Dosboxu) uz ale vychazi rychleji mul, tak tu tohle nechavam
jen tak pro zajimavost.}
