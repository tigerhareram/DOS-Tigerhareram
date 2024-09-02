Procedure VGA_ClearPage(Barva,Buffer:Word); assembler;
Asm
{adresa cile:}
mov ES,buffer
xor DI,DI
{rozkopirovani barvy do vsech ctyr bytu EAX:}
mov AX,barva      {EAX=????00BB}
mov AH,AL         {EAX=????BBBB}
mov BX,AX
db $66; shl AX,16 {EAX=BBBB0000}
mov AX,BX         {EAX=BBBBBBBB}
{32bitove naliti do ciloveho bufferu:}
mov CX,16000
db $66; rep stosw
End;
