Procedure StiskKlavesy(kl: Byte);
Var znak: char;
    retezec: string;
Begin
  If ((readnameZbyva>0) and (readnamePos<9)) then
  Begin
  Case kl of
      2: readname[readnamePos]:='1';
      3: readname[readnamePos]:='2';
      4: readname[readnamePos]:='3';
      5: readname[readnamePos]:='4';
      6: readname[readnamePos]:='5';
      7: readname[readnamePos]:='6';
      8: readname[readnamePos]:='7';
      9: readname[readnamePos]:='8';
     10: readname[readnamePos]:='9';
     11: readname[readnamePos]:='0';
     16: readname[readnamePos]:='q';
     17: readname[readnamePos]:='w';
     18: readname[readnamePos]:='e';
     19: readname[readnamePos]:='r';
     20: readname[readnamePos]:='t';
     21: readname[readnamePos]:='y';
     22: readname[readnamePos]:='u';
     23: readname[readnamePos]:='i';
     24: readname[readnamePos]:='o';
     25: readname[readnamePos]:='p';
     30: readname[readnamePos]:='a';
     31: readname[readnamePos]:='s';
     32: readname[readnamePos]:='d';
     33: readname[readnamePos]:='f';
     34: readname[readnamePos]:='g';
     35: readname[readnamePos]:='h';
     36: readname[readnamePos]:='j';
     37: readname[readnamePos]:='k';
     38: readname[readnamePos]:='l';
     44: readname[readnamePos]:='z';
     45: readname[readnamePos]:='x';
     46: readname[readnamePos]:='c';
     47: readname[readnamePos]:='v';
     48: readname[readnamePos]:='b';
     49: readname[readnamePos]:='n';
     50: readname[readnamePos]:='m';
    End; {Case End}
    If readnamePos<9 then Inc(readnamePos);
    If readnameZbyva>1 then Dec(readnameZbyva);
  End;
End;


Procedure ReadFileNameScreen(MG: Byte);
Begin
  OutText(5,187,'Zadejte jmeno souboru bez pripony o delce do 8 znaku.',Buffer[3]);
  Ramecek(187,25+MG,316,39+MG,253,Buffer[3]);
  Ramecek(80,25+MG,180,39+MG,253,Buffer[3]);
  Blok(81,26+MG,179,38+MG,254,Buffer[3]);
  OutText(83,28+MG,'soubor=',Buffer[3]);
  Blok(126,28+MG,179,38+MG,254,Buffer[3]);
  OutText(126,28+MG,readname,Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Function ReadFilename(MG: Boolean): String;
Var Ending: Boolean;
    A,I: Byte;
    znak: char;
    retezec: string;
Begin
  Ending:=False;
  readname:='        ';
  readnamePos:=1;
  readnameZbyva:=8;
  Repeat
    If MG=True then ReadFileNameScreen(0)
               else ReadFileNameScreen(20);
    WaitKey;
    For I:=2 to 11 do If Key[I]=True then Begin StiskKlavesy(I); End;
    For I:=16 to 25 do If Key[I]=True then Begin StiskKlavesy(I); End;
    For I:=30 to 38 do If Key[I]=True then Begin StiskKlavesy(I); End;
    For I:=44 to 50 do If Key[I]=True then Begin StiskKlavesy(I); End;
    If Key[14]=True then {BackSpace}
    Begin
      If readnameZbyva<8 then Inc(readnameZbyva);
      If readnamePos>1 then Dec(readnamePos);
      readname[readnamePos]:=' ';
    End;
    If Key[28]=True then {Enter}
    Begin
      While Key[28]=True do Begin End;
      A:=0;
      retezec:='';
      For I:=8 downto 1 do If readname[I]=' ' then Inc(A);
      A:=8-A;
      For I:=1 to A do
      Begin
        znak:=readname[I];
        retezec:=retezec+znak;
      End;
      readname:=retezec;
      ReadFileName:=readname;
      Ending:=True;
    End;
    If Key[1]=True then {Esc}
    Begin
      While Key[1]=True do Begin End;
      ReadFileName:='';
      Ending:=True;
    End;
  Until Ending=True;
  If MG=True then Begin
                    Blok(80,25,180,39,254,Buffer[3]);
                    Ramecek(187,25,316,39,254,Buffer[3]);
                  End
             else Begin
                    Blok(80,65,180,79,254,Buffer[3]);
                    Ramecek(187,65,316,69,254,Buffer[3]);
                  End;
  Blok(0,187,319,199,254,Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure WriteReadRozmerScreen(Q:Boolean;Cislo:Word);
Begin
  OutText(5,187,'insert,delete=+-1 home,end=+-10 pgup,pgdn=+-100',Buffer[3]);
  If Q=True then
  Begin
    Ramecek(80,65,180,79,253,Buffer[3]);
    Ramecek(187,65,316,79,253,Buffer[3]);
    OutText(83,68,'rozmerX=',Buffer[3]);
    Blok(133,69,179,78,254,Buffer[3]);
    OutNumber(133,69,Cislo,False,Buffer[3]);
  End else
  Begin
    Ramecek(80,85,180,99,253,Buffer[3]);
    Ramecek(187,85,316,99,253,Buffer[3]);
    OutText(83,88,'rozmerY=',Buffer[3]);
    Blok(133,89,179,98,254,Buffer[3]);
    OutNumber(133,89,Cislo,False,Buffer[3]);
  End;
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Function ReadRozmer(XY: Boolean): Word;
Var Ending: Boolean;
    Cislo: Word;
Begin
  Ending:=False;
  Cislo:=0;
  WriteReadRozmerScreen(XY,Cislo);
  Repeat
{Insert} If ((Key[82]=True) or (Key[22]=True)) then
{U}      Begin
           While Key[82]=True do WaitButton(82);
           While Key[22]=True do WaitButton(22);
           If Cislo<640 then Inc(Cislo);
           WriteReadRozmerScreen(XY,Cislo);
         End;
{Delete} If ((Key[83]=True) or (Key[36]=True)) then
{J}      Begin
           While Key[83]=True do WaitButton(83);
           While Key[36]=True do WaitButton(36);
           If Cislo>0 then Dec(Cislo);
           WriteReadRozmerScreen(XY,Cislo);
         End;
{Home}   If ((Key[71]=True) or (Key[23]=True)) then
{I}      Begin
           While Key[71]=True do WaitButton(71);
           While Key[23]=True do WaitButton(23);
           If Cislo<630 then Inc(Cislo,10);
           WriteReadRozmerScreen(XY,Cislo);
         End;
{End}    If ((Key[79]=True) or (Key[37]=True)) then
{K}      Begin
           While Key[79]=True do WaitButton(79);
           While Key[37]=True do WaitButton(37);
           If Cislo>=10 then Dec(Cislo,10);
           WriteReadRozmerScreen(XY,Cislo);
         End;
{PgUp}   If ((Key[73]=True) or (Key[24]=True)) then
{O}      Begin
           While Key[73]=True do WaitButton(73);
           While Key[24]=True do WaitButton(24);
           If Cislo<540 then Inc(Cislo,100);
           WriteReadRozmerScreen(XY,Cislo);
         End;
{PgDown} If ((Key[81]=True) or (Key[38]=True)) then
{L}      Begin
           While Key[81]=True do WaitButton(81);
           While Key[38]=True do WaitButton(38);
           If Cislo>=100 then Dec(Cislo,100);
           WriteReadRozmerScreen(XY,Cislo);
         End;

{Enter} If Key[28]=True then
        Begin
          While Key[28]=True do Begin End;
          Ending:=True;
        End;

{Esc}   If Key[1]=True then
        Begin
          While Key[1]=True do Begin End;
          Ending:=True;
        End;
  Until Ending=True;

  ReadRozmer:=Cislo;
  If XY=True then Begin
                    Ramecek(80,65,180,79,254,Buffer[3]);
                    Ramecek(187,65,316,79,254,Buffer[3]);
                  End
             else Begin
                    Ramecek(80,85,180,99,254,Buffer[3]);
                    Ramecek(187,85,316,99,254,Buffer[3]);
                  End;
  Blok(0,187,319,199,254,Buffer[3]);
End;


Procedure WriteMenuScreen;
Begin
  ClearPage(Buffer[3]);
  Ramecek(0,0,319,14,253,Buffer[3]);
  OutText(3,3,'EDITOR MAPY T1',Buffer[3]);
  OutText(270,3,'F10=EXIT',Buffer[3]);
  OutText(270,3,'F10=EXIT',Buffer[3]);
  OutText(3,20,'F4=NEW',Buffer[3]);
  OutText(3,33,'F2=SAVE',Buffer[3]);
  OutText(3,46,'F3=LOAD',Buffer[3]);
  OutText(3,59,'F5=EDITOR',Buffer[3]);
  OutText(190,28,'Mapa=',Buffer[3]);
  OutText(224,28,MapName,Buffer[3]);
  OutText(190,48,'Grafika=',Buffer[3]);
  OutText(238,48,GraName,Buffer[3]);
  OutText(190,68,'rozmerX=',Buffer[3]);
  OutNumber(240,69,rozmerX,False,Buffer[3]);
  OutText(190,88,'rozmerY=',Buffer[3]);
  OutNumber(240,89,rozmerY,False,Buffer[3]);
  Blok(190,108,319,199,254,Buffer[3]);
  OutText(190,108,'velikost=',Buffer[3]);
  OutNumber(239,109,rozmerX*rozmerY,False,Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure ErrorStav(N: Byte);
Begin
  Case N of
    0: OutText(5,187,'CHYBA: ZADANI MAPY NEBO GRAFIKY ... ESC',Buffer[3]);
    1: OutText(5,187,'CHYBA: OTEVIRANI MAPY ... ESC',Buffer[3]);
    2: OutText(5,187,'CHYBA: OTEVIRANI GRAFIKY ... ESC',Buffer[3]);
    3: OutText(5,187,'CHYBA: ROZMER MIMO ROZSAH 64000 ... ESC',Buffer[3]);
    4: OutText(5,187,'CHYBA: VELIKOST NENI DELITELNA 16TI ... ESC',Buffer[3]);
    5: OutText(5,187,'CHYBA: ROZMER X JE MENSI NEZ 20 ... ESC',Buffer[3]);
    6: OutText(5,187,'CHYBA: ROZMER Y JE MENSI NEZ 12 ... ESC',Buffer[3]);
    7: OutText(5,187,'CHYBA: VYPLNIT INFORMACE ... ESC',Buffer[3]);
  End; {Case End}
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
  SoundStorno;
  Repeat Until Key[1]=True;
  Blok(0,187,319,199,254,Buffer[3]);
  MapName:='none';
  GraName:='none';
  rozmerX:=0;
  rozmerY:=0;
  WriteMenuScreen;
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Function MapDialog: Boolean;
Var Velikost: LongInt;
Begin
  MapDialog:=False;
  MapName:='';
  GraName:='';
  rozmerX:=0;
  rozmerY:=0;

  MapName:=ReadFileName(True);
  If MapName<>'' then MapName:=MapName+'.map' else MapName:='none';
  WriteMenuScreen;
  GraName:=ReadFileName(False);
  If GraName<>'' then GraName:=GraName+'.gra' else GraName:='none';
  WriteMenuScreen;
  RozmerX:=ReadRozmer(True);
  WriteMenuScreen;
  RozmerY:=ReadRozmer(False);
  WriteMenuScreen;
  Velikost:=rozmerX*rozmerY;
  If ((MapName<>'none') and (GraName<>'none')) then
  Begin
    If (Velikost<=64000) then
    Begin
      If ((Velikost) mod 16)=0 then MapDialog:=True
                               else ErrorStav(4);
    End else ErrorStav(3);
  End else ErrorStav(0);
End;


Procedure MainMenu;
Var Ending: Boolean;
    Velikost: LongInt;
Begin
  Ending:=False;
  MapName:='none';
  GraName:='none';
  rozmerX:=0;
  rozmerY:=0;
  Repeat
  WriteMenuScreen;
  WaitKey;

{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        Velikost:=rozmerX*rozmerY;
        If (((MapName<>'none') and (GraName<>'none')) and
            (Velikost<=64000) and (((Velikost) mod 16)=0)) then
        Begin
          If RozmerX>=20 then
          Begin
            If RozmerY>=12 then
            Begin
              SaveMapFile(MapName);
              SoundDone;
            End else ErrorStav(6);
          End else ErrorStav(5);
        End;
      End;

{F3}  If Key[61]=True then
      Begin
        If MapDialog=True then
        Begin
          FindFirst(MapName,Archive,DirInfo);
          If DosError=0 then
          Begin
            FindFirst(GraName,Archive,DirInfo);
            If DosError=0 then
            Begin
              Velikost:=rozmerX*rozmerY;
              InitMapBuffers(Velikost);
              LoadMapFile(MapName,0);
              LoadGrPage(GraName,0);
              LoadBlok(0,0,0,0,159,199,Buffer[1]);
              SoundDone;
            End else ErrorStav(2);
          End else ErrorStav(1);
        End;
      End;

{F4}  If Key[62]=True then
      Begin
        If MapDialog=True then
        Begin
          Velikost:=rozmerX*rozmerY;
          InitMapBuffers(Velikost);
          SaveMapFile(MapName);
          FindFirst(GraName,Archive,DirInfo);
          If DosError=0 then
          Begin
            LoadGrPage(GraName,0);
            LoadBlok(0,0,0,0,159,199,Buffer[1]);
            SoundDone;
          End else ErrorStav(2);
        End;
      End;

{F5}  If Key[63]=True then
      Begin
        While Key[63]=True do Begin End;
        Velikost:=rozmerX*rozmerY;
        If (((MapName<>'none') and (GraName<>'none')) and
            (Velikost<=64000) and (((Velikost) mod 16)=0)) then
        Begin
          If RozmerX>=20 then
          Begin
            If RozmerY>=12 then
            Begin
              EditMap;
            End else ErrorStav(6);
          End else ErrorStav(5);
        End else ErrorStav(7);
      End;

{F10} If Key[68]=True then Ending:=True;

  Until Ending=True;
End;