Procedure UpdateMainGameScreen1; {nadoba}
Begin
  Blok(0,0,7,199,ColorGreen,Buffer[3]);
  Blok(116,0,123,199,ColorGreen,Buffer[3]);
  Blok(8,192,115,199,ColorGreen,Buffer[3]);
End;


Procedure WriteBrick(X,Y:Word;Typ:Byte);
Begin
  If Typ<8 then WriteBlok(X,Y,160+Typ*12,0,160+Typ*12+11,11,Buffer[1],Buffer[3])
           else WriteBlok(X,Y,160+(Typ-7)*12,12,160+(Typ-7)*12+11,23,Buffer[1],Buffer[3]);
End;


Procedure UpdateMainGameScreen2; {jednotlive kostky}
Var X,Y: Byte;
Begin
  For Y:=0 to 15 do
  For X:=0 to 8 do
  Begin
    Blok(8+X*12,Y*12,8+X*12+11,Y*12+11,ColorBlack,Buffer[3]);
    WriteBrick(8+X*12,Y*12,Brick[Y*9+X].N);
  End;
End;


Procedure UpdateMainGameScreen3; {Score}
Begin
  Blok(170,0,299,15,ColorBlack,Buffer[3]);
  WriteNumber(Buffer[1],160,184,16,16,1,170,0,Score,Buffer[3]);
End;


Procedure UpdateMainGameScreen4; {Level}
Begin
  Blok(170,20,299,35,ColorBlack,Buffer[3]);
  WriteText(Buffer[1],160,136,16,16,1,170,20,'level=',Buffer[3]);
  WriteNumber(Buffer[1],160,184,16,16,1,272,20,Level,Buffer[3]);
End;


Procedure UpdateMainGameScreen5; {Next Brick}
Var I: Byte;
Begin
  Blok(130,0,161,49,ColorBlack,Buffer[3]);
  Ramecek(130,0,161,49,ColorGreen,Buffer[3]);
  For I:=1 to 3 do WriteBrick(140,8+(I-1)*12,NextKostka.B[I].N);
  Blok(130,180,319,195,ColorBlack,Buffer[3]);
  WriteNumber(Buffer[1],160,184,16,16,1,130,180,KostkaCounterAll,Buffer[3]);
End;


Procedure UpdateMainGameScreen6; {Pause}
Begin
  WriteText(Buffer[1],160,136,16,16,1,20,96,'pause',Buffer[3]);
End;


Procedure WriteMainGameScreen;
Begin
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;
