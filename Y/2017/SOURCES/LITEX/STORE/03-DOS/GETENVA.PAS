{zjisti hodnotu retezce dane promenne v prostredi}
function GetEnv(Promenna : string) : string; assembler;
Asm
push   ds
mov    ah,62h                     {zjisti segment PSP}
int    21h
mov    ds,bx
lds    si,ds:[2ah]                {v PSP najdeme adresu Environmentu}
xor    si,si                      {zacina na pocatku paragrafu}
{DS:SI -> prvni znak prostredi (bude se postupne posouvat)}

xor CX,CX

les DI,@result
mov [ES:DI],CL   {vysledek:='' pro pripad, ze promennou nenajdeme}

@DalsiPromenna:
 les DI,promenna
 mov CL,[ES:DI]  {CX = delka jmena promenne}
 inc DI          {ES:DI -> prvni znak jmena (bude se posouvat)}
 xor DX,DX {DX = pocet zatim nalezenych shodnych znaku jmena}

 lodsb {AL:=jeden znak z prostredi}

 or AL,AL {#0?}
 jz @konec {druha nula v rade - jsme na konci prostredi}

 cmp SI,$8000 {nejsme uz moc daleko?}
 ja @konec    {ano}

 @PorovnaniZnaku:
 cmp AL,[ES:DI] {shoduje se ten nacteny znak s prislusnym znakem jmena?}
 jne @neshoda

 {shoda:}
  inc DX {to mame dalsi shodny znak}
  inc DI {jdeme na dalsi znak jmena}
  lodsb  {a precteme dalsi znak prostredi}
  jmp @PorovnaniZnaku

 @neshoda:
  cmp DX,CX    {je shodny usek stejne dlouhy jako zadane jmeno?}
  jne @NaDalsiPromennou {ne => je to uplne jine jmeno}
  {jestli souhlasi delky, mozna jsme na oddelovacim rovnitku:}
  cmp AL,'='
  jne @NaDalsiPromennou {ne, tohle jmeno jenom stejne zacinalo, ale je jine}
  {jmeno jsme nasli, zkopirujeme hodnotu:}
  les DI,@result
  inc DI         {ES:DI -> prvni znak vysledku}
  xor CX,CX   {budouci delka vysledku}
   @kopirovani:
   lodsb     {precti znak z prostredi}
   or AL,AL         {#0?}
   jz @dokopirovano {ano => hotovo}
   cmp CX,255        {neni to moc dlouhe?}
   jge @dokopirovano {je => hotovo}
   inc CX
   stosb  {uloz znak do vysledku}
   jmp @kopirovani
  @dokopirovano:
  les DI,@result
  mov [ES:DI],CL {ulozime delku vysledku}
  jmp @konec

 @NaDalsiPromennou: {dojedeme za nejblizsi #0 a zacneme znovu}
 or AL,AL
 jz @DalsiPromenna {uplne na zacatek hlavniho cyklu}
 lodsb
 jmp @NaDalsiPromennou

@konec:
pop DS
End;
