Procedure Main;
Var Konec: Boolean;
    i: Byte;
Begin
  Konec:=False;
  XVGA_setvisualpage(0); {visible page set 0 , page 0 is visible}

  {---} {map to page 1 background}

  XVGA_setactivepage(1); {4 pages avaiable [0..3]} {draw to page 1}

  {gra 01 + map}
  LoadGRAFile('DATA\graa.gra',0,1);                            {LAYER GRA1 }
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]); {Into Buf[1] to x=0,y=0 }

  LoadMAPFile('DATA\level.map',0);
  Map_WriteXVGAComplet(Buffer[3]);                 {LAYER MAP EXPERIMENTAL }

  For i:=0 to 22 do
  XVGA_BarZ(8,16+i*16,632,16+i*16+15,i+160); {color background lines}
  Str80('DATA\001.TXT');         {text page 80x25 visible - load from disk }

  XVGA_Rectangle(0,400,639,479,ColX[1]);


  {---} {gra and bmp to page 2 objects}

  XVGA_setactivepage(2); {4 pages avaiable [0..3]} {draw to page 1}

  VGA_ClearPage(ColX[0],Buffer[1]); {ColX[0]=black}
  LoadGRAFile('DATA\graa.gra',0,1);                            {LAYER GRA1 }
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]); {Into Buf[1] to x=0,y=0 }
  XVGA_SprZ(0,200,0,0,159,199,1,Buffer[1]);           {In Buffer[1] is gra1}

  VGA_ClearPage(ColX[0],Buffer[1]); {ColX[0]=black}
  LoadGRAFile('DATA\grab.gra',0,2);                            {LAYER GRA2 }
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
  XVGA_SprZ(160,200,0,0,159,199,1,Buffer[1]);         {In Buffer[1] is gra2}

  VGA_ClearPage(ColX[0],Buffer[1]);
  LoadGRAFile('DATA\grac.gra',0,3);                            {LAYER GRA3 }
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
  XVGA_SprZ(320,200,0,0,159,199,1,Buffer[1]);          {In Buffer[1] is gra3}

  VGA_ClearPage(ColX[0],Buffer[1]);
  LoadGRAFile('DATA\grad.gra',0,4);                            {LAYER GRA4 }
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]);
  XVGA_SprZ(480,200,0,0,159,199,1,Buffer[1]);          {In Buffer[1] is gra4}

  VGA_ClearPage(ColX[0],Buffer[1]);
  Str80BMP('DATA\alien.bmp',120);               {alien.bmp 160x200 visible Buf1 }
  XVGA_SprZ(320,0,160,0,319,199,1,Buffer[1]);

  VGA_ClearPage(ColX[0],Buffer[1]);
  Str80BMP('DATA\cosmon.bmp',136);             {cosmon.bmp 160x200 visible Buf1 }
  XVGA_SprZ(480,0,160,0,319,199,1,Buffer[1]);

{fps}
  fps:=0;
  frame_counter:=0;

  setfont(3,1);      {set font number 3}
  setcolor(ColX[1]); {set drawing color , texts & lines}
  Repeat

    MainScreen; {fps and pixels}

{fps count}
    If Timer_Second=True then
    Begin
      Inc(frame_counter);
    End else
    Begin
      If frame_counter>0 then fps:=frame_counter;
      frame_counter:=0;
    End;

{A=STEP}
    If ((Key[28]=1) or (Key[30]=1)) then
    Begin
      If Key[28]=1 then Kbd_RPush(28);
      If Key[30]=1 then Kbd_RPush(30);
      If STEP<22 then Inc(STEP) else STEP:=1;
      P16_StopBlink;
      P16_StartBlink(160+STEP,1); {tempo 1=fastest}
    End;

{Esc}
    If ((Key[68]=1) or (Key[1]=1)) then
    Begin
      If Key[68]=1 then Kbd_RPush(68);
      If Key[1]=1 then Kbd_RPush(1);
      Konec:=True;                         {Esc MainMenu}
    End;

  Until Konec=True;

End;