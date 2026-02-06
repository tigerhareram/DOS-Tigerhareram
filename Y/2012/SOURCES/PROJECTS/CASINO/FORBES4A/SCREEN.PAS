Procedure MainGameScreen;
Var I: Byte;
    N: Byte;
Begin
  Blok(0,0,319,199,ColorUnknown,Buffer[3]);

  {Button COLLECT}
  Blok(0,185,44,199,BtnCol.Color,Buffer[3]);
  Ramecek(0,185,44,199,ColorRedDark,Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,38,187,'c',Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,2,193,'collect',Buffer[3]);

  {Button AUTO}
  Blok(46,185,72,199,Btn[3].Color,Buffer[3]);
  Ramecek(46,185,72,199,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,66,187,'a',Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,48,193,'auto',Buffer[3]);

  {Button WIN GAMBLE}
  Blok(74,185,106,199,Btn[1].Color,Buffer[3]);
  Ramecek(74,185,106,199,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,100,187,'w',Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,76,193,'win/-',Buffer[3]);

  {Button VSADIT}
  Blok(108,185,146,199,Btn[2].Color,Buffer[3]);
  Ramecek(108,185,146,199,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,140,187,'v',Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,110,193,'vsadit',Buffer[3]);

  {Button MULTIWIN}
  Blok(148,185,198,199,Btn[0].Color,Buffer[3]);
  Ramecek(148,185,198,199,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,192,187,'m',Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,150,193,'multiwin',Buffer[3]);

  {Button HLAVA}
  Blok(200,185,238,199,Btn[4].Color,Buffer[3]);
  Ramecek(200,185,238,199,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,232,187,'h',Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,202,193,'hlava',Buffer[3]);

  {Button OREL}
  Blok(240,185,276,199,Btn[5].Color,Buffer[3]);
  Ramecek(240,185,276,199,ColorGreen,Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,270,187,'o',Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,242,193,'orel',Buffer[3]);

  {Button START}
  Blok(278,185,319,199,Btn[6].Color,Buffer[3]);
  Ramecek(278,185,319,199,ColorRedDark,Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,280,187,'num 0',Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,280,193,'start',Buffer[3]);

  {Button VYBRAT KASU}
  Blok(220,44,270,59,Btn[7].Color,Buffer[3]);
  Ramecek(220,44,270,59,ColorRedDark,Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,264,46,'q',Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,222,46,'vybrat',Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,222,53,'kasu',Buffer[3]);

  {Button VYBRAT MULTIWIN}
  Blok(220,62,270,76,Btn[8].Color,Buffer[3]);
  Ramecek(220,62,270,76,ColorRedDark,Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,264,64,'t',Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,222,64,'vybrat',Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,222,70,'multiwin',Buffer[3]);

  {Blikani Tlacitek}
  For I:=0 to 8 do If Btn[I].Blinking=True then ButtonBlink(I);
  For I:=9 to 11 do If ((StopButton[I-9].Mark=False) and (StopButton[I-9].Blinking=True)) then ButtonBlink(I);
  If BtnCol.Blinking=True then ButtonBlink(12);

  {HOTOVOST}
  Blok(264,31,319,39,ColorUnknown,Buffer[3]);
  OutText(216,32,'Hotovost',Buffer[3]);
  OutNumber(264,33,DatRec2.Hotovost,False,Buffer[3]);
  If ((DatRec2.Hotovost>=0) and (DatRec2.Hotovost<10)) then OutText(272,32,'KŸ',Buffer[3]);
  If ((DatRec2.Hotovost>=10) and (DatRec2.Hotovost<100)) then OutText(278,32,'KŸ',Buffer[3]);
  If ((DatRec2.Hotovost>=100) and (DatRec2.Hotovost<1000)) then OutText(284,32,'KŸ',Buffer[3]);
  If ((DatRec2.Hotovost>=1000) and (DatRec2.Hotovost<10000)) then OutText(290,32,'KŸ',Buffer[3]);
  If ((DatRec2.Hotovost>=10000) and (DatRec2.Hotovost<100000)) then OutText(296,32,'KŸ',Buffer[3]);
  If ((DatRec2.Hotovost>=100000) and (DatRec2.Hotovost<1000000)) then OutText(302,32,'KŸ',Buffer[3]);
  If ((DatRec2.Hotovost>=1000000) and (DatRec2.Hotovost<10000000)) then OutText(307,32,'KŸ',Buffer[3]);

  {MINCOVNIK}
  WriteBlok(272,44,210,40,217,71,Buffer[1],Buffer[3]);
  Ramecek(280,43,281,77,ColorBlack,Buffer[3]);
  Ramecek(279,42,281,78,ColorCtecka,Buffer[3]);

  {INSERT MONEY MOUSE 50}
  Blok(285,43,315,59,ColorBlack,Buffer[3]);
  Ramecek(285,43,315,59,ColorGreen,Buffer[3]);
  WriteNumber(Buffer[1],160,55,5,5,1,295,48,50,Buffer[3]);

  {INSERT MONEY MOUSE 500}
  Blok(285,62,315,78,ColorBlack,Buffer[3]);
  Ramecek(285,62,315,78,ColorGreen,Buffer[3]);
  WriteNumber(Buffer[1],160,55,5,5,1,292,67,500,Buffer[3]);

  If VkladShow[1]=True then WriteSprite(275,44,302,40,317,71,Buffer[1],Buffer[3]);
  If VkladShow[2]=True then WriteSprite(275,44,218,40,233,71,Buffer[1],Buffer[3]);
  If VkladShow[3]=True then WriteSprite(275,44,236,42,251,73,Buffer[1],Buffer[3]);
  If VkladShow[4]=True then WriteSprite(275,47,252,42,267,73,Buffer[1],Buffer[3]);
  If VkladShow[5]=True then WriteSprite(275,47,268,40,283,71,Buffer[1],Buffer[3]);
  If VkladShow[6]=True then WriteSprite(275,44,284,40,299,71,Buffer[1],Buffer[3]);
  If VkladShow[7]=True then WriteSprite(280,44,240,168,279,199,Buffer[1],Buffer[3]);
  If VkladShow[8]=True then WriteSprite(280,44,280,168,319,199,Buffer[1],Buffer[3]);
  If VkladShow[9]=True then WriteSprite(280,44,200,168,239,199,Buffer[1],Buffer[3]);
  If VkladShow[10]=True then WriteSprite(280,44,160,168,199,199,Buffer[1],Buffer[3]);

  {Dolni Lista Vyher}
  If Lista[0].Enable=True
  then For I:=0 to 9 do WriteSprite(I*32,168,160+I*16,88,160+I*16+15,103,Buffer[2],Buffer[3])
  else For I:=0 to 9 do WriteSprite(I*32,168,I*16,88,I*16+15,103,Buffer[2],Buffer[3]);

  If Lista[0].Sazka[0]=True then
  Begin
    WriteNumber(Buffer[1],160,55,5,5,1,16,179,8,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,48,179,16,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,80,179,24,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,112,179,32,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,144,179,40,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,176,179,80,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,208,179,120,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,238,179,160,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,270,179,200,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,302,179,400,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,16,169,16,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,48,169,24,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,80,169,32,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,112,169,40,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,144,169,80,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,176,169,120,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,208,169,160,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,238,169,200,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,270,169,240,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,302,169,400,Buffer[3]);
  End;

  If Lista[0].Sazka[1]=True then
  Begin
    WriteNumber(Buffer[1],160,75,5,5,1,16,179,8,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,48,179,16,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,80,179,24,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,112,179,32,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,144,179,40,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,176,179,80,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,208,179,120,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,238,179,160,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,270,179,200,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,302,179,400,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,16,169,16,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,48,169,24,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,80,169,32,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,112,169,40,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,144,169,80,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,176,169,120,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,208,169,160,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,238,169,200,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,270,169,240,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,302,169,400,Buffer[3]);
  End;

  If ((Lista[0].Sazka[0]=False) and (Lista[0].Sazka[1]=False)) then
  Begin
    WriteNumber(Buffer[1],160,75,5,5,1,16,179,8,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,48,179,16,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,80,179,24,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,112,179,32,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,144,179,40,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,176,179,80,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,208,179,120,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,238,179,160,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,270,179,200,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,302,179,400,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,16,169,16,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,48,169,24,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,80,169,32,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,112,169,40,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,144,169,80,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,176,169,120,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,208,169,160,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,238,169,200,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,270,169,240,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,302,169,400,Buffer[3]);
  End;

  {Horni Lista Vyher}
  If Lista[1].Enable=True
  then For I:=0 to 9 do WriteSprite(I*32,152,160+I*16,88,160+I*16+15,103,Buffer[2],Buffer[3])
  else For I:=0 to 9 do WriteSprite(I*32,152,I*16,88,I*16+15,103,Buffer[2],Buffer[3]);

  If Lista[1].Enable=True then
  Begin
    WriteNumber(Buffer[1],160,55,5,5,1,16,157,40,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,48,157,40,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,80,157,80,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,112,157,80,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,144,157,120,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,176,157,160,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,208,157,200,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,238,157,300,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,270,157,400,Buffer[3]);
    WriteNumber(Buffer[1],160,55,5,5,1,302,157,750,Buffer[3]);
  End;

  If Lista[1].Enable=False then
  Begin
    WriteNumber(Buffer[1],160,75,5,5,1,16,157,40,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,48,157,40,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,80,157,80,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,112,157,80,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,144,157,120,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,176,157,160,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,208,157,200,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,238,157,300,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,270,157,400,Buffer[3]);
    WriteNumber(Buffer[1],160,75,5,5,1,302,157,750,Buffer[3]);
  End;

  {DISPLAY WIN + CREDIT}
  Blok(109,139,210,149,ColorBlack,Buffer[3]);
  Ramecek(108,138,211,150,ColorRedDark,Buffer[3]);
  Blok(118,136,138,140,ColorBlack,Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,120,136,'win',Buffer[3]);
  Blok(168,136,206,140,ColorBlack,Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,170,136,'credit',Buffer[3]);

  If VyhraShow=True then
  Begin
    If Vyhra.Castka<10 then WriteNumber(Buffer[1],160,96,5,7,1,130,142,Vyhra.Castka,Buffer[3]);
    If Vyhra.Castka>=100 then WriteNumber(Buffer[1],160,96,5,7,1,120,142,Vyhra.Castka,Buffer[3]);
    If ((Vyhra.Castka>=10) and (Vyhra.Castka<100)) then WriteNumber(Buffer[1],160,96,5,7,1,125,142,Vyhra.Castka,Buffer[3]);
  End;

  If CreditShow=True then
  Begin
    If Credit<10 then WriteNumber(Buffer[1],160,96,5,7,1,200,142,Credit,Buffer[3]);
    If ((Credit>=10) and (Credit<100)) then WriteNumber(Buffer[1],160,96,5,7,1,194,142,Credit,Buffer[3]);
    If ((Credit>=100) and (Credit<1000)) then WriteNumber(Buffer[1],160,96,5,7,1,188,142,Credit,Buffer[3]);
    If ((Credit>=1000) and (Credit<10000)) then WriteNumber(Buffer[1],160,96,5,7,1,182,142,Credit,Buffer[3]);
    If ((Credit>=10000) and (Credit<100000)) then WriteNumber(Buffer[1],160,96,5,7,1,176,142,Credit,Buffer[3]);
    If ((Credit>=100000) and (Credit<1000000)) then WriteNumber(Buffer[1],160,96,5,7,1,170,142,Credit,Buffer[3]);
    If ((Credit>=1000000) and (Credit<9999999)) then WriteNumber(Buffer[1],160,96,5,7,1,164,142,Credit,Buffer[3]);
  End;

  {DISPLAY MULTIWIN}
  Ramecek(111,2,206,43,ColorRedDark,Buffer[3]);
  Blok(134,0,184,5,ColorBlack,Buffer[3]);
  Blok(112,3,205,42,ColorBlack,Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,136,0,'multiwin',Buffer[3]);
  If MultiWin<10 then WriteNumber(Buffer[1],160,103,16,32,2,187,7,MultiWin,Buffer[3]);
  If ((MultiWin>=10) and (MultiWin<100)) then WriteNumber(Buffer[1],160,103,16,32,2,169,7,MultiWin,Buffer[3]);
  If ((MultiWin>=100) and (MultiWin<1000)) then WriteNumber(Buffer[1],160,103,16,32,2,151,7,MultiWin,Buffer[3]);
  If ((MultiWin>=1000) and (MultiWin<10000)) then WriteNumber(Buffer[1],160,103,16,32,2,133,7,MultiWin,Buffer[3]);
  If ((MultiWin>=10000) and (MultiWin<100000)) then WriteNumber(Buffer[1],160,103,16,32,2,115,7,MultiWin,Buffer[3]);
  If ((MultiWin>=100000) and (MultiWin<1000000)) then WriteNumber(Buffer[1],160,103,16,32,2,115,7,99999,Buffer[3]);

  {DISPLAY BONUS}
  Ramecek(239,5,288,29,ColorRedDark,Buffer[3]);
  Blok(248,3,280,5,ColorBlack,Buffer[3]);
  Blok(240,6,287,28,ColorBlack,Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,250,3,'bonus',Buffer[3]);
  If Bonus<10 then WriteNumber(Buffer[1],160,80,8,16,1,278,10,Bonus,Buffer[3]);
  If ((Bonus>=10) and (Bonus<100)) then WriteNumber(Buffer[1],160,80,8,16,1,269,10,Bonus,Buffer[3]);
  If ((Bonus>=100) and (Bonus<1000)) then WriteNumber(Buffer[1],160,80,8,16,1,260,10,Bonus,Buffer[3]);
  If ((Bonus>=1000) and (Bonus<10000)) then WriteNumber(Buffer[1],160,80,8,16,1,251,10,Bonus,Buffer[3]);
  If ((Bonus>=10000) and (Bonus<99999)) then WriteNumber(Buffer[1],160,80,8,16,1,242,10,Bonus,Buffer[3]);

  {DISPLAY BET + BETMULTI}
  Ramecek(35,5,77,29,ColorRedDark,Buffer[3]);
  Blok(46,3,65,5,ColorBlack,Buffer[3]);
  Blok(36,6,76,28,ColorBlack,Buffer[3]);
  WriteText(Buffer[1],160,60,5,5,1,48,3,'bet',Buffer[3]);
  WriteNumber(Buffer[1],160,80,8,16,1,38,10,Bet,Buffer[3]);
  WriteSprite(48,14,20,192,27,199,Buffer[1],Buffer[3]);
  If BetMulti>=10 then WriteNumber(Buffer[1],160,80,8,16,1,58,10,BetMulti,Buffer[3]);
  If ((BetMulti>0) and (BetMulti<10)) then WriteNumber(Buffer[1],160,80,8,16,1,67,10,BetMulti,Buffer[3]);

  {SYMBOLY}
  KresliValce(SymbolLight,Light1,Light1,Light1,Buffer[3]);

  {STOP BUTTON0}
  Ramecek(111,123,135,133,ColorGreen,Buffer[3]);
  Blok(112,124,134,132,StopButton[0].Color,Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,121,126,'j',Buffer[3]);

  {STOP BUTTON1}
  Ramecek(146,123,170,133,ColorGreen,Buffer[3]);
  Blok(147,124,169,132,StopButton[1].Color,Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,156,126,'k',Buffer[3]);

  {STOP BUTTON2}
  Ramecek(182,123,205,133,ColorGreen,Buffer[3]);
  Blok(183,124,204,132,StopButton[2].Color,Buffer[3]);
  WriteText(Buffer[1],160,20,5,5,1,192,126,'l',Buffer[3]);

  {CENA HRY}
  For I:=0 to 11 do
  Begin
    If ((WaitAction.Active=True) and (WaitAction.Cena[I]=1))
    then Blok(1,32+I*8,23,32+I*8+8,ColorWhite,Buffer[3])
    else Blok(1,32+I*8,23,32+I*8+8,ColorRedDark,Buffer[3]);
  End;

  Case Nasobic of {Vybrana cena hry}
   10: Blok(1,32,23,40,ColorRed,Buffer[3]);
    9: Blok(1,40,23,48,ColorRed,Buffer[3]);
    8: Blok(1,48,23,56,ColorRed,Buffer[3]);
    7: Blok(1,56,23,64,ColorRed,Buffer[3]);
    6: Blok(1,64,23,72,ColorRed,Buffer[3]);
    5: Blok(1,72,23,80,ColorRed,Buffer[3]);
    4: Blok(1,80,23,88,ColorRed,Buffer[3]);
    3: Blok(1,88,23,96,ColorRed,Buffer[3]);
    2: Blok(1,96,23,104,ColorRed,Buffer[3]);
    1: Blok(1,104,23,112,ColorRed,Buffer[3]);
    0: If Bet=4 then Blok(1,112,23,120,ColorRed,Buffer[3])
                else Blok(1,120,23,128,ColorRed,Buffer[3]);
  End; {Case End}

  For N:=0 to 11 do {cifry ceny her}
  Begin
    Ramecek(1,32+N*8,23,32+N*8+8,ColorGreen,Buffer[3]);
    Case N of
      0: WriteNumber(Buffer[1],160,35,5,5,1,4,34,100,Buffer[3]);
      1: WriteNumber(Buffer[1],160,35,5,5,1,7,42,90,Buffer[3]);
      2: WriteNumber(Buffer[1],160,35,5,5,1,7,50,80,Buffer[3]);
      3: WriteNumber(Buffer[1],160,35,5,5,1,7,58,70,Buffer[3]);
      4: WriteNumber(Buffer[1],160,35,5,5,1,7,66,60,Buffer[3]);
      5: WriteNumber(Buffer[1],160,35,5,5,1,7,74,50,Buffer[3]);
      6: WriteNumber(Buffer[1],160,35,5,5,1,7,82,40,Buffer[3]);
      7: WriteNumber(Buffer[1],160,35,5,5,1,7,90,30,Buffer[3]);
      8: WriteNumber(Buffer[1],160,35,5,5,1,7,98,20,Buffer[3]);
      9: WriteNumber(Buffer[1],160,35,5,5,1,7,106,10,Buffer[3]);
     10: WriteNumber(Buffer[1],160,35,5,5,1,10,114,4,Buffer[3]);
     11: WriteNumber(Buffer[1],160,35,5,5,1,10,122,2,Buffer[3]);
    End; {Case End}
  End;

  {JACKPOT}
  OutText(26,31,'Jackpot',Buffer[3]);
  OutNumber(72,32,DatRec2.Jackpot,False,Buffer[3]);

  Ramecek(28,42,95,109,ColorRedDark,Buffer[3]);
  Ramecek(29,43,94,108,ColorBlack,Buffer[3]);
  Case ObrazekCounter of
   0: WriteBlok(30,44,0,24,63,87,Buffer[2],Buffer[3]);
   1: WriteBlok(30,44,64,24,127,87,Buffer[2],Buffer[3]);
   2: WriteBlok(30,44,64,24,127,87,Buffer[2],Buffer[3]);
   3: WriteBlok(30,44,128,24,191,87,Buffer[2],Buffer[3]);
   4: WriteBlok(30,44,128,24,191,87,Buffer[2],Buffer[3]);
   5: WriteBlok(30,44,192,24,255,87,Buffer[2],Buffer[3]);
   6: WriteBlok(30,44,192,24,255,87,Buffer[2],Buffer[3]);
   7: WriteBlok(30,44,256,24,319,87,Buffer[2],Buffer[3]);
   8: WriteBlok(30,44,256,24,319,87,Buffer[2],Buffer[3]);
   9: WriteBlok(30,44,0,24,63,87,Buffer[2],Buffer[3]);
  End; {Case End}

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
                                                    Btn[4].Phase:=0;
                                                    SetButtonColor(4);
                                                    Btn[5].Phase:=4;
                                                    SetButtonColor(5);
                                                    ButtonBlink(0);
                                                  End
                                             else Begin
                                                    Risk.Phase:=0;
                                                    Hlava.Enable:=True;
                                                    Orel.Enable:=False;
                                                    Btn[4].Phase:=4;
                                                    SetButtonColor(4);
                                                    Btn[5].Phase:=0;
                                                    SetButtonColor(5);
                                                    ButtonBlink(0);
                                                  End;
                           End;
  End;

  {HLAVA OREL}
  If Risk.Enable=False then
  Begin
    WriteSprite(252,82,100,98,131,115,Buffer[1],Buffer[3]); {RISK TMAVY}
    WriteSprite(220,104,0,100,95,139,Buffer[1],Buffer[3]);  {HLAVA OREL}
  End else
  Begin
    WriteSprite(252,82,100,116,131,131,Buffer[1],Buffer[3]); {RISK SVETLY}
    If Hlava.Enable=True then WriteSprite(220,104,0,140,47,179,Buffer[1],Buffer[3])
                         else WriteSprite(220,104,0,100,47,139,Buffer[1],Buffer[3]);
    If Orel.Enable=True then WriteSprite(268,104,48,140,95,179,Buffer[1],Buffer[3])
                        else WriteSprite(268,104,48,100,95,139,Buffer[1],Buffer[3]);
  End;

  {WIN GAMBLE}
  If WinGamble.Enable=False then
  Begin
    WriteSprite(28,114,100,150,132,165,Buffer[1],Buffer[3]); {WIN}
    WriteSprite(74,114,137,150,148,165,Buffer[1],Buffer[3]); { - }
    WriteBlok(30,132,250,20,282,38,Buffer[1],Buffer[3]); {GREEN TMAVA}
    WriteBlok(64,132,210,20,242,38,Buffer[1],Buffer[3]); {RED TMAVA}
  End;

  If WinGamble.Enable=True then
  Begin
    If WinGamble.Blinking=False then
    Begin
      WriteSprite(28,114,100,166,132,181,Buffer[1],Buffer[3]); {WIN}
      WriteSprite(74,114,137,166,148,181,Buffer[1],Buffer[3]); { - }
      WriteBlok(30,132,250,0,282,18,Buffer[1],Buffer[3]); {GREEN SVETLA}
      WriteBlok(64,132,210,0,242,18,Buffer[1],Buffer[3]); {RED SVETLA}
    End else
    Begin
      If WinGambleGreen.Enable=True
      then Begin
             WriteSprite(28,114,100,166,132,181,Buffer[1],Buffer[3]);
             WriteBlok(30,132,250,0,282,18,Buffer[1],Buffer[3]);
           End
      else Begin
             WriteSprite(28,114,100,150,132,165,Buffer[1],Buffer[3]);
             WriteBlok(30,132,250,20,282,38,Buffer[1],Buffer[3]);
           End;
      If WinGambleRed.Enable=True
      then Begin
             WriteSprite(74,114,137,166,148,181,Buffer[1],Buffer[3]);
             WriteBlok(64,132,210,0,242,18,Buffer[1],Buffer[3]);
           End
      else Begin
             WriteSprite(74,114,137,150,148,165,Buffer[1],Buffer[3]);
             WriteBlok(64,132,210,20,242,38,Buffer[1],Buffer[3]);
           End;
    End;
  End;
  Blok(30,150,96,151,ColorUnknown,Buffer[3]);

  If WaitAction.Active=True then
  Begin
    For I:=0 to 9 do If WaitAction.Lista[0,I]=1
    then WriteSprite(I*32,168,160+I*16,88,160+I*16+15,103,Buffer[2],Buffer[3])
    else WriteSprite(I*32,168,I*16,88,I*16+15,103,Buffer[2],Buffer[3]);

    For I:=0 to 9 do If WaitAction.Lista[1,I]=1
    then WriteSprite(I*32,152,160+I*16,88,160+I*16+15,103,Buffer[2],Buffer[3])
    else WriteSprite(I*32,152,I*16,88,I*16+15,103,Buffer[2],Buffer[3]);

    For I:=0 to 9 do If WaitAction.Cislo[0,I]=1 then
    Begin
     Case I of
      0: WriteNumber(Buffer[1],160,55,5,5,1,16,179,8,Buffer[3]);
      1: WriteNumber(Buffer[1],160,55,5,5,1,48,179,16,Buffer[3]);
      2: WriteNumber(Buffer[1],160,55,5,5,1,80,179,24,Buffer[3]);
      3: WriteNumber(Buffer[1],160,55,5,5,1,112,179,32,Buffer[3]);
      4: WriteNumber(Buffer[1],160,55,5,5,1,144,179,40,Buffer[3]);
      5: WriteNumber(Buffer[1],160,55,5,5,1,176,179,80,Buffer[3]);
      6: WriteNumber(Buffer[1],160,55,5,5,1,208,179,120,Buffer[3]);
      7: WriteNumber(Buffer[1],160,55,5,5,1,238,179,160,Buffer[3]);
      8: WriteNumber(Buffer[1],160,55,5,5,1,270,179,200,Buffer[3]);
      9: WriteNumber(Buffer[1],160,55,5,5,1,302,179,400,Buffer[3]);
     End; {Case End}
    End else
    Begin
     Case I of
      0: WriteNumber(Buffer[1],160,75,5,5,1,16,179,8,Buffer[3]);
      1: WriteNumber(Buffer[1],160,75,5,5,1,48,179,16,Buffer[3]);
      2: WriteNumber(Buffer[1],160,75,5,5,1,80,179,24,Buffer[3]);
      3: WriteNumber(Buffer[1],160,75,5,5,1,112,179,32,Buffer[3]);
      4: WriteNumber(Buffer[1],160,75,5,5,1,144,179,40,Buffer[3]);
      5: WriteNumber(Buffer[1],160,75,5,5,1,176,179,80,Buffer[3]);
      6: WriteNumber(Buffer[1],160,75,5,5,1,208,179,120,Buffer[3]);
      7: WriteNumber(Buffer[1],160,75,5,5,1,238,179,160,Buffer[3]);
      8: WriteNumber(Buffer[1],160,75,5,5,1,270,179,200,Buffer[3]);
      9: WriteNumber(Buffer[1],160,75,5,5,1,302,179,400,Buffer[3]);
     End; {Case End}
    End;

    For I:=0 to 9 do If WaitAction.Cislo[1,I]=1 then
    Begin
      Case I of
       0: WriteNumber(Buffer[1],160,55,5,5,1,16,169,16,Buffer[3]);
       1: WriteNumber(Buffer[1],160,55,5,5,1,48,169,24,Buffer[3]);
       2: WriteNumber(Buffer[1],160,55,5,5,1,80,169,32,Buffer[3]);
       3: WriteNumber(Buffer[1],160,55,5,5,1,112,169,40,Buffer[3]);
       4: WriteNumber(Buffer[1],160,55,5,5,1,144,169,80,Buffer[3]);
       5: WriteNumber(Buffer[1],160,55,5,5,1,176,169,120,Buffer[3]);
       6: WriteNumber(Buffer[1],160,55,5,5,1,208,169,160,Buffer[3]);
       7: WriteNumber(Buffer[1],160,55,5,5,1,238,169,200,Buffer[3]);
       8: WriteNumber(Buffer[1],160,55,5,5,1,270,169,240,Buffer[3]);
       9: WriteNumber(Buffer[1],160,55,5,5,1,302,169,400,Buffer[3]);
      End; {Case End}
    End else
    Begin
      Case I of
       0: WriteNumber(Buffer[1],160,75,5,5,1,16,169,16,Buffer[3]);
       1: WriteNumber(Buffer[1],160,75,5,5,1,48,169,24,Buffer[3]);
       2: WriteNumber(Buffer[1],160,75,5,5,1,80,169,32,Buffer[3]);
       3: WriteNumber(Buffer[1],160,75,5,5,1,112,169,40,Buffer[3]);
       4: WriteNumber(Buffer[1],160,75,5,5,1,144,169,80,Buffer[3]);
       5: WriteNumber(Buffer[1],160,75,5,5,1,176,169,120,Buffer[3]);
       6: WriteNumber(Buffer[1],160,75,5,5,1,208,169,160,Buffer[3]);
       7: WriteNumber(Buffer[1],160,75,5,5,1,238,169,200,Buffer[3]);
       8: WriteNumber(Buffer[1],160,75,5,5,1,270,169,240,Buffer[3]);
       9: WriteNumber(Buffer[1],160,75,5,5,1,302,169,400,Buffer[3]);
      End; {Case End}
    End;

    For I:=0 to 9 do If WaitAction.Cislo[2,I]=1 then
    Begin
      Case I of
       0: WriteNumber(Buffer[1],160,55,5,5,1,16,157,40,Buffer[3]);
       1: WriteNumber(Buffer[1],160,55,5,5,1,48,157,40,Buffer[3]);
       2: WriteNumber(Buffer[1],160,55,5,5,1,80,157,80,Buffer[3]);
       3: WriteNumber(Buffer[1],160,55,5,5,1,112,157,80,Buffer[3]);
       4: WriteNumber(Buffer[1],160,55,5,5,1,144,157,120,Buffer[3]);
       5: WriteNumber(Buffer[1],160,55,5,5,1,176,157,160,Buffer[3]);
       6: WriteNumber(Buffer[1],160,55,5,5,1,208,157,200,Buffer[3]);
       7: WriteNumber(Buffer[1],160,55,5,5,1,238,157,300,Buffer[3]);
       8: WriteNumber(Buffer[1],160,55,5,5,1,270,157,400,Buffer[3]);
       9: WriteNumber(Buffer[1],160,55,5,5,1,302,157,750,Buffer[3]);
      End; {Case End}
    End else
    Begin
      Case I of
       0: WriteNumber(Buffer[1],160,75,5,5,1,16,157,40,Buffer[3]);
       1: WriteNumber(Buffer[1],160,75,5,5,1,48,157,40,Buffer[3]);
       2: WriteNumber(Buffer[1],160,75,5,5,1,80,157,80,Buffer[3]);
       3: WriteNumber(Buffer[1],160,75,5,5,1,112,157,80,Buffer[3]);
       4: WriteNumber(Buffer[1],160,75,5,5,1,144,157,120,Buffer[3]);
       5: WriteNumber(Buffer[1],160,75,5,5,1,176,157,160,Buffer[3]);
       6: WriteNumber(Buffer[1],160,75,5,5,1,208,157,200,Buffer[3]);
       7: WriteNumber(Buffer[1],160,75,5,5,1,238,157,300,Buffer[3]);
       8: WriteNumber(Buffer[1],160,75,5,5,1,270,157,400,Buffer[3]);
       9: WriteNumber(Buffer[1],160,75,5,5,1,302,157,750,Buffer[3]);
      End; {Case End}
    End;

    If WaitAction.Risk[1]=1 then WriteSprite(220,104,0,140,47,179,Buffer[1],Buffer[3])  {HLAVA SVETLA}
                            else WriteSprite(220,104,0,100,47,139,Buffer[1],Buffer[3]); {HLAVA TMAVA}
    If WaitAction.Risk[2]=1 then WriteSprite(268,104,48,140,95,179,Buffer[1],Buffer[3])  {OREL SVETLY}
                            else WriteSprite(268,104,48,100,95,139,Buffer[1],Buffer[3]); {OREL TMAVY}

    If WaitAction.WinGamble[1]=1 then
    Begin
      WriteSprite(28,114,100,166,132,181,Buffer[1],Buffer[3]);
      WriteBlok(30,132,250,0,282,18,Buffer[1],Buffer[3]);
    End else
    Begin
      WriteSprite(28,114,100,150,132,165,Buffer[1],Buffer[3]);
      WriteBlok(30,132,250,20,282,38,Buffer[1],Buffer[3]);
    End;

    If WaitAction.WinGamble[2]=1 then
    Begin
      WriteSprite(74,114,137,166,148,181,Buffer[1],Buffer[3]);
      WriteBlok(64,132,210,0,242,18,Buffer[1],Buffer[3]);
    End else
    Begin
      WriteSprite(74,114,137,150,148,165,Buffer[1],Buffer[3]);
      WriteBlok(64,132,210,20,242,38,Buffer[1],Buffer[3]);
    End;

    Blok(30,150,96,151,ColorUnknown,Buffer[3]);

  End;

  WaitRetrace;
  HideMouse;
  FlipPage(Buffer[3],Buffer[4]);
  ShowMouse;
End;