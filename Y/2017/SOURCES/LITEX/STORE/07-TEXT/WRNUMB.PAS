Procedure Text_WriteNumber(FontBuffer,FontX,FontY,FontDelka,FontVyska,mezera,x,y:Word;Cislo:Longint;BufferTo:Word;Mode:TMode);
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
    Begin
      If Mode=VGA then
      VGA_SprZ(x+posuv,y,FontX+(MRozdil*FontDelka),FontY,FontX+(MRozdil*FontDelka)+FontDelka-1,FontY+FontVyska-1,
      0,FontBuffer,BufferTo);
      If Mode=SVGA then
      SVGA_SprZ(x+posuv,y,FontX+(MRozdil*FontDelka),FontY,FontX+(MRozdil*FontDelka)+FontDelka-1,FontY+FontVyska-1,
      0,FontBuffer);
      Inc(posuv,FontDelka+mezera);
    End;
    Cislo:=MZbytek;
    If delitel>0 then delitel:=delitel div 10;
  End;
  If (Zapisovat=False) And (MRozdil=0) then
  Begin
    If Mode=VGA then
    VGA_SprZ(x+posuv,y,FontX+(MRozdil*FontDelka),FontY,FontX+(MRozdil*FontDelka)+FontDelka-1,FontY+FontVyska-1,
    0,FontBuffer,BufferTo);
    If Mode=SVGA then
    SVGA_SprZ(x+posuv,y,FontX+(MRozdil*FontDelka),FontY,FontX+(MRozdil*FontDelka)+FontDelka-1,FontY+FontVyska-1,
    0,FontBuffer);
  End;
End;
