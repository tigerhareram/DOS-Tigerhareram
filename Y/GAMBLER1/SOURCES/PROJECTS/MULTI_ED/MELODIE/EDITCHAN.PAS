Procedure EditChanScreen;
Begin
  ClearPage(Buffer[1]);
  Ramecek(0,0,319,14,253,Buffer[1]);
  OutText(3,3,'MULTI-EDITOR',Buffer[1]);
  Blok(80,3,121,13,254,Buffer[1]);
  OutText(80,3,'MELODIE',Buffer[1]);
  OutText(130,3,'soubor=',Buffer[1]);
  OutText(174,3,filename,Buffer[1]);
  OutText(270,3,'F10=EXIT',Buffer[1]);

  Blok(3,20,60,85,254,Buffer[1]);
  OutText(3,20,'F1=VYBRAT KANAL',Buffer[1]);
  OutText(3,33,'F8=SMAZAT KANAL',Buffer[1]);
  OutText(3,46,'F3=NAHRAT RTTTL',Buffer[1]);
  OutText(3,59,'F7=ZAPSAT RTTTL',Buffer[1]);
  OutText(3,72,'F2=SAVE',Buffer[1]);
  OutText(3,85,'ESC=BACK',Buffer[1]);


  Blok(120,60,230,89,254,Buffer[1]);
  Ramecek(120,60,230,89,253,Buffer[1]);
  OutText(125,65,'kanal=',Buffer[1]);
  OutNumber(160,66,KanalVolba,False,Buffer[1]);
  OutText(125,75,'rtttl=',Buffer[1]);
  OutText(157,75,FileNameText,Buffer[1]);

  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure EditChannel;
Var Ending: Boolean;
    I: Word;
Begin
  Ending:=False;
  KanalVolba:=0;
  Repeat
    EditChanScreen;

{F1}  If Key[59]=True then
      Begin
        While Key[59]=True do Begin End;
        If KanalVolba<7 then Inc(KanalVolba)
                        else KanalVolba:=0;
        FileNameText:='none';
      End;

{F8}  If Key[66]=True then
      Begin
        While Key[66]=True do Begin End;
        For I:=0 to 2999 do Mem[Melody.DataSeg:KanalVolba*3000+I]:=120;
        SoundDone;
      End;

{F3}  If Key[61]=True then
      Begin
        While Key[61]=True do Begin End;
        FileNameText:=ReadFileName;
        If FileNameText<>'' then FilenameText:=FileNameText+priponaTXT else FileNameText:='none';
        If FileNameText<>'none' then
        Begin
          FindFirst(FileNameText,Archive,DirInfo);
          If DosError=0 then
          Begin
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
            FileNameText:='none'
          End;
        End Else SoundStorno;
      End;

{F7}  If Key[65]=True then
      Begin
        While Key[65]=True do Begin End;
        If FileNameText<>'none' then
        Begin
          Assign(FText,FileNameText);
          Reset(FText);
          ZapsatRTTTL;
          Close(FText);
          SoundDone;
        End else
        SoundStorno;
      End;

{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        CountMelodyLenght;
        SaveMELFile(FileName);
        SoundDone;
      End;

{Esc} If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        FileNameText:='none';
        Ending:=True;
      End;

  Until Ending=True;
End;