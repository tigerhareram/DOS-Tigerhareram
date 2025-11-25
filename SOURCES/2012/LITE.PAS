{$G+}
Unit Lite;
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Interface
Type
  TRGB = Record
           R: Byte;
           G: Byte;
           B: Byte;
         End;

  TMelody1 = Record
               Nastroj: Byte;
               Balance: Byte;
               DefaultOktava: Byte;
               Nota: Byte;
               Volume: Byte;
               Pos: Word;
               NotaHraje: Boolean;
               NotaCounter: Byte;
               FIFO: array[1..2] of Byte;
               Stop: Boolean;
             End;

  TMelody = Record
              DataSeg: Word;
              DataPoint: Pointer;
              Kanal: array[0..7] of TMelody1;
              Delka: LongInt;
              DelkaKanalu: array[0..7] of LongInt;
              Tempo: Word;
              Delay: Word;
              DelayCounter: Word;
              Opakovat: Boolean;
              Repetice: LongInt;
              SegmentLenght: LongInt;
              Start: Word;
              Finish: Word;
            End;

Var
  xmsCelkemPotreba: Word;
  xmsBlokPotreba: Word;

  Key: array[0..127] of Boolean;
  Buffer: array[0..4] of Word;
  Barva: array[0..15] of TRGB;
  CisloStranky: Byte;
  BufferSeg2: Word;
  BityP: Pointer;
  Bity: Word;
  b: array[0..7] of Byte;
  SoundDataSeg: Word;
  ZvukTabSeg: Word;

  Melody: TMelody;
  NotDrums: Byte;

  {XMS}
  Function  DetekujXms: Word;
  Procedure GetSizeXms(var celkemXMS,blokXMS: Word);
  Function  AlokujXms(kolik: Word): word;
  Procedure UvolniXms(handle: Word);
  Procedure MoveToXMS(Handle: Word; XMSOffset: LongInt; Var Source; BlockLength: LongInt);
  Procedure MoveFromXMS(Handle: Word; XMSOffset: LongInt; Var Dest; BlockLength: LongInt);


  {Grafika}
  Procedure Init320x200;
  Procedure Init80x25;
  Procedure WaitRetrace;

  Procedure InitBuffers;
  Procedure ShutdownBuffers;

  Procedure GetPal(Color:Byte; Var R,G,B:Byte);
  Procedure SetPal(Color:Byte; R,G,B:Byte);
  Procedure SavePal(Color:Byte);
  Procedure RestorePal(Color:Byte);
  Procedure BlackPal(Color:Byte);
  Procedure FadeOut;
  Procedure FadeIn;
  Procedure StartBlinking(Color:Byte);
  Procedure StopBlinking(Color:Byte);
  Procedure SetBlinkingTempo(Tempo: Byte);

  Procedure LoadGRPage(JmenoSouboru:string;Pozice:LongInt);
  Procedure SaveGrPage(JmenoSouboru:string);
  Procedure LoadBmpFile(JmenoSouboru: string; pozice: LongInt; StartColor: Byte);
  Procedure LoadBmpFile256(JmenoSouboru: string; pozice: LongInt; X,Y,BufferTo: Word);
  Procedure LoadBlok(x1,y1,x2,y2,x3,y3,BufferTo: Word);
  Procedure LoadBlokM(x1,y1,x2,y2,x3,y3,BufferTo: Word);
  Procedure LoadBitMap(X,Y: Word; BufferTo: Word);
  Procedure LoadBitMapM(X,Y: Word; BufferTo: Word);

  Function  ReadPixel(X,Y,Buffer:Word): Byte;
  Procedure WritePixel(X:Word;Y,Color:Byte;Buffer:Word);
  Procedure Blok(x1,y1,x2,y2,Color,Buffer:Word);
  Procedure Ramecek(X1,Y1,X2,Y2:Word;Color:Byte;Buffer:Word);
  Procedure WriteBlok(x1,y1,x2,y2,x3,y3,BufferFrom,BufferTo: Word);
  Procedure WriteSprite(x1,y1,x2,y2,x3,y3,BufferFrom,BufferTo: Word);
  Procedure WriteGraphics(X,Y,MapXview,MapYview:LongInt;x1,y1,x2,y2,BufferFrom,BufferTo:Word);
  Procedure LoadDefaultFont(x1,y1,Color,BufferTo: Word);
  Procedure WriteText(FontBuffer,FontX,FontY,FontDelka,FontVyska,mezera,x,y:Word;retezec:string;BufferTo:Word);
  Procedure WriteNumber(FontBuffer,FontX,FontY,FontDelka,FontVyska,mezera,x,y:Word;Cislo:Longint;BufferTo:Word);
  Procedure Line(a,b,c,d:integer;barva,BufferTo:word);

  Procedure FlipPage(BufferFrom,BufferTo: Word);
  Procedure ClearPage(Buffer:Word);


  {Movement}
  Function GetLineX(a,b,c,d:integer;Vzdalenost:Word): Word;
  Function GetLineY(a,b,c,d:integer;Vzdalenost:Word): Word;


  {Kolize}
  Function Inside(x,y,x1,y1,x2,y2: LongInt): Boolean;
  Function Plosina(x,y,x1,x2,plosinaY: LongInt): Boolean;


  {Texter CZ}
  Procedure InitTexter(Barva:Byte);
  Procedure ShutdownTexter;
  Procedure ChangeTexterColor(Barva:Byte);
  Procedure OutText(X,Y:Word;retezec:string;BufferTo:Word);
  Procedure OutNumber(x,y:Word;Cislo:Longint;Small:Boolean;BufferTo:Word);


  {Mapa}
  Procedure InitMapBuffers(Velikost: Word);
  Procedure ShutdownMapBuffers;
  Procedure LoadMapFile(soubor:string; pozice:Longint);
  Procedure SaveMapFile(soubor:string);
  Procedure SetMapByte(MapOffset:Word;bajt:Byte);
  Function  GetMapByte(MapOffset:Word): Byte;
  Procedure WriteMapScreen(XView,YView,MapDelka:Word;BufferFrom,BufferTo:Word);


  {Keyboard}
  Procedure InitKeyboard;
  Procedure ShutdownKeyboard;


  {Sound Blaster}
  Procedure InitSB;
  Procedure ShutdownSB;
  Procedure SBPlayRaw(Cislo:Byte);


  {Timer}
  Procedure InitTimer;
  Procedure ShutdownTimer;

  Procedure Wait(ms: Word);
  Procedure Sound(Hertz: Word);
  Procedure Silence;
  Procedure Stopky_Start;
  Procedure Stopky_Stop;
  Function  Stopky_GetNumber: LongInt;
  Function  FPS2s: Boolean;
  Procedure Start_LoadSymbol(X,Y:Word;BackColor,FrontColor:Byte);
  Procedure Stop_LoadSymbol;


  {Pc Speaker}
  Procedure InitRawBuffers;
  Procedure ShutdownRawBuffers;
  Procedure LoadRAWFile(filename: String;Pozice:LongInt;N:Byte);
  Procedure PlayRaw(Cislo:Byte);

  Procedure LoadSNDFile(Filename:String;Pozice:LongInt);
  Procedure SaveSNDFile(Filename: String);
  Procedure PlaySound(Sample:Byte);
  Procedure StopPlay;


  {MIDI}
  Procedure InitGM;
  Procedure ShutdownGM;
  Procedure LoadMELFile(Filename:String;Pozice:LongInt);
  Procedure SaveMELFile(Filename:String);
  Procedure StartGMPlay(Temp,Vol:Byte;Start,Finish:Word;Rep:Boolean);
  Procedure StopGMPlay;
  Procedure SetMelodyTempo(Temp: Byte);
  Procedure SetKanalVolume(Kan,Vol: Byte);
  Procedure JumpToMelodyRepeat;
  Procedure CountMelodyLenght;
  Procedure CountMelodySegmentLenght(Start,Finish: Word);
  Procedure SetupGM;

  Procedure SetupGMAdr;
  Procedure ResetGM;
  Procedure SetNastroj(Kanal,Cislo:byte);
  Procedure SetBalance(Kanal,Poloha:byte);
  Procedure NotaOn(Kanal,Nota,Hlasitost:byte);
  Procedure NotaOff(Kanal,Nota,Hlasitost:byte);


  {Mouse}
  Procedure InitMouse;
  Procedure ShowMouse;
  Procedure HideMouse;
  Function  GetMouseX: Word;
  Function  GetMouseY: Word;
  Function  GetButton1: Byte;
  Function  GetButton2: Byte;
  Function  GetButton3: Byte;
  Procedure SetMouseXY(X,Y: Word);
  Procedure SetMouseRozsah(X1,Y1,X2,Y2: Word);


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Implementation
{$L D:\SOURCES\2012\STORE1\ENGINE\320clear.obj}
{$L D:\SOURCES\2012\STORE1\ENGINE\320flip.obj}
{$L D:\SOURCES\2012\STORE1\ENGINE\320blok.obj}
{$L D:\SOURCES\2012\STORE1\ENGINE\320wblok.obj}

Uses DOS;

Type
  TBMPHeader = Record
                 Id: Word;
                 Velikost: LongInt;
                 Reserved: LongInt;
                 DataOffset: LongInt;
                 HeaderSize: LongInt;
                 RozsahX: LongInt;
                 RozsahY: LongInt;
                 BitPlanes: Word;
                 BPP: Word;
                 Komprese: LongInt;
                 ImageSize: LongInt;
                 HorizontalRes: LongInt;
                 VerticalRes: LongInt;
                 Colors: LongInt;
                 ImportantColors: LongInt;
               End;

  TBmpRGB = Record
            B: Byte;
            G: Byte;
            R: Byte;
            Reserved: Byte;
          End;

  TBMP = Record
           Header: TBMPHeader;
           Palette: array[0..255] of TBmpRGB;
           DataByte: Byte;
         End;

  TMapa = Record
            MapFile: File;
            Size: Word;
            MapBuffer: Word;
            MapBufferP: Pointer;
            MapBufferRLE: Word;
            MapBufferRLEP: Pointer;
            DelkaRLE: Word;
          End;

  TSample = Record
              Handle: Word;
              Delka: LongInt;
              Pocitadlo: Word;
            End;

  TLoadSymbol = Record
                  X: Word;
                  Y: Word;
                  BackColor: Byte;
                  FrontColor: Byte;
                  OnScreen: Boolean;
                  TimeCounter: Word;
                  FrameCounter: Byte;
                End;

  XMSParamBlock= Record
                   Length: LongInt;
                   SHandle: Word;
                   SOffset: Array[1..2] Of Word;
                   DHandle: Word;
                   DOffset: Array[1..2] Of Word;
                 End;

Const
  DefaultFont: array[0..124] of Byte =
  (119,157,239,253,241,255,227,24,198,16,132,72,31,250,17,247,175,242,6,49,
   140,97,8,196,145,143,157,239,193,209,251,163,8,197,222,119,159,249,67,121,
   140,99,24,19,144,173,99,234,249,196,148,35,56,194,113,9,35,248,197,208,
   124,124,72,198,49,143,192,64,6,49,138,162,47,144,2,140,98,69,16,31,
   249,34,170,168,136,249,0,135,17,81,39,192,64,65,196,247,143,247,125,206,
   155,2,20,194,1,140,107,71,59,238,240,156,252,146,1,8,98,72,133,223,
   255,131,231,33,206);

  znaky: array[0..204] of Byte = (
{A}  126,144,144,144,126,
{B}  254,146,146,146,108,
{C}  124,130,130,130,68,
{D}  254,130,130,130,124,
{E}  254,146,146,146,130,
{F}  254,144,144,144,128,
{G}  124,130,146,146,92,
{H}  254,16,16,16,254,
{I}  130,254,130,0,0,
{J}  4,2,2,2,252,
{K}  254,16,40,68,130,
{L}  254,2,2,2,2,
{M}  254,64,32,64,254,
{N}  254,32,16,8,254,
{O}  124,130,130,130,124,
{P}  254,144,144,144,96,
{Q}  124,130,138,134,126,
{R}  254,144,152,148,98,
{S}  100,146,146,146,76,
{T}  128,128,254,128,128,
{U}  252,2,2,2,252,
{V}  248,4,2,4,248,
{W}  252,2,4,2,252,
{X}  198,40,16,40,198,
{Y}  224,16,14,16,224,
{Z}  134,138,146,162,194,
{+}  16,16,124,16,16,
{-}  16,16,16,16,16,
{x}  40,16,40,
{/}  2,4,8,16,32,64,128,
{:}  0,0,40,0,0,
{.}  2,0,0,0,0,
{,}  6,0,0,0,0,
{=}  40,40,40,40,40,
{?}  64,128,138,144,96,
{%}  4,72,16,36,64,
{!}  250,0,0,0,0,
{(}  56,68,130,0,0,
{)}  130,68,56,0,0,
{>}  130,68,40,16,0,
{<}  16,40,68,130,0);

  SmallZnaky: array[0..131] of Byte = (
{a}  2,21,21,21,14,1,
{b}  127,10,17,17,14,
{c}  14,17,17,17,10,
{d}  14,17,17,10,127,
{e}  14,17,21,21,12,
{f}  5,63,69,64,32,
{g}  57,69,69,62,64,
{h}  127,8,16,16,15,
{i}  1,47,1,
{j}  1,33,190,
{k}  127,4,10,17,
{l}  64,127,1,
{m}  31,8,16,15,16,15,
{n}  31,8,16,16,15,
{o}  14,17,17,17,14,
{p}  65,127,41,68,68,56,
{q}  56,68,68,41,127,65,
{r}  31,8,16,16,8,
{s}  9,21,21,21,18,
{t}  16,126,17,2,
{u}  16,30,1,17,30,1,
{v}  28,2,1,2,28,
{w}  28,2,1,2,1,2,28,
{x}  17,10,4,10,17,
{y}  112,9,9,10,124,
{z}  17,19,21,25,17,
{ø}  32,80,32 );

  Cifry: array[0..49] of Byte = (
{0} 124,138,146,162,124,
{1} 34,66,254,2,2,
{2} 78,146,146,146,98,
{3} 130,146,146,146,108,
{4} 16,48,80,144,254,
{5} 242,146,146,146,140,
{6} 124,146,146,146,76,
{7} 130,132,136,144,224,
{8} 108,146,146,146,108,
{9} 100,146,146,146,124);

  SmallCifry: array[0..39] of Byte = (
{0} 112,136,136,112,
{1} 40,72,248,8,
{2} 152,168,168,72,
{3} 136,168,168,80,
{4} 32,96,160,248,
{5} 232,168,168,144,
{6} 112,168,168,16,
{7} 128,152,160,192,
{8} 80,168,168,80,
{9} 64,168,168,112);

   MaxRawu = 50;

   DMA8reg : array[0..2] of byte = ($a,$b,$c);
   DMA16reg : array[0..2] of byte = ($d4,$d6,$d8);
   DMAOfs : array[0..7] of byte = (0,2,4,6,$c0,$c4,$c8,$cc);
   DMAVel : array[0..7] of byte = (1,3,5,7,$c2,$c6,$ca,$ce);
   DMAstr : array[0..7] of byte = ($87,$83,$81,$82,$89,$8a,$8b,$8f);
   INTvec : array[0..15] of byte = (8,9,10,11,12,13,14,15,$70,$71,$72,$73,$74,$75,$76,$77);

   VIDEO        = $10;  { Video interrupt number                    }
   CRTC_ADDR	= $3d4; { Base port of the CRT Controller (color)   }
   SEQU_ADDR	= $3c4; { Base port of the Sequencer                }


Var
  F: File;
  Bmp: TBMP;
  Map: TMapa;

  GrafikaSeg: Word;             GrafikaP: Pointer;
  Barvy4Seg: Word;              Barvy4P: Pointer;
  PaletaSeg: Word;              PaletaP: Pointer;

  RLESeg: Word;                 RLEP: Pointer;
  RLEKompressedSeg: Word;       RLEKompressedSegP: Pointer;
  RLEdelka: Word;

  BufferP: array[0..3] of Pointer;
  Buffer2: Pointer;

  BufferSegC,BufferSegC1,BufferSegC2,BufferSegC3: Word;
  BufferC,BufferC1,BufferC2,BufferC3: Pointer;
  TexterColor: Byte;

  c: array [0..7] of Byte;

  PressedKey: Byte;
  BIOSKeyboardHandler: Procedure;

  BIOSTimerHandler: Procedure;
  clock_ticks,counter: longint;
  StopkyTics: LongInt;
  StopkyActive: Boolean;

  SoundDataP: Pointer;
  ZvukTabP: Pointer;

  xmsAdr:longint;
  xmsVersion,ovlXmsVersion,hmaDetect: Word;
  xmsCelkem,xmsMaxBlok: Word;
  xmsChyba: Byte;
  XMSError: Boolean;

  PocetRawu: Byte;
  LongRawCislo: Byte;
  LongRaw: Boolean;
  LongRawCast: Word;
  LongRawMaxCasti: Word;
  LongRawZbytek: Word;
  Sample: array[0..MaxRawu] of TSample;
  OffsetSpeakeru: Word;
  PrehravanyZvuk: Byte;
  PrehravatZvuk: Boolean;
  RawHraje: Boolean;
  CisloZvuku: Byte;
  PosuvZ: Word;

  delaycounter: Word;
  waiting: Boolean;
  player: Byte;
  stopky: LongInt;
  fps_helper: Byte;

  GMAdr: Word;
  GMHraje: Boolean;

  LoadSymbol: TLoadSymbol;

  IRQ,DMA8,DMA16 : byte;
  Adr : word;
  Typ : byte;
  SBbuffer : pointer;
  SBBufferSeg: Word;
  StaraSBObsluha : pointer;
  LinearAdr : longint;
  Stranka,OfsStranky : word;
  AktCast : byte;
  SBOffsetMIN: Word;
  SBOffsetMAX: Word;
  DelkaZbytku: LongInt;
  AktPos: LongInt;
  CisloRawu: Byte;

  ColorBackup: array[0..255] of TRGB;

  Blinking: Boolean;
  BlinkingCounter: Word;
  BlinkingCounterMax: Word;
  Blink: array[0..255] of Boolean;
  Blink2: array[0..255] of Byte;


{SECTION XMS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Function DetekujXms: Word;
{ Vrati 0, pokud je ovladac XMS nainstalovany.}
{ zmeni global. prom. xmsAdr, xmsVersion, ovlXmsVersion a hmaDetect}
Var vrat:word;
Begin
  asm
    mov vrat,1    { predpokladame chybu }
    mov ax,4300h  { sluzba 4300h - XMS, zjisti pritomnost XMS}
    int 2Fh       { multiplexni preruseni (preruseni nainstalovanych ovladacu)}
    cmp al,80h    { (pokud mame v al 80h je XMS) }
    jnz @konec    { ...XMS neni, tak skocime na konec... }
    mov vrat,0    { XMS je!!! }
    mov ax,4310h  { sluzba 4310h, vrat adresu obsluzneho programu }
    int 2Fh
    mov word ptr [xmsadr],bx    { do xmsAdr si dame adresu kde mame ovladac }
    mov word ptr [xmsadr+2],es

    mov ah,00h             {vrat stav XMS}
    call [xmsadr]
    mov [xmsVersion],ax    { verze xms v BCD }
    mov [ovlXmsVersion],bx { verze ovladace. Opet v BCD }
    mov [hmaDetect],dx     { true/false }

   @konec:
  End;
  DetekujXms:=vrat;
  If vrat=0 then XMSError:=True;
End;


Procedure GetSizeXms(var celkemXMS,blokXMS: Word);
{ V celkem vraci celkovou (volnou?) velikost Xms a v blok kolik si maximalne muzeme alokovat pro 1 blok. }
{ Vetsinou jsou obe velikosti shodne. }
Var celkem,blok:word;
Begin
  asm
    mov  ah,08h  {zjisti velikost XMS}
    call [xmsadr]
    mov  [xmsChyba],bl    { chyba? }
    mov  [celkem],dx
    mov  [blok],dx
  end;
  celkemXMS:=celkem;
  blokXMS:=blok;
End;


Function AlokujXms(kolik: Word): Word;
{ Kolik je v Kb. Vraci handle (rukojet) alokovaneho bloku. }
Var vrat:word;
Begin
  Asm
    mov  ah,09h          {alokuj XMS}
    mov  dx,[kolik]
    call [xmsadr]
    mov  [vrat],dx
    mov  [xmsChyba],bl   { chyba? }
  End;
  AlokujXms:=vrat;
End;


Procedure UvolniXms(handle: Word);
{ Vsechny bloky, ktere jsme si alokovali bychom meli uvolnit. }
{ Jinak budou az do restartu systemu nepouzitelne pro jine aplikace. }
Begin
  Asm
    mov  ah,0ah
    mov  dx,[handle]
    call [xmsadr]
    mov  [xmsChyba],bl    { chyba? }
  End;
End;


Procedure MoveToXMS(Handle: Word; XMSOffset: LongInt; Var Source; BlockLength: LongInt);
Var
  ParamBlock: XMSParamBlock;
  XSeg,PSeg,POfs: Word;
Begin
  If Handle<>0 then
  Begin
    XMSchyba:=0;
    With ParamBlock Do
      Begin
        Length:=BlockLength;
        SHandle:=0;
        SOffset[1]:=Ofs(Source);
        SOffset[2]:=Seg(Source);
        DHandle:=Handle;
        DOffset[1]:=Word(XMSOffset AND $FFFF);
        DOffset[2]:=Word(XMSOffset SHR 16);
      End;
    PSeg:=Seg(ParamBlock);
    POfs:=Ofs(ParamBlock);
    XSeg:=Seg(XMSAdr);
    Asm
      Push DS
      Mov  AH,0Bh
      Mov  SI,POfs
      Mov  BX,XSeg
      Mov  ES,BX
      Mov  BX,PSeg
      Mov  DS,BX
      Call [ES:XMSAdr]
      Or   AX,AX
      Jne  @@1
      Mov  XMSChyba,BL
  @@1:
      Pop  DS
    End;
  End;
End;


Procedure MoveFromXMS(Handle: Word; XMSOffset: LongInt; Var Dest; BlockLength: LongInt);
Var
  ParamBlock: XMSParamBlock;
  XSeg,PSeg,POfs: Word;
Begin
  If Handle<>0 then
  Begin
    XMSChyba:=0;
    With ParamBlock Do
      Begin
        Length:=BlockLength;
        SHandle:=Handle;
        SOffset[1]:=Word(XMSOffset AND $FFFF);
        SOffset[2]:=Word(XMSOffset SHR 16);
        DHandle:=0;
        DOffset[1]:=Ofs(Dest);
        DOffset[2]:=Seg(Dest);
      End;
    PSeg:=Seg(ParamBlock);
    POfs:=Ofs(ParamBlock);
    XSeg:=Seg(XMSAdr);
    Asm
      Push DS
      Mov  AH,0Bh
      Mov  SI,POfs
      Mov  BX,XSeg;
      Mov  ES,BX
      Mov  BX,PSeg
      Mov  DS,BX
      Call [ES:XMSAdr]
      Or   AX,AX
      Jne  @@1
      Mov  XMSChyba,BL
  @@1:
      Pop  DS
    End;
  End;
End;


{SECTION GRAPHICS 320x200 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Init320x200; Assembler;
Asm
  Mov AH, 00h
  Mov AL, 13h
  Int 10h
End;


Procedure Init80x25; Assembler;
Asm
  Mov AH, 00h
  Mov AL, 03h
  Int 10h
End;


Procedure WaitRetrace; Assembler;
Asm
    Mov dx,3DAh
@l1:
    In al,dx
    And al,08h
    Jnz @l1
@l2:
    In al,dx
    And al,08h
    Jz  @l2
End;


Procedure InitBuffers;
Var I,x: Word;
Begin
  XMSError:=False;
  If DetekujXMS=0 then GetSizeXMS(XMSCelkemPotreba,XMSBlokPotreba)
                  else XMSError:=True;

  GetMem(BufferP[0],64000); Buffer[0]:=Seg(BufferP[0]^);
  For x:=0 to 63999 do mem[Buffer[0]:x]:=0;

  GetMem(BityP,32000); Bity:=Seg(BityP^);
  For x:=0 to 31999 do mem[Bity:x]:=0;

  For I:=1 to 3 do
  Begin
    GetMem(BufferP[I],64000); Buffer[I]:=Seg(BufferP[I]^);
    For x:=0 to 63999 do mem[Buffer[I]:x]:=0;
  End;

  Buffer[4]:=$A000;
  GetMem(Buffer2,2000); BufferSeg2:=Seg(Buffer2^);
  GetMem(GrafikaP,8000); GrafikaSeg:=Seg(GrafikaP^);
  GetMem(Barvy4P,1008); Barvy4Seg:=Seg(Barvy4P^);
  GetMem(PaletaP,48); PaletaSeg:=Seg(PaletaP^);
  GetMem(RLEP,24128); RLESeg:=Seg(RLEP^);
  GetMem(RLEKompressedSegP,24128); RLEKompressedSeg:=Seg(RLEKompressedSegP^);

  For I:=0 to 1999 do mem[BufferSeg2:I]:=0;
  For I:=0 to 7999 do mem[GrafikaSeg:I]:=0;
  For I:=0 to 1007 do mem[Barvy4Seg:I]:=0;
  For I:=0 to 47 do mem[PaletaSeg:I]:=0;
  For I:=0 to 24127 do mem[RLESeg:I]:=0;
  For I:=0 to 24127 do mem[RLEKompressedSeg:I]:=0;
End;


Procedure ShutdownBuffers;
Var I: Byte;
Begin
  FreeMem(BufferP[0],64000);
  For I:=1 to 3 do FreeMem(BufferP[I],64000);
  FreeMem(Buffer2,2000);
  FreeMem(GrafikaP,8000);
  FreeMem(Barvy4P,1008);
  FreeMem(PaletaP,48);
  FreeMem(RLEP,24128);
  FreeMem(RLEKompressedSegP,24128);
End;


Function Bin2Dec(b7,b6,b5,b4,b3,b2,b1,b0: Byte): Byte;
Var I: Byte;
Begin
  I:=0;
  If b7=1 then Inc(I,128);
  If b6=1 then Inc(I,64);
  If b5=1 then Inc(I,32);
  If b4=1 then Inc(I,16);
  If b3=1 then Inc(I,8);
  If b2=1 then Inc(I,4);
  If b1=1 then Inc(I,2);
  If b0=1 then Inc(I,1);
  Bin2Dec:=I;
End;


Procedure Dec2Bin(DCnum:Byte);
Var I: Byte;
Begin
  For I:=0 to 7 do b[I]:=(DCnum AND (1 SHL I)) SHR I;
End;


Procedure GetPal(Color:Byte; Var R,G,B:Byte);
Begin
   Port[$3c7]:=Color;
   R:=Port[$3c9];
   G:=Port[$3c9];
   B:=Port[$3c9];
End;


Procedure SetPal(Color:Byte; R,G,B:Byte);
Begin
   Port[$3c8]:=Color;
   Port[$3c9]:=R;
   Port[$3c9]:=G;
   Port[$3c9]:=B;
End;


Procedure SavePal(Color:Byte);
Begin
  GetPal(Color,Colorbackup[Color].R,Colorbackup[Color].G,Colorbackup[Color].B);
End;


Procedure RestorePal(Color:Byte);
Begin
  SetPal(Color,Colorbackup[Color].R,Colorbackup[Color].G,Colorbackup[Color].B);
End;


Procedure BlackPal(Color:Byte);
Begin
  SetPal(Color,0,0,0);
End;


Procedure FadeOut;
Var
  Color,I: Byte;
  Tmp: array[1..3] of Byte;
Begin
  For I:=0 to 63 do
  Begin
    WaitRetrace;
    For Color:=0 to 255 do
    Begin
      GetPal(Color,Tmp[1],Tmp[2],Tmp[3]);
      If Tmp[1]>0 then Dec(Tmp[1]);
      If Tmp[2]>0 then Dec(Tmp[2]);
      If Tmp[3]>0 then Dec(Tmp[3]);
      SetPal(Color,Tmp[1],Tmp[2],Tmp[3]);
    End;
  End;
End;


Procedure FadeIn;
Var
  Color,I: Byte;
  Tmp: array[1..3] of Byte;
Begin
  For I:=0 to 63 do
  Begin
    WaitRetrace;
    For Color:=0 to 255 do
    Begin
      GetPal(Color,Tmp[1],Tmp[2],Tmp[3]);
      If Tmp[1]<ColorBackup[Color].R then Inc(Tmp[1]);
      If Tmp[2]<ColorBackup[Color].G then Inc(Tmp[2]);
      If Tmp[3]<ColorBackup[Color].B then Inc(Tmp[3]);
      SetPal(Color,Tmp[1],Tmp[2],Tmp[3]);
    End;
  End;
End;


Procedure StartBlinking(Color:Byte);
Begin
  If Blinking=False then Blinking:=True;
  SavePal(Color);
  Blink[Color]:=True;
  Blink2[Color]:=0;
End;


Procedure StopBlinking(Color:Byte);
Var I: Byte;
Begin
  Blink[Color]:=False;
  Blink2[Color]:=0;
  Blinking:=False;
  For I:=0 to 255 do If Blink[I]=True then Blinking:=True;
End;


Procedure SetBlinkingTempo(Tempo: Byte);
Begin
  If ((Tempo<1) or (Tempo>12)) then Tempo:=5;
  Case Tempo of
    1: BlinkingCounterMax:=360;
    2: BlinkingCounterMax:=340;
    3: BlinkingCounterMax:=320;
    4: BlinkingCounterMax:=300;
    5: BlinkingCounterMax:=280;
    6: BlinkingCounterMax:=260;
    7: BlinkingCounterMax:=240;
    8: BlinkingCounterMax:=220;
    9: BlinkingCounterMax:=200;
   10: BlinkingCounterMax:=180;
   11: BlinkingCounterMax:=160;
   12: BlinkingCounterMax:=140;
  End; {Case End}
End;


Procedure MovArraysTo3;
Var I,A: Word;
Begin
  A:=0;
  For I:=0 to 7999 do Begin mem[GrafikaSeg:I]:=mem[RLESeg:A]; Inc(A); End;
  For I:=0 to 999 do Begin mem[Barvy4Seg:I]:=mem[RLESeg:A]; Inc(A); End;
  For I:=0 to 47 do Begin mem[PaletaSeg:I]:=mem[RLESeg:A]; Inc(A); End;
  CisloStranky:=mem[RLESeg:9048];
End;


Procedure MovArraysToOne;
Var I: Word;
Begin
  For I:=0 to 7999 do mem[RLESeg:I]:=mem[GrafikaSeg:I];
  For I:=0 to 999 do mem[RLESeg:I+8000]:=mem[Barvy4Seg:I];
  For I:=0 to 47 do mem[RLESeg:I+9000]:=mem[PaletaSeg:I];
  mem[RLESeg:9048]:=CisloStranky;
End;


Function GetHDDByte: Byte;
Var ReadByte: Byte;
Begin
  BlockRead(F,ReadByte,1);
  GetHDDByte:=ReadByte;
End;


Procedure RLEDekompress;
Var
  WritedBA: Byte; {znak A}
  WritedBB: Byte; {je-li komprese tak stejny jako znak A}
  WritedBC: Byte; {pocet kolikrat tam je znak A }
  I,A,posun: Word;
Begin
    I:=0; posun:=0;
    While not (posun=RLEDelka) do
    Begin

      WritedBA:=GetHDDByte;                  {nacteme A}
      Inc(posun);
      If posun=RLEDelka then                 {je-li konec zapsat a BREAK}
      Begin
        mem[RLESeg:I]:=WritedBA;
        Break;
      End;

      WritedBB:=GetHDDByte;                {nacteme B}
      Inc(posun);

      If posun=RLEDelka then               {je-li konec zapsat a BREAK}
      Begin
        mem[RLESeg:I]:=WritedBA;
        mem[RLESeg:I+1]:=WritedBB;
        Break;
      End;

      If WritedBA=WritedBB then  {jsou-li dva stejne tzn. nasleduje pocet}
      Begin
        WritedBC:=GetHDDByte;    {muzeme nacist pocet}
        Inc(posun);
        For A:=1 to WritedBC do
        Begin
          mem[RLESeg:I]:=WritedBA; {zapisujeme WritedBC krat}
          Inc(I);
        End;
      End else {jsou dva ruzne}
      Begin
        mem[RLESeg:I]:=WritedBA;   {zapisme jeden a navrat nahoru}
        Inc(I);
        Dec(posun);         {posuneme index o jednu nazpet}
        Seek(F,FilePos(F)-1);
      End;

    End; {While End}
End;


Procedure RLEKompress(number: Word);
Var
  WritedBA: Byte; {znak A}
  WritedBB: Byte; {je-li komprese tak stejny jako znak A}
  WritedBC: Byte; {pocet kolikrat tam je znak A}
  I,A,delka: Word;
  Stejne: Boolean;
Begin
  I:=0; A:=0;
  Repeat
    Stejne:=False;

    If I=number-1 then
    Begin
      mem[RLEKompressedSeg:A]:=mem[RLESeg:I];
      Inc(A);
      Break;
    End;

    While (mem[RLESeg:I]<>mem[RLESeg:I+1]) and (I<number-1) do
    Begin
      mem[RLEKompressedSeg:A]:=mem[RLESeg:I]; {zapis stav 1 kazdy bajt jiny}
      Inc(I);                          {inkrementujeme index pole I}
      Inc(A);                          {inkrementujeme index zabaleneho pole}
    End;

    delka:=1; {zjistujeme kolik bajtu nasleduje za sebou stejnych}
    While (mem[RLESeg:I]=mem[RLESeg:I+delka]) and (delka<255) and (I+delka<number-1) do
    Begin
      Inc(delka);
      Stejne:=True;
    End;

    If Stejne=True then
    Begin
      WritedBA:=mem[RLESeg:I];
      WritedBB:=mem[RLESeg:I];
      WritedBC:=delka;
      mem[RLEKompressedSeg:A]:=WritedBA;
      mem[RLEKompressedSeg:A+1]:=WritedBB;
      mem[RLEKompressedSeg:A+2]:=WritedBC;
      Inc(I,delka);
      Inc(A,3);
    End;

  Until I=number;

  RLEdelka:=A;
End;


Procedure Rozkodovat;
Var Offset32,Offset2,Xa,Ya,X1,Y1,x,y,A,I: Word;
    GrafikaW,GrafikaX: Word;
    BarvyW,BarvyX: Word;
Begin
  {Rozkodovani grafiky 8000B}
  A:=0; I:=0;
  Repeat
    GrafikaW:=memW[GrafikaSeg:I];
    GrafikaX:=GrafikaW AND 3;     {0000 0000 0000 0011}
    mem[Buffer[0]:A+0]:=GrafikaX;
    GrafikaX:=GrafikaW AND 12;    {0000 0000 0000 1100}
    mem[Buffer[0]:A+1]:=GrafikaX SHR 2;
    GrafikaX:=GrafikaW AND 48;    {0000 0000 0011 0000}
    mem[Buffer[0]:A+2]:=GrafikaX SHR 4;
    GrafikaX:=GrafikaW AND 192;   {0000 0000 1100 0000}
    mem[Buffer[0]:A+3]:=GrafikaX SHR 6;
    GrafikaX:=GrafikaW AND 768;   {0000 0011 0000 0000}
    mem[Buffer[0]:A+4]:=GrafikaX SHR 8;
    GrafikaX:=GrafikaW AND 3072;  {0000 1100 0000 0000}
    mem[Buffer[0]:A+5]:=GrafikaX SHR 10;
    GrafikaX:=GrafikaW AND 12288; {0011 0000 0000 0000}
    mem[Buffer[0]:A+6]:=GrafikaX SHR 12;
    GrafikaX:=GrafikaW AND 49152; {1100 0000 0000 0000}
    mem[Buffer[0]:A+7]:=GrafikaX SHR 14;
    Inc(A,8);
    Inc(I,2);
  Until I=8000;
  {Rozkodovani barvy4 2000B}
  A:=0; I:=0;
  Repeat
    BarvyW:=memW[Barvy4Seg:I];
    BarvyX:=BarvyW AND 15;       {0000 0000 0000 1111}
    mem[BufferSeg2:A+0]:=BarvyX;
    BarvyX:=BarvyW AND 240;      {0000 0000 1111 0000}
    mem[BufferSeg2:A+1]:=BarvyX SHR 4;
    BarvyX:=BarvyW AND 3840;     {0000 1111 0000 0000}
    mem[BufferSeg2:A+2]:=BarvyX SHR 8;
    BarvyX:=BarvyW AND 61440;    {1111 0000 0000 0000}
    mem[BufferSeg2:A+3]:=BarvyX SHR 12;
    Inc(A,4);
    Inc(I,2);
  Until I=1000;
  {Nahravani palety RGB ze souboru}
  A:=0;
  For I:=0 to 15 do
  Begin
    Barva[I].R:=mem[PaletaSeg:A+0];
    Barva[I].G:=mem[PaletaSeg:A+1];
    Barva[I].B:=mem[PaletaSeg:A+2];
    Inc(A,3);
  End;
  {Nastaveni palety RGB - nutny graficky rezim}
  For I:=0 to 15 do SetPal(CisloStranky*16+I,Barva[I].R,Barva[I].G,Barva[I].B);
  For I:=0 to 31999 do mem[Bity:I]:=mem[Buffer[0]:I];
  {Nastaveni spravnych barev 160x200 po krocich 8x8}
  For Ya:=0 to 24 do
  For Xa:=0 to 19 do
  Begin
    For y:=0 to 7 do
    For x:=0 to 7 do
    Begin
      X1:=(Xa*8+x) div 8;
      Y1:=(Ya*8+y) div 8;
      Offset2:=(Y1*20+X1)*4;
      Offset32:=((Ya*8+y)*160)+(Xa*8+x);
      Case mem[Buffer[0]:Offset32] of
        0: Begin
             If mem[BufferSeg2:Offset2+0]>0
             then mem[Buffer[0]:Offset32]:=mem[BufferSeg2:Offset2+0]+(CisloStranky*16)
             else mem[Buffer[0]:Offset32]:=0;
           End;
        1: Begin
             If mem[BufferSeg2:Offset2+1]>0
             then mem[Buffer[0]:Offset32]:=mem[BufferSeg2:Offset2+1]+(CisloStranky*16)
             else mem[Buffer[0]:Offset32]:=0;
           End;
        2: Begin
             If mem[BufferSeg2:Offset2+2]>0
             then mem[Buffer[0]:Offset32]:=mem[BufferSeg2:Offset2+2]+(CisloStranky*16)
             else mem[Buffer[0]:Offset32]:=0;
           End;
        3: Begin
             If mem[BufferSeg2:Offset2+3]>0
             then mem[Buffer[0]:Offset32]:=mem[BufferSeg2:Offset2+3]+(CisloStranky*16)
             else mem[Buffer[0]:Offset32]:=0;
           End;
      End; {Case End}
    End;
  End;
End;


Procedure Zakodovat;
Var A,I: Word;
Begin
  A:=0; I:=0;
  Repeat
    Dec2Bin(mem[Buffer[0]:A+0]); c[0]:=b[0]; c[1]:=b[1];
    Dec2Bin(mem[Buffer[0]:A+1]); c[2]:=b[0]; c[3]:=b[1];
    Dec2Bin(mem[Buffer[0]:A+2]); c[4]:=b[0]; c[5]:=b[1];
    Dec2Bin(mem[Buffer[0]:A+3]); c[6]:=b[0]; c[7]:=b[1];
    mem[GrafikaSeg:I]:=Bin2Dec(c[7],c[6],c[5],c[4],c[3],c[2],c[1],c[0]);
    Inc(A,4);
    Inc(I);
  Until I=8000;
  A:=0; I:=0;
  Repeat
    Dec2Bin(mem[BufferSeg2:A+0]); c[0]:=b[0]; c[1]:=b[1]; c[2]:=b[2]; c[3]:=b[3];
    Dec2Bin(mem[BufferSeg2:A+1]); c[4]:=b[0]; c[5]:=b[1]; c[6]:=b[2]; c[7]:=b[3];
    mem[Barvy4Seg:I]:=Bin2Dec(c[7],c[6],c[5],c[4],c[3],c[2],c[1],c[0]);
    Inc(A,2);
    Inc(I);
  Until I=1000;
  A:=0;
  For I:=0 to 15 do
  Begin
    mem[PaletaSeg:A+0]:=Barva[I].R;
    mem[PaletaSeg:A+1]:=Barva[I].G;
    mem[PaletaSeg:A+2]:=Barva[I].B;
    Inc(A,3);
  End;
End;


Procedure LoadGRPage(JmenoSouboru:string;Pozice:LongInt);
Var I: Word;
    WritedByte: Byte;
Begin
  Assign(F,JmenoSouboru);
  Reset(F,1);
  Seek(F,Pozice);
  BlockRead(F,RLEdelka,2);
  RLEDekompress;
  MovArraysTo3;
  Rozkodovat;
  Close(F);
End;


Procedure SaveGrPage(JmenoSouboru:string);
Var I: Word;
    WritedByte: Byte;
Begin
  For I:=0 to 31999 do mem[Buffer[0]:I]:=mem[Bity:I];
  Assign(F,JmenoSouboru);
  ReWrite(F,1);
  Zakodovat;
  MovArraysToOne;
  RLEKompress(9049);
  BlockWrite(F,RLEDelka,2);
  For I:=1 to RLEDelka do
  Begin
    WritedByte:=mem[RLEKompressedSeg:I-1];
    BlockWrite(F,WritedByte,1);
  End;
  Close(F);
End;


Procedure LoadBmpFile(JmenoSouboru: string; pozice: LongInt; StartColor: Byte);
Var
  I,N: LongInt;
  Pixel1: Byte;
  Pixel2: Byte;
Begin
  Assign(F,JmenoSouboru);
  Reset(F,1);
  Seek(F,pozice);

  {Header}
  BlockRead(F,BMP.Header,54);

  {Palette}
  For I:=0 to 15 do
  Begin
    BlockRead(F,BMP.Palette[I].B,1);
    BlockRead(F,BMP.Palette[I].G,1);
    BlockRead(F,BMP.Palette[I].R,1);
    BlockRead(F,BMP.Palette[I].Reserved,1);
    BMP.Palette[I].B:=BMP.Palette[I].B DIV 4;
    BMP.Palette[I].G:=BMP.Palette[I].G DIV 4;
    BMP.Palette[I].R:=BMP.Palette[I].R DIV 4;
    SetPal(StartColor+I,BMP.Palette[I].R,BMP.Palette[I].G,BMP.Palette[I].B);
  End;

  {Data}
  N:=0;
  For I:=0 to (BMP.Header.ImageSize-1) do
  Begin
    BlockRead(F,BMP.DataByte,1);
    Pixel1:=(BMP.DataByte SHR 4);
    Pixel2:=(BMP.DataByte AND 15);
    mem[Buffer[0]:N]:=StartColor+Pixel1;
    mem[Buffer[0]:N+1]:=StartColor+Pixel2;
    Inc(N,2);
  End;

  Close(F);
End;


Procedure LoadBmpFile256(JmenoSouboru: string; pozice: LongInt;X,Y,BufferTo: Word);
Var
  I,N: LongInt;
  Xa,Ya: Word;
  Offset: Word;
Begin
  Assign(F,JmenoSouboru);
  Reset(F,1);
  Seek(F,pozice);

  {Header}
  BlockRead(F,BMP.Header,54);

  {Palette}
  For I:=0 to 255 do
  Begin
    BlockRead(F,BMP.Palette[I].B,1);
    BlockRead(F,BMP.Palette[I].G,1);
    BlockRead(F,BMP.Palette[I].R,1);
    BlockRead(F,BMP.Palette[I].Reserved,1);
    BMP.Palette[I].B:=BMP.Palette[I].B DIV 4;
    BMP.Palette[I].G:=BMP.Palette[I].G DIV 4;
    BMP.Palette[I].R:=BMP.Palette[I].R DIV 4;
    SetPal(I,BMP.Palette[I].R,BMP.Palette[I].G,BMP.Palette[I].B);
  End;

  {Data}
  For Ya:=BMP.Header.RozsahY-1 downto 0 do
  For Xa:=0 to BMP.Header.RozsahX-1 do
  Begin
    BlockRead(F,BMP.DataByte,1);
    Offset:=((Y+Ya)*320)+(X+Xa);
    mem[BufferTo:Offset]:=BMP.DataByte;
  End;

  Close(F);
End;


Procedure LoadBlok(x1,y1,x2,y2,x3,y3,BufferTo: Word);
Var Xa,Ya,x,y,Offset1,Offset2: Word;
Begin
  Xa:=x1; Ya:=y1;
  For y:=y2 to y3 do
  Begin
    For x:=x2 to x3 do
    Begin
      Offset1:=Ya*320+Xa; Offset2:=y*160+x;
      mem[BufferTo:Offset1]:=mem[Buffer[0]:Offset2];
      inc(Xa);
    End;
    Xa:=x1; Inc(Ya);
  End;
End;


Procedure LoadBlokM(x1,y1,x2,y2,x3,y3,BufferTo: Word);
Var Xa,Ya,x,y,Offset1,Offset2: Word;
Begin
  Xa:=x1; Ya:=y1;
  For y:=y2 to y3 do
  Begin
    For x:=x3 downto x2 do
    Begin
      Offset1:=Ya*320+Xa; Offset2:=y*160+x;
      mem[BufferTo:Offset1]:=mem[Buffer[0]:Offset2];
      inc(Xa);
    End;
    Xa:=x1; Inc(Ya);
  End;
End;


Procedure LoadBitMap(X,Y: Word; BufferTo: Word);
Var xa,ya: Word;
    Offset1: Word;
    Offset2: Word;
Begin
  Offset2:=0;
  For ya:=(BMP.Header.RozsahY-1) downto 0 do
  For xa:=0 to (BMP.Header.RozsahX-1) do
  Begin
    Offset1:=((Y+ya)*320+(X+xa));
    mem[BufferTo:Offset1]:=mem[Buffer[0]:Offset2];
    Inc(Offset2);
  End;
End;


Procedure LoadBitMapM(X,Y: Word; BufferTo: Word);
Var xa,ya: Word;
    Offset1: Word;
    Offset2: Word;
Begin
  Offset2:=0;
  For ya:=(BMP.Header.RozsahY-1) downto 0 do
  For xa:=(BMP.Header.RozsahX-1) downto 0 do
  Begin
    Offset1:=((Y+ya)*320+(X+xa));
    mem[BufferTo:Offset1]:=mem[Buffer[0]:Offset2];
    Inc(Offset2);
  End;
End;


Function ReadPixel(X,Y,Buffer:Word): Byte;
Begin
  ReadPixel:=mem[Buffer:Y*320+X];
End;


Procedure WritePixel(X:Word;Y,Color:Byte;Buffer:Word); Assembler;
Asm
  MOV AX, Buffer
  MOV ES, AX

  XOR AX, AX
  INC AX
  SHL AX, 8
  XOR CX, CX
  INC CX
  SHL CX, 6
  ADD AX, CX

  XOR BX, BX
  MOV BL, Y
  MUL BX
  MOV CX, X
  ADD AX, CX

  MOV DI, AX
  XOR AX, AX
  MOV AL, Color
  STOSB
End;


Procedure Blok(x1,y1,x2,y2,Color,Buffer:Word); external;


Procedure Ramecek(X1,Y1,X2,Y2:Word;Color:Byte;Buffer:Word); Assembler;
Asm
  MOV AX, Buffer
  MOV ES, AX

  XOR AX, AX
  INC AX
  SHL AX, 8
  XOR CX, CX
  INC CX
  SHL CX, 6
  ADD AX, CX
  MOV SI, AX

  MOV BX, y1
  MUL BX
  MOV CX, x1
  ADD AX, CX
  MOV DI, AX

  XOR AX, AX
  MOV AL, Color

  MOV DX, x2
  MOV CX, x1
  SUB DX, CX

  MOV CX, DX
  INC CX
@cyklus1:
  STOSB
  LOOP @cyklus1
  DEC DI
  SUB DI, DX
  ADD DI, SI

  MOV CX, y2
  MOV BX, y1
  SUB CX, BX
  DEC CX
@cyklus2:
  STOSB
  DEC DI
  ADD DI, DX
  STOSB
  DEC DI
  SUB DI, DX
  ADD DI, SI
  LOOP @cyklus2

  MOV CX, DX
  INC CX
@cyklus3:
  STOSB
  LOOP @cyklus3
End;


Procedure WriteBlok(x1,y1,x2,y2,x3,y3,BufferFrom,BufferTo: Word); external;


Procedure WriteSprite(x1,y1,x2,y2,x3,y3,BufferFrom,BufferTo: Word); Assembler;
Asm
  PUSH DS

@testing:
  MOV DX, x3
  MOV CX, x2
  SUB DX, CX {DX=delka}
  INC DX
  TEST DX, 0000000000000001b
  JNE @odd

@even:
  MOV AX, BufferTo
  MOV ES, AX
  MOV AX, BufferFrom
  MOV DS, AX

  XOR AX, AX
  INC AX
  SHL AX, 8
  XOR CX, CX
  INC CX
  SHL CX, 6
  ADD AX, CX {AX=320}
  PUSH AX

  MOV BX, y1
  MUL BX
  MOV CX, x1
  ADD AX, CX
  MOV DI, AX {ES:DI BufferTo}

  POP AX
  MOV BX, y2
  MUL BX
  MOV CX, x2
  ADD AX, CX
  MOV SI, AX {DS:SI BufferFrom}

  MOV BX, y3
  MOV DX, y2
  SUB BX, DX {BX=vyska}
  INC BX

@cyklus2:
  MOV DX, x3
  MOV CX, x2
  SUB DX, CX {DX=delka}
  INC DX
  SHR DX, 1

  MOV CX, DX
@cyklus1:
  PUSH BX
  XOR BX, BX
  LODSW
  CMP AX, BX
  JE @je_nulaW
  JNE @neni_nulaW

@je_nulaW:
  INC DI
  INC DI
  JMP @konec

@neni_nulaW:
  CMP AL, BL
  JE @prvnibajt
  CMP AH, BL
  JE @druhybajt
  JMP @oba2bajty

@prvnibajt:
  INC DI
  CMP AH, BL
  JE @equal1
  JMP @equal2
@equal1:
  INC DI
  JMP @konec
@equal2:
  DEC SI
  MOVSB
  JMP @konec

@druhybajt:
  DEC SI
  DEC SI
  MOVSB
  INC DI
  INC SI
  JMP @konec

@oba2bajty:
  DEC SI
  DEC SI
  MOVSW

@konec:
  POP BX
  LOOP @cyklus1
  MOV CX, BX
  SHL DX, 1
  SUB DI, DX
  ADD DI, 320
  SUB SI, DX
  ADD SI, 320
  SHR DX, 1
  DEC BX
  LOOP @cyklus2
  JMP @final

@odd:
  MOV AX, BufferTo
  MOV ES, AX
  MOV AX, BufferFrom
  MOV DS, AX

  XOR AX, AX
  INC AX
  SHL AX, 8
  XOR CX, CX
  INC CX
  SHL CX, 6
  ADD AX, CX {AX=320}
  PUSH AX

  MOV BX, y1
  MUL BX
  MOV CX, x1
  ADD AX, CX
  MOV DI, AX {ES:DI BufferTo}
  MOV DX, x3
  MOV CX, x2
  SUB DX, CX {DX=delka}
  ADD DI, DX

  POP AX
  MOV BX, y2
  MUL BX
  MOV CX, x2
  ADD AX, CX
  MOV SI, AX {DS:SI BufferFrom}
  MOV DX, x3
  MOV CX, x2
  SUB DX, CX {DX=delka}
  ADD SI, DX

  MOV CX, y3
  MOV DX, y2
  SUB CX, DX {CX=vyska}
  INC CX

  XOR BL, BL
@cyklus3:
  LODSB  {DS:SI -> AL}
  CMP AL, BL
  JE @je_nulaB
  JNE @neni_nulaB

@je_nulaB:
  DEC SI
  ADD SI, 320
  ADD DI, 320
  JMP @konec_nulaB

@neni_nulaB:
  STOSB
  DEC SI
  ADD SI, 320
  DEC DI
  ADD DI, 320

@konec_nulaB:
  LOOP @cyklus3

  JMP @even

@final:
  POP DS
End;


Procedure WriteGraphics(X,Y,MapXview,MapYview:LongInt;x1,y1,x2,y2,BufferFrom,BufferTo:Word);
Var OnScrX1: Word;
    OnScrY1: Word;
    OnScrX2: Word;
    OnScrY2: Word;
    Vykreslovat: Boolean;
    ShowX,ShowY: Word;
Begin
  Vykreslovat:=True;

  {Test jestli je na obrazovce v ose X}
  If ((X>MapXview) and ((X+(x2-x1))<MapXview+320))
  then Begin
         ShowX:=X-MapXview;
         OnScrX1:=x1;
         OnScrX2:=x2;
       End
  else Begin
         If X<=MapXview then {levy okraj}
         Begin
           If (X+(x2-x1))<=MapXview
           then Begin {neni videt vubec}
                  Vykreslovat:=False;
                End
           else Begin {je videt kousek}
                  ShowX:=0;
                  OnScrX1:=x1+MapXview-X;
                  OnScrX2:=x2;
                End;
         End;
         If (X+(x2-x1))>=MapXview+320 then {pravy okraj}
         Begin
           If X>=MapXview+320
           then Begin {neni videt vubec}
                  Vykreslovat:=False;
                End
           else Begin {je videt kousek}
                  ShowX:=X-MapXview;
                  OnScrX1:=x1;
                  OnScrX2:=x1+MapXview+320-X;
                End;
         End;
       End;

  {Test jestli je na obrazovce v ose Y}
  If ((Y>MapYview) and ((Y+(y2-y1))<MapYview+200))
  then Begin
         ShowY:=Y-MapYview;
         OnScrY1:=y1;
         OnScrY2:=y2;
       End
  else Begin
         If Y<=MapYview then {horni okraj}
         Begin
           If (Y+(y2-y1))<=MapYview
           then Begin {neni videt vubec}
                  Vykreslovat:=False;
                End
           else Begin {je videt kousek}
                  ShowY:=0;
                  OnScrY1:=y1+MapYview-Y;
                  OnScrY2:=y2;
                End;
         End;
         If (Y+(y2-y1))>=MapYview+200 then {dolni okraj}
         Begin
           If Y>=MapYview+200
           then Begin {neni videt vubec}
                  Vykreslovat:=False;
                End
           else Begin {je videt kousek}
                  ShowY:=Y-MapYview;
                  OnScrY1:=y1;
                  OnScrY2:=y1+MapYview+200-Y;
                End;
         End;
       End;

  If Vykreslovat=True then WriteSprite(ShowX,ShowY,OnScrX1,OnScrY1,OnScrX2,OnScrY2,BufferFrom,BufferTo);
End;


Procedure LoadDefaultFont(x1,y1,Color,BufferTo: Word);
Var
  FontBufP: Pointer;
  FontBufSeg: Word;
  A,I,N: Word;
  X,Y: Word;
Begin
  GetMem(FontBufP,1024);
  FontBufSeg:=Seg(FontBufP^);
  A:=0;
  For I:=0 to 124 do
  Begin
    Dec2Bin(DefaultFont[I]);
    For N:=0 to 7 do
    If b[N]>0 then mem[FontBufSeg:A+(7-N)]:=Color
              else mem[FontBufSeg:A+(7-N)]:=0;
    Inc(A,8);
  End;
  I:=0;
  For Y:=0 to 19 do
  For X:=0 to 49 do
  Begin
    WritePixel(x1+X,y1+Y,mem[FontBufSeg:I],BufferTo);
    Inc(I);
  End;
  FreeMem(FontBufP,1024);
End;


Procedure WriteZnak(FontBuffer,FontX,FontY,FontDelka,FontVyska,x,y:Word;Znak:Char;BufferTo:Word);
Var radek,N,zn: Byte;
Begin
  zn:=Ord(Znak);

  If ((zn>=97) and (zn<124)) then
  Begin
    If (zn>=97) and (zn<107) then {a..j , 1.radek}
    Begin
      N:=zn-97;
      radek:=0;
    End;
    If ((zn>=107) and (zn<117)) then {k..t , 2.radek}
    Begin
      N:=zn-107;
      radek:=1;
    End;
    If ((zn>=117) and (zn<124)) then {u..z , 3.radek}
    Begin
      N:=zn-117;
      radek:=2;
    End;
    WriteSprite(x,y,FontX+N*FontDelka,FontY+radek*FontVyska,
                    FontX+N*FontDelka+(FontDelka-1),FontY+radek*FontVyska+(FontVyska-1),
                    FontBuffer,BufferTo);
  End;

  If ((zn>=48) and (zn<58)) then {0..9 , 4.radek}
  Begin
    N:=zn-48;
    radek:=3;
    WriteSprite(x,y,FontX+N*FontDelka,FontY+radek*FontVyska,
                    FontX+N*FontDelka+(FontDelka-1),FontY+radek*FontVyska+(FontVyska-1),
                    FontBuffer,BufferTo);
  End;

  If zn=61 then {=}
  WriteSprite(x,y,FontX+6*FontDelka,FontY+2*FontVyska,FontX+6*FontDelka+(FontDelka-1),FontY+2*FontVyska+(FontVyska-1),
  FontBuffer,BufferTo);

  If zn=43 then {+}
  WriteSprite(x,y,FontX+7*FontDelka,FontY+2*FontVyska,FontX+7*FontDelka+(FontDelka-1),FontY+2*FontVyska+(FontVyska-1),
  FontBuffer,BufferTo);

  If zn=45 then {-}
  WriteSprite(x,y,FontX+8*FontDelka,FontY+2*FontVyska,FontX+8*FontDelka+(FontDelka-1),FontY+2*FontVyska+(FontVyska-1),
  FontBuffer,BufferTo);

  If zn=47 then {/}
  WriteSprite(x,y,FontX+9*FontDelka,FontY+2*FontVyska,FontX+9*FontDelka+(FontDelka-1),FontY+2*FontVyska+(FontVyska-1),
  FontBuffer,BufferTo);
End;


Procedure WriteText(FontBuffer,FontX,FontY,FontDelka,FontVyska,mezera,x,y:Word;retezec:string;BufferTo:Word);
Var I: Word;
    posuv:Byte;
    Ordinal: Byte;
Begin
  posuv:=FontDelka+mezera;
  For I:=1 to Length(retezec) do
  Begin
    Ordinal:=Ord(retezec[I]);
    WriteZnak(FontBuffer,FontX,FontY,FontDelka,FontVyska,X,Y,retezec[I],BufferTo);
    Inc(X,posuv);
  End;
End;


Procedure WriteNumber(FontBuffer,FontX,FontY,FontDelka,FontVyska,mezera,x,y:Word;Cislo:Longint;BufferTo:Word);
Var MZbytek,MRozdil,delitel: Longint;
    Zapisovat:Boolean;
    posuv,pocet:Byte;
Begin
  posuv:=0;
  Zapisovat:=False;
  delitel:=1000000;
  For pocet:=0 to 6 do
  Begin
    If delitel>0 then
    Begin
      MRozdil:=Cislo div delitel;
      MZbytek:=Cislo mod delitel;
    End else
    Begin
      MRozdil:=0;
      MZbytek:=0;
    End;
    If MRozdil>0 then Zapisovat:=True;
    If Zapisovat=True then
    Begin
      WriteSprite(x+posuv,y,FontX+(MRozdil*FontDelka),FontY,FontX+(MRozdil*FontDelka)+FontDelka-1,FontY+FontVyska-1,
      FontBuffer,BufferTo);
      Inc(posuv,FontDelka+mezera);
    End;
    Cislo:=MZbytek;
    If delitel>0 then delitel:=delitel div 10;
  End;
  If (Zapisovat=False) And (MRozdil=0) then
  WriteSprite(x+posuv,y,FontX+(MRozdil*FontDelka),FontY,FontX+(MRozdil*FontDelka)+FontDelka-1,FontY+FontVyska-1,
  FontBuffer,BufferTo);
End;


Procedure Line(a,b,c,d:integer;barva,BufferTo:word);

  function sgn(a:real):integer;
  begin
    if a>0 then sgn:=1
    else
      if a<0 then sgn:=-1
      else sgn:=0;
  end;

var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
begin
  u:= c-a;
  v:= d-b;
  d1x:= sgn(u);
  d1y:= sgn(v);
  m:= abs(u);
  n:= abs(v);
  if not(m>n) then
    begin
      d2x:= 0;
      d2y:= d1y;
      i:=m;
      m:=n;
      n:=i;
    end
  else
    begin
      d2x:= d1x;
      d2y:= 0;
    end;
  s:= m shr 1;
  for i:=0 to m do
    begin
      WritePixel(a,b,barva,BufferTo);
      s:= s+n;
      if not(s<m) then
        begin
          s:= s-m;
          a:= a+d1x;
          b:= b+d1y;
        end
      else
        begin
          a:= a+d2x;
          b:= b+d2y;
        end;
    end;
end;


Procedure FlipPage(BufferFrom,BufferTo: Word); external;


Procedure ClearPage(Buffer:Word); external;


{SECTION MOVEMENT XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Function GetLineX(a,b,c,d:integer;Vzdalenost:Word): Word;

  function sgn(a:real):integer;
  begin
    if a>0 then sgn:=1
    else
      if a<0 then sgn:=-1
      else sgn:=0;
  end;

var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
    ErrorOutput,vzd2: Word;
begin
  vzd2:=0;
  u:= c-a;
  v:= d-b;
  d1x:= sgn(u);
  d1y:= sgn(v);
  m:= abs(u);
  n:= abs(v);
  if not(m>n) then
    begin
      d2x:= 0;
      d2y:= d1y;
      i:=m;
      m:=n;
      n:=i;
    end
  else
    begin
      d2x:= d1x;
      d2y:= 0;
    end;
  s:= m shr 1;
  for i:=0 to m do
    begin
      Inc(vzd2);
      If vzd2=Vzdalenost then GetLineX:=a;
      ErrorOutput:=a;
      s:= s+n;
      if not(s<m) then
        begin
          s:= s-m;
          a:= a+d1x;
          b:= b+d1y;
        end
      else
        begin
          a:= a+d2x;
          b:= b+d2y;
        end;
    end;
  If Vzdalenost>vzd2 then GetLineX:=ErrorOutput;
end;


Function GetLineY(a,b,c,d:integer;Vzdalenost:Word): Word;

  function sgn(a:real):integer;
  begin
    if a>0 then sgn:=1
    else
      if a<0 then sgn:=-1
      else sgn:=0;
  end;

var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
    ErrorOutput,vzd2: Word;
begin
  vzd2:=0;
  u:= c-a;
  v:= d-b;
  d1x:= sgn(u);
  d1y:= sgn(v);
  m:= abs(u);
  n:= abs(v);
  if not(m>n) then
    begin
      d2x:= 0;
      d2y:= d1y;
      i:=m;
      m:=n;
      n:=i;
    end
  else
    begin
      d2x:= d1x;
      d2y:= 0;
    end;
  s:= m shr 1;
  for i:=0 to m do
    begin
      Inc(vzd2);
      If vzd2=Vzdalenost then GetLineY:=b;
      ErrorOutput:=b;
      s:= s+n;
      if not(s<m) then
        begin
          s:= s-m;
          a:= a+d1x;
          b:= b+d1y;
        end
      else
        begin
          a:= a+d2x;
          b:= b+d2y;
        end;
    end;
  If Vzdalenost>vzd2 then GetLineY:=ErrorOutput;
end;


{SECTION KOLIZE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Function Inside(x,y,x1,y1,x2,y2: LongInt): Boolean;
Begin
  Inside:=False;
  If (((x>=x1) and (x<=x2)) and ((y>=y1) and (y<=y2))) then Inside:=True;
End;


Function Plosina(x,y,x1,x2,plosinaY: LongInt): Boolean;
Begin
  If (((x>=x1) and (x<=x2)) and (y=plosinaY)) then Plosina:=True;
End;


{SECTION TEXTER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure InitTexter(Barva:Byte);
Var Offset,I,A: Word;
Begin
  GetMem(BufferC,1435); BufferSegC:=Seg(BufferC^); {205=delka*7=vyska=1435B}
  For I:=0 to 1434 do mem[BufferSegC:I]:=0; {vymaz bufferu}
  GetMem(BufferC1,350); BufferSegC1:=Seg(BufferC1^); {50=delka*7=vyska=350B}
  For I:=0 to 349 do mem[BufferSegC1:I]:=0; {vymaz bufferu C1 cifry}
  GetMem(BufferC2,280); BufferSegC2:=Seg(BufferC2^); {40=delka*7=vyska=280B}
  For I:=0 to 279 do mem[BufferSegC2:I]:=0; {vymaz bufferu C2 small cifry}
  GetMem(BufferC3,1056); BufferSegC3:=Seg(BufferC3^); {40=delka*7=vyska=280B}
  For I:=0 to 1055 do mem[BufferSegC3:I]:=0; {vymaz bufferu C3 small znaky}

  TexterColor:=Barva;
  For I:=0 to 204 do
  Begin
    Dec2Bin(Znaky[I]);
    For A:=7 downto 0 do
    If b[A]=1 then mem[BufferSegC:205*(7-A)+I]:=TexterColor;
  End;

  For I:=0 to 49 do
  Begin
    Dec2Bin(Cifry[I]);
    For A:=7 downto 0 do
    If b[A]=1 then mem[BufferSegC1:50*(7-A)+I]:=TexterColor;
  End;

  For I:=0 to 39 do
  Begin
    Dec2Bin(SmallCifry[I]);
    For A:=7 downto 0 do
    If b[A]=1 then mem[BufferSegC2:40*(7-A)+I]:=TexterColor;
  End;

  For I:=0 to 131 do
  Begin
    Dec2Bin(SmallZnaky[I]);
    For A:=7 downto 0 do
    If b[A]=1 then mem[BufferSegC3:132*(7-A)+I]:=TexterColor;
  End;
End;


Procedure ShutdownTexter;
Begin
  FreeMem(BufferC,1435);
  FreeMem(BufferC1,350);
  FreeMem(BufferC2,280);
  FreeMem(BufferC3,1056);
End;


Procedure ChangeTexterColor(Barva:Byte);
Var I: Word;
Begin
  For I:=0 to 1434 do If mem[BufferSegC:I]<>0  then mem[BufferSegC:I]:=Barva;
  For I:=0 to 349  do If mem[BufferSegC1:I]<>0 then mem[BufferSegC1:I]:=Barva;
  For I:=0 to 279  do If mem[BufferSegC2:I]<>0 then mem[BufferSegC2:I]:=Barva;
  For I:=0 to 1055 do If mem[BufferSegC3:I]<>0 then mem[BufferSegC3:I]:=Barva;
End;


Procedure WriteTexterSprite1(x1,y1,x2,y2,x3,y3,BufferTo:Word); Assembler;
Asm
  PUSH DS
  MOV AX, BufferTo
  MOV ES, AX
  MOV AX, BufferSegC
  MOV DS, AX

  XOR AX, AX
  INC AX
  SHL AX, 8
  XOR CX, CX
  INC CX
  SHL CX, 6
  ADD AX, CX {AX=320}

  MOV BX, y1
  MUL BX
  MOV CX, x1
  ADD AX, CX
  MOV DI, AX {ES:DI BufferTo}

  MOV AX, 205
  MOV BX, y2
  MUL BX
  MOV CX, x2
  ADD AX, CX
  MOV SI, AX {DS:SI BufferFrom}

  MOV BX, y3
  MOV DX, y2
  SUB BX, DX {BX=vyska}
  INC BX

@cyklus2:
  MOV DX, x3
  MOV CX, x2
  SUB DX, CX {DX=delka}
  INC DX

  MOV CX, DX
@cyklus1:
  PUSH BX
  XOR BL, BL
  LODSB
  CMP AL, BL
  JE @je_nula

  DEC SI
  MOVSB
  JMP @konec

@je_nula:
  INC DI

@konec:
  POP BX
  LOOP @cyklus1
  MOV CX, BX
  SUB DI, DX
  ADD DI, 320
  SUB SI, DX
  ADD SI, 205
  DEC BX
  LOOP @cyklus2

  POP DS
End;


Procedure WriteTexterSprite2(x1,y1,x2,y2,x3,y3,BufferTo:Word); Assembler;
Asm
  PUSH DS
  MOV AX, BufferTo
  MOV ES, AX
  MOV AX, BufferSegC3
  MOV DS, AX

  XOR AX, AX
  INC AX
  SHL AX, 8
  XOR CX, CX
  INC CX
  SHL CX, 6
  ADD AX, CX {AX=320}

  MOV BX, y1
  MUL BX
  MOV CX, x1
  ADD AX, CX
  MOV DI, AX {ES:DI BufferTo}

  MOV AX, 132
  MOV BX, y2
  MUL BX
  MOV CX, x2
  ADD AX, CX
  MOV SI, AX {DS:SI BufferFrom}

  MOV BX, y3
  MOV DX, y2
  SUB BX, DX {BX=vyska}
  INC BX

@cyklus2:
  MOV DX, x3
  MOV CX, x2
  SUB DX, CX {DX=delka}
  INC DX

  MOV CX, DX
@cyklus1:
  PUSH BX
  XOR BL, BL
  LODSB
  CMP AL, BL
  JE @je_nula

  DEC SI
  MOVSB
  JMP @konec

@je_nula:
  INC DI

@konec:
  POP BX
  LOOP @cyklus1
  MOV CX, BX
  SUB DI, DX
  ADD DI, 320
  SUB SI, DX
  ADD SI, 132
  DEC BX
  LOOP @cyklus2

  POP DS
End;


Procedure WriteCifra(x,y:Word;Cislo:Byte;BufferTo:Word);
Var xa,ya,Offset:Word;
Begin
    For ya:=0 to 6 do
    Begin
      For xa:=0 to 4 do
      Begin
        Offset:=ya*50+((Cislo*5)+xa);
        If mem[BufferSegC1:Offset]>0 then
         mem[BufferTo:(y+ya)*320+(x+xa)]:=TexterColor;
      End;
    End;
End;


Procedure WriteSmallCifra(x,y:Word;Cislo:Byte;BufferTo:Word);
Var xa,ya,Offset:Word;
Begin
    For ya:=0 to 4 do
    Begin
      For xa:=0 to 3 do
      Begin
        Offset:=ya*40+((Cislo*4)+xa);
        If mem[BufferSegC2:Offset]>0 then
         mem[BufferTo:(y+ya)*320+(x+xa)]:=TexterColor;
      End;
    End;
End;


Procedure OutZnak(X,Y:Word;Znak:Char;BufferTo:Word);
Var Ordinal: Byte;
Begin
  Ordinal:=Ord(Znak);

  If Ordinal in [48..57] then {znaky 0..9}
  WriteCifra(X,Y+1,Ordinal-48,BufferTo);

  If Ordinal in [65..90] then {znaky A..Z}
  WriteTexterSprite1(X,Y+1,(Ordinal-65)*5,0,(Ordinal-65)*5+4,6,BufferTo);

  Case Ordinal of {ostatni znaky}

{+} 43: WriteTexterSprite1(X,Y+1,130,0,134,6,BufferTo);
{-} 45: WriteTexterSprite1(X,Y+1,135,0,139,6,BufferTo);
{*} 42: WriteTexterSprite1(X,Y+1,140,0,142,6,BufferTo);
{/} 47: WriteTexterSprite1(X,Y,143,0,149,6,BufferTo);
{:} 58: WriteTexterSprite1(X,Y+1,150,0,154,6,BufferTo);
{.} 46: WriteTexterSprite1(X,Y+1,155,0,155,6,BufferTo);
{,} 44: WriteTexterSprite1(X,Y+2,160,0,160,6,BufferTo);
{=} 61: WriteTexterSprite1(X,Y+1,165,0,169,6,BufferTo);
{?} 63: WriteTexterSprite1(X,Y+1,170,0,174,6,BufferTo);
{%} 37: WriteTexterSprite1(X,Y+1,175,0,179,6,BufferTo);
{!} 33: WriteTexterSprite1(X,Y+1,180,0,180,6,BufferTo);
{(} 40: WriteTexterSprite1(X,Y+1,185,0,189,6,BufferTo);
{)} 41: WriteTexterSprite1(X,Y+1,190,0,194,6,BufferTo);
{>} 62: WriteTexterSprite1(X,Y+1,195,0,199,6,BufferTo);
{<} 60: WriteTexterSprite1(X,Y+1,200,0,204,6,BufferTo);

{a}  97: WriteTexterSprite2(X,Y,0,0,5,7,BufferTo);
{b}  98: WriteTexterSprite2(X,Y,6,0,10,7,BufferTo);
{c}  99: WriteTexterSprite2(X,Y,11,0,15,7,BufferTo);
{d} 100: WriteTexterSprite2(X,Y,16,0,20,7,BufferTo);
{e} 101: WriteTexterSprite2(X,Y,21,0,25,7,BufferTo);
{f} 102: WriteTexterSprite2(X,Y,26,0,30,7,BufferTo);
{g} 103: WriteTexterSprite2(X,Y+2,31,0,35,7,BufferTo);
{h} 104: WriteTexterSprite2(X,Y,36,0,40,7,BufferTo);
{i} 105: WriteTexterSprite2(X,Y,41,0,43,7,BufferTo);
{j} 106: WriteTexterSprite2(X,Y+2,44,0,46,7,BufferTo);
{k} 107: WriteTexterSprite2(X,Y,47,0,50,7,BufferTo);
{l} 108: WriteTexterSprite2(X,Y,51,0,53,7,BufferTo);
{m} 109: WriteTexterSprite2(X,Y,54,0,59,7,BufferTo);
{n} 110: WriteTexterSprite2(X,Y,60,0,64,7,BufferTo);
{o} 111: WriteTexterSprite2(X,Y,65,0,69,7,BufferTo);
{p} 112: WriteTexterSprite2(X,Y+2,70,0,75,7,BufferTo);
{q} 113: WriteTexterSprite2(X,Y+2,76,0,81,7,BufferTo);
{r} 114: WriteTexterSprite2(X,Y,82,0,86,7,BufferTo);
{s} 115: WriteTexterSprite2(X,Y,87,0,91,7,BufferTo);
{t} 116: WriteTexterSprite2(X,Y,92,0,95,7,BufferTo);
{u} 117: WriteTexterSprite2(X,Y,96,0,101,7,BufferTo);
{v} 118: WriteTexterSprite2(X,Y,102,0,106,7,BufferTo);
{w} 119: WriteTexterSprite2(X,Y,107,0,113,7,BufferTo);
{x} 120: WriteTexterSprite2(X,Y,114,0,118,7,BufferTo);
{y} 121: WriteTexterSprite2(X,Y+2,119,0,123,7,BufferTo);
{z} 122: WriteTexterSprite2(X,Y,124,0,128,7,BufferTo);
{ } 160: Begin WriteTexterSprite2(X,Y,0,0,5,7,BufferTo); WriteTexterSprite2(X+3,Y,130,2,131,3,BufferTo); End;
{Ÿ} 159: Begin WriteTexterSprite2(X,Y,11,0,15,7,BufferTo); WriteTexterSprite2(X+1,Y,129,2,131,3,BufferTo); End;
{Ô} 212: Begin WriteTexterSprite2(X,Y,16,0,20,7,BufferTo); WriteTexterSprite2(X+1,Y-2,129,2,131,3,BufferTo); End;
{‚} 130: Begin WriteTexterSprite2(X,Y,21,0,25,7,BufferTo); WriteTexterSprite2(X+2,Y,130,2,131,3,BufferTo); End;
{Ø} 216: Begin WriteTexterSprite2(X,Y,21,0,25,7,BufferTo); WriteTexterSprite2(X+1,Y,129,2,131,3,BufferTo); End;
{¡} 161: Begin WriteTexterSprite2(X,Y,41,0,43,7,BufferTo); WriteTexterSprite2(X+1,Y+1,130,2,131,3,BufferTo); End;
{å} 229: Begin WriteTexterSprite2(X,Y,60,0,64,7,BufferTo); WriteTexterSprite2(X+1,Y,129,2,131,3,BufferTo); End;
{¢} 162: Begin WriteTexterSprite2(X,Y,65,0,69,7,BufferTo); WriteTexterSprite2(X+2,Y,130,2,131,3,BufferTo); End;
{ý} 253: Begin WriteTexterSprite2(X,Y,82,0,86,7,BufferTo); WriteTexterSprite2(X+1,Y,129,2,131,3,BufferTo); End;
{ç} 231: Begin WriteTexterSprite2(X,Y,87,0,91,7,BufferTo); WriteTexterSprite2(X+1,Y,129,2,131,3,BufferTo); End;
{œ} 156: Begin WriteTexterSprite2(X,Y,92,0,95,7,BufferTo); WriteTexterSprite2(X,Y-2,129,2,131,3,BufferTo); End;
{£} 163: Begin WriteTexterSprite2(X,Y,96,0,101,7,BufferTo); WriteTexterSprite2(X+3,Y,130,2,131,3,BufferTo); End;
{…} 133: Begin WriteTexterSprite2(X,Y,96,0,101,7,BufferTo); WriteTexterSprite2(X+1,Y-1,129,1,131,3,BufferTo); End;
{ì} 236: Begin WriteTexterSprite2(X,Y+2,119,0,123,7,BufferTo); WriteTexterSprite2(X+2,Y,130,2,131,3,BufferTo); End;
{§} 167: Begin WriteTexterSprite2(X,Y,124,0,128,7,BufferTo); WriteTexterSprite2(X+1,Y,129,2,131,3,BufferTo); End;

{µ} 181: Begin WriteTexterSprite1(X,Y+1,0,0,4,6,BufferTo); WriteTexterSprite2(X+2,Y-2,130,2,131,3,BufferTo); End;
{¬} 172: Begin WriteTexterSprite1(X,Y+1,10,0,14,6,BufferTo); WriteTexterSprite2(X+1,Y-2,129,2,131,3,BufferTo); End;
{Ò} 210: Begin WriteTexterSprite1(X,Y+1,15,0,19,6,BufferTo); WriteTexterSprite2(X+1,Y-2,129,2,131,3,BufferTo); End;
{} 144: Begin WriteTexterSprite1(X,Y+1,20,0,24,6,BufferTo); WriteTexterSprite2(X+2,Y-2,130,2,131,3,BufferTo); End;
{·} 183: Begin WriteTexterSprite1(X,Y+1,20,0,24,6,BufferTo); WriteTexterSprite2(X+1,Y-2,129,2,131,3,BufferTo); End;
{Ö} 214: Begin WriteTexterSprite1(X,Y+1,40,0,44,6,BufferTo); WriteTexterSprite2(X+1,Y-2,130,2,131,3,BufferTo); End;
{Õ} 213: Begin WriteTexterSprite1(X,Y+1,65,0,69,6,BufferTo); WriteTexterSprite2(X+1,Y-2,129,2,131,3,BufferTo); End;
{à} 224: Begin WriteTexterSprite1(X,Y+1,70,0,74,6,BufferTo); WriteTexterSprite2(X+2,Y-2,130,2,131,3,BufferTo); End;
{ü} 252: Begin WriteTexterSprite1(X,Y+1,85,0,89,6,BufferTo); WriteTexterSprite2(X+1,Y-2,129,2,131,3,BufferTo); End;
{æ} 230: Begin WriteTexterSprite1(X,Y+1,90,0,94,6,BufferTo); WriteTexterSprite2(X+1,Y-2,129,2,131,3,BufferTo); End;
{›} 155: Begin WriteTexterSprite1(X,Y+1,95,0,99,6,BufferTo); WriteTexterSprite2(X+1,Y-2,129,2,131,3,BufferTo); End;
{é} 233: Begin WriteTexterSprite1(X,Y+1,100,0,104,6,BufferTo); WriteTexterSprite2(X+2,Y-2,130,2,131,3,BufferTo); End;
{Þ} 222: Begin WriteTexterSprite1(X,Y+1,100,0,104,6,BufferTo); WriteTexterSprite2(X+1,Y-3,129,1,131,3,BufferTo); End;
{í} 237: Begin WriteTexterSprite1(X,Y+1,120,0,124,6,BufferTo); WriteTexterSprite2(X+2,Y-2,130,2,131,3,BufferTo); End;
{¦} 166: Begin WriteTexterSprite1(X,Y+1,125,0,129,6,BufferTo); WriteTexterSprite2(X+1,Y-2,129,2,131,3,BufferTo); End;
  End; {Case End}

End;


Procedure OutText(X,Y:Word;retezec:string;BufferTo:Word);
Var I: Word;
    posuv:Byte;
    Ordinal: Byte;
Begin
  posuv:=6; {default}
  For I:=1 to Length(retezec) do
  Begin
    Ordinal:=Ord(retezec[I]);
    Case Ordinal of {znaky o jine delce nez 5 ... nastavit jiny posuv}
{Ö} 214: posuv:=4;
{I} 73: posuv:=4;
{*} 42: posuv:=4;
{/} 47: posuv:=8;
{a} 97: posuv:=7;
{i} 105: posuv:=4;
{j} 106: posuv:=4;
{k} 107: posuv:=5;
{l} 108: posuv:=4;
{m} 109: posuv:=7;
{p} 112: posuv:=7;
{q} 113: posuv:=7;
{t} 116: posuv:=5;
{u} 117: posuv:=7;
{w} 119: posuv:=8;
{ } 160: posuv:=7;
{¡} 161: posuv:=4;
{£} 163: posuv:=7;
{…} 133: posuv:=7;
{œ} 156: posuv:=5;
    End; {Case End}
    OutZnak(X,Y,retezec[I],BufferTo);
    Inc(X,posuv);
    posuv:=6; {default}
  End;
End;


Procedure OutNumber(x,y:Word;Cislo:Longint;Small:Boolean;BufferTo:Word);
Var MZbytek,MRozdil,delitel: Longint;
    Zapisovat:Boolean;
    posuv,pocet:Byte;
Begin
  posuv:=0;
  Zapisovat:=False;
  delitel:=1000000;
  For pocet:=0 to 6 do
  Begin
    If delitel>0 then
    Begin
      MRozdil:=Cislo div delitel;
      MZbytek:=Cislo mod delitel;
    End else
    Begin
      MRozdil:=0;
      MZbytek:=0;
    End;
    If MRozdil>0 then Zapisovat:=True;
    If Zapisovat=True then
    If Small=False then
                     Begin
                       WriteCifra(x+posuv,y,MRozdil,BufferTo);
                       Inc(posuv,6);
                     End
                   else
                     Begin
                       WriteSmallCifra(x+posuv,y,MRozdil,BufferTo);
                       Inc(posuv,5);
                     End;
    Cislo:=MZbytek;
    If delitel>0 then delitel:=delitel div 10;
  End;
  If (Zapisovat=False) And (MRozdil=0) then
  If Small=False then WriteCifra(x+posuv,y,MRozdil,BufferTo)
                 else WriteSmallCifra(x+posuv,y,MRozdil,BufferTo);
End;


{SECTION MAP XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure InitMapBuffers(Velikost: Word);
Var x: Word;
Begin
  Map.Size:=Velikost;
  GetMem(Map.MapBufferP,Map.Size); Map.MapBuffer:=Seg(Map.MapBufferP^);
  For x:=0 to Map.Size-1 do mem[Map.MapBuffer:x]:=0; {vymaz bufferu}
End;


Procedure ShutdownMapBuffers;
Begin
  FreeMem(Map.MapBufferP,Map.Size);
End;


Function GetHDDMapByte: Byte;
Var ReadByte: Byte;
Begin
  BlockRead(Map.MapFile,ReadByte,1);
  GetHDDMapByte:=ReadByte;
End;


Procedure RLEDekompresMap;
Var
  WritedBA: Byte; {znak A}
  WritedBB: Byte; {je-li komprese tak stejny jako znak A}
  WritedBC: Byte; {pocet kolikrat tam je znak A }
  I,A,posun: Word;
Begin
  I:=0; posun:=0;
  While not (posun=Map.DelkaRLE) do
  Begin

    WritedBA:=GetHDDMapByte;                 {nacteme A}
    Inc(posun);
    If posun=Map.DelkaRLE then               {je-li konec zapsat a BREAK}
    Begin
      mem[Map.MapBuffer:I]:=WritedBA;
      Break;
    End;

    WritedBB:=GetHDDMapByte;            {nacteme B}
    Inc(posun);
    If posun=Map.DelkaRLE then          {je-li konec zapsat a BREAK}
    Begin
      mem[Map.MapBuffer:I]:=WritedBA;
      mem[Map.MapBuffer:I+1]:=WritedBB;
      Break;
    End;

    If WritedBA=WritedBB then  {jsou-li dva stejne tzn. nasleduje pocet}
    Begin
      WritedBC:=GetHDDMapByte; {muzeme nacist pocet}
      Inc(posun);
      For A:=1 to WritedBC do
      Begin
        mem[Map.MapBuffer:I]:=WritedBA; {zapisujeme WritedBC krat}
        Inc(I);
      End;
    End else {jsou dva ruzne}
    Begin
      mem[Map.MapBuffer:I]:=WritedBA;   {zapisme jeden a navrat nahoru}
      Inc(I);
      Dec(posun);                       {posuneme index o jednu nazpet}
      Seek(Map.MapFile,FilePos(Map.MapFile)-1);
    End;

  End; {While End}
End;


Procedure RLEKompressMap(number: Word);
Var
  WritedBA: Byte; {znak A}
  WritedBB: Byte; {je-li komprese tak stejny jako znak A}
  WritedBC: Byte; {pocet kolikrat tam je znak A}
  I,A,delka: Word;
  Stejne: Boolean;
Begin
  I:=0; A:=0;
  Repeat
    Stejne:=False;

    If I=number-1 then
    Begin
      mem[Map.MapBufferRLE:A]:=mem[Map.MapBuffer:I];
      Inc(A);
      Break;
    End;

    While (mem[Map.MapBuffer:I]<>mem[Map.MapBuffer:I+1]) and (I<number-1) do
    Begin
      mem[Map.MapBufferRLE:A]:=mem[Map.MapBuffer:I]; {zapis stav 1 kazdy bajt jiny}
      Inc(I);                          {inkrementujeme index pole I}
      Inc(A);                          {inkrementujeme index zabaleneho pole}
    End;

    delka:=1; {zjistujeme kolik bajtu nasleduje za sebou stejnych}
    While (mem[Map.MapBuffer:I]=mem[Map.MapBuffer:I+delka]) and (delka<255) and (I+delka<number-1) do
    Begin
      Inc(delka);
      Stejne:=True;
    End;

    If Stejne=True then
    Begin
      WritedBA:=mem[Map.MapBuffer:I];
      WritedBB:=mem[Map.MapBuffer:I];
      WritedBC:=delka;
      mem[Map.MapBufferRLE:A]:=WritedBA;
      mem[Map.MapBufferRLE:A+1]:=WritedBB;
      mem[Map.MapBufferRLE:A+2]:=WritedBC;
      Inc(I,delka);
      Inc(A,3);
    End;

  Until I=number;

  Map.DelkaRLE:=A;
End;


Procedure LoadMapFile(soubor: string; pozice: Longint);
Begin
  Assign(Map.MapFile,soubor);
  Reset(Map.MapFile,1);
  Seek(Map.MapFile,pozice);
  BlockRead(Map.MapFile,Map.DelkaRLE,2);
  RLEDekompresMap;
  Close(Map.MapFile);
End;


Procedure SaveMapFile(soubor:string);
Var I: Word;
    WritedByte: Byte;
Begin
  Assign(F,soubor);
  ReWrite(F,1);
  RLEKompressMap(Map.Size+1);
  BlockWrite(F,Map.DelkaRLE,2);
  For I:=1 to Map.DelkaRLE do
  Begin
    WritedByte:=mem[Map.MapBufferRLE:I-1];
    BlockWrite(F,WritedByte,1);
  End;
  Close(F);
End;


Procedure SetMapByte(MapOffset:Word; bajt:Byte); Assembler;
Asm
  MOV AX, Map.MapBuffer
  MOV ES, AX

  MOV DI, MapOffset
  XOR AX, AX
  MOV AL, bajt
  STOSB
End;


Function GetMapByte(MapOffset: Word): Byte; Assembler;
Asm
  PUSH DS
  MOV SI, Map.MapBuffer
  MOV DS, SI

  MOV SI, MapOffset
  LODSB                         {AL:=DS:SI}
  POP DS
End;


Procedure WriteMapScreen(XView,YView,MapDelka:Word;BufferFrom,BufferTo:Word);
Var Xmap,Ymap: Byte;
    X1,Y1: Word;
    MapOffset: Word;

  Procedure MapOffsetSetup;
  Begin
    If MapOffset>=128 then Dec(MapOffset,128);
  End;

Begin
  ClearPage(BufferTo);

  X1:=XView div 16;
  Y1:=YView div 16;

  For Ymap:=1 to 11 do
  For Xmap:=1 to 19 do
  Begin
    MapOffset:=GetMapByte((Y1*MapDelka+X1)+Ymap*MapDelka+Xmap); MapOffsetSetup;
    WriteBlok(Xmap*16-(XView mod 16),Ymap*16-(YView mod 16),
      (MapOffset mod 10)*16,(MapOffset div 10)*16,(MapOffset mod 10)*16+15,(MapOffset div 10)*16+15,
      BufferFrom,BufferTo);
  End;

  For Xmap:=1 to 19 do
  Begin
    MapOffset:=GetMapByte((Y1*MapDelka+X1)+Xmap); MapOffsetSetup;
    WriteBlok(Xmap*16-(XView mod 16),0,
      (MapOffset mod 10)*16,(MapOffset div 10)*16+(YView mod 16),(MapOffset mod 10)*16+15,(MapOffset div 10)*16+15,
      BufferFrom,BufferTo);

    Ymap:=12;
    MapOffset:=GetMapByte((Y1*MapDelka+X1)+Ymap*MapDelka+Xmap); MapOffsetSetup;
    WriteBlok(Xmap*16-(XView mod 16),Ymap*16-(YView mod 16),
      (MapOffset mod 10)*16,(MapOffset div 10)*16,(MapOffset mod 10)*16+15,(MapOffset div 10)*16+(YView mod 16),
      BufferFrom,BufferTo);
  End;

  For Ymap:=1 to 11 do
  Begin
    MapOffset:=GetMapByte((Y1*MapDelka+X1)+Ymap*MapDelka); MapOffsetSetup;
    WriteBlok(0,Ymap*16-(YView mod 16),
      (MapOffset mod 10)*16+(XView mod 16),(MapOffset div 10)*16,(MapOffset mod 10)*16+15,(MapOffset div 10)*16+15,
      BufferFrom,BufferTo);

    Xmap:=20;
    MapOffset:=GetMapByte((Y1*MapDelka+X1)+Ymap*MapDelka+Xmap); MapOffsetSetup;
    WriteBlok(Xmap*16-(XView mod 16),Ymap*16-(YView mod 16),
      (MapOffset mod 10)*16,(MapOffset div 10)*16,(MapOffset mod 10)*16+(XView mod 16),(MapOffset div 10)*16+15,
      BufferFrom,BufferTo);
  End;

  Xmap:=0;
  Ymap:=0;
  MapOffset:=GetMapByte((Y1*MapDelka+X1)+Ymap*MapDelka+Xmap); MapOffsetSetup;
  WriteBlok(0,0,
    (MapOffset mod 10)*16+(XView mod 16),(MapOffset div 10)*16+(YView mod 16),
    (MapOffset mod 10)*16+15,(MapOffset div 10)*16+15,
    BufferFrom,BufferTo);

  Xmap:=20;
  Ymap:=0;
  MapOffset:=GetMapByte((Y1*MapDelka+X1)+Ymap*MapDelka+Xmap); MapOffsetSetup;
  WriteBlok(Xmap*16-(XView mod 16),0,
    (MapOffset mod 10)*16,(MapOffset div 10)*16+(YView mod 16),
    (MapOffset mod 10)*16+(XView mod 16),(MapOffset div 10)*16+15,
    BufferFrom,BufferTo);

  Xmap:=0;
  Ymap:=12;
  MapOffset:=GetMapByte((Y1*MapDelka+X1)+Ymap*MapDelka+Xmap); MapOffsetSetup;
  WriteBlok(0,Ymap*16-(YView mod 16),
    (MapOffset mod 10)*16+(XView mod 16),(MapOffset div 10)*16,
    (MapOffset mod 10)*16+15,(MapOffset div 10)*16+(YView mod 16),
    BufferFrom,BufferTo);

  Xmap:=20;
  Ymap:=12;
  MapOffset:=GetMapByte((Y1*MapDelka+X1)+Ymap*MapDelka+Xmap); MapOffsetSetup;
  WriteBlok(Xmap*16-(XView mod 16),Ymap*16-(YView mod 16),
    (MapOffset mod 10)*16,(MapOffset div 10)*16,
    (MapOffset mod 10)*16+(XView mod 16),(MapOffset div 10)*16+(YView mod 16),
    BufferFrom,BufferTo);

  Ramecek(0,0,319,193,0,BufferTo);
  Blok(0,194,319,199,0,BufferTo);
End;


{SECTION KEYBOARD XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{$F+}
Procedure KeyboardHandler(Flags, CS, IP, AX, BX, CX, DX,SI, DI, DS, ES, BP: Word); Interrupt;
Begin
  PresseDKey:=Port[$60];
  If PresseDKey<128 then Key[PresseDKey]:=True;
  If PresseDKey>128 then Key[PresseDKey-128]:=False;
  Port[$20]:=$20;
End;
{$F-}


Procedure InitKeyboard;
Begin
  GetIntVec(9, @BIOSKeyboardHandler);
  SetIntVec(9, Addr(KeyboardHandler));
End;


Procedure ShutdownKeyboard;
Begin
  SetIntVec(9, @BIOSKeyboardHandler);
End;


{SECTION SOUND BLASTER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
function CtiBLASTER : boolean;
var PromBlast : string;
begin
 CtiBlaster := False;
 PromBlast := GetEnv('BLASTER');
 if PromBlast = '' then Exit;
 if Pos('A',PromBlast) = 0 then Exit else
  Adr := (Ord(PromBlast[Pos('A',PromBlast)+1])-Ord('0'))*256+
         (Ord(PromBlast[Pos('A',PromBlast)+2])-Ord('0'))*16+
         (Ord(PromBlast[Pos('A',PromBlast)+3])-Ord('0'));
 if Pos('I',PromBlast) = 0 then Exit else
  IRQ := Ord(PromBlast[Pos('I',PromBlast)+1])-Ord('0');
 if Pos('D',PromBlast) = 0 then Exit else
  DMA8 := Ord(PromBlast[Pos('D',PromBlast)+1])-Ord('0');
 if Pos('H',PromBlast) = 0 then DMA16 := 255 else
  DMA16 := Ord(PromBlast[Pos('H',PromBlast)+1])-Ord('0');
 if Pos('T',PromBlast) = 0 then Exit else
  Typ := Ord(PromBlast[Pos('T',PromBlast)+1])-Ord('0');
 if not (DMA8 in [0,1,3]) then Exit;
 if DMA16 <> 255 then
  if not (DMA16 in [5,6,7]) then Exit;
 if not (IRQ in [2,3,5,7,10,11,12,15]) then Exit;
 CtiBlaster := True;
end;


function VytvorBuffer : boolean;
var PracBuf : pointer;
    Stranka1,Stranka2,I : word;
begin
 VytvorBuffer := False;
 if MaxAvail >= 65536 then
 begin
  GetMem(PracBuf,32768);
  LinearAdr := longint(Seg(PracBuf^)) shl 4 + Ofs(PracBuf^);
  Stranka1 := LinearAdr shr 16;
  Stranka2 := (LinearAdr+32767) shr 16;
  if Stranka1 <> Stranka2 then
  begin
   GetMem(SBbuffer,32768);
   SBBufferSeg:=Seg(SBbuffer^);
   FreeMem(PracBuf,32768);
  end else
  begin
   SBBuffer := PracBuf;
   SBBufferSeg:=Seg(SBbuffer^);
  end;
  For I:=0 to 32767 do mem[SBBufferSeg:I]:=$80;
  LinearAdr := longint(Seg(SBBuffer^)) shl 4 + Ofs(SBBuffer^);
  Stranka := LinearAdr shr 16;
  OfsStranky := LinearAdr and $ffff;
  VytvorBuffer := True;
 end;
end;


Function GetSBOffset2: Word;
Var Ukazatel: Word;
Begin
  Ukazatel := Port[DMAOfs[DMA8]];
  Ukazatel := Ukazatel + Port[DMAOfs[DMA8]] shl 8;
  GetSBOffset2 := Ukazatel;
End;


Function GetSBOffset: Word;
Var Ukazatel: Word;
Begin
  Ukazatel := Port[DMAOfs[DMA8]];
  Ukazatel := Ukazatel + Port[DMAOfs[DMA8]] shl 8;
  GetSBOffset := Ukazatel - SBOffsetMIN;
End;


procedure SBObsluha; interrupt;
var Prac: byte;
    A,I: Word;
begin
 Prac := Port[Adr+$e];
 Port[$20] := $20;
 If IRQ in [2]+[8..15] then Port[$a0] := $20;

 If LongRaw=True then
 Begin {long RAW}
   If LongRawCast<LongRawMaxCasti then
   Begin
     MoveFromXMS(Sample[LongRawCislo].Handle,32768+LongRawCast*8192,mem[Buffer[0]:0],8192);
     A:=0;
     For I:=0 to 2047 do
     Begin
       memL[SBBufferSeg:A+AktCast*8192]:=memL[Buffer[0]:I*4];
       Inc(A,4);
     End;
     Inc(LongRawCast);
   End else
   Begin
     MoveFromXMS(Sample[LongRawCislo].Handle,32768+LongRawCast*8192,mem[Buffer[0]:0],LongRawZbytek);
     A:=0;
     For I:=0 to 2047 do
     Begin
       memL[SBBufferSeg:A+AktCast*8192]:=$80808080;
       Inc(A,4);
     End;
     A:=0;
     For I:=0 to LongRawZbytek do
     Begin
       mem[SBBufferSeg:A+AktCast*8192]:=mem[Buffer[0]:0];
       Inc(A);
     End;
     LongRaw:=False;
   End;
 End else
 Begin {short RAW}
   A:=0;
   For I:=0 to 2047 do
   Begin
     memL[SBBufferSeg:A+AktCast*8192]:=$80808080;
     Inc(A,4);
   End;
 End;

 AktCast := (AktCast+1) and 3;
 If AktCast=0 then SBOffsetMIN:=GetSBOffset2;
 If AktCast=3 then SBOffsetMAX:=GetSBOffset2;
end;


procedure DSPwrite(Data : byte); assembler;
asm
   mov	dx,adr
   add	dx,$c
@cekame:
   in	al,dx
   and	al,$80
   jnz	@cekame
   mov	al,data
   out	dx,al
end;


procedure OdmaskujINT;
begin
 case IRQ of
   2 : Port[$a1] := Port[$a1] and not 2;
  10 : Port[$a1] := Port[$a1] and not 4;
  11 : Port[$a1] := Port[$a1] and not 8;
  else Port[$21] := Port[$21] and not (1 shl IRQ);
 end;
 if IRQ in [2, 10, 11] then Port[$21] := Port[$21] and not 4;
end;


procedure PovolDMA;
begin
 Port[DMA8reg[0]] := 4 or DMA8;
 Port[DMA8reg[2]] := 0;
 Port[DMA8reg[1]] := $58 or DMA8;
 Port[DMAstr[DMA8]] := byte(Stranka);
 Port[DMAofs[DMA8]] := Lo(OfsStranky);
 Port[DMAofs[DMA8]] := Hi(OfsStranky);
 Port[DMAvel[DMA8]] := $ff;	{lo}
 Port[DMAvel[DMA8]] := $7f;	{hi}
 Port[DMA8reg[0]] := DMA8;
end;


procedure StartSB; assembler;
asm
  push	$d1
  call	DSPwrite
  push	$40
  call	DSPwrite
  push	131             {nastavime frekvenci pres konstantu}
  call	DSPwrite
  call	povolDMA
  push	$48
  call	DSPwrite
  push	$ff
  call	DSPwrite
  push	$1f
  call	DSPwrite
  push	$1c
  call	DSPwrite
end;


procedure ZamaskujINT;
begin
 case IRQ of
   2 : Port[$a1] := Port[$a1] or 2;
  10 : Port[$a1] := Port[$a1] or 4;
  11 : Port[$a1] := Port[$a1] or 8;
  else Port[$21] := Port[$21] or (1 shl IRQ);
 end;
 if IRQ in [2,10,11] then Port[$21] := Port[$21] or 4;
end;


Procedure odinstINT;
Begin
  SetIntVec(INTvec[IRQ],StaraSBObsluha);
End;


procedure ExitSB; assembler;
asm
   push	$d9
   call	DSPwrite
   push	$d0
   call	DSPwrite
   call	odinstINT
   call	ZamaskujINT
   push	$d3
   call	DSPwrite
end;


Procedure SBPlayRaw(Cislo:Byte);
Var I,A: Word;
Begin
  CisloRawu:=Cislo;
  DelkaZbytku:=0;
  AktPos:=0;

  A:=0;
  For I:=0 to 8191 do
  Begin
    memL[SBBufferSeg:A]:=$80808080;
    Inc(A,4);
  End;

  A:=0;
  For I:=0 to 8191 do
  Begin
    memL[Buffer[0]:A]:=$80808080;
    Inc(A,4);
  End;

  If Sample[Cislo].Delka>32768 then
  Begin {vetsi nez 32768}
    LongRawCislo:=Cislo;
    LongRaw:=True;
    LongRawCast:=0;
    LongRawMaxCasti:=(Sample[Cislo].Delka-32768) div 8192;
    LongRawZbytek:=(Sample[Cislo].Delka-32768) mod 8192;
    If ((LongRawZbytek>0) and (Odd(LongRawZbytek))) then Dec(LongRawZbytek);
    MoveFromXMS(Sample[Cislo].Handle,0,mem[Buffer[0]:0],32768);
    A:=GetSBOffset+200;
    A:=A and $7fff;
    For I:=0 to 32767 do
    Begin
      mem[SBBufferSeg:A]:=mem[Buffer[0]:I];
      Inc(A);
      A:=A and $7fff;
    End;
  End else
  Begin {mensi nez 32768}
    LongRaw:=False;
    If Odd(Sample[Cislo].Delka)
    then MoveFromXMS(Sample[Cislo].Handle,0,mem[Buffer[0]:0],Sample[Cislo].Delka-1)
    else MoveFromXMS(Sample[Cislo].Handle,0,mem[Buffer[0]:0],Sample[Cislo].Delka);
    A:=GetSBOffset+200;
    A:=A and $7fff;
    For I:=0 to Sample[Cislo].Delka-1 do
    Begin
      mem[SBBufferSeg:A]:=mem[Buffer[0]:I];
      Inc(A);
      A:=A and $7fff;
    End;
  End;
End;


Procedure InitSB;
Begin
  CtiBlaster;
  VytvorBuffer;
  GetIntVec(INTvec[IRQ],StaraSBObsluha);
  SetIntVec(INTvec[IRQ],@SBObsluha);
  OdmaskujINT;
  AktCast:=0;
  StartSB;
End;


Procedure ShutdownSB;
Begin
  ExitSB;
  FreeMem(SBBuffer,32768);
End;


{SECTION TIMER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Wait(ms: Word);
Begin
  If ms>0 then
  Begin
    delaycounter:=0;
    waiting:=True;
    While delaycounter<ms*8 do Begin End;
    waiting:=False;
    delaycounter:=0;
  End;
End;


Procedure Sound(Hertz: Word); Assembler;
Asm
  MOV    BX,SP
  MOV    BX,&Hertz
  MOV    AX,34DDh
  MOV    DX,0012h
  CMP    DX,BX
  JNB    @J1
  DIV    BX
  MOV    BX,AX
  IN     AL,61h
  TEST   AL,03h
  JNZ    @J2
  OR     AL,03h
  OUT    61h,AL
  MOV    AL,-4Ah
  OUT    43h,AL
@J2:
  MOV    AL,BL
  OUT    42h,AL
  MOV    AL,BH
  OUT    42h,AL
@J1:
End;


Procedure Silence; Assembler;
Asm
  IN     AL,61h
  AND    AL,0FCh
  OUT    61h,AL
End;


Procedure Stopky_Start;
Begin
  StopkyTics:=0;
  StopkyActive:=True;
End;


Procedure Stopky_Stop;
Begin
  StopkyActive:=False;
End;


Function Stopky_GetNumber: LongInt;
Begin
  Stopky_GetNumber:=StopkyTics;
End;


Function FPS2s: Boolean;
Begin
  If fps_helper<100 then FPS2s:=False {false v prvni vterine}
                    else FPS2s:=True; {true ve druhe vterine}
End;


Procedure Delay10; {MIDI Delay 10ms}
Begin
  Wait(10);
End;


function TestGM(Adr : word) : boolean; assembler;
asm
  mov	bl,0
  call	delay10  {spozdeni 10 ms}
  mov	dx,adr
  inc	dx
  in	al,dx
  and	al,$40
  or	al,al
  jnz	@neni  {je Port[Adr+1] and $40 = 0?}
  dec	dx
  mov	al,$f8  {provedeme reset}
  out	dx,al
  call	delay10
  inc	dx
  in	al,dx
  and	al,$40
  or	al,al
  jnz	@neni  {je na dane adrese GM cip?}
  inc	bl
@neni:
  mov	al,bl
end;


Procedure SetupGMAdr;
Var TestAdr,I: Word;
Begin
  GMAdr:=0;
  For I:=0 to 11 do
  Begin
    Case I of
      0: TestAdr:=$220;
      1: TestAdr:=$230;
      2: TestAdr:=$240;
      3: TestAdr:=$250;
      4: TestAdr:=$300;
      5: TestAdr:=$320;
      6: TestAdr:=$330;
      7: TestAdr:=$332;
      8: TestAdr:=$334;
      9: TestAdr:=$336;
     10: TestAdr:=$340;
     11: TestAdr:=$360;
    End;
    If TestGM(TestAdr)=True then GMAdr:=TestAdr+1;
  End;
End;


procedure WriteGM; assembler;
asm
  mov	dx,gmadr
  push	ax
  xor	ax,ax
@cekej:
  dec	ah
  jz	@vyprsel
  in	al,dx
  and	al,$40	{je mozne vysilat?}
  jnz	@cekej
@vyprsel:
  dec	dx
  pop	ax
  out	dx,al
end;


function ReadGM : byte; assembler;
asm
  mov	dx,gmadr
  xor	ax,ax
@cekej:
  dec	ah
  jz	@vyprsel
  in	al,dx
  and	al,$80	{je mozne cist?}
  jnz	@cekej
@vyprsel:
  dec	dx
  in	al,dx
end;


procedure ResetGM; assembler;
asm
  mov	dx,gmadr
  mov	al,$ff	{xor	ax,ax; dec	ax}
  out	dx,al
  call	readgm
  xor	ax,ax
@cekej:
  dec	ah
  jz	@vyprsel
  in	al,dx
  and	al,$40
  jnz	@cekej
@vyprsel:
  mov	al,$3f
  out	dx,al  {tady je vyjimka; neni tu DEC DX}
end;


procedure SetNastroj(Kanal,Cislo : byte); assembler;
asm
  mov	al,kanal
  add	al,$c0
  call	writegm
  mov	al,cislo
  call	writegm
end;


procedure SetBalance(Kanal,Poloha : byte); assembler;
asm
  mov	al,kanal
  add	al,$b0
  call	writegm
  mov	al,10
  call	writegm
  mov	al,poloha
  call	writegm
end;


procedure NotaOn(Kanal,Nota,Hlasitost : byte); assembler;
asm
  mov	al,kanal
  add	al,$90
  call	writegm
  mov	al,nota
  call	writegm
  mov	al,hlasitost
  call	writegm
end;


procedure NotaOff(Kanal,Nota,Hlasitost : byte); assembler;
asm
  mov	al,kanal
  add	al,$80
  call	writegm
  mov	al,nota
  call	writegm
  mov	al,hlasitost
  call	writegm
end;


Procedure InitGM;
Var x: Word;
Begin
  GetMem(Melody.DataPoint,24128); Melody.DataSeg:=Seg(Melody.DataPoint^);
  For x:=0 to 24127 do mem[Melody.DataSeg:x]:=0;
  GMHraje:=False;
  SetupGMAdr;
  ResetGM;
End;


Procedure ShutdownGM;
Begin
  ResetGM;
  FreeMem(Melody.DataPoint,24128);
End;


Procedure SetMelodyTempo(Temp: Byte);
Begin
  If ((Temp>0) and (Temp<13)) then
  Begin
    Case Temp of
      1: Melody.Delay:=280;
      2: Melody.Delay:=260;
      3: Melody.Delay:=240;
      4: Melody.Delay:=220;
      5: Melody.Delay:=200;
      6: Melody.Delay:=180;
      7: Melody.Delay:=160;
      8: Melody.Delay:=140;
      9: Melody.Delay:=120;
      10: Melody.Delay:=100;
      11: Melody.Delay:=80;
      12: Melody.Delay:=70;
    End; {Case End}
  End else Melody.Delay:=200;
End;


Procedure SetKanalVolume(Kan,Vol: Byte);
Begin
  If Vol<128 then Melody.Kanal[Kan].Volume:=Vol;
End;


Procedure SetupGM;
Var I: Byte;
Begin
  SetNastroj(9,35);
  SetBalance(9,Melody.Kanal[0].Balance);
  For I:=1 to 7 do
  Begin
    SetNastroj(I,Melody.Kanal[I].Nastroj);
    SetBalance(I,Melody.Kanal[I].Balance);
  End;
  SetMelodyTempo(Melody.Tempo);
  SetKanalVolume(9,127);
  SetKanalVolume(1,127);
  SetKanalVolume(2,127);
  SetKanalVolume(3,127);
  SetKanalVolume(4,127);
  SetKanalVolume(5,127);
  SetKanalVolume(6,127);
  SetKanalVolume(7,127);
End;


Procedure CountMelodyLenght;
Var I: Word;
    kan: Byte;
    bajt: Byte;
    del1: array[0..7] of Word;
    delka: LongInt;
Begin
  For I:=0 to 7 do del1[I]:=0;

  For kan:=0 to 7 do
  Begin
    For I:=2999 downto 0 do
    Begin
      bajt:=mem[Melody.DataSeg:kan*3000+I];
      If bajt<>120 then
      Begin
        del1[kan]:=I;
        Break;
      End;
    End;
  End;

  For I:=0 to 7 do Melody.DelkaKanalu[I]:=del1[I];
  delka:=del1[0];
  If del1[1]>delka then delka:=del1[1];
  If del1[2]>delka then delka:=del1[2];
  If del1[3]>delka then delka:=del1[3];
  If del1[4]>delka then delka:=del1[4];
  If del1[5]>delka then delka:=del1[5];
  If del1[6]>delka then delka:=del1[6];
  If del1[7]>delka then delka:=del1[7];
  Melody.Delka:=delka+1;
End;


Procedure CountMelodySegmentLenght(Start,Finish: Word);
Var I: Word;
    kan: Byte;
    bajt: Byte;
    del1: array[0..7] of Word;
    delka: LongInt;
Begin
  For I:=0 to 7 do del1[I]:=0;

  For kan:=0 to 7 do
  Begin
    For I:=Finish downto Start do
    Begin
      bajt:=mem[Melody.DataSeg:kan*3000+I];
      If bajt<>120 then
      Begin
        del1[kan]:=I;
        Break;
      End;
    End;
  End;

  For I:=0 to 7 do Melody.DelkaKanalu[I]:=del1[I];
  delka:=del1[0];
  If del1[1]>delka then delka:=del1[1];
  If del1[2]>delka then delka:=del1[2];
  If del1[3]>delka then delka:=del1[3];
  If del1[4]>delka then delka:=del1[4];
  If del1[5]>delka then delka:=del1[5];
  If del1[6]>delka then delka:=del1[6];
  If del1[7]>delka then delka:=del1[7];
  Melody.Delka:=delka+1;
End;


Procedure SetupArray1;
Var I: Word;
Begin
  For I:=0 to 23999 do mem[RLESeg:I]:=mem[Melody.DataSeg:I];
  mem[RLESeg:24000]:=Melody.Kanal[0].Nastroj;
  mem[RLESeg:24001]:=Melody.Kanal[0].Balance;
  mem[RLESeg:24002]:=Melody.Kanal[0].DefaultOktava;
  mem[RLESeg:24003]:=Melody.Kanal[1].Nastroj;
  mem[RLESeg:24004]:=Melody.Kanal[1].Balance;
  mem[RLESeg:24005]:=Melody.Kanal[1].DefaultOktava;
  mem[RLESeg:24006]:=Melody.Kanal[2].Nastroj;
  mem[RLESeg:24007]:=Melody.Kanal[2].Balance;
  mem[RLESeg:24008]:=Melody.Kanal[2].DefaultOktava;
  mem[RLESeg:24009]:=Melody.Kanal[3].Nastroj;
  mem[RLESeg:24010]:=Melody.Kanal[3].Balance;
  mem[RLESeg:24011]:=Melody.Kanal[3].DefaultOktava;
  mem[RLESeg:24012]:=Melody.Kanal[4].Nastroj;
  mem[RLESeg:24013]:=Melody.Kanal[4].Balance;
  mem[RLESeg:24014]:=Melody.Kanal[4].DefaultOktava;
  mem[RLESeg:24015]:=Melody.Kanal[5].Nastroj;
  mem[RLESeg:24016]:=Melody.Kanal[5].Balance;
  mem[RLESeg:24017]:=Melody.Kanal[5].DefaultOktava;
  mem[RLESeg:24018]:=Melody.Kanal[6].Nastroj;
  mem[RLESeg:24019]:=Melody.Kanal[6].Balance;
  mem[RLESeg:24020]:=Melody.Kanal[6].DefaultOktava;
  mem[RLESeg:24021]:=Melody.Kanal[7].Nastroj;
  mem[RLESeg:24022]:=Melody.Kanal[7].Balance;
  mem[RLESeg:24023]:=Melody.Kanal[7].DefaultOktava;
  mem[RLESeg:24024]:=Melody.Tempo;
  memW[RLESeg:24025]:=Melody.Repetice;
  memL[RLESeg:24027]:=Melody.Delka;
  mem[RLESeg:24031]:=NotDrums;
End;


Procedure SetupArray2;
Var I: Word;
Begin
  For I:=0 to 23999 do mem[Melody.DataSeg:I]:=mem[RLESeg:I];
  Melody.Kanal[0].Nastroj:=mem[RLESeg:24000];
  Melody.Kanal[0].Balance:=mem[RLESeg:24001];
  Melody.Kanal[0].DefaultOktava:=mem[RLESeg:24002];
  Melody.Kanal[1].Nastroj:=mem[RLESeg:24003];
  Melody.Kanal[1].Balance:=mem[RLESeg:24004];
  Melody.Kanal[1].DefaultOktava:=mem[RLESeg:24005];
  Melody.Kanal[2].Nastroj:=mem[RLESeg:24006];
  Melody.Kanal[2].Balance:=mem[RLESeg:24007];
  Melody.Kanal[2].DefaultOktava:=mem[RLESeg:24008];
  Melody.Kanal[3].Nastroj:=mem[RLESeg:24009];
  Melody.Kanal[3].Balance:=mem[RLESeg:24010];
  Melody.Kanal[3].DefaultOktava:=mem[RLESeg:24011];
  Melody.Kanal[4].Nastroj:=mem[RLESeg:24012];
  Melody.Kanal[4].Balance:=mem[RLESeg:24013];
  Melody.Kanal[4].DefaultOktava:=mem[RLESeg:24014];
  Melody.Kanal[5].Nastroj:=mem[RLESeg:24015];
  Melody.Kanal[5].Balance:=mem[RLESeg:24016];
  Melody.Kanal[5].DefaultOktava:=mem[RLESeg:24017];
  Melody.Kanal[6].Nastroj:=mem[RLESeg:24018];
  Melody.Kanal[6].Balance:=mem[RLESeg:24019];
  Melody.Kanal[6].DefaultOktava:=mem[RLESeg:24020];
  Melody.Kanal[7].Nastroj:=mem[RLESeg:24021];
  Melody.Kanal[7].Balance:=mem[RLESeg:24022];
  Melody.Kanal[7].DefaultOktava:=mem[RLESeg:24023];
  Melody.Tempo:=mem[RLESeg:24024];
  Melody.Repetice:=memW[RLESeg:24025];
  Melody.Delka:=memL[RLESeg:24027];
  NotDrums:=mem[RLESeg:24031];
End;


Procedure LoadMELFile(Filename:String;Pozice:LongInt);
Var I: Word;
    ReadByte: Byte;
Begin
  Assign(F,Filename);
  Reset(F,1);
  Seek(F,Pozice);
  BlockRead(F,RLEdelka,2);
  RLEDekompress;
  SetupArray2;
  Close(F);
  SetupGM;
End;


Procedure SaveMELFile(Filename: String);
Var I: Word;
    WritedByte: Byte;
Begin
  Assign(F,Filename);
  ReWrite(F,1);
  SetupArray1;
  RLEKompress(24032);
  BlockWrite(F,RLEDelka,2);
  For I:=1 to RLEDelka do
  Begin
    WritedByte:=mem[RLEKompressedSeg:I-1];
    BlockWrite(F,WritedByte,1);
  End;
  Close(F);
End;


Procedure StartGMPlay(Temp,Vol:Byte;Start,Finish:Word;Rep:Boolean);
Var I: Byte;
Begin
  Melody.Start:=Start;
  Melody.Finish:=Finish;
  If Finish>0 then CountMelodySegmentLenght(Start,Finish)
              else CountMelodyLenght;
  SetMelodyTempo(Temp);
  For I:=0 to 7 do
  Begin
    SetKanalVolume(I,Vol);
    Melody.Kanal[I].Pos:=Melody.Start;
    Melody.Kanal[I].NotaHraje:=False;
    Melody.Kanal[I].Stop:=False;
  End;
  Melody.DelayCounter:=0;
  If Rep=True then Melody.Opakovat:=True
              else Melody.Opakovat:=False;
  GMHraje:=True;
End;


Procedure StopGMPlay;
Var I: Byte;
Begin
  GMHraje:=False;
  For I:=0 to 7 do
  Begin
    NotaOff(I,Melody.Kanal[I].FIFO[2],Melody.Kanal[1].Volume);
    NotaOff(I,Melody.Kanal[I].Nota,Melody.Kanal[1].Volume);
    Melody.Kanal[I].Pos:=Melody.Start;
    Melody.Kanal[I].NotaCounter:=0;
    Melody.Kanal[I].NotaHraje:=False;
  End;
End;


Procedure JumpToMelodyRepeat;
Var I: Byte;
Begin
  For I:=0 to 7 do
  Begin
    Melody.Kanal[I].Pos:=Melody.Repetice+1;
    Melody.Kanal[I].NotaCounter:=0;
    Melody.Kanal[I].NotaHraje:=False;
    NotaOff(I,Melody.Kanal[I].FIFO[2],Melody.Kanal[1].Volume);
    NotaOff(I,Melody.Kanal[I].Nota,Melody.Kanal[1].Volume);
  End;
End;


Procedure Start_LoadSymbol(X,Y:Word;BackColor,FrontColor:Byte);
Var I: Byte;
Begin
  LoadSymbol.X:=X;
  LoadSymbol.Y:=Y;
  LoadSymbol.BackColor:=BackColor;
  LoadSymbol.FrontColor:=FrontColor;
  LoadSymbol.OnScreen:=True;
End;


Procedure Stop_LoadSymbol;
Begin
  LoadSymbol.OnScreen:=False;
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure TimerHandler; Interrupt;
Var I,A: Byte;
    Tmp: array[1..3] of Byte;
Begin
  {zpozdovac}
  If waiting=True then Inc(delaycounter); {je prave jedna milisekunda}

  {prehravani rawu}
  If RawHraje then
  Begin
    If mem[Buffer[0]:OffsetSpeakeru]>$80
    then Sound(22000) else Silence;

    Inc(Sample[PrehravanyZvuk].Pocitadlo);
    If Sample[PrehravanyZvuk].Pocitadlo=Sample[PrehravanyZvuk].Delka
    then Begin RawHraje:=False; Silence; End;
    If OffsetSpeakeru<32768 then Inc(OffsetSpeakeru) else OffsetSpeakeru:=0;
  End;

  {prehravani zvuku}
  If player=10 then If PrehravatZvuk=True then
  Begin
    If memW[SoundDataSeg:memW[ZvukTabSeg:CisloZvuku*4]*2+PosuvZ*2]>0
    then Sound(memW[SoundDataSeg:memW[ZvukTabSeg:CisloZvuku*4]*2+PosuvZ*2])
    else Sound(10); {Silence;}
    Inc(PosuvZ);
    If PosuvZ>memW[ZvukTabSeg:CisloZvuku*4+2] then {prehrali jsme celou delku zvuku}
    Begin
      PrehravatZvuk:=False;
      PosuvZ:=0;
      Silence;
    End
  End;

  {prehravani General MIDI}
  If GMHraje=True then
  Begin
    If Melody.DelayCounter<Melody.Delay-1
    then Inc(Melody.DelayCounter)
    else Begin
           Melody.DelayCounter:=0;

           {zastavujeme hrajici notu, bici nemusime jen nastroje}
           If NotDrums=1 then
           Begin
             If ((Melody.Kanal[0].Pos>Melody.Start) and (Melody.Kanal[0].NotaCounter=0) and
                 (Melody.Kanal[0].Nota<=120) and (Melody.Kanal[0].NotaHraje=True)) then
             Begin
               NotaOff(4,Melody.Kanal[0].FIFO[2],Melody.Kanal[0].Volume);
               Melody.Kanal[0].FIFO[2]:=Melody.Kanal[0].FIFO[1];
               Melody.Kanal[0].NotaHraje:=False;
             End;
           End;
           For I:=1 to 7 do
           Begin
             If ((Melody.Kanal[I].Pos>Melody.Start) and (Melody.Kanal[I].NotaCounter=0) and
                 (Melody.Kanal[I].Nota<=120) and (Melody.Kanal[I].NotaHraje=True)) then
             Begin
               NotaOff(I,Melody.Kanal[I].FIFO[2],Melody.Kanal[I].Volume);
               Melody.Kanal[I].FIFO[2]:=Melody.Kanal[I].FIFO[1];
               Melody.Kanal[I].NotaHraje:=False;
             End;
           End;

           {nacitame bajt z pameti, nastavujeme notu, mezeru nebo repetici}
           For I:=0 to 7 do
           Begin
             If ((Melody.Kanal[I].Pos<Melody.Delka) and (Melody.Kanal[I].NotaCounter=0) and
                 (Melody.Kanal[I].Stop=False)) then
             Begin
               Melody.Kanal[I].Nota:=mem[Melody.DataSeg:I*3000+Melody.Kanal[I].Pos];
               If Melody.Kanal[I].Nota>=128 then Melody.Kanal[I].NotaCounter:=Melody.Kanal[I].Nota-128; {m}
               If Melody.Kanal[I].Nota<120 then Melody.Kanal[I].FIFO[1]:=Melody.Kanal[I].Nota; {nota}
               If Melody.Kanal[I].Nota=120 then
               Begin
                 Melody.Kanal[I].NotaCounter:=1;
                 Melody.Kanal[I].NotaHraje:=True;
               End;
               If Melody.Kanal[I].Nota=121 then {repetice}
               Begin
                 Melody.Kanal[I].Stop:=True;
                 If ((Melody.Kanal[0].Stop=True) and (Melody.Kanal[1].Stop=True) and
                     (Melody.Kanal[2].Stop=True) and (Melody.Kanal[3].Stop=True)) then
                 For A:=0 to 7 do
                 Begin
                   Melody.Kanal[A].Pos:=Melody.Start;
                   Melody.Kanal[A].NotaCounter:=0;
                   Melody.Kanal[A].NotaHraje:=False;
                   Melody.Kanal[A].Stop:=False;
                   NotaOff(A,Melody.Kanal[A].FIFO[2],Melody.Kanal[A].Volume);
                   NotaOff(A,Melody.Kanal[A].Nota,Melody.Kanal[A].Volume);
                 End;
               End;
             End;
           End;

           {spoustime notu aby hrala}
           If NotDrums=0 then
           Begin
             If ((Melody.Kanal[0].Nota<120) and
                 (Melody.Kanal[0].NotaCounter=0) and
                 (Melody.Kanal[0].Stop=False))
             then NotaOn(9,Melody.Kanal[0].Nota,Melody.Kanal[0].Volume);
           End else
           Begin
             If ((Melody.Kanal[0].NotaHraje=False) and
                 (Melody.Kanal[0].Nota<120) and
                 (Melody.Kanal[0].NotaCounter=0) and
                 (Melody.Kanal[0].Stop=False)) then
                 Begin
                   NotaOn(4,Melody.Kanal[0].Nota,Melody.Kanal[0].Volume);
                   Melody.Kanal[0].NotaHraje:=True;
                 End;
           End;
           For I:=1 to 7 do
           Begin
             If ((Melody.Kanal[I].NotaHraje=False) and
                 (Melody.Kanal[I].Nota<120) and
                 (Melody.Kanal[I].NotaCounter=0) and
                 (Melody.Kanal[I].Stop=False)) then
                 Begin
                   NotaOn(I,Melody.Kanal[I].Nota,Melody.Kanal[I].Volume);
                   Melody.Kanal[I].NotaHraje:=True;
                 End;
           End;

           {test stop kanalu}
           For I:=0 to 7 do
           Begin
             If Melody.Kanal[I].Pos=Melody.DelkaKanalu[I] then
             Melody.Kanal[I].Stop:=True;
           End;

           {test konce melodie kterykoliv kanal}
           If ((Melody.Kanal[0].Pos=Melody.Delka-1) or
               (Melody.Kanal[1].Pos=Melody.Delka-1) or
               (Melody.Kanal[2].Pos=Melody.Delka-1) or
               (Melody.Kanal[3].Pos=Melody.Delka-1) or
               (Melody.Kanal[4].Pos=Melody.Delka-1) or
               (Melody.Kanal[5].Pos=Melody.Delka-1) or
               (Melody.Kanal[6].Pos=Melody.Delka-1) or
               (Melody.Kanal[7].Pos=Melody.Delka-1)) then
           Begin
             If Melody.Opakovat=True
             then Begin
                    For I:=0 to 7 do
                    Begin
                      Melody.Kanal[I].Pos:=Melody.Start;
                      Melody.Kanal[I].NotaCounter:=0;
                      Melody.Kanal[I].NotaHraje:=False;
                      Melody.Kanal[I].Stop:=False;
                    End;
                  End
             else StopGMPlay;
           End;

           {odpocet mezery v melodii}
           For I:=0 to 7 do
           If Melody.Kanal[I].NotaCounter>0 then Dec(Melody.Kanal[I].NotaCounter);

           {posouvame se po melodii}
           For I:=0 to 7 do
           Begin
             If ((Melody.Kanal[I].Pos<Melody.Delka) and (Melody.Kanal[I].NotaCounter=0) and
                 (Melody.Kanal[I].Stop=False))
             then Inc(Melody.Kanal[I].Pos);
           End;

         End;
  End;

  {loading symbol}
  If LoadSymbol.OnScreen=True then
  Begin
    If LoadSymbol.TimeCounter<399
    then Inc(LoadSymbol.TimeCounter)
    else Begin
           LoadSymbol.TimeCounter:=0;
           If LoadSymbol.FrameCounter<3
           then Inc(LoadSymbol.FrameCounter)
           else LoadSymbol.FrameCounter:=0;
           Blok(LoadSymbol.X,LoadSymbol.Y,LoadSymbol.X+4,LoadSymbol.Y+4,LoadSymbol.BackColor,Buffer[4]);
           Case LoadSymbol.FrameCounter of
           0: Begin
                WritePixel(LoadSymbol.X,LoadSymbol.Y+2,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+1,LoadSymbol.Y+2,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+2,LoadSymbol.Y+2,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+3,LoadSymbol.Y+2,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+4,LoadSymbol.Y+2,LoadSymbol.FrontColor,Buffer[4]);
              End;
           1: Begin
                WritePixel(LoadSymbol.X,LoadSymbol.Y,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+1,LoadSymbol.Y+1,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+2,LoadSymbol.Y+2,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+3,LoadSymbol.Y+3,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+4,LoadSymbol.Y+4,LoadSymbol.FrontColor,Buffer[4]);
              End;
           2: Begin
                WritePixel(LoadSymbol.X+2,LoadSymbol.Y,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+2,LoadSymbol.Y+1,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+2,LoadSymbol.Y+2,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+2,LoadSymbol.Y+3,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+2,LoadSymbol.Y+4,LoadSymbol.FrontColor,Buffer[4]);
              End;
           3: Begin
                WritePixel(LoadSymbol.X,LoadSymbol.Y+4,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+1,LoadSymbol.Y+3,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+2,LoadSymbol.Y+2,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+3,LoadSymbol.Y+1,LoadSymbol.FrontColor,Buffer[4]);
                WritePixel(LoadSymbol.X+4,LoadSymbol.Y,LoadSymbol.FrontColor,Buffer[4]);
              End;
           End; {Case End}
         End;
  End;

  {blinking color}
  If Blinking=True then
  Begin
    If BlinkingCounter<BlinkingCounterMax
    then Inc(BlinkingCounter)
    else Begin
           BlinkingCounter:=0;
           For I:=0 to 255 do
           Begin
             If Blink[I]=True then
             Case Blink2[I] of
               0: Begin
                    GetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[1]>0 then dec(Tmp[1]);
                    SetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[1]=0 then Blink2[I]:=1;
                  End;
               1: Begin
                    GetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[2]>0 then dec(Tmp[2]);
                    SetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[2]=0 then Blink2[I]:=2;
                  End;
               2: Begin
                    GetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[3]>0 then dec(Tmp[3]);
                    If Tmp[1]<ColorBackup[I].R then Inc(Tmp[1]);
                    SetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[3]=0 then Blink2[I]:=3;
                  End;
               3: Begin
                    GetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[1]<ColorBackup[I].R then Inc(Tmp[1]);
                    SetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[1]=ColorBackup[I].R then Blink2[I]:=4;
                  End;
               4: Begin
                    GetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[2]<ColorBackup[I].G then Inc(Tmp[2]);
                    SetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[2]=ColorBackup[I].G then Blink2[I]:=5;
                  End;
               5: Begin
                    GetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[3]<ColorBackup[I].B then Inc(Tmp[3]);
                    SetPal(I,Tmp[1],Tmp[2],Tmp[3]);
                    If Tmp[3]=ColorBackup[I].B then Blink2[I]:=0;
                  End;
             End; {Case End}
           End;
         End;
  End;

  {helper pro vypocet fps kazde 2 sekundy}
  If player=80 then {je setina vteriny ?}
  Begin
    If fps_helper<200 then Inc(fps_helper) else fps_helper:=1;
  End;

  {stopky}
  If StopkyActive=True then Inc(StopkyTics);

  {Player=80 = je prave jedna setina vteriny}
  If player<80 then Inc(player)
               else player:=1;

  {volat BIOS obsluhu preruseni ?}
  clock_ticks:=clock_ticks+counter;
  If clock_ticks>=$10000 then
  Begin
    clock_ticks:=clock_ticks-$10000;
    asm pushf end;
    BIOSTimerHandler;
  End
  else Port[$20]:=$20; {konec preruseni}
End;


Procedure InitTimer;
Var I: Word;
Begin
  fps_helper:=0;
  clock_ticks:=0;
  counter:=$1234DD div 8000;
  GetIntVec(8,@BIOSTimerHandler);
  SetIntVec(8,Addr(TimerHandler));
  Port[$43]:=$34;
  Port[$40]:=counter mod 256;
  Port[$40]:=counter div 256;
  PrehravatZvuk:=False;

  GetMem(SoundDataP,4000); SoundDataSeg:=Seg(SoundDataP^);
  GetMem(ZvukTabP,208); ZvukTabSeg:=Seg(ZvukTabP^);

  For I:=0 to 3999 do mem[SoundDataSeg:I]:=0;
  For I:=0 to 207 do mem[ZvukTabSeg:I]:=0;

  For I:=0 to 255 do
  Begin
    Blink[I]:=False;
    Blink2[I]:=0;
  End;
  Blinking:=False;
  BlinkingCounter:=0;
End;


Procedure ShutdownTimer;
Begin
  Port[$43]:=$34;
  Port[$40]:=0;
  Port[$40]:=0;
  SetIntVec(8, @BIOSTimerHandler);
  PrehravatZvuk:=False;
  FreeMem(SoundDataP,4000);
  FreeMem(ZvukTabP,208);
End;


Procedure InitRawBuffers;
Begin
  PocetRawu:=0;
End;


Procedure ShutdownRawBuffers;
Var I: Byte;
Begin
  If PocetRawu>0 then
  For I:=0 to PocetRawu-1 do
  UvolniXMS(Sample[I].Handle);
End;


Procedure MovArraysTo1; {SoundData a ZvukTab => RLE}
Var I: Word;
Begin
  For I:=0 to 1999 do
  Begin
    mem[RLESeg:2*I]:=Byte(memW[SoundDataSeg:I*2] SHR 8);      {hornich 8bitu}
    mem[RLESeg:2*I+1]:=Byte(memW[SoundDataSeg:I*2] AND 255);  {dolnich 8bitu}
  End;
  For I:=0 to 99 do
  Begin
    mem[RLESeg:2*I+4000]:=Byte(memW[ZvukTabSeg:I*2] SHR 8);   {hornich 8bitu}
    mem[RLESeg:2*I+4001]:=Byte(memW[ZvukTabSeg:I*2] AND 255); {dolnich 8bitu}
  End;
End;


Procedure MovArrayTo2; {RLE => SoundData a ZvukTab}
Var I,A: Word;
Begin
  A:=0;
  For I:=0 to 1999 do
  Begin
    memW[SoundDataSeg:I*2]:=mem[RLESeg:A];
    memW[SoundDataSeg:I*2]:=(memW[SoundDataSeg:I*2] SHL 8) OR mem[RLESeg:A+1];
    Inc(A,2);
  End;
  For I:=0 to 99 do
  Begin
    memW[ZvukTabSeg:I*2]:=mem[RLESeg:A];
    memW[ZvukTabSeg:I*2]:=(memW[ZvukTabSeg:I*2] SHL 8) OR mem[RLESeg:A+1];
    Inc(A,2);
  End;
End;


Procedure LoadSNDFile(Filename:String;Pozice:LongInt);
Var I: Word;
    ReadByte: Byte;
Begin
  Assign(F,Filename);
  Reset(F,1);
  Seek(F,Pozice);
  BlockRead(F,RLEdelka,2);
  RLEDekompress;
  MovArrayTo2;
  Close(F);
End;


Procedure SaveSNDFile(Filename: String);
Var I: Word;
    WritedByte: Byte;
Begin
  Assign(F,Filename);
  ReWrite(F,1);
  MovArraysTo1;                          {SoundData a ZvukTab => RLE}
  RLEKompress(4200);                     {RLE => RLEkompressed}
  BlockWrite(F,RLEDelka,2);              {zapsat delku}
  For I:=1 to RLEDelka do
  Begin
    WritedByte:=mem[RLEKompressedSeg:I-1];
    BlockWrite(F,WritedByte,1);
  End;
  Close(F);
End;


Procedure LoadRAWFile(filename:String;Pozice:LongInt;N:Byte); {do 32KB}
Var F: File;
    ReadByte: Byte;
    ReadWord: Word;
    Velikost: Word;
    Casti,I: LongInt;
Begin
  Assign(F,filename);
  Reset(F,1);
  Seek(F,Pozice);
  BlockRead(F,Sample[N].Delka,4);
  Velikost:=(Sample[N].Delka div 1000)+1;
  Sample[N].Handle:=AlokujXMS(Velikost);
  If Sample[N].Delka<32768 then
  Begin
    For I:=0 to Sample[N].Delka-1 do
    Begin
      BlockRead(F,ReadByte,1);
      mem[Buffer[0]:I]:=ReadByte;
    End;
    If Odd(Sample[N].Delka)
    then MoveToXMS(Sample[N].Handle,0,mem[Buffer[0]:0],Sample[N].Delka-1)
    else MoveToXMS(Sample[N].Handle,0,mem[Buffer[0]:0],Sample[N].Delka);
  End else
  Begin
    Casti:=Sample[N].Delka SHR 1;
    For I:=0 to Casti-1 do
    Begin
      BlockRead(F,ReadWord,2);
      memW[Buffer[0]:0]:=ReadWord;
      MoveToXMS(Sample[N].Handle,I*2,mem[Buffer[0]:0],2);
    End;
  End;
  Close(F);
  Inc(PocetRawu);
End;


Procedure PlaySound(Sample:Byte);
Begin
  PrehravatZvuk:=True;
  CisloZvuku:=Sample;
  PosuvZ:=0;
  Silence;
End;


Procedure PlayRaw(Cislo:Byte);
Var I: Word;
Begin
  Inline($FA); {CLI}
  For I:=0 to 32767 do mem[Buffer[0]:I]:=0;
  If Odd(Sample[Cislo].Delka)
  then MoveFromXMS(Sample[Cislo].Handle,0,mem[Buffer[0]:0],Sample[Cislo].Delka-1)
  else MoveFromXMS(Sample[Cislo].Handle,0,mem[Buffer[0]:0],Sample[Cislo].Delka);
  Sample[Cislo].Pocitadlo:=0;
  PrehravanyZvuk:=Cislo;
  OffsetSpeakeru:=0;
  RawHraje:=True;
  Inline($FB); {STI}
End;


Procedure StopPlay;
Begin
  RawHraje:=False;
  PrehravatZvuk:=False;
  Silence;
End;


{SECTION MOUSE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure InitMouse; Assembler;
Asm
  MOV AX, 00H
  INT 33H
End;


Procedure ShowMouse; Assembler;
Asm
  MOV AX, 01H
  INT 33H
End;


Procedure HideMouse; Assembler;
Asm
  MOV AX, 02H
  INT 33H
End;


Function GetMouseX: Word; Assembler;
Asm
  MOV AX, 03H
  INT 33H
  MOV AX, CX
End;


Function GetMouseY: Word; Assembler;
Asm
  MOV AX, 03H
  INT 33H
  MOV AX, DX
End;


Function GetButton1: Byte; Assembler;
Asm
  MOV AX, 03H
  INT 33H
  AND BX, 0000000000000001b
  MOV AL, BL
End;


Function GetButton2: Byte; Assembler;
Asm
  MOV AX, 03H
  INT 33H
  AND BX, 0000000000000010b
  SHR BX, 1
  MOV AL, BL
End;


Function GetButton3: Byte; Assembler;
Asm
  MOV AX, 03H
  INT 33H
  AND BX, 0000000000000100b
  SHR BX, 2
  MOV AL, BL
End;


Procedure SetMouseXY(X,Y: Word); Assembler;
Asm
  MOV AX, 04H
  MOV CX, X
  MOV DX, Y
  INT 33H
End;


Procedure SetMouseRozsah(X1,Y1,X2,Y2: Word); Assembler;
Asm
  MOV AX, 07H
  MOV CX, X1
  MOV DX, X2
  INT 33H
  MOV AX, 08H
  MOV CX, Y1
  MOV DX, Y2
  INT 33H
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.

{klavesy xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}
{2}  1  {16} Q  {30} A  {45} X  {1}  Esc        {59} F1   {72} KeyPadUp
{3}  2  {17} W  {31} S  {46} C  {15} TAB        {60} F2   {80} KeyPadDown
{4}  3  {18} E  {32} D  {47} V  {28} Enter      {61} F3   {75} KeyPadLeft
{5}  4  {19} R  {33} F  {48} B  {14} BackSpace  {62} F4   {77} KeyPadRight
{6}  5  {20} T  {34} G  {49} N  {57} Space      {63} F5
{7}  6  {21} Y  {35} H  {50} M                  {64} F6   {71} KeyPadHome
{8}  7  {22} U  {36} J          {12} Minus      {65} F7   {79} KeyPadEnd
{9}  8  {23} I  {37} K          {13} Plus       {66} F8   {73} KeyPadPgUp
{10} 9  {24} O  {38} L          {53} Lomitko    {67} F9   {81} KeyPadPgDn
{11} 0  {25} P  {44} Z          {55} Hvezdicka  {68} F10  {82} KeyPadIns
                                                {87} F11  {83} KeyPadDel
{26} HranataZavorka1    {58} CapsLock           {88} F12
{27} HranataZavorka2    {69} NumLock
{41} Semicolon          {70} ScrollLock      {29} LeftControl
{39} Strednik           {76} KeyPad5         {56} LeftAlt
{40} Uvozovka           {78} KeyPadPlus      {42} LeftShift
{51} Carka              {74} KeyPadMinus     {54} RightShift
{52} Tecka
{xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}
