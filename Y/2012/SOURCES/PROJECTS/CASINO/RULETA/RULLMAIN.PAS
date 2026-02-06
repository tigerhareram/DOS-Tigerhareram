Procedure RullKulicka;
Begin
  If CisloRulety>0 then Dec(CisloRulety)
                   else CisloRulety:=37;
  StopPlay;
  PlaySound(5);
End;


Procedure RullMain;
Var I: Word;
    counter,N,Color2: Byte;
Begin
  counter:=0;
  Randomize;
  CisloRulety:=Random(38);
  RuletaStoji:=False;
  For I:=0 to 450 do
  Begin
    If ((I>=0) and (I<90)) then RullKulicka;

    If ((I>=90) and (I<120)) then
    Begin
      If counter<2 then Begin
                          Inc(counter);
                          RullKulicka;
                        End
                   else counter:=0;


    End;

    If ((I>=120) and (I<150)) then
    Begin
      If counter<2 then Inc(counter)
                   else Begin
                          counter:=0;
                          RullKulicka;
                        End;
    End;

    If ((I>=150) and (I<180)) then
    Begin
      If counter<3 then Inc(counter)
                   else Begin
                          counter:=0;
                          RullKulicka;
                        End;
    End;

    If ((I>=180) and (I<210)) then
    Begin
      If counter<4 then Inc(counter)
                   else Begin
                          counter:=0;
                          RullKulicka;
                        End;
    End;

    If ((I>=210) and (I<240)) then
    Begin
      If counter<5 then Inc(counter)
                   else Begin
                          counter:=0;
                          RullKulicka;
                        End;
    End;

    If ((I>=240) and (I<270)) then
    Begin
      If counter<6 then Inc(counter)
                   else Begin
                          counter:=0;
                          RullKulicka;
                        End;
    End;

    If ((I>=270) and (I<300)) then
    Begin
      If counter<7 then Inc(counter)
                   else Begin
                          counter:=0;
                          RullKulicka;
                        End;
    End;

    If ((I>=300) and (I<330)) then
    Begin
      If counter<8 then Inc(counter)
                   else Begin
                          counter:=0;
                          RullKulicka;
                        End;
    End;

    If ((I>=330) and (I<360)) then
    Begin
      If counter<9 then Inc(counter)
                   else Begin
                          counter:=0;
                          RullKulicka;
                        End;
    End;

    If ((I>=360) and (I<390)) then
    Begin
      If counter<10 then Inc(counter)
                    else Begin
                           counter:=0;
                           RullKulicka;
                         End;
    End;

    If ((I>=390) and (I<420)) then
    Begin
      If counter<11 then Inc(counter)
                    else Begin
                           counter:=0;
                           RullKulicka;
                         End;
    End;

    If ((I>=420) and (I<450)) then
    Begin
      If counter<12 then Inc(counter)
                    else Begin
                           counter:=0;
                           RullKulicka;
                         End;
    End;

    {ruleta}
    WriteBlok(252,133,252,133,319,199,Buffer[1],Buffer[3]);

    {kulicka}
    If RuletaStoji=False then
    Begin
      WritePixel(283+KulickaXY[CisloRulety].X,164+KulickaXY[CisloRulety].Y,160+14,Buffer[3]);
      WritePixel(283+KulickaXY[CisloRulety].X-1,164+KulickaXY[CisloRulety].Y,160+14,Buffer[3]);
      WritePixel(283+KulickaXY[CisloRulety].X+1,164+KulickaXY[CisloRulety].Y,160+14,Buffer[3]);
      WritePixel(283+KulickaXY[CisloRulety].X,164+KulickaXY[CisloRulety].Y-1,160+14,Buffer[3]);
      WritePixel(283+KulickaXY[CisloRulety].X,164+KulickaXY[CisloRulety].Y+1,160+14,Buffer[3]);
    End;

    Blok(276,159,290,169,160+0,Buffer[3]);
    Ramecek(276,159,290,169,160+14,Buffer[3]);

    {cislo}
    Case CisloRulety of
       0: Begin N:=0;  Color2:=1; End;
       1: Begin N:=28; Color2:=5; End;
       2: Begin N:=9;  Color2:=3; End;
       3: Begin N:=26; Color2:=5; End;
       4: Begin N:=30; Color2:=3; End;
       5: Begin N:=11; Color2:=5; End;
       6: Begin N:=7;  Color2:=3; End;
       7: Begin N:=20; Color2:=5; End;
       8: Begin N:=32; Color2:=3; End;
       9: Begin N:=17; Color2:=5; End;
      10: Begin N:=5;  Color2:=3; End;
      11: Begin N:=22; Color2:=5; End;
      12: Begin N:=34; Color2:=3; End;
      13: Begin N:=15; Color2:=5; End;
      14: Begin N:=3;  Color2:=3; End;
      15: Begin N:=24; Color2:=5; End;
      16: Begin N:=36; Color2:=3; End;
      17: Begin N:=13; Color2:=5; End;
      18: Begin N:=1;  Color2:=3; End;
      19: Begin N:=99; Color2:=1; End;
      20: Begin N:=27; Color2:=3; End;
      21: Begin N:=10; Color2:=5; End;
      22: Begin N:=25; Color2:=3; End;
      23: Begin N:=29; Color2:=5; End;
      24: Begin N:=12; Color2:=3; End;
      25: Begin N:=8;  Color2:=5; End;
      26: Begin N:=19; Color2:=3; End;
      27: Begin N:=31; Color2:=5; End;
      28: Begin N:=18; Color2:=3; End;
      29: Begin N:=6;  Color2:=5; End;
      30: Begin N:=21; Color2:=3; End;
      31: Begin N:=33; Color2:=5; End;
      32: Begin N:=16; Color2:=3; End;
      33: Begin N:=4;  Color2:=5; End;
      34: Begin N:=23; Color2:=3; End;
      35: Begin N:=35; Color2:=5; End;
      36: Begin N:=14; Color2:=3; End;
      37: Begin N:=2;  Color2:=5; End;
    End; {Case End}

    Blok(276,159,290,169,160+Color2,Buffer[3]);
    Ramecek(276,159,290,169,160+14,Buffer[3]);

    If N=99 then OutText(278,160,'00',Buffer[3])
            else OutNumber(278,161,N,False,Buffer[3]);

    WaitRetrace;
    FlipPage(Buffer[3],Buffer[4]);
  End;
End;