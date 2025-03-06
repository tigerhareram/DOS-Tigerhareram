Procedure ImportBMPScreen;
Begin
  ClearPage(Buffer[1]);
  Ramecek(0,0,319,14,253,Buffer[1]);
  OutText(3,3,'MULTI-EDITOR',Buffer[1]);
  Blok(80,3,121,13,254,Buffer[1]);
  OutText(80,3,'GRAFIKA',Buffer[1]);
  OutText(130,3,'soubor=',Buffer[1]);
  OutText(174,3,filename,Buffer[1]);
  OutText(270,3,'F10=EXIT',Buffer[1]);

  Blok(3,20,60,85,254,Buffer[1]);
  OutText(3,20,'F3=NAHRAT BMP',Buffer[1]);
  OutText(3,33,'F4=VYBRAT BARVU 1',Buffer[1]);
  OutText(3,46,'F5=VYBRAT BARVU 2',Buffer[1]);
  OutText(3,59,'F6=VYBRAT BARVU 3',Buffer[1]);
  OutText(3,72,'F7=ZAPSAT BMP',Buffer[1]);
  OutText(3,85,'F2=SAVE',Buffer[1]);
  OutText(3,98,'ESC=BACK',Buffer[1]);

  Blok(120,60,230,89,254,Buffer[1]);
  Ramecek(120,60,230,89,253,Buffer[1]);
  If FileNameBMP<>'none' then
  Begin
    OutText(125,65,'barvy=',Buffer[1]);
    Ramecek(164,66,183,73,253,Buffer[1]);
    Blok(165,67,182,72,ImportBarva1,Buffer[1]);
    Ramecek(185,66,204,73,253,Buffer[1]);
    Blok(186,67,203,72,ImportBarva2,Buffer[1]);
    Ramecek(206,66,225,73,253,Buffer[1]);
    Blok(207,67,224,72,ImportBarva3,Buffer[1]);
  End;
  OutText(125,75,'bmp=',Buffer[1]);
  OutText(151,75,FileNameBMP,Buffer[1]);

  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;

Procedure ImportBMP;
Var Ending: Boolean;
    I: Word;
Begin
  Ending:=False;
  Repeat
    ImportBMPScreen;

{F4}  If Key[62]=True then
      Begin
        While Key[62]=True do Begin End;
        If FileNameBMP<>'none' then
        Begin
          If ImportBarva1<31 then Inc(ImportBarva1)
                             else ImportBarva1:=16;
        End else SoundStorno;
      End;

{F5}  If Key[63]=True then
      Begin
        While Key[63]=True do Begin End;
        If FileNameBMP<>'none' then
        Begin
          If ImportBarva2<31 then Inc(ImportBarva2)
                             else ImportBarva2:=16;
        End else SoundStorno;
      End;

{F6}  If Key[64]=True then
      Begin
        While Key[64]=True do Begin End;
        If FileNameBMP<>'none' then
        Begin
          If ImportBarva3<31 then Inc(ImportBarva3)
                             else ImportBarva3:=16;
        End else SoundStorno;
      End;

{F3}  If Key[61]=True then
      Begin
        While Key[61]=True do Begin End;
        FileNameBMP:=ReadFileName;
        If FileNameBMP<>'' then FileNameBMP:=FileNameBMP+priponaBMP else FileNameBMP:='none';
        If FileNameBMP<>'none' then
        Begin
          FindFirst(FileNameBMP,Archive,DirInfo);
          If DosError=0 then
          Begin
            LoadBmpFile(FileNameBMP,0,16);
            LoadBitMap(0,0,Buffer[2]);
            SoundDone;
          End Else
          Begin
            Ramecek(120,95,246,109,253,Buffer[1]);
            OutText(123,98,'CHYBA Esc=pokracovat',Buffer[1]);
            WaitRetrace;
            FlipPage(Buffer[1],Buffer[4]);
            SoundStorno;
            Repeat Until Key[1]=True;
            While Key[1]=True do Begin End;
            Blok(120,95,246,109,254,Buffer[1]);
            WaitRetrace;
            FlipPage(Buffer[1],Buffer[4]);
            FileNameBMP:='none'
          End;
        End Else SoundStorno;
      End;

{F7}  If Key[65]=True then
      Begin
        While Key[65]=True do Begin End;
        If FileNameBMP<>'none' then
        Begin
          Bmp2Gra;
          ClearPage(Buffer[2]);
          SoundDone;
        End else
        SoundStorno;
      End;


{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        SaveGrPage(FileName);
        SoundDone;
      End;

{Esc} If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        FileNameBMP:='none';
        Ending:=True;
      End;

  Until Ending=True;
End;