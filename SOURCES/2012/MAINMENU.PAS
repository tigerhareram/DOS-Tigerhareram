Procedure MainMenuScreen;
Begin
  ClearPage(Buffer[1]);
  Ramecek(0,0,319,14,253,Buffer[1]);
  OutText(3,3,'MULTI-EDITOR',Buffer[1]);
  Blok(80,3,121,13,254,Buffer[1]);
  If TABGrafika=True then OutText(80,3,'GRAFIKA',Buffer[1]);
  If TABZvuky=True then OutText(80,3,'ZVUKY',Buffer[1]);
  If TABMelodie=True then OutText(80,3,'MELODIE',Buffer[1]);
  OutText(130,3,'soubor=',Buffer[1]);
  OutText(174,3,filename,Buffer[1]);
  OutText(270,3,'F10=EXIT',Buffer[1]);
  If ((TABGrafika=False) and (TABZvuky=False) and (TABMelodie=False)) then
  Begin
    Blok(3,20,60,85,254,Buffer[1]);
    OutText(3,20,'F1=GRAFIKA',Buffer[1]);
    OutText(3,33,'F2=ZVUKY',Buffer[1]);
    OutText(3,46,'F3=MELODIE',Buffer[1]);
  End;
  If ((TABGrafika=True) or (TABZvuky=True) or (TABMelodie=True)) then
  Begin
    Blok(3,20,60,85,254,Buffer[1]);
    OutText(3,20,'F4=NEW',Buffer[1]);
    OutText(3,33,'F2=SAVE',Buffer[1]);
    OutText(3,46,'F3=LOAD',Buffer[1]);
    If ((TABMelodie=True) or (TABGrafika=True)) then
    Begin
      OutText(3,59,'F5=EDITOR',Buffer[1]);
      OutText(3,72,'F6=IMPORT',Buffer[1]);
      OutText(3,85,'ESC=BACK',Buffer[1]);
    End else
    Begin
      OutText(3,59,'F5=EDITOR',Buffer[1]);
      OutText(3,72,'ESC=BACK',Buffer[1]);
    End;
  End;
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure MainMenu;
Var Ending: Boolean;
    I: Word;
Begin
  Ending:=False;
  Repeat
    MainMenuScreen;

    If ((TABGrafika=False) and (TABZvuky=False) and (TABMelodie=False)) then
    Begin
{F1}  If Key[59]=True then
      Begin
        While Key[59]=True do Begin End;
        TABZvuky:=False;
        TABGrafika:=True;
        TABMelodie:=False;
      End;
{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        TABZvuky:=True;
        TABGrafika:=False;
        TABMelodie:=False;
      End;
{F3}  If Key[61]=True then
      Begin
        While Key[61]=True do Begin End;
        TABZvuky:=False;
        TABGrafika:=False;
        TABMelodie:=True;
      End;
    End;

    If TABGrafika=True then
    Begin
{F5}  If Key[63]=True then
      Begin
        While Key[63]=True do Begin End;
        If Filename<>'none' then
        Begin
          TABGrafikaG0:=True;
          LoadBlok(0,0,0,0,159,199,Buffer[3]);
          EditG;
        End;
      End;
{F6}  If Key[64]=True then
      Begin
        While Key[64]=True do Begin End;
        If Filename<>'none' then
        Begin
          ImportBMP;
        End;
      End;
{F4}  If Key[62]=True then
      Begin
        FileName:=ReadFileName;
        If FileName<>'' then Filename:=FileName+priponaGRA else FileName:='none';
        If FileName<>'none' then
        Begin
          SaveGrPage(FileName);
          SoundDone;
        End Else SoundStorno;
      End;
{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        If FileName<>'none' then
        Begin
          SaveGrPage(FileName);
          SoundDone;
        End Else SoundStorno;
      End;
{F3}  If Key[61]=True then
      Begin
        FileName:=ReadFileName;
        If FileName<>'' then Filename:=FileName+priponaGRA else FileName:='none';
        If FileName<>'none' then
        Begin
          FindFirst(FileName,Archive,DirInfo);
          If DosError=0 then
          Begin
            LoadGrPage(FileName,0);
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
            FileName:='none'
          End;
        End Else SoundStorno;
      End;
{Esc} If Key[1]=True then
      Begin
        TABGrafika:=False;
        FileName:='none';
      End;
    End;

    If TABZvuky=True then
    Begin
{F5}  If Key[63]=True then
      Begin
        While Key[63]=True do Begin End;
        If Filename<>'none' then
        Begin
          TABZvukyT:=True;
          EditZ;
        End;
      End;
{F4}  If Key[62]=True then
      Begin
        FileName:=ReadFileName;
        If FileName<>'' then Filename:=FileName+priponaSND else FileName:='none';
        If FileName<>'none' then
        Begin
          SaveSNDFile(FileName);
          SoundDone;
        End Else SoundStorno;
      End;
{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        If FileName<>'none' then
        Begin
          SaveSNDFile(FileName);
          SoundDone;
        End Else SoundStorno;
      End;
{F3}  If Key[61]=True then
      Begin
        FileName:=ReadFileName;
        If FileName<>'' then Filename:=FileName+priponaSND else FileName:='none';
        If FileName<>'none' then
        Begin
          FindFirst(FileName,Archive,DirInfo);
          If DosError=0 then
          Begin
            LoadSNDFile(FileName,0);
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
            FileName:='none'
          End;
        End Else SoundStorno;
      End;
{Esc} If Key[1]=True then
      Begin
        TABZvuky:=False;
        FileName:='none';
      End;
    End;

    If TABMelodie=True then
    Begin
{F5}  If Key[63]=True then
      Begin
        While Key[63]=True do Begin End;
        If Filename<>'none' then
        Begin
          EditMel;
        End;
      End;
{F6}  If Key[64]=True then
      Begin
        While Key[64]=True do Begin End;
        If Filename<>'none' then
        Begin
          EditChannel;
        End;
      End;
{F4}  If Key[62]=True then
      Begin
        FileName:=ReadFilename;
        If FileName<>'' then Filename:=FileName+PriponaMEL else FileName:='none';
        If FileName<>'none' then
        Begin
          For I:=0 to 23999 do mem[Melody.DataSeg:I]:=120;
          For I:=0 to 7 do Begin
                             Melody.Kanal[I].Nastroj:=0;
                             Melody.Kanal[I].Balance:=63;
                             Melody.Kanal[I].DefaultOktava:=5;
                             RepNum[I]:=0;
                           End;
          Melody.Delka:=0;
          NotDrums:=1;
          SaveMELFile(FileName);
          SoundDone;
        End Else SoundStorno;
      End;
{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        If FileName<>'none' then
        Begin
          CountMelodyLenght;
          SaveMELFile(FileName);
          SoundDone;
        End Else SoundStorno;
      End;
{F3}  If Key[61]=True then
      Begin
        FileName:=ReadFileName;
        If FileName<>'' then Filename:=FileName+priponaMEL else FileName:='none';
        If FileName<>'none' then
        Begin
          FindFirst(FileName,Archive,DirInfo);
          If DosError=0 then
          Begin
            LoadMELFile(FileName,0);
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
            FileName:='none'
          End;
        End Else SoundStorno;
      End;
{Esc} If Key[1]=True then
      Begin
        TABMelodie:=False;
        FileName:='none';
      End;
    End;

    If Key[68]=True then Ending:=True;
  Until Ending=True;
End;