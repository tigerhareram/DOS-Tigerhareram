Procedure EnterFile;
Var s,t: string;
    N: Byte;

  Procedure PodProc1; {Text Page 80x25}
  Begin
    Assign(Fi,Cesta);
    Reset(Fi);
    For YFi:=0 to 24 do
    For XFi:=0 to 79 do Read(Fi,stranka[YFi,XFi]);
    Close(Fi);

    setfont(4,1);      {set font sys8x16.chs number 4}
    setcolor(ColX[3]); {set drawing color , texts & lines}
    N:=1;
    For YFi:=0 to 2 do
    Begin
      For XFi:=0 to 79 do writexy(XFi*8,YFi*16,Stranka[YFi,XFi]); {GrafX Stefans text}
    End;
    XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
    XVGA_FlipPage(1,0);
    For YFi:=3 to 5 do
    Begin
      For XFi:=0 to 79 do writexy(XFi*8,YFi*16,Stranka[YFi,XFi]); {GrafX Stefans text}
    End;
    XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
    XVGA_FlipPage(1,0);
    For YFi:=6 to 8 do
    Begin
      For XFi:=0 to 79 do writexy(XFi*8,YFi*16,Stranka[YFi,XFi]); {GrafX Stefans text}
    End;
    XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
    XVGA_FlipPage(1,0);
    For YFi:=9 to 11 do
    Begin
      For XFi:=0 to 79 do writexy(XFi*8,YFi*16,Stranka[YFi,XFi]); {GrafX Stefans text}
    End;
    XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
    XVGA_FlipPage(1,0);
    For YFi:=12 to 14 do
    Begin
      For XFi:=0 to 79 do writexy(XFi*8,YFi*16,Stranka[YFi,XFi]); {GrafX Stefans text}
    End;
    XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
    XVGA_FlipPage(1,0);
    For YFi:=15 to 17 do
    Begin
      For XFi:=0 to 79 do writexy(XFi*8,YFi*16,Stranka[YFi,XFi]); {GrafX Stefans text}
    End;
    XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
    XVGA_FlipPage(1,0);
    For YFi:=18 to 20 do
    Begin
      For XFi:=0 to 79 do writexy(XFi*8,YFi*16,Stranka[YFi,XFi]); {GrafX Stefans text}
    End;
    XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
    XVGA_FlipPage(1,0);
    For YFi:=21 to 24 do
    Begin
      For XFi:=0 to 79 do writexy(XFi*8,YFi*16,Stranka[YFi,XFi]); {GrafX Stefans text}
    End;
    XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]);
    XVGA_FlipPage(1,0);

    setfont(3,1);      {set font number 3}
    setcolor(ColX[1]); {set drawing color , texts & lines}
  End;


Begin
  XVGA_BarZ(0,0,639,399,ColX[0]); {Clear GFX area}
  XVGA_BarZ(240,403,638,410,ColX[0]); {clear loading area}

  Case Ysour of
    0..5: Begin {txt 1-6}
            Str(Xsour+1,s);
            If Xsour+1<10 then s:='0'+s;
            Str(Ysour+1,t);
            Cesta:='DATA\'+'PLANET'+s+'\'+s+'-'+'00'+t+'.txt';
            PodProc1;
          End;
      6: Begin {gra + map}
           Str(Xsour+1,s);
           If Xsour+1<10 then s:='0'+s;
           Str(Ysour+1,t);
           N:=1;
           Cesta:='DATA\'+'PLANET'+s+'\'+s+'-'+'mapa.gra';
           LoadGRAFile(Cesta,0,1);                          {LAYER GRA }
           VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]); {Into Buf[1] to x=0,y=0 }
           XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]);
           XVGA_FlipPage(1,0);
           Cesta:='DATA\'+'PLANET'+s+'\'+s+'-'+'mapa.map';
           LoadMAPFile(Cesta,0);
           Map_WriteXVGAComplet(Buffer[3]);                 {LAYER MAP EXPERIMENTAL }
           For N:=2 to 8 do
           Begin
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]);
             XVGA_FlipPage(1,0);
           End;
         End;
      7: Begin {gra 1-8}
             Str(Xsour+1,s);
             If Xsour+1<10 then s:='0'+s;
             N:=1;

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra01.gra';
             LoadGRAFile(Cesta,0,1);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(0,0,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra02.gra';
             LoadGRAFile(Cesta,0,2);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(160,0,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra03.gra';
             LoadGRAFile(Cesta,0,3);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(320,0,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra04.gra';
             LoadGRAFile(Cesta,0,4);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(480,0,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra05.gra';
             LoadGRAFile(Cesta,0,5);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(0,200,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra06.gra';
             LoadGRAFile(Cesta,0,6);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(160,200,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra07.gra';
             LoadGRAFile(Cesta,0,7);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(320,200,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra08.gra';
             LoadGRAFile(Cesta,0,8);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(480,200,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]);
             XVGA_FlipPage(1,0);
         End;

      8: Begin {gra 8-15 + map gra}
             Str(Xsour+1,s);
             If Xsour+1<10 then s:='0'+s;
             N:=1;

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra09.gra';
             LoadGRAFile(Cesta,0,1);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(0,0,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra10.gra';
             LoadGRAFile(Cesta,0,2);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(160,0,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra11.gra';
             LoadGRAFile(Cesta,0,3);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(320,0,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra12.gra';
             LoadGRAFile(Cesta,0,4);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(480,0,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra13.gra';
             LoadGRAFile(Cesta,0,5);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(0,200,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra14.gra';
             LoadGRAFile(Cesta,0,6);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(160,200,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-gra15.gra';
             LoadGRAFile(Cesta,0,7);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(320,200,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]); Inc(N);
             XVGA_FlipPage(1,0);

             VGA_ClearPage(ColX[0],Buffer[1]);
             Cesta:='DATA\'+'PLANET'+s+'\'+s+'-mapa.gra';
             LoadGRAFile(Cesta,0,8);
             VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
             XVGA_SprZ(480,200,0,0,159,199,1,Buffer[1]);
             XVGA_BarZ(240+N*50-42,403,240+N*50-8,410,ColX[1]);
             XVGA_FlipPage(1,0);
         End;
  End; {Case End}

End;