{ziska adresu rutiny oblushy preruseni}
procedure GetIntVec(Prerus : byte; var Rutina:pointer); assembler;
asm
 mov    ah,35h                     {zjisti vektor preruseni}
 mov    al,prerus                  {cislo rutiny}
 int    21h                        {DOS}
 mov AX,ES
 les DI,rutina
 mov [ES:DI],BX
 mov [ES:DI+2],AX
end;
