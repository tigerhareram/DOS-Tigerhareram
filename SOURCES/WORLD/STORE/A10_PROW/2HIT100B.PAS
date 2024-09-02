Procedure Hit100B;
Const
    ObrazekTime= 125; {cas zobrazovani obrazku}
Var
    Ending: Boolean;
    Counter: LongInt;
    Obrazek: Byte;
Begin
  Ending:=False;
  Counter:=0;
  Obrazek:=0;
  SVGA_TogglePaging;
  Repeat

    SVGA_WaitRetrace;
    Case Obrazek of
     0: ShowBMP640('BITMAP\LSD\2hit100B\frame00.bmp',0,0,0,0);
     1: ShowBMP640('BITMAP\LSD\2hit100B\frame01.bmp',0,0,0,0);
     2: ShowBMP640('BITMAP\LSD\2hit100B\frame02.bmp',0,0,0,0);
     3: ShowBMP640('BITMAP\LSD\2hit100B\frame03.bmp',0,0,0,0);
     4: ShowBMP640('BITMAP\LSD\2hit100B\frame04.bmp',0,0,0,0);
     5: ShowBMP640('BITMAP\LSD\2hit100B\frame05.bmp',0,0,0,0);
     6: ShowBMP640('BITMAP\LSD\2hit100B\frame06.bmp',0,0,0,0);
     7: ShowBMP640('BITMAP\LSD\2hit100B\frame07.bmp',0,0,0,0);
     8: ShowBMP640('BITMAP\LSD\2hit100B\frame08.bmp',0,0,0,0);
     9: ShowBMP640('BITMAP\LSD\2hit100B\frame09.bmp',0,0,0,0);
    10: ShowBMP640('BITMAP\LSD\2hit100B\frame10.bmp',0,0,0,0);
    11: ShowBMP640('BITMAP\LSD\2hit100B\frame11.bmp',0,0,0,0);
    12: ShowBMP640('BITMAP\LSD\2hit100B\frame12.bmp',0,0,0,0);
    13: ShowBMP640('BITMAP\LSD\2hit100B\frame13.bmp',0,0,0,0);
    End; {Case End}

    Timer_Watch_Start;
    Repeat
      Counter:=Timer_Watch_GetTime;

      If Key[31]=1 then
      Begin
        Kbd_RPush(31);
        Counter:=ObrazekTime+1;
      End;

      If Key[1]=1 then
      Begin
        Kbd_RPush(1);
        Ending:=True;
        Counter:=ObrazekTime+1;
      End;

    Until Counter>ObrazekTime;
    Timer_Watch_Stop;

    If Obrazek<13 then Inc(Obrazek) else Obrazek:=0;

  Until Ending=True;
  SVGA_TogglePaging;
End;