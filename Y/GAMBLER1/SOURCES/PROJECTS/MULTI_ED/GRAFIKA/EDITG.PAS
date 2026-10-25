Procedure EditG;
Var I: Byte;
Begin
  EndingEditG:=False;
  For I:=0 to 15 do Getpal(CisloStranky*16+I,Barva[I].R,Barva[I].G,Barva[I].B);
  Repeat
    If TABGrafikaG0=True then
    Begin
      StartEditG0;
      TABGrafikaG0:=False;
    End;
    If TABGrafikaG1=True then
    Begin
      StartEditG1;
      TABGrafikaG1:=False;
    End;
    If TABGrafikaG2=True then
    Begin
      StartEditG2;
      TABGrafikaG2:=False;
    End;
    If TABGrafikaG3=True then
    Begin
      StartEditG3;
      TABGrafikaG3:=False;
    End;
  Until EndingEditG=True;
End;