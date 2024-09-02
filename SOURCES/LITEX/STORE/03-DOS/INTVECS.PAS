{nastavi novou adresu obsluhy vektoru preruseni}
procedure SetIntVec(Prerus : byte; Rutina : pointer); assembler;
asm
 push   ds
 lds DX,rutina
 mov    ah,25h                     {nastav rutinu}
 mov    al,prerus
 int    21h
 pop    ds
end; {slo by to i pomoci MOV na 1. kB pameti s vypnutym CLI}
