Procedure Hit50;
Const
    ObrazekTime= 6*60*1000; {cas zobrazovani obrazku}
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

    If Obrazek<9 then Inc(Obrazek) else Obrazek:=0;

  Until Ending=True;
  SVGA_TogglePaging;
End;