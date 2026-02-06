Procedure CreateNextBrick;
Var I: Byte;
Begin
  For I:=1 to 3 do
  Begin
    If KostkaCounter<DestroyerTime then NextKostka.B[I].N:=Random(6)+1
                                   else NextKostka.B[I].N:=7;

    NextKostka.B[I].Mark:=False;
    NextKostka.B[I].Exp:=False;
    NextKostka.B[I].Y:=I-1;
    NextKostka.B[I].X:=4;
  End;
  UpdateMainGameScreen5;
  WriteMainGameScreen;
  Inc(KostkaCounterAll);
End;


Procedure SetupBrick;
Var I: Byte;
Begin
  If KostkaCounter<DestroyerTime then Inc(KostkaCounter)
                                 else KostkaCounter:=0;

  For I:=1 to 3 do Begin
                     Kostka.B[I].Y:=I-1;
                     Kostka.B[I]:=NextKostka.B[I];
                     Brick[(Kostka.B[I].Y)*9+(Kostka.B[I].X)].N:=Kostka.B[I].N;
                   End;
End;


Procedure BrickStepLeft;
Var I: Byte;
Begin
  If ((Kostka.B[1].X>0) and
     (Brick[(Kostka.B[1].Y)*9+(Kostka.B[1].X-1)].N=0) and
     (Brick[(Kostka.B[2].Y)*9+(Kostka.B[2].X-1)].N=0) and
     (Brick[(Kostka.B[3].Y)*9+(Kostka.B[3].X-1)].N=0)) then
  For I:=1 to 3 do
  Begin
    If SB=False then PlaySound(0) else SBPlayRaw(0);
    Brick[(Kostka.B[I].Y)*9+(Kostka.B[I].X-1)].N:=Kostka.B[I].N;
    Brick[(Kostka.B[I].Y)*9+(Kostka.B[I].X)].N:=0;
    Dec(Kostka.B[I].X);
  End;
End;


Procedure BrickStepRight;
Var I: Byte;
Begin
  If ((Kostka.B[1].X<8) and
     (Brick[(Kostka.B[1].Y)*9+(Kostka.B[1].X+1)].N=0) and
     (Brick[(Kostka.B[2].Y)*9+(Kostka.B[2].X+1)].N=0) and
     (Brick[(Kostka.B[3].Y)*9+(Kostka.B[3].X+1)].N=0)) then
  For I:=1 to 3 do
  Begin
    If SB=False then PlaySound(0) else SBPlayRaw(0);
    Brick[(Kostka.B[I].Y)*9+(Kostka.B[I].X+1)].N:=Kostka.B[I].N;
    Brick[(Kostka.B[I].Y)*9+(Kostka.B[I].X)].N:=0;
    Inc(Kostka.B[I].X);
  End;
End;


Procedure BrickStepDown;
Var I: Byte;
Begin
  For I:=1 to 3 do
  Begin
    Brick[(Kostka.B[I].Y+1)*9+(Kostka.B[I].X)].N:=Kostka.B[I].N;
    Inc(Kostka.B[I].Y);
  End;
  Brick[(Kostka.B[1].Y-1)*9+(Kostka.B[1].X)].N:=0;
End;


Procedure BrickRotate;
Var Store: Byte;
    I: Byte;
Begin
  Store:=Kostka.B[3].N;
  Kostka.B[3].N:=Kostka.B[2].N;
  Kostka.B[2].N:=Kostka.B[1].N;
  Kostka.B[1].N:=Store;
  For I:=1 to 3 do Brick[(Kostka.B[I].Y)*9+(Kostka.B[I].X)].N:=Kostka.B[I].N;
End;


Function TestBrickStop: Boolean;
Var I: Byte;
Begin
  If Kostka.B[3].Y<15 then
  Begin
    If Brick[(Kostka.B[3].Y+1)*9+(Kostka.B[3].X)].N=0
    then TestBrickStop:=False
    else Begin
           TestBrickStop:=True;
           If SB=False then PlaySound(4) else SBPlayRaw(4);
           Level:=LevelBackup;
           If KostkaCounter>0
           then DestroyerTarget:=0
           else DestroyerTarget:=Brick[(Kostka.B[3].Y+1)*9+(Kostka.B[3].X)].N;
           If Reaction=True then For I:=1 to 3 do Kostka.B[I].Y:=0;
         End
  End else
  Begin
    TestBrickStop:=True;
    If SB=False then PlaySound(4) else SBPlayRaw(4);
    Level:=LevelBackup;
    DestroyerTarget:=0;
    Reaction;
  End;
End;


Procedure BrickFall;
Var Ending: Boolean;
Begin
  Ending:=False;
  If LevelBackup<9 then Level:=LevelBackup
                   else Level:=9;
  FillBrickFallCounter;
  Repeat
    UpdateMainGameScreen2;
    WriteMainGameScreen;
    Wait(fps.prodleva);
    If BrickFallCounter>0
    then Begin
           Dec(BrickFallCounter);
{Esc}      If Key[1]=True then Ending:=True;
{Left}     If Key[75]=True then
           Begin
             While Key[75]=True do WaitButton(75,15);
             BrickStepLeft;
             UpdateMainGameScreen2;
             WriteMainGameScreen;
           End;
{Right}    If Key[77]=True then
           Begin
             While Key[77]=True do WaitButton(77,15);
             BrickStepRight;
             UpdateMainGameScreen2;
             WriteMainGameScreen;
           End;
{Space}    If Key[57]=True then
           Begin
             While Key[57]=True do WaitButton(57,20);
             If SB=False then PlaySound(1) else SBPlayRaw(1);
             BrickRotate;
             UpdateMainGameScreen2;
             WriteMainGameScreen;
           End;
{Enter}    If Key[28]=True then
           Begin
             Pause:=True;
             UpdateMainGameScreen6;
             WriteMainGameScreen;
             While Key[28]=True do Begin End;
             Repeat
               If Key[28]=True then
               Begin
                 While Key[28]=True do Begin End;
                 Pause:=False;
                 UpdateMainGameScreen2;
                 WriteMainGameScreen;
               End;
             Until Pause=False;
           End;
{Down}     If Key[80]=True
           then Begin
                  HoldDown:=True;
                  If Level<9 then
                  Begin
                    LevelBackup:=Level;
                    Level:=9;
                    BrickFallCounter:=0;
                  End;
                End
           else Begin
                  HoldDown:=False;
                  If LevelBackup<9 then Level:=LevelBackup;
                End;
         End
    else Begin
           FillBrickFallCounter;

           If TestBrickStop=False then
              Begin
                If HoldDown=True then
                Begin If SB=False then PlaySound(0) else SBPlayRaw(0); End;
                BrickStepDown;
                UpdateMainGameScreen2;
                WriteMainGameScreen;
              End else Ending:=True;

           If ((Brick[(Kostka.B[3].Y+1)*9+(Kostka.B[3].X)].N>0) and
               (Kostka.B[1].Y=0) and (Kostka.B[1].X=4)) then GameOver:=True
         End;
  Until Ending=True;

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


Procedure StartupCountdown;
Var I: Byte;
Begin
  For I:=3 downto 1 do
  Begin
    UpdateMainGameScreen2;
    WriteNumber(Buffer[1],160,184,16,16,1,56,96,I,Buffer[3]);
    WriteMainGameScreen;
    Wait(900);
  End;
End;


Procedure MainGame;
Var Ending: Boolean;
    I: Byte;
Begin
  Ending:=False;
  StartHry:=True;
  GameOver:=False;
  Pause:=False;
  Level:=0;
  LevelBackup:=0;
  Score:=0;
  KostkaCounter:=0;
  KostkaCounterAll:=0;
  For I:=0 to 150 do
  Begin
    Brick[I].N:=0;
    Brick[I].Exp:=False;
  End;

  ClearPage(Buffer[3]);
  UpdateMainGameScreen1; {write nadoba}
  UpdateMainGameScreen2; {write jednotlive kostky}
  UpdateMainGameScreen3; {write score}
  UpdateMainGameScreen4; {write level}
  UpdateMainGameScreen5; {write next brick}
  WriteMainGameScreen;
  StartupCountdown;
  Repeat
    If StartHry=True then Begin
                            CreateNextBrick;
                            StartHry:=False;
                          End;
    SetupBrick;
    CreateNextBrick;
    BrickFall;

    If Key[1]=True then
    Begin
      While Key[1]=True do Begin End;
      Ending:=True;
    End;

  Until ((Ending=True) or (GameOver=True));

  If GameOver=True then
  Begin
    If SB=False then PlaySound(3) else SBPlayRaw(3);
    If Score>HiScore then
    Begin
      HiScore:=Score;
      HiScoreSaveLoad(True); {SAVE}
    End;
    WriteText(Buffer[1],160,136,16,16,1,20,96,'konec',Buffer[3]);
    WriteMainGameScreen;
    While Key[1]=False do Begin End;
    While Key[1]=True do Begin End;
  End;
End;