Procedure StepMain1;
Begin
  If Step.StepCounter2<7 then Inc(Step.StepCounter2)
                          else Begin
                                 Step.StepCounter2:=0;
                                 Parta.Krok:=False;
                                 PostStep;
                               End;
End;


Procedure StepMain2;
Begin
  If Step.StepCounter3<3 then Inc(Step.StepCounter3)
                          else Begin
                                 Step.StepCounter3:=0;
                                 Parta.Krok:=False;
                                 PostStep;
                               End;
End;


Procedure StepMain3;
Begin
  If Step.StepCounter4<1 then Inc(Step.StepCounter4)
                          else Begin
                                 Step.StepCounter4:=0;
                                 Parta.Krok:=False;
                                 PostStep;
                               End;
End;


Procedure StepMain;
Begin
  If ((Parta.Pesky=True) and (Parta.Krok=True)) then
  Begin
    If Parta.Frame=0 then Parta.Frame:=1
                     else Parta.Frame:=0;
    Case Parta.Smer of
      0: Begin
           If Parta.Y<3198 then Inc(Parta.Y,2) else Parta.Y:=0;
           If Mapa.Yview<3198 then Inc(Mapa.Yview,2) else Mapa.Yview:=0;
         End;
      1: Begin
           If Parta.Y>0 then Dec(Parta.Y,2) else Parta.Y:=3198;
           If Mapa.Yview>0 then Dec(Mapa.Yview,2) else Mapa.Yview:=3198;
         End;
      2: Begin
           If Parta.X<5118 then Inc(Parta.X,2) else Parta.X:=0;
           If Mapa.Xview<5118 then Inc(Mapa.Xview,2) else Mapa.Xview:=0;
         End;
      3: Begin
           If Parta.X>0 then Dec(Parta.X,2) else Parta.X:=5118;
           If Mapa.Xview>0 then Dec(Mapa.Xview,2) else Mapa.Xview:=5118;
         End;
    End; {Case End}
    StepMain1;
  End;

  If ((Parta.VLodi1=True) and (Parta.Krok=True)) then
  Begin
    If Parta.Frame=0 then Parta.Frame:=1
                     else Parta.Frame:=0;
    Case Parta.Smer of
      0: Begin
           If Parta.Y<3196 then Inc(Parta.Y,4) else Parta.Y:=0;
           If Lod1.Y<3196 then Inc(Lod1.Y,4) else Lod1.Y:=0;
           If Mapa.Yview<3196 then Inc(Mapa.Yview,4) else Mapa.Yview:=0;
         End;
      1: Begin
           If Parta.Y>0 then Dec(Parta.Y,4) else Parta.Y:=3196;
           If Lod1.Y>0 then Dec(Lod1.Y,4) else Lod1.Y:=3196;
           If Mapa.Yview>0 then Dec(Mapa.Yview,4) else Mapa.Yview:=3196;
         End;
      2: Begin
           If Parta.X<5116 then Inc(Parta.X,4) else Parta.X:=0;
           If Lod1.X<5116 then Inc(Lod1.X,4) else Lod1.X:=0;
           If Mapa.Xview<5116 then Inc(Mapa.Xview,4) else Mapa.Xview:=0;
         End;
      3: Begin
           If Parta.X>0 then Dec(Parta.X,4) else Parta.X:=5116;
           If Lod1.X>0 then Dec(Lod1.X,4) else Lod1.X:=5116;
           If Mapa.Xview>0 then Dec(Mapa.Xview,4) else Mapa.Xview:=5116;
         End;
    End; {Case End}
    StepMain2;
  End;

  If ((Parta.VLodi2=True) and (Parta.Krok=True)) then
  Begin
    Case Parta.Smer of
      0: Begin
           If Parta.Y<3192 then Inc(Parta.Y,8) else Parta.Y:=0;
           If Lod2.Y<3192 then Inc(Lod2.Y,8) else Lod2.Y:=0;
           If Mapa.Yview<3192 then Inc(Mapa.Yview,8) else Mapa.Yview:=0;
         End;
      1: Begin
           If Parta.Y>0 then Dec(Parta.Y,8) else Parta.Y:=3192;
           If Lod2.Y>0 then Dec(Lod2.Y,8) else Lod2.Y:=3192;
           If Mapa.Yview>0 then Dec(Mapa.Yview,8) else Mapa.Yview:=3192;
         End;
      2: Begin
           If Parta.X<5112 then Inc(Parta.X,8) else Parta.X:=0;
           If Lod2.X<5112 then Inc(Lod2.X,8) else Lod2.X:=0;
           If Mapa.Xview<5112 then Inc(Mapa.Xview,8) else Mapa.Xview:=0;
         End;
      3: Begin
           If Parta.X>0 then Dec(Parta.X,8) else Parta.X:=5112;
           If Lod2.X>0 then Dec(Lod2.X,8) else Lod2.X:=5112;
           If Mapa.Xview>0 then Dec(Mapa.Xview,8) else Mapa.Xview:=5112;
         End;
    End; {Case End}
    StepMain3;
  End;
End;
