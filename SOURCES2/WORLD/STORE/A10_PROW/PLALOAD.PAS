Procedure PlanetLoad(planeta,mesic: Word);
Begin
  LoadGraFile('BITMAP\GRAPHICS\data-01.gra',0,0);
  VGA_SprZ(0,0,0,0,159,199,0,Buffer[3],Buffer[2]);

  Case planeta of
    0: Begin                                                     {Merkur}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\01\01-00\01-00.map',0); End;
         End; {Case End}
       End;
    1: Begin                                                     {Venuse}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\02\02-00\02-00.map',0); End;
         End; {Case End}
       End;
    2: Begin                                                     {Zeme}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\03\03-00\03-00.map',0); End;
           1: Begin LoadMapFile('PLANETY\03\03-01\03-01.map',0); End;
         End; {Case End}
       End;
    3: Begin                                                     {Mars}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\04\04-00\04-00.map',0); End;
           1: Begin LoadMapFile('PLANETY\04\04-01\04-01.map',0); End;
           2: Begin LoadMapFile('PLANETY\04\04-02\04-02.map',0); End;
         End; {Case End}
       End;
    4: Begin                                                     {Jupiter}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\05\05-00\05-00.map',0); End;
           1: Begin LoadMapFile('PLANETY\05\05-01\05-01.map',0); End;
           2: Begin LoadMapFile('PLANETY\05\05-02\05-02.map',0); End;
           3: Begin LoadMapFile('PLANETY\05\05-03\05-03.map',0); End;
           4: Begin LoadMapFile('PLANETY\05\05-04\05-04.map',0); End;
           5: Begin LoadMapFile('PLANETY\05\05-05\05-05.map',0); End;
           6: Begin LoadMapFile('PLANETY\05\05-06\05-06.map',0); End;
           7: Begin LoadMapFile('PLANETY\05\05-07\05-07.map',0); End;
           8: Begin LoadMapFile('PLANETY\05\05-08\05-08.map',0); End;
           9: Begin LoadMapFile('PLANETY\05\05-09\05-09.map',0); End;
          10: Begin LoadMapFile('PLANETY\05\05-10\05-10.map',0); End;
          11: Begin LoadMapFile('PLANETY\05\05-11\05-11.map',0); End;
          12: Begin LoadMapFile('PLANETY\05\05-12\05-12.map',0); End;
          13: Begin LoadMapFile('PLANETY\05\05-13\05-13.map',0); End;
          14: Begin LoadMapFile('PLANETY\05\05-14\05-14.map',0); End;
          15: Begin LoadMapFile('PLANETY\05\05-15\05-15.map',0); End;
          16: Begin LoadMapFile('PLANETY\05\05-16\05-16.map',0); End;
          17: Begin LoadMapFile('PLANETY\05\05-17\05-17.map',0); End;
          18: Begin LoadMapFile('PLANETY\05\05-18\05-18.map',0); End;
          19: Begin LoadMapFile('PLANETY\05\05-19\05-19.map',0); End;
          20: Begin LoadMapFile('PLANETY\05\05-20\05-20.map',0); End;
          21: Begin LoadMapFile('PLANETY\05\05-21\05-21.map',0); End;
          22: Begin LoadMapFile('PLANETY\05\05-22\05-22.map',0); End;
          23: Begin LoadMapFile('PLANETY\05\05-23\05-23.map',0); End;
          24: Begin LoadMapFile('PLANETY\05\05-24\05-24.map',0); End;
          25: Begin LoadMapFile('PLANETY\05\05-25\05-25.map',0); End;
          26: Begin LoadMapFile('PLANETY\05\05-26\05-26.map',0); End;
          27: Begin LoadMapFile('PLANETY\05\05-27\05-27.map',0); End;
          28: Begin LoadMapFile('PLANETY\05\05-28\05-28.map',0); End;
          29: Begin LoadMapFile('PLANETY\05\05-29\05-29.map',0); End;
          30: Begin LoadMapFile('PLANETY\05\05-30\05-30.map',0); End;
          31: Begin LoadMapFile('PLANETY\05\05-31\05-31.map',0); End;
          32: Begin LoadMapFile('PLANETY\05\05-32\05-32.map',0); End;
          33: Begin LoadMapFile('PLANETY\05\05-33\05-33.map',0); End;
          34: Begin LoadMapFile('PLANETY\05\05-34\05-34.map',0); End;
          35: Begin LoadMapFile('PLANETY\05\05-35\05-35.map',0); End;
          36: Begin LoadMapFile('PLANETY\05\05-36\05-36.map',0); End;
          37: Begin LoadMapFile('PLANETY\05\05-37\05-37.map',0); End;
          38: Begin LoadMapFile('PLANETY\05\05-38\05-38.map',0); End;
          39: Begin LoadMapFile('PLANETY\05\05-39\05-39.map',0); End;
          40: Begin LoadMapFile('PLANETY\05\05-40\05-40.map',0); End;
          41: Begin LoadMapFile('PLANETY\05\05-41\05-41.map',0); End;
          42: Begin LoadMapFile('PLANETY\05\05-42\05-42.map',0); End;
          43: Begin LoadMapFile('PLANETY\05\05-43\05-43.map',0); End;
          44: Begin LoadMapFile('PLANETY\05\05-44\05-44.map',0); End;
          45: Begin LoadMapFile('PLANETY\05\05-45\05-45.map',0); End;
          46: Begin LoadMapFile('PLANETY\05\05-46\05-46.map',0); End;
          47: Begin LoadMapFile('PLANETY\05\05-47\05-47.map',0); End;
          48: Begin LoadMapFile('PLANETY\05\05-48\05-48.map',0); End;
          49: Begin LoadMapFile('PLANETY\05\05-49\05-49.map',0); End;
          50: Begin LoadMapFile('PLANETY\05\05-50\05-50.map',0); End;
          51: Begin LoadMapFile('PLANETY\05\05-51\05-51.map',0); End;
          52: Begin LoadMapFile('PLANETY\05\05-52\05-52.map',0); End;
          53: Begin LoadMapFile('PLANETY\05\05-53\05-53.map',0); End;
          54: Begin LoadMapFile('PLANETY\05\05-54\05-54.map',0); End;
          55: Begin LoadMapFile('PLANETY\05\05-55\05-55.map',0); End;
          56: Begin LoadMapFile('PLANETY\05\05-56\05-56.map',0); End;
          57: Begin LoadMapFile('PLANETY\05\05-57\05-57.map',0); End;
          58: Begin LoadMapFile('PLANETY\05\05-58\05-58.map',0); End;
          59: Begin LoadMapFile('PLANETY\05\05-59\05-59.map',0); End;
          60: Begin LoadMapFile('PLANETY\05\05-60\05-60.map',0); End;
          61: Begin LoadMapFile('PLANETY\05\05-61\05-61.map',0); End;
          62: Begin LoadMapFile('PLANETY\05\05-62\05-62.map',0); End;
         End; {Case End}
       End;
    5: Begin                                                     {Saturn}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\06\06-00\06-00.map',0); End;
           1: Begin LoadMapFile('PLANETY\06\06-01\06-01.map',0); End;
           2: Begin LoadMapFile('PLANETY\06\06-02\06-02.map',0); End;
           3: Begin LoadMapFile('PLANETY\06\06-03\06-03.map',0); End;
           4: Begin LoadMapFile('PLANETY\06\06-04\06-04.map',0); End;
           5: Begin LoadMapFile('PLANETY\06\06-05\06-05.map',0); End;
           6: Begin LoadMapFile('PLANETY\06\06-06\06-06.map',0); End;
           7: Begin LoadMapFile('PLANETY\06\06-07\06-07.map',0); End;
           8: Begin LoadMapFile('PLANETY\06\06-08\06-08.map',0); End;
           9: Begin LoadMapFile('PLANETY\06\06-09\06-09.map',0); End;
          10: Begin LoadMapFile('PLANETY\06\06-10\06-10.map',0); End;
          11: Begin LoadMapFile('PLANETY\06\06-11\06-11.map',0); End;
          12: Begin LoadMapFile('PLANETY\06\06-12\06-12.map',0); End;
          13: Begin LoadMapFile('PLANETY\06\06-13\06-13.map',0); End;
          14: Begin LoadMapFile('PLANETY\06\06-14\06-14.map',0); End;
          15: Begin LoadMapFile('PLANETY\06\06-15\06-15.map',0); End;
          16: Begin LoadMapFile('PLANETY\06\06-16\06-16.map',0); End;
          17: Begin LoadMapFile('PLANETY\06\06-17\06-17.map',0); End;
          18: Begin LoadMapFile('PLANETY\06\06-18\06-18.map',0); End;
          19: Begin LoadMapFile('PLANETY\06\06-19\06-19.map',0); End;
          20: Begin LoadMapFile('PLANETY\06\06-20\06-20.map',0); End;
          21: Begin LoadMapFile('PLANETY\06\06-21\06-21.map',0); End;
          22: Begin LoadMapFile('PLANETY\06\06-22\06-22.map',0); End;
          23: Begin LoadMapFile('PLANETY\06\06-23\06-23.map',0); End;
          24: Begin LoadMapFile('PLANETY\06\06-24\06-24.map',0); End;
          25: Begin LoadMapFile('PLANETY\06\06-25\06-25.map',0); End;
          26: Begin LoadMapFile('PLANETY\06\06-26\06-26.map',0); End;
          27: Begin LoadMapFile('PLANETY\06\06-27\06-27.map',0); End;
          28: Begin LoadMapFile('PLANETY\06\06-28\06-28.map',0); End;
          29: Begin LoadMapFile('PLANETY\06\06-29\06-29.map',0); End;
          30: Begin LoadMapFile('PLANETY\06\06-30\06-30.map',0); End;
          31: Begin LoadMapFile('PLANETY\06\06-31\06-31.map',0); End;
          32: Begin LoadMapFile('PLANETY\06\06-32\06-32.map',0); End;
          33: Begin LoadMapFile('PLANETY\06\06-33\06-33.map',0); End;
          34: Begin LoadMapFile('PLANETY\06\06-34\06-34.map',0); End;
          35: Begin LoadMapFile('PLANETY\06\06-35\06-35.map',0); End;
          36: Begin LoadMapFile('PLANETY\06\06-36\06-36.map',0); End;
          37: Begin LoadMapFile('PLANETY\06\06-37\06-37.map',0); End;
          38: Begin LoadMapFile('PLANETY\06\06-38\06-38.map',0); End;
          39: Begin LoadMapFile('PLANETY\06\06-39\06-39.map',0); End;
          40: Begin LoadMapFile('PLANETY\06\06-40\06-40.map',0); End;
          41: Begin LoadMapFile('PLANETY\06\06-41\06-41.map',0); End;
          42: Begin LoadMapFile('PLANETY\06\06-42\06-42.map',0); End;
          43: Begin LoadMapFile('PLANETY\06\06-43\06-43.map',0); End;
          44: Begin LoadMapFile('PLANETY\06\06-44\06-44.map',0); End;
          45: Begin LoadMapFile('PLANETY\06\06-45\06-45.map',0); End;
          46: Begin LoadMapFile('PLANETY\06\06-46\06-46.map',0); End;
          47: Begin LoadMapFile('PLANETY\06\06-47\06-47.map',0); End;
          48: Begin LoadMapFile('PLANETY\06\06-48\06-48.map',0); End;
          49: Begin LoadMapFile('PLANETY\06\06-49\06-49.map',0); End;
          50: Begin LoadMapFile('PLANETY\06\06-50\06-50.map',0); End;
         End; {Case End}
       End;
    6: Begin                                                     {Uran}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\07\07-00\07-00.map',0); End;
           1: Begin LoadMapFile('PLANETY\07\07-01\07-01.map',0); End;
           2: Begin LoadMapFile('PLANETY\07\07-02\07-02.map',0); End;
           3: Begin LoadMapFile('PLANETY\07\07-03\07-03.map',0); End;
           4: Begin LoadMapFile('PLANETY\07\07-04\07-04.map',0); End;
           5: Begin LoadMapFile('PLANETY\07\07-05\07-05.map',0); End;
           6: Begin LoadMapFile('PLANETY\07\07-06\07-06.map',0); End;
           7: Begin LoadMapFile('PLANETY\07\07-07\07-07.map',0); End;
           8: Begin LoadMapFile('PLANETY\07\07-08\07-08.map',0); End;
           9: Begin LoadMapFile('PLANETY\07\07-09\07-09.map',0); End;
          10: Begin LoadMapFile('PLANETY\07\07-10\07-10.map',0); End;
          11: Begin LoadMapFile('PLANETY\07\07-11\07-11.map',0); End;
          12: Begin LoadMapFile('PLANETY\07\07-12\07-12.map',0); End;
          13: Begin LoadMapFile('PLANETY\07\07-13\07-13.map',0); End;
          14: Begin LoadMapFile('PLANETY\07\07-14\07-14.map',0); End;
          15: Begin LoadMapFile('PLANETY\07\07-15\07-15.map',0); End;
          16: Begin LoadMapFile('PLANETY\07\07-16\07-16.map',0); End;
          17: Begin LoadMapFile('PLANETY\07\07-17\07-17.map',0); End;
          18: Begin LoadMapFile('PLANETY\07\07-18\07-18.map',0); End;
          19: Begin LoadMapFile('PLANETY\07\07-19\07-19.map',0); End;
          20: Begin LoadMapFile('PLANETY\07\07-20\07-20.map',0); End;
          21: Begin LoadMapFile('PLANETY\07\07-21\07-21.map',0); End;
          22: Begin LoadMapFile('PLANETY\07\07-22\07-22.map',0); End;
          23: Begin LoadMapFile('PLANETY\07\07-23\07-23.map',0); End;
          24: Begin LoadMapFile('PLANETY\07\07-24\07-24.map',0); End;
          25: Begin LoadMapFile('PLANETY\07\07-25\07-25.map',0); End;
          26: Begin LoadMapFile('PLANETY\07\07-26\07-26.map',0); End;
         End; {Case End}
       End;
    7: Begin                                                     {Neptune}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\08\08-00\08-00.map',0); End;
           1: Begin LoadMapFile('PLANETY\08\08-01\08-01.map',0); End;
           2: Begin LoadMapFile('PLANETY\08\08-02\08-02.map',0); End;
           3: Begin LoadMapFile('PLANETY\08\08-03\08-03.map',0); End;
           4: Begin LoadMapFile('PLANETY\08\08-04\08-04.map',0); End;
           5: Begin LoadMapFile('PLANETY\08\08-05\08-05.map',0); End;
           6: Begin LoadMapFile('PLANETY\08\08-06\08-06.map',0); End;
           7: Begin LoadMapFile('PLANETY\08\08-07\08-07.map',0); End;
           8: Begin LoadMapFile('PLANETY\08\08-08\08-08.map',0); End;
           9: Begin LoadMapFile('PLANETY\08\08-09\08-09.map',0); End;
          10: Begin LoadMapFile('PLANETY\08\08-10\08-10.map',0); End;
          11: Begin LoadMapFile('PLANETY\08\08-11\08-11.map',0); End;
          12: Begin LoadMapFile('PLANETY\08\08-12\08-12.map',0); End;
          13: Begin LoadMapFile('PLANETY\08\08-13\08-13.map',0); End;
         End; {Case End}
       End;
    8: Begin                                                     {Pluto}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\09\09-00\09-00.map',0); End;
           1: Begin LoadMapFile('PLANETY\09\09-01\09-01.map',0); End;
           2: Begin LoadMapFile('PLANETY\09\09-02\09-02.map',0); End;
           3: Begin LoadMapFile('PLANETY\09\09-03\09-03.map',0); End;
           4: Begin LoadMapFile('PLANETY\09\09-04\09-04.map',0); End;
           5: Begin LoadMapFile('PLANETY\09\09-05\09-05.map',0); End;
         End; {Case End}
       End;
    9: Begin                                                     {Haumea}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\10\10-00\10-00.map',0); End;
           1: Begin LoadMapFile('PLANETY\10\10-01\10-01.map',0); End;
           2: Begin LoadMapFile('PLANETY\10\10-02\10-02.map',0); End;
         End; {Case End}
       End;
   10: Begin                                                     {Eris}
         Case mesic of
           0: Begin LoadMapFile('PLANETY\11\11-00\11-00.map',0); End;
           1: Begin LoadMapFile('PLANETY\11\11-01\11-01.map',0); End;
         End; {Case End}
       End;
  End;

End;