Procedure WriterPlanet(Y1,Soubor: Word);
Var I,N: Word;
    X,Y: Word;
    Cesta: String;
    JmenoSouboru: String;
Begin
  Case Planeta of
    0: Cesta:='PLANETY\01\01-00\';
    1: Cesta:='PLANETY\02\02-00\';
    2: Cesta:='PLANETY\03\03-00\';
    3: Cesta:='PLANETY\03\03-01\';
    4: Cesta:='PLANETY\04\04-00\';
    5: Cesta:='PLANETY\04\04-01\';
    6: Cesta:='PLANETY\04\04-02\';
    7: Cesta:='PLANETY\05\05-00\';
    8: Cesta:='PLANETY\05\05-01\';
    9: Cesta:='PLANETY\05\05-02\';
   10: Cesta:='PLANETY\05\05-03\';
   11: Cesta:='PLANETY\05\05-04\';
   12: Cesta:='PLANETY\05\05-05\';
   13: Cesta:='PLANETY\05\05-06\';
   14: Cesta:='PLANETY\05\05-07\';
   15: Cesta:='PLANETY\05\05-08\';
   16: Cesta:='PLANETY\05\05-09\';
   17: Cesta:='PLANETY\05\05-10\';
   18: Cesta:='PLANETY\05\05-11\';
   19: Cesta:='PLANETY\05\05-12\';
   20: Cesta:='PLANETY\05\05-13\';
   21: Cesta:='PLANETY\05\05-14\';
   22: Cesta:='PLANETY\05\05-15\';
   23: Cesta:='PLANETY\05\05-16\';
   24: Cesta:='PLANETY\05\05-17\';
   25: Cesta:='PLANETY\05\05-18\';
   26: Cesta:='PLANETY\05\05-19\';
   27: Cesta:='PLANETY\05\05-20\';
   28: Cesta:='PLANETY\05\05-21\';
   29: Cesta:='PLANETY\05\05-22\';
   30: Cesta:='PLANETY\05\05-23\';
   31: Cesta:='PLANETY\05\05-24\';
   32: Cesta:='PLANETY\05\05-25\';
   33: Cesta:='PLANETY\05\05-26\';
   34: Cesta:='PLANETY\05\05-27\';
   35: Cesta:='PLANETY\05\05-28\';
   36: Cesta:='PLANETY\05\05-29\';
   37: Cesta:='PLANETY\05\05-30\';
   38: Cesta:='PLANETY\05\05-31\';
   39: Cesta:='PLANETY\05\05-32\';
   40: Cesta:='PLANETY\05\05-33\';
   41: Cesta:='PLANETY\05\05-34\';
   42: Cesta:='PLANETY\05\05-35\';
   43: Cesta:='PLANETY\05\05-36\';
   44: Cesta:='PLANETY\05\05-37\';
   45: Cesta:='PLANETY\05\05-38\';
   46: Cesta:='PLANETY\05\05-39\';
   47: Cesta:='PLANETY\05\05-40\';
   48: Cesta:='PLANETY\05\05-41\';
   49: Cesta:='PLANETY\05\05-42\';
   50: Cesta:='PLANETY\05\05-43\';
   51: Cesta:='PLANETY\05\05-44\';
   52: Cesta:='PLANETY\05\05-45\';
   53: Cesta:='PLANETY\05\05-46\';
   54: Cesta:='PLANETY\05\05-47\';
   55: Cesta:='PLANETY\05\05-48\';
   56: Cesta:='PLANETY\05\05-49\';
   57: Cesta:='PLANETY\05\05-50\';
   58: Cesta:='PLANETY\05\05-51\';
   59: Cesta:='PLANETY\05\05-52\';
   60: Cesta:='PLANETY\05\05-53\';
   61: Cesta:='PLANETY\05\05-54\';
   62: Cesta:='PLANETY\05\05-55\';
   63: Cesta:='PLANETY\05\05-56\';
   64: Cesta:='PLANETY\05\05-57\';
   65: Cesta:='PLANETY\05\05-58\';
   66: Cesta:='PLANETY\05\05-59\';
   67: Cesta:='PLANETY\05\05-60\';
   68: Cesta:='PLANETY\05\05-61\';
   69: Cesta:='PLANETY\05\05-62\';
   70: Cesta:='PLANETY\06\06-00\';
   71: Cesta:='PLANETY\06\06-01\';
   72: Cesta:='PLANETY\06\06-02\';
   73: Cesta:='PLANETY\06\06-03\';
   74: Cesta:='PLANETY\06\06-04\';
   75: Cesta:='PLANETY\06\06-05\';
   76: Cesta:='PLANETY\06\06-06\';
   77: Cesta:='PLANETY\06\06-07\';
   78: Cesta:='PLANETY\06\06-08\';
   79: Cesta:='PLANETY\06\06-09\';
   80: Cesta:='PLANETY\06\06-10\';
   81: Cesta:='PLANETY\06\06-11\';
   82: Cesta:='PLANETY\06\06-12\';
   83: Cesta:='PLANETY\06\06-13\';
   84: Cesta:='PLANETY\06\06-14\';
   85: Cesta:='PLANETY\06\06-15\';
   86: Cesta:='PLANETY\06\06-16\';
   87: Cesta:='PLANETY\06\06-17\';
   88: Cesta:='PLANETY\06\06-18\';
   89: Cesta:='PLANETY\06\06-19\';
   90: Cesta:='PLANETY\06\06-20\';
   91: Cesta:='PLANETY\06\06-21\';
   92: Cesta:='PLANETY\06\06-22\';
   93: Cesta:='PLANETY\06\06-23\';
   94: Cesta:='PLANETY\06\06-24\';
   95: Cesta:='PLANETY\06\06-25\';
   96: Cesta:='PLANETY\06\06-26\';
   97: Cesta:='PLANETY\06\06-27\';
   98: Cesta:='PLANETY\06\06-28\';
   99: Cesta:='PLANETY\06\06-29\';
  100: Cesta:='PLANETY\06\06-30\';
  101: Cesta:='PLANETY\06\06-31\';
  102: Cesta:='PLANETY\06\06-32\';
  103: Cesta:='PLANETY\06\06-33\';
  104: Cesta:='PLANETY\06\06-34\';
  105: Cesta:='PLANETY\06\06-35\';
  106: Cesta:='PLANETY\06\06-36\';
  107: Cesta:='PLANETY\06\06-37\';
  108: Cesta:='PLANETY\06\06-38\';
  109: Cesta:='PLANETY\06\06-39\';
  110: Cesta:='PLANETY\06\06-40\';
  111: Cesta:='PLANETY\06\06-41\';
  112: Cesta:='PLANETY\06\06-42\';
  113: Cesta:='PLANETY\06\06-43\';
  114: Cesta:='PLANETY\06\06-44\';
  115: Cesta:='PLANETY\06\06-45\';
  116: Cesta:='PLANETY\06\06-46\';
  117: Cesta:='PLANETY\06\06-47\';
  118: Cesta:='PLANETY\06\06-48\';
  119: Cesta:='PLANETY\06\06-49\';
  120: Cesta:='PLANETY\06\06-50\';
  121: Cesta:='PLANETY\07\07-00\';
  122: Cesta:='PLANETY\07\07-01\';
  123: Cesta:='PLANETY\07\07-02\';
  124: Cesta:='PLANETY\07\07-03\';
  125: Cesta:='PLANETY\07\07-04\';
  126: Cesta:='PLANETY\07\07-05\';
  127: Cesta:='PLANETY\07\07-06\';
  128: Cesta:='PLANETY\07\07-07\';
  129: Cesta:='PLANETY\07\07-08\';
  130: Cesta:='PLANETY\07\07-09\';
  131: Cesta:='PLANETY\07\07-10\';
  132: Cesta:='PLANETY\07\07-11\';
  133: Cesta:='PLANETY\07\07-12\';
  134: Cesta:='PLANETY\07\07-13\';
  135: Cesta:='PLANETY\07\07-14\';
  136: Cesta:='PLANETY\07\07-15\';
  137: Cesta:='PLANETY\07\07-16\';
  138: Cesta:='PLANETY\07\07-17\';
  139: Cesta:='PLANETY\07\07-18\';
  140: Cesta:='PLANETY\07\07-19\';
  141: Cesta:='PLANETY\07\07-20\';
  142: Cesta:='PLANETY\07\07-21\';
  143: Cesta:='PLANETY\07\07-22\';
  144: Cesta:='PLANETY\07\07-23\';
  145: Cesta:='PLANETY\07\07-24\';
  146: Cesta:='PLANETY\07\07-25\';
  147: Cesta:='PLANETY\07\07-26\';
  148: Cesta:='PLANETY\08\08-00\';
  149: Cesta:='PLANETY\08\08-01\';
  150: Cesta:='PLANETY\08\08-02\';
  151: Cesta:='PLANETY\08\08-03\';
  152: Cesta:='PLANETY\08\08-04\';
  153: Cesta:='PLANETY\08\08-05\';
  154: Cesta:='PLANETY\08\08-06\';
  155: Cesta:='PLANETY\08\08-07\';
  156: Cesta:='PLANETY\08\08-08\';
  157: Cesta:='PLANETY\08\08-09\';
  158: Cesta:='PLANETY\08\08-10\';
  159: Cesta:='PLANETY\08\08-11\';
  160: Cesta:='PLANETY\08\08-12\';
  161: Cesta:='PLANETY\08\08-13\';
  162: Cesta:='PLANETY\09\09-00\';
  163: Cesta:='PLANETY\09\09-01\';
  164: Cesta:='PLANETY\09\09-02\';
  165: Cesta:='PLANETY\09\09-03\';
  166: Cesta:='PLANETY\09\09-04\';
  167: Cesta:='PLANETY\09\09-05\';
  168: Cesta:='PLANETY\10\10-00\';
  169: Cesta:='PLANETY\10\10-01\';
  170: Cesta:='PLANETY\10\10-02\';
  171: Cesta:='PLANETY\11\11-00\';
  172: Cesta:='PLANETY\11\11-01\';
  173: Cesta:='LEGO\LEGO-01\';
  174: Cesta:='LEGO\LEGO-02\';
  175: Cesta:='LEGO\LEGO-03\';
  176: Cesta:='LEGO\LEGO-04\';
  177: Cesta:='LEGO\LEGO-05\';
  178: Cesta:='LEGO\LEGO-06\';
  179: Cesta:='LEGO\LEGO-07\';
  180: Cesta:='LEGO\LEGO-08\';
  181: Cesta:='LEGO\LEGO-09\';
  182: Cesta:='LEGO\LEGO-10\';
  183: Cesta:='LEGO\LEGO-11\';
  184: Cesta:='LEGO\LEGO-12\';
  185: Cesta:='LEGO\LEGO-13\';
  186: Cesta:='LEGO\LEGO-14\';
  187: Cesta:='LEGO\LEGO-15\';
  188: Cesta:='LEGO\LEGO-16\';
  189: Cesta:='LEGO\LEGO-17\';
  190: Cesta:='LEGO\LEGO-18\';
  191: Cesta:='LEGO\LEGO-19\';
  192: Cesta:='LEGO\LEGO-20\';
  193: Cesta:='LEGO\LEGO-21\';
  194: Cesta:='LEGO\LEGO-22\';
  195: Cesta:='LEGO\LEGO-23\';
  196: Cesta:='LEGO\LEGO-24\';
  197: Cesta:='LEGO\LEGO-25\';
  198: Cesta:='LEGO\LEGO-26\';
  199: Cesta:='LEGO\LEGO-27\';
  200: Cesta:='LEGO\LEGO-28\';
  201: Cesta:='LEGO\LEGO-29\';
  202: Cesta:='LEGO\LEGO-30\';
  203: Cesta:='LEGO\LEGO-31\';
  204: Cesta:='LEGO\LEGO-32\';
  205: Cesta:='LEGO\LEGO-33\';
  206: Cesta:='LEGO\LEGO-34\';
  207: Cesta:='LEGO\LEGO-35\';
  208: Cesta:='LEGO\LEGO-36\';
  209: Cesta:='LEGO\LEGO-37\';
  210: Cesta:='LEGO\LEGO-38\';
  211: Cesta:='LEGO\LEGO-39\';
  212: Cesta:='LEGO\LEGO-40\';
  213: Cesta:='LEGO\LEGO-41\';
  214: Cesta:='LEGO\LEGO-42\';
  215: Cesta:='LEGO\LEGO-43\';
  216: Cesta:='LEGO\LEGO-44\';
  217: Cesta:='LEGO\LEGO-45\';
  218: Cesta:='LEGO\LEGO-46\';
  219: Cesta:='LEGO\LEGO-47\';
  220: Cesta:='LEGO\LEGO-48\';
  221: Cesta:='LEGO\LEGO-49\';
  222: Cesta:='LEGO\LEGO-50\';
  223: Cesta:='LEGO\LEGO-51\';
  224: Cesta:='LEGO\LEGO-52\';
  225: Cesta:='LEGO\LEGO-53\';
  226: Cesta:='LEGO\LEGO-54\';
  227: Cesta:='LEGO\LEGO-55\';
  228: Cesta:='LEGO\LEGO-56\';
  229: Cesta:='LEGO\LEGO-57\';
  230: Cesta:='LEGO\LEGO-58\';
  231: Cesta:='LEGO\LEGO-59\';
  232: Cesta:='LEGO\LEGO-60\';
  233: Cesta:='LEGO\LEGO-61\';
  234: Cesta:='LEGO\LEGO-62\';
  235: Cesta:='LEGO\LEGO-63\';
  236: Cesta:='LEGO\LEGO-64\';
  237: Cesta:='LEGO\LEGO-65\';
  238: Cesta:='LEGO\LEGO-66\';
  239: Cesta:='LEGO\LEGO-67\';
  240: Cesta:='LEGO\LEGO-68\';
  241: Cesta:='LEGO\LEGO-69\';
  242: Cesta:='LEGO\LEGO-70\';
  243: Cesta:='LEGO\LEGO-71\';
  244: Cesta:='LEGO\LEGO-72\';
  245: Cesta:='LEGO\LEGO-73\';
  246: Cesta:='LEGO\LEGO-74\';
  247: Cesta:='LEGO\LEGO-75\';
  248: Cesta:='LEGO\LEGO-76\';
  249: Cesta:='LEGO\LEGO-77\';
  250: Cesta:='LEGO\LEGO-78\';
  251: Cesta:='LEGO\LEGO-79\';
  252: Cesta:='LEGO\LEGO-80\';
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
                         For Y:=0 to 19 do
                         For X:=0 to 39 do Read(Fi,stranka3[Y,X]);
                         Close(Fi);
                       End
                  else Begin {je treba vytvorit}
                         Assign(Fi,Cesta);
                         ReWrite(Fi);
                         fillchar(stranka3,40*20,' ');
                         For Y:=0 to 19 do
                         For X:=0 to 39 do Write(Fi,stranka3[Y,X]);
                         Close(Fi);
                       End;

  SVGA_TogglePaging;

  {program inicializace}
  InsertMode:=False;
  KurzX:=0; KurzY:=0;
  WriteStrankaPlanet(Y1);

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

      SVGA_Rectangle(0,Y1,319,Y1+319,ColX[15]); {levy panel}

      Repeat Until Keypressed;

      if keypressed then znakW:=xReadKey {jestli neco bylo stisknuto, vyhodnotime to}
                    else znakw:=0; {jinak si sem dame nulu, aby bylo jasne, ze neni co vyhodnocovat}
      {xxx:}
      case znakw of xlsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                              _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka3[KurzY,KurzX]);
                              doleva3;
                            End;
                    xpsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                              _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka3[KurzY,KurzX]);
                              doprava3;
                            End;
                    xhsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                              _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka3[KurzY,KurzX]);
                              If KurzY>0 then Dec(KurzY);
                            End;
                    xdsipka:Begin
                              SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                              _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka3[KurzY,KurzX]);
                              If KurzY<19 then Inc(KurzY);
                            End;

                    xhome:Begin
                            SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                            _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka3[KurzY,KurzX]);
                            KurzX:=0;
                          End;
                    xend: Begin {za posledni znak na radku}
                            SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                            _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka3[KurzY,KurzX]);
                            kurzx:=39;
                            while (kurzx>0)and(stranka3[kurzy,kurzx]=' ') do dec(kurzx);
                            if ((kurzx>0) and (kurzx<39)) then inc(kurzx);
                          End;

                    xPgUp:Begin
                            SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                            _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka3[KurzY,KurzX]);
                            KurzY:=0;
                          End;
                    xPgDn:Begin
                            SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                            _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka3[KurzY,KurzX]);
                            KurzY:=19;
                          End;

                    xins:Begin
                           insertmode:=not insertmode;
                         End;
                    xdel:Begin
                           SmazZnak3(Y1);
                         End;

                    xbksp:Begin
                            doleva3;
                            SmazZnak3(Y1);;
                          End;

                    xenter:Begin
                             ZalomRadek3(Y1);;
                           End;

                    32..255:Begin {od mezery do konce ASCII tabulky - napsatelny znak}
                              znak:=chr(byte(znakw));
                              If InsertMode
                              then begin {vkladani - vsechno od kurzoru do konce stranky posuneme o pozici dal}
                                   if stranka3[19,39]=' ' {ale jenom jestli neni stranka uplne plna}
                                     then begin
                                          For I:=indexkonce3 downto KurzY*40+KurzX+1 do
                                            LinearniStranka3[I]:=LinearniStranka3[I-1];
                                          Stranka3[KurzY,KurzX]:=znak;
                                          WriteStrankaPlanet(Y1);
                                          doprava3;
                                          end;
                                    {else nic - jestli byla stranka zaplnena az do konce, nic nevkladame}
                                   end
                              else begin {prepisovani}
                                   Stranka3[KurzY,KurzX]:=znak;
                                   SVGA_BarZ(KurzX*8,KurzY*16+Y1,KurzX*8+7,KurzY*16+15+Y1,ColX[0]);
                                   _Print(KurzX*8,KurzY*16+Y1,ColX[15],stranka3[KurzY,KurzX]);
                                   doprava3;
                                   end;
                            End;
                    end;
                    kResetuj;

    until znakw=xEsc;
    {/xxx}

    {ulozeni souboru}
    Assign(Fi,Cesta);
    ReWrite(Fi);
    For Y:=0 to 19 do
    For X:=0 to 39 do Write(Fi,stranka3[Y,X]);
    Close(Fi);

  End;
  ZrusKlav;

  Kbd_Init; {pokracovat lite keyboard}
  {program}
  SVGA_TogglePaging;

  Kbd_RPush(1);
End;
