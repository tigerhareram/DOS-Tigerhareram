Procedure PingTransfers;
Begin
  If MainMenu<>14 then {Network}
  Begin
    If ServerPripojen=True then Text_OutNumber(600,455,PingBajt,False,Buffer[0],SVGA)
                           else Text_OutText(575,455,'Nespojeno',Buffer[0],SVGA);
  End else
  Begin
    If ServerPripojen=True then Begin
                                  Text_OutNumber(600,30,PingBajt,False,Buffer[0],SVGA);
                                  Text_OutNumber(600,60,CisloKlienta+1,False,Buffer[0],SVGA);
                                End
                           else Text_OutText(575,30,'Nespojeno',Buffer[0],SVGA);
  End;
End;


Procedure MainWorldScreen;
Var I,Kn,N: Word;
    X,Y: Word;
Begin
  SVGA_ClearPage(ColX[0]);
  SVGA_WaitRetrace;
  SVGA_Rectangle(0,0,639,479,ColX[15]);
  SVGA_Rectangle(0,0,639,15,ColX[15]);
  Text_OutText(5,3,'Ovladani: Sipky,Enter,Backspace,Delete,Esc, IJKL+ASQW',Buffer[0],SVGA);
  Text_OutText(420,3,'* W.O.R.L.D. *',Buffer[0],SVGA);
  Text_OutText(590,3,'Esc=Exit',Buffer[0],SVGA);

  If MainMenu=0 then
  Begin
    I:=0;  Text_OutText(20,30+15*I,'Soustava',Buffer[0],SVGA);
    I:=1;  Text_OutText(20,30+15*I,'Generator',Buffer[0],SVGA);
    I:=2;  Text_OutText(20,30+15*I,'Network',Buffer[0],SVGA);
    I:=3;  Text_OutText(20,30+15*I,'Kniha',Buffer[0],SVGA);
    I:=4;  Text_OutText(20,30+15*I,'Lego',Buffer[0],SVGA);
    I:=5;  Text_OutText(20,30+15*I,'Planety',Buffer[0],SVGA);
    I:=6;  Text_OutText(20,30+15*I,'Exit',Buffer[0],SVGA);
    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// MENU //',Buffer[0],SVGA);
    {Pingy} PingTransfers;

    SVGA_Rectangle(285,30,624,349,ColX[15]);
    For Y:=0 to 99 do
    For X:=0 to 159 do SVGA_BarZ(295+X*2,40+Y*3,295+1+X*2,40+2+Y*3,mem[Buffer[1]:Y*320+X]);
  End;

  If MainMenu=1 then
  Begin
    I:=0;  Text_OutText(20,30+15*I,'Merkur',Buffer[0],SVGA);
    I:=1;  Text_OutText(20,30+15*I,'Venuse',Buffer[0],SVGA);
    I:=2;  Text_OutText(20,30+15*I,'Zeme',Buffer[0],SVGA);
    I:=3;  Text_OutText(20,30+15*I,'Mars',Buffer[0],SVGA);
    I:=4;  Text_OutText(20,30+15*I,'Jupiter',Buffer[0],SVGA);
    I:=5;  Text_OutText(20,30+15*I,'Saturn',Buffer[0],SVGA);
    I:=6;  Text_OutText(20,30+15*I,'Uran',Buffer[0],SVGA);
    I:=7;  Text_OutText(20,30+15*I,'Neptun',Buffer[0],SVGA);
    I:=8;  Text_OutText(20,30+15*I,'Pluto',Buffer[0],SVGA);
    I:=9;  Text_OutText(20,30+15*I,'Haumea',Buffer[0],SVGA);
    I:=10; Text_OutText(20,30+15*I,'Eris',Buffer[0],SVGA);
    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// SOLARNI SYSTEM //',Buffer[0],SVGA);
    {Pingy} PingTransfers;

    SVGA_Rectangle(285,30,624,449,ColX[15]);
    SVGA_SprZ(295,40,0,0,159,199,1,Buffer[1]);
    SVGA_SprZ(455,40,160,0,319,199,1,Buffer[1]);
    SVGA_SprZ(295,240,0,0,159,199,1,Buffer[1]);
    SVGA_SprZ(455,240,160,0,319,199,1,Buffer[1]);
  End;

  If MainMenu=2 then {Merkur}
  Begin
    I:=0;  Text_OutText(20,30+15*I,'Planeta Merkur',Buffer[0],SVGA);
    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// MEKRUR - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=3 then {Venuse}
  Begin
    I:=0;  Text_OutText(20,30+15*I,'Planeta Venuse',Buffer[0],SVGA);
    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// VENUSE - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=4 then {Zeme}
  Begin
    I:=0;  Text_OutText(20,30+15*I,'Planeta Zeme',Buffer[0],SVGA);
    I:=1;  Text_OutText(20,30+15*I,'Mesic',Buffer[0],SVGA);
    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// ZEME - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=5 then {Mars}
  Begin
    I:=0;  Text_OutText(20,30+15*I,'Planeta Mars',Buffer[0],SVGA);
    I:=1;  Text_OutText(20,30+15*I,'Phobos',Buffer[0],SVGA);
    I:=2;  Text_OutText(20,30+15*I,'Deimos',Buffer[0],SVGA);
    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// MARS - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=6 then {Jupiter}
  Begin
    I:=0;  Text_OutText(20+120*0,30+15*(I-0),'Planeta Jupiter',Buffer[0],SVGA);
    I:=1;  Text_OutText(20+120*0,30+15*(I-0),'Adrastea',Buffer[0],SVGA);
    I:=2;  Text_OutText(20+120*0,30+15*(I-0),'Amalthea',Buffer[0],SVGA);
    I:=3;  Text_OutText(20+120*0,30+15*(I-0),'Thebe',Buffer[0],SVGA);
    I:=4;  Text_OutText(20+120*0,30+15*(I-0),'Io',Buffer[0],SVGA);
    I:=5;  Text_OutText(20+120*0,30+15*(I-0),'Europa',Buffer[0],SVGA);
    I:=6;  Text_OutText(20+120*0,30+15*(I-0),'Ganymed',Buffer[0],SVGA);
    I:=7;  Text_OutText(20+120*0,30+15*(I-0),'Callisto',Buffer[0],SVGA);
    I:=8;  Text_OutText(20+120*0,30+15*(I-0),'Themisto',Buffer[0],SVGA);
    I:=9;  Text_OutText(20+120*0,30+15*(I-0),'Leda',Buffer[0],SVGA);

    I:=10; Text_OutText(20+120*0,30+15*(I-0),'Himalia',Buffer[0],SVGA);
    I:=11; Text_OutText(20+120*0,30+15*(I-0),'Lysithea',Buffer[0],SVGA);
    I:=12; Text_OutText(20+120*0,30+15*(I-0),'Elara',Buffer[0],SVGA);
    I:=13; Text_OutText(20+120*0,30+15*(I-0),'S/2000 J11',Buffer[0],SVGA);
    I:=14; Text_OutText(20+120*0,30+15*(I-0),'Carpo',Buffer[0],SVGA);
    I:=15; Text_OutText(20+120*0,30+15*(I-0),'S/2003 J3',Buffer[0],SVGA);
    I:=16; Text_OutText(20+120*0,30+15*(I-0),'S/2003 J12',Buffer[0],SVGA);
    I:=17; Text_OutText(20+120*0,30+15*(I-0),'Euporie',Buffer[0],SVGA);
    I:=18; Text_OutText(20+120*0,30+15*(I-0),'Mneme',Buffer[0],SVGA);
    I:=19; Text_OutText(20+120*0,30+15*(I-0),'S/2003 J18',Buffer[0],SVGA);

    I:=20; Text_OutText(20+120*1,30+15*(I-20),'Helike',Buffer[0],SVGA);
    I:=21; Text_OutText(20+120*1,30+15*(I-20),'S/2003 J16',Buffer[0],SVGA);
    I:=22; Text_OutText(20+120*1,30+15*(I-20),'Euanthe',Buffer[0],SVGA);
    I:=23; Text_OutText(20+120*1,30+15*(I-20),'Harpalyke',Buffer[0],SVGA);
    I:=24; Text_OutText(20+120*1,30+15*(I-20),'Praxidike',Buffer[0],SVGA);
    I:=25; Text_OutText(20+120*1,30+15*(I-20),'Thelxinoe',Buffer[0],SVGA);
    I:=26; Text_OutText(20+120*1,30+15*(I-20),'Orthosie',Buffer[0],SVGA);
    I:=27; Text_OutText(20+120*1,30+15*(I-20),'Hermippe',Buffer[0],SVGA);
    I:=28; Text_OutText(20+120*1,30+15*(I-20),'Locaste',Buffer[0],SVGA);
    I:=29; Text_OutText(20+120*1,30+15*(I-20),'Ananke',Buffer[0],SVGA);

    I:=30; Text_OutText(20+120*1,30+15*(I-20),'Thyone',Buffer[0],SVGA);
    I:=31; Text_OutText(20+120*1,30+15*(I-20),'S/2003 J15',Buffer[0],SVGA);
    I:=32; Text_OutText(20+120*1,30+15*(I-20),'S/2003 J17',Buffer[0],SVGA);
    I:=33; Text_OutText(20+120*1,30+15*(I-20),'Kallichore',Buffer[0],SVGA);
    I:=34; Text_OutText(20+120*1,30+15*(I-20),'S/2003 J9',Buffer[0],SVGA);
    I:=35; Text_OutText(20+120*1,30+15*(I-20),'S/2003 J19',Buffer[0],SVGA);
    I:=36; Text_OutText(20+120*1,30+15*(I-20),'Pasithee',Buffer[0],SVGA);
    I:=37; Text_OutText(20+120*1,30+15*(I-20),'Arche',Buffer[0],SVGA);
    I:=38; Text_OutText(20+120*1,30+15*(I-20),'Kale',Buffer[0],SVGA);
    I:=39; Text_OutText(20+120*1,30+15*(I-20),'Chaldene',Buffer[0],SVGA);

    I:=40; Text_OutText(20+120*2,30+15*(I-40),'Isonoe',Buffer[0],SVGA);
    I:=41; Text_OutText(20+120*2,30+15*(I-40),'Eurydome',Buffer[0],SVGA);
    I:=42; Text_OutText(20+120*2,30+15*(I-40),'S/2003 J4',Buffer[0],SVGA);
    I:=43; Text_OutText(20+120*2,30+15*(I-40),'Erinome',Buffer[0],SVGA);
    I:=44; Text_OutText(20+120*2,30+15*(I-40),'Taygete',Buffer[0],SVGA);
    I:=45; Text_OutText(20+120*2,30+15*(I-40),'Carme',Buffer[0],SVGA);
    I:=46; Text_OutText(20+120*2,30+15*(I-40),'Aitne',Buffer[0],SVGA);
    I:=47; Text_OutText(20+120*2,30+15*(I-40),'S/2003 J23',Buffer[0],SVGA);
    I:=48; Text_OutText(20+120*2,30+15*(I-40),'Kalyke',Buffer[0],SVGA);
    I:=49; Text_OutText(20+120*2,30+15*(I-40),'Pasiphae',Buffer[0],SVGA);

    I:=50; Text_OutText(20+120*2,30+15*(I-40),'Megaclite',Buffer[0],SVGA);
    I:=51; Text_OutText(20+120*2,30+15*(I-40),'Aoede',Buffer[0],SVGA);
    I:=52; Text_OutText(20+120*2,30+15*(I-40),'Sponde',Buffer[0],SVGA);
    I:=53; Text_OutText(20+120*2,30+15*(I-40),'Sinope',Buffer[0],SVGA);
    I:=54; Text_OutText(20+120*2,30+15*(I-40),'Cyllene',Buffer[0],SVGA);
    I:=55; Text_OutText(20+120*2,30+15*(I-40),'S/2003 J5',Buffer[0],SVGA);
    I:=56; Text_OutText(20+120*2,30+15*(I-40),'Callirrhoe',Buffer[0],SVGA);
    I:=57; Text_OutText(20+120*2,30+15*(I-40),'Autonoe',Buffer[0],SVGA);
    I:=58; Text_OutText(20+120*2,30+15*(I-40),'S/2003 J10',Buffer[0],SVGA);
    I:=59; Text_OutText(20+120*2,30+15*(I-40),'Hegemone',Buffer[0],SVGA);

    I:=60; Text_OutText(20+120*3,30+15*(I-60),'Eukelade',Buffer[0],SVGA);
    I:=61; Text_OutText(20+120*3,30+15*(I-60),'S/2003 J14',Buffer[0],SVGA);
    I:=62; Text_OutText(20+120*3,30+15*(I-60),'S/2003 J2',Buffer[0],SVGA);

    {Kur}
    If  (MainMenuSel<20)                        then Text_OutText(20-15+120*0,30+15*MainmenuSel,   '>>',Buffer[0],SVGA);
    If ((MainMenuSel>=20) and (MainMenuSel<40)) then Text_OutText(20-15+120*1,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=40) and (MainMenuSel<60)) then Text_OutText(20-15+120*2,30+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);
    If  (MainMenuSel>=60)                       then Text_OutText(20-15+120*3,30+15*(MainmenuSel-60),'>>',Buffer[0],SVGA);

    {Stitek} Text_OutText(20,455,'// JUPITER - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=7 then {Saturn}
  Begin
    I:=0; Text_OutText(20+120*0,30+15*(I-0),'Planeta Saturn',Buffer[0],SVGA);
    I:=1; Text_OutText(20+120*0,30+15*(I-0),'Pan',Buffer[0],SVGA);
    I:=2; Text_OutText(20+120*0,30+15*(I-0),'S/2005 S1',Buffer[0],SVGA);
    I:=3; Text_OutText(20+120*0,30+15*(I-0),'Atlas',Buffer[0],SVGA);
    I:=4; Text_OutText(20+120*0,30+15*(I-0),'Prometheus',Buffer[0],SVGA);
    I:=5; Text_OutText(20+120*0,30+15*(I-0),'S/2004 S4',Buffer[0],SVGA);
    I:=6; Text_OutText(20+120*0,30+15*(I-0),'S/2004 S6',Buffer[0],SVGA);
    I:=7; Text_OutText(20+120*0,30+15*(I-0),'S/2004 S3',Buffer[0],SVGA);
    I:=8; Text_OutText(20+120*0,30+15*(I-0),'Pandora',Buffer[0],SVGA);
    I:=9; Text_OutText(20+120*0,30+15*(I-0),'Epimatheus',Buffer[0],SVGA);

    I:=10; Text_OutText(20+120*0,30+15*(I-0),'Janus',Buffer[0],SVGA);
    I:=11; Text_OutText(20+120*0,30+15*(I-0),'Mimas',Buffer[0],SVGA);
    I:=12; Text_OutText(20+120*0,30+15*(I-0),'Methone',Buffer[0],SVGA);
    I:=13; Text_OutText(20+120*0,30+15*(I-0),'Pallene',Buffer[0],SVGA);
    I:=14; Text_OutText(20+120*0,30+15*(I-0),'Enceladus',Buffer[0],SVGA);
    I:=15; Text_OutText(20+120*0,30+15*(I-0),'Tethys',Buffer[0],SVGA);
    I:=16; Text_OutText(20+120*0,30+15*(I-0),'Telesto',Buffer[0],SVGA);
    I:=17; Text_OutText(20+120*0,30+15*(I-0),'Calypso',Buffer[0],SVGA);
    I:=18; Text_OutText(20+120*0,30+15*(I-0),'Polydeuces',Buffer[0],SVGA);
    I:=19; Text_OutText(20+120*0,30+15*(I-0),'Dione',Buffer[0],SVGA);

    I:=20; Text_OutText(20+120*1,30+15*(I-20),'Helene',Buffer[0],SVGA);
    I:=21; Text_OutText(20+120*1,30+15*(I-20),'Rhea',Buffer[0],SVGA);
    I:=22; Text_OutText(20+120*1,30+15*(I-20),'Titan',Buffer[0],SVGA);
    I:=23; Text_OutText(20+120*1,30+15*(I-20),'Hyperion',Buffer[0],SVGA);
    I:=24; Text_OutText(20+120*1,30+15*(I-20),'Lapetus',Buffer[0],SVGA);
    I:=25; Text_OutText(20+120*1,30+15*(I-20),'Kiviuq',Buffer[0],SVGA);
    I:=26; Text_OutText(20+120*1,30+15*(I-20),'Ijiraq',Buffer[0],SVGA);
    I:=27; Text_OutText(20+120*1,30+15*(I-20),'Phoebe',Buffer[0],SVGA);
    I:=28; Text_OutText(20+120*1,30+15*(I-20),'Paaliaq',Buffer[0],SVGA);
    I:=29; Text_OutText(20+120*1,30+15*(I-20),'Skathi',Buffer[0],SVGA);

    I:=30; Text_OutText(20+120*1,30+15*(I-20),'S/2004 S11',Buffer[0],SVGA);
    I:=31; Text_OutText(20+120*1,30+15*(I-20),'Siarnaq',Buffer[0],SVGA);
    I:=32; Text_OutText(20+120*1,30+15*(I-20),'Erriapo',Buffer[0],SVGA);
    I:=33; Text_OutText(20+120*1,30+15*(I-20),'Albiorix',Buffer[0],SVGA);
    I:=34; Text_OutText(20+120*1,30+15*(I-20),'Tarvos',Buffer[0],SVGA);
    I:=35; Text_OutText(20+120*1,30+15*(I-20),'S/2004 S13',Buffer[0],SVGA);
    I:=36; Text_OutText(20+120*1,30+15*(I-20),'Mundilfari',Buffer[0],SVGA);
    I:=37; Text_OutText(20+120*1,30+15*(I-20),'S/2004 S17',Buffer[0],SVGA);
    I:=38; Text_OutText(20+120*1,30+15*(I-20),'S/2004 S15',Buffer[0],SVGA);
    I:=39; Text_OutText(20+120*1,30+15*(I-20),'Narvi',Buffer[0],SVGA);

    I:=40; Text_OutText(20+120*2,30+15*(I-40),'S/2004 S10',Buffer[0],SVGA);
    I:=41; Text_OutText(20+120*2,30+15*(I-40),'S/2004 S12',Buffer[0],SVGA);
    I:=42; Text_OutText(20+120*2,30+15*(I-40),'S/2004 S18',Buffer[0],SVGA);
    I:=43; Text_OutText(20+120*2,30+15*(I-40),'Suttungr',Buffer[0],SVGA);
    I:=44; Text_OutText(20+120*2,30+15*(I-40),'S/2004 S9',Buffer[0],SVGA);
    I:=45; Text_OutText(20+120*2,30+15*(I-40),'S/2004 S7',Buffer[0],SVGA);
    I:=46; Text_OutText(20+120*2,30+15*(I-40),'S/2004 S14',Buffer[0],SVGA);
    I:=47; Text_OutText(20+120*2,30+15*(I-40),'Thrymr',Buffer[0],SVGA);
    I:=48; Text_OutText(20+120*2,30+15*(I-40),'S/2004 S16',Buffer[0],SVGA);
    I:=49; Text_OutText(20+120*2,30+15*(I-40),'S/2004 S8',Buffer[0],SVGA);

    I:=50; Text_OutText(20+120*2,30+15*(I-40),'Ymir',Buffer[0],SVGA);

    {Kur}
    If  (MainMenuSel<20)                        then Text_OutText(20-15+120*0,30+15*MainmenuSel,   '>>',Buffer[0],SVGA);
    If ((MainMenuSel>=20) and (MainMenuSel<40)) then Text_OutText(20-15+120*1,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If  (MainMenuSel>=40)                       then Text_OutText(20-15+120*2,30+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);

    {Stitek} Text_OutText(20,455,'// SATURN - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=8 then {Uran}
  Begin
    I:=0; Text_OutText(20+120*0,30+15*(I-0),'Planeta Uran',Buffer[0],SVGA);
    I:=1; Text_OutText(20+120*0,30+15*(I-0),'Cordelia',Buffer[0],SVGA);
    I:=2; Text_OutText(20+120*0,30+15*(I-0),'Ophelia',Buffer[0],SVGA);
    I:=3; Text_OutText(20+120*0,30+15*(I-0),'Bianca',Buffer[0],SVGA);
    I:=4; Text_OutText(20+120*0,30+15*(I-0),'Cressida',Buffer[0],SVGA);
    I:=5; Text_OutText(20+120*0,30+15*(I-0),'Desdemona',Buffer[0],SVGA);
    I:=6; Text_OutText(20+120*0,30+15*(I-0),'Juliet',Buffer[0],SVGA);
    I:=7; Text_OutText(20+120*0,30+15*(I-0),'Portia',Buffer[0],SVGA);
    I:=8; Text_OutText(20+120*0,30+15*(I-0),'Rosalind',Buffer[0],SVGA);
    I:=9; Text_OutText(20+120*0,30+15*(I-0),'S/2003 U 2',Buffer[0],SVGA);

    I:=10; Text_OutText(20+120*0,30+15*(I-0),'Belinda',Buffer[0],SVGA);
    I:=11; Text_OutText(20+120*0,30+15*(I-0),'Puck',Buffer[0],SVGA);
    I:=12; Text_OutText(20+120*0,30+15*(I-0),'S/2003 U 1',Buffer[0],SVGA);
    I:=13; Text_OutText(20+120*0,30+15*(I-0),'Miranda',Buffer[0],SVGA);
    I:=14; Text_OutText(20+120*0,30+15*(I-0),'Ariel',Buffer[0],SVGA);
    I:=15; Text_OutText(20+120*0,30+15*(I-0),'Umbriel',Buffer[0],SVGA);
    I:=16; Text_OutText(20+120*0,30+15*(I-0),'Titania',Buffer[0],SVGA);
    I:=17; Text_OutText(20+120*0,30+15*(I-0),'Oberon',Buffer[0],SVGA);
    I:=18; Text_OutText(20+120*0,30+15*(I-0),'S/2001 U 3',Buffer[0],SVGA);
    I:=19; Text_OutText(20+120*0,30+15*(I-0),'Caliban',Buffer[0],SVGA);

    I:=20; Text_OutText(20+120*1,30+15*(I-20),'Stephano',Buffer[0],SVGA);
    I:=21; Text_OutText(20+120*1,30+15*(I-20),'Trinculo',Buffer[0],SVGA);
    I:=22; Text_OutText(20+120*1,30+15*(I-20),'Sycorax',Buffer[0],SVGA);
    I:=23; Text_OutText(20+120*1,30+15*(I-20),'S/2003 U 3',Buffer[0],SVGA);
    I:=24; Text_OutText(20+120*1,30+15*(I-20),'Prospero',Buffer[0],SVGA);
    I:=25; Text_OutText(20+120*1,30+15*(I-20),'Setebos',Buffer[0],SVGA);
    I:=26; Text_OutText(20+120*1,30+15*(I-20),'S/2001 U 2',Buffer[0],SVGA);

    {Kur}
    If (MainMenuSel<20) then Text_OutText(20-15+120*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If (MainMenuSel>=20) then Text_OutText(20-15+120*1,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);

    {Stitek} Text_OutText(20,455,'// URAN - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=9 then {Neptune}
  Begin
    I:=0; Text_OutText(20+120*0,30+15*(I-0),'Planeta Neptun',Buffer[0],SVGA);
    I:=1; Text_OutText(20+120*0,30+15*(I-0),'Naiad',Buffer[0],SVGA);
    I:=2; Text_OutText(20+120*0,30+15*(I-0),'Thalassa',Buffer[0],SVGA);
    I:=3; Text_OutText(20+120*0,30+15*(I-0),'Despina',Buffer[0],SVGA);
    I:=4; Text_OutText(20+120*0,30+15*(I-0),'Galatea',Buffer[0],SVGA);
    I:=5; Text_OutText(20+120*0,30+15*(I-0),'Larissa',Buffer[0],SVGA);
    I:=6; Text_OutText(20+120*0,30+15*(I-0),'Proteus',Buffer[0],SVGA);
    I:=7; Text_OutText(20+120*0,30+15*(I-0),'Triton',Buffer[0],SVGA);
    I:=8; Text_OutText(20+120*0,30+15*(I-0),'Nereid',Buffer[0],SVGA);
    I:=9; Text_OutText(20+120*0,30+15*(I-0),'S/2002 N 1',Buffer[0],SVGA);

    I:=10; Text_OutText(20+120*0,30+15*(I-0),'S/2002 N 2',Buffer[0],SVGA);
    I:=11; Text_OutText(20+120*0,30+15*(I-0),'S/2002 N 3',Buffer[0],SVGA);
    I:=12; Text_OutText(20+120*0,30+15*(I-0),'S/2002 N 4',Buffer[0],SVGA);
    I:=13; Text_OutText(20+120*0,30+15*(I-0),'S/2003 N 1',Buffer[0],SVGA);

    {Kur} Text_OutText(20-15+120*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// NEPTUN - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=10 then {Pluto}
  Begin
    I:=0; Text_OutText(20+120*0,30+15*(I-0),'Planeta Pluto',Buffer[0],SVGA);
    I:=1; Text_OutText(20+120*0,30+15*(I-0),'Charon',Buffer[0],SVGA);
    I:=2; Text_OutText(20+120*0,30+15*(I-0),'Nix',Buffer[0],SVGA);
    I:=3; Text_OutText(20+120*0,30+15*(I-0),'Hydra',Buffer[0],SVGA);
    I:=4; Text_OutText(20+120*0,30+15*(I-0),'Styx',Buffer[0],SVGA);
    I:=5; Text_OutText(20+120*0,30+15*(I-0),'Kerberos',Buffer[0],SVGA);

    {Kur} Text_OutText(20-15+120*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// PLUTO - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=11 then {Haumea}
  Begin
    I:=0; Text_OutText(20+120*0,30+15*(I-0),'Planeta 136108 Haumea',Buffer[0],SVGA);
    I:=1; Text_OutText(20+120*0,30+15*(I-0),'Hi''iaka',Buffer[0],SVGA);
    I:=2; Text_OutText(20+120*0,30+15*(I-0),'Namaka',Buffer[0],SVGA);

    {Kur} Text_OutText(20-15+120*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// HAUMEA - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=12 then {Eris}
  Begin
    I:=0; Text_OutText(20+120*0,30+15*(I-0),'Planeta Eris',Buffer[0],SVGA);
    I:=1; Text_OutText(20+120*0,30+15*(I-0),'Dysnomia',Buffer[0],SVGA);

    {Kur} Text_OutText(20-15+120*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// ERIS - ORBIT //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=13 then {Generator}
  Begin
    I:=0; Text_OutText(20+120*0,30+15*(I-0),'LSD Simulator 1',Buffer[0],SVGA);
    I:=1; Text_OutText(20+120*0,30+15*(I-0),'LSD Simulator 2',Buffer[0],SVGA);
    I:=2; Text_OutText(20+120*0,30+15*(I-0),'LSD Simulator 3',Buffer[0],SVGA);
    I:=3; Text_OutText(20+120*0,30+15*(I-0),'LSD Simulator 4',Buffer[0],SVGA);
    I:=4; Text_OutText(20+120*0,30+15*(I-0),'LSD Simulator 5',Buffer[0],SVGA);
    I:=5; Text_OutText(20+120*0,30+15*(I-0),'LSD Simulator 6',Buffer[0],SVGA);
    I:=6; Text_OutText(20+120*0,30+15*(I-0),'LSD Simulator 7',Buffer[0],SVGA);
    I:=7; Text_OutText(20+120*0,30+15*(I-0),'LSD Simulator 8',Buffer[0],SVGA);
    I:=8; Text_OutText(20+120*0,30+15*(I-0),'LSD Simulator 9',Buffer[0],SVGA);
    I:=9; Text_OutText(20+120*0,30+15*(I-0),'LSD Mircosofta',Buffer[0],SVGA);

    I:=10; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 1',Buffer[0],SVGA);
    I:=11; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 2',Buffer[0],SVGA);
    I:=12; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 3',Buffer[0],SVGA);
    I:=13; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 4',Buffer[0],SVGA);
    I:=14; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 5',Buffer[0],SVGA);
    I:=15; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 6',Buffer[0],SVGA);
    I:=16; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 7',Buffer[0],SVGA);
    I:=17; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 8',Buffer[0],SVGA);
    I:=18; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 9',Buffer[0],SVGA);
    I:=19; Text_OutText(20+120*1,30+15*(I-10),'LSD Artwork 10',Buffer[0],SVGA);

    I:=20; Text_OutText(20+120*2+20,30+15*(I-20),'PC-Speaker 1',Buffer[0],SVGA);
    I:=21; Text_OutText(20+120*2+20,30+15*(I-20),'PC-Speaker 2',Buffer[0],SVGA);
    I:=22; Text_OutText(20+120*2+20,30+15*(I-20),'PC-Speaker 3',Buffer[0],SVGA);
    I:=23; Text_OutText(20+120*2+20,30+15*(I-20),'Sound Blaster 1',Buffer[0],SVGA);
    I:=24; Text_OutText(20+120*2+20,30+15*(I-20),'Sound Blaster 2',Buffer[0],SVGA);
    I:=25; Text_OutText(20+120*2+20,30+15*(I-20),'Sound Blaster 3',Buffer[0],SVGA);
    I:=26; Text_OutText(20+120*2+20,30+15*(I-20),'Hare Krishna',Buffer[0],SVGA);
    I:=27; Text_OutText(20+120*2+20,30+15*(I-20),'A.S.M.R.',Buffer[0],SVGA);
    I:=28; Text_OutText(20+120*2+20,30+15*(I-20),'Probuzeni',Buffer[0],SVGA);
    I:=29; Text_OutText(20+120*2+20,30+15*(I-20),'Hudba 432Hz',Buffer[0],SVGA);

    I:=30; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence  1 minut ... *',Buffer[0],SVGA);
    I:=31; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence  3 minut ... **',Buffer[0],SVGA);
    I:=32; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence  5 minut ... ***',Buffer[0],SVGA);
    I:=33; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence  8 minut ... ****',Buffer[0],SVGA);
    I:=34; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence 10 minut ... *****',Buffer[0],SVGA);
    I:=35; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence 20 minut ... ******',Buffer[0],SVGA);
    I:=36; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence 30 minut ... *******',Buffer[0],SVGA);
    I:=37; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence 40 minut ... ********',Buffer[0],SVGA);
    I:=38; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence 50 minut ... *********',Buffer[0],SVGA);
    I:=39; Text_OutText(20+120*3+30,30+15*(I-30),'Start Sekvence 1 hodinu ... **********',Buffer[0],SVGA);

    SVGA_HLine(20,619,187,ColX[15]);
    I:=40; Text_OutText(20+120*0+20,200+15*(I-40),'Wake-Up 1',Buffer[0],SVGA);
    I:=41; Text_OutText(20+120*0+20,200+15*(I-40),'Wake-Up 2',Buffer[0],SVGA);

    {Rambo}
    SVGA_Rectangle(524,349,624,419,ColX[15]);
    SVGA_SprZ(534,359,0,100,79,149,1,Buffer[1]);

    {On/Off}
    For I:=20 to 29 do
    If GeneratorSwitch[(I-20)]=1 then Text_OutText(20+120*2,30+15*(I-20),'On',Buffer[0],SVGA)
                                 else Text_OutText(20+120*2,30+15*(I-20),'Off',Buffer[0],SVGA);
    For I:=40 to 41 do
    If GeneratorSwitch[(I-30)]=1 then Text_OutText(20+120*0,200+15*(I-40),'On',Buffer[0],SVGA)
                                 else Text_OutText(20+120*0,200+15*(I-40),'Off',Buffer[0],SVGA);
    {Kur}
    If  (MainMenuSel<10)                        then Text_OutText(20-15+120*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=10) and (MainMenuSel<20)) then Text_OutText(20-15+120*1,30+15*(MainmenuSel-10),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=20) and (MainMenuSel<30)) then Text_OutText(20-15+120*2,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=30) and (MainMenuSel<40)) then Text_OutText(20-15+120*3+30,30+15*(MainmenuSel-30),'>>',Buffer[0],SVGA);
    If   MainMenuSel>=40                        then Text_OutText(20-15+120*0,200+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);

    {Stitek} Text_OutText(20,455,'// GENERATOR //    .. backspace odstranuje hodiny',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=14 then {Network}
  Begin
    I:=0;  If AdresaZadana=False
           then Begin
                  Text_OutText(20,30+15*(I-0),'Spojit Computer .....',Buffer[0],SVGA);
                End
           else Begin {adresa zadana}
                  If ServerPripojen
                  then Begin
                         Text_OutText(20,30+15*(I-0),'Propojeno ...........',Buffer[0],SVGA);
                       End
                  else Begin
                         Text_OutText(20,30+15*(I-0),'Spojit Computer .....',Buffer[0],SVGA);
                       End;
                  For N:=0 to Length(AdresaServeru)-1 do Text_OutText(145+N*7,30,AdresaServeru[N],Buffer[0],SVGA);
                End;

    I:=1;  Text_OutText(20,30+15*(I-0),'IPX adresa serveru >',Buffer[0],SVGA);
    I:=2;  Text_OutText(20,30+15*(I-0),'Command prompt',Buffer[0],SVGA);

    SVGA_Rectangle(0,85,639,85+79,ColX[15]);           {green}

    {Kur} Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// NETWORK INTERFACE //      F5 = odeslat prikaz',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=15 then {Kniha}
  Begin
    I:=0; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 01   6 stran',Buffer[0],SVGA);
    I:=1; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 02   6 stran',Buffer[0],SVGA);
    I:=2; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 03   6 stran',Buffer[0],SVGA);
    I:=3; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 04   6 stran',Buffer[0],SVGA);
    I:=4; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 05   6 stran',Buffer[0],SVGA);
    I:=5; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 06   6 stran',Buffer[0],SVGA);
    I:=6; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 07   6 stran',Buffer[0],SVGA);
    I:=7; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 08   6 stran',Buffer[0],SVGA);
    I:=8; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 09   6 stran',Buffer[0],SVGA);
    I:=9; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 10   6 stran',Buffer[0],SVGA);

    I:=10; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  01  60 stran',Buffer[0],SVGA);
    I:=11; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  02  60 stran',Buffer[0],SVGA);
    I:=12; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  03  60 stran',Buffer[0],SVGA);
    I:=13; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  04  60 stran',Buffer[0],SVGA);
    I:=14; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  05  60 stran',Buffer[0],SVGA);

    I:=15; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 01 300 stran',Buffer[0],SVGA);
    I:=16; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 02 300 stran',Buffer[0],SVGA);
    I:=17; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 03 300 stran',Buffer[0],SVGA);
    I:=18; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 04 300 stran',Buffer[0],SVGA);
    I:=19; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 05 300 stran',Buffer[0],SVGA);

    Text_OutText(20+175*1,30+15*0,KnihovnaInfo.JmenaSesitu[0],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*1,KnihovnaInfo.JmenaSesitu[1],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*2,KnihovnaInfo.JmenaSesitu[2],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*3,KnihovnaInfo.JmenaSesitu[3],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*4,KnihovnaInfo.JmenaSesitu[4],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*5,KnihovnaInfo.JmenaSesitu[5],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*6,KnihovnaInfo.JmenaSesitu[6],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*7,KnihovnaInfo.JmenaSesitu[7],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*8,KnihovnaInfo.JmenaSesitu[8],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*9,KnihovnaInfo.JmenaSesitu[9],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*10,KnihovnaInfo.JmenaBloku[0],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*11,KnihovnaInfo.JmenaBloku[1],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*12,KnihovnaInfo.JmenaBloku[2],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*13,KnihovnaInfo.JmenaBloku[3],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*14,KnihovnaInfo.JmenaBloku[4],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*15,KnihovnaInfo.JmenaKnih[0],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*16,KnihovnaInfo.JmenaKnih[1],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*17,KnihovnaInfo.JmenaKnih[2],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*18,KnihovnaInfo.JmenaKnih[3],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*19,KnihovnaInfo.JmenaKnih[4],Buffer[0],SVGA);

    I:=40; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=41; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=42; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=43; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=44; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=45; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=46; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=47; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=48; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=49; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);

    I:=50; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=51; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=52; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=53; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=54; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);

    I:=55; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=56; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=57; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=58; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=59; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);

    I:=60; Text_OutText(80,30+40+15*(I-40)+35,'ERASE ALL',Buffer[0],SVGA);
    I:=60; Text_OutText(180,30+40+15*(I-40)+35,'SAVE USER',Buffer[0],SVGA);
    I:=60; Text_OutText(280,30+40+15*(I-40)+35,'LOAD USER',Buffer[0],SVGA);
    I:=60; Text_OutText(380,30+40+15*(I-40)+35,'SAVE JIVA',Buffer[0],SVGA);
    I:=60; Text_OutText(480,30+40+15*(I-40)+35,'LOAD JIVA',Buffer[0],SVGA);

    {Kur}
    If  (MainMenuSel<10)                         then Text_OutText(20-15+120*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=10) and (MainMenuSel<15))  then Text_OutText(20-15+120*0,30+20+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=15) and (MainMenuSel<20))  then Text_OutText(20-15+120*0,30+40+15*MainmenuSel,'>>',Buffer[0],SVGA);

    If ((MainMenuSel>=20) and (MainMenuSel<30)) then Text_OutText(20-15+175*1,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=30) and (MainMenuSel<35)) then Text_OutText(20-15+175*1,30+20+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=35) and (MainMenuSel<40)) then Text_OutText(20-15+175*1,30+40+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);

    If   ((MainMenuSel>=40) and (MainMenuSel<50)) then Text_OutText(570-15,30+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);
    If   ((MainMenuSel>=50) and (MainMenuSel<55)) then Text_OutText(570-15,30+20+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);
    If   ((MainMenuSel>=55) and (MainMenuSel<60)) then Text_OutText(570-15,30+40+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);

    If   MainMenuSel>=60 then
    Case MainMenuSel of
      60: Text_OutText(80-15,30+40+15*(MainmenuSel-40)+35,'>>',Buffer[0],SVGA);
      61: Text_OutText(180-15,30+40+15*(MainmenuSel-41)+35,'>>',Buffer[0],SVGA);
      62: Text_OutText(280-15,30+40+15*(MainmenuSel-42)+35,'>>',Buffer[0],SVGA);
      63: Text_OutText(380-15,30+40+15*(MainmenuSel-43)+35,'>>',Buffer[0],SVGA);
      64: Text_OutText(480-15,30+40+15*(MainmenuSel-44)+35,'>>',Buffer[0],SVGA);
    End; {Case End}

    {Stitek} Text_OutText(20,455,'// LITERARNI DILO //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
    {Strankovani} Text_OutText(290,455,'HTML : ',Buffer[0],SVGA);
                  Text_OutNumber(332,456,strankovaniloadu,False,Buffer[0],SVGA);
  End;

  {Kniha - Sesity}
  If ((MainMenu>=16) and (MainMenu<=25)) then
  Begin
    For I:=0 to 5 do Text_OutNumber(20,30+15*I+1,I+1,False,Buffer[0],SVGA);

    {Kur} Text_OutText(20-13,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// LITERARNI DILO //',Buffer[0],SVGA);
             Case MainMenu of
               16: Text_OutText(180,455,'Sesit 01',Buffer[0],SVGA);
               17: Text_OutText(180,455,'Sesit 02',Buffer[0],SVGA);
               18: Text_OutText(180,455,'Sesit 03',Buffer[0],SVGA);
               19: Text_OutText(180,455,'Sesit 04',Buffer[0],SVGA);
               20: Text_OutText(180,455,'Sesit 05',Buffer[0],SVGA);
               21: Text_OutText(180,455,'Sesit 06',Buffer[0],SVGA);
               22: Text_OutText(180,455,'Sesit 07',Buffer[0],SVGA);
               23: Text_OutText(180,455,'Sesit 08',Buffer[0],SVGA);
               24: Text_OutText(180,455,'Sesit 09',Buffer[0],SVGA);
               25: Text_OutText(180,455,'Sesit 10',Buffer[0],SVGA);
             End; {Case End}
    {Pingy} PingTransfers;
  End;

  {Kniha - Bloky}
  If ((MainMenu>=26) and (MainMenu<=30)) then
  Begin
    For N:=0 to 2 do
    Begin
      For I:=0 to 19 do Text_OutNumber(20+40*N,30+15*I+1,I+1+N*20,False,Buffer[0],SVGA);
    End;

    {Kur}
    If  (MainMenuSel<20)                        then Text_OutText(20-13+40*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=20) and (MainMenuSel<40)) then Text_OutText(20-13+40*1,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If   MainMenuSel>=40                        then Text_OutText(20-13+40*2,30+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);

    {Stitek} Text_OutText(20,455,'// LITERARNI DILO //',Buffer[0],SVGA);
             Case MainMenu of
               26: Text_OutText(180,455,'Blok 1',Buffer[0],SVGA);
               27: Text_OutText(180,455,'Blok 2',Buffer[0],SVGA);
               28: Text_OutText(180,455,'Blok 3',Buffer[0],SVGA);
               29: Text_OutText(180,455,'Blok 4',Buffer[0],SVGA);
               30: Text_OutText(180,455,'Blok 5',Buffer[0],SVGA);
             End; {Case End}
    {Pingy} PingTransfers;
  End;

  {Kniha - Knihy}
  If ((MainMenu>=31) and (MainMenu<=35)) then
  Begin
     For N:=0 to 14 do
     Begin
       For I:=0 to 19 do Text_OutNumber(20+40*N,30+15*I+1,I+1+N*20,False,Buffer[0],SVGA);
     End;

    {Kur}
    If  (MainMenuSel<20)
    then Text_OutText(20-13+40*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=20) and (MainMenuSel<40))
    then Text_OutText(20-13+40*1,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=40) and (MainMenuSel<60))
    then Text_OutText(20-13+40*2,30+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=60) and (MainMenuSel<80))
    then Text_OutText(20-13+40*3,30+15*(MainmenuSel-60),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=80) and (MainMenuSel<100))
    then Text_OutText(20-13+40*4,30+15*(MainmenuSel-80),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=100) and (MainMenuSel<120))
    then Text_OutText(20-13+40*5,30+15*(MainmenuSel-100),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=120) and (MainMenuSel<140))
    then Text_OutText(20-13+40*6,30+15*(MainmenuSel-120),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=140) and (MainMenuSel<160))
    then Text_OutText(20-13+40*7,30+15*(MainmenuSel-140),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=160) and (MainMenuSel<180))
    then Text_OutText(20-13+40*8,30+15*(MainmenuSel-160),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=180) and (MainMenuSel<200))
    then Text_OutText(20-13+40*9,30+15*(MainmenuSel-180),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=200) and (MainMenuSel<220))
    then Text_OutText(20-13+40*10,30+15*(MainmenuSel-200),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=220) and (MainMenuSel<240))
    then Text_OutText(20-13+40*11,30+15*(MainmenuSel-220),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=240) and (MainMenuSel<260))
    then Text_OutText(20-13+40*12,30+15*(MainmenuSel-240),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=260) and (MainMenuSel<280))
    then Text_OutText(20-13+40*13,30+15*(MainmenuSel-260),'>>',Buffer[0],SVGA);
    If   MainMenuSel>=280
    then Text_OutText(20-13+40*14,30+15*(MainmenuSel-280),'>>',Buffer[0],SVGA);

    {Stitek} Text_OutText(20,455,'// LITERARNI DILO //',Buffer[0],SVGA);
             Case MainMenu of
               31: Text_OutText(180,455,'Kniha 1',Buffer[0],SVGA);
               32: Text_OutText(180,455,'Kniha 2',Buffer[0],SVGA);
               33: Text_OutText(180,455,'Kniha 3',Buffer[0],SVGA);
               34: Text_OutText(180,455,'Kniha 4',Buffer[0],SVGA);
               35: Text_OutText(180,455,'Kniha 5',Buffer[0],SVGA);
             End; {Case End}
    {Pingy} PingTransfers;
  End;

  If MainMenu=36 then {Lego}
  Begin
    I:=0; Text_OutText(45+70*0,50+30*(I-0),'LEGO-01',Buffer[0],SVGA);
    I:=1; Text_OutText(45+70*0,50+30*(I-0),'LEGO-02',Buffer[0],SVGA);
    I:=2; Text_OutText(45+70*0,50+30*(I-0),'LEGO-03',Buffer[0],SVGA);
    I:=3; Text_OutText(45+70*0,50+30*(I-0),'LEGO-04',Buffer[0],SVGA);
    I:=4; Text_OutText(45+70*0,50+30*(I-0),'LEGO-05',Buffer[0],SVGA);
    I:=5; Text_OutText(45+70*0,50+30*(I-0),'LEGO-06',Buffer[0],SVGA);
    I:=6; Text_OutText(45+70*0,50+30*(I-0),'LEGO-07',Buffer[0],SVGA);
    I:=7; Text_OutText(45+70*0,50+30*(I-0),'LEGO-08',Buffer[0],SVGA);
    I:=8; Text_OutText(45+70*0,50+30*(I-0),'LEGO-09',Buffer[0],SVGA);
    I:=9; Text_OutText(45+70*0,50+30*(I-0),'LEGO-10',Buffer[0],SVGA);

    I:=10; Text_OutText(45+70*1,50+30*(I-10),'LEGO-11',Buffer[0],SVGA);
    I:=11; Text_OutText(45+70*1,50+30*(I-10),'LEGO-12',Buffer[0],SVGA);
    I:=12; Text_OutText(45+70*1,50+30*(I-10),'LEGO-13',Buffer[0],SVGA);
    I:=13; Text_OutText(45+70*1,50+30*(I-10),'LEGO-14',Buffer[0],SVGA);
    I:=14; Text_OutText(45+70*1,50+30*(I-10),'LEGO-15',Buffer[0],SVGA);
    I:=15; Text_OutText(45+70*1,50+30*(I-10),'LEGO-16',Buffer[0],SVGA);
    I:=16; Text_OutText(45+70*1,50+30*(I-10),'LEGO-17',Buffer[0],SVGA);
    I:=17; Text_OutText(45+70*1,50+30*(I-10),'LEGO-18',Buffer[0],SVGA);
    I:=18; Text_OutText(45+70*1,50+30*(I-10),'LEGO-19',Buffer[0],SVGA);
    I:=19; Text_OutText(45+70*1,50+30*(I-10),'LEGO-20',Buffer[0],SVGA);

    I:=20; Text_OutText(45+70*2,50+30*(I-20),'LEGO-21',Buffer[0],SVGA);
    I:=21; Text_OutText(45+70*2,50+30*(I-20),'LEGO-22',Buffer[0],SVGA);
    I:=22; Text_OutText(45+70*2,50+30*(I-20),'LEGO-23',Buffer[0],SVGA);
    I:=23; Text_OutText(45+70*2,50+30*(I-20),'LEGO-24',Buffer[0],SVGA);
    I:=24; Text_OutText(45+70*2,50+30*(I-20),'LEGO-25',Buffer[0],SVGA);
    I:=25; Text_OutText(45+70*2,50+30*(I-20),'LEGO-26',Buffer[0],SVGA);
    I:=26; Text_OutText(45+70*2,50+30*(I-20),'LEGO-27',Buffer[0],SVGA);
    I:=27; Text_OutText(45+70*2,50+30*(I-20),'LEGO-28',Buffer[0],SVGA);
    I:=28; Text_OutText(45+70*2,50+30*(I-20),'LEGO-29',Buffer[0],SVGA);
    I:=29; Text_OutText(45+70*2,50+30*(I-20),'LEGO-30',Buffer[0],SVGA);

    I:=30; Text_OutText(45+70*3,50+30*(I-30),'LEGO-31',Buffer[0],SVGA);
    I:=31; Text_OutText(45+70*3,50+30*(I-30),'LEGO-32',Buffer[0],SVGA);
    I:=32; Text_OutText(45+70*3,50+30*(I-30),'LEGO-33',Buffer[0],SVGA);
    I:=33; Text_OutText(45+70*3,50+30*(I-30),'LEGO-34',Buffer[0],SVGA);
    I:=34; Text_OutText(45+70*3,50+30*(I-30),'LEGO-35',Buffer[0],SVGA);
    I:=35; Text_OutText(45+70*3,50+30*(I-30),'LEGO-36',Buffer[0],SVGA);
    I:=36; Text_OutText(45+70*3,50+30*(I-30),'LEGO-37',Buffer[0],SVGA);
    I:=37; Text_OutText(45+70*3,50+30*(I-30),'LEGO-38',Buffer[0],SVGA);
    I:=38; Text_OutText(45+70*3,50+30*(I-30),'LEGO-39',Buffer[0],SVGA);
    I:=39; Text_OutText(45+70*3,50+30*(I-30),'LEGO-40',Buffer[0],SVGA);

    I:=40; Text_OutText(45+70*4,50+30*(I-40),'LEGO-41',Buffer[0],SVGA);
    I:=41; Text_OutText(45+70*4,50+30*(I-40),'LEGO-42',Buffer[0],SVGA);
    I:=42; Text_OutText(45+70*4,50+30*(I-40),'LEGO-43',Buffer[0],SVGA);
    I:=43; Text_OutText(45+70*4,50+30*(I-40),'LEGO-44',Buffer[0],SVGA);
    I:=44; Text_OutText(45+70*4,50+30*(I-40),'LEGO-45',Buffer[0],SVGA);
    I:=45; Text_OutText(45+70*4,50+30*(I-40),'LEGO-46',Buffer[0],SVGA);
    I:=46; Text_OutText(45+70*4,50+30*(I-40),'LEGO-47',Buffer[0],SVGA);
    I:=47; Text_OutText(45+70*4,50+30*(I-40),'LEGO-48',Buffer[0],SVGA);
    I:=48; Text_OutText(45+70*4,50+30*(I-40),'LEGO-49',Buffer[0],SVGA);
    I:=49; Text_OutText(45+70*4,50+30*(I-40),'LEGO-50',Buffer[0],SVGA);

    I:=50; Text_OutText(45+70*5,50+30*(I-50),'LEGO-51',Buffer[0],SVGA);
    I:=51; Text_OutText(45+70*5,50+30*(I-50),'LEGO-52',Buffer[0],SVGA);
    I:=52; Text_OutText(45+70*5,50+30*(I-50),'LEGO-53',Buffer[0],SVGA);
    I:=53; Text_OutText(45+70*5,50+30*(I-50),'LEGO-54',Buffer[0],SVGA);
    I:=54; Text_OutText(45+70*5,50+30*(I-50),'LEGO-55',Buffer[0],SVGA);
    I:=55; Text_OutText(45+70*5,50+30*(I-50),'LEGO-56',Buffer[0],SVGA);
    I:=56; Text_OutText(45+70*5,50+30*(I-50),'LEGO-57',Buffer[0],SVGA);
    I:=57; Text_OutText(45+70*5,50+30*(I-50),'LEGO-58',Buffer[0],SVGA);
    I:=58; Text_OutText(45+70*5,50+30*(I-50),'LEGO-59',Buffer[0],SVGA);
    I:=59; Text_OutText(45+70*5,50+30*(I-50),'LEGO-60',Buffer[0],SVGA);

    I:=60; Text_OutText(45+70*6,50+30*(I-60),'LEGO-61',Buffer[0],SVGA);
    I:=61; Text_OutText(45+70*6,50+30*(I-60),'LEGO-62',Buffer[0],SVGA);
    I:=62; Text_OutText(45+70*6,50+30*(I-60),'LEGO-63',Buffer[0],SVGA);
    I:=63; Text_OutText(45+70*6,50+30*(I-60),'LEGO-64',Buffer[0],SVGA);
    I:=64; Text_OutText(45+70*6,50+30*(I-60),'LEGO-65',Buffer[0],SVGA);
    I:=65; Text_OutText(45+70*6,50+30*(I-60),'LEGO-66',Buffer[0],SVGA);
    I:=66; Text_OutText(45+70*6,50+30*(I-60),'LEGO-67',Buffer[0],SVGA);
    I:=67; Text_OutText(45+70*6,50+30*(I-60),'LEGO-68',Buffer[0],SVGA);
    I:=68; Text_OutText(45+70*6,50+30*(I-60),'LEGO-69',Buffer[0],SVGA);
    I:=69; Text_OutText(45+70*6,50+30*(I-60),'LEGO-70',Buffer[0],SVGA);

    I:=70; Text_OutText(45+70*7,50+30*(I-70),'LEGO-71',Buffer[0],SVGA);
    I:=71; Text_OutText(45+70*7,50+30*(I-70),'LEGO-72',Buffer[0],SVGA);
    I:=72; Text_OutText(45+70*7,50+30*(I-70),'LEGO-73',Buffer[0],SVGA);
    I:=73; Text_OutText(45+70*7,50+30*(I-70),'LEGO-74',Buffer[0],SVGA);
    I:=74; Text_OutText(45+70*7,50+30*(I-70),'LEGO-75',Buffer[0],SVGA);
    I:=75; Text_OutText(45+70*7,50+30*(I-70),'LEGO-76',Buffer[0],SVGA);
    I:=76; Text_OutText(45+70*7,50+30*(I-70),'LEGO-77',Buffer[0],SVGA);
    I:=77; Text_OutText(45+70*7,50+30*(I-70),'LEGO-78',Buffer[0],SVGA);
    I:=78; Text_OutText(45+70*7,50+30*(I-70),'LEGO-79',Buffer[0],SVGA);
    I:=79; Text_OutText(45+70*7,50+30*(I-70),'LEGO-80',Buffer[0],SVGA);

    {Kur}
    If  (MainMenuSel<10)                        then Text_OutText(45-14+70*0,50+30*MainmenuSel,     '>>',Buffer[0],SVGA);
    If ((MainMenuSel>=10) and (MainMenuSel<20)) then Text_OutText(45-14+70*1,50+30*(MainmenuSel-10),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=20) and (MainMenuSel<30)) then Text_OutText(45-14+70*2,50+30*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=30) and (MainMenuSel<40)) then Text_OutText(45-14+70*3,50+30*(MainmenuSel-30),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=40) and (MainMenuSel<50)) then Text_OutText(45-14+70*4,50+30*(MainmenuSel-40),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=50) and (MainMenuSel<60)) then Text_OutText(45-14+70*5,50+30*(MainmenuSel-50),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=60) and (MainMenuSel<70)) then Text_OutText(45-14+70*6,50+30*(MainmenuSel-60),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=70) and (MainMenuSel<=80)) then Text_OutText(45-14+70*7,50+30*(MainmenuSel-70),'>>',Buffer[0],SVGA);

    {Stitek} Text_OutText(20,455,'// LEGO //',Buffer[0],SVGA);
    {Pingy} PingTransfers;
  End;

  If MainMenu=37 then {Planetarium}
  Begin
    If tocit_planetami=True
    then ZatocPlanetami {tocive planety}
    else KresliPlanety; {staticke planety}
  End;

  SVGA_WaitRetrace;
  SVGA_FlipPage;
End;
