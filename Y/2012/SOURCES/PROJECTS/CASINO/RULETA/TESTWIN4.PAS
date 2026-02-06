Function GetBlik(Cislo: Byte): Byte;
Begin
  Case Cislo of
     0: GetBlik:=61;
     1: GetBlik:=38;
     2: GetBlik:=25;
     3: GetBlik:=12;
     4: GetBlik:=39;
     5: GetBlik:=26;
     6: GetBlik:=13;
     7: GetBlik:=40;
     8: GetBlik:=27;
     9: GetBlik:=14;
    10: GetBlik:=41;
    11: GetBlik:=28;
    12: GetBlik:=15;
    13: GetBlik:=42;
    14: GetBlik:=29;
    15: GetBlik:=16;
    16: GetBlik:=43;
    17: GetBlik:=30;
    18: GetBlik:=17;
    19: GetBlik:=44;
    20: GetBlik:=31;
    21: GetBlik:=18;
    22: GetBlik:=45;
    23: GetBlik:=32;
    24: GetBlik:=19;
    25: GetBlik:=46;
    26: GetBlik:=33;
    27: GetBlik:=20;
    28: GetBlik:=47;
    29: GetBlik:=34;
    30: GetBlik:=21;
    31: GetBlik:=48;
    32: GetBlik:=35;
    33: GetBlik:=22;
    34: GetBlik:=49;
    35: GetBlik:=36;
    36: GetBlik:=23;
    99: GetBlik:=60;
  End; {Case End}
End;


Procedure TestWin4;
Var WinRuleta: Boolean;
    I,N: Byte;
Begin
  WinRuleta:=False;
  Case TypSazky of
    0: If CheckCislo=1 then WinRuleta:=True;
    1: If CheckCislo=2 then WinRuleta:=True;
    2: If CheckCislo=3 then WinRuleta:=True;
    3: If CheckCislo=4 then WinRuleta:=True;
    4: If CheckCislo=5 then WinRuleta:=True;
    5: If CheckCislo=6 then WinRuleta:=True;
    6: If CheckCislo=7 then WinRuleta:=True;
    7: If CheckCislo=8 then WinRuleta:=True;
    8: If CheckCislo=9 then WinRuleta:=True;
    9: If CheckCislo=10 then WinRuleta:=True;
    10: If CheckCislo=11 then WinRuleta:=True;
    11: If CheckCislo=12 then WinRuleta:=True;
    12: If CheckCislo=13 then WinRuleta:=True;
    13: If CheckCislo=14 then WinRuleta:=True;
    14: If CheckCislo=15 then WinRuleta:=True;
    15: If CheckCislo=16 then WinRuleta:=True;
    16: If CheckCislo=17 then WinRuleta:=True;
    17: If CheckCislo=18 then WinRuleta:=True;
    18: If CheckCislo=19 then WinRuleta:=True;
    19: If CheckCislo=20 then WinRuleta:=True;
    20: If CheckCislo=21 then WinRuleta:=True;
    21: If CheckCislo=22 then WinRuleta:=True;
    22: If CheckCislo=23 then WinRuleta:=True;
    23: If CheckCislo=24 then WinRuleta:=True;
    24: If CheckCislo=25 then WinRuleta:=True;
    25: If CheckCislo=26 then WinRuleta:=True;
    26: If CheckCislo=27 then WinRuleta:=True;
    27: If CheckCislo=28 then WinRuleta:=True;
    28: If CheckCislo=29 then WinRuleta:=True;
    29: If CheckCislo=30 then WinRuleta:=True;
    30: If CheckCislo=31 then WinRuleta:=True;
    31: If CheckCislo=32 then WinRuleta:=True;
    32: If CheckCislo=33 then WinRuleta:=True;
    33: If CheckCislo=34 then WinRuleta:=True;
    34: If CheckCislo=35 then WinRuleta:=True;
    35: If CheckCislo=36 then WinRuleta:=True;
    36: If CheckCislo=0 then WinRuleta:=True;
    37: If CheckCislo=99 then WinRuleta:=True;
    38: For I:=1 to 18 do If CheckCislo=I then WinRuleta:=True;
    39: For I:=1 to 18 do If CheckCislo=(I*2) then WinRuleta:=True;
    40: Begin
          If CheckCislo=1 then WinRuleta:=True;
          If CheckCislo=3 then WinRuleta:=True;
          If CheckCislo=5 then WinRuleta:=True;
          If CheckCislo=7 then WinRuleta:=True;
          If CheckCislo=9 then WinRuleta:=True;
          If CheckCislo=12 then WinRuleta:=True;
          If CheckCislo=14 then WinRuleta:=True;
          If CheckCislo=16 then WinRuleta:=True;
          If CheckCislo=18 then WinRuleta:=True;
          If CheckCislo=19 then WinRuleta:=True;
          If CheckCislo=21 then WinRuleta:=True;
          If CheckCislo=23 then WinRuleta:=True;
          If CheckCislo=25 then WinRuleta:=True;
          If CheckCislo=27 then WinRuleta:=True;
          If CheckCislo=30 then WinRuleta:=True;
          If CheckCislo=32 then WinRuleta:=True;
          If CheckCislo=34 then WinRuleta:=True;
          If CheckCislo=36 then WinRuleta:=True;
        End;
    41: Begin
          If CheckCislo=2 then WinRuleta:=True;
          If CheckCislo=4 then WinRuleta:=True;
          If CheckCislo=6 then WinRuleta:=True;
          If CheckCislo=8 then WinRuleta:=True;
          If CheckCislo=10 then WinRuleta:=True;
          If CheckCislo=11 then WinRuleta:=True;
          If CheckCislo=13 then WinRuleta:=True;
          If CheckCislo=15 then WinRuleta:=True;
          If CheckCislo=17 then WinRuleta:=True;
          If CheckCislo=20 then WinRuleta:=True;
          If CheckCislo=22 then WinRuleta:=True;
          If CheckCislo=24 then WinRuleta:=True;
          If CheckCislo=26 then WinRuleta:=True;
          If CheckCislo=28 then WinRuleta:=True;
          If CheckCislo=29 then WinRuleta:=True;
          If CheckCislo=31 then WinRuleta:=True;
          If CheckCislo=33 then WinRuleta:=True;
          If CheckCislo=35 then WinRuleta:=True;
        End;
    42: For I:=1 to 18 do If CheckCislo=((I*2)-1) then WinRuleta:=True;
    43: For I:=19 to 36 do If CheckCislo=I then WinRuleta:=True;
    44: For I:=1 to 12 do If CheckCislo=I then WinRuleta:=True;
    45: For I:=13 to 24 do If CheckCislo=I then WinRuleta:=True;
    46: For I:=25 to 36 do If CheckCislo=I then WinRuleta:=True;
    47: For I:=1 to 12 do If CheckCislo=(I*3) then WinRuleta:=True;
    48: For I:=1 to 12 do If CheckCislo=((I*3)-1) then WinRuleta:=True;
    49: For I:=1 to 12 do If CheckCislo=((I*3)-2) then WinRuleta:=True;
    50: For I:=1 to 6 do If CheckCislo=I then WinRuleta:=True;
    51: For I:=4 to 9 do If CheckCislo=I then WinRuleta:=True;
    52: For I:=7 to 12 do If CheckCislo=I then WinRuleta:=True;
    53: For I:=10 to 15 do If CheckCislo=I then WinRuleta:=True;
    54: For I:=13 to 18 do If CheckCislo=I then WinRuleta:=True;
    55: For I:=16 to 21 do If CheckCislo=I then WinRuleta:=True;
    56: For I:=19 to 24 do If CheckCislo=I then WinRuleta:=True;
    57: For I:=22 to 27 do If CheckCislo=I then WinRuleta:=True;
    58: For I:=25 to 30 do If CheckCislo=I then WinRuleta:=True;
    59: For I:=28 to 33 do If CheckCislo=I then WinRuleta:=True;
    60: For I:=31 to 36 do If CheckCislo=I then WinRuleta:=True;
    61: Begin
          If CheckCislo=3 then WinRuleta:=True;
          If CheckCislo=6 then WinRuleta:=True;
          If CheckCislo=2 then WinRuleta:=True;
          If CheckCislo=5 then WinRuleta:=True;
        End;
    62: Begin
          If CheckCislo=2 then WinRuleta:=True;
          If CheckCislo=5 then WinRuleta:=True;
          If CheckCislo=1 then WinRuleta:=True;
          If CheckCislo=4 then WinRuleta:=True;
        End;
    63: Begin
          If CheckCislo=6 then WinRuleta:=True;
          If CheckCislo=9 then WinRuleta:=True;
          If CheckCislo=5 then WinRuleta:=True;
          If CheckCislo=8 then WinRuleta:=True;
        End;
    64: Begin
          If CheckCislo=5 then WinRuleta:=True;
          If CheckCislo=8 then WinRuleta:=True;
          If CheckCislo=4 then WinRuleta:=True;
          If CheckCislo=7 then WinRuleta:=True;
        End;
    65: Begin
          If CheckCislo=9 then WinRuleta:=True;
          If CheckCislo=12 then WinRuleta:=True;
          If CheckCislo=8 then WinRuleta:=True;
          If CheckCislo=11 then WinRuleta:=True;
        End;
    66: Begin
          If CheckCislo=8 then WinRuleta:=True;
          If CheckCislo=11 then WinRuleta:=True;
          If CheckCislo=7 then WinRuleta:=True;
          If CheckCislo=10 then WinRuleta:=True;
        End;
    67: Begin
          If CheckCislo=12 then WinRuleta:=True;
          If CheckCislo=15 then WinRuleta:=True;
          If CheckCislo=11 then WinRuleta:=True;
          If CheckCislo=14 then WinRuleta:=True;
        End;
    68: Begin
          If CheckCislo=11 then WinRuleta:=True;
          If CheckCislo=14 then WinRuleta:=True;
          If CheckCislo=10 then WinRuleta:=True;
          If CheckCislo=13 then WinRuleta:=True;
        End;
    69: Begin
          If CheckCislo=15 then WinRuleta:=True;
          If CheckCislo=18 then WinRuleta:=True;
          If CheckCislo=14 then WinRuleta:=True;
          If CheckCislo=17 then WinRuleta:=True;
        End;
    70: Begin
          If CheckCislo=14 then WinRuleta:=True;
          If CheckCislo=17 then WinRuleta:=True;
          If CheckCislo=13 then WinRuleta:=True;
          If CheckCislo=16 then WinRuleta:=True;
        End;
    71: Begin
          If CheckCislo=18 then WinRuleta:=True;
          If CheckCislo=21 then WinRuleta:=True;
          If CheckCislo=17 then WinRuleta:=True;
          If CheckCislo=20 then WinRuleta:=True;
        End;
    72: Begin
          If CheckCislo=17 then WinRuleta:=True;
          If CheckCislo=20 then WinRuleta:=True;
          If CheckCislo=16 then WinRuleta:=True;
          If CheckCislo=19 then WinRuleta:=True;
        End;
    73: Begin
          If CheckCislo=21 then WinRuleta:=True;
          If CheckCislo=24 then WinRuleta:=True;
          If CheckCislo=20 then WinRuleta:=True;
          If CheckCislo=23 then WinRuleta:=True;
        End;
    74: Begin
          If CheckCislo=20 then WinRuleta:=True;
          If CheckCislo=23 then WinRuleta:=True;
          If CheckCislo=19 then WinRuleta:=True;
          If CheckCislo=22 then WinRuleta:=True;
        End;
    75: Begin
          If CheckCislo=24 then WinRuleta:=True;
          If CheckCislo=27 then WinRuleta:=True;
          If CheckCislo=23 then WinRuleta:=True;
          If CheckCislo=26 then WinRuleta:=True;
        End;
    76: Begin
          If CheckCislo=23 then WinRuleta:=True;
          If CheckCislo=26 then WinRuleta:=True;
          If CheckCislo=22 then WinRuleta:=True;
          If CheckCislo=25 then WinRuleta:=True;
        End;
    77: Begin
          If CheckCislo=27 then WinRuleta:=True;
          If CheckCislo=30 then WinRuleta:=True;
          If CheckCislo=26 then WinRuleta:=True;
          If CheckCislo=29 then WinRuleta:=True;
        End;
    78: Begin
          If CheckCislo=26 then WinRuleta:=True;
          If CheckCislo=29 then WinRuleta:=True;
          If CheckCislo=25 then WinRuleta:=True;
          If CheckCislo=28 then WinRuleta:=True;
        End;
    79: Begin
          If CheckCislo=30 then WinRuleta:=True;
          If CheckCislo=33 then WinRuleta:=True;
          If CheckCislo=29 then WinRuleta:=True;
          If CheckCislo=32 then WinRuleta:=True;
        End;
    80: Begin
          If CheckCislo=29 then WinRuleta:=True;
          If CheckCislo=32 then WinRuleta:=True;
          If CheckCislo=28 then WinRuleta:=True;
          If CheckCislo=31 then WinRuleta:=True;
        End;
    81: Begin
          If CheckCislo=33 then WinRuleta:=True;
          If CheckCislo=36 then WinRuleta:=True;
          If CheckCislo=32 then WinRuleta:=True;
          If CheckCislo=35 then WinRuleta:=True;
        End;
    82: Begin
          If CheckCislo=32 then WinRuleta:=True;
          If CheckCislo=35 then WinRuleta:=True;
          If CheckCislo=31 then WinRuleta:=True;
          If CheckCislo=34 then WinRuleta:=True;
        End;
    83: Begin
          If ((CheckCislo=1) or
              (CheckCislo=2)  or
              (CheckCislo=3)) then WinRuleta:=True;
        End;
    84: Begin
          If ((CheckCislo=4) or
              (CheckCislo=5)  or
              (CheckCislo=6)) then WinRuleta:=True;
        End;
    85: Begin
          If ((CheckCislo=7) or
              (CheckCislo=8)  or
              (CheckCislo=9)) then WinRuleta:=True;
        End;
    86: Begin
          If ((CheckCislo=10) or
              (CheckCislo=11)  or
              (CheckCislo=12)) then WinRuleta:=True;
        End;
    87: Begin
          If ((CheckCislo=13) or
              (CheckCislo=14)  or
              (CheckCislo=15)) then WinRuleta:=True;
        End;
    88: Begin
          If ((CheckCislo=16) or
              (CheckCislo=17)  or
              (CheckCislo=18)) then WinRuleta:=True;
        End;
    89: Begin
          If ((CheckCislo=19) or
              (CheckCislo=20)  or
              (CheckCislo=21)) then WinRuleta:=True;
        End;
    90: Begin
          If ((CheckCislo=22) or
              (CheckCislo=23)  or
              (CheckCislo=24)) then WinRuleta:=True;
        End;
    91: Begin
          If ((CheckCislo=25) or
              (CheckCislo=26)  or
              (CheckCislo=27)) then WinRuleta:=True;
        End;
    92: Begin
          If ((CheckCislo=28) or
              (CheckCislo=29)  or
              (CheckCislo=30)) then WinRuleta:=True;
        End;
    93: Begin
          If ((CheckCislo=31) or
              (CheckCislo=32)  or
              (CheckCislo=33)) then WinRuleta:=True;
        End;
    94: Begin
          If ((CheckCislo=34) or
              (CheckCislo=35)  or
              (CheckCislo=36)) then WinRuleta:=True;
        End;
    95: Begin
          If ((CheckCislo=99) or
              (CheckCislo=3)  or
              (CheckCislo=2)) then WinRuleta:=True;
        End;
    96: Begin
          If ((CheckCislo=99) or
              (CheckCislo=2)  or
              (CheckCislo=0)) then WinRuleta:=True;
        End;
    97: Begin
          If ((CheckCislo=2) or
              (CheckCislo=0)  or
              (CheckCislo=1)) then WinRuleta:=True;
        End;
    98: Begin
          If ((CheckCislo=3) or
              (CheckCislo=6)) then WinRuleta:=True;
        End;
    99: Begin
          If ((CheckCislo=6) or
              (CheckCislo=9)) then WinRuleta:=True;
        End;
   100: Begin
          If ((CheckCislo=9) or
              (CheckCislo=12)) then WinRuleta:=True;
        End;
   101: Begin
          If ((CheckCislo=12) or
              (CheckCislo=15)) then WinRuleta:=True;
        End;
   102: Begin
          If ((CheckCislo=15) or
              (CheckCislo=18)) then WinRuleta:=True;
        End;
   103: Begin
          If ((CheckCislo=18) or
              (CheckCislo=21)) then WinRuleta:=True;
        End;
   104: Begin
          If ((CheckCislo=21) or
              (CheckCislo=24)) then WinRuleta:=True;
        End;
   105: Begin
          If ((CheckCislo=24) or
              (CheckCislo=27)) then WinRuleta:=True;
        End;
   106: Begin
          If ((CheckCislo=27) or
              (CheckCislo=30)) then WinRuleta:=True;
        End;
   107: Begin
          If ((CheckCislo=30) or
              (CheckCislo=33)) then WinRuleta:=True;
        End;
   108: Begin
          If ((CheckCislo=33) or
              (CheckCislo=36)) then WinRuleta:=True;
        End;
   109: Begin
          If ((CheckCislo=3) or
              (CheckCislo=2)) then WinRuleta:=True;
        End;
   110: Begin
          If ((CheckCislo=6) or
              (CheckCislo=5)) then WinRuleta:=True;
        End;
   111: Begin
          If ((CheckCislo=9) or
              (CheckCislo=8)) then WinRuleta:=True;
        End;
   112: Begin
          If ((CheckCislo=12) or
              (CheckCislo=11)) then WinRuleta:=True;
        End;
   113: Begin
          If ((CheckCislo=15) or
              (CheckCislo=14)) then WinRuleta:=True;
        End;
   114: Begin
          If ((CheckCislo=18) or
              (CheckCislo=17)) then WinRuleta:=True;
        End;
   115: Begin
          If ((CheckCislo=21) or
              (CheckCislo=20)) then WinRuleta:=True;
        End;
   116: Begin
          If ((CheckCislo=24) or
              (CheckCislo=23)) then WinRuleta:=True;
        End;
   117: Begin
          If ((CheckCislo=27) or
              (CheckCislo=26)) then WinRuleta:=True;
        End;
   118: Begin
          If ((CheckCislo=30) or
              (CheckCislo=29)) then WinRuleta:=True;
        End;
   119: Begin
          If ((CheckCislo=33) or
              (CheckCislo=32)) then WinRuleta:=True;
        End;
   120: Begin
          If ((CheckCislo=36) or
              (CheckCislo=35)) then WinRuleta:=True;
        End;
   121: Begin
          If ((CheckCislo=2) or
              (CheckCislo=5)) then WinRuleta:=True;
        End;
   122: Begin
          If ((CheckCislo=5) or
              (CheckCislo=8)) then WinRuleta:=True;
        End;
   123: Begin
          If ((CheckCislo=8) or
              (CheckCislo=11)) then WinRuleta:=True;
        End;
   124: Begin
          If ((CheckCislo=11) or
              (CheckCislo=14)) then WinRuleta:=True;
        End;
   125: Begin
          If ((CheckCislo=14) or
              (CheckCislo=17)) then WinRuleta:=True;
        End;
   126: Begin
          If ((CheckCislo=17) or
              (CheckCislo=20)) then WinRuleta:=True;
        End;
   127: Begin
          If ((CheckCislo=20) or
              (CheckCislo=23)) then WinRuleta:=True;
        End;
   128: Begin
          If ((CheckCislo=23) or
              (CheckCislo=26)) then WinRuleta:=True;
        End;
   129: Begin
          If ((CheckCislo=26) or
              (CheckCislo=29)) then WinRuleta:=True;
        End;
   130: Begin
          If ((CheckCislo=29) or
              (CheckCislo=32)) then WinRuleta:=True;
        End;
   131: Begin
          If ((CheckCislo=32) or
              (CheckCislo=35)) then WinRuleta:=True;
        End;
   132: Begin
          If ((CheckCislo=2) or
              (CheckCislo=1)) then WinRuleta:=True;
        End;
   133: Begin
          If ((CheckCislo=5) or
              (CheckCislo=4)) then WinRuleta:=True;
        End;
   134: Begin
          If ((CheckCislo=8) or
              (CheckCislo=7)) then WinRuleta:=True;
        End;
   135: Begin
          If ((CheckCislo=11) or
              (CheckCislo=10)) then WinRuleta:=True;
        End;
   136: Begin
          If ((CheckCislo=14) or
              (CheckCislo=13)) then WinRuleta:=True;
        End;
   137: Begin
          If ((CheckCislo=17) or
              (CheckCislo=16)) then WinRuleta:=True;
        End;
   138: Begin
          If ((CheckCislo=20) or
              (CheckCislo=19)) then WinRuleta:=True;
        End;
   139: Begin
          If ((CheckCislo=23) or
              (CheckCislo=22)) then WinRuleta:=True;
        End;
   140: Begin
          If ((CheckCislo=26) or
              (CheckCislo=25)) then WinRuleta:=True;
        End;
   141: Begin
          If ((CheckCislo=29) or
              (CheckCislo=28)) then WinRuleta:=True;
        End;
   142: Begin
          If ((CheckCislo=32) or
              (CheckCislo=31)) then WinRuleta:=True;
        End;
   143: Begin
          If ((CheckCislo=35) or
              (CheckCislo=34)) then WinRuleta:=True;
        End;
   144: Begin
          If ((CheckCislo=1) or
              (CheckCislo=4)) then WinRuleta:=True;
        End;
   145: Begin
          If ((CheckCislo=4) or
              (CheckCislo=7)) then WinRuleta:=True;
        End;
   146: Begin
          If ((CheckCislo=7) or
              (CheckCislo=10)) then WinRuleta:=True;
        End;
   147: Begin
          If ((CheckCislo=10) or
              (CheckCislo=13)) then WinRuleta:=True;
        End;
   148: Begin
          If ((CheckCislo=13) or
              (CheckCislo=16)) then WinRuleta:=True;
        End;
   149: Begin
          If ((CheckCislo=16) or
              (CheckCislo=19)) then WinRuleta:=True;
        End;
   150: Begin
          If ((CheckCislo=19) or
              (CheckCislo=22)) then WinRuleta:=True;
        End;
   151: Begin
          If ((CheckCislo=22) or
              (CheckCislo=25)) then WinRuleta:=True;
        End;
   152: Begin
          If ((CheckCislo=25) or
              (CheckCislo=28)) then WinRuleta:=True;
        End;
   153: Begin
          If ((CheckCislo=28) or
              (CheckCislo=31)) then WinRuleta:=True;
        End;
   154: Begin
          If ((CheckCislo=31) or
              (CheckCislo=34)) then WinRuleta:=True;
        End;
   155: Begin
          If ((CheckCislo=99) or
              (CheckCislo=3)) then WinRuleta:=True;
        End;
   156: Begin
          If ((CheckCislo=99) or
              (CheckCislo=0)) then WinRuleta:=True;
        End;
   157: Begin
          If ((CheckCislo=0) or
              (CheckCislo=1)) then WinRuleta:=True;
        End;
  End; {Case End}

  If WinRuleta=True then
  Begin
    Wait(1000);
    For I:=0 to 39 do
    Begin
      If SazPole[GetBlik(CheckCislo)].Vsazeno=True
      then SazPole[GetBlik(CheckCislo)].Vsazeno:=False
      else SazPole[GetBlik(CheckCislo)].Vsazeno:=True;
      StopPlay;
      PlaySound(8);
      Wait(70);
      WriteAutomatScreen4;
    End;

    Wait(1000);

    For I:=0 to Kurz-1 do
    Begin
      Inc(Score4,Sazka4);
      StopPlay;
      PlaySound(4);
      Wait(100);
      WriteAutomatScreen4;
    End;

  End;

End;