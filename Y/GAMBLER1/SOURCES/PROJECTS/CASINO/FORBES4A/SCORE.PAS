Procedure AddScore(Number: Word);
Var Counter: Byte;
    I: Byte;
    zbytek: Byte;
    SoundCounter: Byte;

  Procedure DoDeseti(N: Byte);
  Var A: Byte;
  Begin
    Counter:=0;
    While N>0 do
    Begin
      If Counter<2 then
      Begin
        Inc(Counter);
        TestStopAutoStart;
        MainGameScreen;
        Wait(DatRec.fpsProdleva div 2);
      End else
      Begin
        Counter:=0;
        Inc(MultiWin);
        Dec(N);
        Dec(Vyhra.Castka);
        If DatRec.SBEnable=True then SBPlayRaw(15)
                                else PlaySound(5);
        MainGameScreen;
        Wait(DatRec.fpsProdleva div 2);
      End;
    End;
  End;

Begin
  VyhraShow:=False;
  CreditShow:=False;
  Vyhra.Castka:=Number;
  For I:=0 to 8 do Btn[I].Blinking:=False;
  For I:=0 to 8 do Btn[I].Phase:=0;
  VyhraShow:=True;
  CreditShow:=True;
  MainGameScreen;
  For I:=0 to 49 do Wait(DatRec.fpsProdleva);

  {prepocitani do multiwinu}
  If Number<=10
  then DoDeseti(Number)
  else Begin
         zbytek:=Number mod 10;
         DoDeseti(zbytek);
         Dec(Number,zbytek);

         Counter:=0;
         SoundCounter:=0;
         While Number>0 do
         Begin
           If Counter<2 then
           Begin
             Inc(Counter);
             TestStopAutoStart;
             MainGameScreen;
             Wait(DatRec.fpsProdleva div 2);
           End else
           Begin
             Counter:=0;
             Inc(MultiWin,5);
             Dec(Number,5);
             Dec(Vyhra.Castka,5);

             If ((SoundCounter>=0) and (SoundCounter<25)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(15)
                                       else PlaySound(5);
             End;
             If ((SoundCounter>=25) and (SoundCounter<50)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(16)
                                       else PlaySound(6);
             End;
             If ((SoundCounter>=50) and (SoundCounter<75)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(17)
                                       else PlaySound(7);
             End;
             If ((SoundCounter>=75) and (SoundCounter<100)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(12)
                                       else PlaySound(2);
             End;
             If ((SoundCounter>=100) and (SoundCounter<125)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(13)
                                       else PlaySound(3);
             End;
             If ((SoundCounter>=125) and (SoundCounter<=150)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(14)
                                       else PlaySound(4);
             End;

             MainGameScreen;
             Wait(DatRec.fpsProdleva div 2);

             If SoundCounter<150 then Inc(SoundCounter);
           End;
         End;
       End;
  VyhraShow:=False;
  CreditShow:=True;
  Vyhra.Castka:=0;
End;


Procedure AddScoreCollect(Number: Word);
Var Counter: Byte;
    I: Byte;
    zbytek: Byte;
    SoundCounter: Byte;

  Procedure DoDeseti(N: Byte);
  Var A: Byte;
  Begin
    Counter:=0;
    While N>0 do
    Begin
      If Counter<2 then
      Begin
        Inc(Counter);
        TestStopAutoStart;
        MainGameScreen;
        Wait(DatRec.fpsProdleva div 2);
      End else
      Begin
        Counter:=0;
        Inc(Credit);
        Dec(N);
        Dec(Vyhra.Castka);
        If DatRec.SBEnable=True then SBPlayRaw(15)
                                else PlaySound(5);
        MainGameScreen;
        Wait(DatRec.fpsProdleva div 2);
      End;
    End;
  End;

Begin
  Vyhra.Castka:=Number;
  If Lista[1].Enable=True then Vyhra.Castka:=Vyhra.Castka*Nasobic;

  For I:=0 to 8 do Btn[I].Blinking:=False;
  For I:=0 to 8 do Btn[I].Phase:=0;
  VyhraShow:=True;
  CreditShow:=True;
  MainGameScreen;
  For I:=0 to 49 do Wait(DatRec.fpsProdleva);

  {prepocitani do creditu}
  If Number<=10
  then DoDeseti(Number)
  else Begin
         zbytek:=Number mod 10;
         DoDeseti(zbytek);
         Dec(Number,zbytek);

         Counter:=0;
         SoundCounter:=0;
         While Number>0 do
         Begin
           If Counter<2 then
           Begin
             Inc(Counter);
             TestStopAutoStart;
             MainGameScreen;
             Wait(DatRec.fpsProdleva div 2);
           End else
           Begin
             Counter:=0;
             Inc(Credit,5);
             Dec(Number,5);
             Dec(Vyhra.Castka,5);

             If ((SoundCounter>=0) and (SoundCounter<25)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(15)
                                       else PlaySound(5);
             End;
             If ((SoundCounter>=25) and (SoundCounter<50)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(16)
                                       else PlaySound(6);
             End;
             If ((SoundCounter>=50) and (SoundCounter<75)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(17)
                                       else PlaySound(7);
             End;
             If ((SoundCounter>=75) and (SoundCounter<100)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(12)
                                       else PlaySound(2);
             End;
             If ((SoundCounter>=100) and (SoundCounter<125)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(13)
                                       else PlaySound(3);
             End;
             If ((SoundCounter>=125) and (SoundCounter<=150)) then
             Begin
               If DatRec.SBEnable=True then SBPlayRaw(14)
                                       else PlaySound(4);
             End;

             MainGameScreen;
             Wait(DatRec.fpsProdleva div 2);

             If SoundCounter<150 then Inc(SoundCounter);
           End;
         End;
       End;
  VyhraShow:=False;
  Vyhra.Castka:=0;
End;