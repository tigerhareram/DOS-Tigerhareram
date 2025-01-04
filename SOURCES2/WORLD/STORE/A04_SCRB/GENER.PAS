Procedure ShowGenerBMP(I:Byte);
Begin
  SVGA_TogglePaging;
  Case I of
    1: ShowBMP640('BITMAP\LSD-BMP\lsd01.bmp',0,0,0,0);
    2: ShowBMP640('BITMAP\LSD-BMP\lsd02.bmp',0,0,0,0);
    3: ShowBMP640('BITMAP\LSD-BMP\lsd03.bmp',0,0,0,0);
    4: ShowBMP640('BITMAP\LSD-BMP\lsd04.bmp',0,0,0,0);
    5: ShowBMP640('BITMAP\LSD-BMP\lsd05.bmp',0,0,0,0);
    6: ShowBMP640('BITMAP\LSD-BMP\lsd06.bmp',0,0,0,0);
    7: ShowBMP640('BITMAP\LSD-BMP\lsd07.bmp',0,0,0,0);
    8: ShowBMP640('BITMAP\LSD-BMP\lsd08.bmp',0,0,0,0);
    9: ShowBMP640('BITMAP\LSD-BMP\lsd09.bmp',0,0,0,0);
   10: ShowBMP640('BITMAP\LSD-BMP\lsd10.bmp',0,0,0,0);
   11: ShowBMP640('BITMAP\LSD-BMP\lsd11.bmp',0,0,0,0);
   12: ShowBMP640('BITMAP\LSD-BMP\lsd12.bmp',0,0,0,0);
   13: ShowBMP640('BITMAP\LSD-BMP\lsd13.bmp',0,0,0,0);
   14: ShowBMP640('BITMAP\LSD-BMP\lsd14.bmp',0,0,0,0);
   15: ShowBMP640('BITMAP\LSD-BMP\lsd15.bmp',0,0,0,0);
   16: ShowBMP640('BITMAP\LSD-BMP\lsd16.bmp',0,0,0,0);
   17: ShowBMP640('BITMAP\LSD-BMP\lsd17.bmp',0,0,0,0);
   18: ShowBMP640('BITMAP\LSD-BMP\lsd18.bmp',0,0,0,0);
   19: ShowBMP640('BITMAP\LSD-BMP\lsd19.bmp',0,0,0,0);
  End; {Case End}
  SVGA_TogglePaging;
  Repeat Until ((Key[1]=1) or (Key[31]=1));
  If Key[1]=1 then Kbd_RPush(1);
  If Key[31]=1 then Kbd_RPush(31);
  SetPalette;
End;


Procedure ShowGenerBMPSeq(I:Byte);
Begin
  SVGA_TogglePaging;
  Case I of
    1: ShowBMP640('BITMAP\LSD-BMP\lsd01.bmp',0,0,0,0);
    2: ShowBMP640('BITMAP\LSD-BMP\lsd02.bmp',0,0,0,0);
    3: ShowBMP640('BITMAP\LSD-BMP\lsd03.bmp',0,0,0,0);
    4: ShowBMP640('BITMAP\LSD-BMP\lsd04.bmp',0,0,0,0);
    5: ShowBMP640('BITMAP\LSD-BMP\lsd05.bmp',0,0,0,0);
    6: ShowBMP640('BITMAP\LSD-BMP\lsd06.bmp',0,0,0,0);
    7: ShowBMP640('BITMAP\LSD-BMP\lsd07.bmp',0,0,0,0);
    8: ShowBMP640('BITMAP\LSD-BMP\lsd08.bmp',0,0,0,0);
    9: ShowBMP640('BITMAP\LSD-BMP\lsd09.bmp',0,0,0,0);
   10: ShowBMP640('BITMAP\LSD-BMP\lsd10.bmp',0,0,0,0);
   11: ShowBMP640('BITMAP\LSD-BMP\lsd11.bmp',0,0,0,0);
   12: ShowBMP640('BITMAP\LSD-BMP\lsd12.bmp',0,0,0,0);
   13: ShowBMP640('BITMAP\LSD-BMP\lsd13.bmp',0,0,0,0);
   14: ShowBMP640('BITMAP\LSD-BMP\lsd14.bmp',0,0,0,0);
   15: ShowBMP640('BITMAP\LSD-BMP\lsd15.bmp',0,0,0,0);
   16: ShowBMP640('BITMAP\LSD-BMP\lsd16.bmp',0,0,0,0);
   17: ShowBMP640('BITMAP\LSD-BMP\lsd17.bmp',0,0,0,0);
   18: ShowBMP640('BITMAP\LSD-BMP\lsd18.bmp',0,0,0,0);
   19: ShowBMP640('BITMAP\LSD-BMP\lsd19.bmp',0,0,0,0);
  End; {Case End}
  SVGA_TogglePaging;
  SetPalette;                                            {Barvy obnovit}
End;
