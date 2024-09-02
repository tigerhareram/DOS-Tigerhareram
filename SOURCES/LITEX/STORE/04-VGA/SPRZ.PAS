Procedure VGA_SprZ(x,y, {LH roh v cili (pozor: obrazek nesmi presahnout okraj ciloveho bufferu)}
                   x1,y1, {LH roh ve zdroji}
                   x2,y2, {PD roh ve zdroji (pozor: musi byt vetsi nez x1,y1)}
                   Transp, {0=nepruhledne, 1=barva 0 je pruhledna}
                   BufferFrom,BufferTo: Word);
Var Xa,Ya: Word;
    Xlen: Word;
    Ylen: Word;
    PocetRadku,PocetDwordu,PocetBytu,Mezera:word;
Begin
If Transp=0
  then asm
       push DS
       {segment zdroje = bufferfrom:}
       mov AX,bufferfrom
       mov DS,AX
       {segment cile = bufferto:}
       mov AX,bufferto
       mov ES,AX
       {ofset leveho horniho rohu zdroje = 320*y1+x1:}
       mov AX,320
       mul y1
       add AX,x1
       mov SI,AX
       {ofset leveho horniho rohu cile = 320*y+x:}
       mov AX,320
       mul y
       add AX,x
       mov DI,AX
       {pocet radku = y2-y1+1:}
       mov AX,y2
       sub AX,y1
       inc AX
       mov PocetRadku,AX
       {sirka a mezera mezi koncem jednoho radku a zacatkem dalsiho:}
       mov AX,x2
       sub AX,x1
       inc AX {sirka = x2-x1+1}
       mov BX,320
       sub BX,AX
       mov mezera,BX {mezera = 320-sirka}
       mov BX,AX
       shr BX,2 {pocet dwordu = sirka div 4}
       mov PocetDwordu,BX
       and AX,3 {pocet bytu = sirka mod 4}
       mov PocetBytu,AX
       {cyklus pres vsechny radky:}
        @KopirujRadek:
        {kopirovani po dwordech:}
        mov CX,PocetDwordu
        db $66; rep movsw {rep movsd}
        {kopirovani zbylych bytu:}
        mov CX,PocetBytu
        rep movsb
        {posun na dalsi radek:}
        add SI,mezera
        add DI,mezera
        dec PocetRadku
        jnz @KopirujRadek
       pop DS
       end
  else Begin {Transp=1}
       Xlen:=x2-x1;
       Ylen:=y2-y1;
       For Ya:=0 to Ylen do
        For Xa:=0 to Xlen do
         If mem[BufferFrom:((y1+Ya)*320+(x1+Xa))]>0 then
         mem[BufferTo:((y+Ya)*320+(x+Xa))]:=mem[BufferFrom:((y1+Ya)*320+(x1+Xa))];
       End;
End;
