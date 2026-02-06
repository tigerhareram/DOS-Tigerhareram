Procedure ReadKeys;
Begin
{A}      If Key[30]=True then
         Begin
           If ((Player.InAir=False) and (Player.Skrceny=False) and
               (Player.Rebrik=False) and (Box.Akce=False) and (Strela.Akce=False)) then
           Begin
             Player.Jump:=True;
             PlaySound(0);
           End;
           If ((Player.InAir=True) and (Player.Jump=True)) then
           Begin
             If Player.Power4<15 then Inc(Player.Power4)
                                 else Begin
                                        Player.Jump:=False;
                                        Player.Power4:=0;
                                      End;
           End;
         End;

{Q}      If ((Key[16]=True) and (PressQcounter=0)) then
         Begin
           If Fps.Show=True then Fps.Show:=False
                            else Fps.Show:=True;
           PressQCounter:=10;
         End;

{W}      If ((Key[17]=True) and (PressWCounter=0)) then
         Begin
           If TabulkaShow=True then TabulkaShow:=False
                               else TabulkaShow:=True;
           PressWCounter:=10;
         End;

{E}      If Key[18]=True then
         Begin
           If ((Player.InAir=False) and (Strela.Leti=False)) then
           Begin
             If Ammo>0 then
             Begin
               Box.Akce:=False;
               Kop.Akce:=False;
               Strela.Akce:=True;
               If Strela.DelayCounter<15 then Begin
                                                Strela.DelayCounter:=20;
                                                PlaySound(1);
                                                Dec(Ammo);
                                              End;
             End;
           End;
         End;

{S}      If Key[31]=True then
         Begin
           If Player.InAir=False then
           Begin
             Box.Akce:=True;
             Kop.Akce:=False;
             Kop.DelayCounter:=0;
             If Box.DelayCounter<=17 then Box.DelayCounter:=20;
           End;
         End;

{D}      If Key[32]=True then
         Begin
           Kop.Akce:=True;
           Box.Akce:=False;
           Box.DelayCounter:=0;
           If Kop.DelayCounter<=17 then Kop.DelayCounter:=20;
         End;

{J}      If Key[36]=True then
         Begin
           If Player.Smer<>2 then Player.Smer:=2;
           If Player.Power2<25 then Inc(Player.Power2);
           If ((Kop.Akce=True) and (Player.InAir=False)) then Player.Power2:=0;
           If Player.Skrceny=True then Player.Power2:=0;
         End;

{L}      If Key[38]=True then
         Begin
           If Player.Smer<>1 then Player.Smer:=1;
           If Player.Power1<25 then Inc(Player.Power1);
           If ((Kop.Akce=True) and (Player.InAir=False)) then Player.Power1:=0;
           If Player.Skrceny=True then Player.Power1:=0;
         End;

{I}      If Key[23]=True then
         Begin
           If ((Player.Rebrik=True) and (Player.Jump=False) and
               (Box.Akce=False) and (Kop.Akce=False) and (Strela.Akce=False)) then
           Begin
             Player.Power1:=0;
             Player.Power2:=0;
             If Player.Y>1 then Dec(Player.Y,2);
           End;
         End;

{K}      If Key[37]=True then
         Begin
           If ((Player.Rebrik=True) or
               ((GetPole(Player.X+6,Player.Y+25)=16) and
                (GetPole(Player.X+10,Player.Y+25)=16))) then
           Begin
             If ((GetPole(Player.X+6,Player.Y+25)=16) and
                 (GetPole(Player.X+10,Player.Y+25)=16)) then Player.Rebrik:=True;
             If ((Box.Akce=False) and (Kop.Akce=False) and (Strela.Akce=False)) then
             Begin
               If Player.Y<1135 then
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
           If ((Player.Rebrik=False) and (Player.InAir=False)) then
           Begin
             Player.Skrceny:=True;
             Player.Power1:=0;
             Player.Power2:=0;
           End;
         End else
         Begin
           If ((Player.Rebrik=False) and (Player.InAir=False)) then Player.Skrceny:=False;
         End;

{Esc}    If Key[1]=True then
         Begin
           While Key[1]=True do Begin End;
           Game.LevelFinish:=True;
           Game.Ending:=True;
         End;
End;