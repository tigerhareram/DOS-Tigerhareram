{ Vrati 0, pokud je ovladac XMS nainstalovany.}
{ zmeni global. prom. xmsAdr, xmsVersion, ovlXmsVersion a hmaDetect}
Function DetectXMS: Word;
Var vrat:word;
Begin
  Asm
    mov vrat,1    { predpokladame chybu }
    mov ax,4300h  { sluzba 4300h - XMS, zjisti pritomnost XMS}
    int 2Fh       { multiplexni preruseni (preruseni nainstalovanych ovladacu)}
    cmp al,80h    { (pokud mame v al 80h je XMS) }
    jnz @konec    { ...XMS neni, tak skocime na konec... }
    mov vrat,0    { XMS je!!! }
    mov ax,4310h  { sluzba 4310h, vrat adresu obsluzneho programu }
    int 2Fh
    mov word ptr [xmsadr],bx    { do xmsAdr si dame adresu kde mame ovladac }
    mov word ptr [xmsadr+2],es

    mov ah,00h             {vrat stav XMS}
    call [xmsadr]
    mov [xmsVersion],ax    { verze xms v BCD }
    mov [ovlXmsVersion],bx { verze ovladace. Opet v BCD }
    mov [hmaDetect],dx     { true/false }

   @konec:
  End;
  DetectXMS:=vrat;
End;