Procedure Vrtulky;
Begin
  If Parta.Frame=0 then Parta.Frame:=1
                   else Parta.Frame:=0;
  If Lod2.Klesani=False then
  Begin
    If Lod2.Vyskomer<32 then Inc(Lod2.Vyskomer);
  End Else {Klesani=True}
  Begin
    If Lod2.Vyskomer>0 then Dec(Lod2.Vyskomer)
                       else Begin
                              Parta.VLodi2:=False;
                              Parta.Pesky:=True;
                              Lod2.Klesani:=False;
                            End;
  End;
End;
