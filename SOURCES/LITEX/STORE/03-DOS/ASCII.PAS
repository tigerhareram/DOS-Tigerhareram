{prevede ASCIIZ na ASCII, retezec je na ES:DI}
procedure ASCII; assembler;
asm
 xor    CX,CX {mmm}                {vymazeme delku}
@delka:
 mov    al,es:[di]                 {hledame delku}
 cmp    al,0
 je     @ok                        {je-li 0, retezec konci}
 inc    CX {mmm}                   {jinak zvysime delku}
 inc    di
 jmp    @delka
@ok:
{mmm Pri nulove delce retezce je potreba preskocit prevodni cyklus, protoze
kdyby se zavolal loop, CX by podtekl, cyklus by bezel 65535krat, urcite by
neco zapsal do nealokovane pameti a program by spadl. A protoze prazdny
retezec je v obou formatech stejny (jeden nulovy byte), muzeme skoncit uplne:}
 or CX,CX
 jz @konec
{mmm "or CX,CX; jz" je ve vysledku totez jako "cmp CX,0; je", ale usetri se
trosku mista, protoze se v kodu nemusi ukladat ta nula (podobne jako nulovani
registru xorem).
Dalsi potencialni problem: ASCIIZ retezec muze mit az 65535 znaku, ale
pascalsky jenom 255. Takze ho musime oriznout:}
 cmp CX,255
 jle @DelkaOK {Instrukci jle si nejsem jisty - otestuj si, jestli to nahodou  }
  mov CX,255  {nebere jako shortint se znamenkem.                             }
 @DelkaOK:
 mov    BX,CX                      {uschovame delku}
@prevod:
 mov    al,es:[di-1]               {precteme akt.znak}
 mov    es:[di],al                 {ulozime ho doprava}
 dec    di                         {snizime ukazatel}
 loop   @prevod
 {mmm Pozor, ze instrukce loop pracuje s celym registrem CX. Proto jsem
 v celem kodu prepsal CL na CX, protoze nechat CH bez inicializace by byl
 prusvih.}
 mov es:[di],bl                 {ulozime delku retezce}
@konec:
end;
