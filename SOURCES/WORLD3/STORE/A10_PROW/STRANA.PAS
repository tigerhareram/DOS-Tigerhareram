Procedure SkocNaStranku(StranaCis:LongInt;ObrPosX,ObrPosY,X1,Y1,X2,Y2: Word);
Var X,Y: Byte; {textova strana}
Begin
{   SVGA_BarZ(0,0,319,199,ColX[0]); {mapa 320x200}
    Map_WriteSVGASegment(0,200,X1map,Y1map,X2map,Y2map,Rect1map,Rect2map);

    SVGA_SprZ(0,0,0,0,159,199,1,Buffer[3]);             {BMP}

{    SVGA_BarZ(480,0,639,199,ColX[0]);
    Case VisiblePage of
{      0: Begin
          {SVGA_BarZ(480,0,639,199,ColX[0]);}
{         End;
      1: Begin
           SVGA_SprZ(480,0,0,0,159,199,1,Buffer[1]);    {gra1}
{         End;
      2: Begin
           SVGA_SprZ(480,0,160,0,319,199,1,Buffer[1]);  {gra2}
{         End;
      3: Begin
           SVGA_SprZ(480,0,0,0,159,199,1,Buffer[2]);    {gra3}
{         End;
      4: Begin
           SVGA_SprZ(480,0,160,0,319,199,1,Buffer[2]);  {gra4}
{         End;
    End; {Case End}

    For Y:=0 to 24 do                               {vypsani textove stranky}
    For X:=0 to 79 do Begin
                        _Print(X*8,Y*16,ColX[15],Stranka[Y,X]);
                      End;

    MainWorldScreen;                                   {1st screen interface}

    SVGA_WaitRetrace;
    SVGA_FlipPage;                                     {show screen finished}
End;
