Procedure SoundStorno;
Var I,A:Word;
Begin
  A:=350;
  For I:=0 to 3 do
  Begin
    Sound(A);
    Wait(20);
    Silence;
    Dec(A,50);
  End;
End;


Procedure SoundDone;
Var I,A:Word;
Begin
  A:=200;
  For I:=0 to 5 do
  Begin
    Sound(A);
    Wait(20);
    Silence;
    Inc(A,50);
  End;
End;
