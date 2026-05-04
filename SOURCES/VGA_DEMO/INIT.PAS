Procedure Init;
Var R,G,B : Byte;

Begin
  Mouse_Hide;

  ColX[0]:=0;
  P16_SetPal(ColX[0],0,0,0);     {BLACK BACKGROUND, TIMER LOAD}
  P16_SetPal(ColX[1],12,54,12);  {LOADING PHASE}
  P16_SetPal(ColX[2],5,17,5);    {WINDOW BACKGROUND}
  P16_SetPal(ColX[3],0,0,0);
  P16_SetPal(ColX[4],0,0,0);
  P16_SetPal(ColX[5],0,0,0);
  P16_SetPal(ColX[6],0,0,0);
  P16_SetPal(ColX[7],0,0,0);
  P16_SetPal(ColX[8],0,0,0);
  P16_SetPal(ColX[9],0,0,0);
  P16_SetPal(ColX[10],0,0,0);
  P16_SetPal(ColX[11],0,0,0);
  P16_SetPal(ColX[12],0,0,0);
  P16_SetPal(ColX[13],0,0,0);
  P16_SetPal(ColX[14],0,0,0);
  P16_SetPal(ColX[15],12,54,12); {DEFAULT TEXT , RECTANGLES}


  Timer_StartInit(1900); {LOADING PHASE (2 SECOND)}

  LoadGRAFile('DATA\data.gra',0,1);
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);       {LOAD}

  LoadMAPFile('DATA\level.map',0);
  X1:=0;
  Y1:=0;
  X2:=199;
  Y2:=199;

  LoadBMPFile('BMP\cosmon.bmp',0,0,0,144,Buffer[3]);{BMP2} {Buffer2   0..159}
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[2]);     {LOAD}

  LoadBMPFile('BMP\alien.bmp',0,0,0,128,Buffer[3]); {BMP1} {Buffer2 160..319}
  VGA_SprZ(160,0,0,0,159,199,1,Buffer[3],Buffer[2]);       {LOAD}

  selection:=1; {main menu = option Start}

  Timer_StopInit; {LOADING PHASE DONE}
End;