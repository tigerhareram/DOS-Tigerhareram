Function TestBudeLod: Boolean;
Begin
  Case Parta.Smer of
    0: Begin
         If ((Lod1.X=Parta.X) and (Lod1.Y=Parta.Y+16)) then TestBudeLod:=True
                                                       else TestBudeLod:=False;
       End;
    1: Begin
         If ((Lod1.X=Parta.X) and (Lod1.Y=Parta.Y-16)) then TestBudeLod:=True
                                                       else TestBudeLod:=False;
       End;
    2: Begin
         If ((Lod1.X=Parta.X+16) and (Lod1.Y=Parta.Y)) then TestBudeLod:=True
                                                       else TestBudeLod:=False;
       End;
    3: Begin
         If ((Lod1.X=Parta.X-16) and (Lod1.Y=Parta.Y)) then TestBudeLod:=True
                                                       else TestBudeLod:=False;
       End;
  End;
End;