{$MODE FPC}
{$Q-}{$R-}{$S-}{$D-}
Unit Alpha;
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Interface

Var
  Key: array[0..127] of Boolean;
  Buffer: array[1..4] of Word;

 {Graphics}
  Procedure Init320x200;
  Procedure Init80x25;
  Procedure WaitRetrace;

  Procedure InitBuffers;
  Procedure ShutdownBuffers;

  Procedure GetPal(Color:Byte; Var R,G,B:Byte);
  Procedure SetPal(Color:Byte; R,G,B:Byte);

  Procedure LoadGRPage(JmenoSouboru:string;Pozice:LongInt);
  Procedure LoadBmpFile(JmenoSouboru: string; pozice: LongInt; StartColor: Byte);
  Procedure LoadBlok(x1,y1,x2,y2,x3,y3,BufferTo: Word);
  Procedure LoadBlokM(x1,y1,x2,y2,x3,y3,BufferTo: Word);
  Procedure LoadSprite(x1,y1,x2,y2,x3,y3,BufferTo: Word);
  Procedure LoadSpriteM(x1,y1,x2,y2,x3,y3,BufferTo: Word);
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


 {Texter}
  Procedure InitTexter(Barva:Byte);
  Procedure ShutdownTexter;
  Procedure ChangeTexterColor(Barva:Byte);
  Procedure OutText(X,Y:Word;retezec:string;BufferTo:Word);
  Procedure OutNumber(x,y:Word;Cislo:Longint;Small:Boolean;BufferTo:Word);


 {Mapa}
  Procedure LoadMapFile(soubor:string; pozice:Longint);
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

  {PC Speaker}
  Procedure LoadSNDFile(Filename:String;Pozice:LongInt);
  Procedure LoadRAWFile(filename:String;Pozice:LongInt;N:Byte); {do 32KB}

  Procedure PlaySound(Cislo:Byte);
  Procedure PlayRaw(Cislo:Byte);
  Procedure StopPlay;


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

Uses DOS,Go32;

Type
  TRGB= Record
          R: Byte;
          G: Byte;
          B: Byte;
        End;

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
           Palette: array[0..15] of TBmpRGB;
           DataByte: Byte;
         End;

  TMapa = Record
            MapBuffer: array[0..63999] of Byte;
            MapBufferRLE: array[0..63999] of Byte;
            DelkaRLE: Word;
          End;

  TSample = Record
              Delka: LongInt;
              Pocitadlo: Word;
            End;

  TSampleData = Record
                  Data: array[0..31999] of Byte;
                End;

  TKompress = Record
                DataB: array[0..9999] of Byte;
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

  int1c = $1c;
  kbdint = $9;

  MaxRawu = 50;

   DMA8reg : array[0..2] of byte = ($a,$b,$c);
   DMA16reg : array[0..2] of byte = ($d4,$d6,$d8);
   DMAOfs : array[0..7] of byte = (0,2,4,6,$c0,$c4,$c8,$cc);
   DMAVel : array[0..7] of byte = (1,3,5,7,$c2,$c6,$ca,$ce);
   DMAstr : array[0..7] of byte = ($87,$83,$81,$82,$89,$8a,$8b,$8f);
   INTvec : array[0..15] of byte = (8,9,10,11,12,13,14,15,$70,$71,$72,$73,$74,$75,$76,$77);


Var
  F: File;
  Bmp: TBMP;
  Map: TMapa;
  RLEKompressed: array[1..3] of TKompress;
  RLE: array[1..3] of TKompress;
  RLEdelka: Word;
  b: array[0..7] of Byte;

  Grafika: array[0..7999] of Byte;
  Barvy4:  array[0..999] of Byte;
  Paleta:  array[0..47] of Byte;
  Barva: array[0..15] of TRGB;
  Buffer2: array[0..1999] of Byte;
  BufferSel: array[1..3] of Word;
  BufferL: array[1..3] of LongInt;
  Buffer0: array[0..31999] of Byte;

  BufferC : array[0..1434] of Byte;
  BufferC1: array[0..349] of Byte;
  BufferC2: array[0..279] of Byte;
  BufferC3: array[0..1055] of Byte;

  CisloStranky: Byte;
  TexterColor: Byte;

  clickproc : pointer;
  oldint9_handler : tseginfo;
  newint9_handler : tseginfo;
  Backup1DS : Word; external name '___v2prt0_ds_alias';
  PressedKey: Byte;

  timerproc: pointer;
  oldint1c : tseginfo;
  newint1c : tseginfo;
  Backup2DS : Word; external name '___v2prt0_ds_alias';

  StopkyTics: LongInt;
  StopkyActive: Boolean;
  stopky: LongInt;

  SoundData: array[0..1999] of Word;
  ZvukTab: array[0..99] of Word;

  CisloZvuku: Byte;

  delaycounter: Word;
  waiting: Boolean;
  player: Byte;
  fps_helper: Byte;

  PrehravatZvuk: Boolean;
  PosuvZ: Word;
  PrehravanyZvuk: Byte;
  PocetRawu: Byte;
  Sample: array[0..MaxRawu] of TSample;
  SampleData: array[0..MaxRawu] of TSampleData;
  SPBuffer: array[0..31999] of Byte;

  RawHraje: Boolean;
  OffsetSpeakeru: Word;

  IRQ,DMA8,DMA16 : byte;
  Adr : word;
  Typ : byte;

  SBproc : pointer;
  StaraSBObsluha : tseginfo;
  intSBHandler : tseginfo;
  Backup3DS : Word; external name '___v2prt0_ds_alias';

  SBbuffer : pointer;
  SBBufferSeg: Word;
  LinearAdr : longint;
  Stranka,OfsStranky : word;
  AktCast : byte;
  SBOffsetMIN: Word;
  SBOffsetMAX: Word;
  DelkaZbytku: LongInt;
  AktPos: LongInt;
  CisloRawu: Byte;


{SECTION MISC XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure MovArrayTo2; {RLE => SoundData a ZvukTab}
Var I,A: Word;
Begin
  A:=0;
  For I:=0 to 1999 do
  Begin
    SoundData[I]:=RLE[2].DataB[A];
    SoundData[I]:=(SoundData[I] SHL 8) OR RLE[2].DataB[A+1];
    Inc(A,2);
  End;
  For I:=0 to 99 do
  Begin
    ZvukTab[I]:=RLE[2].DataB[A];
    ZvukTab[I]:=(ZvukTab[I] SHL 8) OR RLE[2].DataB[A+1];
    Inc(A,2);
  End;
End;


Procedure MovArraysTo3;
Var I,A: Word;
Begin
  A:=0;
  For I:=0 to 7999 do Begin Grafika[I]:=RLE[1].DataB[A]; Inc(A); End;
  For I:=0 to 999 do Begin Barvy4[I]:=RLE[1].DataB[A]; Inc(A); End;
  For I:=0 to 47 do Begin Paleta[I]:=RLE[1].DataB[A]; Inc(A); End;
  CisloStranky:=RLE[1].DataB[9048];
End;


Procedure RLEDekompress(H: Byte);
Var
  WritedBA: Byte; {znak A}
  WritedBB: Byte; {je-li komprese tak stejny jako znak A}
  WritedBC: Byte; {pocet kolikrat tam je znak A }
  I,A,posun: Word;
Begin
    I:=0; posun:=0;
    While not (posun=RLEDelka) do
    Begin

      WritedBA:=RLEKompressed[H].DataB[posun]; {nacteme A}
      Inc(posun);
      If posun=RLEDelka then                 {je-li konec zapsat a BREAK}
      Begin
        RLE[H].DataB[I]:=WritedBA;
        Break;
      End;

      WritedBB:=RLEKompressed[H].DataB[posun]; {nacteme B}
      Inc(posun);

      If posun=RLEDelka then               {je-li konec zapsat a BREAK}
      Begin
        RLE[H].DataB[I]:=WritedBA;
        RLE[H].DataB[I+1]:=WritedBB;
        Break;
      End;

      If WritedBA=WritedBB then  {jsou-li dva stejne tzn. nasleduje pocet}
      Begin
        WritedBC:=RLEKompressed[H].DataB[posun]; {muzeme nacist pocet}
        Inc(posun);
        For A:=1 to WritedBC do
        Begin
          RLE[H].DataB[I]:=WritedBA; {zapisujeme WritedBC krat}
          Inc(I);
        End;
      End else {jsou dva ruzne}
      Begin
        RLE[H].DataB[I]:=WritedBA;   {zapisme jeden a navrat nahoru}
        Inc(I);
        Dec(posun);         {posuneme index o jednu nazpet}
      End;

    End; {While End}
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
   OutPortB($3c7,Color);
   R:=InPortB($3c9);
   G:=InPortB($3c9);
   B:=InPortB($3c9);
End;


Procedure SetPal(Color:Byte; R,G,B:Byte);
Begin
   OutPortB($3c8,Color);
   OutPortB($3c9,R);
   OutPortB($3c9,G);
   OutPortB($3c9,B);
End;


Procedure Rozkodovat;
Var Offset32,Offset2,Xa,Ya,X1,Y1,x,y,A,I: Word;
    GrafikaB,GrafikaX: Word;
    BarvyB,BarvyX: Word;
Begin
  {Rozkodovani grafiky 8000B}
  A:=0; I:=0;
  Repeat
    GrafikaB:=Grafika[I];
    GrafikaX:=GrafikaB AND 3;     {0000 0000 0000 0011}
    Buffer0[A+0]:=GrafikaX;
    GrafikaX:=GrafikaB AND 12;    {0000 0000 0000 1100}
    Buffer0[A+1]:=GrafikaX SHR 2;
    GrafikaX:=GrafikaB AND 48;    {0000 0000 0011 0000}
    Buffer0[A+2]:=GrafikaX SHR 4;
    GrafikaX:=GrafikaB AND 192;   {0000 0000 1100 0000}
    Buffer0[A+3]:=GrafikaX SHR 6;
    Inc(A,4);
    Inc(I);
  Until I=8000;
  {Rozkodovani barvy4 2000B}
  A:=0; I:=0;
  Repeat
    BarvyB:=Barvy4[I];
    BarvyX:=BarvyB AND 15;       {0000 0000 0000 1111}
    Buffer2[A+0]:=BarvyX;
    BarvyX:=BarvyB AND 240;      {0000 0000 1111 0000}
    Buffer2[A+1]:=BarvyX SHR 4;
    Inc(A,2);
    Inc(I);
  Until I=1000;
  {Nahravani palety RGB ze souboru}
  A:=0;
  For I:=0 to 15 do
  Begin
    Barva[I].R:=Paleta[A+0];
    Barva[I].G:=Paleta[A+1];
    Barva[I].B:=Paleta[A+2];
    Inc(A,3);
  End;
  {Nastaveni palety RGB - nutny graficky rezim}
  For I:=0 to 15 do SetPal(CisloStranky*16+I,Barva[I].R,Barva[I].G,Barva[I].B);

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
      Case Buffer0[Offset32] of
        0: Begin
             If Buffer2[Offset2+0]>0
             then Buffer0[Offset32]:=Buffer2[Offset2+0]+(CisloStranky*16)
             else Buffer0[Offset32]:=0;
           End;
        1: Begin
             If Buffer2[Offset2+1]>0
             then Buffer0[Offset32]:=Buffer2[Offset2+1]+(CisloStranky*16)
             else Buffer0[Offset32]:=0;
           End;
        2: Begin
             If Buffer2[Offset2+2]>0
             then Buffer0[Offset32]:=Buffer2[Offset2+2]+(CisloStranky*16)
             else Buffer0[Offset32]:=0;
           End;
        3: Begin
             If Buffer2[Offset2+3]>0
             then Buffer0[Offset32]:=Buffer2[Offset2+3]+(CisloStranky*16)
             else Buffer0[Offset32]:=0;
           End;
      End; {Case End}
    End;
  End;
End;


{SECTION GRAPHICS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
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
  For I:=1 to 3 do
  Begin
    BufferL[I]:=Global_DOS_Alloc(64000);
    BufferSel[I]:=Word(BufferL[I]);
    Buffer[I]:=Word(BufferL[I] SHR 16);
    For x:=0 to 63999 do mem[Buffer[I]:x]:=0;
  End;

  Buffer[4]:=$A000;
End;


Procedure ShutdownBuffers;
Var I: Byte;
Begin
  For I:=1 to 3 do Global_DOS_Free(BufferSel[I]);
End;


Procedure LoadGRPage(JmenoSouboru:string;Pozice:LongInt);
Var I: Word;
    WritedByte: Byte;
Begin
  Assign(F,JmenoSouboru);
  Reset(F,1);
  Seek(F,Pozice);
  BlockRead(F,RLEdelka,2);             {nacist delku}
  For I:=1 to RLEDelka do
  Begin
    BlockRead(F,WritedByte,1);
    RLEKompressed[1].DataB[I-1]:=WritedByte;
  End;
  RLEDekompress(1);                    {RLEkompressed => RLE}
  MovArraysTo3;                        {RLE => arrays}
  Rozkodovat;
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
  BlockRead(F,BMP.Header.Id,2);
  BlockRead(F,BMP.Header.Velikost,4);
  BlockRead(F,BMP.Header.Reserved,4);
  BlockRead(F,BMP.Header.DataOffset,4);
  BlockRead(F,BMP.Header.HeaderSize,4);
  BlockRead(F,BMP.Header.RozsahX,4);
  BlockRead(F,BMP.Header.RozsahY,4);
  BlockRead(F,BMP.Header.BitPlanes,2);
  BlockRead(F,BMP.Header.BPP,2);
  BlockRead(F,BMP.Header.Komprese,4);
  BlockRead(F,BMP.Header.ImageSize,4);
  BlockRead(F,BMP.Header.HorizontalRes,4);
  BlockRead(F,BMP.Header.VerticalRes,4);
  BlockRead(F,BMP.Header.Colors,4);
  BlockRead(F,BMP.Header.ImportantColors,4);

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
    Buffer0[N]:=StartColor+Pixel1;
    Buffer0[N+1]:=StartColor+Pixel2;
    Inc(N,2);
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
      mem[BufferTo:Offset1]:=Buffer0[Offset2];
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
      mem[BufferTo:Offset1]:=Buffer0[Offset2];
      inc(Xa);
    End;
    Xa:=x1; Inc(Ya);
  End;
End;


Procedure LoadSprite(x1,y1,x2,y2,x3,y3,BufferTo: Word);
Var Xa,Ya,x,y,Offset1,Offset2: Word;
Begin
  Xa:=x1; Ya:=y1;
  For y:=y2 to y3 do
  Begin
    For x:=x2 to x3 do
    Begin
      Offset1:=Ya*320+Xa; Offset2:=y*160+x;
      If Buffer0[Offset2]>0 then
      mem[BufferTo:Offset1]:=Buffer0[Offset2];
      inc(Xa);
    End;
    Xa:=x1; Inc(Ya);
  End;
End;


Procedure LoadSpriteM(x1,y1,x2,y2,x3,y3,BufferTo: Word);
Var Xa,Ya,x,y,Offset1,Offset2: Word;
Begin
  Xa:=x1; Ya:=y1;
  For y:=y2 to y3 do
  Begin
    For x:=x3 downto x2 do
    Begin
      Offset1:=Ya*320+Xa; Offset2:=y*160+x;
      If Buffer0[Offset2]>0 then
      mem[BufferTo:Offset1]:=Buffer0[Offset2];
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
    mem[BufferTo:Offset1]:=Buffer0[Offset2];
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
    mem[BufferTo:Offset1]:=Buffer0[Offset2];
    Inc(Offset2);
  End;
End;


Function ReadPixel(X,Y,Buffer:Word): Byte;
Begin
  ReadPixel:=mem[Buffer:Y*320+X];
End;


Procedure WritePixel(X:Word;Y,Color:Byte;Buffer:Word);
Begin
  mem[Buffer:Y*320+X]:=Color;
End;


Procedure Blok(x1,y1,x2,y2,Color,Buffer:Word);
Var Off,X,Y,delka,del,vyska,zbytek: Word;
    pocet: Byte;
    ColorL: LongInt;
Begin
  delka:=x2-x1+1;
  vyska:=y2-y1+1;
  pocet:=delka SHR 2;
  zbytek:=delka-(pocet SHL 2);
  del:=delka-zbytek;

  ColorL:=Color;
  ColorL:=ColorL SHL 8;
  Inc(ColorL,Color);
  ColorL:=ColorL SHL 8;
  Inc(ColorL,Color);
  ColorL:=ColorL SHL 8;
  Inc(ColorL,Color);

  If delka<4
  then Begin
         If zbytek>0 then
         Begin
           Off:=y1*320+x2-zbytek+1;
           For Y:=0 to vyska-1 do
           Begin
             For X:=0 to zbytek-1 do
             Begin
               mem[Buffer:Off]:=Color;
               Inc(Off);
             End;
             Dec(Off,zbytek);
             Inc(Off,320);
           End;
         End;
       End
  else Begin
         Off:=y1*320+x1;
         For Y:=0 to vyska-1 do
         Begin
           For X:=0 to pocet-1 do
           Begin
             memL[Buffer:Off]:=ColorL;
             Inc(Off,4);
           End;
           Dec(Off,del);
           Inc(Off,320);
         End;

         If zbytek>0 then
         Begin
           Off:=y1*320+x2-zbytek+1;
           For Y:=0 to vyska-1 do
           Begin
             For X:=0 to zbytek-1 do
             Begin
               mem[Buffer:Off]:=Color;
               Inc(Off);
             End;
             Dec(Off,zbytek);
             Inc(Off,320);
           End;
         End;
       End;
End;


Procedure Ramecek(X1,Y1,X2,Y2:Word;Color:Byte;Buffer:Word);
Var Off,X,Y,delka,del,vyska,zbytek: Word;
    pocet: Byte;
    ColorL: LongInt;
Begin
  delka:=X2-X1+1;
  vyska:=Y2-Y1+1;
  pocet:=delka SHR 2;
  zbytek:=delka-(pocet SHL 2);
  del:=delka-zbytek;

  ColorL:=Color;
  ColorL:=ColorL SHL 8;
  Inc(ColorL,Color);
  ColorL:=ColorL SHL 8;
  Inc(ColorL,Color);
  ColorL:=ColorL SHL 8;
  Inc(ColorL,Color);

  If delka<4
  then Begin
         If zbytek>0 then
         Begin
           Off:=Y1*320+X1;
           For Y:=0 to vyska-1 do
           Begin
             mem[Buffer:Off]:=Color;
             Inc(Off,320);
           End;
           Off:=Y1*320+X1;
           For X:=0 to zbytek-1 do
           Begin
             mem[Buffer:Off]:=Color;
             Inc(Off);
           End;
           Off:=Y2*320+X1;
           For X:=0 to zbytek-1 do
           Begin
             mem[Buffer:Off]:=Color;
             Inc(Off);
           End;
           Off:=Y1*320+X2;
           For Y:=0 to vyska-1 do
           Begin
             mem[Buffer:Off]:=Color;
             Inc(Off,320);
           End;
         End;
       End
  else Begin
         Off:=Y1*320+X1;
         For Y:=0 to vyska-1 do
         Begin
           mem[Buffer:Off]:=Color;
           Inc(Off,320);
         End;
         Off:=Y1*320+X1;
         For X:=0 to pocet-1 do
         Begin
           memL[Buffer:Off]:=ColorL;
           Inc(Off,4);
         End;
         Off:=Y2*320+X1;
         For X:=0 to pocet-1 do
         Begin
           memL[Buffer:Off]:=ColorL;
           Inc(Off,4);
         End;
         Off:=Y1*320+X2;
         For Y:=0 to vyska-1 do
         Begin
           mem[Buffer:Off]:=Color;
           Inc(Off,320);
         End;
         If zbytek>0 then
         Begin
           Off:=Y1*320+X2-zbytek;
           For X:=0 to zbytek-1 do
           Begin
             mem[Buffer:Off]:=Color;
             Inc(Off);
           End;
           Off:=Y2*320+X2-zbytek;
           For X:=0 to zbytek-1 do
           Begin
             mem[Buffer:Off]:=Color;
             Inc(Off);
           End;
         End;
       End;
End;


Procedure WriteBlok(x1,y1,x2,y2,x3,y3,BufferFrom,BufferTo: Word);
Var Off1,Off2,X,Y,delka,del,vyska,zbytek: Word;
    pocet: Byte;
Begin
  delka:=x3-x2+1;
  vyska:=y3-y2+1;
  pocet:=delka SHR 2;
  zbytek:=delka-(pocet SHL 2);
  del:=delka-zbytek;

  If delka<4
  then Begin
         If zbytek>0 then
         Begin
           Off1:=y1*320+x1+del;
           Off2:=y2*320+x2+del;
           For Y:=0 to vyska-1 do
           Begin
             For X:=0 to zbytek-1 do
             Begin
               mem[BufferTo:Off1]:=mem[BufferFrom:Off2];
               Inc(Off1);
               Inc(Off2);
             End;
             Dec(Off1,zbytek);
             Inc(Off1,320);
             Dec(Off2,zbytek);
             Inc(Off2,320);
           End;
         End;
       End
  else Begin
         Off1:=y1*320+x1;
         Off2:=y2*320+x2;
         For Y:=0 to vyska-1 do
         Begin
           For X:=0 to pocet-1 do
           Begin
             memL[BufferTo:Off1]:=memL[BufferFrom:Off2];
             Inc(Off1,4);
             Inc(Off2,4);
           End;
           Dec(Off1,del);
           Inc(Off1,320);
           Dec(Off2,del);
           Inc(Off2,320);
         End;

         If zbytek>0 then
         Begin
           Off1:=y1*320+x1+del;
           Off2:=y2*320+x2+del;
           For Y:=0 to vyska-1 do
           Begin
             For X:=0 to zbytek-1 do
             Begin
               mem[BufferTo:Off1]:=mem[BufferFrom:Off2];
               Inc(Off1);
               Inc(Off2);
             End;
             Dec(Off1,zbytek);
             Inc(Off1,320);
             Dec(Off2,zbytek);
             Inc(Off2,320);
           End;
         End;
       End;
End;


Procedure WriteSprite(x1,y1,x2,y2,x3,y3,BufferFrom,BufferTo: Word);
Var Off1,Off2,X,Y,delka,del,vyska,zbytek: Word;
    pocet,I: Byte;
Begin
  delka:=x3-x2+1;
  vyska:=y3-y2+1;
  pocet:=delka SHR 2;
  zbytek:=delka-(pocet SHL 2);
  del:=delka-zbytek;

  If delka<4
  then Begin
         If zbytek>0 then
         Begin
           Off1:=y1*320+x1+del;
           Off2:=y2*320+x2+del;
           For Y:=0 to vyska-1 do
           Begin
             For X:=0 to zbytek-1 do
             Begin
               If mem[BufferFrom:Off2]>0 then
               mem[BufferTo:Off1]:=mem[BufferFrom:Off2];
               Inc(Off1);
               Inc(Off2);
             End;
             Dec(Off1,zbytek);
             Inc(Off1,320);
             Dec(Off2,zbytek);
             Inc(Off2,320);
           End;
         End;
       End
  else Begin
         Off1:=y1*320+x1;
         Off2:=y2*320+x2;
         For Y:=0 to vyska-1 do
         Begin
           For X:=0 to pocet-1 do
           Begin
             If ((mem[BufferFrom:Off2]>0) and
                 (mem[BufferFrom:Off2+1]>0) and
                 (mem[BufferFrom:Off2+2]>0) and
                 (mem[BufferFrom:Off2+3]>0)) then
             Begin
               memL[BufferTo:Off1]:=memL[BufferFrom:Off2];
               Inc(Off1,4);
               Inc(Off2,4);
             End else
             Begin
               For I:=0 to 3 do
               Begin
                 If mem[BufferFrom:Off2]>0 then
                 mem[BufferTo:Off1]:=mem[BufferFrom:Off2];
                 Inc(Off1);
                 Inc(Off2);
               End;
             End;
           End;
           Dec(Off1,del);
           Inc(Off1,320);
           Dec(Off2,del);
           Inc(Off2,320);
         End;

         If zbytek>0 then
         Begin
           Off1:=y1*320+x1+del;
           Off2:=y2*320+x2+del;
           For Y:=0 to vyska-1 do
           Begin
             For X:=0 to zbytek-1 do
             Begin
               If mem[BufferFrom:Off2]>0 then
               mem[BufferTo:Off1]:=mem[BufferFrom:Off2];
               Inc(Off1);
               Inc(Off2);
             End;
             Dec(Off1,zbytek);
             Inc(Off1,320);
             Dec(Off2,zbytek);
             Inc(Off2,320);
           End;
         End;
       End;
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

Procedure FlipPage(BufferFrom,BufferTo: Word);
Var A,I: Word;
Begin
  A:=0;
  For I:=0 to 15999 do
  Begin
    memL[BufferTo:A]:=memL[BufferFrom:A];
    Inc(A,4);
  End;
End;


Procedure ClearPage(Buffer:Word);
Var A,I: Word;
Begin
  A:=0;
  For I:=0 to 15999 do
  Begin
    memL[Buffer:A]:=0;
    Inc(A,4);
  End;
End;


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
  TexterColor:=Barva;
  For I:=0 to 204 do
  Begin
    Dec2Bin(Znaky[I]);
    For A:=7 downto 0 do
    If b[A]=1 then BufferC[205*(7-A)+I]:=TexterColor;
  End;

  For I:=0 to 49 do
  Begin
    Dec2Bin(Cifry[I]);
    For A:=7 downto 0 do
    If b[A]=1 then BufferC1[50*(7-A)+I]:=TexterColor;
  End;

  For I:=0 to 39 do
  Begin
    Dec2Bin(SmallCifry[I]);
    For A:=7 downto 0 do
    If b[A]=1 then BufferC2[40*(7-A)+I]:=TexterColor;
  End;

  For I:=0 to 131 do
  Begin
    Dec2Bin(SmallZnaky[I]);
    For A:=7 downto 0 do
    If b[A]=1 then BufferC3[132*(7-A)+I]:=TexterColor;
  End;
End;


Procedure ShutdownTexter;
Begin
End;


Procedure ChangeTexterColor(Barva:Byte);
Begin
  TexterColor:=Barva;
End;


Procedure WriteTexterSprite1(x1,y1,x2,y2,x3,y3,BufferTo:Word);
Var Off1,Off2,X,Y,delka,vyska: Word;
Begin
  delka:=x3-x2+1;
  vyska:=y3-y2+1;

  Off1:=y1*320+x1;
  Off2:=y2*205+x2;
  For Y:=0 to vyska-1 do
  Begin
    For X:=0 to delka-1 do
    Begin
      If BufferC[Off2]>0 then
      mem[BufferTo:Off1]:=TexterColor;
      Inc(Off1);
      Inc(Off2);
    End;
    Dec(Off1,delka);
    Inc(Off1,320);
    Dec(Off2,delka);
    Inc(Off2,205);
  End;
End;


Procedure WriteTexterSprite2(x1,y1,x2,y2,x3,y3,BufferTo:Word);
Var Off1,Off2,X,Y,delka,vyska: Word;
Begin
  delka:=x3-x2+1;
  vyska:=y3-y2+1;

  Off1:=y1*320+x1;
  Off2:=y2*132+x2;
  For Y:=0 to vyska-1 do
  Begin
    For X:=0 to delka-1 do
    Begin
      If BufferC3[Off2]>0 then
      mem[BufferTo:Off1]:=TexterColor;
      Inc(Off1);
      Inc(Off2);
    End;
    Dec(Off1,delka);
    Inc(Off1,320);
    Dec(Off2,delka);
    Inc(Off2,132);
  End;
End;


Procedure WriteCifra(x,y:Word;Cislo:Byte;BufferTo:Word);
Var xa,ya,Offset:Word;
Begin
    For ya:=0 to 6 do
    Begin
      For xa:=0 to 4 do
      Begin
        Offset:=ya*50+((Cislo*5)+xa);
        If BufferC1[Offset]>0 then
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
        If BufferC2[Offset]>0 then
         mem[BufferTo:(y+ya)*320+(x+xa)]:=TexterColor;
      End;
    End;
End;


Procedure WriteChar(X,Y:Word;Znak:Char;BufferTo:Word);
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
    WriteChar(X,Y,retezec[I],BufferTo);
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

    WritedBA:=Map.MapBufferRLE[posun];      {nacteme A}
    Inc(posun);
    If posun=Map.DelkaRLE then               {je-li konec zapsat a BREAK}
    Begin
      Map.MapBuffer[I]:=WritedBA;
      Break;
    End;

    WritedBB:=Map.MapBufferRLE[posun];      {nacteme B}
    Inc(posun);

    If posun=Map.DelkaRLE then          {je-li konec zapsat a BREAK}
    Begin
      Map.MapBuffer[I]:=WritedBA;
      Map.MapBuffer[I+1]:=WritedBB;
      Break;
    End;

    If WritedBA=WritedBB then  {jsou-li dva stejne tzn. nasleduje pocet}
    Begin
      WritedBC:=Map.MapBufferRLE[posun]; {muzeme nacist pocet}
      Inc(posun);
      For A:=1 to WritedBC do
      Begin
        Map.MapBuffer[I]:=WritedBA; {zapisujeme WritedBC krat}
        Inc(I);
      End;
    End else {jsou dva ruzne}
    Begin
      Map.MapBuffer[I]:=WritedBA;   {zapisme jeden a navrat nahoru}
      Inc(I);
      Dec(posun);         {posuneme index o jednu nazpet}
    End;

  End; {While End}
End;


Procedure LoadMapFile(soubor: string; pozice: Longint);
Var
  F: File;
  I: Word;
Begin
  Assign(F,soubor);
  Reset(F,1);
  Seek(F,pozice);
  BlockRead(F,Map.DelkaRLE,2);
  For I:=0 to Map.DelkaRLE do BlockRead(F,Map.MapBufferRLE[I],1);
  Close(F);
  RLEDekompresMap;
End;


Procedure SetMapByte(MapOffset:Word; bajt:Byte);
Begin
  Map.MapBuffer[MapOffset]:=bajt;
End;


Function GetMapByte(MapOffset: Word): Byte;
Begin
  GetMapByte:=Map.MapBuffer[MapOffset];
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
procedure int9_handler; assembler; interrupt;
asm
  cli
  push  ds
  push  es
  push  fs
  push  gs
  pusha
  mov   ax, cs:[Backup1DS]
  mov   ds, ax
  mov   es, ax
  mov   ax, dosmemselector
  mov   fs, ax
  call  clickproc
  popa
  pop   gs
  pop   fs
  pop   es
  pop   ds
  sti
end;


procedure int9_dummy; begin end;


procedure Keyboard;
begin
  PressedKey:=InPortB($60);
  If PressedKey<128 then Key[PressedKey]:=True
                    else Key[PressedKey-128]:=False;
  OutPortB($20,$20);
end;


procedure Keyboard_dummy; begin end;


procedure InitKeyboard;
begin
  clickproc := @Keyboard;
  lock_data(clickproc, sizeof(clickproc));
  lock_data(dosmemselector, sizeof(dosmemselector));
  lock_data(Key, sizeof(Key));
  lock_data(PressedKey, sizeof(PressedKey));
  lock_code(@Keyboard, longint(@Keyboard_dummy) - longint(@Keyboard));
  lock_code(@int9_handler, longint(@int9_dummy)-longint(@int9_handler));
  newint9_handler.offset := @int9_handler;
  newint9_handler.segment := get_cs;
  get_pm_interrupt(kbdint, oldint9_handler);
  set_pm_interrupt(kbdint, newint9_handler);
end;


procedure ShutdownKeyboard;
begin
  set_pm_interrupt(kbdint, oldint9_handler);
  unlock_data(dosmemselector, sizeof(dosmemselector));
  unlock_data(clickproc, sizeof(clickproc));
  unlock_data(PressedKey, sizeof(PressedKey));
  unlock_data(Key, sizeof(Key));
  unlock_code(@Keyboard, longint(@Keyboard_dummy)-longint(@Keyboard));
  unlock_code(@int9_handler, longint(@int9_dummy)-longint(@int9_handler));
end;


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
  Ukazatel := InPortW(DMAOfs[DMA8]);
  Ukazatel := Ukazatel + InPortW(DMAOfs[DMA8]) shl 8;
  GetSBOffset2 := Ukazatel;
End;


procedure GetSBOffset2_dummy; begin end;


Function GetSBOffset: Word;
Var Ukazatel: Word;
Begin
  Ukazatel := InPortW(DMAOfs[DMA8]);
  Ukazatel := Ukazatel + InPortW(DMAOfs[DMA8]) shl 8;
  GetSBOffset := Ukazatel - SBOffsetMIN;
End;


procedure GetSBOffset_dummy; begin end;


Procedure intSB_handler; assembler; interrupt;
asm
cli
push fs
push es
push ds
push ax
   mov  ax,cs:[Backup3DS]
   mov  ds,ax
   mov  es,ax
   mov  ax,dosmemselector
   mov  fs,ax
   call SBProc
pop ax
pop ds
pop es
pop fs
sti
end;


Procedure intSB_handler_dummy; begin end;


procedure SBObsluha; interrupt;
var Prac: byte;
    A,I: Word;
begin
 Prac := InPortB(Adr+$e);
 OutPortB($20,$20);
 If IRQ in [2]+[8..15] then OutPortB($a0,$20);

 Begin
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


procedure SBObsluha_dummy; begin end;


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


procedure DSPwrite_dummy; begin end;


procedure OdmaskujINT;
begin
 case IRQ of
   2 : OutPortB($a1,InPortB($a1) and not 2);
  10 : OutPortB($a1,InPortB($a1) and not 4);
  11 : OutPortB($a1,InPortB($a1) and not 8);
  else OutPortB($21,InPortB($21) and not (1 shl IRQ));
 end;
 if IRQ in [2, 10, 11] then OutPortB($21,InPortB($21) and not 4);
end;


procedure PovolDMA;
begin
 OutPortB(DMA8reg[0],4 or DMA8);
 OutPortB(DMA8reg[2],0);
 OutPortB(DMA8reg[1],$58 or DMA8);
 OutPortB(DMAstr[DMA8],byte(Stranka));
 OutPortB(DMAofs[DMA8],Lo(OfsStranky));
 OutPortB(DMAofs[DMA8],Hi(OfsStranky));
 OutPortB(DMAvel[DMA8],$ff); {lo}
 OutPortB(DMAvel[DMA8],$7f); {hi}
 OutPortB(DMA8reg[0],DMA8);
end;


procedure StartSB; assembler;
asm
  mov   AX, $d1
  push  AX
  call	DSPwrite
  mov   AX, $40
  push	AX
  call	DSPwrite
  mov   AX, 131         {nastavime frekvenci pres konstantu}
  push  AX
  call	DSPwrite
  call	povolDMA
  mov   AX, $48
  push  AX
  call	DSPwrite
  mov   AX, $ff
  push	AX
  call	DSPwrite
  mov   AX, $1f
  push	AX
  call	DSPwrite
  mov   AX, $1c
  push	AX
  call	DSPwrite
end;


procedure ZamaskujINT;
begin
 case IRQ of
   2 : OutPortB($a1,InPortB($a1) or 2);
  10 : OutPortB($a1,InPortB($a1) or 4);
  11 : OutPortB($a1,InPortB($a1) or 8);
  else OutPortB($21,InPortB($21) or (1 shl IRQ));
 end;
 if IRQ in [2,10,11] then OutPortB($21,InPortB($21) or 4);
end;


Procedure odinstINT;
Begin
  set_pm_interrupt(INTvec[IRQ], StaraSBObsluha);
End;


procedure ExitSB; assembler;
asm
   mov  AX, $d9
   push	AX
   call	DSPwrite
   mov  AX, $d0
   push	AX
   call	DSPwrite
   call	odinstINT
   call	ZamaskujINT
   mov  AX, $d3
   push	AX
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

  Begin
    A:=GetSBOffset+200;
    A:=A and $7fff;
    For I:=0 to Sample[Cislo].Delka do
    Begin
      mem[SBBufferSeg:A]:=SampleData[Cislo].Data[I];
      Inc(A);
      A:=A and $7fff;
    End;
  End;
End;


Procedure InitSB;
Begin
  AktCast:=0;

  CtiBlaster;
  VytvorBuffer;

  SBproc := @SBObsluha;
  lock_data(SBproc, sizeof(SBproc));
  lock_data(dosmemselector, sizeof(dosmemselector));

  lock_data(AktCast, sizeof(AktCast));
  lock_data(SBOffsetMIN, sizeof(SBOffsetMIN));
  lock_data(SBOffsetMAX, sizeof(SBOffsetMAX));
  lock_data(SBBuffer,sizeof(SBBuffer));

  lock_code(@GetSBOffset2, longint(@GetSBOffset2_dummy)-longint(@GetSBOffset2));
  lock_code(@GetSBOffset, longint(@GetSBOffset_dummy)-longint(@GetSBOffset));
  lock_code(@SBObsluha, longint(@SBObsluha_dummy)-longint(@SBObsluha));
  lock_code(@DSPWrite, longint(@DSPWrite_dummy)-longint(@DSPWrite));
  lock_code(@intSB_handler, longint(@intSB_handler_dummy)-longint(@intSB_handler));

  intSBHandler.offset := @intSB_handler;
  intSBHandler.segment := get_cs;
  get_pm_interrupt(INTvec[IRQ],StaraSBObsluha);
  set_pm_interrupt(INTvec[IRQ],intSBHandler);

  OdmaskujINT;
  StartSB;
End;


Procedure ShutdownSB;
Begin
  unlock_data(AktCast, sizeof(AktCast));
  unlock_data(SBOffsetMIN, sizeof(SBOffsetMIN));
  unlock_data(SBOffsetMAX, sizeof(SBOffsetMAX));
  unlock_data(SBBuffer,sizeof(SBBuffer));

  unlock_code(@SBObsluha, longint(@SBObsluha_dummy)-longint(@SBObsluha));
  unlock_code(@GetSBOffset2, longint(@GetSBOffset2_dummy)-longint(@GetSBOffset2));
  unlock_code(@GetSBOffset, longint(@GetSBOffset_dummy)-longint(@GetSBOffset));
  unlock_code(@DSPWrite, longint(@DSPWrite_dummy)-longint(@DSPWrite));
  unlock_code(@intSB_handler, longint(@intSB_handler_dummy)-longint(@intSB_handler));

  unlock_data(SBproc, sizeof(SBproc));
  unlock_data(dosmemselector, sizeof(dosmemselector));

  set_pm_interrupt(INTvec[IRQ],StaraSBObsluha);

  ExitSB;
  FreeMem(SBBuffer,32768);
End;


{SECTION TIMER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Wait(ms: Word);
Begin
  delaycounter:=0;
  waiting:=True;
  While delaycounter<ms*8 do Begin End;
  waiting:=False;
  delaycounter:=0;
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


Procedure SoundDummy; begin end;


Procedure Silence; Assembler;
Asm
  IN     AL,61h
  AND    AL,0FCh
  OUT    61h,AL
End;


Procedure SilenceDummy; begin end;


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


Procedure LoadSNDFile(Filename:String;Pozice:LongInt);
Var I: Word;
    ReadByte: Byte;
Begin
  Assign(F,Filename);
  Reset(F,1);
  Seek(F,Pozice);
  BlockRead(F,RLEdelka,2);             {nacist delku}
  For I:=1 to RLEdelka do
  Begin
    BlockRead(F,ReadByte,1);
    RLEKompressed[2].DataB[I-1]:=ReadByte;
  End;
  RLEDekompress(2);                    {RLEkompressed => RLE}
  MovArrayTo2;                         {RLE => SoundData a ZvukTab}
  Close(F);
End;


Procedure LoadRAWFile(filename:String;Pozice:LongInt;N:Byte); {do 32KB}
Var F: File;
    ReadByte: Byte;
    I: Word;
Begin
  Assign(F,filename);
  Reset(F,1);
  Seek(F,Pozice);
  BlockRead(F,Sample[N].Delka,4);
  For I:=0 to Sample[N].Delka-1 do
  Begin
    BlockRead(F,ReadByte,1);
    SampleData[N].Data[I]:=ReadByte;
  End;
  Close(F);
End;


Procedure PlaySound(Cislo:Byte);
Begin
  RawHraje:=False;
  Sample[PrehravanyZvuk].Pocitadlo:=0;
  OffsetSpeakeru:=0;

  CisloZvuku:=Cislo;
  PosuvZ:=0;
  PrehravatZvuk:=True;
End;


Procedure PlayRaw(Cislo:Byte);
Var
  I: Word;
Begin
  For I:=0 to Sample[Cislo].Delka-1 do SPBuffer[I]:=SampleData[Cislo].Data[I];
  PrehravanyZvuk:=Cislo;
  Sample[Cislo].Pocitadlo:=0;
  OffsetSpeakeru:=0;
  PrehravatZvuk:=False;
  RawHraje:=True;
End;


Procedure StopPlay;
Begin
  RawHraje:=False;
  PrehravatZvuk:=False;
  Silence;
End;


Procedure int1c_handler; assembler; interrupt;
asm
cli
push fs
push es
push ds
push ax
   mov  ax,cs:[Backup2DS]
   mov  ds,ax
   mov  es,ax
   mov  ax,dosmemselector
   mov  fs,ax
   call TimerProc
pop ax
pop ds
pop es
pop fs
sti
end;


Procedure HandlerDummy;begin end;


Procedure MujCasovacDummy;begin end;


Procedure MujCasovac;
Var I,A: Word;
begin
  {zpozdovac}
  If waiting=True then Inc(delaycounter); {je prave jedna milisekunda}

  {prehravani rawu}
  If RawHraje=True then
  Begin
    If SPBuffer[OffsetSpeakeru]>$80
    then Sound(22050) else Silence;

    Inc(Sample[PrehravanyZvuk].Pocitadlo);
    Inc(OffsetSpeakeru);
    If Sample[PrehravanyZvuk].Pocitadlo=Sample[PrehravanyZvuk].Delka
    then Begin
           RawHraje:=False;
           Sample[PrehravanyZvuk].Pocitadlo:=0;
           OffsetSpeakeru:=0;
           Silence;
         End;
  End;

  {prehravani zvuku}
  If player=80 then
  If PrehravatZvuk=True then
  Begin
    If SoundData[ZvukTab[CisloZvuku*2]+PosuvZ]>0
    then Sound(SoundData[ZvukTab[CisloZvuku*2]+PosuvZ])
    else Sound(10);
    Inc(PosuvZ);
    If PosuvZ>ZvukTab[CisloZvuku*2+1] then {prehrali jsme celou delku zvuku}
    Begin
      PrehravatZvuk:=False;
      PosuvZ:=0;
      Silence;
    End
  End;

  {helper pro vypocet fps kazde 2 sekundy}
  If player=80 then {je setina vteriny ?}
  Begin
    If fps_helper<200 then Inc(fps_helper) else fps_helper:=0;
  End;

  {If Player=80 then: je prave jedna setina vteriny}
  If player<80 then Inc(player)
               else player:=0;

  {stopky}
  If StopkyActive=True then
  Begin
    If stopky<7
    then Begin
           Inc(stopky);
         End
    else Begin
          stopky:=0;
          Inc(StopkyTics);
         End;
  End;

OutPortB($20,$20);
end;


Procedure InitTimer;
var i : Longint;
    counter:longint;
begin
  timerproc:=@MujCasovac;

  lock_data(timerproc, sizeof(timerproc));
  lock_data(dosmemselector, sizeof(dosmemselector));

  lock_data(waiting, sizeof(waiting));
  lock_data(delaycounter, sizeof(delaycounter));
  lock_data(player, sizeof(player));
  lock_data(PrehravatZvuk, sizeof(PrehravatZvuk));
  lock_data(SoundData, sizeof(SoundData));
  lock_data(ZvukTab, sizeof(ZvukTab));
  lock_data(CisloZvuku, sizeof(CisloZvuku));
  lock_data(PosuvZ, sizeof(PosuvZ));
  lock_data(Sample,sizeof(Sample));
  lock_data(PrehravanyZvuk,sizeof(PrehravanyZvuk));
  lock_data(SPBuffer,sizeof(SPBuffer));
  lock_data(OffsetSpeakeru,sizeof(OffsetSpeakeru));
  lock_data(RawHraje,sizeof(RawHraje));
  lock_data(fps_helper, sizeof(fps_helper));
  lock_data(StopkyActive, sizeof(StopkyActive));
  lock_data(StopkyTics, sizeof(StopkyTics));

  lock_code(@Sound,longint(@SoundDummy) - longint(@Sound));
  lock_code(@Silence,longint(@SilenceDummy) - longint(@Silence));

  lock_code(@MujCasovac,longint(@MujCasovacDummy) - longint(@MujCasovac));
  lock_code(@int1c_handler,longint(@HandlerDummy)-longint(@int1c_handler));

  newint1c.offset := @int1c_handler;
  newint1c.segment := get_cs;
  get_pm_interrupt(int1c, oldint1c);
  set_pm_interrupt(int1c, newint1c);

  counter:=$1234DD div 8000; {frekvence=8000}
  OutPortB($43,$34);
  OutPortB($40,counter mod 256);
  OutPortB($40,counter div 256);
end;


Procedure ShutdownTimer;
begin
  OutPortB($43,$34);
  OutPortB($40,0);
  OutPortB($40,0);

  unlock_data(waiting, sizeof(waiting));
  unlock_data(delaycounter, sizeof(delaycounter));
  unlock_data(player, sizeof(player));
  unlock_data(PrehravatZvuk, sizeof(PrehravatZvuk));
  unlock_data(SoundData, sizeof(SoundData));
  unlock_data(ZvukTab, sizeof(ZvukTab));
  unlock_data(CisloZvuku, sizeof(CisloZvuku));
  unlock_data(PosuvZ, sizeof(PosuvZ));
  unlock_data(Sample,sizeof(Sample));
  unlock_data(PrehravanyZvuk,sizeof(PrehravanyZvuk));
  unlock_data(SPBuffer,sizeof(SPBuffer));
  unlock_data(OffsetSpeakeru,sizeof(OffsetSpeakeru));
  unlock_data(RawHraje,sizeof(RawHraje));
  unlock_data(fps_helper, sizeof(fps_helper));
  unlock_data(StopkyActive, sizeof(StopkyActive));
  unlock_data(StopkyTics, sizeof(StopkyTics));

  unlock_code(@Sound,longint(@SoundDummy) - longint(@Sound));
  unlock_code(@Silence,longint(@SilenceDummy) - longint(@Silence));

  unlock_data(timerproc, sizeof(timerproc));
  unlock_data(dosmemselector, sizeof(dosmemselector));
  unlock_code(@MujCasovac,longint(@MujCasovacDummy) - longint(@MujCasovac));
  unlock_code(@int1c_handler,longint(@HandlerDummy)-longint(@int1c_handler));
  set_pm_interrupt(int1c, oldint1c);
end;


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
{4}  3  {18} E  {32} D  {47} V  {28} Enter      {61} F3   {75} KeyPadleft
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
