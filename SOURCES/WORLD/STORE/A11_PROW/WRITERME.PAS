Procedure WriterMemo(Soubor: Word);
Var I,N: Word;
    Cesta: String;
    JmenoSouboru: String;
    X,Y: Word;
Begin
  Case MainMenu of
    16: Cesta:='KNIHOVNA\SESITY\SESIT01\';
    17: Cesta:='KNIHOVNA\SESITY\SESIT02\';
    18: Cesta:='KNIHOVNA\SESITY\SESIT03\';
    19: Cesta:='KNIHOVNA\SESITY\SESIT04\';
    20: Cesta:='KNIHOVNA\SESITY\SESIT05\';
    21: Cesta:='KNIHOVNA\SESITY\SESIT06\';
    22: Cesta:='KNIHOVNA\SESITY\SESIT07\';
    23: Cesta:='KNIHOVNA\SESITY\SESIT08\';
    24: Cesta:='KNIHOVNA\SESITY\SESIT09\';
    25: Cesta:='KNIHOVNA\SESITY\SESIT10\';
    26: Cesta:='KNIHOVNA\BLOKY\BLOK1\';
    27: Cesta:='KNIHOVNA\BLOKY\BLOK2\';
    28: Cesta:='KNIHOVNA\BLOKY\BLOK3\';
    29: Cesta:='KNIHOVNA\BLOKY\BLOK4\';
    30: Cesta:='KNIHOVNA\BLOKY\BLOK5\';
    31: Cesta:='KNIHOVNA\KNIHY\KNIHA1\';
    32: Cesta:='KNIHOVNA\KNIHY\KNIHA2\';
    33: Cesta:='KNIHOVNA\KNIHY\KNIHA3\';
    34: Cesta:='KNIHOVNA\KNIHY\KNIHA4\';
    35: Cesta:='KNIHOVNA\KNIHY\KNIHA5\';
  End; {Case End}

  Str(Soubor+1,JmenoSouboru);
  If (Soubor+1)<10 then JmenoSouboru:='00'+JmenoSouboru;
  If (((Soubor+1)>=10) and ((Soubor+1)<100)) then JmenoSouboru:='0'+JmenoSouboru;
  Cesta:=Cesta+JmenoSouboru;
  Cesta:=Cesta+'.txt';

  FindFirst(Cesta, Archive, DirInfo);
  If DosError = 0 then Begin {jiz existuje}
                         Assign(Fi,Cesta);
                         Reset(Fi);
                         For Y:=0 to 24 do
                         For X:=0 to 79 do Read(Fi,stranka[Y,X]);
                         Close(Fi);
                       End
                  else Begin {je treba vytvorit}
                         Assign(Fi,Cesta);
                         ReWrite(Fi);
                         fillchar(stranka,80*25,' ');
                         For Y:=0 to 24 do
                         For X:=0 to 79 do Write(Fi,stranka[Y,X]);
                         Close(Fi);
                       End;

  SVGA_TogglePaging;

  {program inicializace}
  InsertMode:=False;
  KurzX:=0; KurzY:=0;
  Psani:=True;
  Cteni:=False;
  WriteStranka;

  Kbd_Done; {pozastavit lite keyboard}
  InitKlav; {Mircosoftova klaveska}

  If KlavesyInstalovany then
  Begin
    asm cli end;
    nastavrozlozeni(2); {czech layout} {xxx ceske je druhe}
    asm sti end;
    repeat
      SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
      If InsertMode=True then _Print(KurzX*8,KurzY*16,ColX[1],'Û')
                         else _Print(KurzX*8,KurzY*16,ColX[1],'Ü');

      Repeat Until Keypressed;

      if keypressed then znakW:=xReadKey {jestli neco bylo stisknuto, vyhodnotime to}
                    else znakw:=0; {jinak si sem dame nulu, aby bylo jasne, ze neni co vyhodnocovat}
      {xxx:}
      case znakw of xlsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
                              _Print(KurzX*8,KurzY*16,ColX[15],stranka[KurzY,KurzX]);
                              doleva;
                            End;
                    xpsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
                              _Print(KurzX*8,KurzY*16,ColX[15],stranka[KurzY,KurzX]);
                              doprava;
                            End;
                    xhsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
                              _Print(KurzX*8,KurzY*16,ColX[15],stranka[KurzY,KurzX]);
                              If KurzY>0 then Dec(KurzY);
                            End;
                    xdsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
                              _Print(KurzX*8,KurzY*16,ColX[15],stranka[KurzY,KurzX]);
                              If KurzY<24 then Inc(KurzY);
                            End;

                    xhome:Begin
                            SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
                            _Print(KurzX*8,KurzY*16,ColX[15],stranka[KurzY,KurzX]);
                            KurzX:=0;
                          End;
                    xend: Begin {za posledni znak na radku}
                            SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
                            _Print(KurzX*8,KurzY*16,ColX[15],stranka[KurzY,KurzX]);
                            kurzx:=79;
                            while (kurzx>0)and(stranka[kurzy,kurzx]=' ') do dec(kurzx);
                            if ((kurzx>0) and (kurzx<79)) then inc(kurzx);
                          End;

                    xPgUp:Begin
                            SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
                            _Print(KurzX*8,KurzY*16,ColX[15],stranka[KurzY,KurzX]);
                            KurzY:=0;
                          End;
                    xPgDn:Begin
                            SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
                            _Print(KurzX*8,KurzY*16,ColX[15],stranka[KurzY,KurzX]);
                            KurzY:=24;
                          End;

                    xins:Begin
                           insertmode:=not insertmode;
                         End;
                    xdel:Begin
                           SmazZnak;
                         End;

                    xbksp:Begin
                            doleva;
                            smazznak;
                          End;

                    xenter:Begin
                             ZalomRadek;
                           End;

                    32..255:Begin {od mezery do konce ASCII tabulky - napsatelny znak}
                              znak:=chr(byte(znakw));
                              If InsertMode
                              then begin {vkladani - vsechno od kurzoru do konce stranky posuneme o pozici dal}
                                   if stranka[24,79]=' ' {ale jenom jestli neni stranka uplne plna}
                                     then begin
                                          For I:=indexkonce downto KurzY*80+KurzX+1 do
                                            LinearniStranka[I]:=LinearniStranka[I-1];
                                          Stranka[KurzY,KurzX]:=znak;
                                          WriteStranka;
                                          doprava;
                                          end;
                                    {else nic - jestli byla stranka zaplnena az do konce, nic nevkladame}
                                   end
                              else begin {prepisovani}
                                   Stranka[KurzY,KurzX]:=znak;
                                   SVGA_BarZ(KurzX*8,KurzY*16,KurzX*8+7,KurzY*16+15,ColX[0]);
                                   _Print(KurzX*8,KurzY*16,ColX[15],stranka[KurzY,KurzX]);
                                   doprava;
                                   end;
                            End;
                    end;
                    kResetuj;
    until znakw=xEsc;
    {/xxx}

    {ulozeni souboru}
    Assign(Fi,Cesta);
    ReWrite(Fi);
    For Y:=0 to 24 do
    For X:=0 to 79 do Write(Fi,stranka[Y,X]);
    Close(Fi);

  End;
  ZrusKlav;

  Kbd_Init; {pokracovat lite keyboard}
  {program}
  SVGA_TogglePaging;
End;
