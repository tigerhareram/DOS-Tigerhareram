Procedure MainGame;
Var Ending: Boolean;
Begin
  Game.Ending:=False;
  Game.AllClear:=False;
  Game.Score:=0;
  Game.Level:=1;
  Player.Lives:=2;
  Ammo:=8;
  TabulkaShow:=True;
  Fps.Show:=True;
  Repeat
    StartLevelScreen;
    InitLevel;
    Repeat
      Stopky_Start;
      Player.SaveX:=Player.X;
      Player.SaveY:=Player.Y;
      GameScreen;
      If Player.Death=False then ReadKeys;
      Processing;
      Wait(fps.prodleva);
      Stopky_Stop;
      FPSTrigg;
    Until Game.LevelFinish=True;
  Until Game.Ending=True;
  If Game.Score>HiScore then
  Begin
    HiScore:=Game.Score;
    SaveLoad(True);
  End;
  GameOver;
End;