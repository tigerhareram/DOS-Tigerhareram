Procedure Networking(Typ: Byte);
Begin
  Case Typ of
    0: Begin
       End;
    1: Begin
       End;
    2: Begin
       End;
    3: Begin
       End;
    4: Begin
         If ClientProcess(4)=True then
         Begin
         End;
       End;
    5: Begin
       End;
    6: Begin
       End;
    7: Begin
       End;
    8: Begin
       End;
    9: Begin
         If ClientProcess(9)=True then
         Begin
           If PingBajt1=PingBajt2 then PingBajt:=PingBajt2;
         End;
       End;
  End; {Case End}
End;