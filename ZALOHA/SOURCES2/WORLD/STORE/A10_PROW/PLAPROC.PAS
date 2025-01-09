Procedure PlanetProc(planeta,mesic: Word);
Var i : Byte;
    r: Byte;
    z: Byte;
Begin
  for i:=9 to 120 do StopSound(i);
  r:=Random(8);
  if Planeta=0
               then Begin
                    StartSound(ZvukRaw[9+r],9+r,True);      {merkur}
                    z:=9+r;
                    End;
  if Planeta=1
               then Begin
                    StartSound(ZvukRaw[17+r],17+r,True);    {venuse}
                    z:=17+r;
                    End;
  if ((Planeta=2) or (Planeta=3))
               then Begin
                    StartSound(ZvukRaw[25+r],25+r,True);    {zeme}
                    z:=25+r;
                    End;
  if ((Planeta=4) or (Planeta=5) or (Planeta=6))
               then Begin
                    StartSound(ZvukRaw[33+r],33+r,True);    {mars}
                    z:=33+r;
                    End;
  if ((Planeta>=7) and (Planeta<=69))
               then Begin
                    StartSound(ZvukRaw[41+r],41+r,True);    {jupiter}
                    z:=41+r;
                    End;
  if ((Planeta>=70) and (Planeta<=120))
               then Begin
                    StartSound(ZvukRaw[49+r],49+r,True);    {saturn}
                    z:=49+r;
                    End;
  if ((Planeta>=121) and (Planeta<=147))
               then Begin
                    StartSound(ZvukRaw[57+r],57+r,True);    {uran}
                    z:=57+r;
                    End;
  if ((Planeta>=148) and (Planeta<=161))
               then Begin
                    StartSound(ZvukRaw[65+r],65+r,True);    {neptune}
                    z:=65+r;
                    End;
  if ((Planeta>=162) and (Planeta<=167))
               then Begin
                    StartSound(ZvukRaw[73+r],73+r,True);    {pluto}
                    z:=73+r;
                    End;
  if ((Planeta>=168) and (Planeta<=170))
               then Begin
                    StartSound(ZvukRaw[81+r],81+r,True);    {haumea}
                    z:=81+r;
                    End;
  if ((Planeta>=171) and (Planeta<=172))
               then Begin
                    StartSound(ZvukRaw[89+r],89+r,True);    {eris}
                    z:=89+r;
                    End;
  if ((Planeta>=173) and (Planeta<=253))
               then Begin
                    r:=Random(24);
                    StartSound(ZvukRaw[97+r],97+r,True);    {LEGO}
                    z:=97+r;
                    End;

  PlanetScreen(planeta,mesic);
  WriterPlanet(15,0);

  If Key[1]=1 then Kbd_RPush(1);
  If Key[31]=1 then Kbd_RPush(31);

  StopSound(z);
End;