Procedure Dec2Bin(DCnum:Byte);
Var I: Byte;
Begin
  For I:=0 to 7 do b[I]:=(DCnum AND (1 SHL I)) SHR I;
End;