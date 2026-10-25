Procedure RiskDohra;
Begin
  HideMouse;

  Btn[0].Phase:=0;
  BtnCol.Phase:=0;
  SetButtonColor(0);
  SetButtonColor(12);

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

  Risk.DohraCounter:=0;
  Risk.Counter:=0;
  RiskSpeed:=1;

  Repeat
    WaitRetrace;

    If Risk.Counter<RiskSpeed
                      then Inc(Risk.Counter)
                      else Begin
                             Risk.Counter:=0;
                             Inc(Risk.DohraCounter);

                             If Risk.Phase=0 then Begin
                                                    Risk.Phase:=1;
                                                    Hlava.Enable:=False;
                                                    Orel.Enable:=True;
                                                  End
                                             else Begin
                                                    Risk.Phase:=0;
                                                    Hlava.Enable:=True;
                                                    Orel.Enable:=False;
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

  Until Risk.DohraCounter=50;

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

  ShowMouse;
End;


Procedure RiskHorni;
Var losovani: Word;
Begin
    Key[35]:=False;  {HLAVA}
    Key[24]:=False;  {OREL}
    Repeat
       RiskScreen;
       If AutoStart=True then
       Begin
         Dec(RiskRandom2);
         If RiskRandom2=0 then
         Begin
           RiskAuto:=False;
           If RiskRandom1=0 then Begin {RiskRandom1=0}
                                   losovani:=RiskRandom4;
                                   If losovani<DatRec.Nahoda[9] then
                                   Begin {WIN}
                                     If Hlava.Enable=True then
                                      Begin
                                       Key[35]:=True;   {HLAVA AUTO TRUE}
                                       Key[24]:=False;  {OREL AUTO FALSE}
                                     End;
                                     If Orel.Enable=True then
                                     Begin
                                       Key[35]:=False;  {HLAVA AUTO FALSE}
                                       Key[24]:=True;   {OREL AUTO TRUE}
                                     End;
                                   End else
                                   Begin {LOSE}
                                     If Hlava.Enable=True then
                                     Begin
                                       Key[35]:=False;  {HLAVA AUTO FALSE}
                                       Key[24]:=True;   {OREL AUTO TRUE}
                                     End;
                                     If Orel.Enable=True then
                                     Begin
                                       Key[35]:=True;   {HLAVA AUTO TRUE}
                                       Key[24]:=False;  {OREL AUTO FALSE}
                                     End;
                                   End;
                                 End
                            else Begin {RiskRandom1=1}
                                   losovani:=RiskRandom4;
                                   If losovani<DatRec.Nahoda[9] then
                                   Begin {WIN}
                                     If Hlava.Enable=True then
                                     Begin
                                       Key[35]:=True;   {HLAVA AUTO TRUE}
                                       Key[24]:=False;  {OREL AUTO FALSE}
                                     End;
                                     If Orel.Enable=True then
                                     Begin
                                       Key[35]:=False;  {HLAVA AUTO FALSE}
                                       Key[24]:=True;   {OREL AUTO TRUE}
                                     End;
                                   End else
                                   Begin {LOSE}
                                     If Hlava.Enable=True then
                                     Begin
                                       Key[35]:=False;  {HLAVA AUTO FALSE}
                                       Key[24]:=True;   {OREL AUTO TRUE}
                                     End;
                                     If Orel.Enable=True then
                                     Begin
                                       Key[35]:=True;   {HLAVA AUTO TRUE}
                                       Key[24]:=False;  {OREL AUTO FALSE}
                                     End;
                                   End;
                                 End;
         End;
       End;
       For N:=0 to DatRec.fpsProdleva+1 do
       Begin
{HLAVA}  If ((Key[35]=True) or (HlavaStiskly1=1)) then
         Begin
           If DatRec.SBEnable=True then SBPlayRaw(46);
           If AutoStart=False then While Key[35]=True do Begin End;
           If AutoStart=False then While HlavaStiskly1=1 do Begin End;
           If Key[35]=True then Key[35]:=False;
           NextVyhra:=Vyhra.Castka*2;

           Btn[4].Phase:=3;
           SetButtonColor(4);
           Btn[5].Phase:=0;
           SetButtonColor(5);
           RiskDohra;

           If NextVyhra<3000 then
           Begin
             If Hlava.Enable=True then Begin
                                         Vyhra.Castka:=Vyhra.Castka*2;
                                         If AutoStart=True then
                                         Begin
                                           Inc(RiskCounter);
                                         End;
                                         If DatRec.SBEnable=True
                                         then SBPlayRaw(1)
                                         else PlaySound(16);
                                         For I:=0 to 49 do Wait(DatRec.fpsProdleva);
                                       End
                                  else Begin
                                         Vyhra.Castka:=0;
                                         If AutoStart=True then
                                         Begin
                                           RiskCounter:=2;
                                         End;
                                         If DatRec.SBEnable=True
                                         then SBPlayRaw(9)
                                         else PlaySound(21);
                                         For I:=0 to 49 do Wait(DatRec.fpsProdleva);
                                       End;
             RiskRandom3:=Random(2);
             If RiskRandom3=0 then Risk.Phase:=0
                              else Risk.Phase:=1;
           End else
           Begin
             If Hlava.Enable=True then Begin
                                         If AutoStart=True then
                                         Begin
                                           NextVyhra:=3000;
                                           Vyhra.Castka:=3000;
                                           RiskCounter:=2;
                                         End else
                                         Begin
                                           NextVyhra:=3000;
                                           Vyhra.Castka:=3000;
                                         End;
                                         If DatRec.SBEnable=True
                                         then SBPlayRaw(1)
                                         else PlaySound(16);
                                         For I:=0 to 49 do Wait(DatRec.fpsProdleva);
                                       End
                                  else Begin
                                         Vyhra.Castka:=0;
                                         If AutoStart=True then
                                         Begin
                                           RiskCounter:=2;
                                         End;
                                         If DatRec.SBEnable=True
                                         then SBPlayRaw(9)
                                         else PlaySound(21);
                                         For I:=0 to 49 do Wait(DatRec.fpsProdleva);
                                       End;
           End;
         End;

{OREL}   If ((Key[24]=True) or (OrelStiskly1=1)) then
         Begin
           If DatRec.SBEnable=True then SBPlayRaw(46);
           If AutoStart=False then While Key[24]=True do Begin End;
           If AutoStart=False then While OrelStiskly1=1 do Begin End;
           If Key[24]=True then Key[24]:=False;
           NextVyhra:=Vyhra.Castka*2;

           Btn[4].Phase:=0;
           SetButtonColor(4);
           Btn[5].Phase:=3;
           SetButtonColor(5);
           RiskDohra;

           If NextVyhra<3000 then
           Begin
             If Orel.Enable=True then Begin
                                        Vyhra.Castka:=Vyhra.Castka*2;
                                        If AutoStart=True then
                                        Begin
                                          Inc(RiskCounter);
                                        End;
                                        If DatRec.SBEnable=True
                                        then SBPlayRaw(1)
                                        else PlaySound(16);
                                        For I:=0 to 49 do Wait(DatRec.fpsProdleva);
                                      End
                                 else Begin
                                        Vyhra.Castka:=0;
                                        If AutoStart=True then
                                        Begin
                                          RiskCounter:=2;
                                        End;
                                        If DatRec.SBEnable=True
                                        then SBPlayRaw(9)
                                        else PlaySound(21);
                                        For I:=0 to 49 do Wait(DatRec.fpsProdleva);
                                      End;
             RiskRandom3:=Random(2);
             If RiskRandom3=0 then Risk.Phase:=0
                              else Risk.Phase:=1;
           End else
           Begin
             If Orel.Enable=True then Begin
                                        NextVyhra:=3000;
                                        Vyhra.Castka:=3000;
                                        If AutoStart=True then
                                        Begin
                                          NextVyhra:=3000;
                                          Vyhra.Castka:=3000;
                                          RiskCounter:=2;
                                        End else
                                        Begin
                                          NextVyhra:=3000;
                                          Vyhra.Castka:=3000;
                                        End;
                                        If DatRec.SBEnable=True
                                        then SBPlayRaw(1)
                                        else PlaySound(16);
                                        For I:=0 to 49 do Wait(DatRec.fpsProdleva);
                                      End
                                 else Begin
                                        Vyhra.Castka:=0;
                                        If AutoStart=True then
                                        Begin
                                          RiskCounter:=2;
                                        End;
                                        If DatRec.SBEnable=True
                                        then SBPlayRaw(9)
                                        else PlaySound(21);
                                        For I:=0 to 49 do Wait(DatRec.fpsProdleva);
                                      End;
           End;
         End;

{MULTI}  If (((Key[50]=True) or (Key[57]=True) or (DoMultiwinuStiskly1=1)) and (AutoStart=False)) then
         Begin
           If DatRec.SBEnable=True then SBPlayRaw(46);
           While Key[50]=True do Begin End;
           While Key[57]=True do Begin End;
           While DoMultiwinuStiskly1=1 do Begin End;
           Risk.Enable:=False;
           Risk.Blinking:=False;
           For I:=0 to 8 do
           Begin
             Btn[I].Blinking:=False;
             Btn[I].Smer:=0;
             Btn[I].Phase:=0;
             SetButtonColor(I);
           End;
           BtnCol.Blinking:=False;
           BtnCol.Smer:=0;
           BtnCol.Phase:=3;
           SetButtonColor(12);
           MainGameScreen;
           RiskAuto:=False;
         End;

{COLL}   If (((Key[46]=True) or (CollectStiskly1=1)) and (AutoStart=False)) then
         Begin
           If DatRec.SBEnable=True then SBPlayRaw(46);
           While Key[46]=True do Begin End;
           While CollectStiskly1=1 do Begin End;
           Risk.Enable:=False;
           Risk.Blinking:=False;
           For I:=0 to 8 do
           Begin
             Btn[I].Blinking:=False;
             Btn[I].Smer:=0;
             Btn[I].Phase:=0;
             SetButtonColor(I);
           End;
           BtnCol.Blinking:=False;
           BtnCol.Smer:=0;
           BtnCol.Phase:=3;
           SetButtonColor(12);
           MainGameScreen;
           AddScoreCollect(Vyhra.Castka);
         End;

{AUTO}   If ((RiskRandom2=0) and (RiskAuto=False) and (AutoStart=True)) then
         Begin
           Risk.Enable:=False;
           Risk.Blinking:=False;
           For I:=0 to 8 do
           Begin
             Btn[I].Blinking:=False;
             Btn[I].Smer:=0;
             Btn[I].Phase:=0;
             SetButtonColor(I);
           End;
           BtnCol.Blinking:=False;
           BtnCol.Smer:=0;
           BtnCol.Phase:=3;
           SetButtonColor(12);
           MainGameScreen;
         End;
         TestStopAutoStart;
         Wait(1);
       End;
    Until ((Vyhra.Castka=0) or (NextVyhra=3000) or (RiskAuto=False));
    Key[35]:=False;  {HLAVA}
    Key[24]:=False;  {OREL}
End;


Procedure RiskHorniNahodny;
Var losovani: Word;
Begin
  Repeat
     RiskScreen;
     For N:=0 to ((DatRec.fpsProdleva+1)*5) do
     Begin
       If ((Key[35]=True) or (HlavaStiskly1=1) or
           (Key[24]=True) or (OrelStiskly1=1)) then
       Begin
         losovani:=Random(65535);
         If losovani<DatRec.Nahoda[9] then
         Begin {pokazde vyhra}
           If ((Key[35]=True) or (HlavaStiskly1=1)) then
           Begin
             If DatRec.SBEnable=True then SBPlayRaw(46);
             While Key[35]=True do Begin End;
             While HlavaStiskly1=1 do Begin End;

             Btn[4].Phase:=3;
             SetButtonColor(4);
             Btn[5].Phase:=0;
             SetButtonColor(5);
             RiskDohra;

             Hlava.Enable:=True;
             Orel.Enable:=False;
             MainGameScreen;
           End;
           If ((Key[24]=True) or (OrelStiskly1=1)) then
           Begin
             If DatRec.SBEnable=True then SBPlayRaw(46);
             While Key[24]=True do Begin End;
             While HlavaStiskly1=1 do Begin End;

             Btn[4].Phase:=0;
             SetButtonColor(4);
             Btn[5].Phase:=3;
             SetButtonColor(5);
             RiskDohra;

             Hlava.Enable:=False;
             Orel.Enable:=True;
             MainGameScreen;
           End;
           NextVyhra:=Vyhra.Castka*2;
           If NextVyhra<3000 then
           Begin
             Vyhra.Castka:=Vyhra.Castka*2;
             If DatRec.SBEnable=True
             then SBPlayRaw(1)
             else PlaySound(16);
             For I:=0 to 49 do Wait(DatRec.fpsProdleva);
           End else
           Begin
             NextVyhra:=3000;
             Vyhra.Castka:=3000;
             If DatRec.SBEnable=True
             then SBPlayRaw(1)
             else PlaySound(16);
             For I:=0 to 49 do Wait(DatRec.fpsProdleva);
           End;
         End else
         Begin {pokazde prohra}
           If ((Key[35]=True) or (HlavaStiskly1=1)) then
           Begin
             If DatRec.SBEnable=True then SBPlayRaw(46);
             While Key[35]=True do Begin End;
             While HlavaStiskly1=1 do Begin End;

             Btn[4].Phase:=3;
             SetButtonColor(4);
             Btn[5].Phase:=0;
             SetButtonColor(5);
             RiskDohra;

             Hlava.Enable:=False;
             Orel.Enable:=True;
             MainGameScreen;
           End;
           If ((Key[24]=True) or (OrelStiskly1=1)) then
           Begin
             If DatRec.SBEnable=True then SBPlayRaw(46);
             While Key[24]=True do Begin End;
             While HlavaStiskly1=1 do Begin End;

             Btn[4].Phase:=0;
             SetButtonColor(4);
             Btn[5].Phase:=3;
             SetButtonColor(5);
             RiskDohra;

             Hlava.Enable:=True;
             Orel.Enable:=False;
             MainGameScreen;
           End;
           Vyhra.Castka:=0;
           If DatRec.SBEnable=True
           then SBPlayRaw(9)
           else PlaySound(21);
           For I:=0 to 49 do Wait(DatRec.fpsProdleva);
         End;
       End;
{MULTI}  If (((Key[50]=True) or (Key[57]=True) or (DoMultiwinuStiskly1=1)) and (AutoStart=False)) then
         Begin
           If DatRec.SBEnable=True then SBPlayRaw(46);
           While Key[50]=True do Begin End;
           While Key[57]=True do Begin End;
           While DoMultiwinuStiskly1=1 do Begin End;
           Risk.Enable:=False;
           Risk.Blinking:=False;
           For I:=0 to 8 do
           Begin
             Btn[I].Blinking:=False;
             Btn[I].Smer:=0;
             Btn[I].Phase:=0;
             SetButtonColor(I);
           End;
           BtnCol.Blinking:=False;
           BtnCol.Smer:=0;
           BtnCol.Phase:=3;
           SetButtonColor(12);
           MainGameScreen;
           RiskAuto:=False;
         End;
{COLL}   If (((Key[46]=True) or (CollectStiskly1=1)) and (AutoStart=False)) then
         Begin
           If DatRec.SBEnable=True then SBPlayRaw(46);
           While Key[46]=True do Begin End;
           While CollectStiskly1=1 do Begin End;
           Risk.Enable:=False;
           Risk.Blinking:=False;
           For I:=0 to 8 do
           Begin
             Btn[I].Blinking:=False;
             Btn[I].Smer:=0;
             Btn[I].Phase:=0;
             SetButtonColor(I);
           End;
           BtnCol.Blinking:=False;
           BtnCol.Smer:=0;
           BtnCol.Phase:=3;
           SetButtonColor(12);
           MainGameScreen;
           AddScoreCollect(Vyhra.Castka);
           RiskAuto:=False;
         End;
     End;
  Until ((Vyhra.Castka=0) or (NextVyhra=3000) or (RiskAuto=False));
End;