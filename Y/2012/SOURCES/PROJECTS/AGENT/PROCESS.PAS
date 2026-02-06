Procedure PlayerStep;
Begin
{L} If ((Key[38]=False) and (Player.Power1>0)) then Dec(Player.Power1);
{J} If ((Key[36]=False) and (Player.Power2>0)) then Dec(Player.Power2);

  Case Player.Smer of
 1: Begin {doprava}
        If ((Player.Power1>0) and (Player.Power1<=8)) then
        Begin
          If Player.X<1248 then
          Begin
            If ((KostkaPozadi(Player.X+11+1,Player.Y+23)=1) and
                (KostkaPozadi(Player.X+11+1,Player.Y)=1))
            then Inc(Player.X);
          End;
        End;
        If ((Player.Power1>8) and (Player.Power1<=15)) then
        Begin
          If Player.X<1247 then
          Begin
            If ((KostkaPozadi(Player.X+11+2,Player.Y+23)=1) and
                (KostkaPozadi(Player.X+11+2,Player.Y)=1))
            then Inc(Player.X,2)
            else Begin
                   If ((KostkaPozadi(Player.X+11+1,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+11+1,Player.Y)=1))
                   then Inc(Player.X,1);
                 End;
          End;
        End;
        If ((Player.Power1>16) and (Player.Power1<=24)) then
        Begin
          If Player.X<1246 then
          Begin
            If ((KostkaPozadi(Player.X+11+3,Player.Y+23)=1) and
               (KostkaPozadi(Player.X+11+3,Player.Y)=1))
            then Inc(Player.X,3)
            else Begin
                   If ((KostkaPozadi(Player.X+11+2,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+11+2,Player.Y)=1))
                   then Inc(Player.X,2);
                   If ((KostkaPozadi(Player.X+11+1,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+11+1,Player.Y)=1))
                   then Inc(Player.X);
                 End;
          End;
        End;
        If Player.Power1=25 then
        Begin
          If Player.X<1245 then
          Begin
            If ((KostkaPozadi(Player.X+11+4,Player.Y+23)=1) and
               (KostkaPozadi(Player.X+11+4,Player.Y)=1))
            then Inc(Player.X,4)
            else Begin
                   If ((KostkaPozadi(Player.X+11+3,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+11+3,Player.Y)=1))
                       then Inc(Player.X,3);
                   If ((KostkaPozadi(Player.X+11+2,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+11+2,Player.Y)=1))
                       then Inc(Player.X,2);
                   If ((KostkaPozadi(Player.X+11+1,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+11+1,Player.Y)=1))
                       then Inc(Player.X);
                 End;
          End;
        End;
    End;
 2: Begin {doleva}
        If ((Player.Power2>0) and (Player.Power2<=8)) then
        Begin
          If Player.X>15 then
          Begin
            If ((KostkaPozadi(Player.X+5-1,Player.Y+23)=1) and
                (KostkaPozadi(Player.X+5-1,Player.Y)=1))
            then Dec(Player.X);
          End;
        End;
        If ((Player.Power2>8) and (Player.Power2<=16)) then
        Begin
          If Player.X>16 then
          Begin
            If ((KostkaPozadi(Player.X+5-2,Player.Y+23)=1) and
                (KostkaPozadi(Player.X+5-2,Player.Y)=1))
            then Dec(Player.X,2)
            else Begin
                   If ((KostkaPozadi(Player.X+5-1,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+5-1,Player.Y)=1))
                   then Dec(Player.X);
                 End;
          End;
        End;
        If ((Player.Power2>16) and (Player.Power2<=24)) then
        Begin
          If Player.X>17 then
          Begin
            If ((KostkaPozadi(Player.X+5-3,Player.Y+23)=1) and
                (KostkaPozadi(Player.X+5-3,Player.Y)=1))
            then Dec(Player.X,3)
            else Begin
                   If ((KostkaPozadi(Player.X+5-2,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+5-2,Player.Y)=1))
                   then Dec(Player.X,2);
                   If ((KostkaPozadi(Player.X+5-1,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+5-1,Player.Y)=1))
                   then Dec(Player.X);
                 End;
          End;
        End;
        If Player.Power2=25 then
        Begin
          If Player.X>18 then
          Begin
            If ((KostkaPozadi(Player.X+5-4,Player.Y+23)=1) and
                (KostkaPozadi(Player.X+5-4,Player.Y)=1))
            then Dec(Player.X,4)
            else Begin
                   If ((KostkaPozadi(Player.X+5-3,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+5-3,Player.Y)=1))
                   then Dec(Player.X,3);
                   If ((KostkaPozadi(Player.X+5-2,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+5-2,Player.Y)=1))
                   then Dec(Player.X,2);
                   If ((KostkaPozadi(Player.X+5-1,Player.Y+23)=1) and
                       (KostkaPozadi(Player.X+5-1,Player.Y)=1))
                   then Dec(Player.X);
                 End;
          End;
        End;
    End;
  End; {Case End}
End;


Procedure PlayerFrame;
Begin
  Case Player.Smer of
    1: Begin {doprava}
         If Player.Power1=0 then Player.Sprite:=1;
         If ((Player.Power1>0) and (Player.Power1<=8)) then
         Begin
           If Player.KrokCounter<7 then Inc(Player.KrokCounter)
                                   else Player.KrokCounter:=0;
           Case Player.KrokCounter of
             0: Player.Sprite:=2;
             1: Player.Sprite:=2;
             2: Player.Sprite:=2;
             3: Player.Sprite:=1;
             4: Player.Sprite:=3;
             5: Player.Sprite:=3;
             6: Player.Sprite:=3;
             7: Player.Sprite:=1;
           End; {Case End}
         End;
         If ((Player.Power1>8) and (Player.Power1<=16)) then
         Begin
           If Player.KrokCounter<7 then Inc(Player.KrokCounter)
                                   else Player.KrokCounter:=0;
           Case Player.KrokCounter of
             0: Player.Sprite:=2;
             1: Player.Sprite:=2;
             2: Player.Sprite:=1;
             3: Player.Sprite:=1;
             4: Player.Sprite:=3;
             5: Player.Sprite:=3;
             6: Player.Sprite:=1;
             7: Player.Sprite:=1;
           End; {Case End}
         End;
         If ((Player.Power1>16) and (Player.Power1<=24)) then
         Begin
           If Player.KrokCounter<3 then Inc(Player.KrokCounter)
                                   else Player.KrokCounter:=0;
           Case Player.KrokCounter of
             0: Player.Sprite:=2;
             1: Player.Sprite:=1;
             2: Player.Sprite:=3;
             3: Player.Sprite:=1;
           End; {Case End}
         End;
         If Player.Power1=25 then
         Begin
           If Player.KrokCounter<3 then Inc(Player.KrokCounter)
                                   else Player.KrokCounter:=0;
           Case Player.KrokCounter of
             0: Player.Sprite:=1;
             1: Player.Sprite:=2;
             2: Player.Sprite:=1;
             3: Player.Sprite:=3;
           End; {Case End}
         End;
       End;
    2: Begin {doleva}
         If Player.Power2=0 then Player.Sprite:=4;
         If ((Player.Power2>0) and (Player.Power2<=8)) then
         Begin
           If Player.KrokCounter<7 then Inc(Player.KrokCounter)
                                   else Player.KrokCounter:=0;
           Case Player.KrokCounter of
             0: Player.Sprite:=5;
             1: Player.Sprite:=5;
             2: Player.Sprite:=5;
             3: Player.Sprite:=4;
             4: Player.Sprite:=6;
             5: Player.Sprite:=6;
             6: Player.Sprite:=6;
             7: Player.Sprite:=4;
           End; {Case End}
         End;
         If ((Player.Power2>8) and (Player.Power2<=16)) then
         Begin
           If Player.KrokCounter<7 then Inc(Player.KrokCounter)
                                   else Player.KrokCounter:=0;
           Case Player.KrokCounter of
             0: Player.Sprite:=5;
             1: Player.Sprite:=5;
             2: Player.Sprite:=4;
             3: Player.Sprite:=4;
             4: Player.Sprite:=6;
             5: Player.Sprite:=6;
             6: Player.Sprite:=4;
             7: Player.Sprite:=4;
           End; {Case End}
         End;
         If ((Player.Power2>16) and (Player.Power2<=24)) then
         Begin
           If Player.KrokCounter<3 then Inc(Player.KrokCounter)
                                   else Player.KrokCounter:=0;
           Case Player.KrokCounter of
             0: Player.Sprite:=5;
             1: Player.Sprite:=4;
             2: Player.Sprite:=6;
             3: Player.Sprite:=4;
           End; {Case End}
         End;
         If Player.Power2=25 then
         Begin
           If Player.KrokCounter<3 then Inc(Player.KrokCounter)
                                   else Player.KrokCounter:=0;
           Case Player.KrokCounter of
             0: Player.Sprite:=4;
             1: Player.Sprite:=5;
             2: Player.Sprite:=4;
             3: Player.Sprite:=6;
           End; {Case End}
         End;
       End;
  End; {Case End}
  If Player.Death=True then Player.Sprite:=25;
End;


Procedure PlayerRebrik;
Begin
  Player.Rebrik:=False;

  If ((GetPole(Player.X+8,Player.Y+8)=16) or
      (GetPole(Player.X+8,Player.Y+23)=16))
  then Player.Rebrik:=True;

  If ((Player.Rebrik=True) and ((Key[23]=True) or (Key[37]=True))) then
  Begin
    Player.X:=((Player.X+8) div 16)*16;
    If Player.RebrikCounter<4 then Inc(Player.RebrikCounter)
                              else Player.RebrikCounter:=1;
    Case Player.RebrikCounter of
      1: Player.Sprite:=7;
      2: Player.Sprite:=7;
      3: Player.Sprite:=8;
      4: Player.Sprite:=8;
    End; {Case End}
  End;
End;


Procedure PlayerPodlozka;
Begin
  If ((KostkaPozadi(Player.X+6,Player.Y+24)=1) and
      (KostkaPozadi(Player.X+10,Player.Y+24)=1))
  then Player.InAir:=True;
  If ((GetPole(Player.X+6,Player.Y+24)>=128) and
      (GetPole(Player.X+10,Player.Y+24)>=128))
  then Player.InAir:=False;
  If (((GetPole(Player.X+6,Player.Y+24)=16) and
       (GetPole(Player.X+10,Player.Y+24)=16)) or
       ((GetPole(Player.X+6,Player.Y+25)=16) and
       (GetPole(Player.X+10,Player.Y+25)=16)))
  then Player.InAir:=False;
End;


Procedure PlayerGravity;
Begin
  If Player.InAir=True
  then Begin
         If Player.Power3<13 then Inc(Player.Power3);
       End
  else Begin
         Player.Power3:=0;
       End;

  If ((Player.Power3>0) and (Player.Power3<=4)) then
  Begin
    If Player.Y<1136 then
    Begin
      If ((KostkaPozadi(Player.X+5,Player.Y+24)=1) and
          (KostkaPozadi(Player.X+11,Player.Y+24)=1))
      then Inc(Player.Y);
    End;
  End;
  If ((Player.Power3>4) and (Player.Power3<=8)) then
  Begin
    If Player.Y<1135 then
    Begin
      If ((KostkaPozadi(Player.X+5,Player.Y+25)=1) and
          (KostkaPozadi(Player.X+11,Player.Y+25)=1))
      then Begin
             Inc(Player.Y,2);
           End
      else Begin
             If ((KostkaPozadi(Player.X+5,Player.Y+24)=1) and
                (KostkaPozadi(Player.X+11,Player.Y+24)=1))
                then Inc(Player.Y);
           End;
    End;
  End;
  If ((Player.Power3>8) and (Player.Power3<=12)) then
  Begin
    If Player.Y<1134 then
    Begin
      If ((KostkaPozadi(Player.X+5,Player.Y+26)=1) and
          (KostkaPozadi(Player.X+11,Player.Y+26)=1))
      then Begin
             Inc(Player.Y,3);
           End
      else Begin
             If ((KostkaPozadi(Player.X+5,Player.Y+25)=1) and
                (KostkaPozadi(Player.X+11,Player.Y+25)=1))
                then Inc(Player.Y,2);
             If ((KostkaPozadi(Player.X+5,Player.Y+24)=1) and
                (KostkaPozadi(Player.X+11,Player.Y+24)=1))
                then Inc(Player.Y);
           End;
    End;
  End;
  If Player.Power3=13 then
  Begin
    If Player.Y<1133 then
    Begin
      If ((KostkaPozadi(Player.X+5,Player.Y+27)=1) and
          (KostkaPozadi(Player.X+11,Player.Y+27)=1))
      then Begin
             Inc(Player.Y,4);
           End
      else Begin
             If ((KostkaPozadi(Player.X+5,Player.Y+26)=1) and
                (KostkaPozadi(Player.X+11,Player.Y+26)=1))
                then Inc(Player.Y,3);
             If ((KostkaPozadi(Player.X+5,Player.Y+25)=1) and
                (KostkaPozadi(Player.X+11,Player.Y+25)=1))
                then Inc(Player.Y,2);
             If ((KostkaPozadi(Player.X+5,Player.Y+24)=1) and
                (KostkaPozadi(Player.X+11,Player.Y+24)=1))
                then Inc(Player.Y);
           End;
    End;
  End;
End;


Procedure PlayerJump;
Begin
  If ((KostkaPozadi(Player.X+5,Player.Y-5)=1) and
      (KostkaPozadi(Player.X+11,Player.Y-5)=1))
  then Dec(Player.Y,5)
  else Begin
         If ((KostkaPozadi(Player.X+5,Player.Y-4)=1) and
             (KostkaPozadi(Player.X+11,Player.Y-4)=1))
         then Dec(Player.Y,4);
         If ((KostkaPozadi(Player.X+5,Player.Y-3)=1) and
             (KostkaPozadi(Player.X+11,Player.Y-3)=1))
         then Dec(Player.Y,3);
         If ((KostkaPozadi(Player.X+5,Player.Y-2)=1) and
             (KostkaPozadi(Player.X+11,Player.Y-2)=1))
         then Dec(Player.Y,2);
         If ((KostkaPozadi(Player.X+5,Player.Y-1)=1) and
             (KostkaPozadi(Player.X+11,Player.Y-1)=1))
         then Dec(Player.Y,1);
       End;
  If Key[30]=False then Begin
                          Player.Jump:=False;
                          Player.Power4:=0;
End;                    End;


Procedure Scrolling;
Var posunX,posunY: Byte;
Begin
  If Player.X>Player.SaveX then
  Begin
    posunX:=Player.X-Player.SaveX;
    If ((Map.XView<944-posunX) and (Player.X>152))
    then Inc(Map.XView,posunX);
  End;
  If Player.X<Player.SaveX then
  Begin
    posunX:=Player.SaveX-Player.X;
    If ((Map.XView>15+posunX) and (Player.X<1112))
    then Dec(Map.XView,posunX);
  End;
  If Player.Y>Player.SaveY then
  Begin
    posunY:=Player.Y-Player.SaveY;
    If ((Map.YView<920-posunY) and (Player.Y>88))
    then Inc(Map.YView,posunY);
  End;
  If Player.Y<Player.SaveY then
  Begin
    posunY:=Player.SaveY-Player.Y;
    If ((Map.YView>15+posunY) and (Player.Y<1040))
    then Dec(Map.YView,posunY);
  End;
End;


Procedure TestGetBonus100;
Begin
  If GetPole(Player.X+8,Player.Y+8)=10 then
  Begin
    SetPole(Player.X+8,Player.Y+8,11);
    Bonus[CisloBonusu].X:=Player.X+8;
    Bonus[CisloBonusu].Y:=Player.Y+8;
    Bonus[CisloBonusu].Counter:=30;
    Bonus[CisloBonusu].Hide:=True;
    If CisloBonusu<9 then Inc(CisloBonusu)
                     else CisloBonusu:=0;
    Inc(Game.Score,100);
    PlaySound(4);
  End;
End;


Procedure TestGetBonus500;
Begin
  If GetPole(Player.X+8,Player.Y+8)=20 then
  Begin
    SetPole(Player.X+8,Player.Y+8,21);
    Bonus[CisloBonusu].X:=Player.X+8;
    Bonus[CisloBonusu].Y:=Player.Y+8;
    Bonus[CisloBonusu].Counter:=30;
    Bonus[CisloBonusu].Hide:=True;
    If CisloBonusu<9 then Inc(CisloBonusu)
                     else CisloBonusu:=0;
    Inc(Game.Score,500);
    PlaySound(3);
  End;
End;


Procedure TestGetAmmo;
Begin
  If GetPole(Player.X+8,Player.Y+8)=30 then
  Begin
    SetPole(Player.X+8,Player.Y+8,31);
    Bonus[CisloBonusu].X:=Player.X+8;
    Bonus[CisloBonusu].Y:=Player.Y+8;
    Bonus[CisloBonusu].Counter:=30;
    Bonus[CisloBonusu].Hide:=True;
    If CisloBonusu<9 then Inc(CisloBonusu)
                     else CisloBonusu:=0;
    Inc(Ammo,8);
    PlaySound(5);
  End;
End;


Procedure TestGetLive;
Begin
  If GetPole(Player.X+8,Player.Y+8)=40 then
  Begin
    SetPole(Player.X+8,Player.Y+8,41);
    Bonus[CisloBonusu].X:=Player.X+8;
    Bonus[CisloBonusu].Y:=Player.Y+8;
    Bonus[CisloBonusu].Counter:=30;
    Bonus[CisloBonusu].Hide:=True;
    If CisloBonusu<9 then Inc(CisloBonusu)
                     else CisloBonusu:=0;
    Inc(Player.Lives);
    PlaySound(9);
  End;
End;


Procedure HideBonus;
Var I: Byte;
Begin
  For I:=0 to 9 do
  Begin
    If Bonus[I].Hide=True then
    Begin
      If Bonus[I].Counter>0 then Dec(Bonus[I].Counter)
                            else Begin
                                   SetPole(Bonus[I].X,Bonus[I].Y,0);
                                   Bonus[I].X:=0;
                                   Bonus[I].Y:=0;
                                   Bonus[I].Hide:=False;
                                 End;
    End;
  End;
End;


Procedure PlayerSkrceny;
Begin
  If ((Box.Akce=False) and (Kop.Akce=False) and (Player.Skrceny=True)) then
  Begin
    Case Player.Smer of
      1: Player.Sprite:=17;
      2: Player.Sprite:=21;
    End; {Case End}
  End;
End;


Procedure PlayerBox;
Var I: Byte;
Begin
  If Box.Akce=True then
  Begin
    Player.Power1:=0;
    Player.Power2:=0;

    If ((Box.DelayCounter>18) and (Box.DelayCounter<=20)) then
    Begin
      Case Player.Smer of
        1: Begin
             Player.Sprite:=9;
             If Player.Skrceny=True then Player.Sprite:=17;
           End;
        2: Begin
             Player.Sprite:=13;
             If Player.Skrceny=True then Player.Sprite:=21;
           End;
      End; {Case End}
    End;
    If ((Box.DelayCounter>17) and (Box.DelayCounter<=18)) then
    Begin
      Case Player.Smer of
        1: Begin
             Player.Sprite:=10;
             For I:=0 to 255 do EnemyTestHit(Player.X+20,Player.Y+7,I);
             If Player.Skrceny=True then
             Begin
               Player.Sprite:=18;
               For I:=0 to 255 do EnemyTestHit(Player.X+21,Player.Y+11,I);
             End;
           End;
        2: Begin
             Player.Sprite:=14;
             For I:=0 to 255 do EnemyTestHit(Player.X-6,Player.Y+6,I);
             If Player.Skrceny=True then
             Begin
               Player.Sprite:=22;
               For I:=0 to 255 do EnemyTestHit(Player.X-7,Player.Y+11,I);
             End;
           End;
      End; {Case End}
    End;
    If ((Box.DelayCounter>0) and (Box.DelayCounter<=17)) then
    Begin
      Case Player.Smer of
        1: Begin
             Player.Sprite:=9;
             If Player.Skrceny=True then Player.Sprite:=17;
           End;
        2: Begin
             Player.Sprite:=13;
             If Player.Skrceny=True then Player.Sprite:=21;
           End;
      End; {Case End}
    End;

    If Box.DelayCounter>0 then Dec(Box.DelayCounter)
                          else Begin
                                 Box.Akce:=False;
                                 Case Player.Smer of
                                  1: Begin
                                       Player.Sprite:=1;
                                       If Player.Skrceny=True then Player.Sprite:=17;
                                     End;
                                  2: Begin
                                       Player.Sprite:=4;
                                       If Player.Skrceny=True then Player.Sprite:=21;
                                     End;
                                 End; {Case End}
                               End;
  End;
End;


Procedure PlayerKop;
Var I: Byte;
Begin
  If Kop.Akce=True then
  Begin
    If Player.InAir=False then
    Begin
      Player.Power1:=0;
      Player.Power2:=0;
    End;

    If ((Kop.DelayCounter>19) and (Kop.DelayCounter<=20)) then
    Begin
      Case Player.Smer of
        1: Begin
             Player.Sprite:=12;
             If Player.Skrceny=True then Player.Sprite:=19;
           End;
        2: Begin
             Player.Sprite:=16;
             If Player.Skrceny=True then Player.Sprite:=23;
           End;
      End; {Case End}
    End;

    If ((Kop.DelayCounter>18) and (Kop.DelayCounter<=19)) then
    Begin
      Case Player.Smer of
        1: Begin
             Player.Sprite:=11;
             For I:=0 to 255 do EnemyTestHit(Player.X+23,Player.Y+7,I);
             If Player.Skrceny=True then
             Begin
               Player.Sprite:=20;
               For I:=0 to 255 do EnemyTestHit(Player.X+24,Player.Y+21,I);
             End;
           End;
        2: Begin
             Player.Sprite:=15;
             For I:=0 to 255 do EnemyTestHit(Player.X-10,Player.Y+8,I);
             If Player.Skrceny=True then
             Begin
               Player.Sprite:=24;
               For I:=0 to 255 do EnemyTestHit(Player.X-12,Player.Y+21,I);
             End;
           End;
      End; {Case End}
    End;
    If ((Kop.DelayCounter>9) and (Kop.DelayCounter<=18)) then
    Begin
      Case Player.Smer of
        1: Begin
             Player.Sprite:=12;
             If Player.Skrceny=True then Player.Sprite:=19;
           End;
        2: Begin
             Player.Sprite:=16;
             If Player.Skrceny=True then Player.Sprite:=23;
           End;
      End; {Case End}
    End;
    If ((Kop.DelayCounter>0) and (Kop.DelayCounter<=9)) then
    Begin
      Case Player.Smer of
        1: Begin
             Player.Sprite:=9;
             If Player.Skrceny=True then Player.Sprite:=19;
           End;
        2: Begin
             Player.Sprite:=13;
             If Player.Skrceny=True then Player.Sprite:=23;
           End;
      End; {Case End}
    End;

    If Kop.DelayCounter>0 then Dec(Kop.DelayCounter)
                          else Begin
                                 Kop.Akce:=False;
                                 Case Player.Smer of
                                  1: Begin
                                       Player.Sprite:=1;
                                       If Player.Skrceny=True then Player.Sprite:=17;
                                     End;
                                  2: Begin
                                       Player.Sprite:=4;
                                       If Player.Skrceny=True then Player.Sprite:=21;
                                     End;
                                 End; {Case End}
                               End;
  End;
End;


Procedure PlayerStrela;
Begin
  If Strela.Akce=True then
  Begin
    Player.Power1:=0;
    Player.Power2:=0;

    If ((Strela.DelayCounter>18) and (Strela.DelayCounter<=20)) then
    Begin
      Case Player.Smer of
        1: Begin
             Player.Sprite:=30;
             If Player.Skrceny=True then Player.Sprite:=26;
           End;
        2: Begin
             Player.Sprite:=32;
             If Player.Skrceny=True then Player.Sprite:=28;
           End;
      End; {Case End}
    End;
    If ((Strela.DelayCounter>17) and (Strela.DelayCounter<=18)) then
    Begin
      Strela.Leti:=True;
      Strela.Smer:=Player.Smer;
      Strela.LetCounter:=30;
      Case Player.Smer of
        1: Begin
             Player.Sprite:=31;
             Strela.X:=Player.X+20;
             Strela.Y:=Player.Y+1;
             If Player.Skrceny=True then
             Begin
               Player.Sprite:=27;
               Strela.X:=Player.X+21;
               Strela.Y:=Player.Y+6;
             End;
           End;
        2: Begin
             Player.Sprite:=33;
             Strela.X:=Player.X-11;
             Strela.Y:=Player.Y+1;
             If Player.Skrceny=True then
             Begin
               Player.Sprite:=29;
               Strela.X:=Player.X-12;
               Strela.Y:=Player.Y+6;
             End;
           End;
      End; {Case End}
    End;
    If ((Strela.DelayCounter>0) and (Strela.DelayCounter<=17)) then
    Begin
      Case Player.Smer of
        1: Begin
             Player.Sprite:=30;
             If Player.Skrceny=True then Player.Sprite:=26;
           End;
        2: Begin
             Player.Sprite:=32;
             If Player.Skrceny=True then Player.Sprite:=28;
           End;
      End; {Case End}
    End;

    If Strela.DelayCounter>0 then Dec(Strela.DelayCounter)
                          else Begin
                                 Strela.Akce:=False;
                                 Case Player.Smer of
                                  1: Begin
                                       Player.Sprite:=1;
                                       If Player.Skrceny=True then Player.Sprite:=17;
                                     End;
                                  2: Begin
                                       Player.Sprite:=4;
                                       If Player.Skrceny=True then Player.Sprite:=21;
                                     End;
                                 End; {Case End}
                               End;
  End;
End;


Procedure PlayerStrelaLeti;
Var I: Byte;
Begin
  If Strela.Leti=True then
  Begin
    For I:=0 to 255 do EnemyTestHit(Strela.X+2,Strela.Y+2,I);
    Case Strela.Smer of
     1: Begin
          If GetPole(Strela.X+2,Strela.Y+2)<128 then
          Begin
            If Strela.LetCounter>0 then Inc(Strela.X,5)
                                   else Strela.Leti:=False;
          End else Strela.Leti:=False;
        End;
     2: Begin
          If GetPole(Strela.X+2,Strela.Y+2)<128 then
          Begin
            If Strela.LetCounter>0 then Dec(Strela.X,5)
                                   else Strela.Leti:=False;
          End else Strela.Leti:=False;
        End;
    End; {Case End}
    If Strela.LetCounter>0 then Dec(Strela.LetCounter);
  End;
End;


Procedure PlayerDeath;
Begin
  If ((Player.DeathCounter>0) and (Player.DeathCounter<=25))
  then Begin
       End;
  If ((Player.DeathCounter>25) and (Player.DeathCounter<=85))
  then Begin
         If Player.Y<1120 then Inc(Player.Y,5);
       End;
  If Player.DeathCounter<85 then Inc(Player.DeathCounter)
                            else Begin
                                   Game.LevelFinish:=True;
                                   If Player.Lives>0 then Dec(Player.Lives)
                                                     else Game.Ending:=True;
                                 End;
End;


Procedure PlayerTestGoal;
Begin
  If ((GetPole(Player.X+2,Player.Y+15)=22) and
      (GetPole(Player.X+13,Player.Y+15)=22)) then
  Begin
    Game.LevelFinish:=True;
    PlaySound(6);
    Wait(1600);
    If Game.Level=LastLevel then Begin
                                   Game.Ending:=True;
                                   Game.AllClear:=True;
                                 End
                            else Inc(Game.Level);
  End;
End;


Procedure PressQWDecrease;
Begin
  If PressQCounter>0 then Dec(PressQCounter);
  If PressWCounter>0 then Dec(PressWCounter);
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Processing;
Begin
  If ((Box.Akce=False) and (Strela.Akce=False)) then
  Begin
    PlayerStep;
    If Player.Jump=False then PlayerFrame
                         else Begin
                                If Player.Smer=1 then Player.Sprite:=1;
                                If Player.Smer=2 then Player.Sprite:=4;
                                If Player.Death=True then Player.Sprite:=25;
                              End;
    If Player.Jump=True then PlayerJump;
  End;
  If Player.Death=False then Begin
                               PlayerPodlozka;
                               PlayerRebrik;
                             End;
  If Player.Rebrik=False then PlayerGravity;
  Scrolling;
  TestGetBonus100;
  TestGetBonus500;
  TestGetAmmo;
  TestGetLive;
  HideBonus;
  PlayerSkrceny;
  If Player.Death=False then
  Begin
    PlayerBox;
    PlayerKop;
    PlayerStrela;
  End;
  PlayerStrelaLeti;
  If Player.Death=True then PlayerDeath;
  EnemyDie;
  EnemyAktive;
  EnemyLogics;
  PlayerTestGoal;
  PressQWDecrease;
End;