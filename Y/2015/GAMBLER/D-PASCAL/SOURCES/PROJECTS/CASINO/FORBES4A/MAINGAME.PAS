Procedure StopBlinkingButtons;
Var I: Byte;
Begin
  For I:=0 to 8 do Btn[I].Blinking:=False;
  For I:=0 to 8 do Btn[I].Phase:=0;
  For I:=0 to 8 do SetButtonColor(I);
  MainGameScreen;
End;


Procedure MakeButtons;
Var I: Byte;
Begin
  For I:=9 to 11 do
  Begin
    If StopButton[I-9].Blinking=False then
    Begin
      StopButton[I-9].Phase:=0;
      SetButtonColor(I);
    End;
  End;
  For I:=0 to 8 do Btn[I].Blinking:=False;
  If Credit>=5 then Btn[1].Blinking:=True; {WIN GAMBLE}
  If ((Credit>=4) and (WinGamble.Enable=False))
  then Btn[2].Blinking:=True; {VSADIT}
  If WinGamble.Enable=True then
  Begin
    If Credit>=5 then Btn[3].Blinking:=True; {AUTOSTART WIN GAMBLE}
    If Credit>=5 then Btn[6].Blinking:=True; {START     WIN GAMBLE}
  End else
  Begin
    If Credit>=2 then Btn[3].Blinking:=True; {AUTOSTART}
    If Credit>=2 then Btn[6].Blinking:=True; {START}
  End;
  If ((Credit>=1) or (Multiwin>=1)) then Btn[7].Blinking:=True; {VYBRAT KASU}
  If MultiWin>=1 then Btn[8].Blinking:=True; {VYBRAT MULTIWIN}

  If ((Zamichat=False) and (TestRollEnable=True)) then
  Begin
    For I:=0 to 2 do
    If StopButton[I].Mark=False then StopButton[I].Blinking:=True
                                else Begin
                                       StopButton[I].Blinking:=False;
                                       StopButton[I].Phase:=4;
                                       SetButtonColor(9+I);
                                     End;
  End else
  Begin
    For I:=0 to 2 do StopButton[I].Blinking:=False;
  End;

  For I:=0 to 5 do
  Begin
    If Btn[I].Blinking=False then
    Begin
      Btn[I].Smer:=0;
      Btn[I].Phase:=0;
      SetButtonColor(I);
    End;
  End;
  If Btn[6].Blinking=False then
  Begin
    Btn[6].Smer:=0;
    Btn[6].Phase:=1;
    SetButtonColor(6);
  End;
  If Btn[7].Blinking=False then
  Begin
    Btn[7].Smer:=0;
    Btn[7].Phase:=1;
    SetButtonColor(7);
  End;
  If Btn[8].Blinking=False then
  Begin
    Btn[8].Smer:=0;
    Btn[8].Phase:=2;
    SetButtonColor(8);
  End;
  If BtnCol.Blinking=False then
  Begin
    BtnCol.Smer:=0;
    BtnCol.Phase:=2;
    SetButtonColor(12);
  End;

End;


Procedure MakeThrill;
Var I: Byte;
Begin
    WaitAction.Active:=True;
    If WaitAction.SeqCT<500 then Inc(WaitAction.SeqCT)
                            else Begin
                                   WaitAction.SeqCT:=0;

                                   If WaitAction.SeqAlg<3 then Inc(WaitAction.SeqAlg)
                                                          else WaitAction.SeqAlg:=0;

                                   {cena hry}
                                   Case WaitAction.SeqAlg of
                                     0: Begin
                                          WaitAction.Counter[0]:=0;
                                          WaitAction.Counter[5]:=0;
                                          WaitAction.Smer2:=0;
                                        End;
                                     1: Begin
                                          WaitAction.Counter[0]:=11;
                                          WaitAction.Counter[5]:=0;
                                          WaitAction.Smer2:=1;
                                        End;
                                     3: WaitAction.Counter[0]:=0;
                                   End; {Case End}
                                   For I:=0 to 11 do WaitAction.Cena[I]:=0;

                                   {cena vyher}
                                   Case WaitAction.SeqAlg of
                                     0: Begin
                                          WaitAction.Counter[1]:=0;
                                          WaitAction.Counter[4]:=0;
                                          WaitAction.Smer1:=0;
                                        End;
                                     1: Begin
                                          WaitAction.Counter[1]:=9;
                                          WaitAction.Counter[4]:=0;
                                          WaitAction.Smer1:=1;
                                        End;
                                     3: WaitAction.Counter[1]:=0;
                                   End; {Case End}
                                   For I:=0 to 9 do
                                   Begin
                                     WaitAction.Lista[0,I]:=0;
                                     WaitAction.Lista[1,I]:=0;
                                     WaitAction.Cislo[0,I]:=0;
                                     WaitAction.Cislo[1,I]:=0;
                                     WaitAction.Cislo[2,I]:=0;
                                   End;

                                   {RISK & WIN/-}
                                   WaitAction.Counter[2]:=0;
                                 End;

    {RISK & WIN/-}
    If WaitAction.SeqAlg<2 then
    Begin
     Case WaitAction.Counter[2] of
      0: Begin
           WaitAction.Risk[1]:=0;
           WaitAction.Risk[2]:=0;
           WaitAction.WinGamble[1]:=0;
           WaitAction.WinGamble[2]:=0;
         End;
      1: Begin
           WaitAction.Risk[1]:=1;
           WaitAction.Risk[2]:=0;
           WaitAction.WinGamble[1]:=1;
           WaitAction.WinGamble[2]:=0;
         End;
      2: Begin
           WaitAction.Risk[1]:=1;
           WaitAction.Risk[2]:=1;
           WaitAction.WinGamble[1]:=1;
           WaitAction.WinGamble[2]:=1;
         End;
      3: Begin
           WaitAction.Risk[1]:=0;
           WaitAction.Risk[2]:=1;
           WaitAction.WinGamble[1]:=0;
           WaitAction.WinGamble[2]:=1;
         End;
      4: Begin
           WaitAction.Risk[1]:=0;
           WaitAction.Risk[2]:=0;
           WaitAction.WinGamble[1]:=0;
           WaitAction.WinGamble[2]:=0;
         End;
     End; {Case End}
    End else
    Begin
     Case WaitAction.Counter[2] of
      0: Begin
           WaitAction.Risk[1]:=1;
           WaitAction.Risk[2]:=1;
           WaitAction.WinGamble[1]:=0;
           WaitAction.WinGamble[2]:=0;
         End;
      1: Begin
           WaitAction.Risk[1]:=0;
           WaitAction.Risk[2]:=0;
           WaitAction.WinGamble[1]:=1;
           WaitAction.WinGamble[2]:=1;
         End;
      2: Begin
           WaitAction.Risk[1]:=1;
           WaitAction.Risk[2]:=1;
           WaitAction.WinGamble[1]:=0;
           WaitAction.WinGamble[2]:=0;
         End;
      3: Begin
           WaitAction.Risk[1]:=0;
           WaitAction.Risk[2]:=0;
           WaitAction.WinGamble[1]:=1;
           WaitAction.WinGamble[2]:=1;
         End;
     End; {Case End}
    End;

    If WaitAction.SeqAlg=3 then
    Begin
     Case WaitAction.Counter[2] of
      0: Begin
           WaitAction.Risk[1]:=0;
           WaitAction.Risk[2]:=0;
           WaitAction.WinGamble[1]:=0;
           WaitAction.WinGamble[2]:=0;
         End;
      1: Begin
           WaitAction.Risk[1]:=0;
           WaitAction.Risk[2]:=0;
           WaitAction.WinGamble[1]:=0;
           WaitAction.WinGamble[2]:=0;
         End;
      2: Begin
           WaitAction.Risk[1]:=1;
           WaitAction.Risk[2]:=1;
           WaitAction.WinGamble[1]:=1;
           WaitAction.WinGamble[2]:=1;
         End;
      3: Begin
           WaitAction.Risk[1]:=1;
           WaitAction.Risk[2]:=1;
           WaitAction.WinGamble[1]:=1;
           WaitAction.WinGamble[2]:=1;
         End;
     End; {Case End}
    End else


    {CENY HER A VYHER}
    If WaitAction.SeqAlg<3 then
    Begin
      If WaitAction.Cena[WaitAction.Counter[0]]=0
      then WaitAction.Cena[WaitAction.Counter[0]]:=1
      else WaitAction.Cena[WaitAction.Counter[0]]:=0;

      If WaitAction.Lista[0,WaitAction.Counter[1]]=0
      then WaitAction.Lista[0,WaitAction.Counter[1]]:=1
      else WaitAction.Lista[0,WaitAction.Counter[1]]:=0;

      If WaitAction.Lista[1,WaitAction.Counter[1]]=0
      then WaitAction.Lista[1,WaitAction.Counter[1]]:=1
      else WaitAction.Lista[1,WaitAction.Counter[1]]:=0;

      If WaitAction.Cislo[0,WaitAction.Counter[1]]=0
      then WaitAction.Cislo[0,WaitAction.Counter[1]]:=1
      else WaitAction.Cislo[0,WaitAction.Counter[1]]:=0;

      If WaitAction.Cislo[1,WaitAction.Counter[1]]=0
      then WaitAction.Cislo[1,WaitAction.Counter[1]]:=1
      else WaitAction.Cislo[1,WaitAction.Counter[1]]:=0;

      If WaitAction.Cislo[2,WaitAction.Counter[1]]=0
      then WaitAction.Cislo[2,WaitAction.Counter[1]]:=1
      else WaitAction.Cislo[2,WaitAction.Counter[1]]:=0;
    End;

    If ((WaitAction.SeqAlg=0) or (WaitAction.SeqAlg=1)) then
    Begin
      Case WaitAction.Smer2 of
        0: Begin
             If WaitAction.Counter[0]<11 then Inc(WaitAction.Counter[0])
                                         else Begin
                                                WaitAction.Counter[0]:=0;
                                                If WaitAction.Counter[5]<1 then Inc(WaitAction.Counter[5])
                                                                           else Begin
                                                                                  WaitAction.Counter[5]:=0;
                                                                                  WaitAction.Smer2:=1;
                                                                                  WaitAction.Counter[0]:=11;
                                                                                End;
                                              End;
           End;
        1: Begin
             If WaitAction.Counter[0]>0 then Dec(WaitAction.Counter[0])
                                        else Begin
                                               WaitAction.Counter[0]:=11;
                                               If WaitAction.Counter[5]<1 then Inc(WaitAction.Counter[5])
                                                                          else Begin
                                                                                 WaitAction.Counter[5]:=0;
                                                                                 WaitAction.Smer2:=0;
                                                                                 WaitAction.Counter[0]:=0;
                                                                               End;
                                             End;
           End;
      End; {Case End}

      Case WaitAction.Smer1 of
        0: Begin
             If WaitAction.Counter[1]<9 then Inc(WaitAction.Counter[1])
                                        else Begin
                                               WaitAction.Counter[1]:=0;
                                               If WaitAction.Counter[4]<1 then Inc(WaitAction.Counter[4])
                                                                          else Begin
                                                                                 WaitAction.Counter[4]:=0;
                                                                                 WaitAction.Smer1:=1;
                                                                                 WaitAction.Counter[1]:=9;
                                                                               End;
                                             End;
           End;
        1: Begin
             If WaitAction.Counter[1]>0 then Dec(WaitAction.Counter[1])
                                        else Begin
                                               WaitAction.Counter[1]:=9;
                                               If WaitAction.Counter[4]<1 then Inc(WaitAction.Counter[4])
                                                                          else Begin
                                                                                 WaitAction.Counter[4]:=0;
                                                                                 WaitAction.Smer1:=0;
                                                                                 WaitAction.Counter[1]:=0;
                                                                               End;
                                             End;
           End;
      End; {Case End}

    End;

    If WaitAction.SeqAlg=0 then
    Begin
      If WaitAction.Counter[3]<2
      then Inc(WaitAction.Counter[3])
      else Begin
             WaitAction.Counter[3]:=0;
             If WaitAction.Counter[2]<4 then Inc(WaitAction.Counter[2])
                                        else WaitAction.Counter[2]:=0;
           End;
    End;

    If WaitAction.SeqAlg=1 then
    Begin
      If WaitAction.Counter[3]<2
      then Inc(WaitAction.Counter[3])
      else Begin
             WaitAction.Counter[3]:=0;
             If WaitAction.Counter[2]>0 then Dec(WaitAction.Counter[2])
                                        else WaitAction.Counter[2]:=4;
           End;
    End;

    If WaitAction.SeqAlg=2 then
    Begin
      For I:=0 to 11 do WaitAction.Cena[I]:=0;
      WaitAction.Cena[Random(12)]:=1;

      For I:=0 to 9 do
      Begin
        WaitAction.Lista[0,I]:=0;
        WaitAction.Lista[1,I]:=0;
        WaitAction.Cislo[0,I]:=0;
        WaitAction.Cislo[1,I]:=0;
        WaitAction.Cislo[2,I]:=0;
      End;
      WaitAction.Counter[1]:=Random(10);
      WaitAction.Lista[0,WaitAction.Counter[1]]:=1;
      WaitAction.Lista[1,WaitAction.Counter[1]]:=1;
      WaitAction.Cislo[0,WaitAction.Counter[1]]:=1;
      WaitAction.Cislo[1,WaitAction.Counter[1]]:=1;
      WaitAction.Cislo[2,WaitAction.Counter[1]]:=1;

      If WaitAction.Counter[2]<3 then Inc(WaitAction.Counter[2])
                                 else WaitAction.Counter[2]:=0;
    End;

    If WaitAction.SeqAlg=3 then
    Begin
      If WaitAction.Counter[4]<4
      then Inc(WaitAction.Counter[4])
      else Begin
             WaitAction.Counter[4]:=0;

             If WaitAction.Counter[2]<3 then Inc(WaitAction.Counter[2])
                                        else WaitAction.Counter[2]:=0;

             If WaitAction.Counter[1]<7 then Inc(WaitAction.Counter[1])
                                        else WaitAction.Counter[1]:=0;

             If WaitAction.Counter[0]<2 then Inc(WaitAction.Counter[0])
                                        else WaitAction.Counter[0]:=0;

             Case WaitAction.Counter[0] of
             0: For I:=0 to 9 do
                Begin
                  WaitAction.Lista[0,I]:=0;
                  WaitAction.Lista[1,I]:=0;
                End;
             1: For I:=0 to 9 do
                Begin
                  WaitAction.Lista[0,I]:=1;
                  WaitAction.Lista[1,I]:=0;
                End;
             2: For I:=0 to 9 do
                Begin
                  WaitAction.Lista[0,I]:=0;
                  WaitAction.Lista[1,I]:=1;
                End;
             End; {Case End}

             If WaitAction.Counter[1]<4 then
             Begin
               WaitAction.Cena[0]:=0;
               WaitAction.Cena[1]:=1;
               WaitAction.Cena[2]:=0;
               WaitAction.Cena[3]:=1;
               WaitAction.Cena[4]:=0;
               WaitAction.Cena[5]:=1;
               WaitAction.Cena[6]:=0;
               WaitAction.Cena[7]:=1;
               WaitAction.Cena[8]:=0;
               WaitAction.Cena[9]:=1;
               WaitAction.Cena[10]:=0;
               WaitAction.Cena[11]:=1;

               WaitAction.Cislo[0,0]:=1;
               WaitAction.Cislo[0,1]:=0;
               WaitAction.Cislo[0,2]:=1;
               WaitAction.Cislo[0,3]:=0;
               WaitAction.Cislo[0,4]:=1;
               WaitAction.Cislo[0,5]:=0;
               WaitAction.Cislo[0,6]:=1;
               WaitAction.Cislo[0,7]:=0;
               WaitAction.Cislo[0,8]:=1;
               WaitAction.Cislo[0,9]:=0;

               WaitAction.Cislo[1,0]:=0;
               WaitAction.Cislo[1,1]:=1;
               WaitAction.Cislo[1,2]:=0;
               WaitAction.Cislo[1,3]:=1;
               WaitAction.Cislo[1,4]:=0;
               WaitAction.Cislo[1,5]:=1;
               WaitAction.Cislo[1,6]:=0;
               WaitAction.Cislo[1,7]:=1;
               WaitAction.Cislo[1,8]:=0;
               WaitAction.Cislo[1,9]:=1;

               WaitAction.Cislo[2,0]:=1;
               WaitAction.Cislo[2,1]:=0;
               WaitAction.Cislo[2,2]:=1;
               WaitAction.Cislo[2,3]:=0;
               WaitAction.Cislo[2,4]:=1;
               WaitAction.Cislo[2,5]:=0;
               WaitAction.Cislo[2,6]:=1;
               WaitAction.Cislo[2,7]:=0;
               WaitAction.Cislo[2,8]:=1;
               WaitAction.Cislo[2,9]:=0;
             End else
             Begin
               WaitAction.Cena[0]:=1;
               WaitAction.Cena[1]:=0;
               WaitAction.Cena[2]:=1;
               WaitAction.Cena[3]:=0;
               WaitAction.Cena[4]:=1;
               WaitAction.Cena[5]:=0;
               WaitAction.Cena[6]:=1;
               WaitAction.Cena[7]:=0;
               WaitAction.Cena[8]:=1;
               WaitAction.Cena[9]:=0;
               WaitAction.Cena[10]:=1;
               WaitAction.Cena[11]:=0;

               WaitAction.Cislo[0,0]:=0;
               WaitAction.Cislo[0,1]:=1;
               WaitAction.Cislo[0,2]:=0;
               WaitAction.Cislo[0,3]:=1;
               WaitAction.Cislo[0,4]:=0;
               WaitAction.Cislo[0,5]:=1;
               WaitAction.Cislo[0,6]:=0;
               WaitAction.Cislo[0,7]:=1;
               WaitAction.Cislo[0,8]:=0;
               WaitAction.Cislo[0,9]:=1;

               WaitAction.Cislo[1,0]:=1;
               WaitAction.Cislo[1,1]:=0;
               WaitAction.Cislo[1,2]:=1;
               WaitAction.Cislo[1,3]:=0;
               WaitAction.Cislo[1,4]:=1;
               WaitAction.Cislo[1,5]:=0;
               WaitAction.Cislo[1,6]:=1;
               WaitAction.Cislo[1,7]:=0;
               WaitAction.Cislo[1,8]:=1;
               WaitAction.Cislo[1,9]:=0;

               WaitAction.Cislo[2,0]:=0;
               WaitAction.Cislo[2,1]:=1;
               WaitAction.Cislo[2,2]:=0;
               WaitAction.Cislo[2,3]:=1;
               WaitAction.Cislo[2,4]:=0;
               WaitAction.Cislo[2,5]:=1;
               WaitAction.Cislo[2,6]:=0;
               WaitAction.Cislo[2,7]:=1;
               WaitAction.Cislo[2,8]:=0;
               WaitAction.Cislo[2,9]:=1;
             End;
           End;
    End;

End;


Procedure MainGame;
Var Ending: Boolean;
    CreditCounter: Byte;
    I: Byte;
    Counting: Word;
    Odpocitadlo: LongInt;
Begin
  Ending:=False;
  For I:=0 to 2 do SetupSymboly(I);
  For I:=0 to 5 do WaitAction.Counter[I]:=0;
  For I:=0 to 11 do WaitAction.Cena[I]:=0;
  For I:=0 to 9 do
  Begin
    WaitAction.Lista[0,I]:=0;
    WaitAction.Lista[1,I]:=0;
    WaitAction.Cislo[0,I]:=0;
    WaitAction.Cislo[1,I]:=0;
    WaitAction.Cislo[2,I]:=0;
  End;
  WaitAction.Smer1:=0;
  WaitAction.Smer2:=0;
  WaitAction.SeqAlg:=0;
  WaitAction.SeqCT:=0;

  MakeButtons;
  MakeThrill;
  MainGameScreen;
  Wait(DatRec.fpsProdleva);

  Wait(2500);
  For I:=0 to 19 do
  Begin
        If DatRec2.Hotovost>=1000 then
        Begin
          Inc(VkladyTMP,1000);
          Inc(DatRec2.Pub.Vklady,1000);
          VkladShow[10]:=True;
          While Key[11]=True do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[10]:=False;
          PlusBankovka(0);
          Inc(Credit,1000);
          Dec(DatRec2.Hotovost,1000);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(44);
        End;
        Wait(2500);
  End;

  Wait(2500);
  If DatRec.SBEnable=True then SBPlayRaw(46);
  SetBet;
  MainGameScreen;
  Wait(2500);

          AutoStart:=True;
          AutoStartTyp:=4;
          While ((Credit>=Bet) and (MultiWin>=BetMulti) and (AutoStart=True)) do
          Begin
            If DatRec.SBEnable=True
            then SBPlayRaw(47)
            else PlaySound(14);
            Dec(Credit,Bet);
            Dec(MultiWin,BetMulti);
            MainGameScreen;
            Roll;
            TestBetDown;
            For Counting:=0 to 699 do
            Begin
              TestStopAutoStart;
              Wait(1);
            End;
          End;
          If AutoStart=True then
          Begin

          Wait(2500);
          For I:=0 to 4 do
          Begin
            If DatRec2.Hotovost>=1000 then
            Begin
              Inc(VkladyTMP,1000);
              Inc(DatRec2.Pub.Vklady,1000);
              VkladShow[10]:=True;
              While Key[11]=True do
              Begin
                MainGameScreen;
                Wait(DatRec.fpsProdleva);
              End;
              VkladShow[10]:=False;
              PlusBankovka(0);
              Inc(Credit,1000);
              Dec(DatRec2.Hotovost,1000);
              MainGameScreen;
              If DatRec.SBEnable=True then SBPlayRaw(44);
            End;
            Wait(2500);
          End;

            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);

            AutoStart:=True;
            AutoStartTyp:=4;
            While ((Credit>=Bet) and (MultiWin>=BetMulti) and (AutoStart=True)) do
            Begin
              If DatRec.SBEnable=True
              then SBPlayRaw(47)
              else PlaySound(14);
              Dec(Credit,Bet);
              Dec(MultiWin,BetMulti);
              MainGameScreen;
              Roll;
              TestBetDown;
              For Counting:=0 to 699 do
              Begin
                TestStopAutoStart;
                Wait(1);
              End;
            End;

      Wait(2500);
      For I:=0 to 19 do
      Begin
        If DatRec2.Hotovost>=5 then
        Begin
          Inc(VkladyTMP,5);
          Inc(DatRec2.Pub.Vklady,5);
          VkladShow[3]:=True;
          MainGameScreen;
          Wait(1000);
          VkladShow[3]:=False;
          Inc(Credit,5);
          Dec(DatRec2.Hotovost,5);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(40)
                                  else PlaySound(0);
          Wait(1000);
          If DatRec.SBEnable=True then SBPlayRaw(39);
        End;
        Wait(2000);
      End;

            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);
            If DatRec.SBEnable=True then SBPlayRaw(46);
            SetBet;
            MainGameScreen;
            Wait(2500);

            AutoStart:=True;
            AutoStartTyp:=4;
            While ((Credit>=Bet) and (MultiWin>=BetMulti) and (AutoStart=True)) do
            Begin
              If DatRec.SBEnable=True
              then SBPlayRaw(47)
              else PlaySound(14);
              Dec(Credit,Bet);
              Dec(MultiWin,BetMulti);
              MainGameScreen;
              Roll;
              TestBetDown;
              For Counting:=0 to 699 do
              Begin
                TestStopAutoStart;
                Wait(1);
              End;
            End;

            Wait(2500);
            If AutoStart=True then
            Begin
              If Multiwin>0 then Begin
                                   If DatRec.SBEnable=True then SBPlayRaw(46);
                                   Inc(Credit,Multiwin);
                                   Multiwin:=0;
                                   MainGameScreen;
                                   Wait(250);
                                 End;

              If Credit>0 then Begin
                                 If DatRec.SBEnable=True then SBPlayRaw(46);
                                 Inc(DatRec2.Pub.Vyplaceno,Credit);
                                 Inc(VyplacenoTMP,Credit);
                                 Inc(DatRec2.Hotovost,Credit);
                                 Credit:=0;
                                 MainGameScreen;
                               End;
              TestBetDown;
              HistorieHer;
              SaveLoadPenize(True);
              SaveLoadForbes(True);

              AutoStart:=False;
              KresliValce(SymbolLight,LightJ,LightK,LightL,Buffer[3]);
              Blok(109,141,210,149,ColorBlack,Buffer[3]);
              WriteText(Buffer[1],160,140,5,7,1,120,142,'autostart off',Buffer[3]);
              WaitRetrace;
              FlipPage(Buffer[3],Buffer[4]);
              For I:=0 to 49 do Wait(DatRec.fpsProdleva);
            End;
          End;

  Odpocitadlo:=0;
  Repeat
    MakeButtons;
    MakeThrill;
    MainGameScreen;
    Wait(DatRec.fpsProdleva);

{J}   If (((Key[36]=True) or (J1=1)) and (Zamichat=False) and
          (TestRollEnable=True)) then
      Begin
        If DatRec.SBEnable=True then SBPlayRaw(46);
        While Key[36]=True do Begin End;
        While J1=1 do Begin End;
        If StopButton[0].Mark=True
        then Begin
               StopButton[0].Mark:=False;
               If DatRec.SBEnable=True
               then SBPlayRaw(0)
               else PlaySound(8);
             End
        else Begin
               StopButton[0].Mark:=True;
               If DatRec.SBEnable=True
               then SBPlayRaw(41)
               else PlaySound(8);
             End;
        MainGameScreen;
      End;

{K}   If (((Key[37]=True) or (K1=1)) and (Zamichat=False) and
          (TestRollEnable=True)) then
      Begin
        If DatRec.SBEnable=True then SBPlayRaw(46);
        While Key[37]=True do Begin End;
        While K1=1 do Begin End;
        If StopButton[1].Mark=True
        then Begin
               StopButton[1].Mark:=False;
               If DatRec.SBEnable=True
               then SBPlayRaw(0)
               else PlaySound(8);
             End
        else Begin
               StopButton[1].Mark:=True;
               If DatRec.SBEnable=True
               then SBPlayRaw(41)
               else PlaySound(8);
             End;
        MainGameScreen;
      End;

{L}   If (((Key[38]=True) or (L1=1)) and (Zamichat=False) and
          (TestRollEnable=True)) then
      Begin
        If DatRec.SBEnable=True then SBPlayRaw(46);
        While Key[38]=True do Begin End;
        While L1=1 do Begin End;
        If StopButton[2].Mark=True
        then Begin
               StopButton[2].Mark:=False;
               If DatRec.SBEnable=True
               then SBPlayRaw(0)
               else PlaySound(8);
             End
        else Begin
               StopButton[2].Mark:=True;
               If DatRec.SBEnable=True
               then SBPlayRaw(41)
               else PlaySound(8);
             End;
        MainGameScreen;
      End;

{A}   If ((Key[30]=True) or (AutostartStiskly1=1)) then
      Begin
        If ((StopButton[0].Mark=True) and
            (StopButton[1].Mark=True) and
            (StopButton[2].Mark=True)) then
            For I:=0 to 2 do StopButton[I].Mark:=False;
        StopBlinkingButtons;
        WaitAction.Active:=False;
        For I:=0 to 2 do StopButton[I].WaitActPhase:=0;
        If DatRec.SBEnable=True then SBPlayRaw(46);
        While ((Key[30]=True) or (AutostartStiskly1=1)) do Begin End;
        If ((WinGamble.Enable=True) and (Credit>=5)) then
        Begin
          If DatRec.SBEnable=True
          then SBPlayRaw(28)
          else PlaySound(9);
          AutoStart:=True;
          Blok(109,141,210,149,ColorBlack,Buffer[3]);
          WriteText(Buffer[1],160,140,5,7,1,120,142,'autostart on',Buffer[3]);
          WaitRetrace;
          FlipPage(Buffer[3],Buffer[4]);
          For I:=0 to 49 do Wait(DatRec.fpsProdleva);
          While ((Credit>=5) and (AutoStart=True)) do
          Begin
            Dec(Credit,5);
            StopBlinkingButtons;
            WaitAction.Active:=False;
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
              TestStopAutoStart;
              UpdateGamble;
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
                   If DatRec2.Bonus=0 then Inc(MultiWin,10)
                              else Begin
                                     If DatRec2.Bonus-750>=0 then
                                     Begin
                                       DatRec2.Bonus750:=750;
                                       Dec(DatRec2.Bonus,750);
                                     End else
                                     Begin
                                       DatRec2.Bonus750:=DatRec2.Bonus;
                                       DatRec2.Bonus:=0;
                                     End;
                                     AddScore(DatRec2.Bonus750);
                                   End;
                 End
            else Begin
                   {Sound False}
                   If DatRec.SBEnable=True
                   then SBPlayRaw(31)
                   else PlaySound(21);
                   For I:=0 to 49 do
                   Begin
                     TestStopAutoStart;
                     Wait(DatRec.fpsProdleva);
                   End;
                 End;
          End;
          If AutoStart=True then
          Begin
            AutoStart:=False;
            KresliValce(SymbolLight,LightJ,LightK,LightL,Buffer[3]);
            Blok(109,141,210,149,ColorBlack,Buffer[3]);
            WriteText(Buffer[1],160,140,5,7,1,120,142,'autostart off',Buffer[3]);
            WaitRetrace;
            FlipPage(Buffer[3],Buffer[4]);
            For I:=0 to 49 do Wait(DatRec.fpsProdleva);
          End;
        End;
        WinGamble.Blinking:=False;
        WinGambleGreen.Enable:=False;
        WinGambleRed.Enable:=False;

        If ((WinGamble.Enable=False) and ((Credit>=Bet) and (MultiWin>=BetMulti))) then
        Begin
          If DatRec.SBEnable=True
          then SBPlayRaw(28)
          else PlaySound(9);
          AutoStart:=True;
          Blok(109,141,210,149,ColorBlack,Buffer[3]);
          WriteText(Buffer[1],160,140,5,7,1,120,142,'autostart on',Buffer[3]);
          WaitRetrace;
          FlipPage(Buffer[3],Buffer[4]);
          For I:=0 to 49 do Wait(DatRec.fpsProdleva);
          AutoStartTyp:=0;
          While ((Credit>=Bet) and (MultiWin>=BetMulti) and (AutoStart=True)) do
          Begin
            If DatRec.SBEnable=True
            then SBPlayRaw(47)
            else PlaySound(14);
            Dec(Credit,Bet);
            Dec(MultiWin,BetMulti);
            MainGameScreen;
            Roll;
            TestBetDown;
            For Counting:=0 to 699 do
            Begin
              TestStopAutoStart;
              Wait(1);
            End;
          End;
          If AutoStart=True then
          Begin
            If Multiwin>0 then Begin
                                 If DatRec.SBEnable=True then SBPlayRaw(46);
                                 Inc(Credit,Multiwin);
                                 Multiwin:=0;
                                 MainGameScreen;
                                 Wait(250);
                               End;

            If Credit>0 then Begin
                               If DatRec.SBEnable=True then SBPlayRaw(46);
                               Inc(DatRec2.Pub.Vyplaceno,Credit);
                               Inc(VyplacenoTMP,Credit);
                               Inc(DatRec2.Hotovost,Credit);
                               Credit:=0;
                               MainGameScreen;
                             End;
            TestBetDown;
            HistorieHer;
            SaveLoadPenize(True);
            SaveLoadForbes(True);

            AutoStart:=False;
            KresliValce(SymbolLight,LightJ,LightK,LightL,Buffer[3]);
            Blok(109,141,210,149,ColorBlack,Buffer[3]);
            WriteText(Buffer[1],160,140,5,7,1,120,142,'autostart off',Buffer[3]);
            WaitRetrace;
            FlipPage(Buffer[3],Buffer[4]);
            For I:=0 to 49 do Wait(DatRec.fpsProdleva);
          End;
        End;
      End;

{NUM} If ((Key[82]=True) or (StartStiskly1=1)) then
      Begin
        If ((StopButton[0].Mark=True) and
            (StopButton[1].Mark=True) and
            (StopButton[2].Mark=True)) then
            For I:=0 to 2 do StopButton[I].Mark:=False;
        StopBlinkingButtons;
        WaitAction.Active:=False;
        For I:=0 to 2 do StopButton[I].WaitActPhase:=0;
        If DatRec.SBEnable=True then SBPlayRaw(46);
        While ((Key[82]=True) or (StartStiskly1=1)) do Begin End;
        If ((WinGamble.Enable=True) and (Credit>=5)) then
        Begin
          If DatRec.SBEnable=True
          then SBPlayRaw(28)
          else PlaySound(14);
          Dec(Credit,5);
          MainGameScreen;
          StopBlinkingButtons;
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
          End;
          If WinGambleGreen.Enable=True
          then Begin
                 {Sound True}
                 If DatRec.SBEnable=True
                 then SBPlayRaw(35)
                 else PlaySound(22);
                 If DatRec2.Bonus=0 then Inc(MultiWin,10)
                            else Begin
                                   If DatRec2.Bonus-750>=0 then
                                   Begin
                                     DatRec2.Bonus750:=750;
                                     Dec(DatRec2.Bonus,750);
                                   End else
                                   Begin
                                     DatRec2.Bonus750:=DatRec2.Bonus;
                                     DatRec2.Bonus:=0;
                                   End;
                                   AddScore(DatRec2.Bonus750);
                                 End;
               End
          else Begin
                 {Sound False}
                 If DatRec.SBEnable=True
                 then SBPlayRaw(9)
                 else PlaySound(21);
                 For I:=0 to 49 do Wait(DatRec.fpsProdleva);
               End;

          WinGamble.Blinking:=False;
          WinGambleGreen.Enable:=False;
          WinGambleRed.Enable:=False;
        End;

        If ((WinGamble.Enable=False) and (TestRollEnable=True)) then
        Begin
          If DatRec.SBEnable=True
          then SBPlayRaw(47)
          else PlaySound(14);
          Dec(Credit,Bet);
          Dec(MultiWin,BetMulti);
          MainGameScreen;
          Roll;
          TestBetDown;
        End;
      End;

{V}   If (((Key[47]=True) or (Key[28]=True) or (VsaditStiskly1=1)) and
         (Credit>=4) and (WinGamble.Enable=False)) then
      Begin
        If DatRec.SBEnable=True then SBPlayRaw(46);
        While Key[47]=True do WaitButton(47);
        While Key[28]=True do WaitButton(28);
        While VsaditStiskly1=1 do Begin End;
        SetBet;
      End;

{W}   If ((Key[17]=True) or (Key[75]=True) or (Key[77]=True) or (WinGambleStiskly1=1)) then
      Begin
        If DatRec.SBEnable=True then SBPlayRaw(46);
        While Key[17]=True do Begin End;
        While Key[75]=True do Begin End;
        While Key[77]=True do Begin End;
        While WinGambleStiskly1=1 do Begin End;
        If WinGamble.Enable=False then Begin
                                         If DatRec.SBEnable=True
                                         then SBPlayRaw(41)
                                         else PlaySound(8);
                                         WinGamble.Store[0]:=Bet;
                                         WinGamble.Store[1]:=BetMulti;
                                         BetMulti:=0;
                                         Bet:=5;
                                         WinGamble.Enable:=True;
                                         Btn[2].Blinking:=False;
                                         Btn[2].Phase:=0;
                                         SetButtonColor(2);
                                       End
                                  else Begin
                                         If DatRec.SBEnable=True
                                         then SBPlayRaw(0)
                                         else PlaySound(8);
                                         Bet:=WinGamble.Store[0];
                                         BetMulti:=WinGamble.Store[1];
                                         WinGamble.Enable:=False;
                                       End;
        MainGameScreen;
        Wait(DatRec.fpsProdleva);
      End;

{T&D} If ((Key[20]=True) or (Key[32]=True) or (VybratMultiwinStiskly1=1)) then
      Begin
        StopBlinkingButtons;
        CreditShow:=True;
        While Key[20]=True do WaitButton(20);
        While Key[32]=True do WaitButton(32);
        StahovaniMultiwinu1:=1;
        While ((VybratMultiwinStiskly1=1) and (StahovaniMultiwinu1=1)) do WaitMouseButton1;
        Wait(10);
        Inc(MultiCounter);
        If ((MultiCounter>=1) and (MultiCounter<10)) then {za korunu}
        Begin
          If MultiWin>=1 then
          Begin
            Dec(MultiWin);
            Inc(Credit);
            If DatRec.SBEnable=True then SBPlayRaw(15)
                                    else PlaySound(5);
            MainGameScreen
          End;
        End;
        If ((MultiCounter>=10) and (MultiCounter<25)) then {za 2 korun}
        Begin
          If MultiWin>=2 then
          Begin
            Dec(MultiWin,2);
            Inc(Credit,2);
            If DatRec.SBEnable=True then SBPlayRaw(16)
                                    else PlaySound(6);
            MainGameScreen
          End;
        End;
        If ((MultiCounter>=25) and (MultiCounter<45)) then {za 5 korun}
        Begin
          If MultiWin>=5 then
          Begin
            Dec(MultiWin,5);
            Inc(Credit,5);
            If Datrec.SBEnable=True then SBPlayRaw(17)
                                    else PlaySound(7);
            MainGameScreen;

          End;
        End;
        If ((MultiCounter>=45) and (MultiCounter<71)) then {za 10 korun}
        Begin
          If MultiWin>=10 then
          Begin
            Dec(MultiWin,10);
            Inc(Credit,10);
            If Datrec.SBEnable=True then SBPlayRaw(12)
                                    else PlaySound(2);
            MainGameScreen;
          End;
        End;
        If ((MultiCounter>=71) and (MultiCounter<101)) then {za 20 korun}
        Begin
          If MultiWin>=20 then
          Begin
            Dec(MultiWin,20);
            Inc(Credit,20);
            If DatRec.SBEnable=True then SBPlayRaw(13)
                                    else PlaySound(3);
            MainGameScreen;

          End;
        End;
        If ((MultiCounter>=101) and (MultiCounter<121)) then {za 50 korun}
        Begin
          If MultiWin>=50 then
          Begin
            Dec(MultiWin,50);
            Inc(Credit,50);
            If DatRec.SBEnable=True then SBPlayRaw(14)
                                    else PlaySound(4);
            MainGameScreen;
          End;
        End;
        If MultiCounter>=121 then {za 100 korun}
        Begin
          If MultiWin>=100 then
          Begin
            Dec(MultiWin,100);
            Inc(Credit,100);
            If DatRec.SBEnable=True then SBPlayRaw(14)
                                    else PlaySound(4);
            MainGameScreen;
          End;
        End;
      End else MultiCounter:=0;

{C} If ((Key[16]=True) or (Key[80]=True) or (VybratCreditStiskly1=1)) then
    Begin
        StopBlinkingButtons;
        CreditShow:=True;
        MainGameScreen;
        While Key[16]=True do Begin End;
        While Key[80]=True do Begin End;
        While ((VybratCreditStiskly1=1) and (StahovaniKasy1=1)) do Begin End;

        If Multiwin>0 then Begin
                             If DatRec.SBEnable=True then SBPlayRaw(46);
                             Inc(Credit,Multiwin);
                             Multiwin:=0;
                             MainGameScreen;
                             Wait(250);
                           End;

        If Credit>0 then Begin
                           If DatRec.SBEnable=True then SBPlayRaw(46);
                           Inc(DatRec2.Pub.Vyplaceno,Credit);
                           Inc(VyplacenoTMP,Credit);
                           Inc(DatRec2.Hotovost,Credit);
                           Credit:=0;
                           MainGameScreen;
                         End;
      TestBetDown;
    End;

{1}   If Key[2]=True then
      Begin
        If DatRec2.Hotovost>=1 then
        Begin
          Inc(VkladyTMP,1);
          Inc(DatRec2.Pub.Vklady,1);
          VkladShow[1]:=True;
          While Key[2]=True do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[1]:=False;
          Inc(Credit,1);
          Dec(DatRec2.Hotovost,1);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(40)
                                  else PlaySound(0);
          Wait(1000);
          If DatRec.SBEnable=True then SBPlayRaw(39);
        End;
      End;


{2}   If Key[3]=True then
      Begin
        If DatRec2.Hotovost>=2 then
        Begin
          Inc(VkladyTMP,2);
          Inc(DatRec2.Pub.Vklady,2);
          VkladShow[2]:=True;
          While Key[3]=True do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[2]:=False;
          Inc(Credit,2);
          Dec(DatRec2.Hotovost,2);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(40)
                                  else PlaySound(0);
          Wait(1000);
          If DatRec.SBEnable=True then SBPlayRaw(39);
        End;
      End;


{3}   If Key[4]=True then
      Begin
        If DatRec2.Hotovost>=5 then
        Begin
          Inc(VkladyTMP,5);
          Inc(DatRec2.Pub.Vklady,5);
          VkladShow[3]:=True;
          While Key[4]=True do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[3]:=False;
          Inc(Credit,5);
          Dec(DatRec2.Hotovost,5);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(40)
                                  else PlaySound(0);
          Wait(1000);
          If DatRec.SBEnable=True then SBPlayRaw(39);
        End;
      End;


{4}   If Key[5]=True then
      Begin
        If DatRec2.Hotovost>=10 then
        Begin
          Inc(VkladyTMP,10);
          Inc(DatRec2.Pub.Vklady,10);
          VkladShow[4]:=True;
          While Key[5]=True do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[4]:=False;
          Inc(Credit,10);
          Dec(DatRec2.Hotovost,10);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(40)
                                  else PlaySound(0);
          Wait(1000);
          If DatRec.SBEnable=True then SBPlayRaw(39);
        End;
      End;


{5}   If Key[6]=True then
      Begin
        If DatRec2.Hotovost>=20 then
        Begin
          Inc(VkladyTMP,20);
          Inc(DatRec2.Pub.Vklady,20);
          VkladShow[5]:=True;
          While Key[6]=True do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[5]:=False;
          Inc(Credit,20);
          Dec(DatRec2.Hotovost,20);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(40)
                                  else PlaySound(0);
          Wait(1000);
          If DatRec.SBEnable=True then SBPlayRaw(39);
        End;
      End;


{6}   If ((Key[7]=True) or (Key[72]=True) or (Vlozit50Stiskly1=1)) then
      Begin
        If DatRec2.Hotovost>=50 then
        Begin
          Inc(VkladyTMP,50);
          Inc(DatRec2.Pub.Vklady,50);
          VkladShow[6]:=True;
          While ((Key[7]=True) or (Key[72]=True) or (Vlozit50Stiskly1=1)) do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[6]:=False;
          Inc(Credit,50);
          Dec(DatRec2.Hotovost,50);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(40)
                                  else PlaySound(0);
          Wait(1000);
          If DatRec.SBEnable=True then SBPlayRaw(39);
        End;
      End;


{7}   If Key[8]=True then
      Begin
        If DatRec2.Hotovost>=100 then
        Begin
          Inc(VkladyTMP,100);
          Inc(DatRec2.Pub.Vklady,100);
          VkladShow[7]:=True;
          While Key[8]=True do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[7]:=False;
          PlusBankovka(7);
          Inc(Credit,100);
          Dec(DatRec2.Hotovost,100);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(44);
        End;
      End;


{8}   If Key[9]=True then
      Begin
        If DatRec2.Hotovost>=200 then
        Begin
          Inc(VkladyTMP,200);
          Inc(DatRec2.Pub.Vklady,200);
          VkladShow[8]:=True;
          While Key[9]=True do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[8]:=False;
          PlusBankovka(8);
          Inc(Credit,200);
          Dec(DatRec2.Hotovost,200);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(44);
        End;
      End;

{9}   If ((Key[10]=True) or (Vlozit500Stiskly1=1)) then
      Begin
        If DatRec2.Hotovost>=500 then
        Begin
          Inc(VkladyTMP,500);
          Inc(DatRec2.Pub.Vklady,500);
          VkladShow[9]:=True;
          While ((Key[10]=True) or (Vlozit500Stiskly1=1)) do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[9]:=False;
          PlusBankovka(9);
          Inc(Credit,500);
          Dec(DatRec2.Hotovost,500);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(44);
        End;
      End;


{0}   If Key[11]=True then
      Begin
        If DatRec2.Hotovost>=1000 then
        Begin
          Inc(VkladyTMP,1000);
          Inc(DatRec2.Pub.Vklady,1000);
          VkladShow[10]:=True;
          While Key[11]=True do
          Begin
            MainGameScreen;
            Wait(DatRec.fpsProdleva);
          End;
          VkladShow[10]:=False;
          PlusBankovka(0);
          Inc(Credit,1000);
          Dec(DatRec2.Hotovost,1000);
          MainGameScreen;
          If DatRec.SBEnable=True then SBPlayRaw(44);
        End;
      End;


{Esc} If ((Key[1]=True) or (GetButton2=1)) then
      Begin
        While ((Key[1]=True) or (GetButton2=1)) do Begin End;
        Ending:=True;
      End;

    Inc(Odpocitadlo,15);
    If Odpocitadlo>=600000 then Ending:=True; {AutoExit}

  Until Ending=True;
End;