Procedure SetGameButtons;
Begin
  Button[0].Open:=True;
  Button[0].Blink1:=True;
  Button[0].Blink2:=False;
  If Hotovost1>=5 then Begin
                        Button[1].Open:=True;
                        Button[1].Blink2:=True;
                        Button[1].Blink1:=False;
                      End
                 else Begin
                        Button[1].Open:=False;
                        Button[1].Blink2:=False;
                        Button[1].Blink1:=False;
                      End;
  If Score>=5    then Begin
                        Button[2].Open:=True;
                        Button[2].Blink2:=True;
                        Button[2].Blink1:=False;
                      End
                 else Begin
                        Button[2].Open:=False;
                        Button[2].Blink2:=False;
                        Button[2].Blink1:=False;
                      End;
  If Credit>5    then Begin
                        Button[3].Open:=True;
                        Button[3].Blink2:=True;
                        Button[3].Blink1:=False;
                      End
                 else Begin
                        Button[3].Open:=False;
                        Button[3].Blink2:=False;
                        Button[3].Blink1:=False;
                        Sazka:=5; BetCounter:=0;
                      End;
  If Credit>=Sazka then Begin
                          Button[4].Open:=True;
                          Button[4].Blink2:=True;
                          Button[4].Blink1:=False;
                        End
                   else Begin
                          Button[4].Open:=False;
                          Button[4].Blink2:=False;
                          Button[4].Blink1:=False;
                        End;
End;


Procedure ProcesTlacitka;
Var I: Byte;
Begin
  {Blinking}
  SetGameButtons;
  For I:=0 to 4 do
  Begin
    If Button[I].Blink1=True then
    Begin
      If Button[I].Counter<11 then Inc(Button[I].Counter) else Button[I].Counter:=0;
      If Button[I].Counter<=6 then Button[I].Phase:=0 else Button[I].Phase:=1;
    End;
    If Button[I].Blink2=True then
    Begin
      If Button[I].Counter<7 then Inc(Button[I].Counter) else Button[I].Counter:=0;
      If Button[I].Counter<=4 then Button[I].Phase:=0 else Button[I].Phase:=1;
    End;
  End;

  {Functions}
{X} If Button[0].Pressed=True then
    Begin
      StopAllBlink;
      SetButtons2;
      StopPlay;
      If Score>0 then Vybrat;
      StopPlay;
      PlaySound(5);
      Wait(500);
      Ending:=True;
    End;

{C} If Button[1].Pressed=True then
    Begin
      StopAllBlink;
      SetButtons2;
      FundDialog;
      SetGameButtons;
      WriteAutomatScreen;
    End;

{V} If (Button[2].Pressed=True) and (Score>=5) then
    Begin
      StopAllBlink;
      SetButtons2;
      StopPlay;
      Vybrat;
      SetGameButtons;
    End;

{B} If Button[3].Pressed=True then
    Begin
      StopAllBlink;
      SetButtons2;
      SetBet;
      Wait(200);
      SetGameButtons;
      WriteAutomatScreen;
    End;

{N} If Button[4].Pressed=True then
    Begin
      StopAllBlink;
      SetButtons2;
      Roll;
      SetGameButtons;
      WriteAutomatScreen;
    End;
End;
