Procedure Hit100C;
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
     0: ShowBMP640('BITMAP\LSD\3hit100C\frame00.bmp',0,0,0,0);
     1: ShowBMP640('BITMAP\LSD\3hit100C\frame01.bmp',0,0,0,0);
     2: ShowBMP640('BITMAP\LSD\3hit100C\frame02.bmp',0,0,0,0);
     3: ShowBMP640('BITMAP\LSD\3hit100C\frame03.bmp',0,0,0,0);
     4: ShowBMP640('BITMAP\LSD\3hit100C\frame04.bmp',0,0,0,0);
     5: ShowBMP640('BITMAP\LSD\3hit100C\frame05.bmp',0,0,0,0);
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

    If Obrazek<5 then Inc(Obrazek) else Obrazek:=0;

  Until Ending=True;
  SVGA_TogglePaging;
End;