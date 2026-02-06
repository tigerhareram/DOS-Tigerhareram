Procedure AutoMark;
Var I,A,HodnotaSymbolu: Byte;

  Procedure FindBestKombination(I: Byte);
  Begin
    If ((Valec[0].Symbol[1]=Valec[1].Symbol[1]) and
        (Valec[0].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                  End;

    If ((Valec[0].Symbol[1]=Valec[2].Symbol[1]) and
        (Valec[0].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[1]=Valec[2].Symbol[1]) and
        (Valec[1].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[2]=Valec[1].Symbol[2]) and
        (Valec[0].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                  End;

    If ((Valec[0].Symbol[2]=Valec[2].Symbol[2]) and
        (Valec[0].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[2]=Valec[2].Symbol[2]) and
        (Valec[1].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[3]=Valec[1].Symbol[3]) and
        (Valec[0].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                   End;

    If ((Valec[0].Symbol[3]=Valec[2].Symbol[3]) and
        (Valec[0].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[3]=Valec[2].Symbol[3]) and
        (Valec[1].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[1]=Valec[1].Symbol[2]) and
        (Valec[0].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                   End;

    If ((Valec[0].Symbol[1]=Valec[2].Symbol[3]) and
        (Valec[0].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[2]=Valec[2].Symbol[3]) and
        (Valec[1].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[3]=Valec[1].Symbol[2]) and
        (Valec[0].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                  End;

    If ((Valec[0].Symbol[3]=Valec[2].Symbol[1]) and
        (Valec[0].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[2]=Valec[2].Symbol[1]) and
        (Valec[1].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[1]>=0) and
        (Valec[1].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                  End;

    If ((Valec[0].Symbol[1]=0) and (Valec[2].Symbol[1]>=0) and
        (Valec[2].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[1]=0) and (Valec[2].Symbol[1]>=0) and
        (Valec[2].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[2]=0) and (Valec[1].Symbol[2]>=0) and
        (Valec[1].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                  End;

    If ((Valec[0].Symbol[2]=0) and (Valec[2].Symbol[2]>=0) and
        (Valec[2].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[2]=0) and (Valec[2].Symbol[2]>=0) and
        (Valec[2].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[3]>=0) and
        (Valec[1].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                   End;

    If ((Valec[0].Symbol[3]=0) and (Valec[2].Symbol[3]>=0) and
        (Valec[2].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[3]=0) and (Valec[2].Symbol[3]>=0) and
        (Valec[2].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[2]>=0) and
        (Valec[1].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                   End;

    If ((Valec[0].Symbol[1]=0) and (Valec[2].Symbol[3]>=0) and
        (Valec[2].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[2]=0) and (Valec[2].Symbol[3]>=0) and
        (Valec[2].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[2]>=0) and
        (Valec[1].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                   End;

    If ((Valec[0].Symbol[3]=0) and (Valec[2].Symbol[1]>=0) and
        (Valec[2].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[2]=0) and (Valec[2].Symbol[1]>=0) and
        (Valec[2].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[1]>=0) and (Valec[1].Symbol[1]=0) and
        (Valec[0].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                  End;

    If ((Valec[0].Symbol[1]>=0) and (Valec[2].Symbol[1]=0) and
        (Valec[0].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[1]>=0) and (Valec[2].Symbol[1]=0) and
        (Valec[1].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[2]>=0) and (Valec[1].Symbol[2]=0) and
        (Valec[0].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                  End;

    If ((Valec[0].Symbol[2]>=0) and (Valec[2].Symbol[2]=0) and
        (Valec[0].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[2]>=0) and (Valec[2].Symbol[2]=0) and
        (Valec[1].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[3]>=0) and (Valec[1].Symbol[3]=0) and
        (Valec[0].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                   End;

    If ((Valec[0].Symbol[3]>=0) and (Valec[2].Symbol[3]=0) and
        (Valec[0].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[3]>=0) and (Valec[2].Symbol[3]=0) and
        (Valec[1].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[1]>=0) and (Valec[1].Symbol[2]=0) and
        (Valec[0].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                  End;

    If ((Valec[0].Symbol[1]>=0) and (Valec[2].Symbol[3]=0) and
        (Valec[0].Symbol[1]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[2]>=0) and (Valec[2].Symbol[3]=0) and
        (Valec[1].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[0].Symbol[3]>=0) and (Valec[1].Symbol[2]=0) and
        (Valec[0].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=False;
                                                   End;

    If ((Valec[0].Symbol[3]>=0) and (Valec[2].Symbol[1]=0) and
        (Valec[0].Symbol[3]=I))              then Begin
                                                    StopButton[0].Mark:=True;
                                                    StopButton[1].Mark:=False;
                                                    StopButton[2].Mark:=True;
                                                  End;

    If ((Valec[1].Symbol[2]>=0) and (Valec[2].Symbol[1]=0) and
        (Valec[1].Symbol[2]=I))              then Begin
                                                    StopButton[0].Mark:=False;
                                                    StopButton[1].Mark:=True;
                                                    StopButton[2].Mark:=True;
                                                  End;
  End;

Begin
   For I:=0 to 2 do
   For A:=1 to 3 do
   If Valec[I].Symbol[A]=0 then StopButton[I].Mark:=True; {SINGLE JOKER}

   For HodnotaSymbolu:=1 to 9 do FindBestKombination(HodnotaSymbolu);

   FindBestKombination(0); {FIND DOUBLE JOKERS}
End;