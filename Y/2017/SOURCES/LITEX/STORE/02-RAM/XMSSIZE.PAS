{ V celkem vraci celkovou (volnou?) velikost Xms a v blok kolik si maximalne muzeme alokovat pro 1 blok. }
{ Vetsinou jsou obe velikosti shodne. }
Procedure GetSizeXMS(Var xmsSize:Word);
Var celkem: Word;
Begin
  Asm
    mov  ah,08h  {zjisti velikost XMS}
    call [xmsadr]
    mov  [xmsChyba],bl    { chyba? }
    mov  [celkem], dx
  End;
  xmsSize:=celkem;
End;