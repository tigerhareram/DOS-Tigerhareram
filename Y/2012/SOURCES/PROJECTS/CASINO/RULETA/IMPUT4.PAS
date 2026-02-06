Procedure ReadImput4;
Var I: Byte;
Begin
  For I:=0 to 7 do Button4[I].Pressed:=False;

{X}
  If Key[45]=True then
  Begin
    While Key[45]=True do Begin End;
    Button4[0].Pressed:=True;
  End;

{C}
  If Key[46]=True then
  Begin
    While Key[46]=True do Begin End;
    Button4[1].Pressed:=True;
  End;

{V}
  If Key[47]=True then
  Begin
    While Key[47]=True do Begin End;
    Button4[2].Pressed:=True;
  End;

{B}
  If Key[48]=True then
  Begin
    While Key[48]=True do Begin End;
    Button4[3].Pressed:=True;
  End;

{N}
  If Key[49]=True then
  Begin
    While Key[49]=True do Begin End;
    Button4[4].Pressed:=True;
  End;

{H}
  If Key[35]=True then
  Begin
    While Key[35]=True do Begin End;
    Button4[5].Pressed:=True;
  End;

{J}
  If Key[36]=True then
  Begin
    While Key[36]=True do Begin End;
    Button4[6].Pressed:=True;
  End;

{P}
  If Key[25]=True then
  Begin
    While Key[25]=True do Begin End;
    Button4[7].Pressed:=True;
  End;
End;