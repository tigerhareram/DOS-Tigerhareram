Procedure SetSazka;
Var I: Byte;
Begin
  ClearSazka;
  Case TypSazky of
    0: Begin {1}
         Kurz:=36;
         Xzetonu:=33;
         Yzetonu:=77;
         SazPole[38].Vsazeno:=True;
       End;
    1: Begin {2}
         Kurz:=36;
         Xzetonu:=33;
         Yzetonu:=55;
         SazPole[25].Vsazeno:=True;
       End;
    2: Begin {3}
         Kurz:=36;
         Xzetonu:=33;
         Yzetonu:=33;
         SazPole[12].Vsazeno:=True;
       End;
    3: Begin {4}
         Kurz:=36;
         Xzetonu:=55;
         Yzetonu:=77;
         SazPole[39].Vsazeno:=True;
       End;
    4: Begin {5}
         Kurz:=36;
         Xzetonu:=55;
         Yzetonu:=55;
         SazPole[26].Vsazeno:=True;
       End;
    5: Begin {6}
         Kurz:=36;
         Xzetonu:=55;
         Yzetonu:=33;
         SazPole[13].Vsazeno:=True;
       End;
    6: Begin {7}
         Kurz:=36;
         Xzetonu:=77;
         Yzetonu:=77;
         SazPole[40].Vsazeno:=True;
       End;
    7: Begin {8}
         Kurz:=36;
         Xzetonu:=77;
         Yzetonu:=55;
         SazPole[27].Vsazeno:=True;
       End;
    8: Begin {9}
         Kurz:=36;
         Xzetonu:=77;
         Yzetonu:=33;
         SazPole[14].Vsazeno:=True;
       End;
    9: Begin {10}
         Kurz:=36;
         Xzetonu:=99;
         Yzetonu:=77;
         SazPole[41].Vsazeno:=True;
       End;
   10: Begin {11}
         Kurz:=36;
         Xzetonu:=99;
         Yzetonu:=55;
         SazPole[28].Vsazeno:=True;
       End;
   11: Begin {12}
         Kurz:=36;
         Xzetonu:=99;
         Yzetonu:=33;
         SazPole[15].Vsazeno:=True;
       End;
   12: Begin {13}
         Kurz:=36;
         Xzetonu:=121;
         Yzetonu:=77;
         SazPole[42].Vsazeno:=True;
       End;
   13: Begin {14}
         Kurz:=36;
         Xzetonu:=121;
         Yzetonu:=55;
         SazPole[29].Vsazeno:=True;
       End;
   14: Begin {15}
         Kurz:=36;
         Xzetonu:=121;
         Yzetonu:=33;
         SazPole[16].Vsazeno:=True;
       End;
   15: Begin {16}
         Kurz:=36;
         Xzetonu:=143;
         Yzetonu:=77;
         SazPole[43].Vsazeno:=True;
       End;
   16: Begin {17}
         Kurz:=36;
         Xzetonu:=143;
         Yzetonu:=55;
         SazPole[30].Vsazeno:=True;
       End;
   17: Begin {18}
         Kurz:=36;
         Xzetonu:=143;
         Yzetonu:=33;
         SazPole[17].Vsazeno:=True;
       End;
   18: Begin {19}
         Kurz:=36;
         Xzetonu:=165;
         Yzetonu:=77;
         SazPole[44].Vsazeno:=True;
       End;
   19: Begin {20}
         Kurz:=36;
         Xzetonu:=165;
         Yzetonu:=55;
         SazPole[31].Vsazeno:=True;
       End;
   20: Begin {21}
         Kurz:=36;
         Xzetonu:=165;
         Yzetonu:=33;
         SazPole[18].Vsazeno:=True;
       End;
   21: Begin {22}
         Kurz:=36;
         Xzetonu:=187;
         Yzetonu:=77;
         SazPole[45].Vsazeno:=True;
       End;
   22: Begin {23}
         Kurz:=36;
         Xzetonu:=187;
         Yzetonu:=55;
         SazPole[32].Vsazeno:=True;
       End;
   23: Begin {24}
         Kurz:=36;
         Xzetonu:=187;
         Yzetonu:=33;
         SazPole[19].Vsazeno:=True;
       End;
   24: Begin {25}
         Kurz:=36;
         Xzetonu:=209;
         Yzetonu:=77;
         SazPole[46].Vsazeno:=True;
       End;
   25: Begin {26}
         Kurz:=36;
         Xzetonu:=209;
         Yzetonu:=55;
         SazPole[33].Vsazeno:=True;
       End;
   26: Begin {27}
         Kurz:=36;
         Xzetonu:=209;
         Yzetonu:=33;
         SazPole[20].Vsazeno:=True;
       End;
   27: Begin {28}
         Kurz:=36;
         Xzetonu:=231;
         Yzetonu:=77;
         SazPole[47].Vsazeno:=True;
       End;
   28: Begin {29}
         Kurz:=36;
         Xzetonu:=231;
         Yzetonu:=55;
         SazPole[34].Vsazeno:=True;
       End;
   29: Begin {30}
         Kurz:=36;
         Xzetonu:=231;
         Yzetonu:=33;
         SazPole[21].Vsazeno:=True;
       End;
   30: Begin {31}
         Kurz:=36;
         Xzetonu:=253;
         Yzetonu:=77;
         SazPole[48].Vsazeno:=True;
       End;
   31: Begin {32}
         Kurz:=36;
         Xzetonu:=253;
         Yzetonu:=55;
         SazPole[35].Vsazeno:=True;
       End;
   32: Begin {33}
         Kurz:=36;
         Xzetonu:=253;
         Yzetonu:=33;
         SazPole[22].Vsazeno:=True;
       End;
   33: Begin {34}
         Kurz:=36;
         Xzetonu:=275;
         Yzetonu:=77;
         SazPole[49].Vsazeno:=True;
       End;
   34: Begin {35}
         Kurz:=36;
         Xzetonu:=275;
         Yzetonu:=55;
         SazPole[36].Vsazeno:=True;
       End;
   35: Begin {36}
         Kurz:=36;
         Xzetonu:=275;
         Yzetonu:=33;
         SazPole[23].Vsazeno:=True;
       End;
   36: Begin {0}
         Kurz:=36;
         Xzetonu:=11;
         Yzetonu:=71;
         SazPole[61].Vsazeno:=True;
       End;
   37: Begin {99}
         Kurz:=36;
         Xzetonu:=11;
         Yzetonu:=39;
         SazPole[60].Vsazeno:=True;
       End;
   38: Begin {1-18}
         Kurz:=2;
         Xzetonu:=44;
         Yzetonu:=121;
         For I:=38 to 43 do SazPole[I].Vsazeno:=True;
         For I:=25 to 30 do SazPole[I].Vsazeno:=True;
         For I:=12 to 17 do SazPole[I].Vsazeno:=True;
       End;
   39: Begin {suda}
         Kurz:=2;
         Xzetonu:=88;
         Yzetonu:=121;
         SazPole[25].Vsazeno:=True;
         SazPole[39].Vsazeno:=True;
         SazPole[13].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
         SazPole[41].Vsazeno:=True;
         SazPole[15].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
         SazPole[43].Vsazeno:=True;
         SazPole[17].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
         SazPole[45].Vsazeno:=True;
         SazPole[19].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
         SazPole[47].Vsazeno:=True;
         SazPole[21].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
         SazPole[49].Vsazeno:=True;
         SazPole[23].Vsazeno:=True;
       End;
   40: Begin {cervena}
         Kurz:=2;
         Xzetonu:=132;
         Yzetonu:=121;
         SazPole[38].Vsazeno:=True;
         SazPole[12].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
         SazPole[40].Vsazeno:=True;
         SazPole[14].Vsazeno:=True;
         SazPole[15].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
         SazPole[43].Vsazeno:=True;
         SazPole[17].Vsazeno:=True;
         SazPole[44].Vsazeno:=True;
         SazPole[18].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
         SazPole[46].Vsazeno:=True;
         SazPole[20].Vsazeno:=True;
         SazPole[21].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
         SazPole[49].Vsazeno:=True;
         SazPole[23].Vsazeno:=True;
       End;
   41: Begin {cerna}
         Kurz:=2;
         Xzetonu:=176;
         Yzetonu:=121;
         SazPole[25].Vsazeno:=True;
         SazPole[39].Vsazeno:=True;
         SazPole[13].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
         SazPole[41].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
         SazPole[42].Vsazeno:=True;
         SazPole[16].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
         SazPole[45].Vsazeno:=True;
         SazPole[19].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
         SazPole[47].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
         SazPole[48].Vsazeno:=True;
         SazPole[22].Vsazeno:=True;
         SazPole[36].Vsazeno:=True;
       End;
   42: Begin {licha}
         Kurz:=2;
         Xzetonu:=220;
         Yzetonu:=121;
         SazPole[38].Vsazeno:=True;
         SazPole[12].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
         SazPole[40].Vsazeno:=True;
         SazPole[14].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
         SazPole[42].Vsazeno:=True;
         SazPole[16].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
         SazPole[44].Vsazeno:=True;
         SazPole[18].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
         SazPole[46].Vsazeno:=True;
         SazPole[20].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
         SazPole[48].Vsazeno:=True;
         SazPole[22].Vsazeno:=True;
         SazPole[36].Vsazeno:=True;
       End;
   43: Begin {19-36}
         Kurz:=2;
         Xzetonu:=266;
         Yzetonu:=121;
         For I:=44 to 49 do SazPole[I].Vsazeno:=True;
         For I:=31 to 36 do SazPole[I].Vsazeno:=True;
         For I:=18 to 23 do SazPole[I].Vsazeno:=True;
       End;
   44: Begin {1. 12}
         Kurz:=3;
         Xzetonu:=66;
         Yzetonu:=99;
         For I:=12 to 15 do SazPole[I].Vsazeno:=True;
         For I:=25 to 28 do SazPole[I].Vsazeno:=True;
         For I:=38 to 41 do SazPole[I].Vsazeno:=True;
       End;
   45: Begin {2. 12}
         Kurz:=3;
         Xzetonu:=154;
         Yzetonu:=99;
         For I:=16 to 19 do SazPole[I].Vsazeno:=True;
         For I:=29 to 32 do SazPole[I].Vsazeno:=True;
         For I:=42 to 45 do SazPole[I].Vsazeno:=True;
       End;
   46: Begin {3. 12}
         Kurz:=3;
         Xzetonu:=242;
         Yzetonu:=99;
         For I:=20 to 23 do SazPole[I].Vsazeno:=True;
         For I:=33 to 36 do SazPole[I].Vsazeno:=True;
         For I:=46 to 49 do SazPole[I].Vsazeno:=True;
       End;
   47: Begin {hornich 12}
         Kurz:=3;
         Xzetonu:=297;
         Yzetonu:=33;
         For I:=12 to 23 do SazPole[I].Vsazeno:=True;
       End;
   48: Begin {prostrednich 12}
         Kurz:=3;
         Xzetonu:=297;
         Yzetonu:=55;
         For I:=25 to 36 do SazPole[I].Vsazeno:=True;
       End;
   49: Begin {dolnich 12}
         Kurz:=3;
         Xzetonu:=297;
         Yzetonu:=77;
         For I:=38 to 49 do SazPole[I].Vsazeno:=True;
       End;
   50: Begin {1 2 3 4 5 6}
         Kurz:=6;
         Xzetonu:=44;
         Yzetonu:=11;
         SazPole[12].Vsazeno:=True;
         SazPole[25].Vsazeno:=True;
         SazPole[38].Vsazeno:=True;
         SazPole[13].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
         SazPole[39].Vsazeno:=True;
       End;
   51: Begin {4 5 6 7 8 9}
         Kurz:=6;
         Xzetonu:=66;
         Yzetonu:=11;
         SazPole[13].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
         SazPole[39].Vsazeno:=True;
         SazPole[14].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
         SazPole[40].Vsazeno:=True;
       End;
   52: Begin {7 8 9 10 11 12}
         Kurz:=6;
         Xzetonu:=88;
         Yzetonu:=11;
         SazPole[14].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
         SazPole[40].Vsazeno:=True;
         SazPole[15].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
         SazPole[41].Vsazeno:=True;
       End;
   53: Begin {10 11 12 13 14 15}
         Kurz:=6;
         Xzetonu:=110;
         Yzetonu:=11;
         SazPole[15].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
         SazPole[41].Vsazeno:=True;
         SazPole[16].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
         SazPole[42].Vsazeno:=True;
       End;
   54: Begin {13 14 15 16 17 18}
         Kurz:=6;
         Xzetonu:=132;
         Yzetonu:=11;
         SazPole[16].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
         SazPole[42].Vsazeno:=True;
         SazPole[17].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
         SazPole[43].Vsazeno:=True;
       End;
   55: Begin {16 17 18 19 20 21}
         Kurz:=6;
         Xzetonu:=154;
         Yzetonu:=11;
         SazPole[17].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
         SazPole[43].Vsazeno:=True;
         SazPole[18].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
         SazPole[44].Vsazeno:=True;
       End;
   56: Begin {19 20 21 22 23 24}
         Kurz:=6;
         Xzetonu:=176;
         Yzetonu:=11;
         SazPole[18].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
         SazPole[44].Vsazeno:=True;
         SazPole[19].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
         SazPole[45].Vsazeno:=True;
       End;
   57: Begin {22 23 24 25 26 27}
         Kurz:=6;
         Xzetonu:=198;
         Yzetonu:=11;
         SazPole[19].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
         SazPole[45].Vsazeno:=True;
         SazPole[20].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
         SazPole[46].Vsazeno:=True;
       End;
   58: Begin {25 26 27 28 29 30}
         Kurz:=6;
         Xzetonu:=220;
         Yzetonu:=11;
         SazPole[20].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
         SazPole[46].Vsazeno:=True;
         SazPole[21].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
         SazPole[47].Vsazeno:=True;
       End;
   59: Begin {28 29 30 31 32 33}
         Kurz:=6;
         Xzetonu:=242;
         Yzetonu:=11;
         SazPole[21].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
         SazPole[47].Vsazeno:=True;
         SazPole[22].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
         SazPole[48].Vsazeno:=True;
       End;
   60: Begin {31 32 33 34 35 36}
         Kurz:=6;
         Xzetonu:=264;
         Yzetonu:=11;
         SazPole[22].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
         SazPole[48].Vsazeno:=True;
         SazPole[23].Vsazeno:=True;
         SazPole[36].Vsazeno:=True;
         SazPole[49].Vsazeno:=True;
       End;
   61: Begin {3 6 2 5}
         Kurz:=9;
         Xzetonu:=44;
         Yzetonu:=44;
         SazPole[12].Vsazeno:=True;
         SazPole[13].Vsazeno:=True;
         SazPole[25].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
       End;
   62: Begin {2 5 1 4}
         Kurz:=9;
         Xzetonu:=44;
         Yzetonu:=66;
         SazPole[25].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
         SazPole[38].Vsazeno:=True;
         SazPole[39].Vsazeno:=True;
       End;
   63: Begin {6 9 5 8}
         Kurz:=9;
         Xzetonu:=66;
         Yzetonu:=44;
         SazPole[13].Vsazeno:=True;
         SazPole[14].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
       End;
   64: Begin {5 8 4 7}
         Kurz:=9;
         Xzetonu:=66;
         Yzetonu:=66;
         SazPole[26].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
         SazPole[39].Vsazeno:=True;
         SazPole[40].Vsazeno:=True;
       End;
   65: Begin {9 12 8 11}
         Kurz:=9;
         Xzetonu:=88;
         Yzetonu:=44;
         SazPole[14].Vsazeno:=True;
         SazPole[15].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
       End;
   66: Begin {8 11 7 10}
         Kurz:=9;
         Xzetonu:=88;
         Yzetonu:=66;
         SazPole[27].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
         SazPole[40].Vsazeno:=True;
         SazPole[41].Vsazeno:=True;
       End;
   67: Begin {12 15 11 14}
         Kurz:=9;
         Xzetonu:=110;
         Yzetonu:=44;
         SazPole[15].Vsazeno:=True;
         SazPole[16].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
       End;
   68: Begin {11 14 10 13}
         Kurz:=9;
         Xzetonu:=110;
         Yzetonu:=66;
         SazPole[28].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
         SazPole[41].Vsazeno:=True;
         SazPole[42].Vsazeno:=True;
       End;
   69: Begin {15 18 14 17}
         Kurz:=9;
         Xzetonu:=132;
         Yzetonu:=44;
         SazPole[16].Vsazeno:=True;
         SazPole[17].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
       End;
   70: Begin {14 17 13 16}
         Kurz:=9;
         Xzetonu:=132;
         Yzetonu:=66;
         SazPole[29].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
         SazPole[42].Vsazeno:=True;
         SazPole[43].Vsazeno:=True;
       End;
   71: Begin {18 21 17 20}
         Kurz:=9;
         Xzetonu:=154;
         Yzetonu:=44;
         SazPole[17].Vsazeno:=True;
         SazPole[18].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
       End;
   72: Begin {17 20 16 19}
         Kurz:=9;
         Xzetonu:=154;
         Yzetonu:=66;
         SazPole[30].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
         SazPole[43].Vsazeno:=True;
         SazPole[44].Vsazeno:=True;
       End;
   73: Begin {21 24 20 23}
         Kurz:=9;
         Xzetonu:=176;
         Yzetonu:=44;
         SazPole[18].Vsazeno:=True;
         SazPole[19].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
       End;
   74: Begin {20 23 19 22}
         Kurz:=9;
         Xzetonu:=176;
         Yzetonu:=66;
         SazPole[31].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
         SazPole[44].Vsazeno:=True;
         SazPole[45].Vsazeno:=True;
       End;
   75: Begin {24 27 23 26}
         Kurz:=9;
         Xzetonu:=198;
         Yzetonu:=44;
         SazPole[19].Vsazeno:=True;
         SazPole[20].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
       End;
   76: Begin {23 26 22 25}
         Kurz:=9;
         Xzetonu:=198;
         Yzetonu:=66;
         SazPole[32].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
         SazPole[45].Vsazeno:=True;
         SazPole[46].Vsazeno:=True;
       End;
   77: Begin {27 30 26 29}
         Kurz:=9;
         Xzetonu:=220;
         Yzetonu:=44;
         SazPole[20].Vsazeno:=True;
         SazPole[21].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
       End;
   78: Begin {26 29 25 28}
         Kurz:=9;
         Xzetonu:=220;
         Yzetonu:=66;
         SazPole[33].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
         SazPole[46].Vsazeno:=True;
         SazPole[47].Vsazeno:=True;
       End;
   79: Begin {30 33 29 32}
         Kurz:=9;
         Xzetonu:=242;
         Yzetonu:=44;
         SazPole[21].Vsazeno:=True;
         SazPole[22].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
       End;
   80: Begin {29 32 28 31}
         Kurz:=9;
         Xzetonu:=242;
         Yzetonu:=66;
         SazPole[34].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
         SazPole[47].Vsazeno:=True;
         SazPole[48].Vsazeno:=True;
       End;
   81: Begin {33 36 32 35}
         Kurz:=9;
         Xzetonu:=264;
         Yzetonu:=44;
         SazPole[22].Vsazeno:=True;
         SazPole[23].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
         SazPole[36].Vsazeno:=True;
       End;
   82: Begin {32 35 31 34}
         Kurz:=9;
         Xzetonu:=264;
         Yzetonu:=66;
         SazPole[35].Vsazeno:=True;
         SazPole[36].Vsazeno:=True;
         SazPole[48].Vsazeno:=True;
         SazPole[49].Vsazeno:=True;
       End;
   83: Begin {1 2 3}
         Kurz:=12;
         Xzetonu:=33;
         Yzetonu:=11;
         SazPole[12].Vsazeno:=True;
         SazPole[25].Vsazeno:=True;
         SazPole[38].Vsazeno:=True;
       End;
   84: Begin {4 5 6}
         Kurz:=12;
         Xzetonu:=55;
         Yzetonu:=11;
         SazPole[13].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
         SazPole[39].Vsazeno:=True;
       End;
   85: Begin {7 8 9}
         Kurz:=12;
         Xzetonu:=77;
         Yzetonu:=11;
         SazPole[14].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
         SazPole[40].Vsazeno:=True;
       End;
   86: Begin {10 11 12}
         Kurz:=12;
         Xzetonu:=99;
         Yzetonu:=11;
         SazPole[15].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
         SazPole[41].Vsazeno:=True;
       End;
   87: Begin {13 14 15}
         Kurz:=12;
         Xzetonu:=121;
         Yzetonu:=11;
         SazPole[16].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
         SazPole[42].Vsazeno:=True;
       End;
   88: Begin {16 17 18}
         Kurz:=12;
         Xzetonu:=143;
         Yzetonu:=11;
         SazPole[17].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
         SazPole[43].Vsazeno:=True;
       End;
   89: Begin {19 20 21}
         Kurz:=12;
         Xzetonu:=165;
         Yzetonu:=11;
         SazPole[18].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
         SazPole[44].Vsazeno:=True;
       End;
   90: Begin {22 23 24}
         Kurz:=12;
         Xzetonu:=187;
         Yzetonu:=11;
         SazPole[19].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
         SazPole[45].Vsazeno:=True;
       End;
   91: Begin {25 26 27}
         Kurz:=12;
         Xzetonu:=209;
         Yzetonu:=11;
         SazPole[20].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
         SazPole[46].Vsazeno:=True;
       End;
   92: Begin {28 29 30}
         Kurz:=12;
         Xzetonu:=231;
         Yzetonu:=11;
         SazPole[21].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
         SazPole[47].Vsazeno:=True;
       End;
   93: Begin {31 32 33}
         Kurz:=12;
         Xzetonu:=253;
         Yzetonu:=11;
         SazPole[22].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
         SazPole[48].Vsazeno:=True;
       End;
   94: Begin {34 35 36}
         Kurz:=12;
         Xzetonu:=275;
         Yzetonu:=11;
         SazPole[23].Vsazeno:=True;
         SazPole[36].Vsazeno:=True;
         SazPole[49].Vsazeno:=True;
       End;
   95: Begin {00 3 2}
         Kurz:=12;
         Xzetonu:=22;
         Yzetonu:=44;
         SazPole[12].Vsazeno:=True;
         SazPole[25].Vsazeno:=True;
         SazPole[60].Vsazeno:=True;
       End;
   96: Begin {00 2 0}
         Kurz:=12;
         Xzetonu:=22;
         Yzetonu:=55;
         SazPole[60].Vsazeno:=True;
         SazPole[25].Vsazeno:=True;
         SazPole[61].Vsazeno:=True;
       End;
   97: Begin {2 0 1}
         Kurz:=12;
         Xzetonu:=22;
         Yzetonu:=66;
         SazPole[25].Vsazeno:=True;
         SazPole[61].Vsazeno:=True;
         SazPole[38].Vsazeno:=True;
       End;
   98: Begin {3 6}
         Kurz:=18;
         Xzetonu:=44;
         Yzetonu:=33;
         SazPole[12].Vsazeno:=True;
         SazPole[13].Vsazeno:=True;
       End;
   99: Begin {6 9}
         Kurz:=18;
         Xzetonu:=66;
         Yzetonu:=33;
         SazPole[13].Vsazeno:=True;
         SazPole[14].Vsazeno:=True;
       End;
  100: Begin {9 12}
         Kurz:=18;
         Xzetonu:=88;
         Yzetonu:=33;
         SazPole[14].Vsazeno:=True;
         SazPole[15].Vsazeno:=True;
       End;
  101: Begin {12 15}
         Kurz:=18;
         Xzetonu:=110;
         Yzetonu:=33;
         SazPole[15].Vsazeno:=True;
         SazPole[16].Vsazeno:=True;
       End;
  102: Begin {15 18}
         Kurz:=18;
         Xzetonu:=132;
         Yzetonu:=33;
         SazPole[16].Vsazeno:=True;
         SazPole[17].Vsazeno:=True;
       End;
  103: Begin {18 21}
         Kurz:=18;
         Xzetonu:=154;
         Yzetonu:=33;
         SazPole[17].Vsazeno:=True;
         SazPole[18].Vsazeno:=True;
       End;
  104: Begin {21 24}
         Kurz:=18;
         Xzetonu:=176;
         Yzetonu:=33;
         SazPole[18].Vsazeno:=True;
         SazPole[19].Vsazeno:=True;
       End;
  105: Begin {24 27}
         Kurz:=18;
         Xzetonu:=198;
         Yzetonu:=33;
         SazPole[19].Vsazeno:=True;
         SazPole[20].Vsazeno:=True;
       End;
  106: Begin {27 30}
         Kurz:=18;
         Xzetonu:=220;
         Yzetonu:=33;
         SazPole[20].Vsazeno:=True;
         SazPole[21].Vsazeno:=True;
       End;
  107: Begin {30 33}
         Kurz:=18;
         Xzetonu:=242;
         Yzetonu:=33;
         SazPole[21].Vsazeno:=True;
         SazPole[22].Vsazeno:=True;
       End;
  108: Begin {33 36}
         Kurz:=18;
         Xzetonu:=264;
         Yzetonu:=33;
         SazPole[22].Vsazeno:=True;
         SazPole[23].Vsazeno:=True;
       End;
  109: Begin {3 2}
         Kurz:=18;
         Xzetonu:=33;
         Yzetonu:=44;
         SazPole[12].Vsazeno:=True;
         SazPole[25].Vsazeno:=True;
       End;
  110: Begin {6 5}
         Kurz:=18;
         Xzetonu:=55;
         Yzetonu:=44;
         SazPole[13].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
       End;
  111: Begin {9 8}
         Kurz:=18;
         Xzetonu:=77;
         Yzetonu:=44;
         SazPole[14].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
       End;
  112: Begin {12 11}
         Kurz:=18;
         Xzetonu:=99;
         Yzetonu:=44;
         SazPole[15].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
       End;
  113: Begin {15 14}
         Kurz:=18;
         Xzetonu:=121;
         Yzetonu:=44;
         SazPole[16].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
       End;
  114: Begin {18 17}
         Kurz:=18;
         Xzetonu:=143;
         Yzetonu:=44;
         SazPole[17].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
       End;
  115: Begin {21 20}
         Kurz:=18;
         Xzetonu:=165;
         Yzetonu:=44;
         SazPole[18].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
       End;
  116: Begin {24 23}
         Kurz:=18;
         Xzetonu:=187;
         Yzetonu:=44;
         SazPole[19].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
       End;
  117: Begin {27 26}
         Kurz:=18;
         Xzetonu:=209;
         Yzetonu:=44;
         SazPole[20].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
       End;
  118: Begin {30 29}
         Kurz:=18;
         Xzetonu:=231;
         Yzetonu:=44;
         SazPole[21].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
       End;
  119: Begin {33 32}
         Kurz:=18;
         Xzetonu:=253;
         Yzetonu:=44;
         SazPole[22].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
       End;
  120: Begin {36 35}
         Kurz:=18;
         Xzetonu:=275;
         Yzetonu:=44;
         SazPole[23].Vsazeno:=True;
         SazPole[36].Vsazeno:=True;
       End;
  121: Begin {2 5}
         Kurz:=18;
         Xzetonu:=44;
         Yzetonu:=55;
         SazPole[25].Vsazeno:=True;
         SazPole[26].Vsazeno:=True;
       End;
  122: Begin {5 8}
         Kurz:=18;
         Xzetonu:=66;
         Yzetonu:=55;
         SazPole[26].Vsazeno:=True;
         SazPole[27].Vsazeno:=True;
       End;
  123: Begin {8 11}
         Kurz:=18;
         Xzetonu:=88;
         Yzetonu:=55;
         SazPole[27].Vsazeno:=True;
         SazPole[28].Vsazeno:=True;
       End;
  124: Begin {11 14}
         Kurz:=18;
         Xzetonu:=110;
         Yzetonu:=55;
         SazPole[28].Vsazeno:=True;
         SazPole[29].Vsazeno:=True;
       End;
  125: Begin {14 17}
         Kurz:=18;
         Xzetonu:=132;
         Yzetonu:=55;
         SazPole[29].Vsazeno:=True;
         SazPole[30].Vsazeno:=True;
       End;
  126: Begin {17 20}
         Kurz:=18;
         Xzetonu:=154;
         Yzetonu:=55;
         SazPole[30].Vsazeno:=True;
         SazPole[31].Vsazeno:=True;
       End;
  127: Begin {20 23}
         Kurz:=18;
         Xzetonu:=176;
         Yzetonu:=55;
         SazPole[31].Vsazeno:=True;
         SazPole[32].Vsazeno:=True;
       End;
  128: Begin {23 26}
         Kurz:=18;
         Xzetonu:=198;
         Yzetonu:=55;
         SazPole[32].Vsazeno:=True;
         SazPole[33].Vsazeno:=True;
       End;
  129: Begin {26 29}
         Kurz:=18;
         Xzetonu:=220;
         Yzetonu:=55;
         SazPole[33].Vsazeno:=True;
         SazPole[34].Vsazeno:=True;
       End;
  130: Begin {29 32}
         Kurz:=18;
         Xzetonu:=242;
         Yzetonu:=55;
         SazPole[34].Vsazeno:=True;
         SazPole[35].Vsazeno:=True;
       End;
  131: Begin {32 35}
         Kurz:=18;
         Xzetonu:=264;
         Yzetonu:=55;
         SazPole[35].Vsazeno:=True;
         SazPole[36].Vsazeno:=True;
       End;
  132: Begin {2 1}
         Kurz:=18;
         Xzetonu:=33;
         Yzetonu:=66;
         SazPole[25].Vsazeno:=True;
         SazPole[38].Vsazeno:=True;
       End;
  133: Begin {5 4}
         Kurz:=18;
         Xzetonu:=55;
         Yzetonu:=66;
         SazPole[26].Vsazeno:=True;
         SazPole[39].Vsazeno:=True;
       End;
  134: Begin {8 7}
         Kurz:=18;
         Xzetonu:=77;
         Yzetonu:=66;
         SazPole[27].Vsazeno:=True;
         SazPole[40].Vsazeno:=True;
       End;
  135: Begin {11 10}
         Kurz:=18;
         Xzetonu:=99;
         Yzetonu:=66;
         SazPole[28].Vsazeno:=True;
         SazPole[41].Vsazeno:=True;
       End;
  136: Begin {14 13}
         Kurz:=18;
         Xzetonu:=121;
         Yzetonu:=66;
         SazPole[29].Vsazeno:=True;
         SazPole[42].Vsazeno:=True;
       End;
  137: Begin {17 16}
         Kurz:=18;
         Xzetonu:=143;
         Yzetonu:=66;
         SazPole[30].Vsazeno:=True;
         SazPole[43].Vsazeno:=True;
       End;
  138: Begin {20 19}
         Kurz:=18;
         Xzetonu:=165;
         Yzetonu:=66;
         SazPole[31].Vsazeno:=True;
         SazPole[44].Vsazeno:=True;
       End;
  139: Begin {23 22}
         Kurz:=18;
         Xzetonu:=187;
         Yzetonu:=66;
         SazPole[32].Vsazeno:=True;
         SazPole[45].Vsazeno:=True;
       End;
  140: Begin {26 25}
         Kurz:=18;
         Xzetonu:=209;
         Yzetonu:=66;
         SazPole[33].Vsazeno:=True;
         SazPole[46].Vsazeno:=True;
       End;
  141: Begin {29 28}
         Kurz:=18;
         Xzetonu:=231;
         Yzetonu:=66;
         SazPole[34].Vsazeno:=True;
         SazPole[47].Vsazeno:=True;
       End;
  142: Begin {32 31}
         Kurz:=18;
         Xzetonu:=253;
         Yzetonu:=66;
         SazPole[35].Vsazeno:=True;
         SazPole[48].Vsazeno:=True;
       End;
  143: Begin {35 34}
         Kurz:=18;
         Xzetonu:=275;
         Yzetonu:=66;
         SazPole[36].Vsazeno:=True;
         SazPole[49].Vsazeno:=True;
       End;
  144: Begin {1 4}
         Kurz:=18;
         Xzetonu:=44;
         Yzetonu:=77;
         SazPole[38].Vsazeno:=True;
         SazPole[39].Vsazeno:=True;
       End;
  145: Begin {4 7}
         Kurz:=18;
         Xzetonu:=66;
         Yzetonu:=77;
         SazPole[39].Vsazeno:=True;
         SazPole[40].Vsazeno:=True;
       End;
  146: Begin {7 10}
         Kurz:=18;
         Xzetonu:=88;
         Yzetonu:=77;
         SazPole[40].Vsazeno:=True;
         SazPole[41].Vsazeno:=True;
       End;
  147: Begin {10 13}
         Kurz:=18;
         Xzetonu:=110;
         Yzetonu:=77;
         SazPole[41].Vsazeno:=True;
         SazPole[42].Vsazeno:=True;
       End;
  148: Begin {13 16}
         Kurz:=18;
         Xzetonu:=132;
         Yzetonu:=77;
         SazPole[42].Vsazeno:=True;
         SazPole[43].Vsazeno:=True;
       End;
  149: Begin {16 19}
         Kurz:=18;
         Xzetonu:=154;
         Yzetonu:=77;
         SazPole[43].Vsazeno:=True;
         SazPole[44].Vsazeno:=True;
       End;
  150: Begin {19 22}
         Kurz:=18;
         Xzetonu:=176;
         Yzetonu:=77;
         SazPole[44].Vsazeno:=True;
         SazPole[45].Vsazeno:=True;
       End;
  151: Begin {22 25}
         Kurz:=18;
         Xzetonu:=198;
         Yzetonu:=77;
         SazPole[45].Vsazeno:=True;
         SazPole[46].Vsazeno:=True;
       End;
  152: Begin {25 28}
         Kurz:=18;
         Xzetonu:=220;
         Yzetonu:=77;
         SazPole[46].Vsazeno:=True;
         SazPole[47].Vsazeno:=True;
       End;
  153: Begin {28 31}
         Kurz:=18;
         Xzetonu:=242;
         Yzetonu:=77;
         SazPole[47].Vsazeno:=True;
         SazPole[48].Vsazeno:=True;
       End;
  154: Begin {31 34}
         Kurz:=18;
         Xzetonu:=264;
         Yzetonu:=77;
         SazPole[48].Vsazeno:=True;
         SazPole[49].Vsazeno:=True;
       End;
  155: Begin {00 3}
         Kurz:=18;
         Xzetonu:=22;
         Yzetonu:=33;
         SazPole[60].Vsazeno:=True;
         SazPole[12].Vsazeno:=True;
       End;
  156: Begin {00 0}
         Kurz:=18;
         Xzetonu:=11;
         Yzetonu:=55;
         SazPole[60].Vsazeno:=True;
         SazPole[61].Vsazeno:=True;
       End;
  157: Begin {0 1}
         Kurz:=18;
         Xzetonu:=22;
         Yzetonu:=77;
         SazPole[61].Vsazeno:=True;
         SazPole[38].Vsazeno:=True;
       End;
  End; {Case End}
End;