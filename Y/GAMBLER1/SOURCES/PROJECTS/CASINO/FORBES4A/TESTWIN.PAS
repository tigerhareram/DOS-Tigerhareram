Procedure SetWildJoker;
Var I: Byte;
    cekani: Word;
    cekani2: Word;
    cekani3: Word;
    Color: Byte;
    Tmp: array[1..3] of Byte;

  Procedure ZhasniObrazek(Obrazek,Color:Byte);
  Var I: Byte;
      Color16Plus: Byte;
  Begin
    Color16Plus:=Color+16;
    cekani:=0;
    cekani2:=0;
    cekani3:=0;
    Repeat
      Inc(cekani2);
      Inc(cekani3);
      If cekani2=2 then
      Begin
        cekani2:=0;
        GetPal(Color,Tmp[1],Tmp[2],Tmp[3]);
        If Tmp[1]>0 then Dec(Tmp[1]);
        If Tmp[2]>0 then Dec(Tmp[2]);
        If Tmp[3]>0 then Dec(Tmp[3]);
        SetPal(Color,Tmp[1],Tmp[2],Tmp[3]);
      End;
      If cekani3=2 then
      Begin
        cekani3:=0;
        If Color<Color16Plus then Inc(Color) else Color:=Color16Plus-16;
      End;
      TestStopAutoStart;
      Inc(cekani);
      Wait(1);
    Until cekani=2600;
    For I:=144 to 223 do BlackPal(I);
    If Obrazek<4
    then Begin
           WriteBlok(30,44,(Obrazek+1)*64,24,(Obrazek+1)*64+63,87,Buffer[2],Buffer[3]);
           WaitRetrace;
           WriteBlok(30,44,(Obrazek+1)*64,24,(Obrazek+1)*64+63,87,Buffer[2],Buffer[4]);
         End
    else Begin
           WriteBlok(30,44,0,24,63,87,Buffer[2],Buffer[3]);
           WaitRetrace;
           WriteBlok(30,44,0,24,63,87,Buffer[2],Buffer[4]);
         End;
    If ObrazekCounter<9 then Inc(ObrazekCounter) else ObrazekCounter:=0;
  End;

  Procedure RozsvitObrazek(Obrazek,Color:Byte);
  Var I: Byte;
      Barva: Byte;
      Color16Plus: Byte;
  Begin
    Color16Plus:=Color+16;
    cekani:=0;
    cekani2:=0;
    cekani3:=0;
    Repeat
      Inc(cekani2);
      Inc(cekani3);
      If cekani2=2 then
      Begin
        cekani2:=0;
        GetPal(Color,Tmp[1],Tmp[2],Tmp[3]);
        If Tmp[1]<ColorBackup[Color].R then Inc(Tmp[1]);
        If Tmp[2]<ColorBackup[Color].G then Inc(Tmp[2]);
        If Tmp[3]<ColorBackup[Color].B then Inc(Tmp[3]);
        SetPal(Color,Tmp[1],Tmp[2],Tmp[3]);
      End;
      If cekani3=2 then
      Begin
        cekani3:=0;
        If Color<Color16Plus then Inc(Color) else Color:=Color16Plus-16;
      End;
      TestStopAutoStart;
      Inc(cekani);
      Wait(1);
    Until cekani=2600;
    If ObrazekCounter<9 then Inc(ObrazekCounter) else ObrazekCounter:=0;
  End;

Begin
 If BezEfektu=False then
 Begin
  If DatRec.SBEnable=True
  then SBPlayRaw(36)
  else PlaySound(21);

Case ObrazekCounter of
0: Begin ZhasniObrazek(0,208);  End;
1: Begin RozsvitObrazek(1,192); End;
2: Begin ZhasniObrazek(1,192);  End;
3: Begin RozsvitObrazek(2,176); End;
4: Begin ZhasniObrazek(2,176);  End;
5: Begin RozsvitObrazek(3,160); End;
6: Begin ZhasniObrazek(3,160);  End;
7: Begin RozsvitObrazek(4,144); End;
8: Begin ZhasniObrazek(4,144);  End;
9: Begin RozsvitObrazek(0,208); End;
End; {Case End}

  Case Bet of
    2: Inc(DatRec2.JackPot,Bet);
    4: Inc(DatRec2.JackPot,Bet);
    5: Inc(DatRec2.JackPot,(Bet+BetMulti));
  End; {Case End}

 End;
End;


Procedure JokerSetup;
Var JokerBool: Word;
    rand1: Word;
Begin
  WinBude:=True;
  If Lista[0].Enable=True then
  Begin
    If Bet=2 then
    Begin
      JokerBool:=Random(65535);
      If JokerBool<DatRec.Nahoda[1] then Begin
                                           WildJoker:=False;
                                           rand1:=Random(65535);
                                           If rand1>DatRec.Nahoda[2] then Joker2x:=False
                                                                     else Joker2x:=True;
                                          End
                                     else Begin WildJoker:=True; Joker2x:=False; End;
    End;
    If Bet=4 then
    Begin
      JokerBool:=Random(65535);
      If JokerBool<DatRec.Nahoda[4] then Begin {24000}
                                           WildJoker:=False;
                                           rand1:=Random(65535);
                                           If rand1>DatRec.Nahoda[5] then Joker2x:=False {47000}
                                                                     else Joker2x:=True;
                                         End
                                    else Begin WildJoker:=True; Joker2x:=False; End;
    End;
  End;

  If Lista[1].Enable=True then
  Begin
    JokerBool:=Random(65535);
    If JokerBool<DatRec.Nahoda[7] then Begin
                                         WildJoker:=False;
                                         rand1:=Random(65535);
                                         If rand1>DatRec.Nahoda[8] then Joker2x:=False
                                                                   else Joker2x:=True;
                                       End
                                  else Begin WildJoker:=True; Joker2x:=False; End;
  End;
End;


Procedure WaitJokerPlus;
Begin
  VyhraShow:=True;
  CreditShow:=False;
  MainGameScreen;
  For I:=0 to 49 do
  Begin
    TestStopAutoStart;
    Wait(DatRec.fpsProdleva);
  End;
End;


Procedure IncVyhra(I,N: Byte);
Var A: Byte;
Begin
  Case Valec[I].Symbol[N] of
    1: Begin
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,8)
                                     else Inc(Vyhra.Castka,16);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,8)
                                       else Inc(Vyhra.Castka,16);
             WaitJokerPlus;
           End;
         End else
         Begin
           Inc(Vyhra.Castka,40);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             Inc(Vyhra.Castka,40);
             WaitJokerPlus;
           End;
         End;
       End;
    2: Begin
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,16)
                                     else Inc(Vyhra.Castka,24);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,16)
                                       else Inc(Vyhra.Castka,24);
             WaitJokerPlus;
           End;
         End else
         Begin
           Inc(Vyhra.Castka,40);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             Inc(Vyhra.Castka,40);
             WaitJokerPlus;
           End;
         End;
       End;
    3: Begin
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,24)
                                     else Inc(Vyhra.Castka,32);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,24)
                                       else Inc(Vyhra.Castka,32);
             WaitJokerPlus;
           End;
         End else
         Begin
           Inc(Vyhra.Castka,80);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             Inc(Vyhra.Castka,80);
             WaitJokerPlus;
           End;
         End;
       End;
    4: Begin
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,32)
                                     else Inc(Vyhra.Castka,40);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,32)
                                       else Inc(Vyhra.Castka,40);
             WaitJokerPlus;
           End;
         End else
         Begin
           Inc(Vyhra.Castka,80);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             Inc(Vyhra.Castka,80);
             WaitJokerPlus;
           End;
         End;
       End;
    5: Begin
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,40)
                                     else Inc(Vyhra.Castka,80);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,40)
                                       else Inc(Vyhra.Castka,80);
             WaitJokerPlus;
           End;
         End else
         Begin
           Inc(Vyhra.Castka,120);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             Inc(Vyhra.Castka,120);
             WaitJokerPlus;
           End;
         End;
       End;
    6: Begin
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,80)
                                     else Inc(Vyhra.Castka,120);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,80)
                                       else Inc(Vyhra.Castka,120);
             WaitJokerPlus;
           End;
         End else
         Begin
           Inc(Vyhra.Castka,160);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             Inc(Vyhra.Castka,160);
             WaitJokerPlus;
           End;
         End;
       End;
    7: Begin
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,120)
                                     else Inc(Vyhra.Castka,160);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,120)
                                       else Inc(Vyhra.Castka,160);
             WaitJokerPlus;
           End;
         End else
         Begin
           Inc(Vyhra.Castka,200);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             Inc(Vyhra.Castka,200);
             WaitJokerPlus;
           End;
         End;
       End;
    8: Begin
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,160)
                                     else Inc(Vyhra.Castka,200);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,160)
                                       else Inc(Vyhra.Castka,200);
             WaitJokerPlus;
           End;
         End else
         Begin
           Inc(Vyhra.Castka,300);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             Inc(Vyhra.Castka,300);
             WaitJokerPlus;
           End;
         End;
       End;
    9: Begin
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,200)
                                     else Inc(Vyhra.Castka,240);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,200)
                                       else Inc(Vyhra.Castka,240);
             WaitJokerPlus;
           End;
         End else
         Begin
           Inc(Vyhra.Castka,400);
           If Joker2x=True then
           Begin
             WaitJokerPlus;
             Inc(Vyhra.Castka,400);
             WaitJokerPlus;
           End;
         End;
       End;
    0: Begin
         JackPotPadl:=True;
         If Lista[0].Enable=True then
         Begin
           If Lista[0].Sazka[0]=True then Inc(Vyhra.Castka,400)
                                     else Inc(Vyhra.Castka,400);
         End else
         Begin
           Inc(Vyhra.Castka,750);
         End;
       End;
  End; {Case End}
  WinConf.SoundSet:=Valec[I].Symbol[N];
  Blok(109,141,210,149,ColorBlack,Buffer[3]);
  WriteText(Buffer[1],160,140,5,7,1,116,142,'win   win   win',Buffer[3]);
  WaitRetrace;
  HideMouse;
  FlipPage(Buffer[3],Buffer[4]);
  ShowMouse;
  For A:=0 to 49 do
  Begin
    TestStopAutoStart;
    Wait(DatRec.fpsProdleva);
  End;
  VyhraShow:=True;
  CreditShow:=False;
  MainGameScreen;
  Joker2x:=False;
End;


Procedure TestWin;
Begin
  Joker2x:=False;
  BezVyhry:=True;

  If ((Valec[0].Symbol[1]>0) and (Valec[0].Symbol[1]=Valec[1].Symbol[1]) and (Valec[1].Symbol[1]=Valec[2].Symbol[1])) then
  Begin
    WinBude:=True;
    If BezEfektu=False then
    Begin
      IncVyhra(0,1);
      WinConf.Symbol[1]:=1;
      WinConf.Symbol[2]:=1;
      WinConf.Symbol[3]:=1;
      WinConf.Vyhra[1]:=True;
      WinBlink;
    End;
  End;

  If ((Valec[0].Symbol[2]>0) and (Valec[0].Symbol[2]=Valec[1].Symbol[2]) and (Valec[1].Symbol[2]=Valec[2].Symbol[2])) then
  Begin
    WinBude:=True;
    If BezEfektu=False then
    Begin
      IncVyhra(0,2);
      WinConf.Symbol[4]:=1;
      WinConf.Symbol[5]:=1;
      WinConf.Symbol[6]:=1;
      WinConf.Vyhra[2]:=True;
      WinBlink;
    End;
  End;

  If ((Valec[0].Symbol[3]>0) and (Valec[0].Symbol[3]=Valec[1].Symbol[3]) and (Valec[1].Symbol[3]=Valec[2].Symbol[3])) then
  Begin
    WinBude:=True;
    If BezEfektu=False then
    Begin
      IncVyhra(0,3);
      WinConf.Symbol[7]:=1;
      WinConf.Symbol[8]:=1;
      WinConf.Symbol[9]:=1;
      WinConf.Vyhra[3]:=True;
      WinBlink;
    End;
  End;

  If ((Valec[0].Symbol[1]>0) and (Valec[0].Symbol[1]=Valec[1].Symbol[2]) and (Valec[1].Symbol[2]=Valec[2].Symbol[3])) then
  Begin
    WinBude:=True;
    If BezEfektu=False then
    Begin
      IncVyhra(0,1);
      WinConf.Symbol[1]:=1;
      WinConf.Symbol[5]:=1;
      WinConf.Symbol[9]:=1;
      WinConf.Vyhra[4]:=True;
      WinBlink;
    End;
  End;

  If ((Valec[0].Symbol[3]>0) and (Valec[0].Symbol[3]=Valec[1].Symbol[2]) and (Valec[1].Symbol[2]=Valec[2].Symbol[1])) then
  Begin
    WinBude:=True;
    If BezEfektu=False then
    Begin
      IncVyhra(0,3);
      WinConf.Symbol[7]:=1;
      WinConf.Symbol[5]:=1;
      WinConf.Symbol[3]:=1;
      WinConf.Vyhra[5]:=True;
      WinBlink;
    End;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[1]=Valec[2].Symbol[1])) or
     ((Valec[1].Symbol[1]=0) and (Valec[0].Symbol[1]=Valec[2].Symbol[1])) or
     ((Valec[2].Symbol[1]=0) and (Valec[0].Symbol[1]=Valec[1].Symbol[1])) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        If ((Valec[0].Symbol[1]=0) and (WinConf.Vyhra[1]=False)) then
        Begin IncVyhra(1,1); WinConf.Vyhra[1]:=True; End;
        If ((Valec[1].Symbol[1]=0) and (WinConf.Vyhra[1]=False)) then
        Begin IncVyhra(2,1); WinConf.Vyhra[1]:=True; End;
        If ((Valec[2].Symbol[1]=0) and (WinConf.Vyhra[1]=False)) then
        Begin IncVyhra(0,1); WinConf.Vyhra[1]:=True; End;
        WinConf.Symbol[1]:=1;
        WinConf.Symbol[2]:=1;
        WinConf.Symbol[3]:=1;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[2]=0) and (Valec[1].Symbol[2]=Valec[2].Symbol[2])) or
     ((Valec[1].Symbol[2]=0) and (Valec[0].Symbol[2]=Valec[2].Symbol[2])) or
     ((Valec[2].Symbol[2]=0) and (Valec[0].Symbol[2]=Valec[1].Symbol[2])) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        If ((Valec[0].Symbol[2]=0) and (WinConf.Vyhra[2]=False)) then
        Begin IncVyhra(1,2); WinConf.Vyhra[2]:=True; End;
        If ((Valec[1].Symbol[2]=0) and (WinConf.Vyhra[2]=False)) then
        Begin IncVyhra(2,2); WinConf.Vyhra[2]:=True; End;
        If ((Valec[2].Symbol[2]=0) and (WinConf.Vyhra[2]=False)) then
        Begin IncVyhra(0,2); WinConf.Vyhra[2]:=True; End;
        WinConf.Symbol[4]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[6]:=1;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[3]=Valec[2].Symbol[3])) or
     ((Valec[1].Symbol[3]=0) and (Valec[0].Symbol[3]=Valec[2].Symbol[3])) or
     ((Valec[2].Symbol[3]=0) and (Valec[0].Symbol[3]=Valec[1].Symbol[3])) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        If ((Valec[0].Symbol[3]=0) and (WinConf.Vyhra[3]=False)) then
        Begin IncVyhra(1,3); WinConf.Vyhra[3]:=True; End;
        If ((Valec[1].Symbol[3]=0) and (WinConf.Vyhra[3]=False)) then
        Begin IncVyhra(2,3); WinConf.Vyhra[3]:=True; End;
        If ((Valec[2].Symbol[3]=0) and (WinConf.Vyhra[3]=False)) then
        Begin IncVyhra(0,3); WinConf.Vyhra[3]:=True; End;
        WinConf.Symbol[7]:=1;
        WinConf.Symbol[8]:=1;
        WinConf.Symbol[9]:=1;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[2]=Valec[2].Symbol[3])) or
     ((Valec[1].Symbol[2]=0) and (Valec[0].Symbol[1]=Valec[2].Symbol[3])) or
     ((Valec[2].Symbol[3]=0) and (Valec[0].Symbol[1]=Valec[1].Symbol[2])) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        If ((Valec[0].Symbol[1]=0) and (WinConf.Vyhra[4]=False)) then
        Begin IncVyhra(1,2); WinConf.Vyhra[4]:=True; End;
        If ((Valec[1].Symbol[2]=0) and (WinConf.Vyhra[4]=False)) then
        Begin IncVyhra(2,3); WinConf.Vyhra[4]:=True; End;
        If ((Valec[2].Symbol[3]=0) and (WinConf.Vyhra[4]=False)) then
        Begin IncVyhra(0,1); WinConf.Vyhra[4]:=True; End;
        WinConf.Symbol[1]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[9]:=1;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[2]=Valec[2].Symbol[1])) or
     ((Valec[1].Symbol[2]=0) and (Valec[0].Symbol[3]=Valec[2].Symbol[1])) or
     ((Valec[2].Symbol[1]=0) and (Valec[0].Symbol[3]=Valec[1].Symbol[2])) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        If ((Valec[0].Symbol[3]=0) and (WinConf.Vyhra[5]=False)) then
        Begin IncVyhra(1,2); WinConf.Vyhra[5]:=True; End;
        If ((Valec[1].Symbol[2]=0) and (WinConf.Vyhra[5]=False)) then
        Begin IncVyhra(2,1); WinConf.Vyhra[5]:=True; End;
        If ((Valec[2].Symbol[1]=0) and (WinConf.Vyhra[5]=False)) then
        Begin IncVyhra(0,3); WinConf.Vyhra[5]:=True; End;
        WinConf.Symbol[3]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[7]:=1;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[1]=0) and (Valec[2].Symbol[1]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(2,1);
        WinConf.Symbol[1]:=1;
        WinConf.Symbol[2]:=1;
        WinConf.Symbol[3]:=1;
        WinConf.Vyhra[1]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[2].Symbol[1]=0) and (Valec[1].Symbol[1]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(1,1);
        WinConf.Symbol[1]:=1;
        WinConf.Symbol[2]:=1;
        WinConf.Symbol[3]:=1;
        WinConf.Vyhra[1]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[1].Symbol[1]=0) and (Valec[2].Symbol[1]=0) and (Valec[0].Symbol[1]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(0,1);
        WinConf.Symbol[1]:=1;
        WinConf.Symbol[2]:=1;
        WinConf.Symbol[3]:=1;
        WinConf.Vyhra[1]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[2]=0) and (Valec[1].Symbol[2]=0) and (Valec[2].Symbol[2]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(2,2);
        WinConf.Symbol[4]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[6]:=1;
        WinConf.Vyhra[2]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[2]=0) and (Valec[2].Symbol[2]=0) and (Valec[1].Symbol[2]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(1,2);
        WinConf.Symbol[4]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[6]:=1;
        WinConf.Vyhra[2]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[1].Symbol[2]=0) and (Valec[2].Symbol[2]=0) and (Valec[0].Symbol[2]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(0,2);
        WinConf.Symbol[4]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[6]:=1;
        WinConf.Vyhra[2]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[3]=0) and (Valec[2].Symbol[3]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
    If BezEfektu=False then
      Begin
        IncVyhra(2,3);
        WinConf.Symbol[7]:=1;
        WinConf.Symbol[8]:=1;
        WinConf.Symbol[9]:=1;
        WinConf.Vyhra[3]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[2].Symbol[3]=0) and (Valec[1].Symbol[3]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(1,3);
        WinConf.Symbol[7]:=1;
        WinConf.Symbol[8]:=1;
        WinConf.Symbol[9]:=1;
        WinConf.Vyhra[3]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[1].Symbol[3]=0) and (Valec[2].Symbol[3]=0) and (Valec[0].Symbol[3]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(0,3);
        WinConf.Symbol[7]:=1;
        WinConf.Symbol[8]:=1;
        WinConf.Symbol[9]:=1;
        WinConf.Vyhra[3]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[1].Symbol[2]=0) and (Valec[2].Symbol[3]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(2,3);
        WinConf.Symbol[1]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[9]:=1;
        WinConf.Vyhra[4]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[1]=0) and (Valec[2].Symbol[3]=0) and (Valec[1].Symbol[2]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(1,2);
        WinConf.Symbol[1]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[9]:=1;
        WinConf.Vyhra[4]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[1].Symbol[2]=0) and (Valec[2].Symbol[3]=0) and (Valec[0].Symbol[1]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(0,1);
        WinConf.Symbol[1]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[9]:=1;
        WinConf.Vyhra[4]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[1].Symbol[2]=0) and (Valec[2].Symbol[1]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(2,1);
        WinConf.Symbol[7]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[3]:=1;
        WinConf.Vyhra[5]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[0].Symbol[3]=0) and (Valec[2].Symbol[1]=0) and (Valec[1].Symbol[2]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(1,2);
        WinConf.Symbol[7]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[3]:=1;
        WinConf.Vyhra[5]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  If ((Valec[1].Symbol[2]=0) and (Valec[2].Symbol[1]=0) and (Valec[0].Symbol[3]>0)) then
  Begin
    JokerSetup;
    If WildJoker=False then
    Begin
      If BezEfektu=False then
      Begin
        IncVyhra(0,3);
        WinConf.Symbol[7]:=1;
        WinConf.Symbol[5]:=1;
        WinConf.Symbol[3]:=1;
        WinConf.Vyhra[5]:=True;
        WinBlink;
      End;
    End else SetWildJoker;
  End;

  Joker2x:=False;
End;