Procedure Main;
Var Konec: Boolean;
    i: Byte;
    N: Byte;
Begin
  Konec:=False;
  XVGA_setvisualpage(0); {visible page set 0 , page 0 is visible}
  XVGA_setactivepage(1); {4 pages avaiable [0..3]} {draw to page 1}

{fps}
  fps:=0;
  frame_counter:=0;

{first button selected}
  Xsour:=0;
  Ysour:=0;
  P16_StartBlink(ColX[2],1);

  Repeat

    Screen; {fps and pixels}

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

{Up}     If ((Key[72]=1) or (Key[23]=1)) then
         Begin
           If Key[72]=1 then Kbd_RPush(72);
           If Key[23]=1 then Kbd_RPush(23);
           P16_StopBlink;
           If Ysour>0 then Dec(Ysour);
           P16_StartBlink(ColX[2],1);
         End;

{Down}   If ((Key[80]=1) or (Key[37]=1)) then
         Begin
           If Key[80]=1 then Kbd_RPush(80);
           If Key[37]=1 then Kbd_RPush(37);
           P16_StopBlink;
           If Ysour<8 then Inc(Ysour);
           P16_StartBlink(ColX[2],1);
         End;

{Left}   If ((Key[75]=1) or (Key[36]=1)) then
         Begin
           If Key[75]=1 then Kbd_RPush(75);
           If Key[36]=1 then Kbd_RPush(36);
           P16_StopBlink;
           If Xsour>0 then Dec(Xsour);
           P16_StartBlink(ColX[2],1);
         End;

{Right}  If ((Key[77]=1) or (Key[38]=1)) then
         Begin
           If Key[77]=1 then Kbd_RPush(77);
           If Key[38]=1 then Kbd_RPush(38);
           P16_StopBlink;
           If Xsour<19 then Inc(Xsour);
           P16_StartBlink(ColX[2],1);
         End;

{Enter}  If ((Key[28]=1) or (Key[30]=1)) then
         Begin
           If Key[28]=1 then Kbd_RPush(28);
           If Key[30]=1 then Kbd_RPush(30);

           EnterFile;

         End;

  Until Konec=True;

End;