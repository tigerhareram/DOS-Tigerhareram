procedure SVGA_HLine(x1,x2,y:word; barva:word); assembler;
{Vodorovna cara z bodu x1,y do bodu x2,y. Barva je word jenom kvuli tomu,
aby se s ni pak lip pracovalo; hodnoty davejte normalne 0..255.}
var count:word;
Asm
{Nasledujici usek je optimalizovan pro paralelni zpracovani instrukci na
 Pentiich (starsim procesorum, ktere to neumi, to nepomuze ani neuskodi):}
mov AX,__lhy;                            mov DX,barva
add y,AX;  {pro virtualni obrazovku}     mov DH,DL
mov AX,_zapisovacisegment;               mov barva,DX   {barva ma ted hodnotu barvy v dolnim i hornim bytu}
mov ES,AX; {ES = cilovy segment}         mov BX,x2
mov AX,_MaxX;                            sub BX,x1
inc AX;                                  inc BX
mul y;                                   mov count,BX {count = pocet pixelu (delka cary)}
add AX,x1
adc DX,0   {DX = pocatecni banka}
mov DI,AX  {DI = ofset zacatku cary}
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

mov BX,count
dec BX
add AX,BX        {AX = ofset konce cary}
jnc @najednou     {kdyz se vejdeme do jedne banky, jdeme dal...}

 {...jinak vyplnime nejdriv konec prvni banky:}

 or CX,$FFFF       {= mov CX,$FFFF}
 sub CX,DI
 inc CX            {CX = pocet pixelu v prvni bance}

 mov AX,count
 sub AX,CX
 mov count,AX      {count = pocet pixelu ve druhe bance}

 mov AX,barva
 db $66; shl AX,16
 mov AX,barva      {EAX ma ted v kazdem bytu hodnotu barvy}

 mov BX,CX
 shr CX,2
 and BX,3
  db $66; rep stosw  {= rep stosd, kopiruje se po 4 bytech}
 mov CX,BX
  rep stosb          {prekopirovani zbylych max. 3 bytu}

 {v posledni iteraci DI preteklo a je v nem 0, coz presne chceme}

 inc _curbank
 mov AX,_curbank
 mul _granularity   {__switchbank obcas necha v DX nejakou kravinu, tak musime znova nasobit a nejde jenom pricist granularitu}
 mov DX,AX
 mov AX,$4F05
 mov BX,_zapisovaciokno
 call __switchbank   {a jsme o banku dal}

@najednou:

mov CX,count         {CX = pocet pixelu (ve druhe bance nebo cele cary)}

mov AX,barva
db $66; shl AX,16
mov AX,barva      {EAX = barva}

mov BX,CX
shr CX,2
and BX,3
 db $66; rep stosw
mov CX,BX
 rep stosb
End;{svga_hline}
