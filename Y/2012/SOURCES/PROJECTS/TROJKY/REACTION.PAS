Procedure CheckExp;
Var X,Y: Byte;
Begin
  For Y:=1 to 14 do
  For X:=1 to 7 do
  Begin
    If ((Brick[(Y-1)*9+(X-1)].N>0) and
        (Brick[(Y-1)*9+(X-1)].N=Brick[(Y-1)*9+X].N) and (Brick[(Y-1)*9+X].N=Brick[(Y-1)*9+(X+1)].N)) then
    Begin
      Brick[(Y-1)*9+(X-1)].Mark:=True;
      Brick[(Y-1)*9+(X)].Mark:=True;
      Brick[(Y-1)*9+(X+1)].Mark:=True;
    End;
    If ((Brick[(Y+1)*9+(X-1)].N>0) and
        (Brick[(Y+1)*9+(X-1)].N=Brick[(Y+1)*9+X].N) and (Brick[(Y+1)*9+X].N=Brick[(Y+1)*9+(X+1)].N)) then
    Begin
      Brick[(Y+1)*9+(X-1)].Mark:=True;
      Brick[(Y+1)*9+(X)].Mark:=True;
      Brick[(Y+1)*9+(X+1)].Mark:=True;
    End;
    If ((Brick[Y*9+(X-1)].N>0) and
        (Brick[Y*9+(X-1)].N=Brick[Y*9+X].N) and (Brick[Y*9+X].N=Brick[Y*9+(X+1)].N)) then
    Begin
      Brick[Y*9+(X-1)].Mark:=True;
      Brick[Y*9+(X)].Mark:=True;
      Brick[Y*9+(X+1)].Mark:=True;
    End;

    If ((Brick[(Y-1)*9+(X+1)].N>0) and
        (Brick[(Y-1)*9+(X+1)].N=Brick[Y*9+(X+1)].N) and (Brick[Y*9+(X+1)].N=Brick[(Y+1)*9+(X+1)].N)) then
    Begin
      Brick[(Y-1)*9+(X+1)].Mark:=True;
      Brick[Y*9+(X+1)].Mark:=True;
      Brick[(Y+1)*9+(X+1)].Mark:=True;
    End;
    If ((Brick[(Y-1)*9+(X-1)].N>0) and
        (Brick[(Y-1)*9+(X-1)].N=Brick[Y*9+(X-1)].N) and (Brick[Y*9+(X-1)].N=Brick[(Y+1)*9+(X-1)].N)) then
    Begin
      Brick[(Y-1)*9+(X-1)].Mark:=True;
      Brick[Y*9+(X-1)].Mark:=True;
      Brick[(Y+1)*9+(X-1)].Mark:=True;
    End;
    If ((Brick[(Y-1)*9+X].N>0) and
        (Brick[(Y-1)*9+X].N=Brick[Y*9+X].N) and (Brick[Y*9+X].N=Brick[(Y+1)*9+X].N)) then
    Begin
      Brick[(Y-1)*9+X].Mark:=True;
      Brick[Y*9+X].Mark:=True;
      Brick[(Y+1)*9+X].Mark:=True;
    End;

    If ((Brick[(Y-1)*9+(X-1)].N>0) and
        (Brick[(Y-1)*9+(X-1)].N=Brick[Y*9+X].N) and (Brick[Y*9+X].N=Brick[(Y+1)*9+(X+1)].N)) then
    Begin
      Brick[(Y-1)*9+(X-1)].Mark:=True;
      Brick[Y*9+X].Mark:=True;
      Brick[(Y+1)*9+(X+1)].Mark:=True;
    End;
    If ((Brick[(Y-1)*9+(X+1)].N>0) and
        (Brick[(Y-1)*9+(X+1)].N=Brick[Y*9+X].N) and (Brick[Y*9+X].N=Brick[(Y+1)*9+(X-1)].N)) then
    Begin
      Brick[(Y-1)*9+(X+1)].Mark:=True;
      Brick[Y*9+X].Mark:=True;
      Brick[(Y+1)*9+(X-1)].Mark:=True;
    End;
  End;
End;


Procedure SetupDestroyer;
Var X,Y: Byte;
Begin
  If DestroyerTarget>0 then
  Begin
    For Y:=0 to 15 do
    For X:=0 to 8 do
    If Brick[Y*9+X].N=DestroyerTarget then Brick[Y*9+X].Mark:=True;
  End;
End;


Function MarkExp: Byte;
Var N,X,Y: Byte;
Begin
  MarkExp:=0;
  For Y:=0 to 15 do
  For X:=0 to 8 do
  If Brick[Y*9+X].Mark=True then
  Begin
    Inc(N);
    Inc(Score,100);
    MarkExp:=N;
  End;
  If N>0 then
  Begin
    If Score>=10000 then Begin Level:=1; LevelBackup:=1; End;
    If Score>=20000 then Begin Level:=2; LevelBackup:=2; End;
    If Score>=30000 then Begin Level:=3; LevelBackup:=3; End;
    If Score>=40000 then Begin Level:=4; LevelBackup:=4; End;
    If Score>=50000 then Begin Level:=5; LevelBackup:=5; End;
    If Score>=60000 then Begin Level:=6; LevelBackup:=6; End;
    If Score>=70000 then Begin Level:=7; LevelBackup:=7; End;
    If Score>=80000 then Begin Level:=8; LevelBackup:=8; End;
    If Score>=90000 then Begin Level:=9; LevelBackup:=9; End;
  End;
  UpdatemainGameScreen3;
  UpdatemainGameScreen4;
  WriteMainGameScreen;
End;


Procedure CountVyskaSloupce(X,Y:Byte);
Var I: Byte;
    A: Byte;
Begin
  A:=0;
  For I:=0 to 15 do
  Begin
    If Brick[I*9+X].N>0
    then Break
    else Inc(A);
  End;
  If A=16 then VyskaSloupce[X]:=0;
  If A<16 then VyskaSloupce[X]:=Y-A;
End;


Procedure Fall;
Var I,X,Y: Byte;
Begin
  For Y:=15 downto 0 do
  Begin
    For X:=0 to 8 do
    Begin
      If Brick[Y*9+X].N=0 then
      Begin
        CountVyskaSloupce(X,Y);
        If VyskaSloupce[X]>0 then
        Begin
          For I:=0 to VyskaSloupce[X]-1 do
          If Y-(I+1)>=0
          then Brick[(Y-I)*9+X].N:=Brick[(Y-(I+1))*9+X].N;
          If Y-VyskaSloupce[X]>=0
          then Brick[(Y-(VyskaSloupce[X]))*9+X].N:=0;
        End;
      End;
    End;
  End;
End;


Procedure BurnBrics;
Var I,X,Y: Byte;
Begin
  Setpal(31,63,63,63);
  For Y:=0 to 15 do
  For X:=0 to 8 do
  If Brick[Y*9+X].Mark=True then Inc(Brick[Y*9+X].N,7);
  UpdateMainGameScreen2;
  WriteMainGameScreen;
  If SB=False then PlaySound(2) else SBPlayRaw(2);
  For I:=16 downto 0 do
  Begin
    If I>0 then SetPal(31,I*4-1,I*4-1,I*4-1)
           else SetPal(31,0,0,0);
    UpdateMainGameScreen2;
    WriteMainGameScreen;
    Wait(30);
  End;
  For Y:=0 to 15 do
  For X:=0 to 8 do
  Begin
    If Brick[Y*9+X].Mark=True then Brick[Y*9+X].N:=0;
    If Brick[Y*9+X].Mark=True then Brick[Y*9+X].Mark:=False;
  End;
End;


Function Reaction: Boolean;
Var N,X,Y,I: Byte;
    ProvestFall: Boolean;
Begin
  N:=0;
  HoldDown:=False;
  Reaction:=False;
  If KostkaCounter>0 then CheckExp
                     else Begin
                            CheckExp;
                            SetupDestroyer;
                          End;
  If MarkExp>0 then
  Begin
    Reaction:=True;
    Repeat
      BurnBrics;

      Repeat
        ProvestFall:=False;
        For X:=0 to 8 do
        Begin
          CountVyskaSloupce(X,15);
          If VyskaSloupce[X]>0 then
          Begin
            For I:=0 to VyskaSloupce[X]-1 do
            If Brick[(15-I)*9+X].N=0 then ProvestFall:=True;
          End;
        End;

        If ProvestFall=True then
        Begin
          Fall;
          FillBrickFallCounter;
          While BrickFallCounter>0 do
          Begin
            Dec(BrickFallCounter);
            UpdateMainGameScreen2;
            WriteMainGameScreen;
            Wait(fps.prodleva);
            If Key[1]=True then BrickFallCounter:=0;
          End;
        End;
      Until ProvestFall=False;

      CheckExp;
      N:=MarkExp;
    Until N=0;
  End;
End;