Procedure KresliPlanety; {statik}
Var I: Byte;
Begin
  SVGA_ClearPage(ColX[0]);
  SVGA_Rectangle(0,0,639,479,ColX[15]);
  SVGA_Rectangle(0,0,639,15,ColX[15]);
  Text_OutText(5,3,'Ovladani: Sipky,Enter,Backspace,Delete,Esc, IJKL+ASQW',Buffer[0],SVGA);
  Text_OutText(420,3,'* W.O.R.L.D. *',Buffer[0],SVGA);
  Text_OutText(590,3,'Esc=Exit',Buffer[0],SVGA);

  I:=0;  Text_OutText(20,30+15*I,'Cas',Buffer[0],SVGA);
         Text_OutText(50+00,30+15*I,TextD[1],Buffer[0],SVGA);
         Text_OutText(50+06,30+15*I,TextD[2],Buffer[0],SVGA);
         Text_OutText(50+12,30+15*I,'.'     ,Buffer[0],SVGA);
         Text_OutText(50+18,30+15*I,TextD[3],Buffer[0],SVGA);
         Text_OutText(50+24,30+15*I,TextD[4],Buffer[0],SVGA);
         Text_OutText(50+30,30+15*I,'.'     ,Buffer[0],SVGA);
         Text_OutText(50+36,30+15*I,TextD[5],Buffer[0],SVGA);
         Text_OutText(50+42,30+15*I,TextD[6],Buffer[0],SVGA);
         Text_OutText(50+48,30+15*I,TextD[7],Buffer[0],SVGA);
         Text_OutText(50+54,30+15*I,TextD[8],Buffer[0],SVGA);

  I:=1;  Text_OutText(20,30+15*I,'Chod planet',Buffer[0],SVGA);
         Text_OutText(20+72,30+15*I,'off',Buffer[0],SVGA);

  {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
  {Stitek} Text_OutText(10,455,'// KONJUNKCE PLANET //',Buffer[0],SVGA);

  svga_barz(160,15,639,479,0);
  vykreslisoustavu(400,250,90,datum);
  Text_OutNumber(160+10,27,TextDny,True,Buffer[0],SVGA);
  Text_OutNumber(160+28,27,TextMesice,True,Buffer[0],SVGA);
  Text_OutNumber(160+46,27,TextRoky,True,Buffer[0],SVGA);
  svga_rectangle(160,15,639,479,ColX[15]);

End;


Procedure ZatocPlanetami; {tocive}
Var I: Byte;
Begin
  Kbd_Done; {pozastavit lite keyboard}
  InitKlav; {Mircosoftova klaveska}
  kResetuj;

  {animace planet:}
  svga_resetpages;
  svga_togglepaging;
  repeat
    SVGA_ClearPage(ColX[0]);
    SVGA_WaitRetrace;
    SVGA_Rectangle(0,0,639,479,ColX[15]);
    SVGA_Rectangle(0,0,639,15,ColX[15]);
    Text_OutText(5,3,'Ovladani: Sipky,Enter,Backspace,Delete,Esc, IJKL+ASQW',Buffer[0],SVGA);
    Text_OutText(420,3,'* W.O.R.L.D. *',Buffer[0],SVGA);
    Text_OutText(590,3,'Esc=Exit',Buffer[0],SVGA);

    I:=0;  Text_OutText(20,30+15*I,'Cas',Buffer[0],SVGA);
           Text_OutText(50+00,30+15*I,TextD[1],Buffer[0],SVGA);
           Text_OutText(50+06,30+15*I,TextD[2],Buffer[0],SVGA);
           Text_OutText(50+12,30+15*I,'.'     ,Buffer[0],SVGA);
           Text_OutText(50+18,30+15*I,TextD[3],Buffer[0],SVGA);
           Text_OutText(50+24,30+15*I,TextD[4],Buffer[0],SVGA);
           Text_OutText(50+30,30+15*I,'.'     ,Buffer[0],SVGA);
           Text_OutText(50+36,30+15*I,TextD[5],Buffer[0],SVGA);
           Text_OutText(50+42,30+15*I,TextD[6],Buffer[0],SVGA);
           Text_OutText(50+48,30+15*I,TextD[7],Buffer[0],SVGA);
           Text_OutText(50+54,30+15*I,TextD[8],Buffer[0],SVGA);

    I:=1;  Text_OutText(20,30+15*I,'Chod planet',Buffer[0],SVGA);
           Text_OutText(20+72,30+15*I,'on',Buffer[0],SVGA);

    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(10,455,'// KONJUNKCE PLANET //',Buffer[0],SVGA);

    svga_barz(160,15,639,479,0);
    vykreslisoustavu(400,250,90,datum);
    Text_OutNumber(160+10,27,TextDny,True,Buffer[0],SVGA);
    Text_OutNumber(160+28,27,TextMesice,True,Buffer[0],SVGA);
    Text_OutNumber(160+46,27,TextRoky,True,Buffer[0],SVGA);
    svga_rectangle(160,15,639,479,ColX[15]);

    SVGA_WaitRetrace;
    SVGA_FlipPage;

    timer_wait(60);

    If TextDny<TextDnyVMesici then Inc(TextDny)
                              else Begin
                                     TextDny:=1;
                                     If TextMesice<12 then Inc(TextMesice)
                                                      else Begin
                                                             TextMesice:=1;
                                                             Inc(TextRoky);
                                                           End;
                                     Case TextMesice of
                                       1: TextDnyVMesici:=31;
                                       2: TextDnyVMesici:=28;
                                       3: TextDnyVMesici:=30;
                                       4: TextDnyVMesici:=31;
                                       5: TextDnyVMesici:=30;
                                       6: TextDnyVMesici:=31;
                                       7: TextDnyVMesici:=30;
                                       8: TextDnyVMesici:=31;
                                       9: TextDnyVMesici:=30;
                                      10: TextDnyVMesici:=31;
                                      11: TextDnyVMesici:=30;
                                      12: TextDnyVMesici:=31;
                                     End; {Case End}
                                   End;

    datum:=TextRoky+(TextMesice-1)/12+(TextDny-1)/365-(2016+10/12+5/365);

  until keypressed; {konci se stiskem klavesy}
  tocit_planetami:=False;
  svga_togglepaging;

  {uklid:}
  ZrusKlav;
  Kbd_Init;
End;