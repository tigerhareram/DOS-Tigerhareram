Unit Gamb1;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Interface
Uses Lite,DOS;

Type
  TRGB= Record
          R: Byte;
          G: Byte;
          B: Byte;
        End;

  TLista = Record
             Enable: Boolean;
             Sazka: array[0..1] of Boolean;
             Color: Byte;
           End;

  TDatRec = Record
              fpsProdleva: Byte;
              RollSpeed: Byte;
              SpinCounter: Byte;
              SpinHelper: Byte;
              SBEnable: Boolean;
              Svetla: Boolean;
              Nahoda: array[0..9] of Word;
              NahodnyRisk: Boolean;
              ModSpinu: Byte;
              SpinNumber: Word;
              SpinNumberA: Word;
              SpinNumberB: Word;
              SpinNumberC: Word;
              SpinPosun: array[0..2] of Word;
              SpinPosunMark: array[0..2] of Word;
              SpinValecBuff : array[0..2] of Byte;
              StoreMultiWin: LongInt;
              StoreCredit: LongInt;
              StoreBet: Byte;
              StoreBetMulti: Byte;
              StoreBetCounter: Word;
              StoreNasobic: Word;
              StoreLista: array[0..1] of TLista;
            End;

  TPub = Record
           Vklady: LongInt;
           Vyplaceno: LongInt;
         End;

  TDatRec2 = Record
               VkladyTMP: LongInt;
               VyplacenoTMP: LongInt;
               Pub: TPub;
               Vklad: array[0..24] of LongInt;
               Vyplaceno: array[0..24] of LongInt;
               JackPot: LongInt;
               JackPotCounter: Byte;
               Bonus: LongInt;
               Bonus750: Word;
               HiScore: LongInt;
               Hotovost : LongInt;
               vec: array[0..13] of Boolean;
             End;

  TButton = Record
              Counter: Byte;
              Blinking: Boolean;
              Phase: Byte;
              Smer: Byte;
              Color: Byte;
            End;

  TRisk = Record
            Enable: Boolean;
            Blinking: Boolean;
            Phase: Byte;
            Counter: Byte;
            DohraCounter: Word;
          End;

  TRisk2 = Record
             Enable: Boolean;
           End;

  TWinGamble = Record
                 Enable: Boolean;
                 Blinking: Boolean;
                 Phase: Byte;
                 Counter: Byte;
                 Counter2: Byte;
                 Store: array[0..1] of Byte;
               End;

  TWinGamble2 = Record
                  Enable: Boolean;
                End;

  TValec = Record
             Rotate: Boolean;
             Symbol: array [0..4] of Byte;
             Scroll: Byte;
             Counter: LongInt;
             SymbolCounter: Word;
           End;

  TVyhra = Record
             Castka: Word;
           End;

  TWinConf = Record
               Symbol: array[1..9] of Byte;
               Light: array[1..9] of Byte;
               Vyhra: array[1..5] of Boolean;
               Counter1: Byte;
               Counter2: Byte;
               Counter3: Byte;
               SoundSet: Byte;
             End;

  TWaitAction = Record
                  Active: Boolean;
                  SeqCT: LongInt;
                  SeqAlg: Byte;
                  Counter: array[0..5] of Byte;
                  Smer1: Byte;
                  Smer2: Byte;
                  Lista: array[0..1,0..9] of Byte;
                  Cislo: array[0..2,0..9] of Byte;
                  Cena: array[0..11] of Byte;
                  Risk: array[1..2] of Byte;
                  WinGamble: array[1..2] of Byte;
                  Memory: Byte;
                End;

  TStopButton = Record
                  Mark: Boolean;
                  WaitActPhase: Byte;
                  Counter: Byte;
                  Blinking: Boolean;
                  Phase: Byte;
                  Smer: Byte;
                  Color: Byte;
                End;

  TIndicator = Record
                 Counter: LongInt;
                 delka: LongInt;
                 Step: Word;
                 CT2: Byte;
                 Indicator: array[1..5] of Byte;
               End;

Const
  ButtonSpeed = 50;

  ColorRed         = 1;
  ColorBlue        = 2;
  ColorGreen       = 3;
  ColorRedDark     = 4;
  ColorBlack       = 5;
  ColorWhite       = 6;
  ColorTexter      = 7;
  ColorCtecka      = 8;
  ColorBlink1      = 9;
  ColorBlink2      = 10;
  ColorBlink3      = 11;
  ColorBlue1       = 12;
  ColorBlue2       = 13;
  ColorBlue3       = 14;
  ColorBlue4       = 15;
  ColorButtonA1    = 225;
  ColorButtonA2    = 226;
  ColorButtonA3    = 227;
  ColorButtonA4    = 228;
  ColorButtonA5    = 229;
  ColorButtonB1    = 230;
  ColorButtonB2    = 231;
  ColorButtonB3    = 232;
  ColorButtonB4    = 233;
  ColorButtonB5    = 234;
  ColorButtonC1    = 235;
  ColorButtonC2    = 236;
  ColorButtonC3    = 237;
  ColorButtonC4    = 238;
  ColorUnknown     = 239;

  MaxSymbolu       = 24;

  SymbolyA: array[0..24] of Byte = (0,1,1,1,9,2,2,2,8,2,6,7,1,8,1,3,3,3,3,4,6,4,5,4,7);
  SymbolyB: array[0..24] of Byte = (0,3,1,1,1,9,1,1,7,3,3,6,6,5,5,3,5,4,4,4,2,8,2,2,2);
  SymbolyC: array[0..24] of Byte = (0,2,2,2,2,1,1,1,1,7,3,3,3,9,8,6,4,6,4,5,4,7,5,1,5);

  MaxHistorie = 19;

  {------------------------------------------------------------------------}

  {cim mensi cisla tim min zisku vyher pro gamblera}

  RovnaMira1 = 14890; {Vyhry 2kc}      {0 ... 32767}
  RovnaMira2 = 20912; {Vyhry 4kc}      {0 ... 32767}
  RovnaMira3 = 27336; {Vyhry 5kc}      {0 ... 32767}

  RovnaMira4 = 32767; {Riskovani 1:1}  {0 ... 65535}

  Joker1 = 49152; {Joker 2kc}      {32768 ... 65535}
  Joker2 = 49152; {Joker 4kc}      {32768 ... 65535}
  Joker3 = 49152; {Joker 5kc}      {32768 ... 65535}

  JokerNasobeni1 = 21845;          {0 ... 65535}
  JokerNasobeni2 = 21845;          {0 ... 65535}
  JokerNasobeni3 = 21845;          {0 ... 65535}

  {------------------------------------------------------------------------}

Var
  F: File;
  DatRec: TDatRec;
  DatRec2: TDatRec2;
  DirInfo: SearchRec;

  ButtonDelay: Byte;
  Btn: array[0..8] of TButton;
  BtnCol: TButton; {EDIT}
  Lista: array[0..1] of TLista;

  Risk: TRisk;
  Hlava: TRisk2;
  Orel: TRisk2;

  WinGamble: TWinGamble;
  WinGambleGreen: TWinGamble2;
  WinGambleRed: TWinGamble2;
  RandomGamble: Word;

  Penize : LongInt;
  VecProdata: array[0..13] of Boolean;
  Credit : LongInt;
  Vyhra  : TVyhra;
  WinConf: TWinConf;
  MultiWin: LongInt;
  MultiCounter: Byte;
  MultiCounter2: Byte;
  Bet: Byte;
  BetMulti: Byte;
  BetCounter: Byte;
  Nasobic: Byte;
  AutoStart: Boolean;
  AutoStartTyp: Byte;
  VkladyTMP: LongInt;
  VyplacenoTMP: LongInt;
  WildJoker: Boolean;
  JackPotPadl: Boolean;

  CreditShow: Boolean;
  VyhraShow: Boolean;
  VkladShow: array[1..10] of Boolean;

  Valec: array[0..2] of TValec;
  AllStoped: Boolean;
  PreValec: array[0..2] of TValec;
  PrePos: array[0..2] of Byte;
  PreCounter: Word;
  AllStopedPre: Boolean;
  BezEfektu: Boolean;
  WinBude: Boolean;
  Obtiznost: Word;
  StahovaniMultiwinu1: Byte;
  StahovaniKasy1: Byte;
  Button1Waiting: Byte;

  {risking global}
    NextVyhra: Word;
    I: Byte;
    N: Byte;
    BetStore: Byte;
    BetMultiStore:Byte;
    RiskRandom1: Byte;
    RiskRandom2: Byte;
    RiskRandom3: Byte;
    RiskRandom4: Word;
    RiskAuto: Boolean;
    RiskCounter: Byte;

  SoundValce: Byte;
  RiskSpeed: Byte;
  RiskSpeedCounter: Byte;
  RiskSPDCounter: Byte;
  Joker2x: Boolean;
  Obrazek: Byte;
  ObrazekCounter: Byte;
  ColorBackup: array[0..255] of TRGB;

  SBOffsetMAX: Word;
  SBOffsetMIN: Word;

  VyhernostKurzor: Byte;
  VyhernostKurzorC: Byte;

  Light1: Byte;
  Light2: Byte;
  Light3: Word;
  LightJ: Byte;
  LightK: Byte;
  LightL: Byte;
  SymbolLight: Byte;
  SymbolLightSmer: Byte;

  WaitAction: TWaitAction;
  Linie: array[0..1] of TIndicator;

  StopButton: array[0..2] of TStopButton;
  Zamichat: Boolean;
  StornoSetup: Byte;
  BezVyhry: Boolean;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Implementation





{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.