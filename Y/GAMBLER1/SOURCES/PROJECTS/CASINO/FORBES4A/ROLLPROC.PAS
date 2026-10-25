Procedure SetupSymboly(I: Byte);
Begin
  If I=0 then
  Begin
    If Valec[I].SymbolCounter<=MaxSymbolu-4 then
    Begin
      Valec[I].Symbol[0]:=SymbolyA[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyA[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyA[Valec[I].SymbolCounter+2];
      Valec[I].Symbol[3]:=SymbolyA[Valec[I].SymbolCounter+3];
      Valec[I].Symbol[4]:=SymbolyA[Valec[I].SymbolCounter+4];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu-3 then
    Begin
      Valec[I].Symbol[0]:=SymbolyA[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyA[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyA[Valec[I].SymbolCounter+2];
      Valec[I].Symbol[3]:=SymbolyA[Valec[I].SymbolCounter+3];
      Valec[I].Symbol[4]:=SymbolyA[0];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu-2 then
    Begin
      Valec[I].Symbol[0]:=SymbolyA[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyA[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyA[Valec[I].SymbolCounter+2];
      Valec[I].Symbol[3]:=SymbolyA[0];
      Valec[I].Symbol[4]:=SymbolyA[1];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu-1 then
    Begin
      Valec[I].Symbol[0]:=SymbolyA[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyA[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyA[0];
      Valec[I].Symbol[3]:=SymbolyA[1];
      Valec[I].Symbol[4]:=SymbolyA[2];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu then
    Begin
      Valec[I].Symbol[0]:=SymbolyA[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyA[0];
      Valec[I].Symbol[2]:=SymbolyA[1];
      Valec[I].Symbol[3]:=SymbolyA[2];
      Valec[I].Symbol[4]:=SymbolyA[3];
    End;
  End;

  If I=1 then
  Begin
    If Valec[I].SymbolCounter<=MaxSymbolu-4 then
    Begin
      Valec[I].Symbol[0]:=SymbolyB[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyB[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyB[Valec[I].SymbolCounter+2];
      Valec[I].Symbol[3]:=SymbolyB[Valec[I].SymbolCounter+3];
      Valec[I].Symbol[4]:=SymbolyB[Valec[I].SymbolCounter+4];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu-3 then
    Begin
      Valec[I].Symbol[0]:=SymbolyB[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyB[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyB[Valec[I].SymbolCounter+2];
      Valec[I].Symbol[3]:=SymbolyB[Valec[I].SymbolCounter+3];
      Valec[I].Symbol[4]:=SymbolyB[0];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu-2 then
    Begin
      Valec[I].Symbol[0]:=SymbolyB[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyB[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyB[Valec[I].SymbolCounter+2];
      Valec[I].Symbol[3]:=SymbolyB[0];
      Valec[I].Symbol[4]:=SymbolyB[1];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu-1 then
    Begin
      Valec[I].Symbol[0]:=SymbolyB[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyB[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyB[0];
      Valec[I].Symbol[3]:=SymbolyB[1];
      Valec[I].Symbol[4]:=SymbolyB[2];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu then
    Begin
      Valec[I].Symbol[0]:=SymbolyB[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyB[0];
      Valec[I].Symbol[2]:=SymbolyB[1];
      Valec[I].Symbol[3]:=SymbolyB[2];
      Valec[I].Symbol[4]:=SymbolyB[3];
    End;
  End;

  If I=2 then
  Begin
    If Valec[I].SymbolCounter<=MaxSymbolu-4 then
    Begin
      Valec[I].Symbol[0]:=SymbolyC[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyC[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyC[Valec[I].SymbolCounter+2];
      Valec[I].Symbol[3]:=SymbolyC[Valec[I].SymbolCounter+3];
      Valec[I].Symbol[4]:=SymbolyC[Valec[I].SymbolCounter+4];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu-3 then
    Begin
      Valec[I].Symbol[0]:=SymbolyC[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyC[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyC[Valec[I].SymbolCounter+2];
      Valec[I].Symbol[3]:=SymbolyC[Valec[I].SymbolCounter+3];
      Valec[I].Symbol[4]:=SymbolyC[0];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu-2 then
    Begin
      Valec[I].Symbol[0]:=SymbolyC[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyC[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyC[Valec[I].SymbolCounter+2];
      Valec[I].Symbol[3]:=SymbolyC[0];
      Valec[I].Symbol[4]:=SymbolyC[1];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu-1 then
    Begin
      Valec[I].Symbol[0]:=SymbolyC[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyC[Valec[I].SymbolCounter+1];
      Valec[I].Symbol[2]:=SymbolyC[0];
      Valec[I].Symbol[3]:=SymbolyC[1];
      Valec[I].Symbol[4]:=SymbolyC[2];
    End;

    If Valec[I].SymbolCounter=MaxSymbolu then
    Begin
      Valec[I].Symbol[0]:=SymbolyC[Valec[I].SymbolCounter+0];
      Valec[I].Symbol[1]:=SymbolyC[0];
      Valec[I].Symbol[2]:=SymbolyC[1];
      Valec[I].Symbol[3]:=SymbolyC[2];
      Valec[I].Symbol[4]:=Symbolyc[3];
    End;
  End;

End;


Procedure RollProc;
Var I: Byte;
Begin
  For I:=0 to 2 do
  Begin
    If Valec[I].Rotate=True then
    Begin
      If Valec[I].Counter>0 then Dec(Valec[I].Counter)
                            else Begin
                                   Valec[I].Rotate:=False;
                                   If DatRec.SBEnable=True then SBPlayRaw(48)
                                                           else PlaySound(11+SoundValce);
                                   Inc(SoundValce);
                                 End;

      If Valec[I].Scroll<23 then Inc(Valec[I].Scroll)
                            else Valec[I].Scroll:=0;

      If Valec[I].Scroll=0 then
      Begin
        If Valec[I].SymbolCounter>0 then Dec(Valec[I].SymbolCounter)
                                    else Valec[I].SymbolCounter:=MaxSymbolu;
        SetupSymboly(I);
      End;
    End;

    If ((Valec[0].Rotate=False) and
        (Valec[1].Rotate=False) and
        (Valec[2].Rotate=False)) then AllStoped:=True;
  End;

If DatRec.Svetla=True then
Begin

If Light3>0 then Dec(Light3);

If DatRec.ModSpinu=0 then
Begin
Case DatRec.SpinHelper of
0: Begin
     Case Light3 of
      1980: Light1:=0;
      1960: Light1:=1;
      1940: Light1:=2;
      1920: Light1:=3;
      1900: Light1:=4;
      1880: Light1:=3;
      1860: Light1:=2;
      1840: Light1:=1;
      1820: Light1:=0;
      1800: Light1:=1;
      1780: Light1:=2;
      1760: Light1:=3;
      1740: Light1:=4;
      1720: Light1:=3;
      1700: Light1:=2;
      1680: Light1:=1;
      1660: Light1:=0;
     End; {Case End}
   End;

1: Begin
     Case Light3 of
      1380: Light1:=0;
      1360: Light1:=1;
      1340: Light1:=2;
      1320: Light1:=3;
      1300: Light1:=4;
      1280: Light1:=3;
      1260: Light1:=2;
      1240: Light1:=1;
      1220: Light1:=0;
      1200: Light1:=1;
      1180: Light1:=2;
      1160: Light1:=3;
      1140: Light1:=4;
      1120: Light1:=3;
      1100: Light1:=2;
      1080: Light1:=1;
      1060: Light1:=0;
     End; {Case End}
   End;

2: Begin
     Case Light3 of
      780: Light1:=0;
      760: Light1:=1;
      740: Light1:=2;
      720: Light1:=3;
      700: Light1:=4;
      680: Light1:=3;
      660: Light1:=2;
      640: Light1:=1;
      620: Light1:=0;
      600: Light1:=1;
      580: Light1:=2;
      560: Light1:=3;
      540: Light1:=4;
      520: Light1:=3;
      500: Light1:=2;
      480: Light1:=1;
      460: Light1:=0;
     End; {Case End}
   End;

3: Begin
     Case Light3 of
      185: Light1:=0;
      180: Light1:=1;
      175: Light1:=2;
      170: Light1:=3;
      165: Light1:=4;
      160: Light1:=3;
      155: Light1:=2;
      150: Light1:=1;
      145: Light1:=0;
      140: Light1:=1;
      135: Light1:=2;
      130: Light1:=3;
      125: Light1:=4;
      120: Light1:=3;
      115: Light1:=2;
      110: Light1:=1;
      100: Light1:=0;
     End; {Case End}
   End;
End; {Case End}
End else
    Begin
      Case Light3 of
      185: Light1:=0;
      180: Light1:=1;
      175: Light1:=2;
      170: Light1:=3;
      165: Light1:=4;
      160: Light1:=3;
      155: Light1:=2;
      150: Light1:=1;
      145: Light1:=0;
      140: Light1:=1;
      135: Light1:=2;
      130: Light1:=3;
      125: Light1:=4;
      120: Light1:=3;
      115: Light1:=2;
      110: Light1:=1;
      100: Light1:=0;
      End; {Case End}
End;

  If StopButton[0].Mark=False then LightJ:=Light1;
  If StopButton[1].Mark=False then LightK:=Light1;
  If StopButton[2].Mark=False then LightL:=Light1;

  Case SymbolLightSmer of
    0: If SymbolLight<3 then Inc(SymbolLight) else SymbolLightSmer:=1;
    1: If SymbolLight>0 then Dec(SymbolLight) else SymbolLightSmer:=0;
  End; {Case End}

End;

  If Linie[0].Counter<Linie[0].Step
  then Inc(Linie[0].Counter)
  else Begin
         Linie[0].Counter:=0;
         If Linie[0].CT2<=5 then Inc(Linie[0].CT2);
         Linie[0].Indicator[Linie[0].CT2]:=1;
         Linie[1].Indicator[Linie[0].CT2]:=1;
      End;
End;