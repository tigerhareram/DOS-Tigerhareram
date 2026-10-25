Procedure VyhraStorno;
Var I,A: Byte;
    KonecCounter: Word;

  Procedure FindStorno0;
  Begin
    If PrePos[0]<24
    then Begin
           Inc(PrePos[0]);
           Inc(Valec[0].Counter,24); {pootocit valec 0}
           Inc(DatRec.SpinPosun[0]);
         End
    else Begin
           PrePos[0]:=0;
           Dec(Valec[0].Counter,25*24);
           Dec(DatRec.SpinPosun[0],25);
           If PrePos[1]<24
           then Begin
                  Inc(PrePos[1]);
                  Inc(Valec[1].Counter,24); {pootocit valec 1}
                  Inc(DatRec.SpinPosun[1]);
                End
           else Begin
                  PrePos[1]:=0;
                  Dec(Valec[1].Counter,25*24);
                  Dec(DatRec.SpinPosun[1],25);
                  If PrePos[2]<24
                  then Begin
                         Inc(PrePos[2]);
                         Inc(Valec[2].Counter,24); {pootocit valec 2}
                         Inc(DatRec.SpinPosun[2]);
                       End
                  else Begin
                         PrePos[2]:=0;
                         Dec(Valec[2].Counter,25*24);
                         Dec(DatRec.SpinPosun[2],25);
                       End;
                End;
         End;
  End;

  Procedure FindStorno1;
  Begin
    If PrePos[2]<24
    then Begin
           Inc(PrePos[2]);
           Inc(Valec[2].Counter,24);
           Inc(DatRec.SpinPosun[2]);
         End
    else Begin
           PrePos[2]:=0;
           Dec(Valec[2].Counter,25*24);
           Dec(DatRec.SpinPosun[2],25);
         End;
  End;

  Procedure FindStorno2;
  Begin
    If PrePos[0]<24
    then Begin
           Inc(PrePos[0]);
           Inc(Valec[0].Counter,24);
           Inc(DatRec.SpinPosun[0]);
         End
    else Begin
           PrePos[0]:=0;
           Dec(Valec[0].Counter,25*24);
           Dec(DatRec.SpinPosun[0],25);
         End;
  End;

  Procedure FindStorno3;
  Begin
    If PrePos[1]<24
    then Begin
           Inc(PrePos[1]);
           Inc(Valec[1].Counter,24);
           Inc(DatRec.SpinPosun[1]);
         End
    else Begin
           PrePos[1]:=0;
           Dec(Valec[1].Counter,25*24);
           Dec(DatRec.SpinPosun[1],25);
         End;
  End;

  Procedure FindStorno4;
  Begin
    If PrePos[1]<24
    then Begin
           Inc(PrePos[1]);
           Inc(Valec[1].Counter,24);
           Inc(DatRec.SpinPosun[1]);
         End
    else Begin
           PrePos[1]:=0;
           Dec(Valec[1].Counter,25*24);
           Dec(DatRec.SpinPosun[1],25);
           If PrePos[2]<24
           then Begin
                  Inc(PrePos[2]);
                  Inc(Valec[2].Counter,24);
                  Inc(DatRec.SpinPosun[2]);
                End
           else Begin
                  PrePos[2]:=0;
                  Dec(Valec[2].Counter,25*24);
                  Dec(DatRec.SpinPosun[2],25);
                End;
         End;
  End;

  Procedure FindStorno5;
  Begin
    If PrePos[0]<24
    then Begin
           Inc(PrePos[0]);
           Inc(Valec[0].Counter,24);
           Inc(DatRec.SpinPosun[0]);
         End
    else Begin
           PrePos[0]:=0;
           Dec(Valec[0].Counter,25*24);
           Dec(DatRec.SpinPosun[0],25);
           If PrePos[2]<24
           then Begin
                  Inc(PrePos[2]);
                  Inc(Valec[2].Counter,24);
                  Inc(DatRec.SpinPosun[2]);
                End
           else Begin
                  PrePos[2]:=0;
                  Dec(Valec[2].Counter,25*24);
                  Dec(DatRec.SpinPosun[2],25);
                End;
         End;
  End;

  Procedure FindStorno6;
  Begin
    If PrePos[0]<24
    then Begin
           Inc(PrePos[0]);
           Inc(Valec[0].Counter,24);
           Inc(DatRec.SpinPosun[0]);
         End
    else Begin
           PrePos[0]:=0;
           Dec(Valec[0].Counter,25*24);
           Dec(DatRec.SpinPosun[0],25);
           If PrePos[1]<24
           then Begin
                  Inc(PrePos[1]);
                  Inc(Valec[1].Counter,24);
                  Inc(DatRec.SpinPosun[1]);
                End
           else Begin
                  PrePos[1]:=0;
                  Dec(Valec[1].Counter,25*24);
                  Dec(DatRec.SpinPosun[1]);
                End;
         End;
  End;

Begin
  {zalohovat vychozi stav do prevalec}
  For I:=0 to 2 do
  Begin
    PreValec[I].SymbolCounter:=Valec[I].SymbolCounter;
    For A:=0 to 4 do PreValec[I].Symbol[A]:=Valec[I].Symbol[A];
  End;

  {default setup}
  For I:=0 to 2 do
  Begin
    PrePos[I]:=0;
    PreValec[I].Counter:=0;
  End;

  {predpokladame vyhru}
  WinBude:=True;
  PreCounter:=0;

  If ((StopButton[0].Mark=False) and
      (StopButton[1].Mark=False) and
      (StopButton[2].Mark=False)) then Begin
                                         StornoSetup:=0;
                                         KonecCounter:=25*25*25;
                                       End;

  If ((StopButton[0].Mark=True) and
      (StopButton[1].Mark=True) and
      (StopButton[2].Mark=False)) then Begin
                                         StornoSetup:=1;
                                         KonecCounter:=25;
                                       End;

  If ((StopButton[0].Mark=False) and
      (StopButton[1].Mark=True) and
      (StopButton[2].Mark=True)) then Begin
                                        StornoSetup:=2;
                                        KonecCounter:=25;
                                      End;

  If ((StopButton[0].Mark=True) and
      (StopButton[1].Mark=False) and
      (StopButton[2].Mark=True)) then Begin
                                        StornoSetup:=3;
                                        KonecCounter:=25;
                                      End;

  If ((StopButton[0].Mark=True) and
      (StopButton[1].Mark=False) and
      (StopButton[2].Mark=False)) then Begin
                                         StornoSetup:=4;
                                         KonecCounter:=25*25;
                                       End;

  If ((StopButton[0].Mark=False) and
      (StopButton[1].Mark=True) and
      (StopButton[2].Mark=False)) then Begin
                                         StornoSetup:=5;
                                         KonecCounter:=25*25;
                                       End;

  If ((StopButton[0].Mark=False) and
      (StopButton[1].Mark=False) and
      (StopButton[2].Mark=True)) then Begin
                                        StornoSetup:=6;
                                        KonecCounter:=25*25;
                                      End;;

  Repeat
    WildJoker:=False;
    Vyhra.Castka:=0;

    For I:=0 to 2 do
    Begin
      {nastavit vychozi stav}
      If StopButton[I].Mark=False then
      Begin
        Valec[I].SymbolCounter:=PreValec[I].SymbolCounter;
        For A:=0 to 4 do Valec[I].Symbol[A]:=PreValec[I].Symbol[A];
        SetupSymboly(I);
        PreValec[I].Rotate:=True;
        PreValec[I].Scroll:=0;
      End;
    End;

    {nastavit delku toceni valcu}
    For I:=0 to 2 do
    Begin
      PreValec[I].Counter:=Valec[I].Counter;
    End;

    {simulovat zatoceni}
    AllStopedPre:=False;
    Repeat
      RollPre;
    Until AllStopedPre=True;

    {testovat vyhru}
    BezEfektu:=True;
    WinBude:=False;
    TestWin;

    {mame vyhru ? --> najit kombinaci bez vyhry}
    If WinBude=True then
    Begin
      Case StornoSetup of
        0: FindStorno0;
        1: FindStorno1;
        2: FindStorno2;
        3: FindStorno3;
        4: FindStorno4;
        5: FindStorno5;
        6: FindStorno6;
      End; {Case End}
    End;

    {nastavit pocatecni parametry valcu}
    If WinBude=False then
    Begin
      For I:=0 to 2 do
      Begin
        If StopButton[I].Mark=False then
        Begin
          Valec[I].SymbolCounter:=PreValec[I].SymbolCounter;
          For A:=0 to 4 do Valec[I].Symbol[A]:=PreValec[I].Symbol[A];
          SetupSymboly(I);
        End;
      End;
    End;

    Inc(PreCounter);

  Until ((WinBude=False) or (PreCounter=KonecCounter+1));
  BezEfektu:=False;
End;


Procedure RollSetup;
Var I,A: Byte;
    delka: Word;
Begin
  AllStoped:=False;

  For I:=0 to 1 do
  For A:=1 to 5 do Linie[I].Indicator[A]:=0;

  For I:=0 to 2 do
  Begin
    If StopButton[I].Mark=False then
    Begin
      Valec[I].Rotate:=True;
      Valec[I].Scroll:=0;
    End;
  End;

  For I:=1 to 5 do WinConf.Vyhra[I]:=False;
  For I:=1 to 9 do WinConf.Symbol[I]:=0;

  MainGameScreen;

  If DatRec.SpinNumber<15624
  then Inc(DatRec.SpinNumber)
  else DatRec.SpinNumber:=0;

  If DatRec.ModSpinu=0 then
  Begin {SPIN MODE 0 NAHODA}
    Valec[0].Counter:=((DatRec.SpinCounter*24)-1)+(Random(26)*24);
    Valec[1].Counter:=((DatRec.SpinCounter*24)-1)+(Random(26)*24);
    Valec[2].Counter:=((DatRec.SpinCounter*24)-1)+(Random(26)*24);
  End else
  Begin {SPIN MODE 1 CYKLUS}
    If DatRec.SpinNumberA<24
    then Begin
           Inc(DatRec.SpinNumberA);
         End
    else Begin
           DatRec.SpinNumberA:=0;
           Inc(DatRec.SpinPosunMark[1]);
           If DatRec.SpinNumberB<24
           then Begin
                  Inc(DatRec.SpinNumberB);
                End
           else Begin
                  DatRec.SpinNumberB:=0;
                  Inc(DatRec.SpinPosunMark[2]);
                  If DatRec.SpinNumberC<24
                  then Begin
                         Inc(DatRec.SpinNumberC);
                       End
                  else Begin
                         DatRec.SpinNumberC:=0;
                       End;
                End;
         End;
    Valec[0].Counter:=(((25+1)*24)-1)-(DatRec.SpinPosun[0]*24)+(DatRec.SpinPosunMark[0]*24);
    Valec[1].Counter:=(((25+2)*24)-1)-(DatRec.SpinPosun[1]*24)+(DatRec.SpinPosunMark[1]*24);
    Valec[2].Counter:=(((25+3)*24)-1)-(DatRec.SpinPosun[2]*24)+(DatRec.SpinPosunMark[2]*24);
    For I:=0 to 2 do DatRec.SpinPosun[I]:=0;
  End;

  {Odstraneni vyhry}
  If Lista[0].Enable=True then
  Begin
    If Bet=2 then
    Begin
      Obtiznost:=Random(65535);
      If Obtiznost>=DatRec.Nahoda[0] then VyhraStorno;
    End;
    If Bet=4 then
    Begin
      Obtiznost:=Random(65535);
      If Obtiznost>=DatRec.Nahoda[3] then VyhraStorno;
    End;
  End;

  If Lista[1].Enable=True then
  Begin
    Obtiznost:=Random(65535);
    If Obtiznost>=DatRec.Nahoda[6] then VyhraStorno;
  End;

  Linie[0].delka:=0;
  Linie[0].Counter:=0;
  Linie[0].CT2:=0;
  If ((Valec[0].Counter>Linie[0].delka) and (StopButton[0].Mark=False)) then Linie[0].delka:=Valec[0].Counter;
  If ((Valec[1].Counter>Linie[0].delka) and (StopButton[1].Mark=False)) then Linie[0].delka:=Valec[1].Counter;
  If ((Valec[2].Counter>Linie[0].delka) and (StopButton[2].Mark=False)) then Linie[0].delka:=Valec[2].Counter;
  Linie[0].Step:=Linie[0].delka div 5;
  Dec(Linie[0].Step);

  RiskSpeed:=2;
  RiskSpeedCounter:=3;
  RiskSPDCounter:=2;

  Case DatRec.SpinHelper of
   0: Light3:=2000;
   1: Light3:=1400;
   2: Light3:=800;
   3: Light3:=200;
  End; {Case End}

  If DatRec.ModSpinu=1 then Light3:=200;

  SymbolLight:=1;
  SymbolLightSmer:=0;
  SoundValce:=0;
  WildJoker:=False;
  Vyhra.Castka:=0;
End;