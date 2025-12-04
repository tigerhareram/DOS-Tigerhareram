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


Procedure ReadFileNameScreen;
Begin
  OutText(5,187,'Zadejte jmeno souboru bez pripony o delce do 8 znaku.',Buffer[1]);
  Ramecek(120,95,230,109,253,Buffer[1]);
  Blok(121,96,229,108,254,Buffer[1]);
  OutText(123,98,'soubor=',Buffer[1]);
  Blok(166,98,229,108,254,Buffer[1]);
  OutText(166,98,readname,Buffer[1]);
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Function ReadFilename: String;
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
    ReadFileNameScreen;
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
  Blok(120,95,230,109,254,Buffer[1]);
  Blok(0,187,319,199,254,Buffer[1]);
  Blok(174,3,269,13,254,Buffer[1]);
  FlipPage(Buffer[1],Buffer[4]);
End;
