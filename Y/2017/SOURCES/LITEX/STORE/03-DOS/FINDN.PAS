{zkusi najit dalsi soubor v adresari}
procedure FindNext(var InfoSoub : SearchRec); assembler;
asm
 push   ds
 mov    ah,1ah
 lds    dx,infosoub
 int    21h
 pop ds

 mov    ah,4fh              {najdi dalsi soubor}
 int    21h

jnc @PrevodJmena
 mov doserror,18
 jmp @konec
@PrevodJmena:
les DI,infosoub
add DI,30
call ascii
mov doserror,0
@konec:
end;
