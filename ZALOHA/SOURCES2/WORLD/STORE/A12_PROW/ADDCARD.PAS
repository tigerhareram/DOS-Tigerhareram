Function VratNahodnouCestu: String;
Var Cislo: Byte;
Begin
  Randomize;
  Cislo:=Random(42)+1;
  Case Cislo of
    1: VratNahodnouCestu:='BITMAP\CARDS\01.bmp';
    2: VratNahodnouCestu:='BITMAP\CARDS\02.bmp';
    3: VratNahodnouCestu:='BITMAP\CARDS\03.bmp';
    4: VratNahodnouCestu:='BITMAP\CARDS\04.bmp';
    5: VratNahodnouCestu:='BITMAP\CARDS\05.bmp';
    6: VratNahodnouCestu:='BITMAP\CARDS\06.bmp';
    7: VratNahodnouCestu:='BITMAP\CARDS\07.bmp';
    8: VratNahodnouCestu:='BITMAP\CARDS\08.bmp';
    9: VratNahodnouCestu:='BITMAP\CARDS\09.bmp';
   10: VratNahodnouCestu:='BITMAP\CARDS\10.bmp';
   11: VratNahodnouCestu:='BITMAP\CARDS\11.bmp';
   12: VratNahodnouCestu:='BITMAP\CARDS\12.bmp';
   13: VratNahodnouCestu:='BITMAP\CARDS\13.bmp';
   14: VratNahodnouCestu:='BITMAP\CARDS\14.bmp';
   15: VratNahodnouCestu:='BITMAP\CARDS\15.bmp';
   16: VratNahodnouCestu:='BITMAP\CARDS\16.bmp';
   17: VratNahodnouCestu:='BITMAP\CARDS\17.bmp';
   18: VratNahodnouCestu:='BITMAP\CARDS\18.bmp';
   19: VratNahodnouCestu:='BITMAP\CARDS\19.bmp';
   20: VratNahodnouCestu:='BITMAP\CARDS\20.bmp';
   21: VratNahodnouCestu:='BITMAP\CARDS\21.bmp';
   22: VratNahodnouCestu:='BITMAP\CARDS\22.bmp';

   23: VratNahodnouCestu:='BITMAP\CARDS\coin01.bmp';
   24: VratNahodnouCestu:='BITMAP\CARDS\coinp.bmp';
   25: VratNahodnouCestu:='BITMAP\CARDS\coinq.bmp';
   26: VratNahodnouCestu:='BITMAP\CARDS\coink.bmp';
   27: VratNahodnouCestu:='BITMAP\CARDS\coinki.bmp';

   28: VratNahodnouCestu:='BITMAP\CARDS\cup01.bmp';
   29: VratNahodnouCestu:='BITMAP\CARDS\cupp.bmp';
   30: VratNahodnouCestu:='BITMAP\CARDS\cupq.bmp';
   31: VratNahodnouCestu:='BITMAP\CARDS\cupk.bmp';
   32: VratNahodnouCestu:='BITMAP\CARDS\cupki.bmp';

   33: VratNahodnouCestu:='BITMAP\CARDS\sword01.bmp';
   34: VratNahodnouCestu:='BITMAP\CARDS\swordp.bmp';
   35: VratNahodnouCestu:='BITMAP\CARDS\swordq.bmp';
   36: VratNahodnouCestu:='BITMAP\CARDS\swordk.bmp';
   37: VratNahodnouCestu:='BITMAP\CARDS\swordki.bmp';

   38: VratNahodnouCestu:='BITMAP\CARDS\wand01.bmp';
   39: VratNahodnouCestu:='BITMAP\CARDS\wandp.bmp';
   40: VratNahodnouCestu:='BITMAP\CARDS\wandq.bmp';
   41: VratNahodnouCestu:='BITMAP\CARDS\wandk.bmp';
   42: VratNahodnouCestu:='BITMAP\CARDS\wandki.bmp';
  End; {Case End}
End;


Procedure AddCard;
Begin
  If PocetKaret<3 then Inc(PocetKaret)
                  else Begin
                         PocetKaret:=0;
                         MainWorldScreen;
                       End;

  Case PocetKaret of
    0: Begin CestaCard1:=''; CestaCard2:=''; CestaCard3:=''; End;
    1: CestaCard1:=VratNahodnouCestu;
    2: Repeat
         CestaCard2:=VratNahodnouCestu;
       Until CestaCard2<>CestaCard1;
    3: Repeat
         CestaCard3:=VratNahodnouCestu;
       Until ((CestaCard3<>CestaCard1) and (CestaCard3<>CestaCard2));
  End; {Case End}

  SVGA_TogglePaging;
  If CestaCard1<>'' then Begin
                           LoadBMPFile(CestaCard1,0,0,0,80,Buffer[3]);
                           SVGA_SprZ(40,64,0,0,159,199,0,Buffer[3]);
                         End;
  If CestaCard2<>'' then Begin
                           LoadBMPFile(CestaCard2,0,0,0,100,Buffer[3]);
                           SVGA_SprZ(240,64,0,0,159,199,0,Buffer[3]);
                         End;
  If CestaCard3<>'' then Begin
                           LoadBMPFile(CestaCard3,0,0,0,120,Buffer[3]);
                           SVGA_SprZ(440,64,0,0,159,199,0,Buffer[3]);
                         End;
  SVGA_TogglePaging;
  Kbd_Rkey;
End;