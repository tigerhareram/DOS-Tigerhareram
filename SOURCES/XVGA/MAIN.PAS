Procedure Main;
Var Konec: Boolean;
    i: Byte;
Begin
  Konec:=False;

  XVGA_setvisualpage(0); {visible page set 0 , page 0 is visible}
  XVGA_setactivepage(1); {4 pages avaiable [0..3]} {draw to page 1}

  LoadGRAFile('DATA\001a.gra',0,1);                            {LAYER GRA1 }
  VGA_SprZ(0,0,0,0,159,199,1,Buffer[3],Buffer[1]); {Into Buf[1] to x=160,y=0 }
                                                   {In Buffer[1] is gra1   }

  LoadMAPFile('DATA\001.map',0);
  Map_WriteXVGAComplet(Buffer[3]);                 {LAYER MAP EXPERIMENTAL }

  Str80BMP('DATA\001.bmp');                  {001.bmp 160x200 visible Buf1 }
  XVGA_SprZ(0,0,160,0,319,199,1,Buffer[1]);

  XVGA_SprZ(480,0,0,0,159,199,1,Buffer[1]);      {001a.gra 160x200 visible }


  Str80('DATA\001.TXT');         {text page 80x25 visible - load from disk }

{fps}
  fps:=0;
  frame_counter:=0;

  Repeat

    MainScreen; {fps and pixels}
    XVGA_FlipPage(1,0);

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