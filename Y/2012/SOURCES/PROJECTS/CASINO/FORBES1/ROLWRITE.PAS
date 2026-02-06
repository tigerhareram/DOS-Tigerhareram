Procedure KresliValce;
Var I,n: Byte;
Begin
  For I:=0 to 2 do
  Begin
    WriteSymbol(I*40,0,Valec[I].Symbol[0],True,32-Valec[I].Scroll,0);
    WriteSymbol(I*40,Valec[I].Scroll,Valec[I].Symbol[1],True,0,0);
    WriteSymbol(I*40,Valec[I].Scroll+32,Valec[I].Symbol[2],True,0,0);
    WriteSymbol(I*40,Valec[I].Scroll+64,Valec[I].Symbol[3],True,0,Valec[I].Scroll);
  End;
End;