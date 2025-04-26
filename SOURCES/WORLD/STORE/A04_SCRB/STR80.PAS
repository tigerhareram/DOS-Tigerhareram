Procedure WriteStranka;
Var X,Y:Byte;
    CisloStranky: String;
Begin
  SVGA_ClearPage(ColX[0]); {ColX [0..15] = 16 barevnych fixu barvy 240..255}
  SVGA_Rectangle(0,400,639,479,ColX[15]); {Pouziva se ColX[0] a ColX[15]}

  If Scan_Toggle=True then
  Begin
    Map_WriteSVGAComplet(Buffer[2]);
    SVGA_SprZ(ScanX,ScanY,ScanSizeX1,ScanSizeY1,ScanSizeX2,ScanSizeY2,1,Buffer[2]);
  End;

  If Psani=True then
  Begin
    _Print(10,405,ColX[15],'Alt+Cisla:');

    _Print(10,425,ColX[15],'Û219 ß223 ß223 ß223 Û219');
    _Print(10,445,ColX[15],'Û219 °176 ±177 ²178 Û219');
    _Print(10,465,ColX[15],'Û219 Ü220 Ü220 Ü220 Û219');

    _Print(260,425,ColX[15],'Ú218 Â194 Ä196 ¿191');
    _Print(260,445,ColX[15],'³179 ³179      ³179');
    _Print(260,465,ColX[15],'À192 Á193 Ä196 Ù217');

    _Print(470,425,ColX[15],'É201 Ë203 Í205 »187');
    _Print(470,445,ColX[15],'Ì204 º186      º186');
    _Print(470,465,ColX[15],'È200 Ê202 Í205 ¼188');
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
