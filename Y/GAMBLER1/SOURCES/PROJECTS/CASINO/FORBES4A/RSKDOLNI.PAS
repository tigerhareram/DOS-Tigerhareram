Procedure RiskDolni;
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

           If NextVyhra<1500 then
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
                                           NextVyhra:=1500;
                                           Vyhra.Castka:=1500;
                                           RiskCounter:=2;
                                         End else
                                         Begin
                                           NextVyhra:=1500;
                                           Vyhra.Castka:=1500;
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

           If NextVyhra<1500 then
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
                                        If AutoStart=True then
                                        Begin
                                          NextVyhra:=1500;
                                          Vyhra.Castka:=1500;
                                          RiskCounter:=2;
                                        End else
                                        Begin
                                          NextVyhra:=1500;
                                          Vyhra.Castka:=1500;
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
           MainGameScreen;
           AddScore(Vyhra.Castka);
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
    Until ((Vyhra.Castka=0) or (NextVyhra=1500) or (RiskAuto=False));
    Key[35]:=False;  {HLAVA}
    Key[24]:=False;  {OREL}
End;


Procedure RiskDolniNahodny;
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
           If NextVyhra<1500 then
           Begin
             Vyhra.Castka:=Vyhra.Castka*2;
             If DatRec.SBEnable=True
             then SBPlayRaw(1)
             else PlaySound(16);
             For I:=0 to 49 do Wait(DatRec.fpsProdleva);
           End else
           Begin
             NextVyhra:=1500;
             Vyhra.Castka:=1500;
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
           BtnCol.Phase:=0;
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
  Until ((Vyhra.Castka=0) or (NextVyhra=1500) or (RiskAuto=False));
End;