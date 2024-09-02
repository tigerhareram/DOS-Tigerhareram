Procedure Spkr_PlaySound(Cislo: Byte);
Begin
  SND_I:=Cislo;
  clock7:=0;
  sndpl_counter:=0;
  sndpl_stopcount:=SND_Lenght[Cislo];
  sndpl_enable:=True;
End;