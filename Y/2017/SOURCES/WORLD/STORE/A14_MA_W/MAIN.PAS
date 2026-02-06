Procedure KnihovnaInfoOperate;
Var Y: Byte;
Begin
  FileName:='KNIHOVNA\index.dat';
  FindFirst(FileName , Archive, DirInfo);
  If DosError = 0 then Begin {jiz existuje}
                         Assign(F,FileName);
                         Reset(F,SizeOf(KnihovnaInfo));
                         BlockRead(F,KnihovnaInfo,1);
                         Close(F);
                       End
                  else Begin {je treba vytvorit}
                         For Y:=0 to 9 do KnihovnaInfo.JmenaSesitu[Y]:='';
                         For Y:=0 to 4 do KnihovnaInfo.JmenaBloku[Y]:='';
                         For Y:=0 to 4 do KnihovnaInfo.JmenaKnih[Y]:='';

                         {ulozeni jmen knih a sesitu}
                         Assign(F,FileName);
                         ReWrite(F,SizeOf(KnihovnaInfo));
                         BlockWrite(F,KnihovnaInfo,1);
                         Close(F);
                       End;

  MainWorldScreen;
End;


Procedure Main;
Var I,N: Word;
    Rs,Gs,Bs: Byte;
    Retez: String;
    Ending: Boolean;
Begin
  KonecProgramu:=False;
  MainMenu:=0;
  MainMenuSel:=0;
  MainMenuMax:=6;
  LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);     {Grafika}

  Repeat
    MainWorldScreen;

    i:=0;
    Repeat
    if i<25 then Begin
                   Inc(i);
                   Timer_Wait(20);
                   If KeyCode<128 then i:=25;
                 End;
    Until i>=25;

    If ServerPripojen=True then
    Begin
      Networking(9);
    End;

{Up}     If ((Key[72]=1) or (Key[23]=1)) then
         Begin
           If Key[72]=1 then Kbd_RPush(72);
           If Key[23]=1 then Kbd_RPush(23);
           If MainMenuSel>0 then Dec(MainMenuSel);
         End;

{Down}   If ((Key[80]=1) or (Key[37]=1)) then
         Begin
           If Key[80]=1 then Kbd_RPush(80);
           If Key[37]=1 then Kbd_RPush(37);
           If MainMenuSel<MainMenuMax then Inc(MainMenuSel);
         End;

{Left}   If ((Key[75]=1) or (Key[36]=1)) then
         Begin
           If Key[75]=1 then Kbd_RPush(75);
           If Key[36]=1 then Kbd_RPush(36);
           If ((MainMenu=15) and (MainMenuSel>=60)) then Dec(MainMenuSel);
           If MainMenu=13
           then Begin
                  If MainMenuSel>9 then Dec(MainMenuSel,10);
                End
           else Begin
                  If MainMenu<>36 then
                  Begin
                    If ((MainMenuMax>20) and not ((MainMenu=15) and (MainMenuSel>=60))) then
                    Begin
                      If MainMenuSel>19 then Dec(MainMenuSel,20);
                    End;
                  End else
                  Begin
                    If MainMenuSel>9 then Dec(MainMenuSel,10);
                  End;
                End;
         End;

{Right}  If ((Key[77]=1) or (Key[38]=1)) then
         Begin
           If Key[77]=1 then Kbd_RPush(77);
           If Key[38]=1 then Kbd_RPush(38);
           If ((MainMenu=15) and ((MainMenuSel>=60) and (MainMenuSel<64))) then Inc(MainMenuSel);
           If MainMenu=13
           then Begin
                  If MainMenuSel<MainMenuMax-11 then Inc(MainMenuSel,10);
                End
           else Begin
                  If MainMenu<>36 then
                  Begin
                    If MainMenuMax>20 then
                    Begin
                      If MainMenuSel<MainMenuMax-19 then Inc(MainMenuSel,20);
                    End;
                  End else
                  Begin
                    If MainMenuSel<MainMenuMax-9 then Inc(MainMenuSel,10);
                  End;
                End;
         End;

{Enter}  If ((Key[28]=1) or (Key[30]=1)) then
         Begin
           If Key[28]=1 then Kbd_RPush(28);
           If Key[30]=1 then Kbd_RPush(30);
           Case MainMenu of
  {MainMenu} 0: Begin
                  Case MainMenuSel of
                    0: Begin
                         MainMenu:=1;       {Soustava}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=10;
                         LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);    {Grafika}
                         LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                       End;
                    1: Begin
                         MainMenu:=13;      {Generator}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=41;
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                    2: Begin
                         MainMenu:=14;      {Network}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=2;
                       End;
                    3: Begin
                         MainMenu:=15;      {Kniha}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=64;
                         FileName:='KNIHOVNA\index.dat';
                         FindFirst(FileName , Archive, DirInfo);
                         If DosError = 0 then Begin {jiz existuje}
                                                Assign(F,FileName);
                                                Reset(F,SizeOf(KnihovnaInfo));
                                                BlockRead(F,KnihovnaInfo,1);
                                                Close(F);
                                              End
                                         else Begin {je treba vytvorit}
                                                Assign(F,FileName);
                                                ReWrite(F,SizeOf(KnihovnaInfo));
                                                BlockWrite(F,KnihovnaInfo,1);
                                                Close(F);
                                              End;
                       End;
                    4: Begin
                         MainMenu:=36;
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=79;
                       End;
                    5: Begin
                         MainMenu:=37;        {Planety}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=1;
                         _nactifont(FFont,'INT21H\space.fnt');
                         _NastavFont(FFont,True);
                         datum:=TextRoky+(TextMesice-1)/12+(TextDny-1)/365-(2016+10/12+5/365);
                       End;
                    6: Begin
                         KonecProgramu:=True; {Exit}
                       End;
                  End; {Case End}
                End;
{Soustava 1} 1: Begin
                  Case MainMenuSel of
                    0: Begin {Merkur}
                         MainMenu:=2;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                       End;
                    1: Begin {Venuse}
                         MainMenu:=3;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                       End;
                    2: Begin {Zeme}
                         MainMenu:=4;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=1;
                       End;
                    3: Begin {Mars}
                         MainMenu:=5;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=2;
                       End;
                    4: Begin {Jupiter}
                         MainMenu:=6;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=62;
                       End;
                    5: Begin {Saturn}
                         MainMenu:=7;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=50;
                       End;
                    6: Begin {Uran}
                         MainMenu:=8;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=26;
                       End;
                    7: Begin {Neptun}
                         MainMenu:=9;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=13;
                       End;
                    8: Begin {Pluto}
                         MainMenu:=10;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    9: Begin {Haumea}
                         MainMenu:=11;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=2;
                       End;
                   10: Begin {Eris}
                         MainMenu:=12;
                         MainMenuSelSave2:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=1;
                       End;
                  End; {Case End}
                End;
{Merkur}     2: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta Merkur}
                         Planeta:=0;
                         PlanetLoad(0,0); PlanetProc(0,0);
                       End;
                  End; {Case End}
                End;
{Venuse}     3: Begin
                Case MainMenuSel of
                    0: Begin {Planeta Venuse}
                         Planeta:=1;
                         PlanetLoad(1,0); PlanetProc(1,0);
                       End;
                  End; {Case End}
                End;
{Zeme}       4: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta Zeme}
                         Planeta:=2;
                         PlanetLoad(2,0); PlanetProc(2,0);
                       End;
                    1: Begin {Mesic}
                         Planeta:=3;
                         PlanetLoad(2,1); PlanetProc(2,1);
                       End;
                  End; {Case End}
                End;
{Mars}       5: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta Mars}
                         Planeta:=4;
                         PlanetLoad(3,0); PlanetProc(3,0);
                       End;
                    1: Begin {Phobos}
                         Planeta:=5;
                         PlanetLoad(3,1); PlanetProc(3,1);
                       End;
                    2: Begin {Deimos}
                         Planeta:=6;
                         PlanetLoad(3,2); PlanetProc(3,2);
                       End;
                  End; {Case End}
                End;
{Jupiter}    6: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta Jupiter}
                         Planeta:=7;
                         PlanetLoad(4,0); PlanetProc(4,0);
                       End;
                    1: Begin {Adrastea}
                         Planeta:=8;
                         PlanetLoad(4,1); PlanetProc(4,1);
                       End;
                    2: Begin {Amalthea}
                         Planeta:=9;
                         PlanetLoad(4,2); PlanetProc(4,2);
                       End;
                    3: Begin {Thebe}
                         Planeta:=10;
                         PlanetLoad(4,3); PlanetProc(4,3);
                       End;
                    4: Begin {Io}
                         Planeta:=11;
                         PlanetLoad(4,4); PlanetProc(4,4);
                       End;
                    5: Begin {Europa}
                         Planeta:=12;
                         PlanetLoad(4,5); PlanetProc(4,5);
                       End;
                    6: Begin {Ganymed}
                         Planeta:=13;
                         PlanetLoad(4,6); PlanetProc(4,6);
                       End;
                    7: Begin {Callisto}
                         Planeta:=14;
                         PlanetLoad(4,7); PlanetProc(4,7);
                       End;
                    8: Begin {Themisto}
                         Planeta:=15;
                         PlanetLoad(4,8); PlanetProc(4,8);
                       End;
                    9: Begin {Leda}
                         Planeta:=16;
                         PlanetLoad(4,9); PlanetProc(4,9);
                       End;
                   10: Begin {Himalia}
                         Planeta:=17;
                         PlanetLoad(4,10); PlanetProc(4,10);
                       End;
                   11: Begin {Lysithea}
                         Planeta:=18;
                         PlanetLoad(4,11); PlanetProc(4,11);
                       End;
                   12: Begin {Elara}
                         Planeta:=19;
                         PlanetLoad(4,12); PlanetProc(4,12);
                       End;
                   13: Begin {S/2000 J11}
                         Planeta:=20;
                         PlanetLoad(4,13); PlanetProc(4,13);
                       End;
                   14: Begin {Carpo}
                         Planeta:=21;
                         PlanetLoad(4,14); PlanetProc(4,14);
                       End;
                   15: Begin {S/2003 J3}
                         Planeta:=22;
                         PlanetLoad(4,15); PlanetProc(4,15);
                       End;
                   16: Begin {S/2003 J12}
                         Planeta:=23;
                         PlanetLoad(4,16); PlanetProc(4,16);
                       End;
                   17: Begin {Euporie}
                         Planeta:=24;
                         PlanetLoad(4,17); PlanetProc(4,17);
                       End;
                   18: Begin {Mneme}
                         Planeta:=25;
                         PlanetLoad(4,18); PlanetProc(4,18);
                       End;
                   19: Begin {S/2003 J18}
                         Planeta:=26;
                         PlanetLoad(4,19); PlanetProc(4,19);
                       End;
                   20: Begin {Helike}
                         Planeta:=27;
                         PlanetLoad(4,20); PlanetProc(4,20);
                       End;
                   21: Begin {S/2003 J16}
                         Planeta:=28;
                         PlanetLoad(4,21); PlanetProc(4,21);
                       End;
                   22: Begin {Euanthe}
                         Planeta:=29;
                         PlanetLoad(4,22); PlanetProc(4,22);
                       End;
                   23: Begin {Harpalyke}
                         Planeta:=30;
                         PlanetLoad(4,23); PlanetProc(4,23);
                       End;
                   24: Begin {Praxidike}
                         Planeta:=31;
                         PlanetLoad(4,24); PlanetProc(4,24);
                       End;
                   25: Begin {Thelxinoe}
                         Planeta:=32;
                         PlanetLoad(4,25); PlanetProc(4,25);
                       End;
                   26: Begin {Orthosie}
                         Planeta:=33;
                         PlanetLoad(4,26); PlanetProc(4,26);
                       End;
                   27: Begin {Hermippe}
                         Planeta:=34;
                         PlanetLoad(4,27); PlanetProc(4,27);
                       End;
                   28: Begin {Locaste}
                         Planeta:=35;
                         PlanetLoad(4,28); PlanetProc(4,28);
                       End;
                   29: Begin {Ananke}
                         Planeta:=36;
                         PlanetLoad(4,29); PlanetProc(4,29);
                       End;
                   30: Begin {Thyone}
                         Planeta:=37;
                         PlanetLoad(4,30); PlanetProc(4,30);
                       End;
                   31: Begin {S/2003 J15}
                         Planeta:=38;
                         PlanetLoad(4,31); PlanetProc(4,31);
                       End;
                   32: Begin {S/2003 J17}
                         Planeta:=39;
                         PlanetLoad(4,32); PlanetProc(4,32);
                       End;
                   33: Begin {Kallichore}
                         Planeta:=40;
                         PlanetLoad(4,33); PlanetProc(4,33);
                       End;
                   34: Begin {S/2003 J9}
                         Planeta:=41;
                         PlanetLoad(4,34); PlanetProc(4,34);
                       End;
                   35: Begin {S/2003 J19}
                         Planeta:=42;
                         PlanetLoad(4,35); PlanetProc(4,35);
                       End;
                   36: Begin {Pasithee}
                         Planeta:=43;
                         PlanetLoad(4,36); PlanetProc(4,36);
                       End;
                   37: Begin {Arche}
                         Planeta:=44;
                         PlanetLoad(4,37); PlanetProc(4,37);
                       End;
                   38: Begin {Kale}
                         Planeta:=45;
                         PlanetLoad(4,38); PlanetProc(4,38);
                       End;
                   39: Begin {Chaldene}
                         Planeta:=46;
                         PlanetLoad(4,39); PlanetProc(4,39);
                       End;
                   40: Begin {Isonoe}
                         Planeta:=47;
                         PlanetLoad(4,40); PlanetProc(4,40);
                       End;
                   41: Begin {Eurydome}
                         Planeta:=48;
                         PlanetLoad(4,41); PlanetProc(4,41);
                       End;
                   42: Begin {S/2003 J4}
                         Planeta:=49;
                         PlanetLoad(4,42); PlanetProc(4,42);
                       End;
                   43: Begin {Erinome}
                         Planeta:=50;
                         PlanetLoad(4,43); PlanetProc(4,43);
                       End;
                   44: Begin {Taygete}
                         Planeta:=51;
                         PlanetLoad(4,44); PlanetProc(4,44);
                       End;
                   45: Begin {Carme}
                         Planeta:=52;
                         PlanetLoad(4,45); PlanetProc(4,45);
                       End;
                   46: Begin {Aitne}
                         Planeta:=53;
                         PlanetLoad(4,46); PlanetProc(4,46);
                       End;
                   47: Begin {S/2003 J23}
                         Planeta:=54;
                         PlanetLoad(4,47); PlanetProc(4,47);
                       End;
                   48: Begin {Kalyke}
                         Planeta:=55;
                         PlanetLoad(4,48); PlanetProc(4,48);
                       End;
                   49: Begin {Pasiphae}
                         Planeta:=56;
                         PlanetLoad(4,49); PlanetProc(4,49);
                       End;
                   50: Begin {Megaclite}
                         Planeta:=57;
                         PlanetLoad(4,50); PlanetProc(4,50);
                       End;
                   51: Begin {Aoede}
                         Planeta:=58;
                         PlanetLoad(4,51); PlanetProc(4,51);
                       End;
                   52: Begin {Sponde}
                         Planeta:=59;
                         PlanetLoad(4,52); PlanetProc(4,52);
                       End;
                   53: Begin {Sinope}
                         Planeta:=60;
                         PlanetLoad(4,53); PlanetProc(4,53);
                       End;
                   54: Begin {Cyllene}
                         Planeta:=61;
                         PlanetLoad(4,54); PlanetProc(4,54);
                       End;
                   55: Begin {S/2003 J5}
                         Planeta:=62;
                         PlanetLoad(4,55); PlanetProc(4,55);
                       End;
                   56: Begin {Callirrhoe}
                         Planeta:=63;
                         PlanetLoad(4,56); PlanetProc(4,56);
                       End;
                   57: Begin {Autonoe}
                         Planeta:=64;
                         PlanetLoad(4,57); PlanetProc(4,57);
                       End;
                   58: Begin {S/2003 J10}
                         Planeta:=65;
                         PlanetLoad(4,58); PlanetProc(4,58);
                       End;
                   59: Begin {Hegemone}
                         Planeta:=66;
                         PlanetLoad(4,59); PlanetProc(4,59);
                       End;
                   60: Begin {Eukelade}
                         Planeta:=67;
                         PlanetLoad(4,60); PlanetProc(4,60);
                       End;
                   61: Begin {S/2003 J14}
                         Planeta:=68;
                         PlanetLoad(4,61); PlanetProc(4,61);
                       End;
                   62: Begin {S/2003 J2}
                         Planeta:=69;
                         PlanetLoad(4,62); PlanetProc(4,62);
                       End;
                  End; {Case End}
                End;
{Saturn}     7: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta Saturn}
                         Planeta:=70;
                         PlanetLoad(5,0); PlanetProc(5,0);
                       End;
                    1: Begin {Pan}
                         Planeta:=71;
                         PlanetLoad(5,1); PlanetProc(5,1);
                       End;
                    2: Begin {S/2005 S1}
                         Planeta:=72;
                         PlanetLoad(5,2); PlanetProc(5,2);
                       End;
                    3: Begin {Atlas}
                         Planeta:=73;
                         PlanetLoad(5,3); PlanetProc(5,3);
                       End;
                    4: Begin {Prometheus}
                         Planeta:=74;
                         PlanetLoad(5,4); PlanetProc(5,4);
                       End;
                    5: Begin {S/2004 S4}
                         Planeta:=75;
                         PlanetLoad(5,5); PlanetProc(5,5);
                       End;
                    6: Begin {S/2004 S6}
                         Planeta:=76;
                         PlanetLoad(5,6); PlanetProc(5,6);
                       End;
                    7: Begin {S/2004 S3}
                         Planeta:=77;
                         PlanetLoad(5,7); PlanetProc(5,7);
                       End;
                    8: Begin {Pandora}
                         Planeta:=78;
                         PlanetLoad(5,8); PlanetProc(5,8);
                       End;
                    9: Begin {Epimatheus}
                         Planeta:=79;
                         PlanetLoad(5,9); PlanetProc(5,9);
                       End;
                   10: Begin {Janus}
                         Planeta:=80;
                         PlanetLoad(5,10); PlanetProc(5,10);
                       End;
                   11: Begin {Mimas}
                         Planeta:=81;
                         PlanetLoad(5,11); PlanetProc(5,11);
                       End;
                   12: Begin {Methone}
                         Planeta:=82;
                         PlanetLoad(5,12); PlanetProc(5,12);
                       End;
                   13: Begin {Pallene}
                         Planeta:=83;
                         PlanetLoad(5,13); PlanetProc(5,13);
                       End;
                   14: Begin {Enceladus}
                         Planeta:=84;
                         PlanetLoad(5,14); PlanetProc(5,14);
                       End;
                   15: Begin {Tethys}
                         Planeta:=85;
                         PlanetLoad(5,15); PlanetProc(5,15);
                       End;
                   16: Begin {Telesto}
                         Planeta:=86;
                         PlanetLoad(5,16); PlanetProc(5,16);
                       End;
                   17: Begin {Calypso}
                         Planeta:=87;
                         PlanetLoad(5,17); PlanetProc(5,17);
                       End;
                   18: Begin {Polydeuces}
                         Planeta:=88;
                         PlanetLoad(5,18); PlanetProc(5,18);
                       End;
                   19: Begin {Dione}
                         Planeta:=89;
                         PlanetLoad(5,19); PlanetProc(5,19);
                       End;
                   20: Begin {Helene}
                         Planeta:=90;
                         PlanetLoad(5,20); PlanetProc(5,20);
                       End;
                   21: Begin {Rhea}
                         Planeta:=91;
                         PlanetLoad(5,21); PlanetProc(5,21);
                       End;
                   22: Begin {Titan}
                         Planeta:=92;
                         PlanetLoad(5,22); PlanetProc(5,22);
                       End;
                   23: Begin {Hyperion}
                         Planeta:=93;
                         PlanetLoad(5,23); PlanetProc(5,23);
                       End;
                   24: Begin {Lapetus}
                         Planeta:=94;
                         PlanetLoad(5,24); PlanetProc(5,24);
                       End;
                   25: Begin {Kiviuq}
                         Planeta:=95;
                         PlanetLoad(5,25); PlanetProc(5,25);
                       End;
                   26: Begin {Ijiraq}
                         Planeta:=96;
                         PlanetLoad(5,26); PlanetProc(5,26);
                       End;
                   27: Begin {Phoebe}
                         Planeta:=97;
                         PlanetLoad(5,27); PlanetProc(5,27);
                       End;
                   28: Begin {Paaliaq}
                         Planeta:=98;
                         PlanetLoad(5,28); PlanetProc(5,28);
                       End;
                   29: Begin {Skathi}
                         Planeta:=99;
                         PlanetLoad(5,29); PlanetProc(5,29);
                       End;
                   30: Begin {S/2004 S11}
                         Planeta:=100;
                         PlanetLoad(5,30); PlanetProc(5,30);
                       End;
                   31: Begin {Siarnaq}
                         Planeta:=101;
                         PlanetLoad(5,31); PlanetProc(5,31);
                       End;
                   32: Begin {Erriapo}
                         Planeta:=102;
                         PlanetLoad(5,32); PlanetProc(5,32);
                       End;
                   33: Begin {Albiorix}
                         Planeta:=103;
                         PlanetLoad(5,33); PlanetProc(5,33);
                       End;
                   34: Begin {Tarvos}
                         Planeta:=104;
                         PlanetLoad(5,34); PlanetProc(5,34);
                       End;
                   35: Begin {S/2004 S13}
                         Planeta:=105;
                         PlanetLoad(5,35); PlanetProc(5,35);
                       End;
                   36: Begin {Mundilfari}
                         Planeta:=106;
                         PlanetLoad(5,36); PlanetProc(5,36);
                       End;
                   37: Begin {S/2004 S17}
                         Planeta:=107;
                         PlanetLoad(5,37); PlanetProc(5,37);
                       End;
                   38: Begin {S/2004 S15}
                         Planeta:=108;
                         PlanetLoad(5,38); PlanetProc(5,38);
                       End;
                   39: Begin {Narvi}
                         Planeta:=109;
                         PlanetLoad(5,39); PlanetProc(5,39);
                       End;
                   40: Begin {S/2004 S10}
                         Planeta:=110;
                         PlanetLoad(5,40); PlanetProc(5,40);
                       End;
                   41: Begin {S/2004 S12}
                         Planeta:=111;
                         PlanetLoad(5,41); PlanetProc(5,41);
                       End;
                   42: Begin {S/2004 S18}
                         Planeta:=112;
                         PlanetLoad(5,42); PlanetProc(5,42);
                       End;
                   43: Begin {Suttungr}
                         Planeta:=113;
                         PlanetLoad(5,43); PlanetProc(5,43);
                       End;
                   44: Begin {S/2004 S9}
                         Planeta:=114;
                         PlanetLoad(5,44); PlanetProc(5,44);
                       End;
                   45: Begin {S/2004 S7}
                         Planeta:=115;
                         PlanetLoad(5,45); PlanetProc(5,45);
                       End;
                   46: Begin {S/2004 S14}
                         Planeta:=116;
                         PlanetLoad(5,46); PlanetProc(5,46);
                       End;
                   47: Begin {Thrymr}
                         Planeta:=117;
                         PlanetLoad(5,47); PlanetProc(5,47);
                       End;
                   48: Begin {S/2004 S16}
                         Planeta:=118;
                         PlanetLoad(5,48); PlanetProc(5,48);
                       End;
                   49: Begin {S/2004 S8}
                         Planeta:=119;
                         PlanetLoad(5,49); PlanetProc(5,49);
                       End;
                   50: Begin {Ymir}
                         Planeta:=120;
                         PlanetLoad(5,50); PlanetProc(5,50);
                       End;
                  End; {Case End}
                End;
{Uran}       8: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta Uran}
                         Planeta:=121;
                         PlanetLoad(6,0); PlanetProc(6,0);
                       End;
                    1: Begin {Cordelia}
                         Planeta:=122;
                         PlanetLoad(6,1); PlanetProc(6,1);
                       End;
                    2: Begin {Ophelia}
                         Planeta:=123;
                         PlanetLoad(6,2); PlanetProc(6,2);
                       End;
                    3: Begin {Bianca}
                         Planeta:=124;
                         PlanetLoad(6,3); PlanetProc(6,3);
                       End;
                    4: Begin {Cressida}
                         Planeta:=125;
                         PlanetLoad(6,4); PlanetProc(6,4);
                       End;
                    5: Begin {Desdemona}
                         Planeta:=126;
                         PlanetLoad(6,5); PlanetProc(6,5);
                       End;
                    6: Begin {Juliet}
                         Planeta:=127;
                         PlanetLoad(6,6); PlanetProc(6,6);
                       End;
                    7: Begin {Portia}
                         Planeta:=128;
                         PlanetLoad(6,7); PlanetProc(6,7);
                       End;
                    8: Begin {Rosalind}
                         Planeta:=129;
                         PlanetLoad(6,8); PlanetProc(6,8);
                       End;
                    9: Begin {S/2003 U 2}
                         Planeta:=130;
                         PlanetLoad(6,9); PlanetProc(6,9);
                       End;
                   10: Begin {Belinda}
                         Planeta:=131;
                         PlanetLoad(6,10); PlanetProc(6,10);
                       End;
                   11: Begin {Puck}
                         Planeta:=132;
                         PlanetLoad(6,11); PlanetProc(6,11);
                       End;
                   12: Begin {S/2003 U 1}
                         Planeta:=133;
                         PlanetLoad(6,12); PlanetProc(6,12);
                       End;
                   13: Begin {Miranda}
                         Planeta:=134;
                         PlanetLoad(6,13); PlanetProc(6,13);
                       End;
                   14: Begin {Ariel}
                         Planeta:=135;
                         PlanetLoad(6,14); PlanetProc(6,14);
                       End;
                   15: Begin {Umbriel}
                         Planeta:=136;
                         PlanetLoad(6,15); PlanetProc(6,15);
                       End;
                   16: Begin {Titania}
                         Planeta:=137;
                         PlanetLoad(6,16); PlanetProc(6,16);
                       End;
                   17: Begin {Oberon}
                         Planeta:=138;
                         PlanetLoad(6,17); PlanetProc(6,17);
                       End;
                   18: Begin {S/2001 U 3}
                         Planeta:=139;
                         PlanetLoad(6,18); PlanetProc(6,18);
                       End;
                   19: Begin {Caliban}
                         Planeta:=140;
                         PlanetLoad(6,19); PlanetProc(6,19);
                       End;
                   20: Begin {Stephano}
                         Planeta:=141;
                         PlanetLoad(6,20); PlanetProc(6,20);
                       End;
                   21: Begin {Trinculo}
                         Planeta:=142;
                         PlanetLoad(6,21); PlanetProc(6,21);
                       End;
                   22: Begin {Sycorax}
                         Planeta:=143;
                         PlanetLoad(6,22); PlanetProc(6,22);
                       End;
                   23: Begin {S/2003 U 3}
                         Planeta:=144;
                         PlanetLoad(6,23); PlanetProc(6,23);
                       End;
                   24: Begin {Prospero}
                         Planeta:=145;
                         PlanetLoad(6,24); PlanetProc(6,24);
                       End;
                   25: Begin {Setebos}
                         Planeta:=146;
                         PlanetLoad(6,25); PlanetProc(6,25);
                       End;
                   26: Begin {S/2001 U 2}
                         Planeta:=147;
                         PlanetLoad(6,26); PlanetProc(6,26);
                       End;
                  End; {Case End}
                End;
{Neptun}     9: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta Neptun}
                         Planeta:=148;
                         PlanetLoad(7,0); PlanetProc(7,0);
                       End;
                    1: Begin {Naiad}
                         Planeta:=149;
                         PlanetLoad(7,1); PlanetProc(7,1);
                       End;
                    2: Begin {Thalassa}
                         Planeta:=150;
                         PlanetLoad(7,2); PlanetProc(7,2);
                       End;
                    3: Begin {Despina}
                         Planeta:=151;
                         PlanetLoad(7,3); PlanetProc(7,3);
                       End;
                    4: Begin {Galatea}
                         Planeta:=152;
                         PlanetLoad(7,4); PlanetProc(7,4);
                       End;
                    5: Begin {Larissa}
                         Planeta:=153;
                         PlanetLoad(7,5); PlanetProc(7,5);
                       End;
                    6: Begin {Proteus}
                         Planeta:=154;
                         PlanetLoad(7,6); PlanetProc(7,6);
                       End;
                    7: Begin {Triton}
                         Planeta:=155;
                         PlanetLoad(7,7); PlanetProc(7,7);
                       End;
                    8: Begin {Nereid}
                         Planeta:=156;
                         PlanetLoad(7,8); PlanetProc(7,8);
                       End;
                    9: Begin {S/2002 N 1}
                         Planeta:=157;
                         PlanetLoad(7,9); PlanetProc(7,9);
                       End;
                   10: Begin {S/2002 N 2}
                         Planeta:=158;
                         PlanetLoad(7,10); PlanetProc(7,10);
                       End;
                   11: Begin {S/2002 N 3}
                         Planeta:=159;
                         PlanetLoad(7,11); PlanetProc(7,11);
                       End;
                   12: Begin {S/2002 N 4}
                         Planeta:=160;
                         PlanetLoad(7,12); PlanetProc(7,12);
                       End;
                   13: Begin {S/2003 N 1}
                         Planeta:=161;
                         PlanetLoad(7,13); PlanetProc(7,13);
                       End;
                  End; {Case End}
                End;
{Pluto}     10: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta Pluto}
                         Planeta:=162;
                         PlanetLoad(8,0); PlanetProc(8,0);
                       End;
                    1: Begin {Charon}
                         Planeta:=163;
                         PlanetLoad(8,1); PlanetProc(8,1);
                       End;
                    2: Begin {Nix}
                         Planeta:=164;
                         PlanetLoad(8,2); PlanetProc(8,2);
                       End;
                    3: Begin {Hydra}
                         Planeta:=165;
                         PlanetLoad(8,3); PlanetProc(8,3);
                       End;
                    4: Begin {Styx}
                         Planeta:=166;
                         PlanetLoad(8,4); PlanetProc(8,4);
                       End;
                    5: Begin {Kerberos}
                         Planeta:=167;
                         PlanetLoad(8,5); PlanetProc(8,5);
                       End;
                  End; {Case End}
                End;
{Haumea}    11: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta 136108 Haumea}
                         Planeta:=168;
                         PlanetLoad(9,0); PlanetProc(9,0);
                       End;
                    1: Begin {Hi'iaka}
                         Planeta:=169;
                         PlanetLoad(9,1); PlanetProc(9,1);
                       End;
                    2: Begin {Namaka}
                         Planeta:=170;
                         PlanetLoad(9,2); PlanetProc(9,2);
                       End;
                  End; {Case End}
                End;
{Eris}      12: Begin
                  Case MainMenuSel of
                    0: Begin {Planeta Eris}
                         Planeta:=171;
                         PlanetLoad(10,0); PlanetProc(10,0);
                       End;
                    1: Begin {Dysnomia}
                         Planeta:=172;
                         PlanetLoad(10,1); PlanetProc(10,1);
                       End;
                  End; {Case End}
                End;
{Generator} 13: Begin
                  Case MainMenuSel of
                    0: Begin ShowGenerBMP(1); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                    1: Begin ShowGenerBMP(2); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                    2: Begin ShowGenerBMP(3); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                    3: Begin ShowGenerBMP(4); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                    4: Begin ShowGenerBMP(5); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                    5: Begin ShowGenerBMP(6); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                    6: Begin ShowGenerBMP(7); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                    7: Begin ShowGenerBMP(8); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                    8: Begin ShowGenerBMP(9); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                    9: Begin
                         SVGA_TogglePaging;
                         pripravpaletu(pal,prvni,sirka);
                         For I:=prvni to prvni+sirka-1 do P16_SetPal(I,pal[I,1],pal[I,2],pal[I,3]);
                         vykresliobrazec(320,240,640,480,60,prvni,sirka);
                         Repeat
                           SVGA_WaitRetrace;
                           If mircosoftSmer=0 then rotujpaletudoprava(pal,prvni,sirka)
                                              else rotujpaletudoleva(pal,prvni,sirka);
                           For I:=prvni to prvni+sirka-1 do P16_SetPal(I,pal[I,1],pal[I,2],pal[I,3]);
                           If Key[28]=1 then
                           Begin
                             Kbd_RPush(28);
                             If mircosoftSmer=0 then mircosoftSmer:=1 else mircosoftSmer:=0;
                           End;
                         Until Key[1]=1;
                         Kbd_RPush(1);
                         SVGA_TogglePaging;
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                   10: Begin ShowGenerBMP(10); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   11: Begin ShowGenerBMP(11); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   12: Begin ShowGenerBMP(12); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   13: Begin ShowGenerBMP(13); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   14: Begin ShowGenerBMP(14); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   15: Begin ShowGenerBMP(15); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   16: Begin ShowGenerBMP(16); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   17: Begin ShowGenerBMP(17); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   18: Begin ShowGenerBMP(18); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   19: Begin ShowGenerBMP(19); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   20: Begin
                         GenerSwitch(0);
                         If GeneratorSwitch[0]=1 then Spkr_StartGenerator(1) else Spkr_StopGenerator;
                       End;
                   21: Begin
                         GenerSwitch(1);
                         If GeneratorSwitch[1]=1 then Spkr_StartGenerator(2) else Spkr_StopGenerator;
                       End;
                   22: Begin
                         GenerSwitch(2);
                         If GeneratorSwitch[2]=1 then Spkr_StartGenerator(4) else Spkr_StopGenerator;
                       End;
                   23: Begin
                         GenerSwitch(3); {blaster1}                 {Blaster}
                         for i:=0 to 8 do StopSound(i);
                         If GeneratorSwitch[3]=1 then StartSound(ZvukRaw[0],0,True);
                       End;
                   24: Begin
                         GenerSwitch(4); {blaster2}                 {Blaster}
                         for i:=0 to 8 do StopSound(i);
                         If GeneratorSwitch[4]=1 then StartSound(ZvukRaw[1],1,True);
                       End;
                   25: Begin
                         GenerSwitch(5); {blaster3}                 {Blaster}
                         for i:=0 to 8 do StopSound(i);
                         If GeneratorSwitch[5]=1 then StartSound(ZvukRaw[2],2,True);
                       End;
                   26: Begin
                         GenerSwitch(6);                            {Blaster}
                         Spkr_StopGenerator; {mantra.wav}
                         for i:=0 to 2 do StopSound(i);
                         for i:=5 to 8 do StopSound(i);
                         If GeneratorSwitch[6]=1 then StartSound(ZvukRaw[3],3,True)
                                                 else StopSound(3);
                       End;
                   27: Begin
                         GenerSwitch(7);                            {Blaster}
                         Spkr_StopGenerator; {asmr.wav}
                         for i:=0 to 2 do StopSound(i);
                         for i:=5 to 8 do StopSound(i);
                         If GeneratorSwitch[7]=1 then StartSound(ZvukRaw[4],4,True)
                                                 else StopSound(4);
                       End;
                   28: Begin
                         GenerSwitch(8);                            {Blaster}
                         Spkr_StopGenerator; {wake-up}
                         for i:=0 to 8 do StopSound(i);
                         If GeneratorSwitch[8]=1 then StartSound(ZvukRaw[5],5,True);
                       End;
                   29: Begin
                         GenerSwitch(9);                            {Blaster}
                         Spkr_StopGenerator; {music432}
                         for i:=0 to 8 do StopSound(i);
                         If GeneratorSwitch[9]=1 then StartSound(ZvukRaw[6],6,True);
                       End;
                   30: Begin TripSeq(1);  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   31: Begin TripSeq(3);  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   32: Begin TripSeq(5);  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   33: Begin TripSeq(8);  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   34: Begin TripSeq(10); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   35: Begin TripSeq(20); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   36: Begin TripSeq(30); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   37: Begin TripSeq(40); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   38: Begin TripSeq(50); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   39: Begin TripSeq(60); LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]); End;
                   40: Begin
                         GenerSwitch(10);                          {Wake-Up 1}
                         Spkr_StopGenerator;
                         for i:=0 to 8 do StopSound(i);
                         If GeneratorSwitch[10]=1 then StartSound(ZvukRaw[7],7,True);
                       End;
                   41: Begin
                         GenerSwitch(11);                          {Wake-Up 2}
                         Spkr_StopGenerator;
                         for i:=0 to 8 do StopSound(i);
                         If GeneratorSwitch[11]=1 then StartSound(ZvukRaw[8],8,True);
                       End;
                  End; {Case End}
                End;
  {Network} 14: Begin
                  Case MainMenuSel of
                    0: Begin NetworkLobby(0); End;
                    1: Begin NetworkLobby(1); End;
                    2: Begin NetworkLobby(2); End;
                  End; {Case End}
                End;
    {Kniha} 15: Begin
                  Case MainMenuSel of
                    0: Begin
                         MainMenu:=16;                             {Sesit 01}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    1: Begin
                         MainMenu:=17;                             {Sesit 02}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    2: Begin
                         MainMenu:=18;                             {Sesit 03}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    3: Begin
                         MainMenu:=19;                             {Sesit 04}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    4: Begin
                         MainMenu:=20;                             {Sesit 05}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    5: Begin
                         MainMenu:=21;                             {Sesit 06}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    6: Begin
                         MainMenu:=22;                             {Sesit 07}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    7: Begin
                         MainMenu:=23;                             {Sesit 08}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    8: Begin
                         MainMenu:=24;                             {Sesit 09}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    9: Begin
                         MainMenu:=25;                             {Sesit 10}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                   10: Begin
                         MainMenu:=26;                              {Blok 1}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   11: Begin
                         MainMenu:=27;                              {Blok 2}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   12: Begin
                         MainMenu:=28;                              {Blok 3}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   13: Begin
                         MainMenu:=29;                              {Blok 4}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   14: Begin
                         MainMenu:=30;                              {Blok 5}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   15: Begin
                         MainMenu:=31;                              {Kniha 1}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   16: Begin
                         MainMenu:=32;                              {Kniha 2}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   17: Begin
                         MainMenu:=33;                              {Kniha 3}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   18: Begin
                         MainMenu:=34;                              {Kniha 4}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   19: Begin
                         MainMenu:=35;                              {Kniha 5}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   20: Begin
                         ZadaniJmena(0,0);
                       End;
                   21: Begin
                         ZadaniJmena(1,0);
                       End;
                   22: Begin
                         ZadaniJmena(2,0);
                       End;
                   23: Begin
                         ZadaniJmena(3,0);
                       End;
                   24: Begin
                         ZadaniJmena(4,0);
                       End;
                   25: Begin
                         ZadaniJmena(5,0);
                       End;
                   26: Begin
                         ZadaniJmena(6,0);
                       End;
                   27: Begin
                         ZadaniJmena(7,0);
                       End;
                   28: Begin
                         ZadaniJmena(8,0);
                       End;
                   29: Begin
                         ZadaniJmena(9,0);
                       End;
                   30: Begin
                         ZadaniJmena(10,20);
                       End;
                   31: Begin
                         ZadaniJmena(11,20);
                       End;
                   32: Begin
                         ZadaniJmena(12,20);
                       End;
                   33: Begin
                         ZadaniJmena(13,20);
                       End;
                   34: Begin
                         ZadaniJmena(14,20);
                       End;
                   35: Begin
                         ZadaniJmena(15,40);
                       End;
                   36: Begin
                         ZadaniJmena(16,40);
                       End;
                   37: Begin
                         ZadaniJmena(17,40);
                       End;
                   38: Begin
                         ZadaniJmena(18,40);
                       End;
                   39: Begin
                         ZadaniJmena(19,40);
                       End;
                   40: Begin
                         PrecistZKnihovny(0);
                       End;
                   41: Begin
                         PrecistZKnihovny(1);
                       End;
                   42: Begin
                         PrecistZKnihovny(2);
                       End;
                   43: Begin
                         PrecistZKnihovny(3);
                       End;
                   44: Begin
                         PrecistZKnihovny(4);
                       End;
                   45: Begin
                         PrecistZKnihovny(5);
                       End;
                   46: Begin
                         PrecistZKnihovny(6);
                       End;
                   47: Begin
                         PrecistZKnihovny(7);
                       End;
                   48: Begin
                         PrecistZKnihovny(8);
                       End;
                   49: Begin
                         PrecistZKnihovny(9);
                       End;
                   50: Begin
                         PrecistZKnihovny(10);
                       End;
                   51: Begin
                         PrecistZKnihovny(11);
                       End;
                   52: Begin
                         PrecistZKnihovny(12);
                       End;
                   53: Begin
                         PrecistZKnihovny(13);
                       End;
                   54: Begin
                         PrecistZKnihovny(14);
                       End;
                   55: Begin
                         PrecistZKnihovny(15);
                       End;
                   56: Begin
                         PrecistZKnihovny(16);
                       End;
                   57: Begin
                         PrecistZKnihovny(17);
                       End;
                   58: Begin
                         PrecistZKnihovny(18);
                       End;
                   59: Begin
                         PrecistZKnihovny(19);
                       End;
                   60: Begin
                         SmazVsechnySoubory('KNIHOVNA\');      {erase all}
                         KnihovnaInfoOperate;
                         strankovaniloadu:=0;
                       End;
                   61: Begin
                         ExportujKnihovnu('KNIHOVNA\','USER'); {save user}
                         SmazVsechnySoubory('KNIHOVNA\');      {erase all}
                         KnihovnaInfoOperate;
                         strankovaniloadu:=0;
                       End;
                   62: Begin
                         strankovaniloadu:=0;
                         ImportujKnihovnu('KNIHOVNA\','USER'); {load user}
                         KnihovnaInfoOperate;
                       End;
                   63: Begin
                         ExportujKnihovnu('KNIHOVNA\','JIVA'); {save jiva}
                         SmazVsechnySoubory('KNIHOVNA\');      {erase all}
                         KnihovnaInfoOperate;
                         strankovaniloadu:=0;
                       End;
                   64: Begin
                         strankovaniloadu:=0;
                         ImportujKnihovnu('KNIHOVNA\','JIVA'); {load jiva}
                         KnihovnaInfoOperate;
                       End;
                  End; {Case End}
                End;
{Listy} 16..35: Begin
                  WriterMemo(MainMenuSel);
                End;
{LEGO}      36: Begin
                    Planeta:=173+MainMenuSel;    {planeta 173..+79}
                    PlanetProc(11,MainMenuSel);  {databaze}
                End;
{Planety}   37: Begin
                  Case MainMenuSel of
                    0: Begin
                         Kbd_Done; {pozastavit lite keyboard}
                         InitKlav; {Mircosoftova klaveska}

                         If KlavesyInstalovany then
                         Begin
                           asm cli end;
                           nastavrozlozeni(2); {czech layout} {xxx ceske je druhe}
                           asm sti end;

                           I:=Length(TextD);

                           Ending:=False;
                           Repeat

                             MainWorldScreen;
                             SVGA_TogglePaging; {kreslit napsany radek}
                             SVGA_BarZ(50,30,130,30+9,ColX[0]);
                             If I>0 then
                             Begin
                               For N:=0 to I-1 do Text_OutText(50+(N)*7,30,TextD[N+1],Buffer[0],SVGA);
                               SVGA_BarZ(50+(N+1)*7,30,50+(N+1)*7+6,30+9,ColX[15]);
                             End else SVGA_BarZ(50,30,50+6,30+9,ColX[15]);
                             SVGA_TogglePaging; {kreslit napsany radek zadavaneho jmena end}

                             Repeat Until Keypressed;
                             if keypressed then znakW:=xReadKey {jestli neco bylo stisknuto, vyhodnotime to}
                                           else znakw:=0; {jinak si sem dame nulu, aby bylo jasne, ze neni co vyhodnocovat}

                             case znakw of 32..255: begin {od mezery do konce ASCII tabulky - napsatelny znak}
                                                      If I<8 then Begin
                                                                     znak:=chr(byte(znakw));
                                                                     TextD:=TextD+znak;
                                                                     Inc(I);
                                                                   End;
                                                    end;

                                           xbksp: begin
                                                    If I>0 then Begin
                                                                  Delete(TextD,I,1);
                                                                  Dec(I);
                                                                End;
                                                  end;

                                           xenter: begin
                                                     Ending:=True;
                                                   end;

                                           xesc: begin
                                                   Ending:=True;
                                                 end;
                             end; {case end}
                             kResetuj;
                           Until Ending=True;
                         End;
                         ZrusKlav;
                         Kbd_Init; {pokracovat lite keyboard}

                         Retez:='';
                         Retez:=TextD[1];
                         Retez:=Retez+TextD[2];
                         Val(Retez,TextDny,TextCode);
                         Retez:='';
                         Retez:=TextD[3];
                         Retez:=Retez+TextD[4];
                         Val(Retez,TextMesice,TextCode);
                         Retez:='';
                         Retez:=TextD[5];
                         Retez:=Retez+TextD[6];
                         Retez:=Retez+TextD[7];
                         Retez:=Retez+TextD[8];
                         Val(Retez,TextRoky,TextCode);

                         Case TextMesice of
                           1: TextDnyVMesici:=31;
                           2: TextDnyVMesici:=28;
                           3: TextDnyVMesici:=30;
                           4: TextDnyVMesici:=31;
                           5: TextDnyVMesici:=30;
                           6: TextDnyVMesici:=31;
                           7: TextDnyVMesici:=30;
                           8: TextDnyVMesici:=31;
                           9: TextDnyVMesici:=30;
                          10: TextDnyVMesici:=31;
                          11: TextDnyVMesici:=30;
                          12: TextDnyVMesici:=31;
                         End; {Case End}

                         datum:=TextRoky+(TextMesice-1)/12+(TextDny-1)/365-(2016+10/12+5/365);
                       End;
                    1: Begin
                         If tocit_planetami=False
                         then Begin
                                tocit_planetami:=True;
                                svga_resetpages;
                              End
                         else Begin
                                tocit_planetami:=False;
                                svga_resetpages;
                              End;
                       End;
                  End; {Case End}
                End;
           End; {Case End}
         End;

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           Case MainMenu of
             0: Begin           {MainMenu}
                  KonecProgramu:=True;
                  If ServerPripojen=True then DoneSend;
                End;
             1: Begin           {Soustava}
                  MainMenu:=0;
                  MainMenuSel:=MainMenuSelSave;
                  MainMenuMax:=6;
                  LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);     {Grafika}
                  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);     {Grafika}
                End;
             2: Begin                       {Merkur}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
             3: Begin                       {Venuse}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
             4: Begin                       {Zeme}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
             5: Begin                       {Mars}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
             6: Begin                       {Jupiter}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
             7: Begin                       {Saturn}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
             8: Begin                       {Uran}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
             9: Begin                       {Neptun}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
            10: Begin                       {Pluto}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
            11: Begin                       {Haumea}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
            12: Begin                       {Eris}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave2;
                  MainMenuMax:=10;
                  LoadBMPFile('BITMAP\alien.bmp',0,0,0,176,Buffer[1]);
                  LoadBMPFile('BITMAP\cosmon.bmp',0,160,0,192,Buffer[1]);
                End;
            13: Begin           {Generator}
                  MainMenu:=0;
                  MainMenuSel:=MainMenuSelSave;
                  MainMenuMax:=6;
                  LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);     {Grafika}
                End;
            14: Begin           {Network}
                  MainMenu:=0;
                  MainMenuSel:=MainMenuSelSave;
                  MainMenuMax:=6;
                  LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);     {Grafika}
                  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);     {Grafika}
                End;
            15: Begin           {Kniha}
                  MainMenu:=0;
                  MainMenuSel:=MainMenuSelSave;
                  MainMenuMax:=6;
                  LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);     {Grafika}
                  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);     {Grafika}
                End;
            16: Begin           {Sesit 1}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            17: Begin           {Sesit 2}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            18: Begin           {Sesit 3}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            19: Begin           {Sesit 4}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            20: Begin           {Sesit 5}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            21: Begin           {Sesit 6}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            22: Begin           {Sesit 7}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            23: Begin           {Sesit 8}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            24: Begin           {Sesit 9}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            25: Begin           {Sesit 10}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            26: Begin           {Blok 1}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            27: Begin           {Blok 2}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            28: Begin           {Blok 3}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            29: Begin           {Blok 4}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            30: Begin           {Blok 5}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            31: Begin           {Kniha 1}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            32: Begin           {Kniha 2}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            33: Begin           {Kniha 3}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            34: Begin           {Kniha 4}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            35: Begin           {Kniha 5}
                  MainMenu:=15;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=64;
                End;
            36: Begin           {LEGO}
                  MainMenu:=0;
                  MainMenuSel:=MainMenuSelSave;
                  MainMenuMax:=6;
                  LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);     {Grafika}
                  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);     {Grafika}
                End;
            37: Begin           {Planety}
                  MainMenu:=0;
                  MainMenuSel:=MainMenuSelSave;
                  MainMenuMax:=6;
                  LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);     {Grafika}
                  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);     {Grafika}
                End;
           End; {Case End}
         End;

  Until KonecProgramu=True;
  _ZrusFont(FFont);
  If ZvukKarta=True then
  Begin
    for i:=0 to 6 do FreeSound(ZvukRaw[i]);
    CloseSoundResourceFile;
  End;
  Spkr_Silence;

  If ServerPripojen=True then
  Begin
    If ClientProcess(2)=True {logout}
    then Begin
           {server decrement slot}
           ServerPripojen:=False;
         End
    else Begin
           ServerPripojen:=False;
         End;
  End;
End;