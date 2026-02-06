Procedure RollSetup;
Var I: Byte;
Begin
  Dec(Credit,Sazka);
  StopPlay;
  PlayRaw(0);
  WriteAutomatScreen;
  Vyhra:=0;
  Valec[0].Counter:=319+(Random(3)*32);
  Valec[1].Counter:=447+(Random(3)*32);
  Valec[2].Counter:=575+(Random(3)*32);
  WinCoreSetup;
  If Korigovat2=True then WinCore; {!! korekce vyher !!}
  For I:=0 to 2 do
  Begin
    Valec[I].Scroll:=0;
    Valec[I].Rotate:=True;
    Valec[I].SlowMotion:=False;
    Valec[I].SlowCounter1:=0;
    Valec[I].SlowCounter2:=0;
  End;
  For I:=1 to 5 do WinConf.Vyhra[I]:=False;
  For I:=1 to 9 do WinConf.Symbol[I]:=0;
  If RollCounter<BulletTimeConst then Inc(RollCounter)
                                 else RollCounter:=0;
End;
