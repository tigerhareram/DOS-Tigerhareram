Procedure ServisScreen;
Var C: LongInt;
    I: Byte;
Begin
  ClearPage(Buffer[3]);

  Ramecek(0,0,319,199,ColorGreen,Buffer[3]);

  Ramecek(5,7,200,42,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,222,5,'tab  esc=exit',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,12,'vklady    =',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,22,'vyplaceno =',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,32,'gambler   =',Buffer[3]);
  WriteNumber(Buffer[1],160,15,5,5,1,78,12,DatRec2.Bonus,Buffer[3]);
  WriteNumber(Buffer[1],160,15,5,5,1,78,22,DatRec2.Pub.Vyplaceno,Buffer[3]);
  Zisky(78,32,255); {gambler bilance}

  Ramecek(5,47,200,92,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,52,'prodleva',Buffer[3]);
  WriteSprite(60,52,0,0,4,4,Buffer[1],Buffer[3]);
  For C:=1 to 50 do WritePixel(66+C,54,ColorGreen,Buffer[3]);
  WriteSprite(119,52,5,0,9,4,Buffer[1],Buffer[3]);
  WriteSprite(66+DatRec.fpsProdleva,52,10,0,12,4,Buffer[1],Buffer[3]);
  WriteNumber(Buffer[1],160,15,5,5,1,127,52,DatRec.fpsProdleva,Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,10,62,'l = rychlost =',Buffer[3]);
  WriteNumber(Buffer[1],160,15,5,5,1,97,62,5-DatRec.RollSpeed,Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,10,72,'v = light effect =',Buffer[3]);
  If DatRec.Svetla=True then WriteText(Buffer[1],160,0,5,5,1,122,72,'povoleno',Buffer[3])
                        else WriteText(Buffer[1],160,0,5,5,1,122,72,'zakazano',Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,10,82,'o = spin symbolu =',Buffer[3]);
  If DatRec.ModSpinu=0 then WriteNumber(Buffer[1],160,15,5,5,1,122,82,DatRec.SpinCounter,Buffer[3])
                       else WriteText(Buffer[1],160,0,5,5,1,122,82,'xxx',Buffer[3]);

  Ramecek(5,97,200,112,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,102,'b = sound blaster =',Buffer[3]);
  If DatRec.SBEnable=True then WriteText(Buffer[1],160,0,5,5,1,127,102,'povoleno',Buffer[3])
                          else WriteText(Buffer[1],160,0,5,5,1,127,102,'zakazano',Buffer[3]);

  Ramecek(5,117,200,172,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,122,'e = reset historie her',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,132,'r = reset vklady/vyplaceno',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,142,'n = reset majetku gamblera',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,152,'m = reset vyhernosti',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,162,'x = reset rychlosti',Buffer[3]);

  Ramecek(5,177,200,197,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,10,182,'h = hlava orel =',Buffer[3]);
  If DatRec.NahodnyRisk=True then WriteText(Buffer[1],160,0,5,5,1,110,182,'nahoda',Buffer[3])
                             else WriteText(Buffer[1],160,0,5,5,1,110,182,'postreh',Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,10,189,'c = algoritmus =',Buffer[3]);
  If DatRec.ModSpinu=0 then WriteText(Buffer[1],160,0,5,5,1,110,189,'nahoda',Buffer[3])
                       else WriteText(Buffer[1],160,0,5,5,1,110,189,'cyklus',Buffer[3]);

  For I:=0 to 9 do
  Begin
    Case I of
      0: Ramecek(210,(I*18)+15,317,(I*18)+31,ColorGreen,Buffer[3]);
      1: Ramecek(210,(I*18)+15,317,(I*18)+49,ColorGreen,Buffer[3]);
      3: Ramecek(210,(I*18)+15,317,(I*18)+31,ColorGreen,Buffer[3]);
      4: Ramecek(210,(I*18)+15,317,(I*18)+49,ColorGreen,Buffer[3]);
      6: Ramecek(210,(I*18)+15,317,(I*18)+31,ColorGreen,Buffer[3]);
      7: Ramecek(210,(I*18)+15,317,(I*18)+49,ColorGreen,Buffer[3]);
      9: Ramecek(210,(I*18)+15,317,(I*18)+31,ColorGreen,Buffer[3]);
    End;
    Case I of
     0: OutNumber(289,(I*18)+20,(((DatRec.Nahoda[0]) div ((RovnaMira1*2) div 100))*2),False,Buffer[3]);
     1: OutNumber(289,(I*18)+20,100-((DatRec.Nahoda[1]) div 655),False,Buffer[3]);
     2: OutNumber(289,(I*18)+20,DatRec.Nahoda[2] div 655,False,Buffer[3]);
     3: OutNumber(289,(I*18)+20,(((DatRec.Nahoda[3]) div ((RovnaMira2*2) div 100))*2),False,Buffer[3]);
     4: OutNumber(289,(I*18)+20,100-((DatRec.Nahoda[4]) div 655),False,Buffer[3]);
     5: OutNumber(289,(I*18)+20,DatRec.Nahoda[5] div 655,False,Buffer[3]);
     6: OutNumber(289,(I*18)+20,(((DatRec.Nahoda[6]) div ((RovnaMira3*2) div 100))*2),False,Buffer[3]);
     7: OutNumber(289,(I*18)+20,100-((DatRec.Nahoda[7]) div 655),False,Buffer[3]);
     8: OutNumber(289,(I*18)+20,DatRec.Nahoda[8] div 655,False,Buffer[3]);
     9: OutNumber(289,(I*18)+20,DatRec.Nahoda[9] div 655,False,Buffer[3]);
    End; {Case End}
    OutText(308,(I*18)+20,'%',Buffer[3]);
  End;
  Case VyhernostKurzorC of
    0: Ramecek(212,(VyhernostKurzorC*18)+17,315,(VyhernostKurzorC*18)+29,ColorRed,Buffer[3]);
    1: Ramecek(212,(VyhernostKurzorC*18)+17,315,(VyhernostKurzorC*18)+47,ColorRed,Buffer[3]);
    3: Ramecek(212,(VyhernostKurzorC*18)+17,315,(VyhernostKurzorC*18)+29,ColorRed,Buffer[3]);
    4: Ramecek(212,(VyhernostKurzorC*18)+17,315,(VyhernostKurzorC*18)+47,ColorRed,Buffer[3]);
    6: Ramecek(212,(VyhernostKurzorC*18)+17,315,(VyhernostKurzorC*18)+29,ColorRed,Buffer[3]);
    7: Ramecek(212,(VyhernostKurzorC*18)+17,315,(VyhernostKurzorC*18)+47,ColorRed,Buffer[3]);
    9: Ramecek(212,(VyhernostKurzorC*18)+17,315,(VyhernostKurzorC*18)+29,ColorRed,Buffer[3]);
   10: Ramecek(7,9,198,40,ColorRed,Buffer[3]);
   11: Ramecek(7,49,198,90,ColorRed,Buffer[3]);
   12: Ramecek(7,99,198,110,ColorRed,Buffer[3]);
   13: Ramecek(7,119,198,170,ColorRed,Buffer[3]);
   14: Ramecek(7,179,198,195,ColorRed,Buffer[3]);
  End;
  OutText(214,0*18+19,'2kü vÏhry',Buffer[3]);
  OutText(214,1*18+19,'2kü vÏsmÿch',Buffer[3]);
  OutText(214,2*18+19,'2kü Joker 2X',Buffer[3]);
  OutText(214,3*18+19,'4kü vÏhry',Buffer[3]);
  OutText(214,4*18+19,'4kü vÏsmÿch',Buffer[3]);
  OutText(214,5*18+19,'4kü Joker 2X',Buffer[3]);
  OutText(214,6*18+19,'5kü vÏhry',Buffer[3]);
  OutText(214,7*18+19,'5kü vÏsmÿch',Buffer[3]);
  OutText(214,8*18+19,'5kü Joker 2X',Buffer[3]);
  OutText(214,9*18+19,'1:1 risking',Buffer[3]);

  HideMouse;
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
  ShowMouse;
End;


Procedure Servis;
Var Ending: Boolean;
    I: Byte;
    Spin: Byte;
    procento: Word;
Begin
  LoadDefaultFont(160,0,ColorBlue,Buffer[1]);
  LoadDefaultFont(160,20,ColorGreen,Buffer[1]);
  LoadDefaultFont(160,40,ColorRed,Buffer[1]);
  LoadDefaultFont(160,60,ColorRedDark,Buffer[1]);

  LoadGrPage('GRA\daytona.gra',0);
  LoadBlok(0,0,0,195,12,199,Buffer[1]);

  SetPal(ColorBlue,30,30,63);
  SetPal(ColorGreen,0,40,0);
  SetPal(ColorRed,63,0,0);
  SetPal(ColorRedDark,20,0,0);
  SetPal(ColorTexter,19,22,63);

  Ending:=False;
  VyhernostKurzor:=7;
  VyhernostKurzorC:=10;

  Penize:=500000;
  Inc(DatRec2.Hotovost,Penize);
  Penize:=0;

  Repeat
    ServisScreen;
    Wait(DatRec.fpsProdleva);

{TAB}   If Key[15]=True then
        Begin
          While Key[15]=True do WaitButton(15);
          If VyhernostKurzor<11 then Inc(VyhernostKurzor)
                                else VyhernostKurzor:=0;
          Case VyhernostKurzor of
           0: VyhernostKurzorC:=0;
           1: VyhernostKurzorC:=1;
           2: VyhernostKurzorC:=3;
           3: VyhernostKurzorC:=4;
           4: VyhernostKurzorC:=6;
           5: VyhernostKurzorC:=7;
           6: VyhernostKurzorC:=9;
           7: VyhernostKurzorC:=10;
           8: VyhernostKurzorC:=11;
           9: VyhernostKurzorC:=12;
          10: VyhernostKurzorC:=13;
          11: VyhernostKurzorC:=14;
          End; {Case End}
        End;

{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          Case VyhernostKurzorC of

               {------------------- VYHERNOST ------------------------}

            0: If DatRec.Nahoda[0]<=(((RovnaMira1*2)-((RovnaMira1*2) div 100)))
               then Inc(DatRec.Nahoda[0],((RovnaMira1*2) div 100))
               else DatRec.Nahoda[0]:=(RovnaMira1*2);

            3: If DatRec.Nahoda[3]<=(((RovnaMira2*2)-((RovnaMira2*2) div 100)))
               then Inc(DatRec.Nahoda[3],((RovnaMira2*2) div 100))
               else DatRec.Nahoda[3]:=(RovnaMira2*2);

            6: If DatRec.Nahoda[6]<=(((RovnaMira3*2)-((RovnaMira3*2) div 100)))
               then Inc(DatRec.Nahoda[6],((RovnaMira3*2) div 100))
               else DatRec.Nahoda[6]:=(RovnaMira3*2);

               {-------------------- JOKERS --------------------------}

            1: Begin
                 If DatRec.Nahoda[1]>=32768+327
                 then Dec(DatRec.Nahoda[1],327)
                 else DatRec.Nahoda[1]:=32768;
               End;

            4: Begin
                 If DatRec.Nahoda[4]>=32768+327
                 then Dec(DatRec.Nahoda[4],327)
                 else DatRec.Nahoda[4]:=32768;
              End;

            7: Begin
                 If DatRec.Nahoda[7]>=32768+327
                 then Dec(DatRec.Nahoda[7],327)
                 else DatRec.Nahoda[7]:=32768;
               End;

               {------------------- RISKOVANI ------------------------}

            9: If DatRec.Nahoda[9]<=65535-655
               then Inc(DatRec.Nahoda[9],655)
               else DatRec.Nahoda[9]:=65535;

               {------------------- RYCHLOST -------------------------}

           11: If DatRec.fpsProdleva<30 then Inc(DatRec.fpsProdleva);

          End; {Case End}
        End;

{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          Case VyhernostKurzorC of

               {------------------- VYHERNOST ------------------------}

            0: If DatRec.Nahoda[0]>=(((RovnaMira1*2) div 100))
               then Dec(DatRec.Nahoda[0],((RovnaMira1*2) div 100))
               else DatRec.Nahoda[0]:=0;

            3: If DatRec.Nahoda[3]>=(((RovnaMira2*2) div 100))
               then Dec(DatRec.Nahoda[3],((RovnaMira2*2) div 100))
               else DatRec.Nahoda[3]:=0;

            6: If DatRec.Nahoda[6]>=(((RovnaMira3*2) div 100))
               then Dec(DatRec.Nahoda[6],((RovnaMira3*2) div 100))
               else DatRec.Nahoda[6]:=0;

               {-------------------- JOKERS --------------------------}

            1: Begin
                 If DatRec.Nahoda[1]<=65535-327
                 then Inc(DatRec.Nahoda[1],327)
                 else DatRec.Nahoda[1]:=65535;
               End;

            4: Begin
                 If DatRec.Nahoda[4]<=65535-327
                 then Inc(DatRec.Nahoda[4],327)
                 else DatRec.Nahoda[4]:=65535;
               End;

            7: Begin
                 If DatRec.Nahoda[7]<=65535-327
                 then Inc(DatRec.Nahoda[7],327)
                 else DatRec.Nahoda[7]:=65535;
               End;

               {------------------- RISKOVANI ------------------------}

            9: If DatRec.Nahoda[9]>=655
               then Dec(DatRec.Nahoda[9],655)
               else DatRec.Nahoda[9]:=0;

               {------------------- RYCHLOST -------------------------}

           11: If DatRec.fpsProdleva>1 then Dec(DatRec.fpsProdleva);

          End; {Case End}
        End;

{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do WaitButton(80);
          Case VyhernostKurzorC of

            1: Begin
                 If DatRec.Nahoda[2]>=0+655
                 then Dec(DatRec.Nahoda[2],655)
                 else DatRec.Nahoda[2]:=0;
               End;

            4: Begin
                 If DatRec.Nahoda[5]>=0+655
                 then Dec(DatRec.Nahoda[5],655)
                 else DatRec.Nahoda[5]:=0;
              End;

            7: Begin
                 If DatRec.Nahoda[8]>=0+655
                 then Dec(DatRec.Nahoda[8],655)
                 else DatRec.Nahoda[8]:=0;
               End;
          End; {Case End}
        End;

{Up}    If Key[72]=True then
        Begin
          While Key[72]=True do WaitButton(72);
          Case VyhernostKurzorC of

            1: Begin
                 If DatRec.Nahoda[2]<=65535-655
                 then Inc(DatRec.Nahoda[2],655)
                 else DatRec.Nahoda[2]:=65535;
               End;

            4: Begin
                 If DatRec.Nahoda[5]<=65535-655
                 then Inc(DatRec.Nahoda[5],655)
                 else DatRec.Nahoda[5]:=65535;
               End;

            7: Begin
                 If DatRec.Nahoda[8]<=65535-655
                 then Inc(DatRec.Nahoda[8],655)
                 else DatRec.Nahoda[8]:=65535;
               End;
          End; {Case End}
        End;

{R}     If Key[19]=True then
        Begin
          While Key[19]=True do Begin End;
          DatRec2.Pub.Vklady:=0;
          DatRec2.Pub.Vyplaceno:=0;
        End;

{X}     If Key[45]=True then
        Begin
          While Key[45]=True do Begin End;
          DatRec.fpsProdleva:=15;
          DatRec.RollSpeed:=0;
          DatRec.SpinCounter:=60;
          DatRec.SpinHelper:=1;
        End;

{E}     If Key[18]=True then
        Begin
          While Key[18]=True do Begin End;
          For I:=0 to 24 do Begin
                              DatRec2.Vklad[I]:=0;
                              DatRec2.Vyplaceno[I]:=0;
                            End;
        End;

{L}     If Key[38]=True then
        Begin
          While Key[38]=True do Begin End;
          If DatRec.RollSpeed<4 then Inc(DatRec.RollSpeed)
                                else DatRec.RollSpeed:=0;
        End;

{O}     If Key[24]=True then
        Begin
          While Key[24]=True do Begin End;
          If DatRec.SpinHelper<3 then Inc(DatRec.SpinHelper)
                                 else DatRec.SpinHelper:=0;
          Case DatRec.SpinHelper of
            0: DatRec.SpinCounter:=85;
            1: DatRec.SpinCounter:=60;
            2: DatRec.SpinCounter:=35;
            3: DatRec.SpinCounter:=10;
          End; {Case End}
        End;

{B}     If Key[48]=True then
        Begin
          While Key[48]=True do Begin End;
          If DatRec.SBEnable=True then Begin
                                         DatRec.SBEnable:=False;
                                       End
                                  else Begin
                                         DatRec.SBEnable:=True;
                                       End;
        End;

{N}     If Key[49]=True then
        Begin
          While Key[49]=True do Begin End;
          DatRec2.Hotovost:=0;
          For I:=0 to 13 do Begin
                              DatRec2.vec[I]:=True;
                              VecProdata[I]:=False;
                            End;
        End;

{M}     If Key[50]=True then
        Begin
          While Key[50]=True do Begin End;
          ResetVyhernosti;
        End;

{H}     If Key[35]=True then
        Begin
          While Key[35]=True do Begin End;
          If DatRec.NahodnyRisk=True then DatRec.NahodnyRisk:=False
                                     else DatRec.NahodnyRisk:=True;
        End;

{C}     If Key[46]=True then
        Begin
          While Key[46]=True do Begin End;
          If DatRec.ModSpinu=0 then
          Begin {CYKLUS}
            DatRec.ModSpinu:=1;
            DatRec.SpinNumber:=0;
            DatRec.SpinNumberA:=0;
            DatRec.SpinNumberB:=0;
            DatRec.SpinNumberC:=0;
            For I:=0 to 2 do DatRec.SpinPosun[I]:=0;
            For I:=0 to 2 do DatRec.SpinPosunMark[I]:=0;
            DatRec.SpinValecBuff[0]:=23;
            DatRec.SpinValecBuff[1]:=23;
            DatRec.SpinValecBuff[2]:=23;
            For I:=0 to 2 do Valec[I].SymbolCounter:=DatRec.SpinValecBuff[I];
          End else
          Begin {NAHODA}
            DatRec.ModSpinu:=0;
            DatRec.SpinNumber:=0;
            DatRec.SpinNumberA:=0;
            DatRec.SpinNumberB:=0;
            DatRec.SpinNumberC:=0;
            For I:=0 to 2 do DatRec.SpinPosun[I]:=0;
            For I:=0 to 2 do DatRec.SpinPosunMark[I]:=0;
            DatRec.SpinValecBuff[0]:=Random(25); {FIRST RANDOM}
            DatRec.SpinValecBuff[0]:=Random(25);
            DatRec.SpinValecBuff[1]:=Random(25);
            DatRec.SpinValecBuff[2]:=Random(25);
            For I:=0 to 2 do Valec[I].SymbolCounter:=DatRec.SpinValecBuff[I];
          End;
        End;

{V}     If Key[47]=True then
        Begin
          While Key[47]=True do Begin End;
          If DatRec.Svetla=True then DatRec.Svetla:=False
                                else DatRec.Svetla:=True;
        End;


{Esc} If ((Key[1]=True) or (GetButton2=1)) then
      Begin
        While Key[1]=True do Begin End;
        While GetButton2=1 do Begin End;
        Ending:=True;
      End;

  Until Ending=True;
  SaveLoadForbes(True); {SAVE}
  SaveLoadPenize(True); {SAVE}
End;