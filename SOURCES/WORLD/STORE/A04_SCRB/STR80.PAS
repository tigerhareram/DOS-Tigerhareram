Procedure WriteStranka;
Var X,Y:Byte;
    CisloStranky: String;
Begin
  SVGA_ClearPage(ColX[0]); {ColX [0..15] = 16 barevnych fixu barvy 240..255}
  SVGA_Rectangle(0,400,639,479,ColX[15]); {Pouziva se ColX[0] a ColX[15]}

  If Psani=True then
  Begin
    _Print(10,410,ColX[15],'Alt+Cisla:');

    _Print(115,410,ColX[15],'Ú 218'); _Print(175,410,ColX[15],'Â 194'); _Print(235,410,ColX[15],'¿ 191');
    _Print(115,430,ColX[15],'Ã 195'); _Print(175,430,ColX[15],'Å 197'); _Print(235,430,ColX[15],'´ 180');
    _Print(115,450,ColX[15],'À 192'); _Print(175,450,ColX[15],'Á 193'); _Print(235,450,ColX[15],'Ù 217');

    _Print(295,410,ColX[15],'³ 179');
    _Print(295,430,ColX[15],'Ä 196');

    _Print(400,410,ColX[15],'É 201'); _Print(460,410,ColX[15],'Ë 203'); _Print(520,410,ColX[15],'» 187');
    _Print(400,430,ColX[15],'Ì 204'); _Print(460,430,ColX[15],'Î 206'); _Print(520,430,ColX[15],'¹ 185');
    _Print(400,450,ColX[15],'È 200'); _Print(460,450,ColX[15],'Ê 202'); _Print(520,450,ColX[15],'¼ 188');

    _Print(580,410,ColX[15],'Í 205');
    _Print(580,430,ColX[15],'º 186');
  End;

  If Cteni=True then
  Begin
    _Print(10,410,ColX[15],'<<<');
    _Print(276,410,ColX[15],'LISTOVANI');
    Str(SouborKnih+1,CisloStranky);
    _Print(10,456,ColX[15],CisloStranky);
    _Print(598,410,ColX[15],'>>>');
  End;

  For Y:=0 to 24 do
  For X:=0 to 79 do Begin
                      _Print(X*8,Y*16,ColX[15],Stranka[Y,X]);
                    End;
End;


Procedure WriteStrankaChat(Y1:Word);
Var X,Y:Byte;
    CisloStranky: String;
Begin
  SVGA_BarZ(0,Y1,639,Y1+79,ColX[0]);         {black}

  For Y:=0 to 4 do
  For X:=0 to 79 do Begin
                      _Print(X*8,Y1+Y*16,ColX[15],Stranka2[Y,X]);
                    End;

  SVGA_Rectangle(0,165,639,479,ColX[15]);
End;


Procedure WriteStrankaPlanet(Y1:Word);
Var X,Y:Byte;
    CisloStranky: String;
Begin
  SVGA_BarZ(0,Y1,319,Y1+319,ColX[0]);         {black}

  For Y:=0 to 19 do
  For X:=0 to 39 do Begin
                      _Print(X*8,Y1+Y*16,ColX[15],Stranka3[Y,X]);
                    End;

  SVGA_Rectangle(0,Y1,319,Y1+319,ColX[15]);      {levy panel}
End;
