Procedure WriterChat(Y1: Word);
Var I,N: Word;
    X,Y: Word;
    aa,bb,cc: Boolean;
    aa1,bb1,cc1: Byte;
Begin
  fillchar(stranka2,80*5,' ');
  SVGA_TogglePaging;

  {program inicializace}
  InsertMode:=True;
  KurzX:=0; KurzY:=0;
  WriteStrankaChat(Y1);

  Kbd_Done; {pozastavit lite keyboard}
  InitKlav; {Mircosoftova klaveska}

  If KlavesyInstalovany then
  Begin
    asm cli end;
    nastavrozlozeni(2); {czech layout} {xxx ceske je druhe}
    asm sti end;
    repeat
      SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
      If InsertMode=True then _Print(KurzX*8,KurzY*16+Y1,ColX[1],'Û')
                         else _Print(KurzX*8,KurzY*16+Y1,ColX[1],'Ü');

      SVGA_Rectangle(0,Y1,639,Y1+79,ColX[15]);   {green}

      Repeat Until Keypressed;                            {a cekani na process 4=message}

      if keypressed then znakW:=xReadKey {jestli neco bylo stisknuto, vyhodnotime to}
                    else znakw:=0; {jinak si sem dame nulu, aby bylo jasne, ze neni co vyhodnocovat}
      {xxx:}
      case znakw of xlsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                              _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka2[KurzY,KurzX]);
                              doleva2;
                            End;
                    xpsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                              _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka2[KurzY,KurzX]);
                              doprava2;
                            End;
                    xhsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                              _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka2[KurzY,KurzX]);
                              If KurzY>0 then Dec(KurzY);
                            End;
                    xdsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                              _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka2[KurzY,KurzX]);
                              If KurzY<4 then Inc(KurzY);
                            End;

                    xhome:Begin
                            SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                            _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka2[KurzY,KurzX]);
                            KurzX:=0;
                          End;
                    xend: Begin {za posledni znak na radku}
                            SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                            _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka2[KurzY,KurzX]);
                            kurzx:=79;
                            while (kurzx>0)and(stranka2[kurzy,kurzx]=' ') do dec(kurzx);
                            if ((kurzx>0) and (kurzx<79)) then inc(kurzx);
                          End;

                    xPgUp:Begin
                            SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                            _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka2[KurzY,KurzX]);
                            KurzY:=0;
                          End;
                    xPgDn:Begin
                            SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                            _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka2[KurzY,KurzX]);
                            KurzY:=4;
                          End;

                    xins:Begin
                           insertmode:=not insertmode;
                         End;
                    xdel:Begin
                           SmazZnak2(Y1);
                         End;

                    xbksp:Begin
                            doleva2;
                            SmazZnak2(Y1);;
                          End;

                    xenter:Begin
                             ZalomRadek2(Y1);;
                           End;

                    32..255:Begin {od mezery do konce ASCII tabulky - napsatelny znak}
                              znak:=chr(byte(znakw));
                              If InsertMode
                              then begin {vkladani - vsechno od kurzoru do konce stranky posuneme o pozici dal}
                                   if stranka2[4,79]=' ' {ale jenom jestli neni stranka uplne plna}
                                     then begin
                                          For I:=indexkonce2 downto KurzY*80+KurzX+1 do
                                            LinearniStranka2[I]:=LinearniStranka2[I-1];
                                          Stranka2[KurzY,KurzX]:=znak;
                                          WriteStrankaChat(Y1);
                                          doprava2;
                                          end;
                                    {else nic - jestli byla stranka zaplnena az do konce, nic nevkladame}
                                   end
                              else begin {prepisovani}
                                   Stranka2[KurzY,KurzX]:=znak;
                                   SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                                   _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka2[KurzY,KurzX]);
                                   doprava2;
                                   end;
                            End;
                    end;
                    kResetuj;

    until znakw=xEsc;
    {/xxx}

  End;
  ZrusKlav;

  Kbd_Init; {pokracovat lite keyboard}
  {program}
  SVGA_TogglePaging;

  Kbd_RPush(1);
End;
