Procedure HorseSound;
Begin
  If DatRec.SBEnable=True
  then SBPlayRaw(1)
  else PlaySound(14);
End;

Procedure RiskniXkrat(horni: Boolean;start: Byte);
Var I: Byte;
Begin
    RiskCounter:=start;
    Repeat
     If AutoStart=True then
     Begin
      MainGameScreen;
      Risk.Enable:=True;
      Risk.Blinking:=True;
      For I:=0 to 8 do
      Begin
        Btn[I].Blinking:=False;
        Btn[I].Phase:=0;
        SetButtonColor(I);
      End;
      Btn[0].Blinking:=True;
      Btn[4].Blinking:=True;
      Btn[5].Blinking:=True;
      VyhraShow:=True;
      CreditShow:=False;
      RiskRandom1:=Random(2); {nula nebo jedna}
      Case RiskCounter of
        0: Begin
             RiskRandom2:=Random(10)+40; {counter}
           End;
        1: Begin
             RiskRandom2:=Random(10)+50; {counter}
           End;
      End; {Case End}
      RiskRandom3:=Random(2);
      If RiskRandom3=0 then Risk.Phase:=0
                       else Risk.Phase:=1;
      RiskRandom4:=Random(65535);
      RiskAuto:=True;
      If horni=True then RiskHorni
                    else RiskDolni;
      VyhraShow:=True;
      CreditShow:=False;
      MainGameScreen;
     End else
     Begin
       RiskCounter:=2;
       RiskAuto:=False;
     End;
    Until RiskCounter=2;
    NextVyhra:=0;
End;

Procedure Roll;
Var I: Byte;
    Counting: Word;
Begin
  If Zamichat=False
  then Begin
         If AutoStart=True then
         Begin
           AutoMark;
         End;
       End
  else Begin
         Zamichat:=False;
         For I:=0 to 2 do StopButton[I].Mark:=False;
       End;

  For I:=0 to 8 do
  Begin
    Btn[I].Blinking:=False;
    Btn[I].Smer:=0;
    Btn[I].Phase:=0;
    SetButtonColor(I);
  End;
  BtnCol.Blinking:=False;
  BtnCol.Smer:=0;
  BtnCol.Phase:=2;
  SetButtonColor(12);

  For I:=0 to 2 do
  Begin
    StopButton[I].Blinking:=False;
    If StopButton[I].Mark=True then
    Begin
      StopButton[I].Phase:=4;
      SetButtonColor(I+9);
    End else
    Begin
      StopButton[I].Phase:=0;
      SetButtonColor(I+9);
    End;
  End;

  MainGameScreen;

  RollSetup;
  Repeat
    RollProc;
    KresliValce(SymbolLight,LightJ,LightK,LightL,Buffer[4]);
    Wait(DatRec.RollSpeed);
    TestStopAutoStart;
  Until AllStoped=True;

  SymbolLight:=0;

  KresliValce(SymbolLight,LightJ,LightK,LightL,Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);

  TestWin;

  KresliValce(SymbolLight,LightJ,LightK,LightL,Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);

{HORNI HRA}
If ((Lista[1].Enable=True) and (Vyhra.Castka>0)) then
Begin
  Case AutoStartTyp of
    0: Begin
       End;
    1: Begin
         If Vyhra.Castka<100 then HorseSound;
       End;
    2: Begin
         If Vyhra.Castka<100 then HorseSound;
       End;
    3: Begin
         If Vyhra.Castka>=100 then HorseSound;
       End;
    4: Begin
         If Vyhra.Castka>=100 then HorseSound;
       End;
    5: Begin
         HorseSound;
       End;
    6: Begin
         HorseSound;
       End;
  End; {Case End}

  If AutoStart=True then
  Begin
Case AutoStartTyp of
0: Begin
     Risk.Enable:=False;
     Risk.Blinking:=False;
     For I:=0 to 8 do
     Begin
       Btn[I].Blinking:=False;
       Btn[I].Phase:=0;
       SetButtonColor(I);
     End;
     VyhraShow:=False;
     CreditShow:=True;
     MainGameScreen;
   End;
1: Begin
     If Vyhra.Castka<100 then RiskniXkrat(True,1);
   End;
2: Begin
     If Vyhra.Castka<100 then RiskniXkrat(True,0);
   End;
3: Begin
     If Vyhra.Castka>=100 then RiskniXkrat(True,1);
   End;
4: Begin
     If Vyhra.Castka>=100 then RiskniXkrat(True,0);
   End;
5: Begin
     RiskniXkrat(True,1);
   End;
6: Begin
     RiskniXkrat(True,0);
   End;
End; {Case End}
  End else
  Begin
    MainGameScreen;
    Risk.Enable:=True;
    Risk.Blinking:=True;
    For I:=0 to 8 do
    Begin
      Btn[I].Blinking:=False;
      Btn[I].Phase:=0;
      SetButtonColor(I);
    End;
    BtnCol.Blinking:=True;
    Btn[0].Blinking:=True;
    Btn[4].Blinking:=True;
    Btn[5].Blinking:=True;
    VyhraShow:=True;
    CreditShow:=True;
    RiskCounter:=0;
    RiskAuto:=True;
    RiskRandom3:=Random(2);
    If RiskRandom3=0 then Risk.Phase:=0
                     else Risk.Phase:=1;
    For I:=0 to 14 do Wait(DatRec.fpsProdleva);
    If DatRec.SBEnable=True
    then SBPlayRaw(1)
    else PlaySound(14);
    If DatRec.NahodnyRisk=False then RiskHorni
                                else RiskHorniNahodny;
    VyhraShow:=True;
    CreditShow:=True;
    NextVyhra:=0;
    MainGameScreen;
  End;
  Risk.Enable:=False;
  Risk.Blinking:=False;
  For I:=0 to 8 do
  Begin
    Btn[I].Blinking:=False;
    Btn[I].Phase:=0;
    SetButtonColor(I);
  End;
  VyhraShow:=False;
  CreditShow:=True;
  MainGameScreen;
End else
Begin
  VyhraShow:=False;
  CreditShow:=True;
  MainGameScreen;
End;

  {HORNI HRA NASOBIC + BONUS}
  If ((Lista[1].Enable=True) and (Vyhra.Castka>0)) then {BONUS}
  Begin
    Vyhra.Castka:=Vyhra.Castka*Nasobic;
    VyhraShow:=True;
    CreditShow:=False;
    MainGameScreen;
    For I:=0 to 79 do
    Begin
      TestStopAutoStart;
      Wait(DatRec.fpsProdleva);
    End;

    For I:=0 to 8 do
    Begin
      Btn[I].Blinking:=False;
      Btn[I].Phase:=0;
      SetButtonColor(I);
    End;
    MainGameScreen;

    If Vyhra.Castka>750 then
    Begin
      Inc(Bonus,Vyhra.Castka);
      Vyhra.Castka:=0;
      If DatRec.SBEnable=True
      then SBPlayRaw(35)
      else PlaySound(22);
      WinGamble.Enable:=True;
      MainGameScreen;
      BetStore:=Bet;
      BetMultiStore:=BetMulti;

      While ((Credit>=5) and (Bonus>0)) do
      Begin
        Dec(Credit,5);
        MainGameScreen;

        For I:=0 to 8 do
        Begin
          Btn[I].Blinking:=False;
          Btn[I].Phase:=0;
          SetButtonColor(I);
        End;
        MainGameScreen;

        WinGamble.Blinking:=True;
        WinGambleGreen.Enable:=False;
        WinGambleRed.Enable:=False;
        WinGamble.Counter:=0;
        RandomGamble:=Random(65535);
        If RandomGamble<DatRec.Nahoda[9] then WinGamble.Counter2:=20
                                         else WinGamble.Counter2:=30;
        For I:=0 to WinGamble.Counter2 do
        Begin
          If WinGamble.Counter<2 then Inc(WinGamble.Counter) else
          Begin
            WinGamble.Counter:=0;
            If WinGambleGreen.Enable=True then
            Begin
              WinGambleGreen.Enable:=False;
              WinGambleRed.Enable:=True;
            End else
            Begin
              WinGambleGreen.Enable:=True;
              WinGambleRed.Enable:=False;
            End;
          End;
          UpdateGamble;
          TestStopAutoStart;
        End;
        If WinGambleGreen.Enable=True
        then Begin
               {Sound True}
               If DatRec.SBEnable=True
               then SBPlayRaw(35)
               else PlaySound(22);
               For I:=0 to 49 do
               Begin
                 TestStopAutoStart;
                 Wait(DatRec.fpsProdleva);
               End;
               If Bonus-750>=0 then
               Begin
                 Bonus750:=750;
                 Dec(Bonus,750);
               End else
               Begin
                 Bonus750:=Bonus;
                 Bonus:=0;
               End;
               AddScore(Bonus750);
             End
        else Begin
               {Sound False}
               If DatRec.SBEnable=True
               then SBPlayRaw(9)
               else PlaySound(21);
               For I:=0 to 49 do
               Begin
                 TestStopAutoStart;
                 Wait(DatRec.fpsProdleva);
               End
             End;
      End;
      Bet:=BetStore;
      BetMulti:=BetMultiStore;
      WinGamble.Enable:=False;
      TestBetDown;
    End else AddScore(Vyhra.Castka);
    MainGameScreen;
  End else
  Begin
    VyhraShow:=False;
    CreditShow:=True;
    MainGameScreen;
  End;

{DOLNI HRA}
If ((Lista[0].Enable=True) and (Vyhra.Castka>0)) then {RISK}
Begin
  Case AutoStartTyp of
    0: Begin
       End;
    1: Begin
         If Vyhra.Castka<100 then HorseSound;
       End;
    2: Begin
         If Vyhra.Castka<100 then HorseSound;
       End;
    3: Begin
         If Vyhra.Castka>=100 then HorseSound;
       End;
    4: Begin
         If Vyhra.Castka>=100 then HorseSound;
       End;
    5: Begin
         HorseSound;
       End;
    6: Begin
         HorseSound;
       End;
  End; {Case End}

  If AutoStart=True then
  Begin
Case AutoStartTyp of
0: Begin
     Risk.Enable:=False;
     Risk.Blinking:=False;
     For I:=0 to 8 do
     Begin
       Btn[I].Blinking:=False;
       Btn[I].Phase:=0;
       SetButtonColor(I);
     End;
     If Vyhra.Castka>750 then Begin
                                Inc(Bonus,Vyhra.Castka);
                                Vyhra.Castka:=0;
                              End;
     If Vyhra.Castka>0 then AddScore(Vyhra.Castka);
     VyhraShow:=False;
     CreditShow:=True;
     MainGameScreen;
   End;
1: Begin
     If Vyhra.Castka<100 then RiskniXkrat(False,1);
   End;
2: Begin
     If Vyhra.Castka<100 then RiskniXkrat(False,0);
   End;
3: Begin
     If Vyhra.Castka>=100 then RiskniXkrat(False,1);
   End;
4: Begin
     If Vyhra.Castka>=100 then RiskniXkrat(False,0);
   End;
5: Begin
     RiskniXkrat(False,1);
   End;
6: Begin
     RiskniXkrat(False,0);
   End;
End; {Case End}
  End else
  Begin
    MainGameScreen;
    Risk.Enable:=True;
    Risk.Blinking:=True;
    For I:=0 to 8 do
    Begin
      Btn[I].Blinking:=False;
      Btn[I].Phase:=0;
      SetButtonColor(I);
    End;
    BtnCol.Blinking:=True;
    Btn[0].Blinking:=True;
    Btn[4].Blinking:=True;
    Btn[5].Blinking:=True;
    VyhraShow:=True;
    CreditShow:=True;
    RiskCounter:=0;
    RiskAuto:=True;
    RiskRandom3:=Random(2);
    If RiskRandom3=0 then Risk.Phase:=0
                     else Risk.Phase:=1;
    For I:=0 to 14 do Wait(DatRec.fpsProdleva);
    If DatRec.SBEnable=True
    then SBPlayRaw(1)
    else PlaySound(14);
    If DatRec.NahodnyRisk=False then RiskDolni
                                else RiskDolniNahodny;
    VyhraShow:=True;
    CreditShow:=False;
    NextVyhra:=0;
    MainGameScreen;
  End;

  Risk.Enable:=False;
  Risk.Blinking:=False;
  For I:=0 to 8 do
  Begin
    Btn[I].Blinking:=False;
    Btn[I].Phase:=0;
    SetButtonColor(I);
  End;
  MainGameScreen;
  If Vyhra.Castka>0 then
  Begin
    If Vyhra.Castka>750 then
    Begin
      Inc(Bonus,Vyhra.Castka);
      Vyhra.Castka:=0;
      If DatRec.SBEnable=True
      then SBPlayRaw(35)
      else PlaySound(22);
      WinGamble.Enable:=True;
      MainGameScreen;
      BetStore:=Bet;
      BetMultiStore:=BetMulti;

      While ((Credit>=5) and (Bonus>0)) do
      Begin
        Dec(Credit,5);
        MainGameScreen;

        For I:=0 to 8 do
        Begin
          Btn[I].Blinking:=False;
          Btn[I].Phase:=0;
          SetButtonColor(I);
        End;
        MainGameScreen;

        WinGamble.Blinking:=True;
        WinGambleGreen.Enable:=False;
        WinGambleRed.Enable:=False;
        WinGamble.Counter:=0;
        RandomGamble:=Random(65535);
        If RandomGamble<DatRec.Nahoda[9] then WinGamble.Counter2:=20
                                         else WinGamble.Counter2:=30;
        For I:=0 to WinGamble.Counter2 do
        Begin
          If WinGamble.Counter<2 then Inc(WinGamble.Counter) else
          Begin
            WinGamble.Counter:=0;
            If WinGambleGreen.Enable=True then
            Begin
              WinGambleGreen.Enable:=False;
              WinGambleRed.Enable:=True;
            End else
            Begin
              WinGambleGreen.Enable:=True;
              WinGambleRed.Enable:=False;
            End;
          End;
          UpdateGamble;
          TestStopAutoStart;
        End;
        If WinGambleGreen.Enable=True
        then Begin
               {Sound True}
               If DatRec.SBEnable=True
               then SBPlayRaw(35)
               else PlaySound(22);
               For I:=0 to 49 do
               Begin
                 TestStopAutoStart;
                 Wait(DatRec.fpsProdleva);
               End;
               If Bonus-750>=0 then
               Begin
                 Bonus750:=750;
                 Dec(Bonus,750);
               End else
               Begin
                 Bonus750:=Bonus;
                 Bonus:=0;
               End;
               AddScore(Bonus750);
             End
        else Begin
               {Sound False}
               If DatRec.SBEnable=True
               then SBPlayRaw(9)
               else PlaySound(21);
               For I:=0 to 49 do
               Begin
                 TestStopAutoStart;
                 Wait(DatRec.fpsProdleva);
               End
             End;
      End;
      Bet:=BetStore;
      BetMulti:=BetMultiStore;
      WinGamble.Enable:=False;
      TestBetDown;
    End else AddScore(Vyhra.Castka);
    MainGameScreen;
  End else
  Begin
    VyhraShow:=False;
    CreditShow:=True;
    MainGameScreen;
  End;
End else
Begin
  VyhraShow:=False;
  CreditShow:=True;
  MainGameScreen;
End;

  If StopButton[0].Mark=True then Inc(DatRec.SpinPosunMark[0],26)
                             else DatRec.SpinPosunMark[0]:=0;
  If StopButton[1].Mark=True then Inc(DatRec.SpinPosunMark[1],27)
                             else DatRec.SpinPosunMark[1]:=0;
  If StopButton[2].Mark=True then Inc(DatRec.SpinPosunMark[2],28)
                             else DatRec.SpinPosunMark[2]:=0;

  For I:=0 to 2 do If StopButton[I].Mark=True then
  Begin
    StopButton[I].Mark:=False;
    Zamichat:=True;
  End;

  If BezVyhry=True then
  Begin
  Case DatRec.SpinHelper of
  0: For Counting:=0 to 699 do
     Begin
       Case SymbolLightSmer of
         0: If SymbolLight<3 then Inc(SymbolLight) else SymbolLightSmer:=1;
         1: If SymbolLight>1 then Dec(SymbolLight) else SymbolLightSmer:=0;
       End; {Case End}
       KresliValce(SymbolLight,0,0,0,Buffer[4]);
       Wait(DatRec.RollSpeed);
       If AutoStart=True then TestStopAutoStart;
     End;

  1: For Counting:=0 to 499 do
     Begin
       Case SymbolLightSmer of
         0: If SymbolLight<3 then Inc(SymbolLight) else SymbolLightSmer:=1;
         1: If SymbolLight>1 then Dec(SymbolLight) else SymbolLightSmer:=0;
       End; {Case End}
       KresliValce(SymbolLight,0,0,0,Buffer[4]);
       Wait(DatRec.RollSpeed);
       If AutoStart=True then TestStopAutoStart;
     End;

  2: For Counting:=0 to 299 do
     Begin
       Case SymbolLightSmer of
         0: If SymbolLight<3 then Inc(SymbolLight) else SymbolLightSmer:=1;
         1: If SymbolLight>1 then Dec(SymbolLight) else SymbolLightSmer:=0;
       End; {Case End}
       KresliValce(SymbolLight,0,0,0,Buffer[4]);
       Wait(DatRec.RollSpeed);
       If AutoStart=True then TestStopAutoStart;
     End;

  3: For Counting:=0 to 99 do
     Begin
       Case SymbolLightSmer of
         0: If SymbolLight<3 then Inc(SymbolLight) else SymbolLightSmer:=1;
         1: If SymbolLight>1 then Dec(SymbolLight) else SymbolLightSmer:=0;
       End; {Case End}
       KresliValce(SymbolLight,0,0,0,Buffer[4]);
       Wait(DatRec.RollSpeed);
       If AutoStart=True then TestStopAutoStart;
     End;
  End; {Case End}

    For Counting:=1 to 5 do
    Begin
      Linie[0].Indicator[Counting]:=0;
      Linie[1].Indicator[Counting]:=0;
    End;
    SymbolLight:=0;
    For I:=9 to 11 do
    Begin
      StopButton[I-9].Phase:=0;
      SetButtonColor(I);
    End;
    MainGameScreen;
    If DatRec.SBEnable=True then SBPlayRaw(38)
                            else PlaySound(8);
  End;
End;