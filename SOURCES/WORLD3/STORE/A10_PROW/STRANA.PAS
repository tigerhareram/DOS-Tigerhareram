Procedure SkocNaStranku(StranaCis:LongInt;ObrPosX,ObrPosY,X1,Y1,X2,Y2: Word);
Var X,Y: Byte; {textova strana}
Begin
    MainWorldScreen;                                   {1st screen interface}

    Map_WriteSVGAComplet(Buffer[1]);                 {from Buffer1 to screen}

    For Y:=0 to 24 do                               {vypsani textove stranky}
    For X:=0 to 79 do Begin
                        _Print(X*8,Y*16,ColX[15],Stranka[Y,X]);
                      End;

    SVGA_WaitRetrace;
    SVGA_FlipPage;                                     {show screen finished}
End;
