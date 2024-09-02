Procedure Map_Sqr(Xr,Yr,Number:Word;Mode:TMode);
Var Xa,Ya: Word;
Begin
  Ya:=Number div 20;
  Xa:=Number mod 20;
  If Mode=VGA then Begin memW[BufferMap:(Yr*80+Xr)*2]:=Number; End;
  If Mode=SVGA then Begin End;
End;
