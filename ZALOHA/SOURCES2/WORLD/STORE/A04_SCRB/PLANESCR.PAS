Procedure PlanetScreen(planeta,mesic: Word);
Var JmenoSlozky: String;
    Cesta: String;
Begin
  SVGA_ClearPage(ColX[0]);
  SVGA_Rectangle(0,0,639,479,ColX[15]);
  SVGA_Rectangle(0,0,639,15,ColX[15]);
  Text_OutText(5,3,'Ovladani: Sipky,Enter,Backspace,Delete,Esc, IJKL+ASQW',Buffer[0],SVGA);
  Text_OutText(420,3,'* W.O.R.L.D. *',Buffer[0],SVGA);
  Text_OutText(590,3,'Esc=Exit',Buffer[0],SVGA);

  Case planeta of
    0: Begin                                                     {Merkur}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\01\01-00\01-00.bmp',0,320,15,0); End;
         End; {Case End}
       End;
    1: Begin                                                     {Venuse}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\02\02-00\02-00.bmp',0,320,15,0); End;
         End; {Case End}
       End;
    2: Begin                                                     {Zeme}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\03\03-00\03-00.bmp',0,320,15,0); End;
           1: Begin ShowBMP640('PLANETY\03\03-01\03-01.bmp',0,320,15,0); End;
         End; {Case End}
       End;
    3: Begin                                                     {Mars}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\04\04-00\04-00.bmp',0,320,15,0); End;
           1: Begin ShowBMP640('PLANETY\04\04-01\04-01.bmp',0,320,15,0); End;
           2: Begin ShowBMP640('PLANETY\04\04-02\04-02.bmp',0,320,15,0); End;
         End; {Case End}
       End;
    4: Begin                                                     {Jupiter}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\05\05-00\05-00.bmp',0,320,15,0); End;
           1: Begin ShowBMP640('PLANETY\05\05-01\05-01.bmp',0,320,15,0); End;
           2: Begin ShowBMP640('PLANETY\05\05-02\05-02.bmp',0,320,15,0); End;
           3: Begin ShowBMP640('PLANETY\05\05-03\05-03.bmp',0,320,15,0); End;
           4: Begin ShowBMP640('PLANETY\05\05-04\05-04.bmp',0,320,15,0); End;
           5: Begin ShowBMP640('PLANETY\05\05-05\05-05.bmp',0,320,15,0); End;
           6: Begin ShowBMP640('PLANETY\05\05-06\05-06.bmp',0,320,15,0); End;
           7: Begin ShowBMP640('PLANETY\05\05-07\05-07.bmp',0,320,15,0); End;
           8: Begin ShowBMP640('PLANETY\05\05-08\05-08.bmp',0,320,15,0); End;
           9: Begin ShowBMP640('PLANETY\05\05-09\05-09.bmp',0,320,15,0); End;
          10: Begin ShowBMP640('PLANETY\05\05-10\05-10.bmp',0,320,15,0); End;
          11: Begin ShowBMP640('PLANETY\05\05-11\05-11.bmp',0,320,15,0); End;
          12: Begin ShowBMP640('PLANETY\05\05-12\05-12.bmp',0,320,15,0); End;
          13: Begin ShowBMP640('PLANETY\05\05-13\05-13.bmp',0,320,15,0); End;
          14: Begin ShowBMP640('PLANETY\05\05-14\05-14.bmp',0,320,15,0); End;
          15: Begin ShowBMP640('PLANETY\05\05-15\05-15.bmp',0,320,15,0); End;
          16: Begin ShowBMP640('PLANETY\05\05-16\05-16.bmp',0,320,15,0); End;
          17: Begin ShowBMP640('PLANETY\05\05-17\05-17.bmp',0,320,15,0); End;
          18: Begin ShowBMP640('PLANETY\05\05-18\05-18.bmp',0,320,15,0); End;
          19: Begin ShowBMP640('PLANETY\05\05-19\05-19.bmp',0,320,15,0); End;
          20: Begin ShowBMP640('PLANETY\05\05-20\05-20.bmp',0,320,15,0); End;
          21: Begin ShowBMP640('PLANETY\05\05-21\05-21.bmp',0,320,15,0); End;
          22: Begin ShowBMP640('PLANETY\05\05-22\05-22.bmp',0,320,15,0); End;
          23: Begin ShowBMP640('PLANETY\05\05-23\05-23.bmp',0,320,15,0); End;
          24: Begin ShowBMP640('PLANETY\05\05-24\05-24.bmp',0,320,15,0); End;
          25: Begin ShowBMP640('PLANETY\05\05-25\05-25.bmp',0,320,15,0); End;
          26: Begin ShowBMP640('PLANETY\05\05-26\05-26.bmp',0,320,15,0); End;
          27: Begin ShowBMP640('PLANETY\05\05-27\05-27.bmp',0,320,15,0); End;
          28: Begin ShowBMP640('PLANETY\05\05-28\05-28.bmp',0,320,15,0); End;
          29: Begin ShowBMP640('PLANETY\05\05-29\05-29.bmp',0,320,15,0); End;
          30: Begin ShowBMP640('PLANETY\05\05-30\05-30.bmp',0,320,15,0); End;
          31: Begin ShowBMP640('PLANETY\05\05-31\05-31.bmp',0,320,15,0); End;
          32: Begin ShowBMP640('PLANETY\05\05-32\05-32.bmp',0,320,15,0); End;
          33: Begin ShowBMP640('PLANETY\05\05-33\05-33.bmp',0,320,15,0); End;
          34: Begin ShowBMP640('PLANETY\05\05-34\05-34.bmp',0,320,15,0); End;
          35: Begin ShowBMP640('PLANETY\05\05-35\05-35.bmp',0,320,15,0); End;
          36: Begin ShowBMP640('PLANETY\05\05-36\05-36.bmp',0,320,15,0); End;
          37: Begin ShowBMP640('PLANETY\05\05-37\05-37.bmp',0,320,15,0); End;
          38: Begin ShowBMP640('PLANETY\05\05-38\05-38.bmp',0,320,15,0); End;
          39: Begin ShowBMP640('PLANETY\05\05-39\05-39.bmp',0,320,15,0); End;
          40: Begin ShowBMP640('PLANETY\05\05-40\05-40.bmp',0,320,15,0); End;
          41: Begin ShowBMP640('PLANETY\05\05-41\05-41.bmp',0,320,15,0); End;
          42: Begin ShowBMP640('PLANETY\05\05-42\05-42.bmp',0,320,15,0); End;
          43: Begin ShowBMP640('PLANETY\05\05-43\05-43.bmp',0,320,15,0); End;
          44: Begin ShowBMP640('PLANETY\05\05-44\05-44.bmp',0,320,15,0); End;
          45: Begin ShowBMP640('PLANETY\05\05-45\05-45.bmp',0,320,15,0); End;
          46: Begin ShowBMP640('PLANETY\05\05-46\05-46.bmp',0,320,15,0); End;
          47: Begin ShowBMP640('PLANETY\05\05-47\05-47.bmp',0,320,15,0); End;
          48: Begin ShowBMP640('PLANETY\05\05-48\05-48.bmp',0,320,15,0); End;
          49: Begin ShowBMP640('PLANETY\05\05-49\05-49.bmp',0,320,15,0); End;
          50: Begin ShowBMP640('PLANETY\05\05-50\05-50.bmp',0,320,15,0); End;
          51: Begin ShowBMP640('PLANETY\05\05-51\05-51.bmp',0,320,15,0); End;
          52: Begin ShowBMP640('PLANETY\05\05-52\05-52.bmp',0,320,15,0); End;
          53: Begin ShowBMP640('PLANETY\05\05-53\05-53.bmp',0,320,15,0); End;
          54: Begin ShowBMP640('PLANETY\05\05-54\05-54.bmp',0,320,15,0); End;
          55: Begin ShowBMP640('PLANETY\05\05-55\05-55.bmp',0,320,15,0); End;
          56: Begin ShowBMP640('PLANETY\05\05-56\05-56.bmp',0,320,15,0); End;
          57: Begin ShowBMP640('PLANETY\05\05-57\05-57.bmp',0,320,15,0); End;
          58: Begin ShowBMP640('PLANETY\05\05-58\05-58.bmp',0,320,15,0); End;
          59: Begin ShowBMP640('PLANETY\05\05-59\05-59.bmp',0,320,15,0); End;
          60: Begin ShowBMP640('PLANETY\05\05-60\05-60.bmp',0,320,15,0); End;
          61: Begin ShowBMP640('PLANETY\05\05-61\05-61.bmp',0,320,15,0); End;
          62: Begin ShowBMP640('PLANETY\05\05-62\05-62.bmp',0,320,15,0); End;
         End; {Case End}
       End;
    5: Begin                                                     {Saturn}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\06\06-00\06-00.bmp',0,320,15,0); End;
           1: Begin ShowBMP640('PLANETY\06\06-01\06-01.bmp',0,320,15,0); End;
           2: Begin ShowBMP640('PLANETY\06\06-02\06-02.bmp',0,320,15,0); End;
           3: Begin ShowBMP640('PLANETY\06\06-03\06-03.bmp',0,320,15,0); End;
           4: Begin ShowBMP640('PLANETY\06\06-04\06-04.bmp',0,320,15,0); End;
           5: Begin ShowBMP640('PLANETY\06\06-05\06-05.bmp',0,320,15,0); End;
           6: Begin ShowBMP640('PLANETY\06\06-06\06-06.bmp',0,320,15,0); End;
           7: Begin ShowBMP640('PLANETY\06\06-07\06-07.bmp',0,320,15,0); End;
           8: Begin ShowBMP640('PLANETY\06\06-08\06-08.bmp',0,320,15,0); End;
           9: Begin ShowBMP640('PLANETY\06\06-09\06-09.bmp',0,320,15,0); End;
          10: Begin ShowBMP640('PLANETY\06\06-10\06-10.bmp',0,320,15,0); End;
          11: Begin ShowBMP640('PLANETY\06\06-11\06-11.bmp',0,320,15,0); End;
          12: Begin ShowBMP640('PLANETY\06\06-12\06-12.bmp',0,320,15,0); End;
          13: Begin ShowBMP640('PLANETY\06\06-13\06-13.bmp',0,320,15,0); End;
          14: Begin ShowBMP640('PLANETY\06\06-14\06-14.bmp',0,320,15,0); End;
          15: Begin ShowBMP640('PLANETY\06\06-15\06-15.bmp',0,320,15,0); End;
          16: Begin ShowBMP640('PLANETY\06\06-16\06-16.bmp',0,320,15,0); End;
          17: Begin ShowBMP640('PLANETY\06\06-17\06-17.bmp',0,320,15,0); End;
          18: Begin ShowBMP640('PLANETY\06\06-18\06-18.bmp',0,320,15,0); End;
          19: Begin ShowBMP640('PLANETY\06\06-19\06-19.bmp',0,320,15,0); End;
          20: Begin ShowBMP640('PLANETY\06\06-20\06-20.bmp',0,320,15,0); End;
          21: Begin ShowBMP640('PLANETY\06\06-21\06-21.bmp',0,320,15,0); End;
          22: Begin ShowBMP640('PLANETY\06\06-22\06-22.bmp',0,320,15,0); End;
          23: Begin ShowBMP640('PLANETY\06\06-23\06-23.bmp',0,320,15,0); End;
          24: Begin ShowBMP640('PLANETY\06\06-24\06-24.bmp',0,320,15,0); End;
          25: Begin ShowBMP640('PLANETY\06\06-25\06-25.bmp',0,320,15,0); End;
          26: Begin ShowBMP640('PLANETY\06\06-26\06-26.bmp',0,320,15,0); End;
          27: Begin ShowBMP640('PLANETY\06\06-27\06-27.bmp',0,320,15,0); End;
          28: Begin ShowBMP640('PLANETY\06\06-28\06-28.bmp',0,320,15,0); End;
          29: Begin ShowBMP640('PLANETY\06\06-29\06-29.bmp',0,320,15,0); End;
          30: Begin ShowBMP640('PLANETY\06\06-30\06-30.bmp',0,320,15,0); End;
          31: Begin ShowBMP640('PLANETY\06\06-31\06-31.bmp',0,320,15,0); End;
          32: Begin ShowBMP640('PLANETY\06\06-32\06-32.bmp',0,320,15,0); End;
          33: Begin ShowBMP640('PLANETY\06\06-33\06-33.bmp',0,320,15,0); End;
          34: Begin ShowBMP640('PLANETY\06\06-34\06-34.bmp',0,320,15,0); End;
          35: Begin ShowBMP640('PLANETY\06\06-35\06-35.bmp',0,320,15,0); End;
          36: Begin ShowBMP640('PLANETY\06\06-36\06-36.bmp',0,320,15,0); End;
          37: Begin ShowBMP640('PLANETY\06\06-37\06-37.bmp',0,320,15,0); End;
          38: Begin ShowBMP640('PLANETY\06\06-38\06-38.bmp',0,320,15,0); End;
          39: Begin ShowBMP640('PLANETY\06\06-39\06-39.bmp',0,320,15,0); End;
          40: Begin ShowBMP640('PLANETY\06\06-40\06-40.bmp',0,320,15,0); End;
          41: Begin ShowBMP640('PLANETY\06\06-41\06-41.bmp',0,320,15,0); End;
          42: Begin ShowBMP640('PLANETY\06\06-42\06-42.bmp',0,320,15,0); End;
          43: Begin ShowBMP640('PLANETY\06\06-43\06-43.bmp',0,320,15,0); End;
          44: Begin ShowBMP640('PLANETY\06\06-44\06-44.bmp',0,320,15,0); End;
          45: Begin ShowBMP640('PLANETY\06\06-45\06-45.bmp',0,320,15,0); End;
          46: Begin ShowBMP640('PLANETY\06\06-46\06-46.bmp',0,320,15,0); End;
          47: Begin ShowBMP640('PLANETY\06\06-47\06-47.bmp',0,320,15,0); End;
          48: Begin ShowBMP640('PLANETY\06\06-48\06-48.bmp',0,320,15,0); End;
          49: Begin ShowBMP640('PLANETY\06\06-49\06-49.bmp',0,320,15,0); End;
          50: Begin ShowBMP640('PLANETY\06\06-50\06-50.bmp',0,320,15,0); End;
         End; {Case End}
       End;
    6: Begin                                                     {Uran}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\07\07-00\07-00.bmp',0,320,15,0); End;
           1: Begin ShowBMP640('PLANETY\07\07-01\07-01.bmp',0,320,15,0); End;
           2: Begin ShowBMP640('PLANETY\07\07-02\07-02.bmp',0,320,15,0); End;
           3: Begin ShowBMP640('PLANETY\07\07-03\07-03.bmp',0,320,15,0); End;
           4: Begin ShowBMP640('PLANETY\07\07-04\07-04.bmp',0,320,15,0); End;
           5: Begin ShowBMP640('PLANETY\07\07-05\07-05.bmp',0,320,15,0); End;
           6: Begin ShowBMP640('PLANETY\07\07-06\07-06.bmp',0,320,15,0); End;
           7: Begin ShowBMP640('PLANETY\07\07-07\07-07.bmp',0,320,15,0); End;
           8: Begin ShowBMP640('PLANETY\07\07-08\07-08.bmp',0,320,15,0); End;
           9: Begin ShowBMP640('PLANETY\07\07-09\07-09.bmp',0,320,15,0); End;
          10: Begin ShowBMP640('PLANETY\07\07-10\07-10.bmp',0,320,15,0); End;
          11: Begin ShowBMP640('PLANETY\07\07-11\07-11.bmp',0,320,15,0); End;
          12: Begin ShowBMP640('PLANETY\07\07-12\07-12.bmp',0,320,15,0); End;
          13: Begin ShowBMP640('PLANETY\07\07-13\07-13.bmp',0,320,15,0); End;
          14: Begin ShowBMP640('PLANETY\07\07-14\07-14.bmp',0,320,15,0); End;
          15: Begin ShowBMP640('PLANETY\07\07-15\07-15.bmp',0,320,15,0); End;
          16: Begin ShowBMP640('PLANETY\07\07-16\07-16.bmp',0,320,15,0); End;
          17: Begin ShowBMP640('PLANETY\07\07-17\07-17.bmp',0,320,15,0); End;
          18: Begin ShowBMP640('PLANETY\07\07-18\07-18.bmp',0,320,15,0); End;
          19: Begin ShowBMP640('PLANETY\07\07-19\07-19.bmp',0,320,15,0); End;
          20: Begin ShowBMP640('PLANETY\07\07-20\07-20.bmp',0,320,15,0); End;
          21: Begin ShowBMP640('PLANETY\07\07-21\07-21.bmp',0,320,15,0); End;
          22: Begin ShowBMP640('PLANETY\07\07-22\07-22.bmp',0,320,15,0); End;
          23: Begin ShowBMP640('PLANETY\07\07-23\07-23.bmp',0,320,15,0); End;
          24: Begin ShowBMP640('PLANETY\07\07-24\07-24.bmp',0,320,15,0); End;
          25: Begin ShowBMP640('PLANETY\07\07-25\07-25.bmp',0,320,15,0); End;
          26: Begin ShowBMP640('PLANETY\07\07-26\07-26.bmp',0,320,15,0); End;
         End; {Case End}
       End;
    7: Begin                                                     {Neptune}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\08\08-00\08-00.bmp',0,320,15,0); End;
           1: Begin ShowBMP640('PLANETY\08\08-01\08-01.bmp',0,320,15,0); End;
           2: Begin ShowBMP640('PLANETY\08\08-02\08-02.bmp',0,320,15,0); End;
           3: Begin ShowBMP640('PLANETY\08\08-03\08-03.bmp',0,320,15,0); End;
           4: Begin ShowBMP640('PLANETY\08\08-04\08-04.bmp',0,320,15,0); End;
           5: Begin ShowBMP640('PLANETY\08\08-05\08-05.bmp',0,320,15,0); End;
           6: Begin ShowBMP640('PLANETY\08\08-06\08-06.bmp',0,320,15,0); End;
           7: Begin ShowBMP640('PLANETY\08\08-07\08-07.bmp',0,320,15,0); End;
           8: Begin ShowBMP640('PLANETY\08\08-08\08-08.bmp',0,320,15,0); End;
           9: Begin ShowBMP640('PLANETY\08\08-09\08-09.bmp',0,320,15,0); End;
          10: Begin ShowBMP640('PLANETY\08\08-10\08-10.bmp',0,320,15,0); End;
          11: Begin ShowBMP640('PLANETY\08\08-11\08-11.bmp',0,320,15,0); End;
          12: Begin ShowBMP640('PLANETY\08\08-12\08-12.bmp',0,320,15,0); End;
          13: Begin ShowBMP640('PLANETY\08\08-13\08-13.bmp',0,320,15,0); End;
         End; {Case End}
       End;
    8: Begin                                                     {Pluto}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\09\09-00\09-00.bmp',0,320,15,0); End;
           1: Begin ShowBMP640('PLANETY\09\09-01\09-01.bmp',0,320,15,0); End;
           2: Begin ShowBMP640('PLANETY\09\09-02\09-02.bmp',0,320,15,0); End;
           3: Begin ShowBMP640('PLANETY\09\09-03\09-03.bmp',0,320,15,0); End;
           4: Begin ShowBMP640('PLANETY\09\09-04\09-04.bmp',0,320,15,0); End;
           5: Begin ShowBMP640('PLANETY\09\09-05\09-05.bmp',0,320,15,0); End;
         End; {Case End}
       End;
    9: Begin                                                     {Haumea}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\10\10-00\10-00.bmp',0,320,15,0); End;
           1: Begin ShowBMP640('PLANETY\10\10-01\10-01.bmp',0,320,15,0); End;
           2: Begin ShowBMP640('PLANETY\10\10-02\10-02.bmp',0,320,15,0); End;
         End; {Case End}
       End;
   10: Begin                                                     {Eris}
         Case mesic of
           0: Begin ShowBMP640('PLANETY\11\11-00\11-00.bmp',0,320,15,0); End;
           1: Begin ShowBMP640('PLANETY\11\11-01\11-01.bmp',0,320,15,0); End;
         End; {Case End}
       End;
   11: Begin {LEGO}
         Str(MainMenuSel+1,JmenoSlozky);
         If (MainMenuSel+1)<10 then JmenoSlozky:='0'+JmenoSlozky;
         Cesta:='LEGO\LEGO-';
         Cesta:=Cesta+JmenoSlozky+'\';
         FindFirst(Cesta+'01.bmp', Archive, DirInfo);
         If DosError = 0 then Begin
                                LoadBmpFile(Cesta+'01.bmp',0,0,0,0,Buffer[3]);
                                SVGA_SprZ(320,15,0,0,159,99,0,Buffer[3]);
                              End;
         FindFirst(Cesta+'02.bmp', Archive, DirInfo);
         If DosError = 0 then Begin
                                LoadBmpFile(Cesta+'02.bmp',0,0,0,24,Buffer[3]);
                                SVGA_SprZ(320+160,15,0,0,159,99,0,Buffer[3]);
                              End;
         FindFirst(Cesta+'03.bmp', Archive, DirInfo);
         If DosError = 0 then Begin
                                LoadBmpFile(Cesta+'03.bmp',0,0,0,48,Buffer[3]);
                                SVGA_SprZ(320,100+15,0,0,159,99,0,Buffer[3]);
                              End;
         FindFirst(Cesta+'04.bmp', Archive, DirInfo);
         If DosError = 0 then Begin
                                LoadBmpFile(Cesta+'04.bmp',0,0,0,72,Buffer[3]);
                                SVGA_SprZ(320+160,100+15,0,0,159,99,0,Buffer[3]);
                              End;
         FindFirst(Cesta+'05.bmp', Archive, DirInfo);
         If DosError = 0 then Begin
                                LoadBmpFile(Cesta+'05.bmp',0,0,0,96,Buffer[3]);
                                SVGA_SprZ(320,200+15,0,0,159,99,0,Buffer[3]);
                              End;
         FindFirst(Cesta+'06.bmp', Archive, DirInfo);
         If DosError = 0 then Begin
                                LoadBmpFile(Cesta+'06.bmp',0,0,0,120,Buffer[3]);
                                SVGA_SprZ(320+160,200+15,0,0,159,99,0,Buffer[3]);
                              End;
       End;
  End;

  SVGA_Rectangle(0,15,319,334,ColX[15]);   {levy}
  SVGA_Rectangle(319,15,639,334,ColX[15]); {pravy} {planeta}
  SVGA_Rectangle(0,334,639,479,ColX[15]);  {dolni}

  SVGA_WaitRetrace;
  SVGA_FlipPage;
End;