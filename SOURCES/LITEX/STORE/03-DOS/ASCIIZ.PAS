{prevede ASCII na ASCIIZ, retezec je na DS:SI}
procedure ASCIIZ; assembler;
asm
 push   si                         {uschovame index}
 xor    cx,cx                      {vymazeme pocitadlo}
 mov    cl,[si]                    {delka retezce}
 jcxz @konec {mmm nezbytny predcasny konec v pripade prazdneho retezce;
              misto jcxz by sla pouzit i jina kombinace instrukci}
@konv:                             {vytvorime retezec typu ASCIIZ}
 mov    al,[si+1]                  {precteme znak}
 mov    [si],al                    {ulozime znak}
 inc    si                         {zvysime pocitadlo}
 loop   @konv                      {je uz cely retezec?}
 mov    [si],CL                    {nula v DOSu zakoncuje retezec}
        {xxx ^CX je po skonceni loopu zarucene nulove, tak toho muzeme vyuzit
        a usetrit si nulovani jineho registru}
 pop    si                         {obnovime index}
@konec:
end;
