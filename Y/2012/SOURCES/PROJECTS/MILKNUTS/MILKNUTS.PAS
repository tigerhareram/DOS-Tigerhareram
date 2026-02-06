Program MilkNuts;
Uses Lite;
Type
  TVoda= Record
           Sprite: Byte;  { ktery sprite se vykresluje 1 nebo 2 }
           Pocitadlo: Byte; { zpozdovani stridani spritu }
         End;

  TSplouch= Record
              Sprite: Byte; { ktery sprite se vykresluje }
              Pocitadlo: Byte; { zpozdovani stridani spritu }
              Je: Boolean; { True pokud Splouch do vody nastal }
            End;

  TDlazdice= Record
               X: Word; { souradnice X dlazdice [0..39] }
               Y: Byte; { souradnice Y dlazdice [0..24] }
               Vyska: Byte; { 1=je nepruchozi napr. plosina }
               Sprite: Byte; { cislo spritu ktery se ma vykreslovat }
               Typ: Byte; { 2=lana 4=odperovatko 5=voda }
             End;

  TSkok= Record
           Pocitadlo: Byte; { pocitadlo trvani skoku }
         End;

  TPlayer= Record
             X: Word; { souradnice X [0..303] - panak je velky 16x16 }
             Y: Byte; { souradnice Y [0..183] }
             StartX: Word; { pozice X pri startu levelu [0..303] }
             StartY: Byte; { pozice Y pri startu levelu [0..183] }
             LogY: Byte;   { Y ktere se nemeni pri skoku a padu - pro AI }
             Smer: Byte;   { jakym smerem player hledi }
             Sprite: Byte; { ktery sprite se ma vykreslovat }
             Pocitadlo:Byte; { na zpozdovani vykreslovani sprite }
             Zivoty: Byte; { pocet zbyvajicich zivotu }
             Harakiri: Boolean; { True pokud nastala sebevrazda BACKSPACE }
             DeathPocitadlo: Byte; { zpozdeni pro restart levelu a zivoty-1 }
             Score: Word; { score v jednom levelu }
             ScoreTotal: Longint; { score celkove max cca 120 000 }
             Skok: Boolean; { jestli nastal normalni skok }
             Skok2: Boolean; { jestli nastal veliky skok na odperovatku }
             Pad: Boolean; { True pokud player pada v gravitaci }
             Mrtvy: Boolean; { True pokud je mrtvy }
             Splouch: TSplouch; { viz. TSplouch }
             Vykreslovat: Boolean; { True=vykreslovat playera }
             Nausea: Boolean; { kdyz je hore nohama a oblbly }
             PWRLeft, PWRRight: Byte; { POWER doleva, doprava }
             PWRDown: Byte;           { POWER dolu }
             PWRLPocitadlo: Byte; { POWER doleva - zpozdovac }
             PWRRPocitadlo: Byte; { POWER doprava - zpozdovac }
             UpHelper,DownHelper: Byte; { zpozdeni pri splhani po lanech }
           End;

  TEnemy= Record
            RightPressed: Boolean; { stisk virtualni klavesy doprava }
            LeftPressed: Boolean;  { stisk virtualni klavesy doleva }
            UpPressed: Boolean;    { stisk virtualni klavesy nahoru }
            DownPressed: Boolean;  { stisk virtualni klavesy dolu }
            JumpPressed: Boolean;  { stisk virtualni klavesy skok }
            LeftCounter: Byte;  { zpozdovac doleva }
            RightCounter: Byte; { zpozdovac doprava }
            X: Word; { souradnice X [0..303] - enemy je velky 16x16 }
            Y: Byte; { souradnice Y [0..183] }
            LogY: Byte; { Y ktere se nemeni pri skoku a padu - pro AI }
            StartX: Word;  { pozice X pri startu levelu [0..303] }
            StartY: Byte;  { pozice Y pri startu levelu [0..183] }
            Smer: Byte;    { jakym smerem player hledi }
            Sprite: Byte;  { ktery sprite se ma vykreslovat }
            Pocitadlo:Byte; { na zpozdovani vykreslovani sprite }
            Skok: Boolean;  { jestli nastal normalni skok }
            Skok2: Boolean; { jestli nastal veliky skok na odperovatku }
            EnemySkok: TSkok;  { uz si nepamatuju sorry }
            EnemySkok2: TSkok; { uz si nepamatuju sorry }
            Pad: Boolean; { True pokud player pada v gravitaci }
            Mrtvy: Boolean;  { True pokud je mrtvy }
            Splouch: TSplouch; { viz. TSplouch }
            Vykreslovat: Boolean; { True=vykreslovat playera }
            Nausea: Boolean; { kdyz je hore nohama a oblbly }
            NauseaCounter: Byte; { pro zpozdeni zbrchani se z nausey }
            PWRLeft, PWRRight: Byte; { POWER doleva, doprava }
            PWRDown: Byte;           { POWER dolu }
            PWRLPocitadlo: Byte;     { POWER doleva - zpozdovac }
            PWRRPocitadlo: Byte;     { POWER doprava - zpozdovac }
            UpHelper,DownHelper: Byte; {pro zpozdeni pri splhani po lanech}
            LightLogic: Boolean; { True=chodi doleva doprava, False=Hard AI }
            Going: Boolean; { AI - True=jde doleva, False=jde doprava }
            RopesOnLeftFound: Boolean;  { AI - True kdyz jsou lana nalezena }
            RopesOnRightFound: Boolean; { AI - True kdyz jsou lana nalezena }
            OnRopes: Boolean; { AI - True kdyz je na lanech }
            PathFreeL: Boolean; { AI - True kdyz je cesta volna - Left }
            PathFreeR: Boolean; { AI - True kdyz je cesta volna - Right }
          End;

  TOdperovatko= Record
                  X: Word; { souradnice X [0..303] - odperovatko 16x16}
                  Y: Byte; { souradnice Y [0..183] }
                  Pocitadlo: Byte; { pocitadlo trvani odperovani }
                  Sprite: Byte; { cislo spritu stlaceni odperovatka }
                  Activ: Boolean; { True kdyz je stlacene }
                  Power: Byte; { POWER odperovani viz. skok a skok2 }
                  MEM: Boolean; { pamet odperovatka }
                End;

  TItem= Record
           X: Word; { souradnice X [0..303] - item je velky 16x16 }
           Y: Byte; { souradnice Y [0..183] }
           Sebrany: Boolean; { True pokud je predmet uz sebrany }
           Pocitadlo: Byte; { pocitadlo pro zobrazeni leticiho score+ }
         End;

  TBonusItem= Record
                MinY,MaxY: Byte; {minimalni a maximalni Y}
                Go: Boolean;       {True kdyz jde dolu , False nahoru}
                Pocitadlo: Byte;   {zpozdovac}
              End;

  TVzducholod= Record
                 Leta: Boolean;   {True=v levelu leta vzducholod}
                 X: Word;         {souradnice X [10..287]}
                 Y: Byte;         {souradnice Y [0..183]}
                 Sprite: Byte;    {ktery sprite vykreslovat}
                 Going: Boolean;  {True=jde doprava}
                 Xct1,Xct2: Byte; {zpozdovace vykreslovani}
                 UhelInt: Word;   {uhel pro sinusovku 0..360}
                 UhelRad: Real;   {uhel v radianech pro sin}
                 SinusY: Real;    {sinus Y}
                 K: Byte;         {Y rozsah letu}
                 P: Byte;         {Y osa letu}
               End;

  TDomecek= Record
              X: Word; { souradnice X [0..287] - domecek 32x40 }
              Y: Byte; { souradnice Y [0..159] }
              Otevreno: Boolean; { True pokud jsou otevrene dvere }
            End;

  TCas= Record
          Minuty: Byte;  { minuty }
          Vteriny: Byte; { vteriny }
          CT: Word;      { odpocet }
          Bool: Boolean; { suda/licha vterina }
        End;

  TBonus= Record
            Round: Boolean;      {True = toto kolo je Bonus Round}
            Item: array[0..5] of TBonusItem; {Itemy v Bonus Round}
          End;

Var
  StartGame: Boolean;             {True=zacit novou hru}
  EndingGame: Boolean;            {True=ukoncit hru - navrat do Main Menu}
  MMframe,MMfps,MMprodleva: Word; {fps v Main Menu}
  frame,fps,prodleva: Word;       {fps ve hre}
  trvani: LongInt;                {pocet tiku stopek za jeden frame}
  ShowFPS: Boolean;               {True=zobrazovat FPS ve hre}
  fpsButtonF: Byte;               {zpozdeni pri stisku F pro FPS}
  Vsync: Boolean;                 {True=cekat na vykreslovaci paprsek}
  CisloLevelu: Byte;              {ktery level nasleduje}
  StartovaciLevel: Byte;          {na kterem levelu zacit hru}
  PosledniLevel: Byte;            {na kterem levelu je game over}
  EndingPlay: Boolean;            {True=ukoncit cely program}
  GameCompleted: Boolean;         {True=uspesne dohrana cela hra}
  GratzOver: Boolean;             {True=muzeme pokracovat v gratulations}
  LevelCompleted: Boolean;        {True=tento level je dokonceny}
  StartLevel: Boolean;            {True=zacit hru v tomto levelu}
  VyuctovaniCasu: Boolean;        {True=cas je vyuctovan}
  VyuctovaniScore: Boolean;       {True=score je vyuctovano}
  Skip: Boolean;                  {True=preskoceni vyuctovani score}
  Cas: TCas;                      {viz TCas}

  Voda: TVoda;                    {Voda}
  Player: TPlayer;                {Hrac}
  Skok: TSkok;                    {Maly skok hrace}
  Skok2: TSkok;                   {Veliky skok hrace na odperovatku}
  Enemy: array[0..3] of TEnemy;   {Enemiove}
  A: Byte;                        {Enemy index - Enemy[A]}
  Odperovatko: TOdperovatko;      {Odperovatko}
  Domecek: TDomecek;              {Domecek}
  Bonus: TBonus;                  {Bonus Round}
  Vzducholod: TVzducholod;        {Vzducholod}

  Item: array[0..6] of TItem;     {Predmety}
  Dlazdice: array[0..999] of TDlazdice; {Dlazdice}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXX PROCEDURY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Initialize;
Begin
  LoadGrPage('milknuts.gra',0);
  LoadBlok(0,0,0,0,159,99,Buffer[1]);

  LoadBlokM(0,150,40,16,47,23,Buffer[1]); {voda splouch}

  LoadBlokM(248,32,48,32,55,47,Buffer[1]); {vrtulka 1}
  LoadBlokM(248,48,48,48,55,63,Buffer[1]); {vrtulka 2}
  LoadBlokM(248,64,48,64,55,71,Buffer[1]); {vrtulka 3}
  LoadBlokM(256,32,56,32,79,47,Buffer[1]); {vzducholod}

  LoadBlokM( 0,100, 0,0,15,15,Buffer[1]);
  LoadBlokM(16,100,16,0,31,15,Buffer[1]);
  LoadBlokM(32,100,32,0,47,15,Buffer[1]);
  LoadBlokM(48,100,48,0,63,15,Buffer[1]);
  LoadBlokM(64,100,64,0,79,15,Buffer[1]);

  LoadBlokM( 80,132, 80,32, 95,47,Buffer[1]);
  LoadBlokM( 96,132, 96,32,111,47,Buffer[1]);
  LoadBlokM(112,132,112,32,127,47,Buffer[1]);
  LoadBlokM(128,132,128,32,143,47,Buffer[1]);
  LoadBlokM(144,132,144,32,159,47,Buffer[1]);

  LoadSNDFile('milknuts.snd',0);
  StartGame:=False;
  EndingGame:=False;
  MMprodleva:=10; MMframe:=0; MMfps:=0;                 {Main Menu FPS}
  prodleva:=10; frame:=0; fps:=0; ShowFPS:=False;         {Game FPS}
  Vsync:=False;
  EndingPlay:=False;
  GameCompleted:=False;
  Player.Zivoty:=3;
  Player.Mrtvy:=False;
  Player.ScoreTotal:=0;
  StartovaciLevel:=1;
  PosledniLevel:=10;
End;


Function GetCisloDlazdice(X,Y:Word):Word;
Var Xa,Ya: Byte;
Begin
  Xa:=Trunc(X/8); Ya:=Trunc(Y/8);
  GetCisloDlazdice:=Ya*40+Xa;
End;


Procedure InitLevel(LevelNumber:Byte); {nastaveni levelu pred samotnou hrou}
Var X,Y,I,helper: Word;
Begin
  {Bonus Round}
  Bonus.Round:=False;

  {Vzducholod}
  Vzducholod.Leta:=False;

  {nastaveni dlazdic}
  I:=0;
  For Y:=0 to 24 do
  Begin
    For X:=0 to 39 do
    Begin
      Dlazdice[I].X:=X*8;    Dlazdice[I].Y:=Y*8;
      Dlazdice[I].Typ:=0;    Dlazdice[I].Vyska:=0;
      Inc(I);
    End;
  End;

  {nastaveni vody}
  For I:=0 to 39 do Dlazdice[960+I].Typ:=5; {voda}
  Voda.Sprite:=0; Voda.pocitadlo:=0;

  {smazani pozadi}
  ClearPage(Buffer[2]);

  Case LevelNumber of
    1: Begin
{XXXXXXXXX LEVEL 01 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=881 to 884 do Dlazdice[I].Typ:=1;
         For I:=889 to 918 do Dlazdice[I].Typ:=1;
         For I:=231 to 238 do Dlazdice[I].Typ:=1;
         For I:=0 to 18 do Dlazdice[120+(I*40)+29].Typ:=2;
         For I:=0 to 18 do Dlazdice[120+(I*40)+28].Typ:=2;
         For I:=431 to 438 do Dlazdice[I].Typ:=1;
         For I:=631 to 638 do Dlazdice[I].Typ:=1;
         For I:=401 to 414 do Dlazdice[I].Typ:=1;
         For I:=495 to 498 do Dlazdice[I].Typ:=1;
         For I:=419 to 426 do Dlazdice[I].Typ:=1;
{XXXXXXXXX LEVEL 01 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         {Player XY}
         Player.StartX:=16; Player.StartY:=160;

         {Enemy0}
         Enemy[0].StartX:=196; Enemy[0].StartY:=160;
         Enemy[0].LightLogic:=True;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=284; Enemy[1].StartY:=104;
         Enemy[1].LightLogic:=True;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=284; Enemy[2].StartY:=64;
         Enemy[2].LightLogic:=True;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=128; Odperovatko.Y:=80;

         Item[0].X:=256; Item[0].Y:=64;
         Item[1].X:=256; Item[1].Y:=104;
         Item[2].X:=256; Item[2].Y:=160;
         Item[3].X:=56;  Item[3].Y:=64;
         Item[4].X:=72;  Item[4].Y:=64;
         Item[5].X:=88;  Item[5].Y:=64;
         Item[6].X:=24;  Item[6].Y:=64;

         {domecek}
         Domecek.X:=264; Domecek.Y:=0;
         {cas}
         Cas.CT:=300;
       End; {Level 1 prepare End}

    2: Begin
{XXXXXXXXX LEVEL 02 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=882 to 890 do Dlazdice[I].Typ:=3;
         For I:=895 to 905 do Dlazdice[I].Typ:=3;
         For I:=170 to 188 do Dlazdice[I].Typ:=3;
         For I:=193 to 197 do Dlazdice[I].Typ:=3;
         For I:=570 to 585 do Dlazdice[I].Typ:=3;
         For I:=590 to 591 do Dlazdice[I].Typ:=3;
         For I:=596 to 597 do Dlazdice[I].Typ:=3;
         For I:=671 to 676 do Dlazdice[I].Typ:=3;
         Dlazdice[631].Typ:=1; Dlazdice[636].Typ:=3;
         For I:=0 to 18 do Dlazdice[120+(I*40)+8].Typ:=2;
         For I:=0 to 18 do Dlazdice[120+(I*40)+7].Typ:=2;
         For I:=910 to 913 do Dlazdice[I].Typ:=3;

{XXXXXXXXX LEVEL 02 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         {Player XY}
         Player.StartX:=275; Player.StartY:=16;

         {Enemy0}
         Enemy[0].StartX:=140; Enemy[0].StartY:=96;
         Enemy[0].LightLogic:=True;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=140; Enemy[1].StartY:=160;
         Enemy[1].LightLogic:=True;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=80; Enemy[2].StartY:=16;
         Enemy[2].LightLogic:=True;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=264; Odperovatko.Y:=112;

         Item[0].X:=40;  Item[0].Y:=64;
         Item[1].X:=265; Item[1].Y:=64;
         Item[2].X:=100; Item[2].Y:=96;
         Item[3].X:=40;  Item[3].Y:=80;
         Item[4].X:=248; Item[4].Y:=160;
         Item[5].X:=120; Item[5].Y:=96;
         Item[6].X:=24;  Item[6].Y:=160;

         Domecek.X:=160; Domecek.Y:=136;
         {cas}
         Cas.CT:=300;
       End; {Level 2 prepare End}

    3: Begin
{XXXXXXXXX LEVEL 03 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=0 to 11 do Dlazdice[440+(I*40)+19].Typ:=2;
         For I:=0 to 11 do Dlazdice[440+(I*40)+20].Typ:=2;
         For I:=902 to 906 do Dlazdice[I].Typ:=3;
         For I:=912 to 915 do Dlazdice[I].Typ:=3;
         For I:=244 to 255 do Dlazdice[I].Typ:=3;
         For I:=0 to 7 do Dlazdice[200+(I*40)+1].Typ:=2;
         For I:=0 to 7 do Dlazdice[200+(I*40)+2].Typ:=2;
         For I:=484 to 497 do Dlazdice[I].Typ:=3;
         For I:=380 to 381 do Dlazdice[I].Typ:=3;
         For I:=266 to 277 do Dlazdice[I].Typ:=3;

{XXXXXXXXX LEVEL 03 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         {Player XY}
         Player.StartX:=264; Player.StartY:=160;

         {Enemy0}
         Enemy[0].StartX:=64; Enemy[0].StartY:=32;
         Enemy[0].LightLogic:=True;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=40; Enemy[1].StartY:=80;
         Enemy[1].LightLogic:=True;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=240; Enemy[2].StartY:=32;
         Enemy[2].LightLogic:=True;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=160; Odperovatko.Y:=56;

         Item[0].X:=188; Item[0].Y:=160;
         Item[1].X:=260; Item[1].Y:=32;
         Item[2].X:=60;  Item[2].Y:=80;
         Item[3].X:=40;  Item[3].Y:=32;
         Item[4].X:=280; Item[4].Y:=32;
         Item[5].X:=84;  Item[5].Y:=80;
         Item[6].X:=104; Item[6].Y:=32;

         Domecek.X:=64; Domecek.Y:=8;
         {cas}
         Cas.CT:=300;
       End; {Level 3 prepare End}

    4: Begin
{XXXXXXXXX LEVEL 04 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=686 to 699 do Dlazdice[I].Typ:=13;
         For I:=406 to 419 do Dlazdice[I].Typ:=13;
         For I:=0 to 8 do Dlazdice[360+(I*40)+3].Typ:=2;
         For I:=0 to 8 do Dlazdice[360+(I*40)+4].Typ:=2;
         For I:=882 to 899 do Dlazdice[I].Typ:=13;
         For I:=904 to 907 do Dlazdice[I].Typ:=13;
         For I:=912 to 915 do Dlazdice[I].Typ:=13;
         For I:=0 to 13 do Dlazdice[360+(I*40)+21].Typ:=2;
         For I:=0 to 13 do Dlazdice[360+(I*40)+22].Typ:=2;
         For I:=424 to 427 do Dlazdice[I].Typ:=13;
         For I:=0 to 14 do Dlazdice[160+(I*40)+29].Typ:=2;
         For I:=0 to 14 do Dlazdice[160+(I*40)+30].Typ:=2;
         For I:=432 to 435 do Dlazdice[I].Typ:=13;
         For I:=232 to 237 do Dlazdice[I].Typ:=13;
         For I:=222 to 227 do Dlazdice[I].Typ:=13;

{XXXXXXXXX LEVEL 04 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         {Player XY}
         Player.StartX:=64; Player.StartY:=64;

         {Enemy0}
         Enemy[0].StartX:=64; Enemy[0].StartY:=120;
         Enemy[0].LightLogic:=False;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=56; Enemy[1].StartY:=160;
         Enemy[1].LightLogic:=True;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=112; Enemy[2].StartY:=160;
         Enemy[2].LightLogic:=True;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=232; Odperovatko.Y:=176;

         Item[0].X:=280; Item[0].Y:=24;
         Item[1].X:=144; Item[1].Y:=120;
         Item[2].X:=104; Item[2].Y:=160;
         Item[3].X:=184; Item[3].Y:=24;
         Item[4].X:=128; Item[4].Y:=120;
         Item[5].X:=124; Item[5].Y:=64;
         Item[6].X:=304; Item[6].Y:=154;

         Domecek.X:=80; Domecek.Y:=96;
         {cas}
         Cas.CT:=300;
       End; {Level 4 prepare End}

    5: Begin
{XXXXXXXXX LEVEL 05 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=321 to 323 do Dlazdice[I].Typ:=14;
         For I:=328 to 344 do Dlazdice[I].Typ:=14;
         For I:=349 to 355 do Dlazdice[I].Typ:=14;
         For I:=0 to 14 do Dlazdice[280+(I*40)+26].Typ:=2;
         For I:=0 to 14 do Dlazdice[280+(I*40)+27].Typ:=2;
         For I:=842 to 864 do Dlazdice[I].Typ:=14;
         For I:=869 to 877 do Dlazdice[I].Typ:=14;

{XXXXXXXXX LEVEL 05 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         {Vzducholod}
         Vzducholod.Leta:=True;  {zapnout vzducholod}
         Vzducholod.Going:=True; {jde nejdriv doprava}
         Vzducholod.X:=10;
         Vzducholod.K:=37;
         Vzducholod.P:=120;
         Vzducholod.Sprite:=1;
         Vzducholod.UhelInt:=180;

         {Player XY}
         Player.StartX:=264; Player.StartY:=48;

         {Enemy0}
         Enemy[0].StartX:=264; Enemy[0].StartY:=152;
         Enemy[0].LightLogic:=True;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=128; Enemy[1].StartY:=48;
         Enemy[1].LightLogic:=True;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=32; Enemy[2].StartY:=152;
         Enemy[2].LightLogic:=True;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=40; Odperovatko.Y:=64;

         Item[0].X:=72;  Item[0].Y:=152;
         Item[1].X:=90;  Item[1].Y:=152;
         Item[2].X:=108; Item[2].Y:=152;
         Item[3].X:=272; Item[3].Y:=152;
         Item[4].X:=128; Item[4].Y:=48;
         Item[5].X:=13;  Item[5].Y:=48;
         Item[6].X:=40;  Item[6].Y:=24;

         Domecek.X:=64; Domecek.Y:=24;
         {cas}
         Cas.CT:=300;
       End; {Level 5 prepare End}

    6: Begin
{XXXXXXXXX LEVEL 06 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=486 to 495 do Dlazdice[I].Typ:=15;
         For I:=500 to 516 do Dlazdice[I].Typ:=15;
         For I:=0 to 10 do Dlazdice[440+(I*40)+3].Typ:=2;
         For I:=0 to 10 do Dlazdice[440+(I*40)+4].Typ:=2;
         For I:=846 to 855 do Dlazdice[I].Typ:=15;
         For I:=860 to 869 do Dlazdice[I].Typ:=15;
         For I:=874 to 879 do Dlazdice[I].Typ:=15;
         For I:=840 to 841 do Dlazdice[I].Typ:=15;

{XXXXXXXXX LEVEL 06 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         {Player XY}
         Player.StartX:=264; Player.StartY:=80;

         {Enemy0}
         Enemy[0].StartX:=168; Enemy[0].StartY:=152;
         Enemy[0].LightLogic:=True;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=88; Enemy[1].StartY:=152;
         Enemy[1].LightLogic:=True;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=64; Enemy[2].StartY:=80;
         Enemy[2].LightLogic:=True;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=136; Odperovatko.Y:=96;

         Item[0].X:=104; Item[0].Y:=80;
         Item[1].X:=88;  Item[1].Y:=152;
         Item[2].X:=196; Item[2].Y:=152;
         Item[3].X:=168; Item[3].Y:=80;
         Item[4].X:=108; Item[4].Y:=152;
         Item[5].X:=176; Item[5].Y:=152;
         Item[6].X:=136; Item[6].Y:=48;

         Domecek.X:=64; Domecek.Y:=56;
         {cas}
         Cas.CT:=300;
       End; {Level 6 prepare End}

    7: Begin
{XXXXXXXXX LEVEL 07 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=601 to 605 do Dlazdice[I].Typ:=1;
         For I:=610 to 620 do Dlazdice[I].Typ:=1;
         For I:=0 to 7 do Dlazdice[560+(I*40)+7].Typ:=2;
         For I:=0 to 7 do Dlazdice[560+(I*40)+8].Typ:=2;
         For I:=850 to 867 do Dlazdice[I].Typ:=1;
         For I:=872 to 876 do Dlazdice[I].Typ:=1;

{XXXXXXXXX LEVEL 07 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         Bonus.Round:=True;
         Bonus.Item[0].MinY:=4;   Bonus.Item[0].MaxY:=12;
         Bonus.Item[1].MinY:=5;   Bonus.Item[1].MaxY:=18;
         Bonus.Item[2].MinY:=4;   Bonus.Item[2].MaxY:=18;
         Bonus.Item[3].MinY:=3;   Bonus.Item[3].MaxY:=12;
         Bonus.Item[4].MinY:=3;   Bonus.Item[4].MaxY:=18;
         Bonus.Item[5].MinY:=2;   Bonus.Item[5].MaxY:=18;

         {Player XY}
         Player.StartX:=136; Player.StartY:=152;

         {Enemy0}
         Enemy[0].StartX:=1; Enemy[0].StartY:=160;
         Enemy[0].LightLogic:=True;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=1; Enemy[1].StartY:=160;
         Enemy[1].LightLogic:=True;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=1; Enemy[2].StartY:=160;
         Enemy[2].LightLogic:=True;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=0; Odperovatko.Y:=176;

         Item[0].X:=8;   Item[0].Y:=40;
         Item[1].X:=184; Item[1].Y:=64;
         Item[2].X:=256; Item[2].Y:=88;
         Item[3].X:=32;  Item[3].Y:=40;
         Item[4].X:=208; Item[4].Y:=64;
         Item[5].X:=280; Item[5].Y:=88;
         Item[6].X:=136; Item[6].Y:=104;

         Domecek.X:=104; Domecek.Y:=80;
         {cas}
         Cas.CT:=300;
       End; {Level 7 prepare End}

    8: Begin
{XXXXXXXXX LEVEL 08 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=894 to 903 do Dlazdice[I].Typ:=3;
         For I:=721 to 729 do Dlazdice[I].Typ:=3;
         For I:=0 to 10 do Dlazdice[480+(I*40)+11].Typ:=2;
         For I:=0 to 10 do Dlazdice[480+(I*40)+12].Typ:=2;
         For I:=748 to 758 do Dlazdice[I].Typ:=3;
         For I:=0 to 10 do Dlazdice[480+(I*40)+25].Typ:=2;
         For I:=0 to 10 do Dlazdice[480+(I*40)+26].Typ:=2;
         For I:=534 to 536 do Dlazdice[I].Typ:=3;
         For I:=541 to 543 do Dlazdice[I].Typ:=3;
         For I:=0 to 8 do Dlazdice[200+(I*40)+18].Typ:=2;
         For I:=0 to 8 do Dlazdice[200+(I*40)+19].Typ:=2;
         For I:=241 to 256 do Dlazdice[I].Typ:=3;
         For I:=261 to 269 do Dlazdice[I].Typ:=3;
         For I:=274 to 278 do Dlazdice[I].Typ:=3;

{XXXXXXXXX LEVEL 08 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         {Player XY}
         Player.StartX:=284; Player.StartY:=32;

         {Enemy0}
         Enemy[0].StartX:=40; Enemy[0].StartY:=128;
         Enemy[0].LightLogic:=False;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=296; Enemy[1].StartY:=128;
         Enemy[1].LightLogic:=True;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=148; Enemy[2].StartY:=160;
         Enemy[2].LightLogic:=True;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=248; Odperovatko.Y:=48;

         Item[0].X:=112; Item[0].Y:=88;
         Item[1].X:=16; Item[1].Y:=128;
         Item[2].X:=280; Item[2].Y:=128;
         Item[3].X:=168; Item[3].Y:=88;
         Item[4].X:=48; Item[4].Y:=128;
         Item[5].X:=248; Item[5].Y:=128;
         Item[6].X:=112; Item[6].Y:=160;

         Domecek.X:=128; Domecek.Y:=136;
         {cas}
         Cas.CT:=300;
       End; {Level 8 prepare End}

    9: Begin
{XXXXXXXXX LEVEL 09 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=194 to 198 do Dlazdice[I].Typ:=16;
         For I:=282 to 287 do Dlazdice[I].Typ:=16;
         For I:=522 to 527 do Dlazdice[I].Typ:=16;
         For I:=936 to 937 do Dlazdice[I].Typ:=16;
         For I:=802 to 807 do Dlazdice[I].Typ:=16;
         For I:=0 to 14 do Dlazdice[240+(I*40)+9].Typ:=2;
         For I:=0 to 14 do Dlazdice[240+(I*40)+10].Typ:=2;
         For I:=0 to 14 do Dlazdice[120+(I*40)+16].Typ:=2;
         For I:=0 to 14 do Dlazdice[120+(I*40)+17].Typ:=2;
         For I:=0 to 17 do Dlazdice[120+(I*40)+25].Typ:=2;
         For I:=0 to 17 do Dlazdice[120+(I*40)+26].Typ:=2;
         For I:=0 to 17 do Dlazdice[120+(I*40)+31].Typ:=2;
         For I:=0 to 17 do Dlazdice[120+(I*40)+32].Typ:=2;

{XXXXXXXXX LEVEL 09 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         {Player XY}
         Player.StartX:=284; Player.StartY:=16;

         {Enemy0}
         Enemy[0].StartX:=32; Enemy[0].StartY:=40;
         Enemy[0].LightLogic:=False;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=32; Enemy[1].StartY:=144;
         Enemy[1].LightLogic:=False;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=32; Enemy[2].StartY:=88;
         Enemy[2].LightLogic:=False;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=128; Odperovatko.Y:=168;

         Item[0].X:=184; Item[0].Y:=88;
         Item[1].X:=144; Item[1].Y:=24;
         Item[2].X:=20; Item[2].Y:=144;
         Item[3].X:=184; Item[3].Y:=112;
         Item[4].X:=144; Item[4].Y:=40;
         Item[5].X:=44; Item[5].Y:=144;
         Item[6].X:=32; Item[6].Y:=88;

         Domecek.X:=24; Domecek.Y:=16;
         {cas}
         Cas.CT:=300;
       End; {Level 9 prepare End}

   10: Begin
{XXXXXXXXX LEVEL 10 - XXXXXXXXXXXX PANELY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
         For I:=161 to 166 do Dlazdice[I].Typ:=17;
         For I:=171 to 184 do Dlazdice[I].Typ:=17;
         For I:=0 to 14 do Dlazdice[120+(I*40)+8].Typ:=2;
         For I:=0 to 14 do Dlazdice[120+(I*40)+9].Typ:=2;
         For I:=691 to 695 do Dlazdice[I].Typ:=17;
         For I:=700 to 704 do Dlazdice[I].Typ:=17;
         For I:=0 to 6 do Dlazdice[640+(I*40)+26].Typ:=2;
         For I:=0 to 6 do Dlazdice[640+(I*40)+27].Typ:=2;
         For I:=909 to 917 do Dlazdice[I].Typ:=17;
         For I:=420 to 424 do Dlazdice[I].Typ:=172;
         For I:=0 to 3 do Dlazdice[360+(I*40)+17].Typ:=2;
         For I:=0 to 3 do Dlazdice[360+(I*40)+18].Typ:=2;
         For I:=0 to 7 do Dlazdice[120+(I*40)+26].Typ:=2;
         For I:=0 to 7 do Dlazdice[120+(I*40)+27].Typ:=2;
         For I:=309 to 318 do Dlazdice[I].Typ:=17;
         For I:=881 to 904 do Dlazdice[I].Typ:=17;

{XXXXXXXXX LEVEL 10 - PLAYER ENEMIES ODPEROVATKO ITEMS DOMECEK CAS XXXXXXXXX}
         {Player XY}
         Player.StartX:=24; Player.StartY:=16;

         {Enemy0}
         Enemy[0].StartX:=136; Enemy[0].StartY:=120;
         Enemy[0].LightLogic:=False;
         Enemy[0].Vykreslovat:=True;

         {Enemy1}
         Enemy[1].StartX:=264; Enemy[1].StartY:=40;
         Enemy[1].LightLogic:=False;
         Enemy[1].Vykreslovat:=True;

         {Enemy2}
         Enemy[2].StartX:=264; Enemy[2].StartY:=160;
         Enemy[2].LightLogic:=True;
         Enemy[2].Vykreslovat:=True;

         {odperovatko}
         Odperovatko.X:=136; Odperovatko.Y:=136;

         Item[0].X:=172; Item[0].Y:=120;
         Item[1].X:=48; Item[1].Y:=48;
         Item[2].X:=248; Item[2].Y:=40;
         Item[3].X:=102; Item[3].Y:=120;
         Item[4].X:=48; Item[4].Y:=72;
         Item[5].X:=280; Item[5].Y:=40;
         Item[6].X:=172; Item[6].Y:=64;

         Domecek.X:=264; Domecek.Y:=136;
         {cas}
         Cas.CT:=300;
       End; {Level 10 prepare End}

  End; {Case End}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXX LEVEL SETUP XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
  {nastaveni dlazdic}
  I:=0;
  For Y:=0 to 24 do
  Begin
    For X:=0 to 39 do
    Begin
      Case Dlazdice[GetCisloDlazdice(X*8,Y*8)].Typ of
      1: Begin {panel}
           WriteBlok(X*8,Y*8,56,16,63,23,Buffer[1],Buffer[2]);
           Dlazdice[GetCisloDlazdice(X*8,Y*8)].Vyska:=1;
         End;
      2: Begin {lana}
           WriteSprite(X*8,Y*8,64,16,71,23,Buffer[1],Buffer[2]);
         End;
      3: Begin {zdivo}
           WriteBlok(X*8,Y*8,48,16,55,23,Buffer[1],Buffer[2]);
           Dlazdice[GetCisloDlazdice(X*8,Y*8)].Vyska:=1;
         End;
     13: Begin {panel 2}
           WriteBlok(X*8,Y*8,72,16,79,23,Buffer[1],Buffer[2]);
           Dlazdice[GetCisloDlazdice(X*8,Y*8)].Vyska:=1;
         End;
     14: Begin {zeleny blok}
           WriteBlok(X*8,Y*8,48,24,55,31,Buffer[1],Buffer[2]);
           Dlazdice[GetCisloDlazdice(X*8,Y*8)].Vyska:=1;
         End;
     15: Begin {modry blok}
           WriteBlok(X*8,Y*8,56,24,63,31,Buffer[1],Buffer[2]);
           Dlazdice[GetCisloDlazdice(X*8,Y*8)].Vyska:=1;
         End;
     16: Begin {cerveny blok}
           WriteBlok(X*8,Y*8,64,24,71,31,Buffer[1],Buffer[2]);
           Dlazdice[GetCisloDlazdice(X*8,Y*8)].Vyska:=1;
         End;
     17: Begin {zluty blok}
           WriteBlok(X*8,Y*8,72,24,79,31,Buffer[1],Buffer[2]);
           Dlazdice[GetCisloDlazdice(X*8,Y*8)].Vyska:=1;
         End;
      End; {Case End}
      Inc(I);
    End;
  End;

  {nastaveni playera}
  Player.Splouch.Je:=False;
  Player.Splouch.Pocitadlo:=0;
  Player.Score:=0;
  Player.Smer:=1;
  Player.Sprite:=1;
  Player.Vykreslovat:=True;
  Player.Mrtvy:=False;
  Player.Harakiri:=False;
  Player.DeathPocitadlo:=0;
  Player.Nausea:=False;
  Player.X:=Player.StartX;
  Player.Y:=Player.StartY;
  Player.LogY:=Player.StartY;
  Player.Skok:=False; Skok.Pocitadlo:=0; {!! JUMP !!}
  Player.Skok2:=False; Skok2.Pocitadlo:=0; {!! JUMP !!}
  Player.UpHelper:=0; Player.DownHelper:=0; {zpozdeni pri splhani}
  Player.PWRLeft:=0;
  Player.PWRRight:=0;
  Player.PWRDown:=0;
  Player.PWRLPocitadlo:=0;
  Player.PWRRPocitadlo:=0;

  {nastaveni enemies}
  For A:=0 to 2 do
  Begin
    Enemy[A].Smer:=1;
    Enemy[A].Sprite:=1;
    Enemy[A].X:=Enemy[A].StartX;
    Enemy[A].Y:=Enemy[A].StartY;
    Enemy[A].LogY:=Enemy[A].StartY;
    Enemy[A].RopesOnLeftFound:=False;
    Enemy[A].RopesOnRightFound:=False;
    Enemy[A].OnRopes:=False;
    Enemy[A].RightCounter:=0;
    Enemy[A].LeftCounter:=0;
    Enemy[A].Skok:=False; Enemy[A].EnemySkok.Pocitadlo:=0; {!! JUMP !!}
    Enemy[A].Skok2:=False; Enemy[A].EnemySkok2.Pocitadlo:=0; {!! JUMP !!}
    Enemy[A].UpHelper:=0; Enemy[A].DownHelper:=0; {zpozdeni pri splhani}
    Enemy[A].PWRLeft:=0;
    Enemy[A].PWRRight:=0;
    Enemy[A].PWRDown:=0;
    Enemy[A].PWRLPocitadlo:=0;
    Enemy[A].PWRRPocitadlo:=0;
    Enemy[A].Mrtvy:=False;
  End;

  {nastaveni odperovatka}
  Odperovatko.Sprite:=1;
  Odperovatko.Activ:=False;
  Odperovatko.Pocitadlo:=0;
  Odperovatko.MEM:=False;
  {dlazdice odperovatka}
  Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Vyska:=1;
  Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Vyska:=1;
  Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y+8)].Vyska:=1;
  Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y+8)].Vyska:=1;
  Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Typ:=4;
  Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Typ:=4;
  Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y+8)].Typ:=4;
  Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y+8)].Typ:=4;

  {nastaveni itemu 0..6}
  For I:=0 to 6 do
  Begin
    Item[I].Sebrany:=False; Item[I].Pocitadlo:=0;
    Dlazdice[GetCisloDlazdice(Item[I].X,Item[I].Y)].Typ:=I+6;
    Dlazdice[GetCisloDlazdice(Item[I].X+8,Item[I].Y)].Typ:=I+6;
    Dlazdice[GetCisloDlazdice(Item[I].X,Item[I].Y+8)].Typ:=I+6;
    Dlazdice[GetCisloDlazdice(Item[I].X+8,Item[I].Y+8)].Typ:=I+6;
  End;

  {nastaveni domecku}
  Domecek.Otevreno:=False;
  {nastaveni casu}
  Cas.Bool:=False;
  {level dokonceny}
  LevelCompleted:=False;
  {ENTER=START}
  StartLevel:=False;
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXX FRAME ENGINE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure NacitaniKlaves;
Begin
{Up}  If Key[72]=True then
      Begin
        If (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Pad=False) and (Player.Mrtvy=False) and
           (Player.DeathPocitadlo=0) then Player.Smer:=3;

        If (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+7)].Typ=2) and
           (Dlazdice[GetCisloDlazdice(Player.X,Player.Y-1)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y-1)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Player.X+15,Player.Y-1)].Vyska=0) and
           (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Mrtvy=False) and (Player.DeathPocitadlo=0) and
           (Player.Pad=False) then
        Begin {krok nahoru volny}
          Player.Pad:=False;
          If Player.Y>0 then
          Begin
            Inc(Player.UpHelper);
            If Player.UpHelper=3 then
            Begin Dec(Player.LogY); Dec(Player.Y); Player.UpHelper:=0; End;
          End;
        End;
      End;

{Left} If Key[75]=True then
      If Player.Nausea=False then
      Begin
        If (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Pad=False) and (Player.Mrtvy=False) and
           (Player.DeathPocitadlo=0) then Player.Smer:=2;

        If (Player.Pad=False) and (Player.Splouch.Je=False) and
           (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Mrtvy=False) and (Player.DeathPocitadlo=0) then
        If (Dlazdice[GetCisloDlazdice(Player.X-1,Player.Y)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Player.X-1,Player.Y+8)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Player.X-1,Player.Y+15)].Vyska=0) and
           (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Mrtvy=False) and (Player.DeathPocitadlo=0) and
           (Player.Pad=False) then
        Begin {krok doleva volny}
          If Player.X>0 then Dec(Player.X) else Player.X:=303;
        End;
        If (Player.Pad=False) and (Player.Skok2=False) and (Player.Skok=False) then
        Begin If Player.PWRLeft<10 then Inc(Player.PWRLeft); Player.PWRRight:=0; End;
      End;

{Down} If Key[80]=True then
      Begin
        If (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Pad=False) and (Player.Mrtvy=False) and
           (Player.DeathPocitadlo=0) then Player.Smer:=4;

        If (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+8)].Typ=2) and
           (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+16)].Vyska<>1) and
           (Dlazdice[GetCisloDlazdice(Player.X,Player.Y+16)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+16)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Player.X+15,Player.Y+16)].Vyska=0) and
           (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Mrtvy=False) and (Player.DeathPocitadlo=0) and
           (Player.Pad=False) then
        Begin {krok dolu volny}
          Player.Pad:=False;
          If Player.Y<183 then
          Begin
            Inc(Player.DownHelper);
            If Player.DownHelper=3 then
            Begin Inc(Player.LogY); Inc(Player.Y); Player.DownHelper:=0; End;
          End;
        End;
      End;

{Right} If Key[77]=True then
      If Player.Nausea=False then
      Begin
        If (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Pad=False) and (Player.Mrtvy=False) and
           (Player.DeathPocitadlo=0) then Player.Smer:=1;

        If (Player.Pad=False) and (Player.Splouch.Je=False) and
           (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Mrtvy=False) and (Player.DeathPocitadlo=0) then
        If (Dlazdice[GetCisloDlazdice(Player.X+16,Player.Y)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Player.X+16,Player.Y+8)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Player.X+16,Player.Y+15)].Vyska=0) and
           (Player.Skok=False) and (Player.Skok2=False) and
           (Player.Mrtvy=False) and (Player.DeathPocitadlo=0) and
           (Player.Pad=False) then
        Begin {krok doprava volny}
          If Player.X<303 then Inc(Player.X) else Player.X:=0;
        End;
        If (Player.Pad=False) and (Player.Skok2=False) and (Player.Skok=False) then
        Begin If Player.PWRRight<10 then Inc(Player.PWRRight); Player.PWRLeft:=0; End;
      End;

{Space} If Key[57]=True then { !!! SKOK !!! }
      Begin
        If ((Dlazdice[GetCisloDlazdice(Player.X+2,Player.Y+16)].Vyska=1) or
           (Dlazdice[GetCisloDlazdice(Player.X+13,Player.Y+16)].Vyska=1)) and
           (Player.Skok=False) and (Player.Mrtvy=False) and (Player.DeathPocitadlo=0) then
           Begin
             Player.Skok:=True;
             PlaySound(1);
           End;
        If Player.Pad=True then
        Begin
          Key[57]:=False;
          Player.PWRDown:=25;
        End;
        If Player.Nausea=True then Player.Nausea:=False;
      End;

{Esc} If Key[1]=True then
      Begin
        EndingPlay:=True;
        EndingGame:=True;
        StartGame:=False;
        Player.Mrtvy:=True;
      End;

{BackSpace} If Key[14]=True then
      Begin
        If Player.Harakiri=False then Dec(Player.Zivoty);
        Player.Harakiri:=True;
        Player.Mrtvy:=True;
        Player.Vykreslovat:=False;
        StartGame:=False;
        If (Player.Zivoty=0) and (Player.Harakiri=True) then
        Begin {game over}
          EndingPlay:=True;
          StartGame:=False;
        End;
      End;

{F}   If Key[33]=True then {show FPS}
      Begin
        If fpsButtonF<15 then Inc(fpsButtonF) else fpsButtonF:=0;
        If fpsButtonF=15 then
        Begin
          If ShowFPS=False then ShowFPS:=True else ShowFPS:=False;
        End;
      End;
End;


Procedure UmelaInteligence1;

{4x}  Procedure AI1_SearchLeft; {hleda lana doleva !! SEARCH LEFT !!}
      Var I: Byte;
      Begin
        If (Enemy[A].OnRopes=False) and (Enemy[A].RopesOnRightFound=False) then
        Begin
          For I:=Trunc(Enemy[A].X/8) downto 0 do
          Begin
            If Dlazdice[GetCisloDlazdice(I*8,Enemy[A].Y+15)].Typ=2
            then Begin Enemy[A].RopesOnLeftFound:=True; Break; End
            else Begin Enemy[A].RopesOnLeftFound:=False; End;
          End;
        End;
      End;

{4x}  Procedure AI1_SearchRight; {hleda lana doprava !! SEARCH RIGHT !!}
      Var I: Byte;
      Begin
        If (Enemy[A].OnRopes=False) and (Enemy[A].RopesOnLeftFound=False) then
        Begin
            For I:=Trunc(Enemy[A].X/8) to 39 do
            Begin
              If Dlazdice[GetCisloDlazdice(I*8,Enemy[A].Y+15)].Typ=2
              then Begin Enemy[A].RopesOnRightFound:=True; Break; End
              else Begin Enemy[A].RopesOnRightFound:=False; End;
            End;
        End;
      End;

{2x}  Procedure AI1_GoLeft; {nasel lana vlevo tak tam jde - !! GO LEFT !!}
      Begin
        If (Enemy[A].OnRopes=False) and (Enemy[A].RopesOnLeftFound=True) and
           (Enemy[A].Pad=False) then
        Begin
            If not ((Dlazdice[GetCisloDlazdice(Enemy[A].X,Enemy[A].Y+8)].Typ=2) and
                    (Dlazdice[GetCisloDlazdice(Enemy[A].X+15,Enemy[A].Y+8)].Typ=2))
            then Begin Enemy[A].LeftPressed:=True; Enemy[A].RightPressed:=False; End
            else Begin Enemy[A].OnRopes:=True; End;
        End;
      End;

{2x}  Procedure AI1_GoRight; {nasel lana vpravo tak tam jde - !! GO RIGHT !!}
      Begin
        If (Enemy[A].OnRopes=False) and (Enemy[A].RopesOnRightFound=True) and
           (Enemy[A].Pad=False) then
          Begin
            If not ((Dlazdice[GetCisloDlazdice(Enemy[A].X,Enemy[A].Y+7)].Typ=2) and
                    (Dlazdice[GetCisloDlazdice(Enemy[A].X+15,Enemy[A].Y+7)].Typ=2))
            then Begin Enemy[A].LeftPressed:=False; Enemy[A].RightPressed:=True; End
            else Begin Enemy[A].OnRopes:=True; End;
          End;
      End;

{2x}  Procedure AI1_SearchThenGo;
      Begin
        {player je vlevo a enemy vpravo - hleda nejdriv doleva}
        If Enemy[A].X>Player.X then
        Begin
          AI1_SearchLeft; {hleda lana doleva !! SEARCH LEFT !!}
          AI1_SearchRight; {hleda lana doprava !! SEARCH RIGHT !!}
        End;

        {player je vpravo a enemy vlevo - hleda nejdriv doprava}
        If Enemy[A].X<=Player.X then
        Begin
          AI1_SearchRight; {hleda lana doprava !! SEARCH RIGHT !!}
          AI1_SearchLeft; {hleda lana doleva !! SEARCH LEFT !!}
        End;

        AI1_GoLeft;  {nasel lana vlevo tak tam jde - !! GO LEFT !!}
        AI1_GoRight; {nasel lana vpravo tak tam jde - !! GO RIGHT !!}
      End;

Begin
{vynulovat virtualni klavesy:}
  Enemy[A].LeftPressed:=False;
  Enemy[A].RightPressed:=False;
  Enemy[A].UpPressed:=False;
  Enemy[A].DownPressed:=False;
  Enemy[A].JumpPressed:=False;
  Enemy[A].PathFreeL:=False;
  Enemy[A].PathFreeR:=False;

{jednoducha logika pouze doleva doprava:}
  If Enemy[A].LightLogic=True then
  Begin
    If Enemy[A].Going=True then {jde doleva}
    If not (Dlazdice[GetCisloDlazdice(Enemy[A].X-1,Enemy[A].Y+16)].Vyska=0)
    then Begin Enemy[A].LeftPressed:=True; Enemy[A].Going:=True; End
    else Begin Enemy[A].RightPressed:=True; Enemy[A].Going:=False; End;
    If Enemy[A].Going=False then {jde doprava}
    If not (Dlazdice[GetCisloDlazdice(Enemy[A].X+16,Enemy[A].Y+16)].Vyska=0)
    then Begin Enemy[A].RightPressed:=True; Enemy[A].Going:=False; End
    else Begin Enemy[A].LeftPressed:=True; Enemy[A].Going:=True; End;
  End; {End LightLogic True}

{slozita logika - hleda cestu:}
  If Enemy[A].LightLogic=False then
  Begin

    {3x2 ctverecky doprava volne ? ... PathFreeR:=True}
    If (Dlazdice[getCisloDlazdice(Enemy[A].X+16,Enemy[A].Y)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X+24,Enemy[A].Y)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X+32,Enemy[A].Y)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X+16,Enemy[A].Y+8)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X+24,Enemy[A].Y+8)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X+32,Enemy[A].Y+8)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X+16,Enemy[A].Y+15)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X+24,Enemy[A].Y+15)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X+32,Enemy[A].Y+15)].Vyska=0)
       then Begin Enemy[A].PathFreeR:=True; End
       else Begin Enemy[A].PathFreeR:=False; End;

    {3x2 ctverecky doleva volne ? ... PathFreeL:=True}
    If (Dlazdice[getCisloDlazdice(Enemy[A].X-1,Enemy[A].Y)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X-8,Enemy[A].Y)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X-16,Enemy[A].Y)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X-1,Enemy[A].Y+8)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X-8,Enemy[A].Y+8)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X-16,Enemy[A].Y+8)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X-1,Enemy[A].Y+15)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X-8,Enemy[A].Y+15)].Vyska=0) and
       (Dlazdice[getCisloDlazdice(Enemy[A].X-16,Enemy[A].Y+15)].Vyska=0)
       then Begin Enemy[A].PathFreeL:=True; End
       else Begin Enemy[A].PathFreeL:=False; End;

{kdyz jsou na stejne urovni Y:}
    If Enemy[A].LogY=Player.LogY then
    Begin
      Enemy[A].RopesOnLeftFound:=False;   {setup AI}
      Enemy[A].RopesOnRightFound:=False;  {setup AI}
      Enemy[A].OnRopes:=False;            {setup AI}

      {player je vlevo a enemy vpravo}
      If (Enemy[A].X>Player.X) and (Enemy[A].PathFreeL=True) and
         (Enemy[A].Pad=False) then
      Begin
        Enemy[A].LeftCounter:=20;
        If Enemy[A].Skok=False then
        If Enemy[A].RightCounter>0 then Dec(Enemy[A].RightCounter);
        If not (Dlazdice[GetCisloDlazdice(Enemy[A].X-1,Enemy[A].Y+16)].Vyska=0)
        then Begin If Enemy[A].RightCounter=0 then Enemy[A].LeftPressed:=True; End
        else Begin If Enemy[A].RightCounter=0 then
                                                Begin
                                                  Enemy[A].LeftPressed:=True;
                                                  Enemy[A].PWRLeft:=10;
                                                  Enemy[A].JumpPressed:=True;
                                                End;
             End;
      End;

      {player je vpravo a enemy vlevo}
      If (Enemy[A].X<Player.X) and (Enemy[A].PathFreeR=True) and
         (Enemy[A].Pad=False) then
      Begin
        Enemy[A].RightCounter:=20; If Enemy[A].Skok=False then
        If Enemy[A].LeftCounter>0 then Dec(Enemy[A].LeftCounter);
        If not (Dlazdice[GetCisloDlazdice(Enemy[A].X+16,Enemy[A].Y+16)].Vyska=0)
        then Begin If Enemy[A].LeftCounter=0 then Enemy[A].RightPressed:=True; End
        else Begin If Enemy[A].LeftCounter=0 then
                                               Begin
                                                 Enemy[A].RightPressed:=True;
                                                 Enemy[A].PWRRight:=10;
                                                 Enemy[A].JumpPressed:=True;
                                               End;
             End;
      End;
    End; {End kdyz jsou na stejne urovni Y}

{kdyz je player nahore a enemy dole}
    If Enemy[A].LogY>Player.LogY then
    Begin

      AI1_SearchThenGo; {hleda cestu k lanum a jde na lana}

      {je na lanech co vedou nahoru smerem bliz k playerovi !! GO UP !!}
      If Enemy[A].OnRopes=True then
      Begin
        If Dlazdice[GetCisloDlazdice(Enemy[A].X+7,Enemy[A].Y+7)].Typ=2 then
        Begin {je na lane a splha nahoru}
          Enemy[A].UpPressed:=True;     {leze nahoru}
          Enemy[A].LeftPressed:=False;  {nejde doleva}
          Enemy[A].RightPressed:=False; {nejde doprava}
        End else
        Begin {uz je na konci lana}
          Enemy[A].UpPressed:=False;            {prestane splhat nahoru}
          Enemy[A].OnRopes:=False;              {prestane byt na lanech}
          Enemy[A].RopesOnRightFound:=False;    {znovu bude hledat cestu R}
          Enemy[A].RopesOnLeftFound:=False;     {znovu bude hledat cestu L}
        End;
      End;
    End; {End kdyz je player nahore a enemy dole}

{kdyz je player dole a enemy nahore}
    If Enemy[A].LogY<Player.LogY then
    Begin

      AI1_SearchThenGo; {hleda cestu k lanum a jde na lana}

      {je na lanech co vedou dolu k playerovi !! GO DOWN !!}
      If Enemy[A].OnRopes=True then
      Begin
        If Dlazdice[GetCisloDlazdice(Enemy[A].X+8,Enemy[A].Y+16)].Typ=2 then
        Begin {je na lane a leze dolu}
          Enemy[A].DownPressed:=True;   {leze dolu}
          Enemy[A].LeftPressed:=False;  {nejde doleva}
          Enemy[A].RightPressed:=False; {nejde doprava}
        End else
        Begin {uz je na konci lana}
          If Dlazdice[GetCisloDlazdice(Enemy[A].X,Trunc(Enemy[A].Y/8)+1)].Typ=0 then
          Begin {ma pod sebou jeste vzduch tak sleze jeste niz a spadne}
            Enemy[A].DownPressed:=True;   {leze dolu}
            Enemy[A].LeftPressed:=False;  {nejde doleva}
            Enemy[A].RightPressed:=False; {nejde doprava}
          End else
          Begin {je zrejme uz na plosine tak prestane jit dolu}
            Enemy[A].DownPressed:=False;          {prestane splhat nahoru}
            Enemy[A].OnRopes:=False;              {prestane byt na lanech}
            Enemy[A].RopesOnRightFound:=False;    {znovu bude hledat cestu R}
            Enemy[A].RopesOnLeftFound:=False;     {znovu bude hledat cestu L}
          End;
        End;
      End;

    End; {End kdyz je player dole a enemy nahore}
  End; {End LightLogic=False}

{kdyz ma nauseu:}
  If Enemy[A].Nausea=True then
  Begin
    Inc(Enemy[A].NauseaCounter);
    If Enemy[A].NauseaCounter=40 then
    Begin
      Enemy[A].NauseaCounter:=0;
      Enemy[A].JumpPressed:=True;
      Enemy[A].LeftPressed:=False;
      Enemy[A].RightPressed:=False;
    End;
  End;

End;


Procedure UmelaInteligence2;
Begin
{ENEMY nahoru:}
     If Enemy[A].UpPressed=True then
      Begin
        If (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) and
           (Enemy[A].Pad=False) then Enemy[A].Smer:=3;

        If (Dlazdice[GetCisloDlazdice(Enemy[A].X+8,Enemy[A].Y+8)].Typ=2) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X,Enemy[A].Y-1)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X+8,Enemy[A].Y-1)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X+15,Enemy[A].Y-1)].Vyska=0) and
           (Enemy[A].Pad=False) and (Enemy[A].Splouch.Je=False) and
           (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) then
        Begin {krok nahoru volny}
          Enemy[A].Pad:=False;
          If Enemy[A].Y>0 then
          Begin
            Inc(Enemy[A].UpHelper);
            If Enemy[A].UpHelper=3 then
            Begin Dec(Enemy[A].LogY); Dec(Enemy[A].Y); Enemy[A].UpHelper:=0; End;
          End;
        End;
      End;

{ENEMY doleva:}
      If Enemy[A].LeftPressed=True then
      If Enemy[A].Nausea=False then
      Begin
        If (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) and
           (Enemy[A].Pad=False) then Enemy[A].Smer:=2;

        If (Dlazdice[GetCisloDlazdice(Enemy[A].X-1,Enemy[A].Y)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X-1,Enemy[A].Y+8)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X-1,Enemy[A].Y+15)].Vyska=0) and
           (Enemy[A].Pad=False) and (Enemy[A].Splouch.Je=False) and
           (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) then
        Begin {krok doleva volny}
          If Enemy[A].X>0 then Dec(Enemy[A].X) else Enemy[A].X:=303;
        End;
        If (Enemy[A].Pad=False) and (Enemy[A].Skok=False) then
        Begin If Enemy[A].PWRLeft<10 then Inc(Enemy[A].PWRLeft); Enemy[A].PWRRight:=0; End;
      End;

{ENEMY dolu:}
      If Enemy[A].DownPressed=True then
      Begin
        If (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) and
           (Enemy[A].Pad=False) then Enemy[A].Smer:=4;

        If (Dlazdice[GetCisloDlazdice(Enemy[A].X+8,Enemy[A].Y+8)].Typ=2) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X+8,Enemy[A].Y+16)].Vyska<>1) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X,Enemy[A].Y+16)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X+8,Enemy[A].Y+16)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X+15,Enemy[A].Y+16)].Vyska=0) and
           (Enemy[A].Pad=False) and (Enemy[A].Splouch.Je=False) and
           (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) then
        Begin {krok dolu volny}
          Enemy[A].Pad:=False;
          If Enemy[A].Y<183 then
          Begin
            Inc(Enemy[A].DownHelper);
            If Enemy[A].DownHelper=3 then
            Begin Inc(Enemy[A].LogY); Inc(Enemy[A].Y); Enemy[A].DownHelper:=0; End;
          End;
        End;
      End;

{ENEMY doprava:}
      If Enemy[A].RightPressed=True then
      If Enemy[A].Nausea=False then
      Begin
        If (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) and
           (Enemy[A].Pad=False) then Enemy[A].Smer:=1;

        If (Dlazdice[GetCisloDlazdice(Enemy[A].X+16,Enemy[A].Y)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X+16,Enemy[A].Y+8)].Vyska=0) and
           (Dlazdice[GetCisloDlazdice(Enemy[A].X+16,Enemy[A].Y+15)].Vyska=0) and
           (Enemy[A].Pad=False) and (Enemy[A].Splouch.Je=False) and
           (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) then
        Begin {krok doprava volny}
          If Enemy[A].X<303 then Inc(Enemy[A].X) else Enemy[A].X:=0;
        End;
        If (Enemy[A].Pad=False) and (Enemy[A].Skok=False) then
        If Enemy[A].PWRRight<10 then Inc(Enemy[A].PWRRight); Enemy[A].PWRLeft:=0;
      End;

{ENEMY skok:}
      If Enemy[A].JumpPressed=True then
      Begin
        If ((Dlazdice[GetCisloDlazdice(Enemy[A].X+2,Enemy[A].Y+16)].Vyska=1) or
           (Dlazdice[GetCisloDlazdice(Enemy[A].X+13,Enemy[A].Y+16)].Vyska=1)) and
           (Enemy[A].Skok=False) then
           Enemy[A].Skok:=True;
        If Enemy[A].Pad=True then
        Begin
          Enemy[A].JumpPressed:=False;
          Enemy[A].PWRDown:=25;
        End;
        If Enemy[A].Nausea=True then Enemy[A].Nausea:=False;
      End;
End;


Procedure FramePohyb;
Var I,P: Word; {I pro Itemy}
Begin
  {player}
  If Player.Pad=False then
  If (Key[72]=True) or (Key[75]=True) or (Key[77]=True) or (Key[80]=True) then
  Begin {Zpozdeni pro stridani spritu 1 a 2}
    If Player.Sprite=1 then Begin
                            Inc(Player.Pocitadlo); If Player.Pocitadlo>10 then
                            Begin Player.Sprite:=2; Player.Pocitadlo:=0; End;
                            End;
    If Player.Sprite=2 then Begin
                            Inc(Player.Pocitadlo); If Player.Pocitadlo>10 then
                            Begin Player.Sprite:=1; Player.Pocitadlo:=0; End;
                            End;
  End;

  {player stop akcelerace - kdyz se zastavi na miste}
  If (Key[75]=False) and (Key[77]=False) and
     (Player.Pad=False) and (Player.Skok=False) and (Player.Skok2=False) then
  Begin
    Player.PWRLeft:=0;
    Player.PWRRight:=0;
  End;

  {player gravitace}
  If (Dlazdice[GetCisloDlazdice(Player.X+13,Player.Y+15)].Typ<>5) and
     (Dlazdice[GetCisloDlazdice(Player.X+13,Player.Y+16)].Vyska=0) and
     (Dlazdice[GetCisloDlazdice(Player.X+13,Player.Y+8)].Typ<>2) and
     (Dlazdice[GetCisloDlazdice(Player.X+2,Player.Y+16)].Typ<>5) and
     (Dlazdice[GetCisloDlazdice(Player.X+2,Player.Y+16)].Vyska=0) and
     (Dlazdice[GetCisloDlazdice(Player.X+2,Player.Y+8)].Typ<>2) then
  Begin {falldown}
    If (Player.Skok=False) and (Player.Skok2=False) then
    Begin
      Player.Pad:=True;
      If Player.Y<183 then Inc(Player.Y);
      If Player.PWRDown<50 then Inc(Player.PWRDown);
      If Player.PWRDown=50 then
      Begin
        If Player.Nausea=False then PlaySound(6);
        Player.Nausea:=True;
      End;
    End;
  End else
  Begin {not fall down}
    If (Player.Splouch.Je=False) and (Player.PWRDown>0) then PlaySound(7);
    Player.Pad:=False;
    Player.PWRDown:=0;
    Player.LogY:=Player.Y;
  End;

  {Player falldown akcelerace X}
  If Player.Pad=True then
  Case Player.Smer of
    1: Begin {doprava}
         If Player.PWRRight in [3..8] then
         Begin
           If Dlazdice[GetCisloDlazdice(Player.X+16,Player.Y+15)].Vyska=0 then
           Begin {pad doprava volny}
             If Player.X<303 then Begin
                                    Inc(Player.PWRRPocitadlo);
                                    If Player.PWRRPocitadlo=2 then
                                    Begin
                                      Inc(Player.X);
                                      Player.PWRRPocitadlo:=0;
                                    End;
                                  End
                             else Player.X:=0;
           End;
         End;
         If Player.PWRRight in [9..10] then
         Begin
           If Dlazdice[GetCisloDlazdice(Player.X+16,Player.Y+15)].Vyska=0 then
           Begin {pad doprava volny}
             If Player.X<303 then Inc(Player.X) else Player.X:=0;
           End;
         End;
       End; {1 End doprava}
    2: Begin {doleva}
         If Player.PWRLeft in [3..8] then
         Begin
           If Dlazdice[GetCisloDlazdice(Player.X,Player.Y+15)].Vyska=0 then
           Begin {pad doleva volny}
             If Player.X>0 then Begin
                                  Inc(Player.PWRLPocitadlo);
                                  If Player.PWRLPocitadlo=2 then
                                  Begin
                                    Dec(Player.X);
                                    Player.PWRLPocitadlo:=0;
                                  End;
                                End
                           else Player.X:=303;
           End;
         End;
         If Player.PWRLeft in [9..10] then
         Begin
           If Dlazdice[GetCisloDlazdice(Player.X,Player.Y+15)].Vyska=0 then
           Begin {pad doleva volny}
             If Player.X>0 then Dec(Player.X) else Player.X:=303;
           End;
         End;
       End; {2 End doleva}
  End; {Case End}

  {player pad do vody}
  If Player.Splouch.Je=False then
  If Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+16)].Typ=5 then
  Begin {panak je ve vode}
    PlaySound(4);
    Player.Splouch.Je:=True;
    Player.Vykreslovat:=False;
    Player.Mrtvy:=True;
    Dec(Player.Zivoty);
  End;

  {player splouch}
  If Player.Splouch.Je=True then Begin
                                   Inc(Player.Splouch.Pocitadlo); {If 50 then exit}
                                   If (Player.Zivoty=0) and (Player.Splouch.Pocitadlo=50) then
                                   Begin {game over}
                                     EndingPlay:=True;
                                     StartGame:=False;
                                   End;
                                 End;
  {player skok}
  If Player.Skok=True then
  Begin
    Inc(Skok.Pocitadlo);
    Case Player.Smer of
     1: Begin {skok doprava}
          If Skok.Pocitadlo<16 then
          Begin
            If Player.PWRRight=0 then
            Begin {skok na miste s pohledem doprava}
            End;
            If Player.PWRRight in [3..8] then
            Begin {maly skok}
              If Player.X<303 then Begin
                                     Inc(Player.PWRRPocitadlo);
                                     If Player.PWRRPocitadlo=2 then
                                     Begin
                                       Inc(Player.X);
                                       Player.PWRRPocitadlo:=0;
                                     End;
                                   End
                              else Player.X:=0;
            End;
            If Player.PWRRight in [9..10] then
            Begin {velky skok}
              If Player.X<303 then Inc(Player.X) else Player.X:=0;
            End;
            Dec(Player.Y); {snizujeme Y = panak stoupa}
          End;
        End;
     2: Begin {skok doleva}
          If Skok.Pocitadlo<16 then
          Begin
            If Player.PWRLeft=0 then
            Begin {skok na miste s pohledem doleva}
            End;
            If Player.PWRLeft in [3..8] then
            Begin {maly skok}
              If Player.X>0 then Begin
                                   Inc(Player.PWRLPocitadlo);
                                   If Player.PWRLPocitadlo=2 then
                                   Begin
                                     Dec(Player.X);
                                     Player.PWRLPocitadlo:=0;
                                   End;
                                 End
                            else Player.X:=303;
            End;
            If Player.PWRLeft in [9..10] then
            Begin {velky skok}
              If Player.X>0 then Dec(Player.X) else Player.X:=303;
            End;
            Dec(Player.Y); {snizujeme Y = panak stoupa}
          End;
        End;
     3: Begin {skok zady k obrazovce}
          If Skok.Pocitadlo<16 then Dec(Player.Y);
        End;
     4: Begin {skok s pohledem na obrazovku}
          If Skok.Pocitadlo<16 then Dec(Player.Y);
        End;
    End; {Case End}

    If Skok.Pocitadlo in [16..24] then {vrchol skoku}
    Begin
    Case Player.Smer of
     1: Begin {skok doprava}
          If Player.PWRRight=0 then
          Begin {skok na miste s pohledem doprava}
          End;

          If Player.PWRRight in [3..8] then
          Begin {maly skok}
            If Player.X<303 then Begin
                                   Inc(Player.PWRRPocitadlo);
                                   If Player.PWRRPocitadlo=2 then
                                   Begin
                                     Inc(Player.X);
                                     Player.PWRRPocitadlo:=0;
                                   End;
                                 End
                            else Player.X:=0;
          End;

          If Player.PWRRight in [9..10] then
          Begin {velky skok}
            If Player.X<303 then Inc(Player.X) else Player.X:=0;
          End;
          {uz nesnizujeme Y - je vrchol skoku panak visi ve vzduchu}
        End; {End skok doprava Case = 1}
     2: Begin {skok doleva}
          If Player.PWRLeft=0 then
          Begin {skok na miste s pohledem doleva}
          End;
          If Player.PWRLeft in [3..8] then
          Begin {maly skok}
            If Player.X>0 then Begin
                                 Inc(Player.PWRLPocitadlo);
                                 If Player.PWRLPocitadlo=2 then
                                 Begin
                                   Dec(Player.X);
                                   Player.PWRLPocitadlo:=0;
                                 End;
                               End
                          else Player.X:=303;
          End;
          If Player.PWRLeft in [9..10] then
          Begin {velky skok}
             If Player.X>0 then Dec(Player.X) else Player.X:=303;
          End;
          {uz nesnizujeme Y - je vrchol skoku panak visi ve vzduchu}
        End;
     3: Begin End; {skok zady k obrazovce}
     4: Begin End; {skok s pohledem na obrazovku}
      End{Case End skok byl 1=doprava 2=doleva}
    End;

    If Skok.Pocitadlo=25 then {konec skoku - panak zacina padat}
    Begin
      Skok.Pocitadlo:=0;
      Player.Skok:=False;
      Player.Pad:=True;
    End;
  End; {End Skok=True}

  {player skok 2 - ODPEROVATKOVY SKOK}
  If Player.Skok2=True then
  Begin
    Inc(Skok2.Pocitadlo);
    Case Player.Smer of
     1: Begin {skok doprava}
          If Skok2.Pocitadlo<30 then
          Begin
            If Player.PWRRight=0 then
            Begin {skok na miste s pohledem doprava}
            End;
            If Player.PWRRight in [3..8] then
            Begin {maly skok}
              If Player.X<303 then Begin
                                     Inc(Player.PWRRPocitadlo);
                                     If Player.PWRRPocitadlo=2 then
                                     Begin
                                       Inc(Player.X);
                                       Player.PWRRPocitadlo:=0;
                                     End;
                                   End
                              else Player.X:=0;
            End;
            If Player.PWRRight in [9..10] then
            Begin {velky skok}
              If Player.X<303 then Inc(Player.X) else Player.X:=0;
            End;
            Dec(Player.Y); {snizujeme Y - panak stoupa}
          End;
        End;
     2: Begin {skok doleva}
          If Skok2.Pocitadlo<30 then
          Begin
            If Player.PWRLeft=0 then
            Begin {skok na miste s pohledem doleva}
            End;
            If Player.PWRLeft in [3..8] then
            Begin {maly skok}
              If Player.X>0 then Begin
                                   Inc(Player.PWRLPocitadlo);
                                   If Player.PWRLPocitadlo=2 then
                                   Begin
                                     Dec(Player.X);
                                     Player.PWRLPocitadlo:=0;
                                   End;
                                 End
                            else Player.X:=303;
            End;
            If Player.PWRLeft in [9..10] then
            Begin {velky skok}
              If Player.X>0 then Dec(Player.X) else Player.X:=303;
            End;
            Dec(Player.Y); {snizujeme Y - panak stoupa}
          End;
        End;
     3: Begin {skok zady k obrazovce}
          If Skok2.Pocitadlo<30 then Dec(Player.Y);
        End;
     4: Begin {skok s pohledem na obrazovku}
          If Skok2.Pocitadlo<30 then Dec(Player.Y);
        End;
    End; {Case End}

    If Skok2.Pocitadlo in [31..39] then {vrchol skoku}
    Begin
      Case Player.Smer of
       1: Begin {skok doprava}
            If Player.PWRRight=0 then
            Begin {skok na miste s pohledem doprava}
            End;

            If Player.PWRRight in [3..8] then
            Begin {maly skok}
              If Player.X<303 then Begin
                                     Inc(Player.PWRRPocitadlo);
                                     If Player.PWRRPocitadlo=2 then
                                     Begin
                                       Inc(Player.X);
                                       Player.PWRRPocitadlo:=0;
                                     End;
                                   End
                              else Player.X:=0;
            End;

            If Player.PWRRight in [9..10] then
            Begin {velky skok}
              If Player.X<303 then Inc(Player.X) else Player.X:=0;
            End;
          End;
       2: Begin {skok doleva}
            If Player.PWRLeft=0 then
            Begin {skok na miste s pohledem doleva}
            End;
            If Player.PWRLeft in [3..8] then
            Begin {maly skok}
              If Player.X>0 then Begin
                                   Inc(Player.PWRLPocitadlo);
                                   If Player.PWRLPocitadlo=2 then
                                   Begin
                                     Dec(Player.X);
                                     Player.PWRLPocitadlo:=0;
                                   End;
                                 End
                            else Player.X:=303;
            End;
            If Player.PWRLeft in [9..10] then
            Begin {velky skok}
               If Player.X>0 then Dec(Player.X) else Player.X:=303;
            End;
          End;
       3: Begin End; {skok zady k obrazovce  - vrchol skoku}
       4: Begin End; {skok tvari k obrazovce - vrchol skoku}
      End; {Case End}
    End;

    If Skok2.Pocitadlo=40 then {konec skoku - panak zacina padat}
    Begin
      Skok2.Pocitadlo:=0;
      Player.Skok2:=False;
      Player.Pad:=True;
    End;
  End; {End Skok=True}

  {player odperovatko}
  If ((Dlazdice[GetCisloDlazdice(Player.X+1,Player.Y+16)].Typ=4) or
     (Dlazdice[GetCisloDlazdice(Player.X+14,Player.Y+16)].Typ=4)) and
     (Player.PWRDown>10) and (Player.Skok=False) and (Player.Skok2=False) then
     Begin Odperovatko.Activ:=True; PlaySound(1); End;

  {skok na odperovatku}
  If ((Dlazdice[GetCisloDlazdice(Player.X+1,Player.Y+8)].Typ=4) or
      (Dlazdice[GetCisloDlazdice(Player.X+1,Player.Y+16)].Typ=4) or
      (Dlazdice[GetCisloDlazdice(Player.X+1,Player.Y+24)].Typ=4) or
      (Dlazdice[GetCisloDlazdice(Player.X+14,Player.Y+8)].Typ=4) or
      (Dlazdice[GetCisloDlazdice(Player.X+14,Player.Y+16)].Typ=4) or
     (Dlazdice[GetCisloDlazdice(Player.X+14,Player.Y+24)].Typ=4)) and
     (Odperovatko.Activ=True) and (Player.Skok=False) and (Player.Skok2=False) then
    Begin
      If Odperovatko.MEM=False then
      Begin
        Odperovatko.Power:=Player.PWRDown;
        Odperovatko.MEM:=True;
      End;
      Inc(Odperovatko.Pocitadlo);
      If Odperovatko.Pocitadlo in [0..4] then
      Begin {odperovatko klesa 1}
        Odperovatko.Sprite:=2;
        Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Vyska:=0;
        Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Typ:=0;
        Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Vyska:=0;
        Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Typ:=0;
      End;
      If Odperovatko.Pocitadlo in [5..9] then
      Begin {odperovatko klesa 2}
        Odperovatko.Sprite:=3;
      End;
      If Odperovatko.Pocitadlo in [10..11] then
      Begin {odperovatko stoupa 1}
        Odperovatko.Sprite:=2;
        Dec(Player.Y,4);
      End;
      If Odperovatko.Pocitadlo=12 then
      Begin {odperovatko stoupa 2}
        Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Vyska:=1;
        Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Typ:=4;
        Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Vyska:=1;
        Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Typ:=4;
        Odperovatko.Sprite:=1;
        Odperovatko.Pocitadlo:=0;
        Odperovatko.Activ:=False;
        If Odperovatko.Power<35 then Player.Skok:=True
                                else Player.Skok2:=True;
      End;
    End;

  {odperovatko ready}
  If Odperovatko.Activ=False then
  Begin
    Odperovatko.Power:=0;
    Odperovatko.MEM:=False;
    Odperovatko.Pocitadlo:=0;
    Odperovatko.Sprite:=1;
  End;

  {BonusRound ITEMS}
  If Bonus.Round=True then
  Begin
    For I:=0 to 5 do
    Begin
      If Item[I].Sebrany=False then
      Begin
        If Bonus.Item[I].Go=False then
        Begin
          If Bonus.Item[I].Pocitadlo<4
          then Inc(Bonus.Item[I].Pocitadlo)
          else
            Begin
              Bonus.Item[I].Pocitadlo:=0;
              Inc(Item[I].Y,8);
              For P:=Bonus.Item[I].MinY to Bonus.Item[I].MaxY do
              Begin
                Dlazdice[GetCisloDlazdice(Item[I].X,P*8)].Typ:=0;
                Dlazdice[GetCisloDlazdice(Item[I].X+8,P*8)].Typ:=0;
                Dlazdice[GetCisloDlazdice(Item[I].X,P*8+8)].Typ:=0;
                Dlazdice[GetCisloDlazdice(Item[I].X+8,P*8+8)].Typ:=0;
              End;
              Dlazdice[GetCisloDlazdice(Item[I].X,Item[I].Y)].Typ:=I+6;
              Dlazdice[GetCisloDlazdice(Item[I].X+8,Item[I].Y)].Typ:=I+6;
              Dlazdice[GetCisloDlazdice(Item[I].X,Item[I].Y+8)].Typ:=I+6;
              Dlazdice[GetCisloDlazdice(Item[I].X+8,Item[I].Y+8)].Typ:=I+6;
              If Item[I].Y=Bonus.Item[I].MaxY*8 then Bonus.Item[I].Go:=True;
            End;
        End else
        Begin
          If Bonus.Item[I].Pocitadlo<4
          then Inc(Bonus.Item[I].Pocitadlo)
          else
            Begin
              Bonus.Item[I].Pocitadlo:=0;
              Dec(Item[I].Y,8);
              For P:=Bonus.Item[I].MinY to Bonus.Item[I].MaxY do
              Begin
                Dlazdice[GetCisloDlazdice(Item[I].X,P*8)].Typ:=0;
                Dlazdice[GetCisloDlazdice(Item[I].X+8,P*8)].Typ:=0;
                Dlazdice[GetCisloDlazdice(Item[I].X,P*8+8)].Typ:=0;
                Dlazdice[GetCisloDlazdice(Item[I].X+8,P*8+8)].Typ:=0;
              End;
              Dlazdice[GetCisloDlazdice(Item[I].X,Item[I].Y)].Typ:=I+6;
              Dlazdice[GetCisloDlazdice(Item[I].X+8,Item[I].Y)].Typ:=I+6;
              Dlazdice[GetCisloDlazdice(Item[I].X,Item[I].Y+8)].Typ:=I+6;
              Dlazdice[GetCisloDlazdice(Item[I].X+8,Item[I].Y+8)].Typ:=I+6;
              If Item[I].Y=Bonus.Item[I].MinY*8 then Bonus.Item[I].Go:=False;
            End;
        End;
      End; {End If Item[I].Sebrany=False}
    End; {End For I:=0 to 5 do}
  End; {End If Bonus.Round=True}


  {ITEM 0 test sebrani}
  If (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+8)].Typ=6) and
     (Item[0].Sebrany=False) then
  Begin
    Item[0].Sebrany:=True; Item[0].Pocitadlo:=0;
    Inc(Player.Score,250); PlaySound(2);
  End;
  If Item[0].Sebrany=True then If Item[0].Pocitadlo<20 then Inc(Item[0].Pocitadlo);

  {ITEM 1 test sebrani}
  If (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+8)].Typ=7) and
     (Item[1].Sebrany=False) then
  Begin
    Item[1].Sebrany:=True; Item[1].Pocitadlo:=0;
    Inc(Player.Score,500); PlaySound(2);
  End;
  If Item[1].Sebrany=True then If Item[1].Pocitadlo<20 then Inc(Item[1].Pocitadlo);

  {ITEM 2 test sebrani}
  If (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+8)].Typ=8) and
     (Item[2].Sebrany=False) then
  Begin
    Item[2].Sebrany:=True; Item[2].Pocitadlo:=0;
    Inc(Player.Score,1000); PlaySound(2);
  End;
  If Item[2].Sebrany=True then If Item[2].Pocitadlo<20 then Inc(Item[2].Pocitadlo);

  {ITEM 3 test sebrani}
  If (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+8)].Typ=9) and
     (Item[3].Sebrany=False) then
  Begin
    Item[3].Sebrany:=True; Item[3].Pocitadlo:=0;
    Inc(Player.Score,250); PlaySound(2);
  End;
  If Item[3].Sebrany=True then If Item[3].Pocitadlo<20 then Inc(Item[3].Pocitadlo);

  {ITEM 4 test sebrani}
  If (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+8)].Typ=10) and
     (Item[4].Sebrany=False) then
  Begin
    Item[4].Sebrany:=True; Item[4].Pocitadlo:=0;
    Inc(Player.Score,500); PlaySound(2);
  End;
  If Item[4].Sebrany=True then If Item[4].Pocitadlo<20 then Inc(Item[4].Pocitadlo);

  {ITEM 5 test sebrani}
  If (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+8)].Typ=11) and
     (Item[5].Sebrany=False) then
  Begin
    Item[5].Sebrany:=True; Item[5].Pocitadlo:=0;
    Inc(Player.Score,1000); PlaySound(2);
  End;
  If Item[5].Sebrany=True then If Item[5].Pocitadlo<20 then Inc(Item[5].Pocitadlo);

  {ITEM 6 test sebrani}
  If (Dlazdice[GetCisloDlazdice(Player.X+8,Player.Y+8)].Typ=12) and
     (Item[6].Sebrany=False) then
  Begin
    Item[6].Sebrany:=True; Item[6].Pocitadlo:=0;
    Inc(Player.Score,1500); PlaySound(2);
    Domecek.Otevreno:=True;
  End;
  If Item[6].Sebrany=True then If Item[6].Pocitadlo<20 then Inc(Item[6].Pocitadlo);


  {voda}
  If Voda.Sprite=0 then Begin
                          Inc(Voda.Pocitadlo);
                          If Voda.Pocitadlo=10 then
                            Begin Voda.Sprite:=1; Voda.Pocitadlo:=0; End;
                        End;
  If Voda.Sprite=1 then Begin
                          Inc(Voda.Pocitadlo);
                          If Voda.Pocitadlo=10 then
                            Begin Voda.Sprite:=0; Voda.Pocitadlo:=0; End;
                        End;

  {Vzducholod}
  If Vzducholod.Leta=True then
  Begin
    If Vzducholod.Going=True then Inc(Vzducholod.UhelInt)
                             else Dec(Vzducholod.UhelInt);

    If Vzducholod.X=277  then Vzducholod.Going:=False;
    If Vzducholod.X=10   then Vzducholod.Going:=True;

    Vzducholod.UhelRad:=0.01745*Vzducholod.UhelInt;
    Vzducholod.SinusY:=Sin(Vzducholod.UhelRad);
    Vzducholod.Y:=Round(Vzducholod.SinusY*Vzducholod.K+Vzducholod.P);

    If Vzducholod.Xct1<5  then Inc(Vzducholod.Xct1)
                          else Begin
                                 Vzducholod.Xct1:=0;
                                 If Vzducholod.Going=True then Inc(Vzducholod.X)
                                                          else Dec(Vzducholod.X);
                               End;

    If Vzducholod.Xct2<15  then Inc(Vzducholod.Xct2) else Vzducholod.Xct2:=0;
    If Vzducholod.Xct2 in [0..4]   then Vzducholod.Sprite:=1;
    If Vzducholod.Xct2 in [5..9]   then Vzducholod.Sprite:=2;
    If Vzducholod.Xct2 in [10..14] then Vzducholod.Sprite:=3;
  End;

  {ITEM KEY TEST LEVEL COMPLETE}
  If (Item[6].Sebrany=True) and
  (Player.X in [Domecek.X+8..Domecek.X+16]) and
  (Player.Y in [Domecek.Y+24..Domecek.Y+40]) then
  LevelCompleted:=True;

  {PLAYER DEATH TEST chyceny neprateli}
  For A:=0 to 2 do
  Begin
    If (Player.X+8 > Enemy[A].X) and (Player.X+8 < Enemy[A].X+16) and
       (Player.Y+8 > Enemy[A].Y) and (Player.Y+8 < Enemy[A].Y+16) then
    Begin
      PlaySound(3);
      Player.Smer:=4;
      Player.Mrtvy:=True;
      If Player.DeathPocitadlo=0 then Dec(Player.Zivoty);
      If Player.Zivoty=0 then
      Begin {game over}
        EndingPlay:=True;
        StartGame:=False;
      End;
    End;
  End;
  If Player.Mrtvy=True then
  Begin
    Player.Smer:=4;
    Inc(Player.DeathPocitadlo);
  End;

  {PLAYER DEATH TEST - Vzducholod}
  If (Player.X+8 > Vzducholod.X+3) and (Player.X+8 < Vzducholod.X+29) and
     (Player.Y+8 > Vzducholod.Y+3) and (Player.Y+8 < Vzducholod.Y+13) then
  Begin
    PlaySound(3);
    Player.Smer:=4;
    Player.Mrtvy:=True;
    If Player.DeathPocitadlo=0 then Dec(Player.Zivoty);
    If Player.Zivoty=0 then
    Begin {game over}
      EndingPlay:=True;
      StartGame:=False;
    End;
  End;

  {ubihani casu}
  If FPS2s=True then Begin {prvni vterina}
                       If Cas.Bool=False then
                       Begin Cas.Bool:=True; Dec(Cas.CT); End;
                     End
                else Begin {druha vterina}
                       If Cas.Bool=True then
                       Begin Cas.Bool:=False; Dec(Cas.CT); End;
                     End;

  Cas.Minuty:=Trunc(Cas.CT/60);
  Cas.Vteriny:=Cas.CT-(Cas.Minuty*60);
  If Cas.CT=0 then
  Begin
    Player.Mrtvy:=True;
    Dec(Player.Zivoty);
  End;
  If (Player.Zivoty=0) and (Cas.CT=0) then
  Begin {game over}
    EndingPlay:=True;
    StartGame:=False;
  End;

End;


Procedure FramePohybEnemy;
Begin
  {enemy}
  If Enemy[A].Pad=False then
  If (Enemy[A].RightPressed=True) or (Enemy[A].LeftPressed=True) or
     (Enemy[A].UpPressed=True) or (Enemy[A].DownPressed=True) then
  Begin
    If Enemy[A].Sprite=1 then Begin
                           Inc(Enemy[A].Pocitadlo); If Enemy[A].Pocitadlo>10 then
                           Begin Enemy[A].Sprite:=2; Enemy[A].Pocitadlo:=0; End;
                           End;
    If Enemy[A].Sprite=2 then Begin
                           Inc(Enemy[A].Pocitadlo); If Enemy[A].Pocitadlo>10 then
                           Begin Enemy[A].Sprite:=1; Enemy[A].Pocitadlo:=0; End;
                           End;
  End;

  {enemy stop akcelerace}
  If (Enemy[A].LeftPressed=False) and (Enemy[A].RightPressed=False) and
     (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) and (Enemy[A].Pad=False) then
  Begin
    Enemy[A].PWRLeft:=0;
    Enemy[A].PWRRight:=0;
  End;

  {enemy gravitace}
  If (Dlazdice[GetCisloDlazdice(Enemy[A].X+13,Enemy[A].Y+15)].Typ<>5) and
     (Dlazdice[GetCisloDlazdice(Enemy[A].X+13,Enemy[A].Y+16)].Vyska=0) and
     (Dlazdice[GetCisloDlazdice(Enemy[A].X+13,Enemy[A].Y+8)].Typ<>2) and
     (Dlazdice[GetCisloDlazdice(Enemy[A].X+2,Enemy[A].Y+16)].Typ<>5) and
     (Dlazdice[GetCisloDlazdice(Enemy[A].X+2,Enemy[A].Y+16)].Vyska=0) and
     (Dlazdice[GetCisloDlazdice(Enemy[A].X+2,Enemy[A].Y+8)].Typ<>2) then
  Begin {falldown}
    If (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) then
    Begin
      Enemy[A].Pad:=True;
      If Enemy[A].Y<183 then Inc(Enemy[A].Y);
      If Enemy[A].PWRDown<50 then Inc(Enemy[A].PWRDown);
      If Enemy[A].PWRDown=50 then
      If Enemy[A].Nausea=False then Enemy[A].Nausea:=True;
    End;
  End else
  Begin {not fall down}
    If Enemy[A].PWRDown=50 then Enemy[A].Nausea:=True;
    Enemy[A].Pad:=False;
    Enemy[A].PWRDown:=0;
    Enemy[A].LogY:=Enemy[A].Y;
  End;

  {enemy falldown akcelerace X}
  If Enemy[A].Pad=True then
  Case Enemy[A].Smer of
    1: Begin {doprava}
         If Enemy[A].PWRRight in [3..8] then
         Begin
           If Dlazdice[GetCisloDlazdice(Enemy[A].X+16,Enemy[A].Y+15)].Vyska=0 then
           Begin {pad doprava volny}
             If Enemy[A].X<303 then Begin
                                      Inc(Enemy[A].PWRRPocitadlo);
                                      If Enemy[A].PWRRPocitadlo=2 then
                                      Begin
                                        Inc(Enemy[A].X);
                                        Enemy[A].PWRRPocitadlo:=0;
                                      End;
                                    End
                               else Enemy[A].X:=0;
           End;
         End;
         If Enemy[A].PWRRight in [9..10] then
         Begin
           If Dlazdice[GetCisloDlazdice(Enemy[A].X+16,Enemy[A].Y+15)].Vyska=0 then
           Begin {pad doprava volny}
             If Enemy[A].X<303 then Inc(Enemy[A].X) else Enemy[A].X:=0;
           End;
         End;
       End; {1 End doprava}
    2: Begin {doleva}
         If Enemy[A].PWRLeft in [3..8] then
         Begin
           If Dlazdice[GetCisloDlazdice(Enemy[A].X,Enemy[A].Y+15)].Vyska=0 then
           Begin {pad doleva volny}
             If Enemy[A].X>0 then Begin
                                    Inc(Enemy[A].PWRLPocitadlo);
                                    If Enemy[A].PWRLPocitadlo=2 then
                                    Begin
                                      Dec(Enemy[A].X);
                                      Enemy[A].PWRLPocitadlo:=0;
                                    End;
                                  End
                             else Enemy[A].X:=303;
           End;
         End;
         If Enemy[A].PWRLeft in [9..10] then
         Begin
           If Dlazdice[GetCisloDlazdice(Enemy[A].X,Enemy[A].Y+15)].Vyska=0 then
           Begin {pad doleva volny}
             If Enemy[A].X>0 then Dec(Enemy[A].X) else Enemy[A].X:=303;
           End;
         End;
       End; {2 End doleva}
  End; {Case End}

  {enemy pad do vody}
  If (Enemy[A].Splouch.Je=False) and (Enemy[A].Vykreslovat=True) and (Enemy[A].Mrtvy=False) then
  If Dlazdice[GetCisloDlazdice(Enemy[A].X+8,Enemy[A].Y+16)].Typ=5 then
  Begin {panak je ve vode}
    PlaySound(4);
    Enemy[A].Splouch.Je:=True;
    Enemy[A].Vykreslovat:=False;
    Enemy[A].Mrtvy:=True;
  End;

  {enemy splouch}
  If Enemy[A].Splouch.Je=True then Begin
                                  Inc(Enemy[A].Splouch.Pocitadlo);
                                  If Enemy[A].Splouch.Pocitadlo=50 then
                                  Begin {enemy over}
                                    Enemy[A].Splouch.Pocitadlo:=0;
                                    Enemy[A].Splouch.Je:=False;
                                  End;
                                End;
  {enemy skok}
  If Enemy[A].Skok=True then
  Begin
    Inc(Enemy[A].EnemySkok.Pocitadlo);
    Case Enemy[A].Smer of
     1: Begin {skok doprava}
          If Enemy[A].EnemySkok.Pocitadlo<16 then
          Begin
            If Enemy[A].PWRRight=0 then
            Begin {skok na miste}
            End;
            If Enemy[A].PWRRight in [3..8] then
            Begin {maly skok}
              If Enemy[A].X<303 then Begin
                                       Inc(Enemy[A].PWRRPocitadlo);
                                       If Enemy[A].PWRRPocitadlo=2 then
                                       Begin
                                         Inc(Enemy[A].X);
                                         Enemy[A].PWRRPocitadlo:=0;
                                       End;
                                     End
                                else Enemy[A].X:=0;
            End;
            If Enemy[A].PWRRight in [9..10] then
            Begin {velky skok}
              If Enemy[A].X<303 then Inc(Enemy[A].X) else Enemy[A].X:=0;
            End;
            Dec(Enemy[A].Y)
          End;
        End;
     2: Begin {skok doleva}
          If Enemy[A].EnemySkok.Pocitadlo<16 then
          Begin
            If Enemy[A].PWRLeft=0 then
            Begin {skok na miste}
            End;
            If Enemy[A].PWRLeft in [3..8] then
            Begin {maly skok}
              If Enemy[A].X>0 then Begin
                                     Inc(Enemy[A].PWRLPocitadlo);
                                     If Enemy[A].PWRLPocitadlo=2 then
                                     Begin
                                       Dec(Enemy[A].X);
                                       Enemy[A].PWRLPocitadlo:=0;
                                     End;
                                   End
                              else Enemy[A].X:=303;
            End;
            If Enemy[A].PWRLeft in [9..10] then
            Begin {velky skok}
              If Enemy[A].X>0 then Dec(Enemy[A].X) else Enemy[A].X:=303;
            End;
            Dec(Enemy[A].Y)
          End;
        End;
     3: Begin {skok zady k obrazovce}
          If Enemy[A].EnemySkok.Pocitadlo<16 then Dec(Enemy[A].Y);
        End;
     4: Begin {skok s pohledem na obrazovku}
          If Enemy[A].EnemySkok.Pocitadlo<16 then Dec(Enemy[A].Y);
        End;
    End; {Case End}

    If Enemy[A].EnemySkok.Pocitadlo in [16..24] then {vrchol skoku}
    Begin
    Case Enemy[A].Smer of
     1: Begin {skok doprava}
          If Enemy[A].PWRRight=0 then
          Begin {skok na miste}
          End;
          If Enemy[A].PWRRight in [3..8] then
          Begin {maly skok}
            If Enemy[A].X<303 then Begin
                                     Inc(Enemy[A].PWRRPocitadlo);
                                     If Enemy[A].PWRRPocitadlo=2 then
                                     Begin
                                       Inc(Enemy[A].X);
                                       Enemy[A].PWRRPocitadlo:=0;
                                     End;
                                   End
                              else Enemy[A].X:=0;
          End;
          If Enemy[A].PWRRight in [9..10] then
          Begin {velky skok}
            If Enemy[A].X<303 then Inc(Enemy[A].X) else Enemy[A].X:=0;
          End;
        End;
     2: Begin {skok doleva}
          If Enemy[A].PWRLeft=0 then
          Begin {skok na miste}
          End;
          If Enemy[A].PWRLeft in [3..8] then
          Begin {maly skok}
            If Enemy[A].X>0 then Begin
                                   Inc(Enemy[A].PWRLPocitadlo);
                                   If Enemy[A].PWRLPocitadlo=2 then
                                   Begin
                                     Dec(Enemy[A].X);
                                     Enemy[A].PWRLPocitadlo:=0;
                                   End;
                                 End
                            else Enemy[A].X:=303;
          End;
          If Enemy[A].PWRLeft in [9..10] then
          Begin {velky skok}
             If Enemy[A].X>0 then Dec(Enemy[A].X) else Enemy[A].X:=303;
          End;
        End;
     3: Begin End; {skok zady k obrazovce}
     4: Begin End; {skok s pohledem na obrazovku}

      End{Case End}
    End;

    If Enemy[A].EnemySkok.Pocitadlo=25 then {konec skoku}
    Begin
      Enemy[A].EnemySkok.Pocitadlo:=0;
      Enemy[A].Skok:=False;
      Enemy[A].Pad:=True;
    End;
  End; {End Skok=True}

  {enemy skok 2 - ODPEROVATKOVY SKOK}
  If Enemy[A].Skok2=True then
  Begin
    Inc(Enemy[A].EnemySkok2.Pocitadlo);
    Case Enemy[A].Smer of
     1: Begin {skok doprava}
          If Enemy[A].EnemySkok2.Pocitadlo<30 then
          Begin
            If Enemy[A].PWRRight=0 then
            Begin {skok na miste}
            End;
            If Enemy[A].PWRRight in [3..8] then
            Begin {maly skok}
              If Enemy[A].X<303 then Begin
                                       Inc(Enemy[A].PWRRPocitadlo);
                                       If Enemy[A].PWRRPocitadlo=2 then
                                       Begin
                                         Inc(Enemy[A].X);
                                         Enemy[A].PWRRPocitadlo:=0;
                                       End;
                                     End
                                else Enemy[A].X:=0;
            End;
            If Enemy[A].PWRRight in [9..10] then
            Begin {velky skok}
              If Enemy[A].X<303 then Inc(Enemy[A].X) else Enemy[A].X:=0;
            End;
            Dec(Enemy[A].Y)
          End;
        End;
     2: Begin {skok doleva}
          If Enemy[A].EnemySkok2.Pocitadlo<30 then
          Begin
            If Enemy[A].PWRLeft=0 then
            Begin {skok na miste}
            End;
            If Enemy[A].PWRLeft in [3..8] then
            Begin {maly skok}
              If Enemy[A].X>0 then Begin
                                     Inc(Enemy[A].PWRLPocitadlo);
                                     If Enemy[A].PWRLPocitadlo=2 then
                                     Begin
                                       Dec(Enemy[A].X);
                                       Enemy[A].PWRLPocitadlo:=0;
                                     End;
                                   End
                              else Enemy[A].X:=303;
            End;
            If Enemy[A].PWRLeft in [9..10] then
            Begin {velky skok}
              If Enemy[A].X>0 then Dec(Enemy[A].X) else Enemy[A].X:=303;
            End;
            Dec(Enemy[A].Y)
          End;
        End;
     3: Begin {skok zady k obrazovce}
          If Enemy[A].EnemySkok2.Pocitadlo<30 then Dec(Enemy[A].Y);
        End;
     4: Begin {skok s pohledem na obrazovku}
          If Enemy[A].EnemySkok2.Pocitadlo<30 then Dec(Enemy[A].Y);
        End;
    End; {Case End}

    If Enemy[A].EnemySkok2.Pocitadlo in [31..39] then {vrchol skoku}
    Begin
    Case Enemy[A].Smer of
     1: Begin {skok doprava}
          If Enemy[A].PWRRight=0 then
          Begin {skok na miste}
          End;
          If Enemy[A].PWRRight in [3..8] then
          Begin {maly skok}
            If Enemy[A].X<303 then Begin
                                     Inc(Enemy[A].PWRRPocitadlo);
                                     If Enemy[A].PWRRPocitadlo=2 then
                                     Begin
                                       Inc(Enemy[A].X);
                                       Enemy[A].PWRRPocitadlo:=0;
                                     End;
                                   End
                              else Enemy[A].X:=0;
          End;
          If Enemy[A].PWRRight in [9..10] then
          Begin {velky skok}
            If Enemy[A].X<303 then Inc(Enemy[A].X) else Enemy[A].X:=0;
          End;
        End;
     2: Begin {skok doleva}
          If Enemy[A].PWRLeft=0 then
          Begin {skok na miste}
          End;
          If Enemy[A].PWRLeft in [3..8] then
          Begin {maly skok}
            If Enemy[A].X>0 then Begin
                                   Inc(Enemy[A].PWRLPocitadlo);
                                   If Enemy[A].PWRLPocitadlo=2 then
                                   Begin
                                     Dec(Enemy[A].X);
                                     Enemy[A].PWRLPocitadlo:=0;
                                   End;
                                 End
                            else Enemy[A].X:=303;
          End;
          If Enemy[A].PWRLeft in [9..10] then
          Begin {velky skok}
             If Enemy[A].X>0 then Dec(Enemy[A].X) else Enemy[A].X:=303;
          End;
        End;
     3: Begin End; {skok zady k obrazovce}
     4: Begin End; {skok s pohledem na obrazovku}
      End{Case End}
    End;

    If Enemy[A].EnemySkok2.Pocitadlo=40 then {konec skoku}
    Begin
      Enemy[A].EnemySkok2.Pocitadlo:=0;
      Enemy[A].Skok2:=False;
      Enemy[A].Pad:=True;
    End;
  End; {End Skok=True}

  {enemy odperovatko}
  If ((Dlazdice[GetCisloDlazdice(Enemy[A].X+1,Enemy[A].Y+16)].Typ=4) or
     (Dlazdice[GetCisloDlazdice(Enemy[A].X+14,Enemy[A].Y+16)].Typ=4)) and
     (Enemy[A].PWRDown>10) and (Enemy[A].Skok=False) then
     Begin Odperovatko.Activ:=True; PlaySound(1); End;

  {enemy skok na odperovatku}
  If ((Dlazdice[GetCisloDlazdice(Enemy[A].X+1,Enemy[A].Y+8)].Typ=4) or
      (Dlazdice[GetCisloDlazdice(Enemy[A].X+1,Enemy[A].Y+16)].Typ=4) or
      (Dlazdice[GetCisloDlazdice(Enemy[A].X+1,Enemy[A].Y+24)].Typ=4) or
      (Dlazdice[GetCisloDlazdice(Enemy[A].X+14,Enemy[A].Y+8)].Typ=4) or
      (Dlazdice[GetCisloDlazdice(Enemy[A].X+14,Enemy[A].Y+16)].Typ=4) or
      (Dlazdice[GetCisloDlazdice(Enemy[A].X+14,Enemy[A].Y+24)].Typ=4)) and
      (Odperovatko.Activ=True) and (Enemy[A].Skok=False) then
    Begin
      If Odperovatko.MEM=False then
      Begin
        Odperovatko.Power:=Enemy[A].PWRDown;
        Odperovatko.MEM:=True;
      End;
      Inc(Odperovatko.Pocitadlo);
      If Odperovatko.Pocitadlo in [0..4] then
      Begin {odperovatko klesa 1}
        Odperovatko.Sprite:=2;
        Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Vyska:=0;
        Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Typ:=0;
        Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Vyska:=0;
        Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Typ:=0;
      End;
      If Odperovatko.Pocitadlo in [5..9] then
      Begin {odperovatko klesa 2}
        Odperovatko.Sprite:=3;
      End;
      If Odperovatko.Pocitadlo in [10..11] then
      Begin {odperovatko stoupa 1}
        Odperovatko.Sprite:=2;
        Dec(Enemy[A].Y,4);
      End;
      If Odperovatko.Pocitadlo=12 then
      Begin {odperovatko stoupa 2}
        Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Vyska:=1;
        Dlazdice[GetCisloDlazdice(Odperovatko.X,Odperovatko.Y)].Typ:=4;
        Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Vyska:=1;
        Dlazdice[GetCisloDlazdice(Odperovatko.X+8,Odperovatko.Y)].Typ:=4;
        Odperovatko.Sprite:=1;
        Odperovatko.Pocitadlo:=0;
        Odperovatko.Activ:=False;
        If Odperovatko.Power<35 then Enemy[A].Skok:=True
                                else Enemy[A].Skok2:=True;
      End;
    End;
  {odperovatko ready}
  If Odperovatko.Activ=False then
  Begin
    Odperovatko.Power:=0;
    Odperovatko.MEM:=False;
    Odperovatko.Pocitadlo:=0;
    Odperovatko.Sprite:=1;
  End;
End;


Procedure KresliFrame;
Var I: Byte;
    X,Y: Word;
Begin
  {pozadi}
  FlipPage(Buffer[2],Buffer[3]);
  {domecek}
  WriteSprite(Domecek.X,Domecek.Y,0,32,31,71,Buffer[1],Buffer[3]);
  If Domecek.Otevreno=False then WriteSprite(Domecek.X+8,Domecek.Y+24,32,56,47,71,Buffer[1],Buffer[3])
                            else WriteSprite(Domecek.X+8,Domecek.Y+24,32,40,47,55,Buffer[1],Buffer[3]);
  {cas}
  Ramecek(300,0,319,8,50,Buffer[3]);
  Blok(301,1,318,7,15,Buffer[3]);
  OutNumber(302,2,Cas.Minuty,True,Buffer[3]);
  WritePixel(307,3,50,Buffer[3]);
  WritePixel(307,5,50,Buffer[3]);
  If Cas.Vteriny>9 then OutNumber(309,2,Cas.Vteriny,True,Buffer[3])
                   else Begin
                          OutNumber(309,2,0,True,Buffer[3]);
                          OutNumber(314,2,Cas.Vteriny,True,Buffer[3]);
                        End;

  {score total}
  Ramecek(0,0,32,8,50,Buffer[3]);
  Blok(1,1,31,7,15,Buffer[3]);
  OutNumber(2,2,Player.ScoreTotal,True,Buffer[3]);

  {level score}
  Ramecek(34,0,56,8,50,Buffer[3]);
  Blok(35,1,55,7,15,Buffer[3]);
  OutNumber(36,2,Player.Score,True,Buffer[3]);

  {player left right down Power}
  Ramecek(134,0,146,8,50,Buffer[3]);
  Blok(135,1,145,7,15,Buffer[3]);
  OutNumber(136,2,Player.PWRLeft,True,Buffer[3]);
  Ramecek(148,0,160,8,50,Buffer[3]);
  Blok(149,1,159,7,15,Buffer[3]);
  OutNumber(150,2,Player.PWRDown,True,Buffer[3]);
  Ramecek(162,0,174,8,50,Buffer[3]);
  Blok(163,1,173,7,15,Buffer[3]);
  OutNumber(164,2,Player.PWRRight,True,Buffer[3]);

  {zivoty}
  If Player.Zivoty>1 then
  Begin
    X:=302; Y:=10;
    For I:=1 to Player.Zivoty-1 do
    Begin
      WriteSprite(X,Y,120,16,127,23,Buffer[1],Buffer[3]);
      Inc(X,9);
    End;
  End;

  {odperovatko}
  Case Odperovatko.Sprite of
    1: WriteSprite(Odperovatko.X,Odperovatko.Y,80,0,95,15,Buffer[1],Buffer[3]);
    2: WriteSprite(Odperovatko.X,Odperovatko.Y,96,0,111,15,Buffer[1],Buffer[3]);
    3: WriteSprite(Odperovatko.X,Odperovatko.Y+8,112,8,127,15,Buffer[1],Buffer[3]);
  End; {Case End}

  {Itemy}
  If Item[0].Sebrany=False then WriteSprite(Item[0].X,Item[0].Y,144,0,159,15,Buffer[1],Buffer[3]);
  If Item[1].Sebrany=False then WriteSprite(Item[1].X,Item[1].Y,128,0,143,15,Buffer[1],Buffer[3]);
  If Item[2].Sebrany=False then WriteSprite(Item[2].X,Item[2].Y,128,16,143,31,Buffer[1],Buffer[3]);
  If Item[3].Sebrany=False then WriteSprite(Item[3].X,Item[3].Y,144,0,159,15,Buffer[1],Buffer[3]);
  If Item[4].Sebrany=False then WriteSprite(Item[4].X,Item[4].Y,128,0,143,15,Buffer[1],Buffer[3]);
  If Item[5].Sebrany=False then WriteSprite(Item[5].X,Item[5].Y,128,16,143,31,Buffer[1],Buffer[3]);
  If Item[6].Sebrany=False then WriteSprite(Item[6].X,Item[6].Y,144,16,159,31,Buffer[1],Buffer[3]);

  {Item 0 SCORE}
  If Item[0].Sebrany=True then
  Begin
    If Item[0].Pocitadlo<20 then
    Begin WriteSprite(Item[0].X,Item[0].Y,80,24,95,31,Buffer[1],Buffer[3]); Dec(Item[0].Y); End;
  End;

  {Item 1 SCORE}
  If Item[1].Sebrany=True then
  Begin
    If Item[1].Pocitadlo<20 then
    Begin WriteSprite(Item[1].X,Item[1].Y,80,16,95,23,Buffer[1],Buffer[3]); Dec(Item[1].Y); End;
  End;

  {Item 2 SCORE}
  If Item[2].Sebrany=True then
  Begin
    If Item[2].Pocitadlo<20 then
    Begin WriteSprite(Item[2].X,Item[2].Y,96,16,115,23,Buffer[1],Buffer[3]); Dec(Item[2].Y); End;
  End;

  {Item 3 SCORE}
  If Item[3].Sebrany=True then
  Begin
    If Item[3].Pocitadlo<20 then
    Begin WriteSprite(Item[3].X,Item[3].Y,80,24,95,31,Buffer[1],Buffer[3]); Dec(Item[3].Y); End;
  End;

  {Item 4 SCORE}
  If Item[4].Sebrany=True then
  Begin
    If Item[4].Pocitadlo<20 then
    Begin WriteSprite(Item[4].X,Item[4].Y,80,16,95,23,Buffer[1],Buffer[3]); Dec(Item[4].Y); End;
  End;

  {Item 5 SCORE}
  If Item[5].Sebrany=True then
  Begin
    If Item[5].Pocitadlo<20 then
    Begin WriteSprite(Item[5].X,Item[5].Y,96,16,115,23,Buffer[1],Buffer[3]); Dec(Item[5].Y); End;
  End;

  {Item 6 SCORE}
  If Item[6].Sebrany=True then
  Begin
    If Item[6].Pocitadlo<20 then
    Begin WriteSprite(Item[6].X,Item[6].Y,96,24,115,31,Buffer[1],Buffer[3]); Dec(Item[6].Y); End;
  End;


  For A:=0 to 2 do
  Begin
  {enemy}
    If (Enemy[A].Vykreslovat=True) and (Enemy[A].Skok=False) and (Enemy[A].Skok2=False) and (Enemy[A].Nausea=False) then
    Case Enemy[A].Smer of
      1: Begin {doprava}
           If Enemy[A].Sprite=1 then WriteSprite(Enemy[A].X,Enemy[A].Y,112,32,127,47,Buffer[1],Buffer[3]);
           If Enemy[A].Sprite=2 then WriteSprite(Enemy[A].X,Enemy[A].Y,128,32,143,47,Buffer[1],Buffer[3]);
         End;
      2: Begin {doleva}
           If Enemy[A].Sprite=1 then WriteSprite(Enemy[A].X,Enemy[A].Y,112,132,127,147,Buffer[1],Buffer[3]);
           If Enemy[A].Sprite=2 then WriteSprite(Enemy[A].X,Enemy[A].Y,128,132,143,147,Buffer[1],Buffer[3]);
         End;
      3: Begin {nahoru}
           If Enemy[A].Sprite=1 then WriteSprite(Enemy[A].X,Enemy[A].Y,96,32,111,47,Buffer[1],Buffer[3]);
           If Enemy[A].Sprite=2 then WriteSprite(Enemy[A].X,Enemy[A].Y,96,132,111,147,Buffer[1],Buffer[3]);
         End;
      4: Begin {dolu}
           If Enemy[A].Sprite=1 then WriteSprite(Enemy[A].X,Enemy[A].Y,80,32,95,47,Buffer[1],Buffer[3]);
           If Enemy[A].Sprite=2 then WriteSprite(Enemy[A].X,Enemy[A].Y,80,132,95,147,Buffer[1],Buffer[3]);
         End;
    End;{Case End}

  {enemy skok}
    If (Enemy[A].Vykreslovat=True) and ((Enemy[A].Skok=True) or (Enemy[A].Skok2=True)) and (Enemy[A].Nausea=False) then
    Begin
      If Enemy[A].Smer=1 then WriteSprite(Enemy[A].X,Enemy[A].Y,144,32,159,47,Buffer[1],Buffer[3]);
      If Enemy[A].Smer=2 then WriteSprite(Enemy[A].X,Enemy[A].Y,144,132,159,147,Buffer[1],Buffer[3]);
      If Enemy[A].Smer=3 then WriteSprite(Enemy[A].X,Enemy[A].Y,96,32,111,47,Buffer[1],Buffer[3]);
      If Enemy[A].Smer=4 then WriteSprite(Enemy[A].X,Enemy[A].Y,80,32,95,47,Buffer[1],Buffer[3]);
    End;

  {enemy oblbly nause True}
    If (Enemy[A].Vykreslovat=True) and (Enemy[A].Nausea=True) and
    (Enemy[A].Splouch.Je=False) then WriteSprite(Enemy[A].X,Enemy[A].Y,80,48,95,63,Buffer[1],Buffer[3]);

  {enemy splouch}
    If Enemy[A].Splouch.Je=True then
    Begin
      x:=Enemy[A].X+8;
      y:=Enemy[A].Y+8;
      If Enemy[A].Splouch.Pocitadlo in [0..9] then
      Begin WriteSprite(x,y,32,16,39,23,Buffer[1],Buffer[3]);
            WriteSprite(x-10,y,0,150,7,157,Buffer[1],Buffer[3]);
            WriteSprite(x+10,y,40,16,47,23,Buffer[1],Buffer[3]); End;
      If Enemy[A].Splouch.Pocitadlo in [10..19] then
      Begin WriteSprite(x,y-1,32,16,39,23,Buffer[1],Buffer[3]);
            WriteSprite(x-11,y-1,0,150,7,157,Buffer[1],Buffer[3]);
            WriteSprite(x+11,y-1,40,16,47,23,Buffer[1],Buffer[3]); End;
      If Enemy[A].Splouch.Pocitadlo in [20..29] then
      Begin WriteSprite(x,y-2,32,16,39,23,Buffer[1],Buffer[3]);
            WriteSprite(x-12,y-2,0,150,7,157,Buffer[1],Buffer[3]);
            WriteSprite(x+12,y-2,40,16,47,23,Buffer[1],Buffer[3]); End;
      If Enemy[A].Splouch.Pocitadlo in [30..39] then
      Begin WriteSprite(x,y-3,32,16,39,23,Buffer[1],Buffer[3]);
            WriteSprite(x-13,y-3,0,150,7,157,Buffer[1],Buffer[3]);
            WriteSprite(x+13,y-3,40,16,47,23,Buffer[1],Buffer[3]); End;
      If Enemy[A].Splouch.Pocitadlo in [40..50] then
      Begin WriteSprite(x,y-4,32,16,39,23,Buffer[1],Buffer[3]);
            WriteSprite(x-14,y-4,0,150,7,157,Buffer[1],Buffer[3]);
            WriteSprite(x+14,y-4,40,16,47,23,Buffer[1],Buffer[3]); End;
    End; {Enemy.Splouch.Je=True End}
  End;

  {player}
  If (Player.Vykreslovat=True) and (Player.Skok=False) and (Player.Nausea=False) then
  Case Player.Smer of
    1: Begin {doprava}
         If Player.Sprite=1 then WriteSprite(Player.X,Player.Y,32,0,47,15,Buffer[1],Buffer[3]);
         If Player.Sprite=2 then WriteSprite(Player.X,Player.Y,48,0,63,15,Buffer[1],Buffer[3]);
       End;
    2: Begin {doleva}
         If Player.Sprite=1 then WriteSprite(Player.X,Player.Y,32,100,47,115,Buffer[1],Buffer[3]);
         If Player.Sprite=2 then WriteSprite(Player.X,Player.Y,48,100,63,115,Buffer[1],Buffer[3]);
       End;
    3: Begin {nahoru}
         If Player.Sprite=1 then WriteSprite(Player.X,Player.Y,16,0,31,15,Buffer[1],Buffer[3]);
         If Player.Sprite=2 then WriteSprite(Player.X,Player.Y,16,100,31,115,Buffer[1],Buffer[3]);
       End;
    4: Begin {dolu}
         If Player.Sprite=1 then WriteSprite(Player.X,Player.Y,0,0,15,15,Buffer[1],Buffer[3]);
         If Player.Sprite=2 then WriteSprite(Player.X,Player.Y,0,100,15,115,Buffer[1],Buffer[3]);
       End;
  End;{Case End}

  {player skok}
  If (Player.Vykreslovat=True) and (Player.Skok=True) and (Player.Nausea=False) and (Player.Mrtvy=False) then
  Begin
    If Player.Smer=1 then WriteSprite(Player.X,Player.Y,64,0,79,15,Buffer[1],Buffer[3]);
    If Player.Smer=2 then WriteSprite(Player.X,Player.Y,64,100,79,115,Buffer[1],Buffer[3]);
    If Player.Smer=3 then WriteSprite(Player.X,Player.Y,16,100,31,115,Buffer[1],Buffer[3]);
    If Player.Smer=4 then WriteSprite(Player.X,Player.Y,0,100,15,115,Buffer[1],Buffer[3]);
  End;

  {smrt ve skoku}
  If (Player.Skok=True) and (Player.Nausea=False) and (Player.Mrtvy=True) then
  WriteSprite(Player.X,Player.Y,0,0,15,15,Buffer[1],Buffer[3]);

  {player oblbly nause True}
  If (Player.Nausea=True) and (Player.Splouch.Je=False) then
  WriteSprite(Player.X,Player.Y,56,48,71,63,Buffer[1],Buffer[3]);

  {player splouch}
  If Player.Splouch.Je=True then
  Begin
    x:=Player.X+8;
    y:=Player.Y+8;
    If Player.Splouch.Pocitadlo in [0..9] then
    Begin WriteSprite(x,y,32,16,39,23,Buffer[1],Buffer[3]);
          WriteSprite(x-10,y,0,150,7,157,Buffer[1],Buffer[3]);
          WriteSprite(x+10,y,40,16,47,23,Buffer[1],Buffer[3]); End;
    If Player.Splouch.Pocitadlo in [10..19] then
    Begin WriteSprite(x,y-1,32,16,39,23,Buffer[1],Buffer[3]);
          WriteSprite(x-11,y-1,0,150,7,157,Buffer[1],Buffer[3]);
          WriteSprite(x+11,y-1,40,16,47,23,Buffer[1],Buffer[3]); End;
    If Player.Splouch.Pocitadlo in [20..29] then
    Begin WriteSprite(x,y-2,32,16,39,23,Buffer[1],Buffer[3]);
          WriteSprite(x-12,y-2,0,150,7,157,Buffer[1],Buffer[3]);
          WriteSprite(x+12,y-2,40,16,47,23,Buffer[1],Buffer[3]); End;
    If Player.Splouch.Pocitadlo in [30..39] then
    Begin WriteSprite(x,y-3,32,16,39,23,Buffer[1],Buffer[3]);
          WriteSprite(x-13,y-3,0,150,7,157,Buffer[1],Buffer[3]);
          WriteSprite(x+13,y-3,40,16,47,23,Buffer[1],Buffer[3]); End;
    If Player.Splouch.Pocitadlo in [40..50] then
    Begin WriteSprite(x,y-4,32,16,39,23,Buffer[1],Buffer[3]);
          WriteSprite(x-14,y-4,0,150,7,157,Buffer[1],Buffer[3]);
          WriteSprite(x+14,y-4,40,16,47,23,Buffer[1],Buffer[3]); End;
  End; {Player.Splouch.Je=True End}

  {Vzducholod}
  If Vzducholod.Leta=True then
  Begin
    If Vzducholod.Going=True then
    Begin {leti doprava}
      WriteSprite(Vzducholod.X,Vzducholod.Y,56,32,79,47,Buffer[1],Buffer[3]);
      Case Vzducholod.Sprite of
        1: WriteSprite(Vzducholod.X-8,Vzducholod.Y,48,48,55,63,Buffer[1],Buffer[3]);
        2: WriteSprite(Vzducholod.X-8,Vzducholod.Y,48,32,55,47,Buffer[1],Buffer[3]);
        3: WriteSprite(Vzducholod.X-8,Vzducholod.Y+4,48,64,55,71,Buffer[1],Buffer[3]);
      End; {Case End}
    End else
    Begin {leti doleva}
      WriteSprite(Vzducholod.X,Vzducholod.Y,256,32,279,47,Buffer[1],Buffer[3]);
      Case Vzducholod.Sprite of
        1: WriteSprite(Vzducholod.X+24,Vzducholod.Y,248,48,255,63,Buffer[1],Buffer[3]);
        2: WriteSprite(Vzducholod.X+24,Vzducholod.Y,248,32,255,47,Buffer[1],Buffer[3]);
        3: WriteSprite(Vzducholod.X+24,Vzducholod.Y+4,248,64,255,71,Buffer[1],Buffer[3]);
      End; {Case End}
    End;
  End;

  {voda}
  If Voda.Sprite=0 then For I:=0 to 19 do WriteSprite(I*16,192,0,16,15,23,Buffer[1],Buffer[3])
                   else For I:=0 to 19 do WriteSprite(I*16,192,16,16,31,23,Buffer[1],Buffer[3]);

  {fps}
  If ShowFPS=True then
  Begin
    OutNumber(10,190,fps,True,Buffer[3]);
    OutNumber(35,190,frame,True,Buffer[3]);
    OutNumber(55,190,prodleva,True,Buffer[3]);
  End;

  {kreslime frame}
  If Vsync=True then WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure PocitejFPS;
Begin
  If FPS2s=True then Inc(frame) {je zrovna prvni vterina}
                else Begin      {je zrovna druha vterina}
                       If frame>0 then fps:=frame; {obnovit fps}
                       frame:=0; {vynulovat pocet napocitanych snimku}
                     End;

  If vSync=False then
  Begin
    trvani:=Stopky_GetNumber;
    If trvani>100
    then begin
           If prodleva>0 then Dec(prodleva);
         end
    else begin
           If prodleva<65535 then Inc(prodleva);
         end;
  End;
End;


Procedure ProcessLevel;
Begin
  Repeat
    Stopky_Start;
    NacitaniKlaves;                     {vstup od hrace}
    For A:=0 to 2 do UmelaInteligence1; {logika 1}
    For A:=0 to 2 do UmelaInteligence2; {logika 2}
    FramePohyb;                         {pohyb hrace}
    For A:=0 to 2 do FramePohybEnemy;   {pohyb enemy}
    KresliFrame;                        {frame na screen}
    Wait(prodleva);
    Stopky_Stop;
    PocitejFPS;
  Until (EndingPlay=True) or (EndingGame=True) or (LevelCompleted=True) or
     ((Player.Mrtvy=True) and (Player.Splouch.Pocitadlo=50)) or
     ((Player.Mrtvy=True) and (Cas.CT=0)) or
     ((Player.Mrtvy=True) and (Player.Deathpocitadlo=50)) or
     ((Player.Mrtvy=True) and (Player.Harakiri=True));
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXX GAME ENGINE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure ShowLevelStart(LevelNumber:Byte); {uvodni obrazovka levelu}
Begin
  ClearPage(Buffer[2]);
  Ramecek(0,0,319,199,50,Buffer[2]);
  OutText(125,90,'LEVEL',Buffer[2]);
  OutNumber(161,90,LevelNumber,False,Buffer[2]);
  OutText(110,105,'STISKNETE ENTER',Buffer[2]);
  WritePixel(145,103,50,Buffer[2]);
  WritePixel(146,103,50,Buffer[2]);
  WritePixel(147,103,50,Buffer[2]);
  WritePixel(146,104,50,Buffer[2]);
  If (LevelNumber=7) then
  Begin
    Ramecek(105,45,200,62,50,Buffer[2]);
    OutText(110,50,'! BONUS ROUND !',Buffer[2]);
  End;
  FlipPage(Buffer[2],Buffer[4]);
  Repeat
    If Key[28]=True then Begin StartLevel:=True; PlaySound(0); End;{ENTER=START}
  Until StartLevel=True;
End;


Procedure SSLframe;
Var X,Y,I: Word;
Begin
  ClearPage(Buffer[2]);
  Ramecek(0,0,319,199,50,Buffer[2]);
  If Skip=False then
  Begin Ramecek(8,8,44,20,50,Buffer[2]); OutText(10,10,'S=SKIP',Buffer[2]); End;
  X:=100; Y:=80;
  OutText(X+17,Y+5,'CAS:',Buffer[2]);
  OutNumber(X+40,Y+5,Cas.CT*10,False,Buffer[2]);
  WritePixel(X+18,Y+2,50,Buffer[2]);
  WritePixel(X+19,Y+2,50,Buffer[2]);
  WritePixel(X+20,Y+2,50,Buffer[2]);
  WritePixel(X+19,Y+3,50,Buffer[2]);

  OutText(X+5,Y+15,'OVOCE:',Buffer[2]);
  OutNumber(X+40,Y+15,Player.Score,False,Buffer[2]);

  Blok(X+5,Y+25,X+62,Y+25,50,Buffer[2]);
  OutText(X+5,Y+28,'TOTAL:',Buffer[2]);
  OutNumber(X+40,Y+28,Player.ScoreTotal,False,Buffer[2]);

  If Item[0].Sebrany=True then WriteSprite(X+80,Y,144,0,159,15,Buffer[1],Buffer[2]);
  If Item[1].Sebrany=True then WriteSprite(X+100,Y,128,0,143,15,Buffer[1],Buffer[2]);
  If Item[2].Sebrany=True then WriteSprite(X+120,Y,128,16,143,31,Buffer[1],Buffer[2]);
  If Item[3].Sebrany=True then WriteSprite(X+80,Y+20,144,0,159,15,Buffer[1],Buffer[2]);
  If Item[4].Sebrany=True then WriteSprite(X+100,Y+20,128,0,143,15,Buffer[1],Buffer[2]);
  If Item[5].Sebrany=True then WriteSprite(X+120,Y+20,128,16,143,31,Buffer[1],Buffer[2]);

  If (VyuctovaniScore=True) and (Player.Score=0) then
  Begin
    OutText(X+5,Y+40,'STISKNETE MEZERNIK',Buffer[2]);
    WritePixel(X+40,Y+38,50,Buffer[2]);
    WritePixel(X+41,Y+38,50,Buffer[2]);
    WritePixel(X+42,Y+38,50,Buffer[2]);
    WritePixel(X+41,Y+39,50,Buffer[2]);
    WritePixel(X+101,Y+38,50,Buffer[2]);
    WritePixel(X+100,Y+39,50,Buffer[2]);
  End;

  FlipPage(Buffer[2],Buffer[4]);

  If VyuctovaniCasu=True then
  If Cas.CT>0 then
  Begin
    PlaySound(5);
    Dec(Cas.CT);
    Inc(Player.ScoreTotal,10);
  End;
  If Cas.CT=0 then
  Begin
    VyuctovaniCasu:=False;
    VyuctovaniScore:=True;
  End;

  If VyuctovaniScore=True then
  If Player.Score>0 then
  Begin
    PlaySound(5);
    Dec(Player.Score,10);
    Inc(Player.ScoreTotal,10);
  End;

  If Skip=True then
  Begin
    Inc(Player.ScoreTotal,10*Cas.CT);
    Inc(Player.ScoreTotal,10*Trunc(Player.Score/10));
    Cas.CT:=0;
    Player.Score:=0;
    VyuctovaniScore:=True;
  End;
End;


Procedure ShowScoreList(LevelNumber:Byte); {jeden level dokonceny}
Begin
  VyuctovaniCasu:=True;
  VyuctovaniScore:=False;
  Skip:=False;
  Repeat
    SSLFrame;
    Wait(10);
{S} If Key[31]=True then Skip:=True;
  Until (Key[57]=True) and (VyuctovaniScore=True) and (Player.Score=0);
  PlaySound(0);
  If LevelNumber=PosledniLevel then GameCompleted:=True;
End;


Procedure WriteSCScreen;
Begin
  Ramecek(0,0,319,199,50,Buffer[2]);
  OutText(74,45,'! ! ! GRATULATIONS ! ! !',Buffer[2]);
  OutText(74,65,' ! ! ! GAME OVER ! ! !',Buffer[2]);
  OutText(104,85,'SCORE :',Buffer[2]);
  OutNumber(150,85,Player.ScoreTotal,False,Buffer[2]);
  OutText(104,135,'STISKNETE ENTER',Buffer[2]);
  WritePixel(139,133,50,Buffer[2]);
  WritePixel(140,133,50,Buffer[2]);
  WritePixel(141,133,50,Buffer[2]);
  WritePixel(140,134,50,Buffer[2]);
  GratzOver:=True;
End;


Procedure ShowCongratulations; {cela hra dokoncena}
Var I: Byte;
Begin
  GratzOver:=False;
  Repeat
    ClearPage(Buffer[2]);
    WriteSCScreen;
    If Vsync=True then Waitretrace;
    FlipPage(Buffer[2],Buffer[4]);
  Until (Key[28]=True) and (GratzOver=True);
  For I:=0 to 5 do
  Begin
    PlaySound(I);
    Wait(100);
  End;
  StartGame:=False;
End;


Procedure MainGame;
Begin
  CisloLevelu:=StartovaciLevel;
  Repeat
    ShowLevelStart(CisloLevelu);
    InitLevel(CisloLevelu);
    ProcessLevel; {frame engine}
    If (Player.Mrtvy=False) and (EndingPlay=False) then ShowScoreList(CisloLevelu);
    If Player.Mrtvy=False then If CisloLevelu<20 then Inc(CisloLevelu);
  Until (EndingPlay=True) or (EndingGame=True) or (GameCompleted=True);
  If GameCompleted=True then ShowCongratulations;
End;


{@@@@@@@@@@@@@@@@@@@@@@@@ UVODNI OBRAZOVKA HRY @@@@@@@@@@@@@@@@@@@@@@@@@@@@@}
Procedure WriteMMScreen;
Var X: Word;
    Y: Byte;
Begin
  ClearPage(Buffer[2]);
  Ramecek(0,0,319,199,50,Buffer[2]);
  Ramecek(0,0,128,65,50,Buffer[2]);
  OutText(5,5,'S=START',Buffer[2]);
  OutText(5,15,'ESC=EXIT',Buffer[2]);
  OutText(5,25,'SIPKY=POHYB',Buffer[2]);
  WritePixel(6,23,50,Buffer[2]);
  WritePixel(7,23,50,Buffer[2]);
  WritePixel(8,23,50,Buffer[2]);
  WritePixel(7,24,50,Buffer[2]);
  OutText(5,35,'MEZERNIK=SKOK',Buffer[2]);
  WritePixel(42,34,50,Buffer[2]);
  WritePixel(43,33,50,Buffer[2]);
  OutText(5,45,'BACKSPACE=SEBEVRAZDA',Buffer[2]);
  WritePixel(108,43,50,Buffer[2]);
  WritePixel(109,43,50,Buffer[2]);
  WritePixel(110,43,50,Buffer[2]);
  WritePixel(109,44,50,Buffer[2]);
  OutText(5,55,'F=FPS',Buffer[2]);

  WriteSprite(158,40,144,0,159,15,Buffer[1],Buffer[2]);
  WriteSprite(178,40,128,0,143,15,Buffer[1],Buffer[2]);
  WriteSprite(198,40,128,16,143,31,Buffer[1],Buffer[2]);
  WriteSprite(218,40,144,16,159,31,Buffer[1],Buffer[2]);
  WriteSprite(238,40,0,0,15,15,Buffer[1],Buffer[2]);
  OutNumber(140,190,Player.ScoreTotal,False,Buffer[2]);

  X:=Random(5)+20; Y:=Random(5)+110;
  {M}
  WriteBlok(X,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+8,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+16,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+24,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+32,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+32,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+32,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+32,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+32,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  {I}
  WriteBlok(X+48,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+48,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+48,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+48,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+48,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  {L}
  WriteBlok(X+64,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+64,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+64,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+64,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+64,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+72,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+80,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  {K}
  WriteBlok(X+96,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+96,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+96,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+96,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+96,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+112,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+112,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+104,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+112,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+112,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  {N}
  WriteBlok(X+128,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+128,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+128,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+128,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+128,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+136,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+142,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+150,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+150,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+150,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+150,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+150,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  {U}
  WriteBlok(X+166,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+166,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+166,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+166,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+174,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+182,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+190,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+190,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+190,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+190,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  {T}
  WriteBlok(X+206,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+214,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+222,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+214,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+214,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+214,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+214,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  {S}
  WriteBlok(X+238,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+246,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+254,Y,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+262,Y+8,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+254,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+246,Y+16,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+238,Y+24,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+246,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+254,Y+32,56,16,63,23,Buffer[1],Buffer[2]);
  WriteBlok(X+262,Y+32,56,16,63,23,Buffer[1],Buffer[2]);

  If ShowFPS=True then
  Begin
    OutNumber(10,190,MMfps,True,Buffer[2]);
    OutNumber(35,190,MMframe,True,Buffer[2]);
    OutNumber(55,190,MMprodleva,True,Buffer[2]);
  End;
  If Vsync=True then Waitretrace;
  FlipPage(Buffer[2],Buffer[4]);
End;


Procedure MainMenu;
Begin
  Repeat
    WriteMMScreen; Wait(MMprodleva);

    If FPS2s=True then Inc(MMframe) {je zrovna prvni vterina}
                  else Begin        {je zrovna druha vterina}
                         If MMframe>0 then
                         Begin
                           MMfps:=MMframe; {obnovit fps}
                           If vSync=False then
                           Begin
                             If MMfps<75 then Begin If MMprodleva>0     then Dec(MMprodleva); End
                                         else Begin If MMprodleva<65535 then Inc(MMprodleva); End;
                           End;
                         End;
                         MMframe:=0; {vynulovat pocet napocitanych snimku}
                       End;

{S} If Key[31]=True then StartGame:=True;                           {S=START}
    If Key[1]=True then EndingGame:=True;                          {ESC=EXIT}
{F} If Key[33]=True then                                         {F=SHOW FPS}
    Begin
      If fpsButtonF<15 then Inc(fpsButtonF) else fpsButtonF:=0;
      If fpsButtonF=15 then
      Begin
        If ShowFPS=False then ShowFPS:=True else ShowFPS:=False;
      End;
    End;

    If StartGame=True then
    Begin
      PlaySound(0);
      Player.ScoreTotal:=0;
      Player.Zivoty:=3;
      EndingPlay:=False;
      GameCompleted:=False;
      MainGame;
    End;
  Until EndingGame=True;
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Main;
Begin
  InitBuffers;
  Init320x200;
  InitKeyboard;
  InitTexter(50);
  InitTimer;

  Initialize;
  MainMenu;
  Silence;

  ShutdownTimer;
  ShutdownTexter;
  ShutdownKeyboard;
  Init80x25;
  ShutdownBuffers;
End;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin Main; End.