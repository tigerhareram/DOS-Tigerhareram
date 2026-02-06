Procedure Spkr_StartGenerator(Freq:Word);
Begin
  GenFreq:=Freq;
  GenPhase:=0;
  GenSmer:=1;
  clock6:=0;
  Generator:=True;
End;
