Procedure ALL15Min;
Const
    ObrazekTime1= 60*1000; {cas zobrazovani obrazku}
    ObrazekTime2= 100; {cas zobrazovani obrazku}
Var
    Ending: Boolean;
    Counter: LongInt;
    Obrazek: Byte;
    ObrCount: Byte;
Begin
  Ending:=False;
  SVGA_TogglePaging;


  Counter:=0;
  Obrazek:=0;
  Repeat
    SVGA_WaitRetrace;
    Case Obrazek of
     0: ShowBMP640('BITMAP\LSD\5hit50\LSD01.BMP',0,0,0,0);
     1: ShowBMP640('BITMAP\LSD\5hit50\LSD02.BMP',0,0,0,0);
     2: ShowBMP640('BITMAP\LSD\5hit50\LSD03.BMP',0,0,0,0);
     3: ShowBMP640('BITMAP\LSD\5hit50\LSD04.BMP',0,0,0,0);
     4: ShowBMP640('BITMAP\LSD\5hit50\LSD05.BMP',0,0,0,0);
     5: ShowBMP640('BITMAP\LSD\5hit50\LSD06.BMP',0,0,0,0);
     6: ShowBMP640('BITMAP\LSD\5hit50\LSD07.BMP',0,0,0,0);
     7: ShowBMP640('BITMAP\LSD\5hit50\LSD08.BMP',0,0,0,0);
     8: ShowBMP640('BITMAP\LSD\5hit50\LSD09.BMP',0,0,0,0);
     9: ShowBMP640('BITMAP\LSD\5hit50\LSD10.BMP',0,0,0,0);
    10: ShowBMP640('BITMAP\LSD\6hit25A\hit25A.BMP',0,0,0,0);
    11: ShowBMP640('BITMAP\LSD\7hit25B\hit25B.BMP',0,0,0,0);
    End; {Case End}
    Timer_Watch_Start;
    Repeat
      Counter:=Timer_Watch_GetTime;

      If Key[31]=1 then
      Begin
        Kbd_RPush(31);
        Counter:=ObrazekTime1+1;
      End;

      If Key[1]=1 then
      Begin
        Kbd_RPush(1);
        Ending:=True;
        Counter:=ObrazekTime1+1;
      End;

    Until Counter>ObrazekTime1;
    Timer_Watch_Stop;

    If Obrazek<11 then Inc(Obrazek) else Ending:=True;
  Until Ending=True;

  Ending:=False;
  Counter:=0;
  Obrazek:=0;
  ObrCount:=0;
  Repeat
    SVGA_WaitRetrace;
    Case Obrazek of
     0: ShowBMP640('BITMAP\LSD\1hit100A\frame00.bmp',0,0,0,0);
     1: ShowBMP640('BITMAP\LSD\1hit100A\frame01.bmp',0,0,0,0);
     2: ShowBMP640('BITMAP\LSD\1hit100A\frame02.bmp',0,0,0,0);
     3: ShowBMP640('BITMAP\LSD\1hit100A\frame03.bmp',0,0,0,0);
     4: ShowBMP640('BITMAP\LSD\1hit100A\frame04.bmp',0,0,0,0);
     5: ShowBMP640('BITMAP\LSD\1hit100A\frame05.bmp',0,0,0,0);
     6: ShowBMP640('BITMAP\LSD\1hit100A\frame06.bmp',0,0,0,0);
     7: ShowBMP640('BITMAP\LSD\1hit100A\frame07.bmp',0,0,0,0);
     8: ShowBMP640('BITMAP\LSD\1hit100A\frame08.bmp',0,0,0,0);
     9: ShowBMP640('BITMAP\LSD\1hit100A\frame09.bmp',0,0,0,0);
    10: ShowBMP640('BITMAP\LSD\1hit100A\frame10.bmp',0,0,0,0);
    11: ShowBMP640('BITMAP\LSD\1hit100A\frame11.bmp',0,0,0,0);
    12: ShowBMP640('BITMAP\LSD\1hit100A\frame12.bmp',0,0,0,0);
    13: ShowBMP640('BITMAP\LSD\1hit100A\frame13.bmp',0,0,0,0);
    14: ShowBMP640('BITMAP\LSD\1hit100A\frame14.bmp',0,0,0,0);
    15: ShowBMP640('BITMAP\LSD\1hit100A\frame15.bmp',0,0,0,0);
    16: ShowBMP640('BITMAP\LSD\1hit100A\frame16.bmp',0,0,0,0);
    17: ShowBMP640('BITMAP\LSD\1hit100A\frame17.bmp',0,0,0,0);
    18: ShowBMP640('BITMAP\LSD\1hit100A\frame18.bmp',0,0,0,0);
    19: ShowBMP640('BITMAP\LSD\1hit100A\frame19.bmp',0,0,0,0);
    20: ShowBMP640('BITMAP\LSD\1hit100A\frame20.bmp',0,0,0,0);
    21: ShowBMP640('BITMAP\LSD\1hit100A\frame21.bmp',0,0,0,0);
    22: ShowBMP640('BITMAP\LSD\1hit100A\frame22.bmp',0,0,0,0);
    23: ShowBMP640('BITMAP\LSD\1hit100A\frame23.bmp',0,0,0,0);
    24: ShowBMP640('BITMAP\LSD\1hit100A\frame24.bmp',0,0,0,0);
    25: ShowBMP640('BITMAP\LSD\1hit100A\frame25.bmp',0,0,0,0);
    26: ShowBMP640('BITMAP\LSD\1hit100A\frame26.bmp',0,0,0,0);
    27: ShowBMP640('BITMAP\LSD\1hit100A\frame27.bmp',0,0,0,0);
    28: ShowBMP640('BITMAP\LSD\1hit100A\frame28.bmp',0,0,0,0);
    29: ShowBMP640('BITMAP\LSD\1hit100A\frame29.bmp',0,0,0,0);
    30: ShowBMP640('BITMAP\LSD\1hit100A\frame30.bmp',0,0,0,0);
    31: ShowBMP640('BITMAP\LSD\1hit100A\frame31.bmp',0,0,0,0);
    32: ShowBMP640('BITMAP\LSD\1hit100A\frame32.bmp',0,0,0,0);
    33: ShowBMP640('BITMAP\LSD\1hit100A\frame33.bmp',0,0,0,0);
    34: ShowBMP640('BITMAP\LSD\1hit100A\frame34.bmp',0,0,0,0);
    35: ShowBMP640('BITMAP\LSD\1hit100A\frame35.bmp',0,0,0,0);
    36: ShowBMP640('BITMAP\LSD\1hit100A\frame36.bmp',0,0,0,0);
    37: ShowBMP640('BITMAP\LSD\1hit100A\frame37.bmp',0,0,0,0);
    38: ShowBMP640('BITMAP\LSD\1hit100A\frame38.bmp',0,0,0,0);
    39: ShowBMP640('BITMAP\LSD\1hit100A\frame39.bmp',0,0,0,0);
    40: ShowBMP640('BITMAP\LSD\1hit100A\frame40.bmp',0,0,0,0);
    41: ShowBMP640('BITMAP\LSD\1hit100A\frame41.bmp',0,0,0,0);
    End; {Case End}
    Timer_Watch_Start;
    Repeat
      Counter:=Timer_Watch_GetTime;

      If Key[31]=1 then
      Begin
        Kbd_RPush(31);
        Counter:=ObrazekTime2+1;
      End;

      If Key[1]=1 then
      Begin
        Kbd_RPush(1);
        Ending:=True;
        Counter:=ObrazekTime2+1;
      End;

    Until Counter>ObrazekTime2;
    Timer_Watch_Stop;

    If Obrazek<41 then Inc(Obrazek) else
    Begin
      Obrazek:=0;
      If ObrCount<15 then Inc(ObrCount) else Ending:=True;
    End;
  Until Ending=True;

  Ending:=False;
  Counter:=0;
  Obrazek:=0;
  ObrCount:=0;
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
        Counter:=ObrazekTime2+1;
      End;

      If Key[1]=1 then
      Begin
        Kbd_RPush(1);
        Ending:=True;
        Counter:=ObrazekTime2+1;
      End;

    Until Counter>ObrazekTime2;
    Timer_Watch_Stop;

    If Obrazek<13 then Inc(Obrazek) else
    Begin
      Obrazek:=0;
      If ObrCount<40 then Inc(ObrCount) else Ending:=True;
    End;
  Until Ending=True;

  Ending:=False;
  Counter:=0;
  Obrazek:=0;
  ObrCount:=0;
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
        Counter:=ObrazekTime2+1;
      End;

      If Key[1]=1 then
      Begin
        Kbd_RPush(1);
        Ending:=True;
        Counter:=ObrazekTime2+1;
      End;

    Until Counter>ObrazekTime2;
    Timer_Watch_Stop;

    If Obrazek<5 then Inc(Obrazek) else
    Begin
      Obrazek:=0;
      If ObrCount<120 then Inc(ObrCount) else Ending:=True;
    End;
  Until Ending=True;

  SVGA_TogglePaging;

  Hit100D;
End;