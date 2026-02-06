Procedure EnemyTyp1Step(I:Byte);
Begin
  Case Enemy[I].Smer of
 1: Begin {doprava}
          If Enemy[I].X<1247 then
          Begin
            If ((KostkaPozadi(Enemy[I].X+11+2,Enemy[I].Y+23)=1) and
                (KostkaPozadi(Enemy[I].X+11+2,Enemy[I].Y)=1))
            then Inc(Enemy[I].X,2)
            else Begin
                   If ((KostkaPozadi(Enemy[I].X+11+1,Enemy[I].Y+23)=1) and
                       (KostkaPozadi(Enemy[I].X+11+1,Enemy[I].Y)=1))
                   then Inc(Enemy[I].X,1);
                 End;
          End;
    End;
 2: Begin {doleva}
          If Enemy[I].X>16 then
          Begin
            If ((KostkaPozadi(Enemy[I].X+5-2,Enemy[I].Y+23)=1) and
                (KostkaPozadi(Enemy[I].X+5-2,Enemy[I].Y)=1))
            then Dec(Enemy[I].X,2)
            else Begin
                   If ((KostkaPozadi(Enemy[I].X+5-1,Enemy[I].Y+23)=1) and
                       (KostkaPozadi(Enemy[I].X+5-1,Enemy[I].Y)=1))
                   then Dec(Enemy[I].X);
                 End;
          End;
    End;
  End; {Case End}
End;


Procedure EnemyTyp1Frame(I:Byte);
Begin
  Case Enemy[I].Smer of
    1: Begin {doprava}
         If Enemy[I].KrokCounter<7 then Inc(Enemy[I].KrokCounter)
                                   else Enemy[I].KrokCounter:=0;
         Case Enemy[I].KrokCounter of
           0: Enemy[I].Sprite:=2;
           1: Enemy[I].Sprite:=2;
           2: Enemy[I].Sprite:=2;
           3: Enemy[I].Sprite:=1;
           4: Enemy[I].Sprite:=3;
           5: Enemy[I].Sprite:=3;
           6: Enemy[I].Sprite:=3;
           7: Enemy[I].Sprite:=1;
         End; {Case End}
       End;
    2: Begin {doleva}
         If Enemy[I].KrokCounter<7 then Inc(Enemy[I].KrokCounter)
                                   else Enemy[I].KrokCounter:=0;
         Case Enemy[I].KrokCounter of
           0: Enemy[I].Sprite:=5;
           1: Enemy[I].Sprite:=5;
           2: Enemy[I].Sprite:=5;
           3: Enemy[I].Sprite:=4;
           4: Enemy[I].Sprite:=6;
           5: Enemy[I].Sprite:=6;
           6: Enemy[I].Sprite:=6;
           7: Enemy[I].Sprite:=4;
         End; {Case End}
       End;
  End; {Case End}
End;


Procedure EnemyTyp3Step(I:Byte);
Begin
  Case Enemy[I].Smer of
 1: Begin {doprava}
          If Enemy[I].X<1248 then
          Begin
            If ((KostkaPozadi(Enemy[I].X+15+1,Enemy[I].Y+15)=1) and
                (KostkaPozadi(Enemy[I].X+15+1,Enemy[I].Y)=1))
            then Inc(Enemy[I].X);
          End;
    End;
 2: Begin {doleva}
          If Enemy[I].X>16 then
          Begin
            If ((KostkaPozadi(Enemy[I].X-1,Enemy[I].Y+15)=1) and
                (KostkaPozadi(Enemy[I].X-1,Enemy[I].Y)=1))
            then Dec(Enemy[I].X);
          End;
    End;
  End; {Case End}
End;


Procedure EnemyTyp3Frame(I:Byte);
Begin
  Case Enemy[I].Smer of
    1: Begin {doprava}
         If Enemy[I].KrokCounter<7 then Inc(Enemy[I].KrokCounter)
                                   else Enemy[I].KrokCounter:=0;
         Case Enemy[I].KrokCounter of
           0: Enemy[I].Sprite:=1;
           1: Enemy[I].Sprite:=1;
           2: Enemy[I].Sprite:=2;
           3: Enemy[I].Sprite:=2;
           4: Enemy[I].Sprite:=3;
           5: Enemy[I].Sprite:=3;
           6: Enemy[I].Sprite:=4;
           7: Enemy[I].Sprite:=4;
         End; {Case End}
       End;
    2: Begin {doleva}
         If Enemy[I].KrokCounter<7 then Inc(Enemy[I].KrokCounter)
                                   else Enemy[I].KrokCounter:=0;
         Case Enemy[I].KrokCounter of
           0: Enemy[I].Sprite:=4;
           1: Enemy[I].Sprite:=4;
           2: Enemy[I].Sprite:=3;
           3: Enemy[I].Sprite:=3;
           4: Enemy[I].Sprite:=2;
           5: Enemy[I].Sprite:=2;
           6: Enemy[I].Sprite:=1;
           7: Enemy[I].Sprite:=1;
         End; {Case End}
       End;
  End; {Case End}
End;

Procedure EnemyTyp6Step(I:Byte);
Begin
  If ((Enemy[I].MoveCounter>0) and (Enemy[I].MoveCounter<=24)) then
  Begin
    If Enemy[I].X<1263 then Inc(Enemy[I].X,2);
    If Enemy[I].Y>1 then Dec(Enemy[I].Y,2);
  End;
  If ((Enemy[I].MoveCounter>24) and (Enemy[I].MoveCounter<=64)) then
  Begin
    If Enemy[I].X<1263 then Inc(Enemy[I].X,2);
  End;
  If ((Enemy[I].MoveCounter>64) and (Enemy[I].MoveCounter<=88)) then
  Begin
    If Enemy[I].X<1263 then Inc(Enemy[I].X,2);
    If Enemy[I].Y<1135 then Inc(Enemy[I].Y,2);
  End;
  If ((Enemy[I].MoveCounter>88) and (Enemy[I].MoveCounter<=96)) then
  Begin
    If Enemy[I].Y<1135 then Inc(Enemy[I].Y,2);
  End;
  If ((Enemy[I].MoveCounter>96) and (Enemy[I].MoveCounter<=120)) then
  Begin
    If Enemy[I].X>1 then Dec(Enemy[I].X,2);
    If Enemy[I].Y<1135 then Inc(Enemy[I].Y,2);
  End;
  If ((Enemy[I].MoveCounter>120) and (Enemy[I].MoveCounter<=160)) then
  Begin
    If Enemy[I].X>1 then Dec(Enemy[I].X,2);
  End;
  If ((Enemy[I].MoveCounter>160) and (Enemy[I].MoveCounter<=184)) then
  Begin
    If Enemy[I].X>1 then Dec(Enemy[I].X,2);
    If Enemy[I].Y>1 then Dec(Enemy[I].Y,2);
  End;
  If ((Enemy[I].MoveCounter>184) and (Enemy[I].MoveCounter<=192)) then
  Begin
    If Enemy[I].Y>1 then Dec(Enemy[I].Y,2);
  End;
  If Enemy[I].MoveCounter<192 then Inc(Enemy[I].MoveCounter)
                              else Enemy[I].MoveCounter:=0;
  If Enemy[I].MoveCounter=92 then Enemy[I].Smer:=2;
  If Enemy[I].MoveCounter=188 then Enemy[I].Smer:=1;
End;


Procedure EnemyTyp6Frame(I:Byte);
Begin
  Case Enemy[I].Smer of
   1: Begin {doprava}
         If Enemy[I].KrokCounter<5 then Inc(Enemy[I].KrokCounter)
                                   else Enemy[I].KrokCounter:=0;
         Case Enemy[I].KrokCounter of
           0: Enemy[I].Sprite:=3;
           1: Enemy[I].Sprite:=3;
           2: Enemy[I].Sprite:=3;
           3: Enemy[I].Sprite:=4;
           4: Enemy[I].Sprite:=4;
           5: Enemy[I].Sprite:=4;
         End; {Case End}
      End;
   2: Begin {doleva}
         If Enemy[I].KrokCounter<5 then Inc(Enemy[I].KrokCounter)
                                   else Enemy[I].KrokCounter:=0;
         Case Enemy[I].KrokCounter of
           0: Enemy[I].Sprite:=1;
           1: Enemy[I].Sprite:=1;
           2: Enemy[I].Sprite:=1;
           3: Enemy[I].Sprite:=2;
           4: Enemy[I].Sprite:=2;
           5: Enemy[I].Sprite:=2;
         End; {Case End}
      End;
  End; {Case End}
End;


Procedure EnemyTyp1Moves(I:Byte);
Begin
  Case Enemy[I].Smer of
    1: Begin {doprava}
         If ((GetPole(Enemy[I].X+12,Enemy[I].Y+24)=0) or
             (GetPole(Enemy[I].X+12,Enemy[I].Y+20)>=128)) then
         Begin
           Enemy[I].Smer:=2;
         End;
       End;
    2: Begin {doleva}
         If ((GetPole(Enemy[I].X+4,Enemy[I].Y+24)=0) or
             (GetPole(Enemy[I].X+4,Enemy[I].Y+20)>=128)) then
         Begin
           Enemy[I].Smer:=1;
         End;
       End;
  End; {Case End}
End;


Procedure EnemyTyp2Moves(I:Byte);
Begin
  Case Enemy[I].Smer of
    1: Begin {doprava}
         If ((GetPole(Enemy[I].X+12,Enemy[I].Y+24)=0) or
             (GetPole(Enemy[I].X+12,Enemy[I].Y+20)>=128)) then
         Begin
           Enemy[I].Smer:=2;
           Enemy[I].MoveCounter:=Enemy[I].MoveCounterMax;
         End;
       End;
    2: Begin {doleva}
         If ((GetPole(Enemy[I].X+4,Enemy[I].Y+24)=0) or
             (GetPole(Enemy[I].X+4,Enemy[I].Y+20)>=128)) then
         Begin
           Enemy[I].Smer:=1;
           Enemy[I].MoveCounter:=Enemy[I].MoveCounterMax;
         End;
       End;
  End; {Case End}
  If Enemy[I].MoveCounter>0 then Dec(Enemy[I].MoveCounter)
                            else Begin
                                   Enemy[I].MoveCounter:=Enemy[I].MoveCounterMax;
                                   Case Enemy[I].Smer of
                                     1: Enemy[I].Smer:=2;
                                     2: Enemy[I].Smer:=1;
                                   End; {Case End}
                                 End;
End;


Procedure EnemyTyp3Moves(I:Byte);
Begin
  Case Enemy[I].Smer of
    1: Begin {doprava}
         If ((GetPole(Enemy[I].X+16,Enemy[I].Y+16)=0) or
             (GetPole(Enemy[I].X+16,Enemy[I].Y+10)>=128)) then
         Begin
           Enemy[I].Smer:=2;
         End;
       End;
    2: Begin {doleva}
         If ((GetPole(Enemy[I].X-1,Enemy[I].Y+16)=0) or
             (GetPole(Enemy[I].X-1,Enemy[I].Y+10)>=128)) then
         Begin
           Enemy[I].Smer:=1;
         End;
       End;
  End; {Case End}
End;


Procedure EnemyTyp4Moves(I: Byte);
Begin
  Case Enemy[I].Smer of
    1: Begin {doprava}
         If ((GetPole(Enemy[I].X+16,Enemy[I].Y+16)=0) or
             (GetPole(Enemy[I].X+16,Enemy[I].Y+10)>=128)) then
         Begin
           Enemy[I].Smer:=2;
           Enemy[I].MoveCounter:=Enemy[I].MoveCounterMax;
         End;
       End;
    2: Begin {doleva}
         If ((GetPole(Enemy[I].X-1,Enemy[I].Y+16)=0) or
             (GetPole(Enemy[I].X-1,Enemy[I].Y+10)>=128)) then
         Begin
           Enemy[I].Smer:=1;
           Enemy[I].MoveCounter:=Enemy[I].MoveCounterMax;
         End;
       End;
  End; {Case End}
  If Enemy[I].MoveCounter>0 then Dec(Enemy[I].MoveCounter)
                            else Begin
                                   Enemy[I].MoveCounter:=Enemy[I].MoveCounterMax;
                                   Case Enemy[I].Smer of
                                     1: Enemy[I].Smer:=2;
                                     2: Enemy[I].Smer:=1;
                                   End; {Case End}
                                 End;
End;


Procedure MinaBoom(I:Byte);
Begin
  If ((Player.Death=True) and (Enemy[I].ExpCounter>0)) then
  Begin
    If ((Enemy[I].ExpCounter>5) and (Enemy[I].ExpCounter<=8))
    then Enemy[I].Sprite:=2;
    If ((Enemy[I].ExpCounter>1) and (Enemy[I].ExpCounter<=5))
    then Enemy[I].Sprite:=3;
    If Enemy[I].ExpCounter>1 then Dec(Enemy[I].ExpCounter)
                             else Enemy[I].Sprite:=0;
  End;
End;


Procedure EnemyTestWin(I:Byte);
Var Death: Boolean;
Begin
  Death:=False;
  If Enemy[I].Death=False then
  Case Enemy[I].Typ of
    1: Begin
         If ((Inside(Player.X+5,Player.Y,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True) or
             (Inside(Player.X+5,Player.Y+23,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True) or
             (Inside(Player.X+10,Player.Y,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True) or
             (Inside(Player.X+10,Player.Y+23,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True) or
             (Inside(Player.X+8,Player.Y+5,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True))
         then Death:=True;
       End;
    2: Begin
         If ((Inside(Player.X+5,Player.Y,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True) or
             (Inside(Player.X+5,Player.Y+23,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True) or
             (Inside(Player.X+10,Player.Y,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True) or
             (Inside(Player.X+10,Player.Y+23,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True) or
             (Inside(Player.X+8,Player.Y+5,Enemy[I].X+5,Enemy[I].Y,Enemy[I].X+10,Enemy[I].Y+23)=True))
         then Death:=True;
       End;
    3: Begin
         If ((Inside(Player.X+5,Player.Y,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True) or
             (Inside(Player.X+5,Player.Y+23,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True) or
             (Inside(Player.X+10,Player.Y,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True) or
             (Inside(Player.X+10,Player.Y+23,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True) or
             (Inside(Player.X+8,Player.Y+5,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True))
         then Death:=True;
       End;
    4: Begin
         If ((Inside(Player.X+5,Player.Y,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True) or
             (Inside(Player.X+5,Player.Y+23,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True) or
             (Inside(Player.X+10,Player.Y,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True) or
             (Inside(Player.X+10,Player.Y+23,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True) or
             (Inside(Player.X+8,Player.Y+5,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True))
         then Death:=True;
       End;
    5: Begin
         If ((Inside(Player.X+5,Player.Y+15,Enemy[I].X+4,Enemy[I].Y+6,Enemy[I].X+11,Enemy[I].Y+7)=True) or
             (Inside(Player.X+10,Player.Y+15,Enemy[I].X+4,Enemy[I].Y+6,Enemy[I].X+11,Enemy[I].Y+7)=True))
         then Death:=True;
       End;
    6: Begin
         If Player.Skrceny=False then
         Begin
           If ((Inside(Player.X+5,Player.Y,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True) or
               (Inside(Player.X+5,Player.Y+23,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True) or
               (Inside(Player.X+10,Player.Y,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True) or
               (Inside(Player.X+10,Player.Y+23,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True) or
               (Inside(Player.X+8,Player.Y+5,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True))
           then Death:=True;
         End else
         Begin
           If ((Inside(Player.X+5,Player.Y+8,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True) or
               (Inside(Player.X+5,Player.Y+23,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True) or
               (Inside(Player.X+10,Player.Y+8,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True) or
               (Inside(Player.X+10,Player.Y+23,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True) or
               (Inside(Player.X+8,Player.Y+5,Enemy[I].X,Enemy[I].Y+3,Enemy[I].X+15,Enemy[I].Y+12)=True))
           then Death:=True;
         End;
       End;
  End; {Case End}
  If ((Death=True) and (Player.Death=False)) then
  Begin
    Player.Death:=True;
    Player.DeathCounter:=0;
    Player.Sprite:=25;
    Player.Power1:=0;
    Player.Power2:=0;
    Player.Power3:=0;
    Player.Power4:=0;
    Player.Skrceny:=False;
    PlaySound(7);
    If Enemy[I].Typ=5 then
    Begin
      PlaySound(8);
      Enemy[I].ExpCounter:=8;
    End;
  End;
End;


Procedure EnemyTestHit(X,Y:LongInt;I:Byte);
Var Death: Boolean;
Begin
  Death:=False;
  If ((Enemy[I].Aktive=True) and (Enemy[I].Terminated=False)) then
  Case Enemy[I].Typ of
    1: If Inside(X,Y,Enemy[I].X+4,Enemy[I].Y,Enemy[I].X+11,Enemy[I].Y+23)=True then Death:=True;
    2: If Inside(X,Y,Enemy[I].X+4,Enemy[I].Y,Enemy[I].X+11,Enemy[I].Y+23)=True then Death:=True;
    3: If Inside(X,Y,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True then Death:=True;
    4: If Inside(X,Y,Enemy[I].X,Enemy[I].Y+8,Enemy[I].X+15,Enemy[I].Y+15)=True then Death:=True;
    6: If Inside(X,Y,Enemy[I].X,Enemy[I].Y,Enemy[I].X+15,Enemy[I].Y+11)=True then Death:=True;
  End; {Case End}
  If Death=True then
  Begin
    PlaySound(2);
    Enemy[I].Death:=True;
    Enemy[I].DeathCounter:=0;
    Enemy[I].Smer:=Player.Smer;
    If Strela.Leti=True then
    Begin
      Strela.Leti:=False;
      Strela.Akce:=False;
    End;
    Case Enemy[I].Typ of
      1: Begin
           Case Player.Smer of
             1: Enemy[I].Sprite:=7;
             2: Enemy[I].Sprite:=8;
           End; {Case End}
           Inc(Enemy[I].Y,5);
         End;
      2: Begin
           Case Player.Smer of
             1: Enemy[I].Sprite:=7;
             2: Enemy[I].Sprite:=8;
           End; {Case End}
           Inc(Enemy[I].Y,5);
         End;
      6: Begin
           Enemy[I].Sprite:=5;
         End;
    End; {Case End}
  End;
End;


Procedure EnemyDie;
Var I: Byte;
Begin
  For I:=0 to 255 do
  Begin
    If Enemy[I].Death=True then
    Begin
      If ((Enemy[I].DeathCounter>0) and (Enemy[I].DeathCounter<=5))
      then Begin
             Case Enemy[I].Smer of
               1: If Enemy[I].X<1250 then Inc(Enemy[I].X,2);
               2: If Enemy[I].X>1 then Dec(Enemy[I].X,2);
             End; {Case End}
             If Enemy[I].Y>0 then Dec(Enemy[I].Y);
           End;
      If ((Enemy[I].DeathCounter>5) and (Enemy[I].DeathCounter<=10))
      then Begin
             Case Enemy[I].Smer of
               1: If Enemy[I].X<1250 then Inc(Enemy[I].X,2);
               2: If Enemy[I].X>1 then Dec(Enemy[I].X,2);
             End; {Case End}
           End;
      If ((Enemy[I].DeathCounter>10) and (Enemy[I].DeathCounter<=15))
      then Begin
             Case Enemy[I].Smer of
               1: If Enemy[I].X<1250 then Inc(Enemy[I].X,2);
               2: If Enemy[I].X>1 then Dec(Enemy[I].X,2);
             End; {Case End}
             If Enemy[I].Y<1120 then Inc(Enemy[I].Y);
           End;
      If ((Enemy[I].DeathCounter>15) and (Enemy[I].DeathCounter<=50))
      then Begin
             If Enemy[I].Y<1120 then Inc(Enemy[I].Y,5);
           End;
      If Enemy[I].DeathCounter<50 then Inc(Enemy[I].DeathCounter)
                                  else Enemy[I].Terminated:=True;
    End;
  End;
End;


Procedure EnemyAktive;
Var I: Byte;
    X1,Y1,X2,Y2: LongInt;
Begin
  For I:=0 to 255 do
  Begin
    If Map.Xview<160 then X1:=0 else X1:=Map.Xview-160;
    If Map.Xview>1120 then X2:=1279 else X2:=Map.Xview+320+160;
    If Map.Yview<80 then Y1:=0 else Y1:=Map.Yview-80;
    If Map.Yview>1072 then Y2:=1151 else Y2:=Map.Yview+200+80;
    If Inside(Enemy[I].X,Enemy[I].Y,X1,Y1,X2,Y2)=True
    then Enemy[I].Aktive:=True
    else Enemy[I].Aktive:=False;
  End;
End;


Procedure EnemyLogics;
Var I: Byte;
Begin
  For I:=0 to 255 do
  Begin
    If ((Enemy[I].Death=False) and (Enemy[I].Aktive=True)) then
    Begin
      Case Enemy[I].Typ of
        1: Begin
             EnemyTyp1Step(I);
             EnemyTyp1Frame(I);
             EnemyTyp1Moves(I);
           End;
        2: Begin
             EnemyTyp1Step(I);
             EnemyTyp1Frame(I);
             EnemyTyp2Moves(I);
           End;
        3: Begin
             EnemyTyp3Step(I);
             EnemyTyp3Frame(I);
             EnemyTyp3Moves(I);
           End;
        4: Begin
             EnemyTyp3Step(I);
             EnemyTyp3Frame(I);
             EnemyTyp4Moves(I);
           End;
        5: Begin
             MinaBoom(I);
           End;
        6: Begin
             EnemyTyp6Step(I);
             EnemyTyp6Frame(I);
           End;
      End; {Case End}
      EnemyTestWin(I);
    End;
  End;
End;
