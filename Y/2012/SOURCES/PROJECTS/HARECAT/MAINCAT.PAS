Procedure MainCatScreen;
Begin
  Blok(10,20,70,120,ColorPlice,Buffer[3]);
  Ramecek(10,20,70,120,ColorRed,Buffer[3]);
  Blok(250,20,310,120,ColorPlice,Buffer[3]);
  Ramecek(250,20,310,120,ColorRed,Buffer[3]);
  WriteSprite(80,0,0,30,159,169,Buffer[1],Buffer[3]);
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure CatJapa;
Begin
  If Nadech=True then
  Begin
    If Breath<650 then Inc(Breath)
                  else Begin
                         Breath:=0;
                         Nadech:=False;
                         Vydech:=True;
                         Japa:=0;
                       End;

    Case Breath of
     10: SetPal(ColorPlice,63,63,63);
     20: SetPal(ColorPlice,62,62,62);
     30: SetPal(ColorPlice,61,61,61);
     40: SetPal(ColorPlice,60,60,60);
     50: SetPal(ColorPlice,59,59,59);
     60: SetPal(ColorPlice,58,58,58);
     70: SetPal(ColorPlice,57,57,57);
     80: SetPal(ColorPlice,56,56,56);
     90: SetPal(ColorPlice,55,55,55);
     100: SetPal(ColorPlice,54,54,54);
     110: SetPal(ColorPlice,53,53,53);
     120: SetPal(ColorPlice,52,52,52);
     130: SetPal(ColorPlice,51,51,51);
     140: SetPal(ColorPlice,50,50,50);
     150: SetPal(ColorPlice,49,49,49);
     160: SetPal(ColorPlice,48,48,48);
     170: SetPal(ColorPlice,47,47,47);
     180: SetPal(ColorPlice,46,46,46);
     190: SetPal(ColorPlice,45,45,45);
     200: SetPal(ColorPlice,44,44,44);
     210: SetPal(ColorPlice,43,43,43);
     220: SetPal(ColorPlice,42,42,42);
     230: SetPal(ColorPlice,41,41,41);
     240: SetPal(ColorPlice,40,40,40);
     250: SetPal(ColorPlice,39,39,39);
     260: SetPal(ColorPlice,38,38,38);
     270: SetPal(ColorPlice,37,37,37);
     280: SetPal(ColorPlice,36,36,36);
     290: SetPal(ColorPlice,35,35,35);
     300: SetPal(ColorPlice,34,34,34);
     310: SetPal(ColorPlice,33,33,33);
     320: SetPal(ColorPlice,32,32,32);
     330: SetPal(ColorPlice,31,31,31);
     340: SetPal(ColorPlice,30,30,30);
     350: SetPal(ColorPlice,29,29,29);
     360: SetPal(ColorPlice,28,28,28);
     370: SetPal(ColorPlice,27,27,27);
     380: SetPal(ColorPlice,26,26,26);
     390: SetPal(ColorPlice,25,25,25);
     400: SetPal(ColorPlice,24,24,24);
     410: SetPal(ColorPlice,23,23,23);
     420: SetPal(ColorPlice,22,22,22);
     430: SetPal(ColorPlice,21,21,21);
     440: SetPal(ColorPlice,20,20,20);
     450: SetPal(ColorPlice,19,19,19);
     460: SetPal(ColorPlice,18,18,18);
     470: SetPal(ColorPlice,17,17,17);
     480: SetPal(ColorPlice,16,16,16);
     490: SetPal(ColorPlice,15,15,15);
     500: SetPal(ColorPlice,14,14,14);
     510: SetPal(ColorPlice,13,13,13);
     520: SetPal(ColorPlice,12,12,12);
     530: SetPal(ColorPlice,11,11,11);
     540: SetPal(ColorPlice,10,10,10);
     550: SetPal(ColorPlice,9,9,9);
     560: SetPal(ColorPlice,8,8,8);
     570: SetPal(ColorPlice,7,7,7);
     580: SetPal(ColorPlice,6,6,6);
     590: SetPal(ColorPlice,5,5,5);
     600: SetPal(ColorPlice,4,4,4);
     610: SetPal(ColorPlice,3,3,3);
     620: SetPal(ColorPlice,2,2,2);
     630: SetPal(ColorPlice,1,1,1);
     640: SetPal(ColorPlice,0,0,0);
    End; {Case End}
  End;

  If Vydech=True then
  Begin
    If Breath<6500 then Inc(Breath)
                    else Begin
                           Breath:=0;
                           Vydech:=False;
                           Nadech:=True;
                         End;
    Case Breath of
     100: SetPal(ColorPlice,0,0,0);
     200: SetPal(ColorPlice,1,1,1);
     300: SetPal(ColorPlice,2,2,2);
     400: SetPal(ColorPlice,3,3,3);
     500: SetPal(ColorPlice,4,4,4);
     600: SetPal(ColorPlice,5,5,5);
     700: SetPal(ColorPlice,6,6,6);
     800: SetPal(ColorPlice,7,7,7);
     900: SetPal(ColorPlice,8,8,8);
     1000: SetPal(ColorPlice,9,9,9);
     1100: SetPal(ColorPlice,10,10,10);
     1200: SetPal(ColorPlice,11,11,11);
     1300: SetPal(ColorPlice,12,12,12);
     1400: SetPal(ColorPlice,13,13,13);
     1500: SetPal(ColorPlice,14,14,14);
     1600: SetPal(ColorPlice,15,15,15);
     1700: SetPal(ColorPlice,16,16,16);
     1800: SetPal(ColorPlice,17,17,17);
     1900: SetPal(ColorPlice,18,18,18);
     2000: SetPal(ColorPlice,19,19,19);
     2100: SetPal(ColorPlice,20,20,20);
     2200: SetPal(ColorPlice,21,21,21);
     2300: SetPal(ColorPlice,22,22,22);
     2400: SetPal(ColorPlice,23,23,23);
     2500: SetPal(ColorPlice,24,24,24);
     2600: SetPal(ColorPlice,25,25,25);
     2700: SetPal(ColorPlice,26,26,26);
     2800: SetPal(ColorPlice,27,27,27);
     2900: SetPal(ColorPlice,28,28,28);
     3000: SetPal(ColorPlice,29,29,29);
     3100: SetPal(ColorPlice,30,30,30);
     3200: SetPal(ColorPlice,31,31,31);
     3300: SetPal(ColorPlice,32,32,32);
     3400: SetPal(ColorPlice,33,33,33);
     3500: SetPal(ColorPlice,34,34,34);
     3600: SetPal(ColorPlice,35,35,35);
     3700: SetPal(ColorPlice,36,36,36);
     3800: SetPal(ColorPlice,37,37,37);
     3900: SetPal(ColorPlice,38,38,38);
     4000: SetPal(ColorPlice,39,39,39);
     4100: SetPal(ColorPlice,40,40,40);
     4200: SetPal(ColorPlice,41,41,41);
     4300: SetPal(ColorPlice,42,42,42);
     4400: SetPal(ColorPlice,43,43,43);
     4500: SetPal(ColorPlice,44,44,44);
     4600: SetPal(ColorPlice,45,45,45);
     4700: SetPal(ColorPlice,46,46,46);
     4800: SetPal(ColorPlice,47,47,47);
     4900: SetPal(ColorPlice,48,48,48);
     5000: SetPal(ColorPlice,49,49,49);
     5100: SetPal(ColorPlice,50,50,50);
     5200: SetPal(ColorPlice,51,51,51);
     5300: SetPal(ColorPlice,52,52,52);
     5400: SetPal(ColorPlice,53,53,53);
     5500: SetPal(ColorPlice,54,54,54);
     5600: SetPal(ColorPlice,55,55,55);
     5700: SetPal(ColorPlice,56,56,56);
     5800: SetPal(ColorPlice,57,57,57);
     5900: SetPal(ColorPlice,58,58,58);
     6000: SetPal(ColorPlice,59,59,59);
     6100: SetPal(ColorPlice,60,60,60);
     6200: SetPal(ColorPlice,61,61,61);
     6300: SetPal(ColorPlice,62,62,62);
     6400: SetPal(ColorPlice,63,63,63);
    End; {Case End}
  End;

  If Vydech=True then
  Begin
    If Japa<6500 then Inc(Japa);
    Case Japa Of
       90: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      100: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(138,173,ColorWhite,Buffer[3]);
           End;
      190: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      200: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(142,173,ColorWhite,Buffer[3]);
           End;
      290: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      300: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(146,173,ColorWhite,Buffer[3]);
           End;
      390: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      400: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(150,173,ColorWhite,Buffer[3]);
           End;
      490: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      500: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(138,176,ColorWhite,Buffer[3]);
           End;
      590: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      600: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(142,176,ColorWhite,Buffer[3]);
           End;
      690: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      700: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(146,176,ColorWhite,Buffer[3]);
           End;
      790: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      800: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(150,176,ColorWhite,Buffer[3]);
           End;

      890: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      900: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(170,173,ColorWhite,Buffer[3]);
           End;
      990: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      1000: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(174,173,ColorWhite,Buffer[3]);
           End;
      1090: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      1100: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(178,173,ColorWhite,Buffer[3]);
           End;
      1190: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      1200: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(182,173,ColorWhite,Buffer[3]);
           End;
      1290: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      1300: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(170,176,ColorWhite,Buffer[3]);
           End;
      1390: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      1400: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(174,176,ColorWhite,Buffer[3]);
           End;
      1490: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      1500: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(178,176,ColorWhite,Buffer[3]);
           End;
      1590: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      1600: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(182,176,ColorWhite,Buffer[3]);
           End;

      1690: Blok(80,170,239,189,ColorPozadi,Buffer[3]);
      1700: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(138,173,ColorWhite,Buffer[3]);
           End;
      1790: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      1800: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(142,173,ColorWhite,Buffer[3]);
           End;
      1890: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      1900: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(146,173,ColorWhite,Buffer[3]);
           End;
      1990: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2000: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(150,173,ColorWhite,Buffer[3]);
           End;
      2090: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2100: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(138,176,ColorWhite,Buffer[3]);
           End;
      2190: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2200: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(142,176,ColorWhite,Buffer[3]);
           End;
      2290: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2300: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(146,176,ColorWhite,Buffer[3]);
           End;
      2390: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2400: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(150,176,ColorWhite,Buffer[3]);
           End;

      2490: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2500: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(170,173,ColorWhite,Buffer[3]);
           End;
      2590: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2600: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(174,173,ColorWhite,Buffer[3]);
           End;
      2690: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2700: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(178,173,ColorWhite,Buffer[3]);
           End;
      2790: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2800: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(182,173,ColorWhite,Buffer[3]);
           End;
      2890: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      2900: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(170,176,ColorWhite,Buffer[3]);
           End;
      2990: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      3000: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(174,176,ColorWhite,Buffer[3]);
           End;
      3090: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      3100: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(178,176,ColorWhite,Buffer[3]);
           End;
      3190: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      3200: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(182,176,ColorWhite,Buffer[3]);
           End;

      3290: Blok(80,170,239,189,ColorPozadi,Buffer[3]);
      3300: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(138,173,ColorWhite,Buffer[3]);
           End;
      3390: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      3400: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(142,173,ColorWhite,Buffer[3]);
           End;
      3490: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      3500: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(146,173,ColorWhite,Buffer[3]);
           End;
      3590: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      3600: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(150,173,ColorWhite,Buffer[3]);
           End;
      3690: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      3700: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(138,176,ColorWhite,Buffer[3]);
           End;
      3790: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      3800: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(142,176,ColorWhite,Buffer[3]);
           End;
      3890: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      3900: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(146,176,ColorWhite,Buffer[3]);
           End;
      3990: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      4000: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(150,176,ColorWhite,Buffer[3]);
           End;

      4090: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      4100: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(170,173,ColorWhite,Buffer[3]);
           End;
      4190: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      4200: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(174,173,ColorWhite,Buffer[3]);
           End;
      4290: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      4300: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(178,173,ColorWhite,Buffer[3]);
           End;
      4390: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      4400: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(182,173,ColorWhite,Buffer[3]);
           End;
      4490: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      4500: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(170,176,ColorWhite,Buffer[3]);
           End;
      4590: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      4600: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(174,176,ColorWhite,Buffer[3]);
           End;
      4690: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      4700: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(178,176,ColorWhite,Buffer[3]);
           End;
      4790: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      4800: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(182,176,ColorWhite,Buffer[3]);
           End;

      4890: Blok(80,170,239,189,ColorPozadi,Buffer[3]);
      4900: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(138,173,ColorWhite,Buffer[3]);
           End;
      4990: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5000: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(142,173,ColorWhite,Buffer[3]);
           End;
      5090: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5100: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(146,173,ColorWhite,Buffer[3]);
           End;
      5190: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5200: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(150,173,ColorWhite,Buffer[3]);
           End;
      5290: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5300: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(138,176,ColorWhite,Buffer[3]);
           End;
      5390: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5400: Begin
             SBPlayRaw(02);
             OutText(144,180,'Kriçna',Buffer[3]);
             WritePixel(142,176,ColorWhite,Buffer[3]);
           End;
      5490: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5500: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(146,176,ColorWhite,Buffer[3]);
           End;
      5590: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5600: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(150,176,ColorWhite,Buffer[3]);
           End;

      5690: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5700: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(170,173,ColorWhite,Buffer[3]);
           End;
      5790: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5800: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(174,173,ColorWhite,Buffer[3]);
           End;
      5890: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      5900: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(178,173,ColorWhite,Buffer[3]);
           End;
      5990: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      6000: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(182,173,ColorWhite,Buffer[3]);
           End;
      6090: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      6100: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(170,176,ColorWhite,Buffer[3]);
           End;
      6190: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      6200: Begin
             SBPlayRaw(03);
             OutText(148,180,'R ma',Buffer[3]);
             WritePixel(174,176,ColorWhite,Buffer[3]);
           End;
      6290: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      6300: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(178,176,ColorWhite,Buffer[3]);
           End;
      6390: Blok(80,180,239,189,ColorPozadi,Buffer[3]);
      6400: Begin
             SBPlayRaw(01);
             OutText(148,180,'Har‚',Buffer[3]);
             WritePixel(182,176,ColorWhite,Buffer[3]);
           End;
      6490: Blok(80,170,239,189,ColorPozadi,Buffer[3]);
    End; {Case End}
  End;

End;


Procedure MainCat;
Var Ending: Boolean;
Begin
  Ending:=False;
  Nadech:=True;
  Vydech:=False;
  Breath:=0;
  Japa:=0;
  Repeat

    MainCatScreen;
    CatJapa;

    If Key[1]=True then
    Begin
      While Key[1]=True do Begin End;
      Ending:=True;
    End;

  Until Ending=True;
End;