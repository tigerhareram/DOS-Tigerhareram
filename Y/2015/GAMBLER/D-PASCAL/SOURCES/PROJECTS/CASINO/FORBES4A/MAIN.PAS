Procedure MainScreen;
Var I: Byte;
Begin
  ClearPage(Buffer[3]);

  Ramecek(0,0,319,199,ColorGreen,Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,6,3,'jackpot',Buffer[3]);
  WriteNumber(Buffer[1],160,80,8,16,1,10,10,DatRec2.JackPot,Buffer[3]);

  OutText(6,28,'REKORD',Buffer[3]);
  OutNumber(10,38,DatRec2.HiScore,False,Buffer[3]);

  For I:=0 to 60 do WritePixel(4+I,47,ColorGreen,Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,6,50,'hra',Buffer[3]);
  Zisky(27,50,0);
  WriteText(Buffer[1],160,0,5,5,1,6,57,'historie',Buffer[3]);
  For I:=1 to MaxHistorie do Zisky(10,57+(I*7),I);

  Ramecek(272,150,312,170,ColorGreen,Buffer[3]);
  OutText(278,156,'Bazar',Buffer[3]);

  WriteText(Buffer[1],160,0,5,5,1,268,5,'f10=exit',Buffer[3]);
  If ((VkladyTMP<>VyplacenoTMP) and (Credit=0) and (Multiwin=0))
  then Begin
         WriteText(Buffer[1],160,0,5,5,1,268,178,'z=zapsat',Buffer[3]);
         Ramecek(220,150,267,170,ColorGreen,Buffer[3]);
         OutText(226,156,'Zapsat',Buffer[3]);
       End;
  WriteText(Buffer[1],160,0,5,5,1,268,185,'p=penize',Buffer[3]);
  WriteText(Buffer[1],160,0,5,5,1,257,192,'o=ovladani',Buffer[3]);

  If Fps2s=True then Begin
                       WriteSprite(72,80,0,64,79,87,Buffer[1],Buffer[3]);
                       WriteSprite(168,80,80,64,159,87,Buffer[1],Buffer[3]);
                     End
                else Blok(72,80,247,103,ColorBlack,Buffer[3]);

  WaitRetrace;
  HideMouse;
  FlipPage(Buffer[3],Buffer[4]);
  ShowMouse;
End;


Procedure Main;
Var Ending: Boolean;
    I: Byte;
Begin
  Ending:=False;
  MainScreen;

  MainGame;
  DatRec2.Vklad[0]:=VkladyTMP;
  DatRec2.Vyplaceno[0]:=VyplacenoTMP;
  If VyplacenoTMP>VkladyTMP then
  Begin
    If (VyplacenoTMP-VkladyTMP) > DatRec2.HiScore
    then DatRec2.HiScore:=VyplacenoTMP-VkladyTMP;
  End;

  Repeat
    MainScreen;
    Wait(DatRec.fpsProdleva);

{Enter} If ((Key[28]=True) or (EnterStiskly1=1)) then
        Begin
          While Key[28]=True do Begin End;
          MainGame;
          DatRec2.Vklad[0]:=VkladyTMP;
          DatRec2.Vyplaceno[0]:=VyplacenoTMP;
          If VyplacenoTMP>VkladyTMP then
          Begin
            If (VyplacenoTMP-VkladyTMP) > DatRec2.HiScore
            then DatRec2.HiScore:=VyplacenoTMP-VkladyTMP;
          End;
        End;

{O}     If Key[24]=True then
        Begin
          While Key[24]=True do Begin End;
          Ovladani;
        End;

{Z}     If Key[44]=True then
        Begin
          While Key[44]=True do Begin End;
          HistorieHer;
        End;

{P}     If ((Key[25]=True) or (GetButton3=1) or (BazarStiskly1=1)) then
        Begin
          While ((Key[25]=True) or (GetButton3=1) or (BazarStiskly1=1)) do Begin End;
          Prodat;
        End;

{Z}     If ((Key[25]=True) or (GetButton3=1) or (ZapsatStiskly1=1)) then
        Begin
          While ((Key[25]=True) or (GetButton3=1) or (ZapsatStiskly1=1)) do Begin End;
          HistorieHer;
        End;

{F10}   If ((Key[68]=True) or (GetButton2=1)) then Ending:=True;

  Until Ending=True;
  SaveLoadPenize(True);
  SaveLoadForbes(True);
End;
