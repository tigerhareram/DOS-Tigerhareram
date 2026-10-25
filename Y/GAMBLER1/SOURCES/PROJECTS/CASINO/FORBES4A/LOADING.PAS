Procedure SavePal1(Color:Byte);
Begin
  GetPal(Color,Colorbackup[Color].R,
               Colorbackup[Color].G,
               Colorbackup[Color].B);
End;


Procedure Loading;
Var I,Obrazek,Color,StartColor: Byte;
Begin

 {XX ZVUKY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

  LoadSndFile('SND\daytona.snd',0);
  LoadRawFile('RAWS\yeah1.raw',0,0);
  LoadRawFile('RAWS\horse.raw',0,1);
  LoadRawFile('RAWS\blip1.raw',0,2);
  LoadRawFile('RAWS\police.raw',0,3);
  LoadRawFile('RAWS\yeeha.raw',0,4);
  LoadRawFile('RAWS\fanfare1.raw',0,5);
  LoadRawFile('RAWS\fanfare2.raw',0,6);
  LoadRawFile('RAWS\bullet.raw',0,7);
  LoadRawFile('RAWS\blip2.raw',0,8);
  LoadRawFile('RAWS\blip3.raw',0,9);
  LoadRawFile('RAWS\bonus.raw',0,35);
  LoadRawFile('RAWS\laughter.raw',0,36);
  LoadRawFile('RAWS\bell0.raw',0,37);
  LoadRawFile('RAWS\bell1.raw',0,38);
  LoadRawFile('RAWS\bell2.raw',0,39);
  LoadRawFile('RAWS\coin.raw',0,40);
  LoadRawFile('RAWS\yeah2.raw',0,41);
  LoadRawFile('RAWS\bonus2.raw',0,42);
  LoadRawFile('RAWS\bonus3.raw',0,43);
  LoadRawFile('RAWS\bonus4.raw',0,44);
  LoadRawFile('RAWS\plum.raw',0,45);
  LoadRawFile('RAWS\click.raw',0,46);
  LoadRawFile('RAWS\pull.raw',0,47);
  LoadRawFile('RAWS\bell3.raw',0,48);

  LoadRawFile('RAWS\00.raw',0,10);
  LoadRawFile('RAWS\01.raw',0,11);
  LoadRawFile('RAWS\02.raw',0,12);
  LoadRawFile('RAWS\03.raw',0,13);
  LoadRawFile('RAWS\04.raw',0,14);
  LoadRawFile('RAWS\05.raw',0,15);
  LoadRawFile('RAWS\06.raw',0,16);
  LoadRawFile('RAWS\07.raw',0,17);
  LoadRawFile('RAWS\08.raw',0,18);
  LoadRawFile('RAWS\09.raw',0,19);
  LoadRawFile('RAWS\10.raw',0,20);
  LoadRawFile('RAWS\11.raw',0,21);
  LoadRawFile('RAWS\12.raw',0,22);
  LoadRawFile('RAWS\13.raw',0,23);
  LoadRawFile('RAWS\14.raw',0,24);
  LoadRawFile('RAWS\15.raw',0,25);
  LoadRawFile('RAWS\16.raw',0,26);
  LoadRawFile('RAWS\17.raw',0,27);
  LoadRawFile('RAWS\18.raw',0,28);
  LoadRawFile('RAWS\19.raw',0,29);
  LoadRawFile('RAWS\20.raw',0,30);
  LoadRawFile('RAWS\21.raw',0,31);
  LoadRawFile('RAWS\22.raw',0,32);
  LoadRawFile('RAWS\23.raw',0,33);
  LoadRawFile('RAWS\24.raw',0,34);

 {XX BUFFER 1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

  LoadDefaultFont(160,0,ColorBlue,Buffer[1]);
  LoadDefaultFont(160,20,ColorGreen,Buffer[1]);
  LoadDefaultFont(160,40,ColorRed,Buffer[1]);
  LoadDefaultFont(160,60,ColorRedDark,Buffer[1]);

  WriteText(Buffer[1],160,20,5,5,1,10,10,'loading',Buffer[4]);
  Start_LoadSymbol(54,10,ColorBlack,ColorGreen);

  LoadGrPage('GRA\numbers.gra',0);
  LoadBlok(160,80,0,0,79,15,Buffer[1]);    {BET , BONUS}
  LoadBlok(160,96,0,16,49,22,Buffer[1]);   {CREDIT , VYHRA}
  LoadBlok(160,103,0,24,159,55,Buffer[1]); {MULTIWIN}
  LoadBlok(160,140,0,56,49,83,Buffer[1]);  {WIN + CREDIT text}

  LoadGrPage('GRA\daytona.gra',0);
  LoadBlok(0,64,0,0,159,23,Buffer[1]);    {PRESS ENTER}
  LoadBlok(0,195,0,195,12,199,Buffer[1]); {MINI SIPKY}
  LoadBlok(20,192,0,24,7,31,Buffer[1]);   {BET + SYMBOL}
  LoadBlok(0,100,0,32,95,71,Buffer[1]);   {HLAVA OREL TMAVA}
  LoadBlok(0,140,0,72,95,111,Buffer[1]);  {HLAVA OREL SVETLA}
  LoadBlok(100,100,96,32,127,47,Buffer[1]); {RISK TMAVY}
  LoadBlok(100,116,96,48,127,63,Buffer[1]); {RISK SVETLY}
  LoadBlok(100,150,96,64,144,79,Buffer[1]); {WIN - TMAVY}
  LoadBlok(100,166,96,80,144,95,Buffer[1]); {WIN - SVETLY}
  LoadBlok(250,0,40,112,72,129,Buffer[1]);  {WIN GAMBLE GREEN SVETLA}
  LoadBlok(210,0,0,112,32,129,Buffer[1]);   {WIN GAMBLE RED SVETLA}
  LoadBlok(250,20,40,136,72,153,Buffer[1]);  {WIN GAMBLE GREEN TMAVA}
  LoadBlok(210,20,0,136,32,153,Buffer[1]);   {WIN GAMBLE RED TMAVA}
  LoadBlok(210,40,72,112,79,143,Buffer[1]);    {MINCOVNIK}
  LoadBlok(284,40,144,112,159,143,Buffer[1]);  {MINCE 50}
  LoadBlok(268,40,128,112,143,143,Buffer[1]);  {MINCE 20}
  LoadBlok(252,42,112,112,127,143,Buffer[1]);  {MINCE 10}
  LoadBlok(236,42,96,112,111,143,Buffer[1]);   {MINCE 5}
  LoadBlok(218,40,80,112,95,143,Buffer[1]);    {MINCE 2}
  LoadBlok(302,40,128,32,144,63,Buffer[1]);    {MINCE 1}
  LoadBlok(160,168,0,160,39,191,Buffer[1]);    {BANKOVKA 1000}
  LoadBlok(200,168,40,160,79,191,Buffer[1]);   {BANKOVKA 500}
  LoadBlok(240,168,80,160,119,191,Buffer[1]);  {BANKOVKA 100}
  LoadBlok(280,168,120,160,159,191,Buffer[1]); {BANKOVKA 200}

  SetPal(ColorRed,63,0,0);
  SetPal(ColorBlue,30,30,63);
  SetPal(ColorGreen,0,40,0);
  SetPal(ColorRedDark,20,0,0);
  SetPal(ColorBlack,0,0,0);
  SetPal(ColorBlink1,16,16,16);
  SetPal(ColorBlink2,32,32,32);
  SetPal(ColorBlink3,48,48,48);
  SetPal(ColorWhite,63,63,63);
  SetPal(ColorBlue1,0,0,24);
  SetPal(ColorBlue2,0,0,37);
  SetPal(ColorBlue3,0,0,50);
  SetPal(ColorBlue4,0,0,63);
  SetPal(ColorTexter,19,22,63);
  SetPal(ColorCtecka,30,17,9);
  SetPal(ColorButtonA1,11,0,0);
  SetPal(ColorButtonA2,24,0,0);
  SetPal(ColorButtonA3,37,0,0);
  SetPal(ColorButtonA4,50,0,0);
  SetPal(ColorButtonA5,63,0,0);
  SetPal(ColorButtonB1,0,23,0);
  SetPal(ColorButtonB2,0,33,0);
  SetPal(ColorButtonB3,0,43,0);
  SetPal(ColorButtonB4,0,53,0);
  SetPal(ColorButtonB5,0,63,0);
  SetPal(ColorButtonC1,22,22,0);
  SetPal(ColorButtonC2,35,35,0);
  SetPal(ColorButtonC3,47,47,0);
  SetPal(ColorButtonC4,63,63,0);
  SetPal(ColorUnknown,5,5,5);

 {XX BUFFER 2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

  For I:=0 to 4 do
  Begin
    Case I of
     0: Color:=ColorBlack;
     1: Color:=ColorBlink1;
     2: Color:=ColorBlink2;
     3: Color:=ColorBlink3;
     4: Color:=ColorWhite;
    End; {Case End}
    Blok(I*32,0,I*32+31,23,Color,Buffer[2]);
  End;

  LoadBmpFile('BMP\plice.bmp',0,208);
  LoadBitMap(0,24,Buffer[2]);
  LoadBmpFile('BMP\skull.bmp',0,192);
  LoadBitMap(64,24,Buffer[2]);
  LoadBmpFile('BMP\brain.bmp',0,176);
  LoadBitMap(128,24,Buffer[2]);
  LoadBmpFile('BMP\gun.bmp',0,160);
  LoadBitMap(192,24,Buffer[2]);
  LoadBmpFile('BMP\tiger.bmp',0,144);
  LoadBitMap(256,24,Buffer[2]);

  LoadGrPage('GRA\gambler1.gra',0);
  LoadBlok(0,88,0,24,79,39,Buffer[2]);
  LoadGrPage('GRA\gambler2.gra',0);
  LoadBlok(80,88,0,24,79,39,Buffer[2]);
  LoadGrPage('GRA\gambler3.gra',0);
  LoadBlok(160,88,0,24,79,39,Buffer[2]);
  LoadGrPage('GRA\gambler4.gra',0);
  LoadBlok(240,88,0,24,79,39,Buffer[2]);

  LoadGrPage('GRA\gambler1.gra',0);
  LoadBlok(0,104,0,0,159,23,Buffer[2]);
  LoadGrPage('GRA\gambler2.gra',0);
  LoadBlok(160,104,0,0,159,23,Buffer[2]);
  LoadGrPage('GRA\gambler3.gra',0);
  LoadBlok(0,128,0,0,159,23,Buffer[2]);
  LoadGrPage('GRA\gambler4.gra',0);
  LoadBlok(160,128,0,0,159,23,Buffer[2]);
  LoadGrPage('GRA\gambler5.gra',0);
  LoadBlok(0,152,0,0,159,23,Buffer[2]);
  LoadGrPage('GRA\gambler6.gra',0);
  LoadBlok(160,152,0,0,159,23,Buffer[2]);
  LoadGrPage('GRA\gambler7.gra',0);
  LoadBlok(0,176,0,0,159,23,Buffer[2]);
  LoadGrPage('GRA\gambler8.gra',0);
  LoadBlok(160,176,0,0,159,23,Buffer[2]);

  For I:=144 to 234 do SavePal1(I);

  Stop_LoadSymbol;
End;