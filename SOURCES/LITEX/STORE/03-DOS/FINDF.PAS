{najde prvni soubor a nastavi parametry DTA}
procedure FindFirst(Cesta : string; Atribut : word; var InfoSoub : SearchRec); assembler;
asm
 push   ds
 mov    ah,1ah                     {funkce: nastav DTA}
 lds    dx,infosoub                {adresa pole}
 int    21h                        {volame danou funkci}

 lds    si,cesta                   {prevedeme na DOSovy format}
 call   asciiz
 mov    DX,SI                      {maska souboru+adresar}
 mov    cx,atribut                 {co hledame}
 mov    ah,4eh                     {najdi prvni soubor}
 int    21h

pop    ds
jnc @PrevodJmena        {CF=1 znamena chybu}
 mov    doserror,18                {soubor nenalezen}
 jmp @konec
@PrevodJmena:
les DI,infosoub
add DI,30   {ofset jmena}
call ascii  {jmeno jsme dostali v ASCIIZ, tak ho prevedeme na string}
mov doserror,0
@konec:
les DI,cesta
call ascii
end;
