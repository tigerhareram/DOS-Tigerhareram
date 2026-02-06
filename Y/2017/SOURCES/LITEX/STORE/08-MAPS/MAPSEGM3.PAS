Procedure Map_WriteSVGAComplet(BufferFrom:Word);
Var X,Y: Word;
    MapWord:Word;
Begin
  For Y:=0 to 49 do
  For X:=0 to 79 do
  Begin
    MapWord:=memW[BufferMap:(Y*80+X)*2];
    Map_SqrSVGA(X*8,Y*8,MapWord,BufferFrom);
  End;
End;
