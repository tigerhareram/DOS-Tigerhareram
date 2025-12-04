Procedure SetDefaults;
Var I: Byte;
Begin
  TABGrafika:=False;
  TABGrafikaG0:=True;
  TABGrafikaG1:=False;
  TABGrafikaG2:=False;
  TABGrafikaG3:=False;
  TABZvuky:=False;
  ZvukIndex:=0;
  ZvukSelect:=0;
  ZvukSelect1:=0;
  ZvukY:=0;
  TABZacatky:=True;
  TABDelky:=False;
  TABMelodie:=False;
  NastrojDrum:=0;
  DrumNote:=35;
  SetKanalVolume(9,127);
  SetKanalVolume(1,127);
  SetKanalVolume(2,127);
  SetKanalVolume(3,127);
  SetKanalVolume(4,127);
  SetKanalVolume(5,127);
  SetKanalVolume(6,127);
  SetKanalVolume(7,127);
  MezeraCounter:=1;
  Melody.Tempo:=5;
  For I:=0 to 7 do RepNum[I]:=0;
  filename:='none';
  filenametext:='none';
  filenameBMP:='none';
  ImportBarva1:=16;
  ImportBarva2:=17;
  ImportBarva3:=18;
  readname:='';
  Setpal(253,63,63,63); {White}
  Setpal(254,0,0,0); {Black}
  Setpal(250,63,0,0); {Red}
  Setpal(251,0,63,0); {Green}
  Setpal(252,0,0,63); {Blue}
  Setpal(249,0,25,0); {Green A}
  Setpal(248,0,18,0); {Green B}
  Setpal(247,15,40,10); {Green C}
  Setpal(246,60,25,25); {Red}
  X4B:=0; Y4B:=0;
  X4B1:=0; Y4B1:=0;
  Xe:=0; Ye:=0;
  Xe1:=0; Ye1:=0;
  Xs1:=0; Ys1:=0;
  For I:=0 to 63 do Schranka[I]:=0;
  For I:=0 to 3 do Schranka4Barvy[I]:=0;
  MouseColor:=0;
  MouseX:=160;
  MouseY:=0;
End;