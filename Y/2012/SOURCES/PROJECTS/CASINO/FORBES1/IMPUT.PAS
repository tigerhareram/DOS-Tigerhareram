Procedure ReadImput;
Begin
{X} If (Key[45]=True) and (Button[0].Open=True) then
    Begin SetAllClose; Button[0].Pressed:=True; End else Button[0].Pressed:=False;

{C} If (Key[46]=True) and (Button[1].Open=True) then
    Begin SetAllClose; Button[1].Pressed:=True; End else Button[1].Pressed:=False;

{V} If (Key[47]=True) and (Button[2].Open=True) then
    Begin SetAllClose; Button[2].Pressed:=True; End else Button[2].Pressed:=False;

{B} If (Key[48]=True) and (Button[3].Open=True) then
    Begin SetAllClose; Button[3].Pressed:=True; End else Button[3].Pressed:=False;

{N} If (Key[49]=True) and (Button[4].Open=True) then
    Begin SetAllClose; Button[4].Pressed:=True; End else Button[4].Pressed:=False;
End;