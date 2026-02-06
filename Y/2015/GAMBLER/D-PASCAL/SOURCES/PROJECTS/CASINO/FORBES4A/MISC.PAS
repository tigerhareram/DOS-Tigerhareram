Procedure TestStopAutoStart;
Var I: Byte;
    textmsg: string;
Begin
  If ((AutoStart=True) and ((AutostartStiskly1=1) or (Key[30]=True))) then
  Begin
    If DatRec.SBEnable=True then SBPlayRaw(46);
    While Key[30]=True do Begin End;
    If AutoStartTyp<7 then Inc(AutoStartTyp)
                      else AutoStartTyp:=1;
    If WinGamble.Enable=True then
    Begin
      textmsg:='autostart off';
      AutoStart:=False;
      AutoStartTyp:=7;
    End else
    Case AutoStartTyp of
     1: textmsg:='risk male 1x';
     2: textmsg:='risk male 2x';
     3: textmsg:='risk velke 1x';
     4: textmsg:='risk velke 2x';
     5: textmsg:='risk vse 1x';
     6: textmsg:='risk vse 2x';
     7: Begin textmsg:='autostart off'; AutoStart:=False; End;
    End; {Case End}
    KresliValce(SymbolLight,LightJ,LightK,LightL,Buffer[3]);
    Blok(109,141,210,149,ColorBlack,Buffer[3]);
    WriteText(Buffer[1],160,140,5,7,1,120,142,textmsg,Buffer[3]);
    WaitRetrace;
    FlipPage(Buffer[3],Buffer[4]);
    For I:=0 to 29 do Wait(DatRec.fpsProdleva);
  End;
End;


Procedure TestBetDown;

  Procedure DecSound;
  Var I: Byte;
  Begin
    For I:=0 to 9 do Wait(DatRec.fpsProdleva);
    MainGameScreen;
    If DatRec.SBEnable=True
    then SBPlayRaw(7)
    else PlaySound(20);
    For I:=0 to 49 do Wait(DatRec.fpsProdleva);
  End;

Begin
  If Credit<Bet then
  Begin
    Bet:=2;
    BetMulti:=0;
    BetCounter:=0;
    Nasobic:=0;
    Lista[1].Enable:=False;
    Lista[0].Enable:=True;
    Lista[0].Sazka[0]:=True;
    Lista[0].Sazka[1]:=False;
    DecSound;
  End;

  If MultiWin<BetMulti then
  Begin
    If MultiWin>=95 then BetMulti:=95;
    If ((MultiWin>=85) and (MultiWin<95)) then Begin
                                                 BetMulti:=85;
                                                 Nasobic:=9;
                                                 BetCounter:=10;
                                                 DecSound;
                                               End;
    If ((MultiWin>=75) and (MultiWin<85)) then Begin
                                                 BetMulti:=75;
                                                 Nasobic:=8;
                                                 BetCounter:=9;
                                                 DecSound;
                                               End;
    If ((MultiWin>=65) and (MultiWin<75)) then Begin
                                                 BetMulti:=65;
                                                 Nasobic:=7;
                                                 BetCounter:=8;
                                                 DecSound;
                                               End;
    If ((MultiWin>=55) and (MultiWin<65)) then Begin
                                                 BetMulti:=55;
                                                 Nasobic:=6;
                                                 BetCounter:=7;
                                                 DecSound;
                                               End;
    If ((MultiWin>=45) and (MultiWin<55)) then Begin
                                                 BetMulti:=45;
                                                 Nasobic:=5;
                                                 BetCounter:=6;
                                                 DecSound;
                                               End;
    If ((MultiWin>=35) and (MultiWin<45)) then Begin
                                                 BetMulti:=35;
                                                 Nasobic:=4;
                                                 BetCounter:=5;
                                                 DecSound;
                                               End;
    If ((MultiWin>=25) and (MultiWin<35)) then Begin
                                                 BetMulti:=25;
                                                 Nasobic:=3;
                                                 BetCounter:=4;
                                                 DecSound;
                                               End;
    If ((MultiWin>=15) and (MultiWin<25)) then Begin
                                                 BetMulti:=15;
                                                 Nasobic:=2;
                                                 BetCounter:=3;
                                                 DecSound;
                                               End;

    If ((MultiWin>=5) and (MultiWin<15)) then  Begin
                                                 BetMulti:=5;
                                                 Nasobic:=1;
                                                 BetCounter:=2;
                                                 DecSound;
                                               End;
    If MultiWin<5 then Begin
                         BetMulti:=0;
                         Bet:=2;
                         Nasobic:=0;
                         BetCounter:=0;
                         Lista[1].Enable:=False;
                         Lista[0].Enable:=True;
                         Lista[0].Sazka[0]:=True;
                         Lista[0].Sazka[1]:=False;
                         DecSound;
                        End;
  End;
End;


Function TestRollEnable: Boolean;
Begin
  If ((Credit>=Bet) and (MultiWin>=BetMulti)) then TestRollEnable:=True
                                              else TestRollEnable:=False;
End;


Procedure SetButtonColor(I: Byte);
Begin
  If ((I>=0) and (I<=3)) then
  Case Btn[I].Phase of
    0: Btn[I].Color:=ColorButtonA1;
    1: Btn[I].Color:=ColorButtonA2;
    2: Btn[I].Color:=ColorButtonA3;
    3: Btn[I].Color:=ColorButtonA4;
    4: Btn[I].Color:=ColorButtonA5;
  End; {Case End}
  If ((I=4) or (I=5)) then
  Case Btn[I].Phase of
    0: Btn[I].Color:=ColorBlue1;
    1: Btn[I].Color:=ColorBlue2;
    2: Btn[I].Color:=ColorBlue3;
    3: Btn[I].Color:=ColorBlue4;
  End; {Case End}
  If ((I=6) or (I=7)) then
  Case Btn[I].Phase of
    0: Btn[I].Color:=ColorButtonB1;
    1: Btn[I].Color:=ColorButtonB2;
    2: Btn[I].Color:=ColorButtonB3;
    3: Btn[I].Color:=ColorButtonB4;
    4: Btn[I].Color:=ColorButtonB5;
  End; {Case End}
  If I=8 then
  Case Btn[I].Phase of
    0: Btn[I].Color:=ColorButtonC1;
    1: Btn[I].Color:=ColorButtonC2;
    2: Btn[I].Color:=ColorButtonC3;
    3: Btn[I].Color:=ColorButtonC4;
  End; {Case End}
  If I>=9 then
  Case StopButton[I-9].Phase of
    0: StopButton[I-9].Color:=ColorButtonA1;
    1: StopButton[I-9].Color:=ColorButtonA2;
    2: StopButton[I-9].Color:=ColorButtonA3;
    3: StopButton[I-9].Color:=ColorButtonA4;
    4: StopButton[I-9].Color:=ColorButtonA5;
  End; {Case End}
  If I=12 then
  Case BtnCol.Phase of
    0: BtnCol.Color:=ColorButtonC1;
    1: BtnCol.Color:=ColorButtonC2;
    2: BtnCol.Color:=ColorButtonC3;
    3: BtnCol.Color:=ColorButtonC4;
  End; {Case End}
End;


Procedure ButtonBlink(I: Byte);
Begin
  If I<8 then
  Case Btn[I].Smer of
    0: If Btn[I].Phase<4 then Inc(Btn[I].Phase) else Btn[I].Smer:=1;
    1: If Btn[I].Phase>0 then Dec(Btn[I].Phase) else Btn[I].Smer:=0;
  End; {Case End}
  If I=8 then
  Case Btn[I].Smer of
    0: If Btn[I].Phase<3 then Inc(Btn[I].Phase) else Btn[I].Smer:=1;
    1: If Btn[I].Phase>0 then Dec(Btn[I].Phase) else Btn[I].Smer:=0;
  End; {Case End}
  If I>=9 then
  Case StopButton[I-9].Smer of
    0: If StopButton[I-9].Phase<4 then Inc(StopButton[I-9].Phase) else StopButton[I-9].Smer:=1;
    1: If StopButton[I-9].Phase>0 then Dec(StopButton[I-9].Phase) else StopButton[I-9].Smer:=0;
  End; {Case End}
  If I=12 then
  Case BtnCol.Smer of
    0: If BtnCol.Phase<3 then Inc(BtnCol.Phase) else BtnCol.Smer:=1;
    1: If BtnCol.Phase>0 then Dec(BtnCol.Phase) else BtnCol.Smer:=0;
  End; {Case End}
  SetButtonColor(I);
End;
