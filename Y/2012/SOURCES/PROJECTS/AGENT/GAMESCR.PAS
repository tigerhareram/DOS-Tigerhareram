Procedure GameScreen;
Var I: Byte;

Begin
  ClearPage(Buffer[3]);
  WriteMapScreen(Map.XView,Map.YView,80,Buffer[2],Buffer[3]);

  {Enemy}
  For I:=0 to 255 do
  Begin
    If ((Enemy[I].Aktive=True) and (Enemy[I].Terminated=False)) then
    Begin
      If ((Enemy[I].Typ=1) or (Enemy[I].Typ=2)) then
      Begin
        Case Enemy[I].Sprite of
          {doprava stoji}      1: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,0,120,15,143,Buffer[1],Buffer[3]);
          {doprava krok A}     2: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,16,120,31,143,Buffer[1],Buffer[3]);
          {doprava krok B}     3: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,32,120,47,143,Buffer[1],Buffer[3]);
          {doleva stoji}       4: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,0,144,15,167,Buffer[1],Buffer[3]);
          {doleva krok A}      5: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,16,144,31,167,Buffer[1],Buffer[3]);
          {doleva krok B}      6: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,32,144,47,167,Buffer[1],Buffer[3]);
          {doprava death}      7: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,48,120,71,135,Buffer[1],Buffer[3]);
          {doleva death}       8: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,48,136,71,151,Buffer[1],Buffer[3]);
        End; {Case End}
      End;
      If ((Enemy[I].Typ=3) or (Enemy[I].Typ=4)) then
      Begin
        Case Enemy[I].Sprite of
          1: WriteGraphics(Enemy[I].X,Enemy[I].Y+8,Map.XView,Map.YView,0,168,15,175,Buffer[1],Buffer[3]);
          2: WriteGraphics(Enemy[I].X,Enemy[I].Y+8,Map.XView,Map.YView,16,168,31,175,Buffer[1],Buffer[3]);
          3: WriteGraphics(Enemy[I].X,Enemy[I].Y+8,Map.XView,Map.YView,32,168,47,175,Buffer[1],Buffer[3]);
          4: WriteGraphics(Enemy[I].X,Enemy[I].Y+8,Map.XView,Map.YView,48,168,63,175,Buffer[1],Buffer[3]);
        End; {Case End}
      End;
      If Enemy[I].Typ=5 then
      Begin
        Case Enemy[I].Sprite of
          1: WriteGraphics(Enemy[I].X,Enemy[I].Y+8,Map.XView,Map.YView,0,192,15,199,Buffer[1],Buffer[3]);
          2: WriteGraphics(Enemy[I].X-8,Enemy[I].Y,Map.XView,Map.YView,0,176,31,191,Buffer[1],Buffer[3]);
          3: WriteGraphics(Enemy[I].X-8,Enemy[I].Y,Map.XView,Map.YView,32,176,63,191,Buffer[1],Buffer[3]);
        End; {Case End}
      End;
      If Enemy[I].Typ=6 then
      Begin
        Case Enemy[I].Sprite of
         1: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,88,48,103,63,Buffer[1],Buffer[3]);
         2: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,104,48,119,63,Buffer[1],Buffer[3]);
         3: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,88,64,103,79,Buffer[1],Buffer[3]);
         4: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,104,64,119,79,Buffer[1],Buffer[3]);
         5: WriteGraphics(Enemy[I].X,Enemy[I].Y,Map.XView,Map.YView,120,48,135,63,Buffer[1],Buffer[3]);
        End; {Case End}
      End;
    End;
  End;

  {Player}
  Case Player.Sprite of
{doprava stoji}      1: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,0,0,15,23,Buffer[1],Buffer[3]);
{doprava krok A}     2: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,16,0,31,23,Buffer[1],Buffer[3]);
{doprava krok B}     3: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,32,0,47,23,Buffer[1],Buffer[3]);
{doleva stoji}       4: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,0,24,15,47,Buffer[1],Buffer[3]);
{doleva krok A}      5: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,16,24,31,47,Buffer[1],Buffer[3]);
{doleva krok B}      6: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,32,24,47,47,Buffer[1],Buffer[3]);
{rebrik A}           7: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,0,48,15,71,Buffer[1],Buffer[3]);
{rebrik B}           8: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,16,48,31,71,Buffer[1],Buffer[3]);
{doprava boj ready}  9: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,48,0,63,23,Buffer[1],Buffer[3]);
{doprava box}       10: Begin
                          WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,64,0,79,23,Buffer[1],Buffer[3]);
                          WriteGraphics(Player.X+16,Player.Y+2,Map.XView,Map.YView,152,0,159,7,Buffer[1],Buffer[3]);
                        End;
{doprava kop A}     11: Begin
                          WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,80,0,103,23,Buffer[1],Buffer[3]);
                          WriteGraphics(Player.X+19,Player.Y+3,Map.XView,Map.YView,152,0,159,7,Buffer[1],Buffer[3]);
                        End;
{doprava kop B}     12: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,104,0,127,23,Buffer[1],Buffer[3]);
{doleva boj ready}  13: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,48,24,63,47,Buffer[1],Buffer[3]);
{doleva box}        14: Begin
                          WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,64,24,79,47,Buffer[1],Buffer[3]);
                          WriteGraphics(Player.X-8,Player.Y+2,Map.XView,Map.YView,152,8,159,15,Buffer[1],Buffer[3]);
                        End;
{doleva kop A} 15: Begin
                     WriteGraphics(Player.X-8,Player.Y,Map.XView,Map.YView,80,24,103,47,Buffer[1],Buffer[3]);
                     WriteGraphics(Player.X-10,Player.Y+4,Map.XView,Map.YView,152,8,159,15,Buffer[1],Buffer[3]);
                   End;
{doleva kop B}      16: WriteGraphics(Player.X-8,Player.Y,Map.XView,Map.YView,104,24,127,47,Buffer[1],Buffer[3]);
{doprava skrceny}       17: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,0,72,15,95,Buffer[1],Buffer[3]);
{doprava skrceny box}   18: Begin
                              WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,16,72,39,95,Buffer[1],Buffer[3]);
                              WriteGraphics(Player.X+17,Player.Y+7,Map.XView,Map.YView,152,0,159,7,Buffer[1],Buffer[3]);
                            End;
{doprava skrceny kop B} 19: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,40,72,63,95,Buffer[1],Buffer[3]);
{doprava skrceny kop A} 20: Begin
                              WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,64,72,87,95,Buffer[1],Buffer[3]);
                              WriteGraphics(Player.X+20,Player.Y+17,Map.XView,Map.YView,152,0,159,7,Buffer[1],Buffer[3]);
                            End;
{doleva skrceny}        21: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,0,96,15,119,Buffer[1],Buffer[3]);
{doleva skrceny box}    22: Begin
                              WriteGraphics(Player.X-8,Player.Y,Map.XView,Map.YView,16,96,39,119,Buffer[1],Buffer[3]);
                              WriteGraphics(Player.X-9,Player.Y+7,Map.XView,Map.YView,152,8,159,15,Buffer[1],Buffer[3]);
                            End;
{doleva skrceny kop B}  23: WriteGraphics(Player.X-8,Player.Y,Map.XView,Map.YView,40,96,63,119,Buffer[1],Buffer[3]);
{doleva skrceny kop A}  24: Begin
                              WriteGraphics(Player.X-8,Player.Y,Map.XView,Map.YView,64,96,87,119,Buffer[1],Buffer[3]);
                              WriteGraphics(Player.X-12,Player.Y+17,Map.XView,Map.YView,152,8,159,15,Buffer[1],Buffer[3]);
                            End;
{death}                 25: WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,32,48,47,71,Buffer[1],Buffer[3]);
{doprava skrceny strelba A} 26: Begin
                                  WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,16,72,39,95,Buffer[1],Buffer[3]);
                                  WriteGraphics(Player.X+17,Player.Y+7,Map.XView,Map.YView,152,16,159,23,Buffer[1],Buffer[3]);
                                End;
{doprava skrceny strelba B} 27: Begin
                                  WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,16,72,39,95,Buffer[1],Buffer[3]);
                                  WriteGraphics(Player.X+17,Player.Y+7,Map.XView,Map.YView,152,16,159,23,Buffer[1],Buffer[3]);
                                  WriteGraphics(Player.X+17,Player.Y+7,Map.XView,Map.YView,152,40,159,41,Buffer[1],Buffer[3]);
                                End;
{doleva skrceny strelba A} 28: Begin
                                 WriteGraphics(Player.X-8,Player.Y,Map.XView,Map.YView,16,96,39,119,Buffer[1],Buffer[3]);
                                 WriteGraphics(Player.X-9,Player.Y+7,Map.XView,Map.YView,152,24,159,31,Buffer[1],Buffer[3]);
                               End;
{doleva skrceny strelba B}    29: Begin
                                    WriteGraphics(Player.X-8,Player.Y,Map.XView,Map.YView,16,96,39,119,Buffer[1],Buffer[3]);
                                    WriteGraphics(Player.X-9,Player.Y+7,Map.XView,Map.YView,152,24,159,31,Buffer[1],Buffer[3]);
                                    WriteGraphics(Player.X-9,Player.Y+7,Map.XView,Map.YView,152,48,159,49,Buffer[1],Buffer[3]);
                                  End;
{doprava strelba A}       30: Begin
                                WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,64,0,79,23,Buffer[1],Buffer[3]);
                                WriteGraphics(Player.X+16,Player.Y+2,Map.XView,Map.YView,152,16,159,23,Buffer[1],Buffer[3]);
                              End;
{doprava strelba B}       31: Begin
                                WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,64,0,79,23,Buffer[1],Buffer[3]);
                                WriteGraphics(Player.X+16,Player.Y+2,Map.XView,Map.YView,152,16,159,23,Buffer[1],Buffer[3]);
                                WriteGraphics(Player.X+16,Player.Y+2,Map.XView,Map.YView,152,40,159,41,Buffer[1],Buffer[3]);
                              End;
{doleva strelba A}        32: Begin
                                WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,64,24,79,47,Buffer[1],Buffer[3]);
                                WriteGraphics(Player.X-8,Player.Y+2,Map.XView,Map.YView,152,24,159,31,Buffer[1],Buffer[3]);
                              End;
{doleva strelba B}        33: Begin
                                WriteGraphics(Player.X,Player.Y,Map.XView,Map.YView,64,24,79,47,Buffer[1],Buffer[3]);
                                WriteGraphics(Player.X-8,Player.Y+2,Map.XView,Map.YView,152,24,159,31,Buffer[1],Buffer[3]);
                                WriteGraphics(Player.X-8,Player.Y+2,Map.XView,Map.YView,152,48,159,49,Buffer[1],Buffer[3]);
                              End;
  End; {Case End}

{strela}
  If Strela.Leti=True then WriteGraphics(Strela.X,Strela.Y,Map.XView,Map.YView,155,32,159,39,Buffer[1],Buffer[3]);

  Ramecek(0,0,319,192,ColorRed,Buffer[3]);
  Blok(0,193,319,199,ColorBlack,Buffer[3]);
  If Fps.Show=True then
  Begin
    Ramecek(297,183,311,191,ColorRed,Buffer[3]);
    Blok(298,184,310,190,ColorWhite,Buffer[3]);
    WriteNumber(Buffer[2],160,15,5,5,1,299,185,fps.fps,Buffer[3]);
  End;
  If TabulkaShow=True then
  Begin
    Ramecek(5,5,85,25,ColorRed,Buffer[3]);
    Blok(6,6,84,24,ColorWhite,Buffer[3]);
    WriteText(Buffer[2],160,0,5,5,1,7,7,'score=',Buffer[3]);
    WriteNumber(Buffer[2],160,15,5,5,1,43,7,Game.Score,Buffer[3]);
    WriteText(Buffer[2],160,0,5,5,1,7,13,'ammo =',Buffer[3]);
    WriteNumber(Buffer[2],160,15,5,5,1,43,13,Ammo,Buffer[3]);
    WriteText(Buffer[2],160,0,5,5,1,7,19,'lives=',Buffer[3]);
    WriteNumber(Buffer[2],160,15,5,5,1,43,19,Player.Lives,Buffer[3]);
  End;

  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;