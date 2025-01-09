Procedure PrecistZKnihovny(Index: Byte);
Var Cesta: String;
    JmenoSouboru: String;
    Ending: Boolean;
    MaxSoubor: Word;
    Nalezeno: Boolean;
    Y,X: Word;
    Backup: String;
Begin

  If Index<10 then
  Begin
    Case Index of
      0: Cesta:='KNIHOVNA\SESITY\SESIT01\';
      1: Cesta:='KNIHOVNA\SESITY\SESIT02\';
      2: Cesta:='KNIHOVNA\SESITY\SESIT03\';
      3: Cesta:='KNIHOVNA\SESITY\SESIT04\';
      4: Cesta:='KNIHOVNA\SESITY\SESIT05\';
      5: Cesta:='KNIHOVNA\SESITY\SESIT06\';
      6: Cesta:='KNIHOVNA\SESITY\SESIT07\';
      7: Cesta:='KNIHOVNA\SESITY\SESIT08\';
      8: Cesta:='KNIHOVNA\SESITY\SESIT09\';
      9: Cesta:='KNIHOVNA\SESITY\SESIT10\';
    End; {Case End}
    MaxSoubor:=5;
  End;

  If ((Index>=10) and (Index<15)) then
  Begin
    Case Index of
     10: Cesta:='KNIHOVNA\BLOKY\BLOK1\';
     11: Cesta:='KNIHOVNA\BLOKY\BLOK2\';
     12: Cesta:='KNIHOVNA\BLOKY\BLOK3\';
     13: Cesta:='KNIHOVNA\BLOKY\BLOK4\';
     14: Cesta:='KNIHOVNA\BLOKY\BLOK5\';
    End; {Case End}
    MaxSoubor:=59;
  End;

  If ((Index>=15) and (Index<20)) then
  Begin
    Case Index of
     15: Cesta:='KNIHOVNA\KNIHY\KNIHA1\';
     16: Cesta:='KNIHOVNA\KNIHY\KNIHA2\';
     17: Cesta:='KNIHOVNA\KNIHY\KNIHA3\';
     18: Cesta:='KNIHOVNA\KNIHY\KNIHA4\';
     19: Cesta:='KNIHOVNA\KNIHY\KNIHA5\';
    End; {Case End}
    MaxSoubor:=299;
  End;

  Backup:=Cesta;
  SouborKnih:=0;
  Ending:=False;
  Psani:=False;
  Cteni:=True;

  Cesta:=Backup;
  Str(SouborKnih+1,JmenoSouboru);
  If (SouborKnih+1)<10 then JmenoSouboru:='00'+JmenoSouboru;
  If (((SouborKnih+1)>=10) and ((SouborKnih+1)<100)) then JmenoSouboru:='0'+JmenoSouboru;
  Cesta:=Cesta+JmenoSouboru;
  Cesta:=Cesta+'.txt';

  Nalezeno:=False;
  Repeat
    FindFirst(Cesta, Archive, DirInfo);
    If DosError = 0 then Begin {jiz existuje}
                           Assign(Fi,Cesta);
                           Reset(Fi);
                           For Y:=0 to 24 do
                           For X:=0 to 79 do Read(Fi,stranka[Y,X]);
                           Close(Fi);
                           Nalezeno:=True;
                         End
                    else Begin {je treba vytvorit nebo neni pritomny}
                           If SouborKnih<MaxSoubor then Inc(SouborKnih);
                           Cesta:=Backup;
                           Str(SouborKnih+1,JmenoSouboru);
                           If (SouborKnih+1)<10 then JmenoSouboru:='00'+JmenoSouboru;
                           If (((SouborKnih+1)>=10) and ((SouborKnih+1)<100)) then JmenoSouboru:='0'+JmenoSouboru;
                           Cesta:=Cesta+JmenoSouboru;
                           Cesta:=Cesta+'.txt';

                           If SouborKnih=MaxSoubor then
                           Begin
                             Nalezeno:=True;
                             Ending:=True;
                           End;
                         End;
  Until Nalezeno=True;

  SVGA_TogglePaging;
  Repeat

    If Ending=False then
    Begin
      WriteStranka;
      Kbd_Rkey;
    End;

    If Key[75]=1 then
    Begin
      Kbd_RPush(75);
      If SouborKnih>0 then Dec(SouborKnih);

      Cesta:=Backup;
      Str(SouborKnih+1,JmenoSouboru);
      If (SouborKnih+1)<10 then JmenoSouboru:='00'+JmenoSouboru;
      If (((SouborKnih+1)>=10) and ((SouborKnih+1)<100)) then JmenoSouboru:='0'+JmenoSouboru;
      Cesta:=Cesta+JmenoSouboru;
      Cesta:=Cesta+'.txt';

      Nalezeno:=False;
      Repeat
        FindFirst(Cesta, Archive, DirInfo);
        If DosError = 0 then Begin {jiz existuje}
                               Assign(Fi,Cesta);
                               Reset(Fi);
                               For Y:=0 to 24 do
                               For X:=0 to 79 do Read(Fi,stranka[Y,X]);
                               Close(Fi);
                               Nalezeno:=True;
                             End
                        else Begin {je treba vytvorit nebo neni pritomny}
                               If SouborKnih>0 then Dec(SouborKnih);

                               Cesta:=Backup;
                               Str(SouborKnih+1,JmenoSouboru);
                               If (SouborKnih+1)<10 then JmenoSouboru:='00'+JmenoSouboru;
                               If (((SouborKnih+1)>=10) and ((SouborKnih+1)<100)) then JmenoSouboru:='0'+JmenoSouboru;
                               Cesta:=Cesta+JmenoSouboru;
                               Cesta:=Cesta+'.txt';

                               If SouborKnih=0 then
                               Begin
                                 Nalezeno:=True;
                               End;
                             End;
      Until Nalezeno=True;
    End;

    If Key[77]=1 then
    Begin
      Kbd_RPush(77);
      If SouborKnih<MaxSoubor then Inc(SouborKnih);

      Cesta:=Backup;
      Str(SouborKnih+1,JmenoSouboru);
      If (SouborKnih+1)<10 then JmenoSouboru:='00'+JmenoSouboru;
      If (((SouborKnih+1)>=10) and ((SouborKnih+1)<100)) then JmenoSouboru:='0'+JmenoSouboru;
      Cesta:=Cesta+JmenoSouboru;
      Cesta:=Cesta+'.txt';

      Nalezeno:=False;
      Repeat
        FindFirst(Cesta, Archive, DirInfo);
        If DosError = 0 then Begin {jiz existuje}
                               Assign(Fi,Cesta);
                               Reset(Fi);
                               For Y:=0 to 24 do
                               For X:=0 to 79 do Read(Fi,stranka[Y,X]);
                               Close(Fi);
                               Nalezeno:=True;
                             End
                        else Begin {je treba vytvorit nebo neni pritomny}
                               If SouborKnih<MaxSoubor then Inc(SouborKnih);

                               Cesta:=Backup;
                               Str(SouborKnih+1,JmenoSouboru);
                               If (SouborKnih+1)<10 then JmenoSouboru:='00'+JmenoSouboru;
                               If (((SouborKnih+1)>=10) and ((SouborKnih+1)<100)) then JmenoSouboru:='0'+JmenoSouboru;
                               Cesta:=Cesta+JmenoSouboru;
                               Cesta:=Cesta+'.txt';

                               If SouborKnih=MaxSoubor then
                               Begin
                                 Nalezeno:=True;
                               End;
                             End;
      Until Nalezeno=True;
    End;


    If Key[1]=1 then Begin
                       Kbd_RPush(1);
                       Ending:=True;
                     End;

  Until Ending=True;
  SVGA_TogglePaging;

End;
