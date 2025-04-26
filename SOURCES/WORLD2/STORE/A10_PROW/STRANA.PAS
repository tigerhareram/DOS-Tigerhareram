Procedure SkocNaStranku(StranaCis:LongInt;ObrPosX,ObrPosY,X1,Y1,X2,Y2: Word);
Var textova: String;
    obrazek: String;
    mapova: String;
    grafile1: String;
    grafile2: String;
    grafile3: String;
    grafile4: String;
Begin
    Case StranaCis of
      001 : Begin textova:='KNIHOVNA\001.txt';
                  obrazek:='KNIHOVNA\001.bmp';
                  mapova:='KNIHOVNA\001.map';
                  grafile1:='KNIHOVNA\001a.gra';
                  grafile2:='KNIHOVNA\001b.gra';
                  grafile3:='KNIHOVNA\001c.gra';
                  grafile4:='KNIHOVNA\001d.gra'; End;

      002 : Begin textova:='KNIHOVNA\002.txt';
                  obrazek:='KNIHOVNA\002.bmp';
                  mapova:='KNIHOVNA\002.map';
                  grafile1:='KNIHOVNA\002a.gra';
                  grafile2:='KNIHOVNA\002b.gra';
                  grafile3:='KNIHOVNA\002c.gra';
                  grafile4:='KNIHOVNA\002d.gra'; End;

      003 : Begin textova:='KNIHOVNA\003.txt';
                  obrazek:='KNIHOVNA\003.bmp';
                  mapova:='KNIHOVNA\003.map';
                  grafile1:='KNIHOVNA\003a.gra';
                  grafile2:='KNIHOVNA\003b.gra';
                  grafile3:='KNIHOVNA\003c.gra';
                  grafile4:='KNIHOVNA\003d.gra'; End;

      004 : Begin textova:='KNIHOVNA\004.txt';
                  obrazek:='KNIHOVNA\004.bmp';
                  mapova:='KNIHOVNA\004.map';
                  grafile1:='KNIHOVNA\004a.gra';
                  grafile2:='KNIHOVNA\004b.gra';
                  grafile3:='KNIHOVNA\004c.gra';
                  grafile4:='KNIHOVNA\004d.gra'; End;

      005 : Begin textova:='KNIHOVNA\005.txt';
                  obrazek:='KNIHOVNA\005.bmp';
                  mapova:='KNIHOVNA\005.map';
                  grafile1:='KNIHOVNA\005a.gra';
                  grafile2:='KNIHOVNA\005b.gra';
                  grafile3:='KNIHOVNA\005c.gra';
                  grafile4:='KNIHOVNA\005d.gra'; End;

      006 : Begin textova:='KNIHOVNA\006.txt';
                  obrazek:='KNIHOVNA\006.bmp';
                  mapova:='KNIHOVNA\006.map';
                  grafile1:='KNIHOVNA\006a.gra';
                  grafile2:='KNIHOVNA\006b.gra';
                  grafile3:='KNIHOVNA\006c.gra';
                  grafile4:='KNIHOVNA\006d.gra'; End;
    End;

    LoadGRAFile(grafile1,0,1);                        {LAYER GRA1}
    VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);        {LOAD}

{    LoadGRAFile(grafile2,0,2);                       {LAYER GRA2}
{    VGA_SprZ(160,0,0,0,159,199,1,Buffer[3],Buffer[1]);     {LOAD}

{    LoadGRAFile(grafile3,0,3);                       {LAYER GRA3}
{    VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[2]);       {LOAD}

{    LoadGRAFile(grafile4,0,4);                       {LAYER GRA4}
{    VGA_SprZ(160,0,0,0,159,199,1,Buffer[3],Buffer[2]);     {LOAD}

    MainWorldScreen;                        {1st screen interface}

    LoadMAPFile(mapova,0);                {LAYER MAP EXPERIMENTAL}
    Map_WriteSVGAComplet(Buffer[3]);

    Str80BMP(obrazek,ObrPosX,ObrPosY,X1,Y1,X2,Y2);     {LAYER BMP}

    Str80(textova);                                    {LAYER TXT}

    SVGA_WaitRetrace;
    SVGA_FlipPage;                                 {show screen finished}
End;
