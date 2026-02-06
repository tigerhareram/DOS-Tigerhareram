Procedure SetAllButtons4;
Begin
  Button4[0].Blinking:=True;
  If Hotovost4>=5 then Button4[1].Blinking:=True
                 else Button4[1].Blinking:=False;
  If Score4>=5 then Button4[2].Blinking:=True
               else Button4[2].Blinking:=False;
  If Credit4>=10 then Button4[3].Blinking:=True
                 else Button4[3].Blinking:=False;
  If Credit4>=Sazka4 then Begin
                            Button4[4].Blinking:=True;
                            Button4[5].Blinking:=True;
                            Button4[6].Blinking:=True;
                          End
                     else Begin
                            Button4[4].Blinking:=False;
                            Button4[5].Blinking:=False;
                            Button4[6].Blinking:=False;
                            Sazka4:=5;
                            BetBT4:=0;
                          End;
  If Score4>=5 then Button4[7].Blinking:=True
               else Button4[7].Blinking:=False;
End;


Procedure StopAllBlinking4;
Var I: Byte;
Begin
  For I:=0 to 7 do Button4[I].Phase:=0;
End;

Procedure Button4Blinking;

  Procedure Button4BlinkingHelp(I,Speed: Byte);
  Begin
    If Button4[I].Blinking=True then
      Begin
      If Button4[I].Counter<Speed then Inc(Button4[I].Counter)
                                else Button4[I].Counter:=0;
      If Button4[I].Counter=0 then
      Begin
        If Button4[I].Phase=0 then Button4[I].Phase:=1
                              else Button4[I].Phase:=0;
      End;
    End Else
    Begin
      Button4[I].Phase:=0;
      Button4[I].Counter:=0;
    End;
  End;

Var N: Byte;
Begin
  Button4BlinkingHelp(0,8);
  For N:=1 to 3 do Button4BlinkingHelp(N,7);
  Button4BlinkingHelp(4,5);
  For N:=5 to 7 do Button4BlinkingHelp(N,7);
End;


Procedure ProcesTlacitka4;
Begin
  Button4Blinking;


{X} If ((Button4[0].Pressed=True) and (Button4[0].Blinking=True)) then
    Begin
      StopAllBlinking4;
      If Score4>0 then Vybrat4;
      WriteAutomatScreen4;
      Ending4:=True;
    End;

{C} If ((Button4[1].Pressed=True) and (Button4[1].Blinking=True)) then
    Begin
      StopAllBlinking4;
      FundDiag4:=True;
      StopPlay;
      PlaySound(1);
      WriteAutomatScreen4;
      SetAllButtons4;
    End;

{V} If ((Button4[2].Pressed=True) and (Button4[2].Blinking=True)) then
    Begin
      StopAllBlinking4;
      Vybrat4;
      SetAllButtons4;
    End;

{B} If ((Button4[3].Pressed=True) and (Button4[3].Blinking=True)) then
    Begin
      StopAllBlinking4;
      SetBet4;
      WriteAutomatScreen4;
      SetAllButtons4;
    End;

{N} If ((Button4[4].Pressed=True) and (Button4[4].Blinking=True)) then
    Begin
      StopAllBlinking4;
      Dec(Credit4,Sazka4);
      WriteAutomatScreen4;
      RullMain;
      TestWin4;
      RuletaStoji:=True;
      SetAllButtons4;
    End;

{H} If ((Button4[5].Pressed=True) and (Button4[5].Blinking=True)) then
    Begin
      StopAllBlinking4;
      If TypSazky>0 then Dec(TypSazky) else TypSazky:=MaxSazek;
      StopPlay;
      PlaySound(9);
      SetSazka;
      WriteAutomatScreen4;
      SetAllButtons4;
    End;

{J} If ((Button4[6].Pressed=True) and (Button4[6].Blinking=True)) then
    Begin
      StopAllBlinking4;
      If TypSazky<MaxSazek then Inc(TypSazky) else TypSazky:=0;
      StopPlay;
      PlaySound(9);
      SetSazka;
      WriteAutomatScreen4;
      SetAllButtons4;
    End;

{P} If ((Button4[7].Pressed=True) and (Button4[7].Blinking=True)) then
    Begin
      StopAllBlinking4;
      Vybrat4P;
      SetAllButtons4;
    End;

End;