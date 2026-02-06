procedure SVGA_TogglePaging; assembler;
{Prepina mezi normalnim a strankovanym rezimem. Viditelna stranka zustava vzdy
na miste a aktivni se prepne - bud na tu druhou stranku nez je viditelna,
pokud strankovani zapiname, nebo na stejnou jako viditelna, pokud ho vypiname.}
Asm
xor __lhy,_maxy+1
not _pagingactive
End;{svga_togglepaging}
