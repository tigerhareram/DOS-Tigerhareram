Procedure SetupSymboly;
Var I,n: Byte;
Begin
  For I:=0 to 2 do
  Begin
    If Valec[I].SCounter<=MaxSymbolu-4 then
    Begin
      Valec[I].Symbol[0]:=Symboly[Valec[I].SCounter+0];
      Valec[I].Symbol[1]:=Symboly[Valec[I].SCounter+1];
      Valec[I].Symbol[2]:=Symboly[Valec[I].SCounter+2];
      Valec[I].Symbol[3]:=Symboly[Valec[I].SCounter+3];
      Valec[I].Symbol[4]:=Symboly[Valec[I].SCounter+4];
    End;

    If Valec[I].SCounter=MaxSymbolu-3 then
    Begin
      Valec[I].Symbol[0]:=Symboly[Valec[I].SCounter+0];
      Valec[I].Symbol[1]:=Symboly[Valec[I].SCounter+1];
      Valec[I].Symbol[2]:=Symboly[Valec[I].SCounter+2];
      Valec[I].Symbol[3]:=Symboly[Valec[I].SCounter+3];
      Valec[I].Symbol[4]:=Symboly[0];
    End;

    If Valec[I].SCounter=MaxSymbolu-2 then
    Begin
      Valec[I].Symbol[0]:=Symboly[Valec[I].SCounter+0];
      Valec[I].Symbol[1]:=Symboly[Valec[I].SCounter+1];
      Valec[I].Symbol[2]:=Symboly[Valec[I].SCounter+2];
      Valec[I].Symbol[3]:=Symboly[0];
      Valec[I].Symbol[4]:=Symboly[1];
    End;

    If Valec[I].SCounter=MaxSymbolu-1 then
    Begin
      Valec[I].Symbol[0]:=Symboly[Valec[I].SCounter+0];
      Valec[I].Symbol[1]:=Symboly[Valec[I].SCounter+1];
      Valec[I].Symbol[2]:=Symboly[0];
      Valec[I].Symbol[3]:=Symboly[1];
      Valec[I].Symbol[4]:=Symboly[2];
    End;

    If Valec[I].SCounter=MaxSymbolu then
    Begin
      Valec[I].Symbol[0]:=Symboly[Valec[I].SCounter+0];
      Valec[I].Symbol[1]:=Symboly[0];
      Valec[I].Symbol[2]:=Symboly[1];
      Valec[I].Symbol[3]:=Symboly[2];
      Valec[I].Symbol[4]:=Symboly[3];
    End;

  End;
End;


Procedure ProcessRoll;
Var I: Byte;
Begin
  For I:=0 to 2 do
  Begin
    If (Valec[I].Rotate=True) and (Valec[I].SlowMotion=False) then
    Begin
      If Valec[I].Scroll<31 then Inc(Valec[I].Scroll)
                            else Valec[I].Scroll:=0;
      If Valec[I].Counter>0 then Dec(Valec[I].Counter)
                            else Begin
                                   If ((RollCounter=BulletTimeConst) and (I=2)) then
                                   Begin
                                     Valec[2].SlowMotion:=True;
                                     Valec[2].SlowCounter1:=127;
                                     Valec[2].SlowCounter2:=0;
                                     StopPlay;
                                     PlayRaw(1);
                                   End else
                                   Begin
                                     Valec[I].Rotate:=False;
                                     StopPlay;
                                     PlaySound(I+7);
                                   End;
                                 End;

      If Valec[I].Scroll=0 then
      Begin
        If Valec[I].SCounter>0 then Dec(Valec[I].SCounter)
                               else Valec[I].SCounter:=MaxSymbolu;
        SetupSymboly;
      End;
    End;

    If (Valec[2].Rotate=True) and (Valec[2].SlowMotion=True) and
       (Valec[2].SlowCounter1>=96) and (Valec[2].SlowCounter1<=127) then
    Begin
      If Valec[2].SlowCounter2<3 then Inc(Valec[2].SlowCounter2) else
      Begin
        Valec[2].SlowCounter2:=0;
        If Valec[2].Scroll<31 then Inc(Valec[2].Scroll)
                              else Valec[2].Scroll:=0;
        If Valec[2].SlowCounter1>0 then Dec(Valec[2].SlowCounter1);
        If Valec[2].Scroll=0 then
        Begin
          If Valec[2].SCounter>0 then Dec(Valec[2].SCounter)
                                 else Valec[2].SCounter:=MaxSymbolu;
          SetupSymboly;
        End;
      End;
    End;

    If (Valec[2].Rotate=True) and (Valec[2].SlowMotion=True) and
       (Valec[2].SlowCounter1>=63) and (Valec[2].SlowCounter1<=95) then
    Begin
      If Valec[2].SlowCounter2<8 then Inc(Valec[2].SlowCounter2) else
      Begin
        Valec[2].SlowCounter2:=0;
        If Valec[2].Scroll<31 then Inc(Valec[2].Scroll)
                              else Valec[2].Scroll:=0;
        If Valec[2].SlowCounter1>0 then Dec(Valec[2].SlowCounter1);
        If Valec[2].Scroll=0 then
        Begin
          If Valec[2].SCounter>0 then Dec(Valec[2].SCounter)
                                 else Valec[2].SCounter:=MaxSymbolu;
          SetupSymboly;
        End;
      End;
    End;

    If (Valec[2].Rotate=True) and (Valec[2].SlowMotion=True) and
       (Valec[2].SlowCounter1>=32) and (Valec[2].SlowCounter1<=63) then
    Begin
      If Valec[2].SlowCounter2<16 then Inc(Valec[2].SlowCounter2) else
      Begin
        Valec[2].SlowCounter2:=0;
        If Valec[2].Scroll<31 then Inc(Valec[2].Scroll)
                              else Valec[2].Scroll:=0;
        If Valec[2].SlowCounter1>0 then Dec(Valec[2].SlowCounter1);
        If Valec[2].Scroll=0 then
        Begin
          If Valec[2].SCounter>0 then Dec(Valec[2].SCounter)
                                 else Valec[2].SCounter:=MaxSymbolu;
          SetupSymboly;
        End;
      End;
    End;

    If (Valec[2].Rotate=True) and (Valec[2].SlowMotion=True) and
       (Valec[2].SlowCounter1>=0) and (Valec[2].SlowCounter1<=31) then
    Begin
      If Valec[2].SlowCounter2<25 then Inc(Valec[2].SlowCounter2) else
      Begin
        Valec[2].SlowCounter2:=0;
        If Valec[2].Scroll<31 then Inc(Valec[2].Scroll)
                              else Valec[2].Scroll:=0;
        If Valec[2].SlowCounter1>0 then Dec(Valec[2].SlowCounter1)
                                   else Begin
                                          Valec[2].Rotate:=False;
                                          PlaySound(9);
                                        End;
        If Valec[2].Scroll=0 then
        Begin
          If Valec[2].SCounter>0 then Dec(Valec[2].SCounter)
                                 else Valec[2].SCounter:=MaxSymbolu;
          SetupSymboly;
        End;
      End;
    End;

    If (Valec[0].Rotate=False) and
       (Valec[1].Rotate=False) and
       (Valec[2].Rotate=False) then AllStoped:=True;
  End; {End For I:=0 to 2}
End;
