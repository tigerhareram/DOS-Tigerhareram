Function PreStep: Boolean;
Begin
  PreStep:=True;

  If Parta.Pesky=True then
  Begin
    Case Parta.Smer of
      0: Begin
           If GetPole(Parta.X,Parta.Y+16)=0 then PreStep:=False;
           If GetPole(Parta.X,Parta.Y+16)>=128 then PreStep:=False;
           If TestVLese2(Parta.X,Parta.Y+16)=False then Parta.VLese:=False;
           If TestBudeLod=True then
           Begin
             If Lod1.Obtain=True then PreStep:=True
                                 else PreStep:=False;
           End
         End;
      1: Begin
           If GetPole(Parta.X,Parta.Y-16)=0 then PreStep:=False;
           If GetPole(Parta.X,Parta.Y-16)>=128 then PreStep:=False;
           If TestVLese2(Parta.X,Parta.Y-16)=False then Parta.VLese:=False;
           If TestBudeLod=True then
           Begin
             If Lod1.Obtain=True then PreStep:=True
                                 else PreStep:=False;
           End
         End;
      2: Begin
           If GetPole(Parta.X+16,Parta.Y)=0 then PreStep:=False;
           If GetPole(Parta.X+16,Parta.Y)>=128 then PreStep:=False;
           If TestVLese2(Parta.X+16,Parta.Y)=False then Parta.VLese:=False;
           If TestBudeLod=True then
           Begin
             If Lod1.Obtain=True then PreStep:=True
                                 else PreStep:=False;
           End
         End;
      3: Begin
           If GetPole(Parta.X-16,Parta.Y)=0 then PreStep:=False;
           If GetPole(Parta.X-16,Parta.Y)>=128 then PreStep:=False;
           If TestVLese2(Parta.X-16,Parta.Y)=False then Parta.VLese:=False;
           If TestBudeLod=True then
           Begin
             If Lod1.Obtain=True then PreStep:=True
                                 else PreStep:=False;
           End
         End;
    End; {Case End}
  End;

  If (Parta.VLodi1=True) and
     (Parta.X>=16) and (Parta.X<5104) and
     (Parta.Y>=16) and (Parta.Y<3184) then
  Begin
    Case Parta.Smer of
      0: Begin
           If GetPole(Parta.X,Parta.Y+16)>0 then PreStep:=False;
           If GetPole(Parta.X,Parta.Y+16)=80 then Begin
                                                    PreStep:=True;
                                                    Parta.VLodi1:=False;
                                                    Parta.Pesky:=True;
                                                  End;
         End;
      1: Begin
           If GetPole(Parta.X,Parta.Y-16)>0 then PreStep:=False;
           If GetPole(Parta.X,Parta.Y-16)=110 then Begin
                                                     PreStep:=True;
                                                     Parta.VLodi1:=False;
                                                     Parta.Pesky:=True;
                                                   End;
         End;
      2: Begin
           If GetPole(Parta.X+16,Parta.Y)>0 then PreStep:=False;
           If GetPole(Parta.X+16,Parta.Y)=90 then Begin
                                                    PreStep:=True;
                                                    Parta.VLodi1:=False;
                                                    Parta.Pesky:=True;
                                                  End;
         End;
      3: Begin
           If GetPole(Parta.X-16,Parta.Y)>0 then PreStep:=False;
           If GetPole(Parta.X-16,Parta.Y)=100 then Begin
                                                     PreStep:=True;
                                                     Parta.VLodi1:=False;
                                                     Parta.Pesky:=True;
                                                   End;
         End;
    End; {Case End}
  End;

  If Parta.VLodi2=True then
  Begin
  End;

End;