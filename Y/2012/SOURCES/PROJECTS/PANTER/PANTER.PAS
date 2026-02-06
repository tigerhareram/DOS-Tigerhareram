Program Panter;
Uses Go32,DOS,Alpha;

Type
  TPlayer = Record
              Jmeno: string[12];
              Job: Byte;
              HP: Word;
              HPmax: Word;
              MP: array[0..7] of Byte;
              MPmax: array[0..7] of Byte;
            End;

  TOvladani = Record
                KeyUp: Byte;
                KeyDown: Byte;
                KeyLeft: Byte;
                KeyRight: Byte;
                KeyOK: Byte;
                KeyBack: Byte;
              End;

  TMenu = Record
            ButtonDelay: Word;
            Speed: Word;
          End;

  TGraphics = Record
                vSync: Boolean;
                ShowGame: Boolean;
                ShowMenu: Boolean;
                FontColor: Byte;
                FontColorR: Byte;
                FontColorG: Byte;
                FontColorB: Byte;
                WindowsColor: Byte;
                WindowsColorR: Byte;
                WindowsColorG: Byte;
                WindowsColorB: Byte;
                ButtonColor: Byte;
                BlackColor: Byte;
                WhiteColor: Byte;
              End;

  Tfps = Record
           limit: Byte;
           frame: Word;
           count: Word;
           prodleva: Word;
           prodlevamenu: Word;
           zobrazovat: Boolean;
           trvani: LongInt;
           trvaniTarget: LongInt;
         End;

  TMap = Record
           DelkaRLE: Word;
           Xview: Word;
           Yview: Word;
           WorldMapOnScreen: Boolean;
           Id: Byte;
           Obtain: array[0..29] of Boolean;
         End;

  TWater = Record
             WaterCounter: Byte;
             WaterBlink: Byte;
           End;

  TLod = Record
           X: Word;
           Y: Word;
           Xa: Word; { [0..319] }
           Ya: Word; { [0..199] }
           Smer: Byte;
           Frame: Byte;
           Vyskomer: Byte;
           Klesani: Boolean;
           Obtain: Boolean;
         End;

  TParta = Record
             X: Word;
             Y: Word;
             Smer: Byte;
             Frame: Byte;
             Pesky: Boolean;
             VLodi1: Boolean;
             VLodi2: Boolean;
             VLese: Boolean;
             Vudce: Byte;
             Krok: Boolean;
             Gold: LongInt;
           End;

  TStep = Record
            StepCounter1: Byte;
            StepCounter2: Byte;
            StepCounter3: Byte;
            StepCounter4: Byte;
          End;

  TSlot = Record
            Player: array[1..4] of TPlayer;
            Ovladani: TOvladani;
            Graphics: TGraphics;
            Menu: TMenu;
            fps: Tfps;
            Parta: TParta;
            Lod1: TLod;
            Lod2: TLod;
            Mapa: TMap;
          End;

  TSave = Record
            Slot: array[0..4] of TSlot;
          End;


Const
  Parta_StartX = 1952;
  Parta_StartY = 1440;

  Lod1_StartX = 1920;
  Lod1_StartY = 1440;

  Lod2_StartX = 1952;
  Lod2_StartY = 1504;


Var
  DirInfo: SearchRec; {Save/Load}
  F: File;            {Save/Load}
  Save: TSave;        {Save/Load}

  Mapa: TMap;
  Player: array[1..4] of TPlayer;
  Ovladani: TOvladani;
  Graphics: TGraphics;
  Menu: TMenu;
  fps: Tfps;
  Water: TWater;
  Parta: TParta;
  Lod1: TLod;
  Lod2: TLod;
  Step: TStep;

  StartGame: Boolean;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{Utils}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MACHINE\waitbtn.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MACHINE\waitkey.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MACHINE\waitrel.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MACHINE\waitmenu.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MACHINE\setcolor.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MACHINE\fpstrigg.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SCENE2\showfps.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SCENE2\sipka.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SCENE2\sipka2.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SCENE2\wwaiting.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SAVELOAD\loadgraA.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SAVELOAD\loadgraB.pas}

{Config}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SETUP\setup1.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SETUP\setup2.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SETUP\setup3.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SETUP\setup.pas}

{Saving}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SAVELOAD\saveload.pas}

{Game Menu}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\GM_Item.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\GM_Magic.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\GM_Equip.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\GM_Stat.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\GM_Form.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\MapaId00.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\GM_Mapa.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\GM_Conf.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\GM_Save.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAINMENU\gamemenu.pas}

{World sys}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MACHINE\waterblk.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MACHINE\getpole.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\testles.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\testles2.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\testlod.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\testlod2.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\testlod3.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\poststep.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\stepmain.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\prestep.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\vrtulky.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\STEP\pristani.pas}

{Map GFX}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SCENE\world1.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SCENE\parta.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SCENE\object.pas}

{World Map}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\SCENE\world.pas}

{Starting}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\START\editname.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\START\editjob.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\START\startset.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\START\start1.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\START\start.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\START\default.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAIN\init.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAIN\mainmenu.pas}
{$I C:\SOURCES\PROJECTS\GAMES\PANTER\MAIN\shutdown.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

Procedure Main;
Begin
  Init;
  MainMenu;
  Shutdown;
End;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin Main; End.
