Procedure InitLevel;
Var I: Byte;
    X,Y: Byte;
Begin
  Case Game.Level of
    1: Begin
         LoadMapFile('level1.map',0);
         Map.Xview:=16;
         Map.YView:=920;
       End;
    2: Begin

       End;
  End; {Case End}

  I:=0;
  For Y:=0 to 71 do
  For X:=0 to 79 do
  Begin
    If GetMapByte(Y*80+X)=109 then
    Begin
      SetMapByte(Y*80+X,0);
      Player.X:=X*16;
      Player.Y:=Y*16-8;
      Player.Sprite:=4;
      Player.Smer:=2;
    End;

    If GetMapByte(Y*80+X)=119 then
    Begin
      SetMapByte(Y*80+X,0);
      Player.X:=X*16;
      Player.Y:=Y*16-8;
      Player.Sprite:=1;
      Player.Smer:=1;
    End;

    If GetMapByte(Y*80+X)=100 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=1;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16-8;
      Enemy[I].Smer:=2;
      Enemy[I].Sprite:=4;
      Enemy[I].KrokCounter:=0;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=110 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=1;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16-8;
      Enemy[I].Smer:=1;
      Enemy[I].Sprite:=1;
      Enemy[I].KrokCounter:=0;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=101 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=2;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16-8;
      Enemy[I].Smer:=2;
      Enemy[I].Sprite:=4;
      Enemy[I].KrokCounter:=0;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Enemy[I].MoveCounter:=80;
      Enemy[I].MoveCounterMax:=80;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=111 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=2;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16-8;
      Enemy[I].Smer:=1;
      Enemy[I].Sprite:=1;
      Enemy[I].KrokCounter:=0;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Enemy[I].MoveCounter:=80;
      Enemy[I].MoveCounterMax:=80;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=102 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=3;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16;
      Enemy[I].Smer:=2;
      Enemy[I].Sprite:=1;
      Enemy[I].KrokCounter:=0;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=112 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=3;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16;
      Enemy[I].Smer:=1;
      Enemy[I].Sprite:=1;
      Enemy[I].KrokCounter:=0;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=103 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=4;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16;
      Enemy[I].Smer:=2;
      Enemy[I].Sprite:=1;
      Enemy[I].KrokCounter:=0;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Enemy[I].MoveCounter:=80;
      Enemy[I].MoveCounterMax:=80;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=113 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=4;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16;
      Enemy[I].Smer:=1;
      Enemy[I].Sprite:=1;
      Enemy[I].KrokCounter:=0;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Enemy[I].MoveCounter:=80;
      Enemy[I].MoveCounterMax:=80;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=114 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=5;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16;
      Enemy[I].Sprite:=1;
      Enemy[I].ExpCounter:=0;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=105 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=6;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16-12;
      Enemy[I].Smer:=2;
      Enemy[I].Sprite:=3;
      Enemy[I].KrokCounter:=0;
      Enemy[I].MoveCounter:=88;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Inc(I);
    End;

    If GetMapByte(Y*80+X)=115 then
    Begin
      SetMapByte(Y*80+X,0);
      Enemy[I].Typ:=6;
      Enemy[I].X:=X*16;
      Enemy[I].Y:=Y*16-12;
      Enemy[I].Smer:=1;
      Enemy[I].Sprite:=1;
      Enemy[I].KrokCounter:=0;
      Enemy[I].MoveCounter:=188;
      Enemy[I].Death:=False;
      Enemy[I].Terminated:=False;
      Inc(I);
    End;
  End;

  Game.LevelFinish:=False;

  CisloBonusu:=0;
  For I:=0 to 9 do Bonus[I].Hide:=False;

  Player.Death:=False;
  Player.KrokCounter:=0;
  Player.Power1:=0;
  Player.Power2:=0;
  Player.Power3:=0;
  Player.Power4:=0;
  Player.Rebrik:=False;
  Player.RebrikCounter:=1;
  Player.Skrceny:=False;

  Box.Akce:=False;
  Box.DelayCounter:=0;
  Kop.Akce:=False;
  Kop.DelayCounter:=0;

  Strela.Akce:=False;
  Strela.DelayCounter:=0;
  Strela.Leti:=False;
End;