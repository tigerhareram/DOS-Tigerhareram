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

      007 : Begin textova:='KNIHOVNA\007.txt';
                  obrazek:='KNIHOVNA\007.bmp';
                  mapova:='KNIHOVNA\007.map';
                  grafile1:='KNIHOVNA\007a.gra';
                  grafile2:='KNIHOVNA\007b.gra';
                  grafile3:='KNIHOVNA\007c.gra';
                  grafile4:='KNIHOVNA\007d.gra'; End;

      008 : Begin textova:='KNIHOVNA\008.txt';
                  obrazek:='KNIHOVNA\008.bmp';
                  mapova:='KNIHOVNA\008.map';
                  grafile1:='KNIHOVNA\008a.gra';
                  grafile2:='KNIHOVNA\008b.gra';
                  grafile3:='KNIHOVNA\008c.gra';
                  grafile4:='KNIHOVNA\008d.gra'; End;

      009 : Begin textova:='KNIHOVNA\009.txt';
                  obrazek:='KNIHOVNA\009.bmp';
                  mapova:='KNIHOVNA\009.map';
                  grafile1:='KNIHOVNA\009a.gra';
                  grafile2:='KNIHOVNA\009b.gra';
                  grafile3:='KNIHOVNA\009c.gra';
                  grafile4:='KNIHOVNA\009d.gra'; End;

      010 : Begin textova:='KNIHOVNA\010.txt';
                  obrazek:='KNIHOVNA\010.bmp';
                  mapova:='KNIHOVNA\010.map';
                  grafile1:='KNIHOVNA\010a.gra';
                  grafile2:='KNIHOVNA\010b.gra';
                  grafile3:='KNIHOVNA\010c.gra';
                  grafile4:='KNIHOVNA\010d.gra'; End;

      011 : Begin textova:='KNIHOVNA\011.txt';
                  obrazek:='KNIHOVNA\011.bmp';
                  mapova:='KNIHOVNA\011.map';
                  grafile1:='KNIHOVNA\011a.gra';
                  grafile2:='KNIHOVNA\011b.gra';
                  grafile3:='KNIHOVNA\011c.gra';
                  grafile4:='KNIHOVNA\011d.gra'; End;

      012 : Begin textova:='KNIHOVNA\012.txt';
                  obrazek:='KNIHOVNA\012.bmp';
                  mapova:='KNIHOVNA\012.map';
                  grafile1:='KNIHOVNA\012a.gra';
                  grafile2:='KNIHOVNA\012b.gra';
                  grafile3:='KNIHOVNA\012c.gra';
                  grafile4:='KNIHOVNA\012d.gra'; End;

      013 : Begin textova:='KNIHOVNA\013.txt';
                  obrazek:='KNIHOVNA\013.bmp';
                  mapova:='KNIHOVNA\013.map';
                  grafile1:='KNIHOVNA\013a.gra';
                  grafile2:='KNIHOVNA\013b.gra';
                  grafile3:='KNIHOVNA\013c.gra';
                  grafile4:='KNIHOVNA\013d.gra'; End;

      014 : Begin textova:='KNIHOVNA\014.txt';
                  obrazek:='KNIHOVNA\014.bmp';
                  mapova:='KNIHOVNA\014.map';
                  grafile1:='KNIHOVNA\014a.gra';
                  grafile2:='KNIHOVNA\014b.gra';
                  grafile3:='KNIHOVNA\014c.gra';
                  grafile4:='KNIHOVNA\014d.gra'; End;

      015 : Begin textova:='KNIHOVNA\015.txt';
                  obrazek:='KNIHOVNA\015.bmp';
                  mapova:='KNIHOVNA\015.map';
                  grafile1:='KNIHOVNA\015a.gra';
                  grafile2:='KNIHOVNA\015b.gra';
                  grafile3:='KNIHOVNA\015c.gra';
                  grafile4:='KNIHOVNA\015d.gra'; End;

      016 : Begin textova:='KNIHOVNA\016.txt';
                  obrazek:='KNIHOVNA\016.bmp';
                  mapova:='KNIHOVNA\016.map';
                  grafile1:='KNIHOVNA\016a.gra';
                  grafile2:='KNIHOVNA\016b.gra';
                  grafile3:='KNIHOVNA\016c.gra';
                  grafile4:='KNIHOVNA\016d.gra'; End;

      017 : Begin textova:='KNIHOVNA\017.txt';
                  obrazek:='KNIHOVNA\017.bmp';
                  mapova:='KNIHOVNA\017.map';
                  grafile1:='KNIHOVNA\017a.gra';
                  grafile2:='KNIHOVNA\017b.gra';
                  grafile3:='KNIHOVNA\017c.gra';
                  grafile4:='KNIHOVNA\017d.gra'; End;

      018 : Begin textova:='KNIHOVNA\018.txt';
                  obrazek:='KNIHOVNA\018.bmp';
                  mapova:='KNIHOVNA\018.map';
                  grafile1:='KNIHOVNA\018a.gra';
                  grafile2:='KNIHOVNA\018b.gra';
                  grafile3:='KNIHOVNA\018c.gra';
                  grafile4:='KNIHOVNA\018d.gra'; End;

      019 : Begin textova:='KNIHOVNA\019.txt';
                  obrazek:='KNIHOVNA\019.bmp';
                  mapova:='KNIHOVNA\019.map';
                  grafile1:='KNIHOVNA\019a.gra';
                  grafile2:='KNIHOVNA\019b.gra';
                  grafile3:='KNIHOVNA\019c.gra';
                  grafile4:='KNIHOVNA\019d.gra'; End;

      020 : Begin textova:='KNIHOVNA\020.txt';
                  obrazek:='KNIHOVNA\020.bmp';
                  mapova:='KNIHOVNA\020.map';
                  grafile1:='KNIHOVNA\020a.gra';
                  grafile2:='KNIHOVNA\020b.gra';
                  grafile3:='KNIHOVNA\020c.gra';
                  grafile4:='KNIHOVNA\020d.gra'; End;

    End;

    MainWorldScreen;                        {1st screen interface}

    LoadGRAFile(grafile1,0,1);                        {LAYER GRA1}
    VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);        {LOAD}

    LoadMAPFile(mapova,0);                {LAYER MAP EXPERIMENTAL}
    Map_WriteSVGAComplet(Buffer[3]);

    Case VisibleBMP of
      0: Begin
           SVGA_BarZ(0,0,159,199,ColX[0]);
           LoadGRAFile(grafile1,0,1);                      {LAYER GRA1}
           VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);      {LOAD}
           Map_WriteSVGAComplet(Buffer[3]);
         End;
      1: Begin
           LoadMAPFile(mapova,0);         {LAYER MAP EXPERIMENTAL}
           Map_WriteSVGAComplet(Buffer[3]);
           VGA_BarZ(0,0,159,199,ColX[0],Buffer[1]);   {Black Page}
           Str80BMP(obrazek,ObrPosX,ObrPosY,X1,Y1,X2,Y2);
         End;
      {LAYER BMP first !!}
    End; {Case End}

    VGA_BarZ(0,0,159,199,ColX[0],Buffer[1]);         {Black Page}
    LoadGRAFile(grafile1,0,1);                 {LAYER GRA1 again}
    VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);       {LOAD}

    LoadGRAFile(grafile2,0,2);                       {LAYER GRA2}
    VGA_SprZ(160,0,0,0,159,199,1,Buffer[3],Buffer[1]);     {LOAD}

    LoadGRAFile(grafile3,0,3);                       {LAYER GRA3}
    VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[2]);       {LOAD}

    LoadGRAFile(grafile4,0,4);                       {LAYER GRA4}
    VGA_SprZ(160,0,0,0,159,199,1,Buffer[3],Buffer[2]);     {LOAD}

    Case VisiblePage of
      0: Begin {gra a not visible}
           SVGA_BarZ(480,0,639,199,ColX[0]);
           Map_WriteSVGAComplet(Buffer[3]);
           Case VisibleBMP of
            0: Begin
                 SVGA_BarZ(0,0,159,199,ColX[0]);
                 LoadGRAFile(grafile1,0,1);           {LAYER GRA1 again}
                 VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]); {LOAD}
                 Map_WriteSVGAComplet(Buffer[3]);
               End;
            1: Begin
                 LoadGRAFile(grafile1,0,1);           {LAYER GRA1 again}
                 VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]); {LOAD}
                 Map_WriteSVGAComplet(Buffer[3]);
                 VGA_BarZ(0,0,159,199,ColX[0],Buffer[1]);   {Black Page}
                 Str80BMP(obrazek,ObrPosX,ObrPosY,X1,Y1,X2,Y2);
               End;
           End; {Case End}
         End;
      1: Begin SVGA_SprZ(480,0,0,0,159,199,1,Buffer[1]); End; {gra a visible}
      2: Begin SVGA_SprZ(480,0,160,0,319,199,1,Buffer[1]); End; {gra b visible}
      3: Begin SVGA_SprZ(480,0,0,0,159,199,1,Buffer[2]); End; {gra c visible}
      4: Begin SVGA_SprZ(480,0,160,0,319,199,1,Buffer[2]); End; {gra d visible}
    End; {Case End}

    Str80(textova);                              {LAYER TXT last}

    SVGA_WaitRetrace;
    SVGA_FlipPage;                                 {show screen finished}
End;
