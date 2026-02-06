Procedure WriteAutomatScreen4;
Var I,N,X,Y: Word;
    Color,Color2: Byte;
    rotace: Word;
Begin
  ClearPage(Buffer[3]);

  {s zec¡ pole}
  For I:=1 to 12 do
  Ramecek(I*22,0,I*22+21,21,160+14,Buffer[3]);
  For I:=0 to 1 do
  Ramecek(0,22+I*33,21,22+I*33+32,160+14,Buffer[3]);
  For Y:=1 to  3 do
  For X:=1 to 13 do Ramecek(X*22,Y*22,X*22+21,Y*22+21,160+14,Buffer[3]);
  For I:=0 to 2 do
  Ramecek(22+I*88,88,22+I*88+87,109,160+14,Buffer[3]);
  For I:=0 to 5 do
  Ramecek(22+I*44,110,22+I*44+43,131,160+14,Buffer[3]);

  For I:=0 to 11 do
  If SazPole[I].Vsazeno=True then Blok(23+I*22,1,42+I*22,20,160+2,Buffer[3])
                             else Blok(23+I*22,1,42+I*22,20,160+1,Buffer[3]);
  For I:=12 to 24 do
  Begin
    Case I of
    12: SazPole[I].Color:=3;
    13: SazPole[I].Color:=5;
    14: SazPole[I].Color:=3;
    15: SazPole[I].Color:=3;
    16: SazPole[I].Color:=5;
    17: SazPole[I].Color:=3;
    18: SazPole[I].Color:=3;
    19: SazPole[I].Color:=5;
    20: SazPole[I].Color:=3;
    21: SazPole[I].Color:=3;
    22: SazPole[I].Color:=5;
    23: SazPole[I].Color:=3;
    24: SazPole[I].Color:=1;
    End; {Case End}
    If SazPole[I].Vsazeno=True then Blok(23+(I-12)*22,23,42+(I-12)*22,42,160+SazPole[I].Color+1,Buffer[3])
                               else Blok(23+(I-12)*22,23,42+(I-12)*22,42,160+SazPole[I].Color,Buffer[3]);
  End;

  For I:=25 to 37 do
  Begin
    Case I of
    25: SazPole[I].Color:=5;
    26: SazPole[I].Color:=3;
    27: SazPole[I].Color:=5;
    28: SazPole[I].Color:=5;
    29: SazPole[I].Color:=3;
    30: SazPole[I].Color:=5;
    31: SazPole[I].Color:=5;
    32: SazPole[I].Color:=3;
    33: SazPole[I].Color:=5;
    34: SazPole[I].Color:=5;
    35: SazPole[I].Color:=3;
    36: SazPole[I].Color:=5;
    37: SazPole[I].Color:=1;
    End; {Case End}
    If SazPole[I].Vsazeno=True then Blok(23+(I-25)*22,45,42+(I-25)*22,64,160+SazPole[I].Color+1,Buffer[3])
                               else Blok(23+(I-25)*22,45,42+(I-25)*22,64,160+SazPole[I].Color,Buffer[3]);
  End;

  For I:=38 to 50 do
  Begin
    Case I of
    38: SazPole[I].Color:=3;
    39: SazPole[I].Color:=5;
    40: SazPole[I].Color:=3;
    41: SazPole[I].Color:=5;
    42: SazPole[I].Color:=5;
    43: SazPole[I].Color:=3;
    44: SazPole[I].Color:=3;
    45: SazPole[I].Color:=5;
    46: SazPole[I].Color:=3;
    47: SazPole[I].Color:=5;
    48: SazPole[I].Color:=5;
    49: SazPole[I].Color:=3;
    50: SazPole[I].Color:=1;
    End; {Case End}
    If SazPole[I].Vsazeno=True then Blok(23+(I-38)*22,67,42+(I-38)*22,86,160+SazPole[I].Color+1,Buffer[3])
                               else Blok(23+(I-38)*22,67,42+(I-38)*22,86,160+SazPole[I].Color,Buffer[3]);
  End;

    If SazPole[51].Vsazeno=True then Blok(23,89,108,108,160+2,Buffer[3])
                                else Blok(23,89,108,108,160+1,Buffer[3]);
    If SazPole[52].Vsazeno=True then Blok(111,89,196,108,160+2,Buffer[3])
                                else Blok(111,89,196,108,160+1,Buffer[3]);
    If SazPole[53].Vsazeno=True then Blok(199,89,284,108,160+2,Buffer[3])
                                else Blok(199,89,284,108,160+1,Buffer[3]);


  For I:=0 to 1 do
  If SazPole[54+I].Vsazeno=True then Blok(23+I*44,111,64+I*44,130,160+2,Buffer[3])
                                else Blok(23+I*44,111,64+I*44,130,160+1,Buffer[3]);
  For I:=4 to 5 do
  If SazPole[54+I].Vsazeno=True then Blok(23+I*44,111,64+I*44,130,160+2,Buffer[3])
                                else Blok(23+I*44,111,64+I*44,130,160+1,Buffer[3]);

  If SazPole[56].Vsazeno=True then Blok(23+2*44,111,64+2*44,130,160+4,Buffer[3])
                              else Blok(23+2*44,111,64+2*44,130,160+3,Buffer[3]);

  If SazPole[57].Vsazeno=True then Blok(23+3*44,111,64+3*44,130,160+6,Buffer[3])
                              else Blok(23+3*44,111,64+3*44,130,160+5,Buffer[3]);

  If SazPole[60].Vsazeno=True then Blok(1,23,20,53,160+2,Buffer[3])
                              else Blok(1,23,20,53,160+1,Buffer[3]);
  If SazPole[61].Vsazeno=True then Blok(1,56,20,86,160+2,Buffer[3])
                              else Blok(1,56,20,86,160+1,Buffer[3]);

  {§eton}
  WriteSprite(Xzetonu-10,Yzetonu-10,0,128,19,147,Buffer[1],Buffer[3]);

  {popis s zec¡ho pole}
  For I:=0 to 11 do WriteSprite(23+7+I*22,7,80,0,86,6,Buffer[1],Buffer[3]);
  For I:=0 to 2 do WriteSprite(286+7,23+7+I*22,87,0,93,6,Buffer[1],Buffer[3]);
  For I:=4 to 12 do OutNumber(23+4+(I-1)*22,23+7,I*3,False,Buffer[3]);
  For I:=4 to 12 do OutNumber(23+4+(I-1)*22,45+7,I*3-1,False,Buffer[3]);
  For I:=4 to 12 do OutNumber(23+4+(I-1)*22,67+7,I*3-2,False,Buffer[3]);
  For I:=0 to 2 do OutNumber(23+8+I*22,23+7,(I+1)*3,False,Buffer[3]);
  For I:=0 to 2 do OutNumber(23+8+I*22,45+7,(I+1)*3-1,False,Buffer[3]);
  For I:=0 to 2 do OutNumber(23+8+I*22,67+7,(I+1)*3-2,False,Buffer[3]);
  OutText(6,35,'00',Buffer[3]);
  OutNumber(8,67,0,False,Buffer[3]);
  OutText(50,95,'1. 12',Buffer[3]);
  OutText(140,95,'2. 12',Buffer[3]);
  OutText(230,95,'3. 12',Buffer[3]);
  OutText(33,116,'1-18',Buffer[3]);
  OutText(74,116,'sud ',Buffer[3]);
  OutText(208,116,'lich ',Buffer[3]);
  OutText(250,116,'19-36',Buffer[3]);

  {tlacitka}
  If Button4[0].Phase=0 then WriteBlok(0,184,0,0,39,15,Buffer[1],Buffer[3])
                        else WriteBlok(0,184,40,0,79,15,Buffer[1],Buffer[3]);

  If Button4[7].Phase=0 then WriteBlok(0,133,0,112,39,127,Buffer[1],Buffer[3])
                        else WriteBlok(0,133,40,112,79,127,Buffer[1],Buffer[3]);

  If Button4[2].Phase=0 then WriteBlok(0,150,0,32,39,47,Buffer[1],Buffer[3])
                        else WriteBlok(0,150,40,32,79,47,Buffer[1],Buffer[3]);

  If Button4[1].Phase=0 then WriteBlok(0,167,0,16,39,31,Buffer[1],Buffer[3])
                        else WriteBlok(0,167,40,16,79,31,Buffer[1],Buffer[3]);

  If Button4[3].Phase=0 then WriteBlok(41,167,0,48,39,63,Buffer[1],Buffer[3])
                        else WriteBlok(41,167,40,48,79,63,Buffer[1],Buffer[3]);

  If Button4[5].Phase=0 then WriteBlok(41,133,0,80,39,95,Buffer[1],Buffer[3])
                        else WriteBlok(41,133,40,80,79,95,Buffer[1],Buffer[3]);

  If Button4[6].Phase=0 then WriteBlok(41,150,0,96,39,111,Buffer[1],Buffer[3])
                        else WriteBlok(41,150,40,96,79,111,Buffer[1],Buffer[3]);

  If Button4[4].Phase=0 then WriteBlok(41,184,0,64,39,79,Buffer[1],Buffer[3])
                        else WriteBlok(41,184,40,64,79,79,Buffer[1],Buffer[3]);

  {cisla}
  Ramecek(82,133,250,199,160+14,Buffer[3]);
  OutText(94,143,'Kurz',Buffer[3]);
  OutText(94,153,'S zka',Buffer[3]);    OutNumber(150,154,sazka4,False,Buffer[3]);
  OutText(94,163,'Credit',Buffer[3]);   OutNumber(150,164,credit4,False,Buffer[3]);
  OutText(94,173,'Score',Buffer[3]);    OutNumber(150,174,score4,False,Buffer[3]);
  OutText(94,183,'Hotovost',Buffer[3]); OutNumber(150,184,Hotovost4,False,Buffer[3]);
  If ((Hotovost4>=0) and (Hotovost4<10)) then OutText(158,183,'KŸ',Buffer[3]);
  If ((Hotovost4>=10) and (Hotovost4<100)) then OutText(164,183,'KŸ',Buffer[3]);
  If ((Hotovost4>=100) and (Hotovost4<1000)) then OutText(170,183,'KŸ',Buffer[3]);
  If ((Hotovost4>=1000) and (Hotovost4<10000)) then OutText(176,183,'KŸ',Buffer[3]);
  If ((Hotovost4>=10000) and (Hotovost4<100000)) then OutText(182,183,'KŸ',Buffer[3]);
  If ((Hotovost4>=100000) and (Hotovost4<1000000)) then OutText(188,183,'KŸ',Buffer[3]);
  If ((Hotovost4>=1000000) and (Hotovost4<9999999)) then OutText(194,183,'KŸ',Buffer[3]);
  Case kurz of
    2: OutText(150,144,'2x',Buffer[3]);
    3: OutText(150,144,'3x',Buffer[3]);
    6: OutText(150,144,'6x',Buffer[3]);
    9: OutText(150,144,'9x',Buffer[3]);
   12: OutText(150,144,'12x',Buffer[3]);
   18: OutText(150,144,'18x',Buffer[3]);
   36: OutText(150,144,'36x',Buffer[3]);
  End; {Case End}

  {ruleta}
  WriteBlok(252,133,252,133,319,199,Buffer[1],Buffer[3]);

  Blok(276,159,290,169,160+0,Buffer[3]);
  Ramecek(276,159,290,169,160+14,Buffer[3]);

  {cislo}
  Case CisloRulety of
       0: Begin N:=0;  Color2:=1; End;
       1: Begin N:=28; Color2:=5; End;
       2: Begin N:=9;  Color2:=3; End;
       3: Begin N:=26; Color2:=5; End;
       4: Begin N:=30; Color2:=3; End;
       5: Begin N:=11; Color2:=5; End;
       6: Begin N:=7;  Color2:=3; End;
       7: Begin N:=20; Color2:=5; End;
       8: Begin N:=32; Color2:=3; End;
       9: Begin N:=17; Color2:=5; End;
      10: Begin N:=5;  Color2:=3; End;
      11: Begin N:=22; Color2:=5; End;
      12: Begin N:=34; Color2:=3; End;
      13: Begin N:=15; Color2:=5; End;
      14: Begin N:=3;  Color2:=3; End;
      15: Begin N:=24; Color2:=5; End;
      16: Begin N:=36; Color2:=3; End;
      17: Begin N:=13; Color2:=5; End;
      18: Begin N:=1;  Color2:=3; End;
      19: Begin N:=99; Color2:=1; End;
      20: Begin N:=27; Color2:=3; End;
      21: Begin N:=10; Color2:=5; End;
      22: Begin N:=25; Color2:=3; End;
      23: Begin N:=29; Color2:=5; End;
      24: Begin N:=12; Color2:=3; End;
      25: Begin N:=8;  Color2:=5; End;
      26: Begin N:=19; Color2:=3; End;
      27: Begin N:=31; Color2:=5; End;
      28: Begin N:=18; Color2:=3; End;
      29: Begin N:=6;  Color2:=5; End;
      30: Begin N:=21; Color2:=3; End;
      31: Begin N:=33; Color2:=5; End;
      32: Begin N:=16; Color2:=3; End;
      33: Begin N:=4;  Color2:=5; End;
      34: Begin N:=23; Color2:=3; End;
      35: Begin N:=35; Color2:=5; End;
      36: Begin N:=14; Color2:=3; End;
      37: Begin N:=2;  Color2:=5; End;
  End; {Case End}

  Blok(276,159,290,169,160+Color2,Buffer[3]);
  Ramecek(276,159,290,169,160+14,Buffer[3]);

  If N=99 then OutText(278,160,'00',Buffer[3])
          else OutNumber(278,161,N,False,Buffer[3]);

  {fund diag}
  If FundDiag4=True then
  Begin
    Repeat

{Esc}
      If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        FundDiag4:=False;
      End;

{Up}
      If Key[72]=True then
      Begin
        While Key[72]=True do Begin End;
        If FundSelect4>0 then Dec(FundSelect4)
      End;

{Down}
      If Key[80]=True then
      Begin
        While Key[80]=True do Begin End;
        If FundSelect4<9 then Inc(FundSelect4)
      End;

{Left}
      If Key[75]=True then
      Begin
        While Key[75]=True do Begin End;
        If FundSelect4>4 then Dec(FundSelect4,5);
      End;

{Right}
      If Key[77]=True then
      Begin
        While Key[77]=True do Begin End;
        If FundSelect4<5 then Inc(FundSelect4,5);
      End;

{Enter}
      If Key[28]=True then
      Begin
        While Key[28]=True do Begin End;
        Case FundSelect4 of
          0: Begin
               If Hotovost4>=5 then Begin
                                     Dec(Hotovost4,5);
                                     Inc(Credit4,5);
                                     FundDiag4:=False;
                                     StopPlay;
                                     PlaySound(2);
                                   End
                              else Begin
                                     StopPlay;
                                     PlaySound(3);
                                   End;
             End;
          1: Begin
               If Hotovost4>=10 then Begin
                                      Dec(Hotovost4,10);
                                      Inc(Credit4,10);
                                      FundDiag4:=False;
                                      StopPlay;
                                      PlaySound(2);
                                     End
                                else Begin
                                       StopPlay;
                                       PlaySound(3);
                                     End;
             End;
          2: Begin
               If Hotovost4>=20 then Begin
                                      Dec(Hotovost4,20);
                                      Inc(Credit4,20);
                                      FundDiag4:=False;
                                      StopPlay;
                                      PlaySound(2);
                                     End
                                else Begin
                                       StopPlay;
                                       PlaySound(3);
                                     End;
             End;
          3: Begin
               If Hotovost4>=50 then Begin
                                      Dec(Hotovost4,50);
                                      Inc(Credit4,50);
                                      FundDiag4:=False;
                                      StopPlay;
                                      PlaySound(2);
                                     End
                                else Begin
                                       StopPlay;
                                       PlaySound(3);
                                     End;
             End;
          4: Begin
               If Hotovost4>=100 then Begin
                                       Dec(Hotovost4,100);
                                       Inc(Credit4,100);
                                       FundDiag4:=False;
                                       StopPlay;
                                       PlaySound(2);
                                      End
                                 else Begin
                                        StopPlay;
                                        PlaySound(3);
                                      End;
             End;
          5: Begin
               If Hotovost4>=200 then Begin
                                       Dec(Hotovost4,200);
                                       Inc(Credit4,200);
                                       FundDiag4:=False;
                                       StopPlay;
                                       PlaySound(2);
                                      End
                                 else Begin
                                        StopPlay;
                                        PlaySound(3);
                                      End;
             End;
          6: Begin
               If Hotovost4>=500 then Begin
                                       Dec(Hotovost4,500);
                                       Inc(Credit4,500);
                                       FundDiag4:=False;
                                       StopPlay;
                                       PlaySound(2);
                                      End
                                 else Begin
                                        StopPlay;
                                        PlaySound(3);
                                      End;
             End;
          7: Begin
               If Hotovost4>=1000 then Begin
                                        Dec(Hotovost4,1000);
                                        Inc(Credit4,1000);
                                        FundDiag4:=False;
                                        StopPlay;
                                        PlaySound(2);
                                       End
                                  else Begin
                                         StopPlay;
                                         PlaySound(3);
                                       End;
             End;
          8: Begin
               If Hotovost4>=2000 then Begin
                                        Dec(Hotovost4,2000);
                                        Inc(Credit4,2000);
                                        FundDiag4:=False;
                                        StopPlay;
                                        PlaySound(2);
                                       End
                                  else Begin
                                         StopPlay;
                                         PlaySound(3);
                                       End;
             End;
          9: Begin
               If Hotovost4>=5000 then Begin
                                        Dec(Hotovost4,5000);
                                        Inc(Credit4,5000);
                                        FundDiag4:=False;
                                        StopPlay;
                                        PlaySound(2);
                                       End
                                  else Begin
                                         StopPlay;
                                         PlaySound(3);
                                       End;
             End;
        End; {Case End}
      End;

      Blok(0,132,80,199,160+0,Buffer[3]);
      Ramecek(0,132,80,199,160+14,Buffer[3]);

      X:=5; Y:=134;
      For I:=0 to 4 do
      Begin Blok(X+1,Y+1,X+29,Y+10,160+8,Buffer[3]); Inc(Y,13); End;

      X:=42; Y:=134;
      For I:=0 to 4 do
      Begin Blok(X+1,Y+1,X+29,Y+10,160+8,Buffer[3]); Inc(Y,13); End;

      X:=5; Y:=134;
      Case FundSelect4 of
        0: Blok(X,Y,X+29,Y+10,160+3,Buffer[3]);
        1: Blok(X,Y+13,X+29,Y+23,160+3,Buffer[3]);
        2: Blok(X,Y+26,X+29,Y+36,160+3,Buffer[3]);
        3: Blok(X,Y+39,X+29,Y+49,160+3,Buffer[3]);
        4: Blok(X,Y+52,X+29,Y+62,160+3,Buffer[3]);
      End; {Case End}

      X:=42; Y:=134;
      Case FundSelect4 of
        5: Blok(X,Y,X+29,Y+10,160+3,Buffer[3]);
        6: Blok(X,Y+13,X+29,Y+23,160+3,Buffer[3]);
        7: Blok(X,Y+26,X+29,Y+36,160+3,Buffer[3]);
        8: Blok(X,Y+39,X+29,Y+49,160+3,Buffer[3]);
        9: Blok(X,Y+52,X+29,Y+62,160+3,Buffer[3]);
      End; {Case End}

      X:=5; Y:=134;
      For I:=0 to 4 do
      Begin
        Ramecek(X,Y,X+30,Y+11,160+14,Buffer[3]);
        Case I of
          0: OutNumber(X+13,Y+2,5,False,Buffer[3]);
          1: OutNumber(X+10,Y+2,10,False,Buffer[3]);
          2: OutNumber(X+10,Y+2,20,False,Buffer[3]);
          3: OutNumber(X+10,Y+2,50,False,Buffer[3]);
          4: OutNumber(X+7,Y+2,100,False,Buffer[3]);
        End; {Case End}
        Inc(Y,13);
      End;

      X:=42; Y:=134;
      For I:=0 to 4 do
      Begin
        Ramecek(X,Y,X+30,Y+11,160+14,Buffer[3]);
        Case I of
          0: OutNumber(X+7,Y+2,200,False,Buffer[3]);
          1: OutNumber(X+7,Y+2,500,False,Buffer[3]);
          2: OutNumber(X+4,Y+2,1000,False,Buffer[3]);
          3: OutNumber(X+4,Y+2,2000,False,Buffer[3]);
          4: OutNumber(X+4,Y+2,5000,False,Buffer[3]);
        End; {Case End}
        Inc(Y,13);
      End;

      WaitRetrace;
      FlipPage(Buffer[3],Buffer[4]);

    Until FundDiag4=False;

  End; {End FundDiag}

  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;
