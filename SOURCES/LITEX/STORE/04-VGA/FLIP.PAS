Procedure VGA_FlipPage(BufferFrom,BufferTo:Word); assembler;
Asm
push DS
mov DS,bufferfrom
xor SI,SI
mov ES,bufferto
xor DI,DI

{32bitove kopirovani:}
mov CX,16000
db $66; rep movsw

{nebo alternativne 64bitove kopirovani (aby to slo prelozit, musis byt
v rezimu $N+, protoze se vyuziva matematicky koprocesor):}
(*
mov CX,8000
 @PoQwordech:
 fild qword ptr [DS:SI]  {zkopiruje 8 B na zasobnik koprocesoru}
 fistp qword ptr [ES:DI] {presune tech 8 B ze zasobniku do cile}
 add SI,8
 add DI,8
 loop @PoQwordech
*)

pop DS
End;
