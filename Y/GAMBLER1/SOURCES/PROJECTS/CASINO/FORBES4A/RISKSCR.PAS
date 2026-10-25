Procedure RiskScreen;
Begin
  WaitRetrace;
  HideMouse;

  {DISPLAY WIN + CREDIT}
  Blok(109,141,210,149,ColorBlack,Buffer[4]);
  Ramecek(108,138,211,150,ColorRedDark,Buffer[4]);
  Blok(118,136,138,140,ColorBlack,Buffer[4]);
  WriteText(Buffer[1],160,60,5,5,1,120,136,'win',Buffer[4]);
  Blok(168,136,206,140,ColorBlack,Buffer[4]);
  WriteText(Buffer[1],160,60,5,5,1,170,136,'credit',Buffer[4]);

  If VyhraShow=True then
  Begin
    If Vyhra.Castka<10 then WriteNumber(Buffer[1],160,96,5,7,1,130,142,Vyhra.Castka,Buffer[4]);
    If Vyhra.Castka>=100 then WriteNumber(Buffer[1],160,96,5,7,1,120,142,Vyhra.Castka,Buffer[4]);
    If ((Vyhra.Castka>=10) and (Vyhra.Castka<100)) then WriteNumber(Buffer[1],160,96,5,7,1,125,142,Vyhra.Castka,Buffer[4]);
  End;

  If CreditShow=True then
  Begin
    If Credit<10 then WriteNumber(Buffer[1],160,96,5,7,1,200,142,Credit,Buffer[4]);
    If ((Credit>=10) and (Credit<100)) then WriteNumber(Buffer[1],160,96,5,7,1,194,142,Credit,Buffer[4]);
    If ((Credit>=100) and (Credit<1000)) then WriteNumber(Buffer[1],160,96,5,7,1,188,142,Credit,Buffer[4]);
    If ((Credit>=1000) and (Credit<10000)) then WriteNumber(Buffer[1],160,96,5,7,1,182,142,Credit,Buffer[4]);
    If ((Credit>=10000) and (Credit<100000)) then WriteNumber(Buffer[1],160,96,5,7,1,176,142,Credit,Buffer[4]);
    If ((Credit>=100000) and (Credit<1000000)) then WriteNumber(Buffer[1],160,96,5,7,1,170,142,Credit,Buffer[4]);
    If ((Credit>=1000000) and (Credit<9999999)) then WriteNumber(Buffer[1],160,96,5,7,1,164,142,Credit,Buffer[4]);
  End;

  {HLAVA OREL BLINKING}
  If Risk.Blinking=True then
  Begin
    If Risk.Counter<RiskSpeed
                      then Inc(Risk.Counter)
                      else Begin
                             Risk.Counter:=0;
                             If RiskSpeedCounter>0 then Dec(RiskSpeedCounter)
                                                   else Begin
                                                          RiskSpeedCounter:=3;
                                                          If RiskSPDCounter>0
                                                          then Dec(RiskSPDCounter)
                                                          else RiskSPDCounter:=1;
                                                        End;
                             If RiskSpeedCounter=0 then
                             Case RiskSPDCounter of
                               0: RiskSpeed:=1;
                               1: RiskSpeed:=2;
                             End; {Case End}
                             If Risk.Phase=0 then Begin
                                                    Risk.Phase:=1;
                                                    Hlava.Enable:=False;
                                                    Orel.Enable:=True;
                                                    ButtonBlink(4);
                                                    ButtonBlink(5);
                                                    ButtonBlink(0);
                                                    ButtonBlink(12);
                                                  End
                                             else Begin
                                                    Risk.Phase:=0;
                                                    Hlava.Enable:=True;
                                                    Orel.Enable:=False;
                                                    ButtonBlink(4);
                                                    ButtonBlink(5);
                                                    ButtonBlink(0);
                                                    ButtonBlink(12);
                                                  End;
                           End;
  End;

  {HLAVA OREL}
  Begin
    WriteSprite(252,82,100,116,131,131,Buffer[1],Buffer[4]); {RISK}
    If Hlava.Enable=True then WriteSprite(220,104,0,140,47,179,Buffer[1],Buffer[4])
                         else WriteSprite(220,104,0,100,47,139,Buffer[1],Buffer[4]);
    If Orel.Enable=True then WriteSprite(268,104,48,140,95,179,Buffer[1],Buffer[4])
                        else WriteSprite(268,104,48,100,95,139,Buffer[1],Buffer[4]);
  End;

  {Button COLLECT}
  Blok(0,185,44,199,BtnCol.Color,Buffer[4]);
  Ramecek(0,185,44,199,ColorRedDark,Buffer[4]);
  WriteText(Buffer[1],160,60,5,5,1,38,187,'c',Buffer[4]);
  WriteText(Buffer[1],160,60,5,5,1,2,193,'collect',Buffer[4]);

  {Button MULTIWIN}
  Blok(148,185,198,199,Btn[0].Color,Buffer[4]);
  Ramecek(148,185,198,199,ColorGreen,Buffer[4]);
  WriteText(Buffer[1],160,20,5,5,1,192,187,'m',Buffer[4]);
  WriteText(Buffer[1],160,20,5,5,1,150,193,'multiwin',Buffer[4]);

  {Button HLAVA}
  Blok(200,185,238,199,Btn[4].Color,Buffer[4]);
  Ramecek(200,185,238,199,ColorGreen,Buffer[4]);
  WriteText(Buffer[1],160,20,5,5,1,232,187,'h',Buffer[4]);
  WriteText(Buffer[1],160,20,5,5,1,202,193,'hlava',Buffer[4]);

  {Button OREL}
  Blok(240,185,276,199,Btn[5].Color,Buffer[4]);
  Ramecek(240,185,276,199,ColorGreen,Buffer[4]);
  WriteText(Buffer[1],160,20,5,5,1,270,187,'o',Buffer[4]);
  WriteText(Buffer[1],160,20,5,5,1,242,193,'orel',Buffer[4]);

  ShowMouse;
End;
