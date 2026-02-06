Procedure Blinking;
Var I: Byte;
Begin
  If WinConf.Vyhra[1]=True then
  Begin
    For I:=1 to 3 do
    Case SymbolLightSmer of
      0: If WinConf.Symbol[I]<3 then Inc(WinConf.Symbol[I]) else SymbolLightSmer:=1;
      1: If WinConf.Symbol[I]>0 then Dec(WinConf.Symbol[I]) else SymbolLightSmer:=0;
    End; {Case End}
    If Linie[0].Indicator[2]=0 then Linie[0].Indicator[2]:=1
                               else Linie[0].Indicator[2]:=0;
    If Linie[1].Indicator[2]=0 then Linie[1].Indicator[2]:=1
                               else Linie[1].Indicator[2]:=0;
  End;

  If WinConf.Vyhra[2]=True then
  Begin
    For I:=4 to 6 do
    Case SymbolLightSmer of
      0: If WinConf.Symbol[I]<3 then Inc(WinConf.Symbol[I]) else SymbolLightSmer:=1;
      1: If WinConf.Symbol[I]>0 then Dec(WinConf.Symbol[I]) else SymbolLightSmer:=0;
    End; {Case End}
    If Linie[0].Indicator[3]=0 then Linie[0].Indicator[3]:=1
                               else Linie[0].Indicator[3]:=0;
    If Linie[1].Indicator[3]=0 then Linie[1].Indicator[3]:=1
                               else Linie[1].Indicator[3]:=0;
  End;

  If WinConf.Vyhra[3]=True then
  Begin
    For I:=7 to 9 do
    Case SymbolLightSmer of
      0: If WinConf.Symbol[I]<3 then Inc(WinConf.Symbol[I]) else SymbolLightSmer:=1;
      1: If WinConf.Symbol[I]>0 then Dec(WinConf.Symbol[I]) else SymbolLightSmer:=0;
    End; {Case End}
    If Linie[0].Indicator[4]=0 then Linie[0].Indicator[4]:=1
                               else Linie[0].Indicator[4]:=0;
    If Linie[1].Indicator[4]=0 then Linie[1].Indicator[4]:=1
                               else Linie[1].Indicator[4]:=0;
  End;

  If WinConf.Vyhra[4]=True then
  Begin
    If WinConf.Vyhra[1]=False then
    Case SymbolLightSmer of
      0: If WinConf.Symbol[1]<3 then Inc(WinConf.Symbol[1]) else SymbolLightSmer:=1;
      1: If WinConf.Symbol[1]>0 then Dec(WinConf.Symbol[1]) else SymbolLightSmer:=0;
    End; {Case End}
    If WinConf.Vyhra[2]=False then
    Case SymbolLightSmer of
      0: If WinConf.Symbol[5]<3 then Inc(WinConf.Symbol[5]) else SymbolLightSmer:=1;
      1: If WinConf.Symbol[5]>0 then Dec(WinConf.Symbol[5]) else SymbolLightSmer:=0;
    End; {Case End}
    If WinConf.Vyhra[3]=False then
    Case SymbolLightSmer of
      0: If WinConf.Symbol[9]<3 then Inc(WinConf.Symbol[9]) else SymbolLightSmer:=1;
      1: If WinConf.Symbol[9]>0 then Dec(WinConf.Symbol[9]) else SymbolLightSmer:=0;
    End; {Case End}
    If Linie[0].Indicator[1]=0 then Linie[0].Indicator[1]:=1
                               else Linie[0].Indicator[1]:=0;
    If Linie[1].Indicator[5]=0 then Linie[1].Indicator[5]:=1
                               else Linie[1].Indicator[5]:=0;
  End;

  If WinConf.Vyhra[5]=True then
  Begin
    If WinConf.Vyhra[3]=False then
    Case SymbolLightSmer of
      0: If WinConf.Symbol[7]<3 then Inc(WinConf.Symbol[7]) else SymbolLightSmer:=1;
      1: If WinConf.Symbol[7]>0 then Dec(WinConf.Symbol[7]) else SymbolLightSmer:=0;
    End; {Case End}
    If ((WinConf.Vyhra[2]=False) and (WinConf.Vyhra[4]=False))  then
    Case SymbolLightSmer of
      0: If WinConf.Symbol[5]<3 then Inc(WinConf.Symbol[5]) else SymbolLightSmer:=1;
      1: If WinConf.Symbol[5]>0 then Dec(WinConf.Symbol[5]) else SymbolLightSmer:=0;
    End; {Case End}
    If WinConf.Vyhra[1]=False then
    Case SymbolLightSmer of
      0: If WinConf.Symbol[3]<3 then Inc(WinConf.Symbol[3]) else SymbolLightSmer:=1;
      1: If WinConf.Symbol[3]>0 then Dec(WinConf.Symbol[3]) else SymbolLightSmer:=0;
    End; {Case End}
    If Linie[0].Indicator[5]=0 then Linie[0].Indicator[5]:=1
                               else Linie[0].Indicator[5]:=0;
    If Linie[1].Indicator[1]=0 then Linie[1].Indicator[1]:=1
                               else Linie[1].Indicator[1]:=0;
  End;
End;


Procedure KresliBlikani(S1,S2,S3,S4,S5,S6,S7,S8,S9:Byte;BufferTo:Word);
Begin
  Blok(0,125,111,199,ColorUnknown,Buffer[0]);

  Ramecek(4,126,37,199,ColorRedDark,Buffer[0]);
  Ramecek(39,126,72,199,ColorRedDark,Buffer[0]);
  Ramecek(74,126,107,199,ColorRedDark,Buffer[0]);

  WriteSymbolLight(5,127+Valec[0].Scroll,Valec[0].Symbol[1],WinConf.Symbol[1],S1,0,0,Buffer[0]);
  WriteSymbolLight(40,127+Valec[1].Scroll,Valec[1].Symbol[1],WinConf.Symbol[2],S2,0,0,Buffer[0]);
  WriteSymbolLight(75,127+Valec[2].Scroll,Valec[2].Symbol[1],WinConf.Symbol[3],S3,0,0,Buffer[0]);

  WriteSymbolLight(5,127+Valec[0].Scroll+24,Valec[0].Symbol[2],WinConf.Symbol[4],S4,0,0,Buffer[0]);
  WriteSymbolLight(40,127+Valec[1].Scroll+24,Valec[1].Symbol[2],WinConf.Symbol[5],S5,0,0,Buffer[0]);
  WriteSymbolLight(75,127+Valec[2].Scroll+24,Valec[2].Symbol[2],WinConf.Symbol[6],S6,0,0,Buffer[0]);

  WriteSymbolLight(5,127+Valec[0].Scroll+48,Valec[0].Symbol[3],WinConf.Symbol[7],S7,0,0,Buffer[0]);
  WriteSymbolLight(40,127+Valec[1].Scroll+48,Valec[1].Symbol[3],WinConf.Symbol[8],S8,0,0,Buffer[0]);
  WriteSymbolLight(75,127+Valec[2].Scroll+48,Valec[2].Symbol[3],WinConf.Symbol[9],S9,0,0,Buffer[0]);

  For I:=0 to 1 do
  Begin
    If Linie[I].Indicator[1]=1 then Blok(I*109,126,I*109+2,128,ColorWhite,Buffer[0])
                               else Blok(I*109,126,I*109+2,128,ColorRedDark,Buffer[0]);
    If Linie[I].Indicator[2]=1 then Blok(I*109,137,I*109+2,139,ColorWhite,Buffer[0])
                               else Blok(I*109,137,I*109+2,139,ColorRedDark,Buffer[0]);
    If Linie[I].Indicator[3]=1 then Blok(I*109,161,I*109+2,163,ColorWhite,Buffer[0])
                               else Blok(I*109,161,I*109+2,163,ColorRedDark,Buffer[0]);
    If Linie[I].Indicator[4]=1 then Blok(I*109,185,I*109+2,187,ColorWhite,Buffer[0])
                               else Blok(I*109,185,I*109+2,187,ColorRedDark,Buffer[0]);
    If Linie[I].Indicator[5]=1 then Blok(I*109,197,I*109+2,199,ColorWhite,Buffer[0])
                               else Blok(I*109,197,I*109+2,199,ColorRedDark,Buffer[0]);
  End;

  HideMouse;
  WriteBlok(103,46,0,125,111,199,Buffer[0],BufferTo);
  ShowMouse;
End;


Procedure WinBlink;
Var I: Byte;
Begin
  BezVyhry:=False;
  SymbolLight:=0;
  Light1:=0;
  Light2:=0;
  Light3:=0;
  WinConf.Counter1:=0;
  WinConf.Counter2:=0;
  WinConf.Counter3:=0;
  For I:=1 to 5 do
  Begin
    Linie[0].Indicator[I]:=0;
    Linie[1].Indicator[I]:=0;
  End;
  KresliValce(SymbolLight,Light1,Light1,Light1,Buffer[3]);
  KresliValce(SymbolLight,Light1,Light1,Light1,Buffer[4]);

  Case WinConf.SoundSet of
    0: If DatRec.SBEnable=True
       then SBPlayRaw(5)
       else PlayRaw(5);

    9: If DatRec.SBEnable=True
       then SBPlayRaw(6)
       else PlayRaw(6);

    8: If DatRec.SBEnable=True
       then SBPlayRaw(4)
       else PlayRaw(4);
  End; {Case End}

  Repeat
    If DatRec.SBEnable=True then
    Begin {Sound Blaster povoleny}
      If ((WinConf.SoundSet>0) and (WinConf.SoundSet<6)) then
      Begin
        If WinConf.Counter2<15 then Inc(WinConf.Counter2)
                               else Begin
                                      WinConf.Counter2:=0;
                                      Case WinConf.SoundSet of
                                        1: SBPlayRaw(2);
                                        2: SBPlayRaw(42);
                                        3: SBPlayRaw(43);
                                        4: SBPlayRaw(45);
                                        5: SBPlayRaw(37);
                                        6: SBPlayRaw(29);
                                      End; {Case End}
                                    End;
      End;

      If WinConf.SoundSet=6 then
      Begin
        If WinConf.Counter2<15 then Inc(WinConf.Counter2)
                               else Begin
                                      WinConf.Counter2:=0;
                                      SBPlayRaw(8);
                                    End;
      End;

      If WinConf.SoundSet=7 then
      Begin
        If WinConf.Counter2<15 then Inc(WinConf.Counter2)
                               else Begin
                                      WinConf.Counter2:=0;
                                      SBPlayRaw(3);
                                    End;
      End;
    End else
    Begin {Sound Blaster zakazany}
      If WinConf.Counter2<15 then Inc(WinConf.Counter2)
                             else Begin
                                    WinConf.Counter2:=0;
                                    Case WinConf.SoundSet of
                                      1: PlaySound(14);
                                      2: PlaySound(18);
                                      3: PlaySound(17);
                                      4: PlaySound(17);
                                      5: PlaySound(19);
                                      6: PlaySound(19);
                                      7: PlaySound(23);
                                    End; {Case End}
                                  End;
    End;

    Blinking;
    If Light2<15 then Inc(Light2)
                 else Light2:=0;
    Case Light2 of
    0: Light1:=0;
    1: Light1:=1;
    2: Light1:=2;
    3: Light1:=3;
    4: Light1:=4;
    5: Light1:=3;
    6: Light1:=2;
    7: Light1:=1;
    8: Light1:=1;
    9: Light1:=2;
    10: Light1:=3;
    11: Light1:=4;
    12: Light1:=3;
    13: Light1:=2;
    14: Light1:=1;
    15: Light1:=0;
    End {Case End};
    If WinConf.Vyhra[1]=True then KresliBlikani(Light1,Light1,Light1,0,0,0,0,0,0,Buffer[4]);
    If WinConf.Vyhra[2]=True then KresliBlikani(0,0,0,Light1,Light1,Light1,0,0,0,Buffer[4]);
    If WinConf.Vyhra[3]=True then KresliBlikani(0,0,0,0,0,0,Light1,Light1,Light1,Buffer[4]);
    If WinConf.Vyhra[4]=True then KresliBlikani(Light1,0,0,0,Light1,0,0,0,Light1,Buffer[4]);
    If WinConf.Vyhra[5]=True then KresliBlikani(0,0,Light1,0,Light1,0,Light1,0,0,Buffer[4]);
    TestStopAutoStart;
    Wait(DatRec.fpsProdleva);
    Inc(WinConf.Counter1);
  Until WinConf.Counter1=199;
  If WinConf.SoundSet=7 then For I:=0 to 79 do Wait(DatRec.fpsProdleva);
  For I:=1 to 9 do WinConf.Symbol[I]:=0;
  Repeat
    If Light1>0 then Dec(Light1);
    If WinConf.Vyhra[1]=True then KresliBlikani(Light1,Light1,Light1,0,0,0,0,0,0,Buffer[4]);
    If WinConf.Vyhra[2]=True then KresliBlikani(0,0,0,Light1,Light1,Light1,0,0,0,Buffer[4]);
    If WinConf.Vyhra[3]=True then KresliBlikani(0,0,0,0,0,0,Light1,Light1,Light1,Buffer[4]);
    If WinConf.Vyhra[4]=True then KresliBlikani(Light1,0,0,0,Light1,0,0,0,Light1,Buffer[4]);
    If WinConf.Vyhra[5]=True then KresliBlikani(0,0,Light1,0,Light1,0,Light1,0,0,Buffer[4]);
  Until Light1=0;
  For I:=1 to 5 do
  Begin
    WinConf.Vyhra[I]:=False;
    Linie[0].Indicator[I]:=0;
    Linie[1].Indicator[I]:=0;
  End;
  If JackPotPadl=True then JackPotWin;
End;