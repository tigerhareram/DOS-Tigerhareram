Procedure Main;
Var Konec: Boolean;
    i: Byte;
Begin
  Konec:=False;

  XVGA_setvisualpage(0); {visible page set 0 , page 0 is visible}
  XVGA_setactivepage(1); {4 pages avaiable [0..3]} {draw to page 1}

  {gra 01 + map}
  LoadGRAFile('DATA\graa.gra',0,1);                            {LAYER GRA1 }
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]); {Into Buf[1] to x=0,y=0 }

  LoadMAPFile('DATA\level.map',0);
  Map_WriteXVGAComplet(Buffer[3]);                 {LAYER MAP EXPERIMENTAL }

  {to page 1 (640x480) from buffer[1]}
  XVGA_SprZ(0,200,0,0,159,199,1,Buffer[1]);           {In Buffer[1] is gra1}

  {---}

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

  Str80('DATA\001.TXT');         {text page 80x25 visible - load from disk }

  XVGA_Rectangle(0,0,639,400,ColX[1]);
  XVGA_Rectangle(0,400,639,479,ColX[1]);

{fps}
  fps:=0;
  frame_counter:=0;

  XVGA_setactivepage(3); {MainScreen play in page 3}
  Repeat

    MainScreen; {fps and pixels}
    XVGA_FlipPage(3,0);

{fps count}
    If Timer_Second=True then
    Begin
      Inc(frame_counter);
    End else
    Begin
      If frame_counter>0 then fps:=frame_counter;
      frame_counter:=0;
    End;

{wait key time 20x25=500 (0,5 seconds waiting) }
{   i:=0;
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
End;