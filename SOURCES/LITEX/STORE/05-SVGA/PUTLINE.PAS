procedure _PutLine(x,y,delka:word; zdroj:pointer); assembler;
{Radek grafickych dat na adrese Zdroj o delce Delka zkopiruje na obrazovku.
X,Y je pozadovane umisteni leveho konce radku na obrazovce.}
var PuvodniDS,DSZdroje:word; {push a pop nestaci, je potreba obnovovat vickrat}
Asm
mov AX,__lhy;                               mov BX,DS
add y,AX;  {pro virtualni obrazovku}        mov puvodnids,BX
mov ES,_zapisovacisegment {ES = cilovy segment}
mov AX,_MaxX
inc AX
mul y
add AX,x
adc DX,0   {DX = pocatecni banka}
mov DI,AX  {ES:DI = adresa zacatku cilove oblasti}
cmp DX,_CurBank
je @neprepinej
 mov _curbank,DX
 mov AX,DX
 mul _Granularity
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank
 mov AX,DI
@neprepinej:        {pocatecni banka nastavena}

lds SI,zdroj        {DS:SI = adresa zacatku dat ke zkopirovani}
mov dszdroje,DS

mov BX,delka
dec BX
add AX,BX        {AX = ofset konce cary}
jnc @najednou     {kdyz se vejdeme do jedne banky, jdeme dal...}

 {...jinak vyplnime nejdriv konec prvni banky:}

 mov CX,$FFFF
 sub CX,DI
 inc CX            {CX = pocet pixelu v prvni bance}

 sub delka,CX      {delka = pocet pixelu ve druhe bance}

 mov BX,CX
 shr CX,2
 and BX,3
  db $66; rep movsw  {= rep movsd, kopiruje se po 4 bytech}
 mov CX,BX
  rep movsb          {prekopirovani zbylych max. 3 bytu}

 {v posledni iteraci DI preteklo a je v nem 0, coz presne chceme}
 mov DS,puvodnids
 inc _curbank
 mov AX,_curbank
 mul _granularity   {__switchbank obcas necha v DX nejakou kravinu, tak musime znova nasobit a nejde jenom pricist granularitu}
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank   {a jsme o banku dal}
 mov DS,dszdroje

@najednou:

mov CX,delka         {CX = pocet pixelu (ve druhe bance nebo celkem)}

mov BX,CX
shr CX,2
and BX,3
 db $66; rep movsw
mov CX,BX
 rep movsb

mov DS,puvodnids
End;{_putline}
