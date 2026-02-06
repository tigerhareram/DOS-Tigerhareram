Procedure LoadSounds;
Begin
  LoadRawFile('blip.raw',0,0);
  LoadRawFile('bullet.raw',0,1);
  LoadRawFile('police.raw',0,2);
  LoadRawFile('yeeha.raw',0,3);
  LoadSndFile('forbes.snd',0);
  PlaySound(5);
End;