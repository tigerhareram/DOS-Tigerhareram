Procedure StartSetup;
Var I,N: Byte;
Begin
  Parta.X:=Parta_StartX;
  Parta.Y:=Parta_StartY;
  Parta.VLese:=False;

  Parta.Pesky:=True;
  Parta.VLodi1:=False;
  Parta.VLodi2:=False;

  Lod1.Obtain:=True;
  Lod1.X:=Lod1_StartX;
  Lod1.Y:=Lod1_StartY;
  Lod1.Smer:=3;

  Lod2.Obtain:=True;
  Lod2.X:=Lod2_StartX;
  Lod2.Y:=Lod2_StartY;
  Lod2.Smer:=3;

  Parta.Vudce:=Player[1].Job-1;

  For I:=0 to 29 do Mapa.Obtain[I]:=False;
  Mapa.Obtain[0]:=True;

  For I:=1 to 4 do
  Begin
    Case Player[I].Job of
      1: Begin {Valecnik}
           Player[I].HPmax:=30;
           Player[I].HP:=30;
         End;
      2: Begin {Zlodej}
           Player[I].HPmax:=24;
           Player[I].HP:=24;
         End;
      3: Begin {Ninja}
           Player[I].HPmax:=28;
           Player[I].HP:=28;
         End;
      4: Begin {Cerny Mag}
           Player[I].HPmax:=20;
           Player[I].HP:=20;
           For N:=0 to 7 do
           Begin
             Player[I].MPmax[N]:=0;
             Player[I].MP[N]:=0;
           End;
         End;
      5: Begin {Bily Mag}
           Player[I].HPmax:=22;
           Player[I].HP:=22;
           For N:=0 to 7 do
           Begin
             Player[I].MPmax[N]:=0;
             Player[I].MP[N]:=0;
           End;
         End;
      6: Begin {Cerveny Mag}
           Player[I].HPmax:=26;
           Player[I].HP:=26;
           For N:=0 to 7 do
           Begin
             Player[I].MPmax[N]:=0;
             Player[I].MP[N]:=0;
           End;
         End;
    End; {Case End}
  End;

  Parta.Gold:=500;
End;