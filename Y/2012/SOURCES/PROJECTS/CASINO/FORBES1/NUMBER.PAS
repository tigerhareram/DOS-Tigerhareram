Procedure Cifra(x,y:Word;Cislo,PageTo:Byte);
Begin
  WriteSprite(x,y,Cislo*16,0,(Cislo*16)+15,31,Buffer[1],Buffer[PageTo]);
End;


Procedure SmallCifra(x,y:Word;Cislo,PageTo:Byte);
Begin
  WriteSprite(x,y,160+Cislo*8,184,167+Cislo*8,199,Buffer[1],Buffer[PageTo]);
End;


Procedure Number(x,y:Word;Cislo:Longint;Small:Boolean;PageTo:Byte);
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
                       Cifra(x+posuv,y,MRozdil,PageTo);
                       Inc(posuv,20);
                     End
                   else
                     Begin
                       SmallCifra(x+posuv,y,MRozdil,PageTo);
                       Inc(posuv,10);
                     End;
    Cislo:=MZbytek;
    If delitel>0 then delitel:=delitel div 10;
  End;
  If (Zapisovat=False) And (MRozdil=0) then
  If Small=False then Cifra(x+posuv,y,MRozdil,PageTo)
                 else SmallCifra(x+posuv,y,MRozdil,PageTo);
End;
