Procedure Default;
Var I: Byte;
Begin
  ButtonDelay:=20;

  For I:=0 to 8 do
  Begin
    Btn[I].Blinking:=False;
    Btn[I].Phase:=0;
    Btn[I].Counter:=0;
  End;

  Risk.Enable:=False;

  CreditShow:=True;
  VyhraShow:=False;
  For I:=1 to 8 do VkladShow[I]:=False;

  WinGamble.Enable:=False;
  JackPotPadl:=False;
  Vyhra.Castka:=0;
  AutoStart:=False;
  AutoStartTyp:=0;
  Obrazek:=0;
  ObrazekCounter:=0;
  Light1:=0;
  For I:=0 to 2 do Begin
                     StopButton[I].WaitActPhase:=0;
                     StopButton[I].Counter:=0;
                     StopButton[I].Mark:=False;
                   End;
  Zamichat:=False;
End;