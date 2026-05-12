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

  Str80('DATA\001.TXT');         {text page 80x25 visible - load from disk }

  XVGA_Rectangle(0,0,639,400,ColX[2]);
  XVGA_Rectangle(0,400,639,479,ColX[2]);




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

  XVGA_InitImage(320,0,160,200,0); {alien 160x200}
  XVGA_InitImage(480,0,160,200,1); {cosmon 160x200}

{fps}
  fps:=0;
  frame_counter:=0;

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

{Esc}    If ((Key[68]=1) or (Key[1]=1)) then
         Begin
           If Key[68]=1 then Kbd_RPush(68);
           If Key[1]=1 then Kbd_RPush(1);
           Konec:=True;                         {Esc MainMenu}
         End;

  Until Konec=True;







  {experiment 2 = palette processes}

  Konec:=False;
  P16_StartBlink(ColX[1],0);

  P16_FadeOut(120,0); {fade out color 120 + next 15 alien palette}
  P16_FadeOut(136,0); {fade out color 136 + next 15 cosmon palette}

  Repeat

   i:=0;
   Repeat
   if i<25 then Begin
                  Inc(i);
                  Timer_Wait(20);
                  If KeyCode<128 then i:=25;
                End;
    Until i>=25;

{Esc}    If ((Key[68]=1) or (Key[1]=1)) then
         Begin
           If Key[68]=1 then Kbd_RPush(68);
           If Key[1]=1 then Kbd_RPush(1);
           Konec:=True;                         {Esc MainMenu}
         End;

  Until Konec=True;
  P16_StopBlink;
End;