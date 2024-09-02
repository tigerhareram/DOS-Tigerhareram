Procedure Text_OutNumber(x,y:Word;Cislo:Longint;Small:Boolean;BufferTo:Word;Mode:TMode);
Var MZbytek,MRozdil,delitel: Longint;
    Zapisovat:Boolean;
    posuv,pocet:Byte;
Begin
  posuv:=0;
  Zapisovat:=False;
  delitel:=1000000;
  For pocet:=0 to 6 do
  Begin
    If delitel>0 then
    Begin
      MRozdil:=Cislo div delitel;
      MZbytek:=Cislo mod delitel;
    End else
    Begin
      MRozdil:=0;
      MZbytek:=0;
    End;
    If MRozdil>0 then Zapisovat:=True;
    If Zapisovat=True then
    If Small=False then
                     Begin
                       If Mode=VGA then OutCifra1VGA(x+posuv,y,MRozdil,BufferTo);
                       If Mode=SVGA then OutCifra2SVGA(x+posuv,y,MRozdil);
                       Inc(posuv,6);
                     End
                   else
                     Begin
                       If Mode=VGA then OutSmallCifra1VGA(x+posuv,y,MRozdil,BufferTo);
                       If Mode=SVGA then OutSmallCifra2SVGA(x+posuv,y,MRozdil);
                       Inc(posuv,5);
                     End;
    Cislo:=MZbytek;
    If delitel>0 then delitel:=delitel div 10;
  End;

  If (Zapisovat=False) And (MRozdil=0) then
  Begin
    If Mode=VGA then
    Begin
      If Small=False then OutCifra1VGA(x+posuv,y,MRozdil,BufferTo)
                     else OutSmallCifra1VGA(x+posuv,y,MRozdil,BufferTo);
    End;
    If Mode=SVGA then
    Begin
      If Small=False then OutCifra2SVGA(x+posuv,y,MRozdil)
                     else OutSmallCifra2SVGA(x+posuv,y,MRozdil);
    End;
  End;
End;