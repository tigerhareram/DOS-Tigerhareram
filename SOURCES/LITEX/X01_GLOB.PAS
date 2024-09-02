{$A-,G+,N+,R-,B-,E-,S-,Q-,V-,X+,F+}

Unit x01_glob;
 {Global Definition}


Interface
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Uses CRT, DOS,

{LiteX}

{Inertia 3D engine}
i_Types, i_Polygo, i_Memory, i_BufIO, i_PCX, i_Shade, i_Inerti,

{Ethan Brodsky smix}
b_xms, b_detect, b_smix;

Type
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{01-Glob}

{02-RAM}     XMSParamBlock = Record                          { XMS Transfer }
                               Length: LongInt;
                               SHandle: Word;                      { source }
                               SOffset: LongInt;
                               DHandle: Word;                      { dest.  }
                               DOffset: LongInt;
                             End;

{03-DOS}    SearchRec = record            {pole DTA pro DOSove funkce Najdi soubor}
                          Fill : array[1..21] of byte;
                          Attr : byte;    {atributy}
                          Time : longint; {cas a datum vytvoreni}
                          Size : longint; {velikost souboru}
                          Name : string[12];
                        end;              {nazvy kompatibilni s ENG Pascalu}
            ComStr = string[127];         {nahrady typu promennych}
            PathStr = string[79];         {cesta k souboru/adresari}
            DirStr = string[67];          {adresar}
            NameStr = string[8];          {nazev souboru}
            ExtStr = string[4];           {pripona souboru}

{04-VGA}     TSprCol = Record                            { 8x8 4 colors GRA }
                         C: array[0..3] Of Byte;
                       End;

             TRGBc = Record                         { 160x200 16 colors GRA }
                       R: Byte;
                       G: Byte;
                       B: Byte;
                       c: Byte;
                     End;

             TBMPHeader = Record                                      { BMP }
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

             TBGRres = Record                                         { BMP }
                         B: Byte;
                         G: Byte;
                         R: Byte;
                         res: Byte;
                       End;

             TBMP = Record                                            { BMP }
                      Header: TBMPHeader;
                      Palette: array[0..255] of TBGRres;
                      DataByte: Byte;
                    End;

{05-SVGA}    PoleWordu=array[0..1000] of word; {na horni mezi nezalezi, stejne je to jenom sablona pro ukazatel}

             UkNaPoleWordu=^polewordu;           {pomocne typy}

             T_VESAInfo = record {navratovy buffer na informace o rozhrani VESA}
                            Signature:array[0..3] of char; {'VESA' nebo 'VBE2', kdyz je vsechno v poradku}
                            Version:word;  {cislo verze VESA rozhrani; v hornim bytu je ta cislice pred teckou,
                                           v dolnim ta za teckou}
                            OEMId:pointer; {ukazatel na jmeno karty (retezec zakonceny znakem #0)}
                            Flags:longint; {ruzne atributy}
                            ModeList:uknapolewordu; {ukazatel na seznam dostupnych rezimu (pole je ukonceno hodnotou $FFFF)}
                            VideoMemory:word; {velikost VRAM [64KB bloku], od VESA verze 1.1}
                            zbytek:array[1..492] of byte;
                          end;

             P_VESAinfo = ^T_VESAInfo;

{06-3DFX}

{07-Texts}   TMode = (VGA,SVGA,OpenGL);

             _FontArray=array[0..0]of byte;
             {Pomocna datova struktura pro ukladani rastrovych fontu. Delka pole je
             dynamicka podle vysky znaku. Sam o sobe je tento typ nepouzitelny -
             - potrebujeme znat vysku pisma, jinak se v nem nic nenajde.
             Technicke detaily: kazde pismeno je tvoreno nekolika byty, kazdy
             predstavuje jeden radek (kde je jednicka, tam se pixel vykresli, kde je
             nula, tam ne). Sirka znaku je pevna - 8 pixelu (tj. 8 bitu v 1 bytu),
             vyska libovolna. Znakova sada zabere v pameti 256 krat vyska pisma bytu
             (pro pismo 8x8 pixelu to tedy dela presne 2 KB).}
             _UkNaFont=^_fontarray;

             {uzivatelsky typ:}
             _Font = record
             fVyska:byte;{vyska pisma v radcich (bytech)}
             fStdX,fStdY,fStdRoztec:byte;{doporucene parametry ulozene v souboru s fontem}
             fData:_uknafont;
             end;

{08-Maps}

{09-Timer}

{10-SB16}

{11-Keyb.1}

{12-Keyb.2}

{13-Mouse}

{14-Math}

{15-IPX}     hiloword   = word;                   { Hi-Lo format }
             netaddr    = longint;                { Hi-Lo format }
             nodeaddr   = array[0..5]of byte;     { Hi-Lo format }
             socketnr   = hiloword;               { Hi-Lo format }

             procid     = record                            {  Adresa                  }
	 	            Net    : netaddr;               {          - s¡Ÿ           }
 		            Node   : nodeaddr;              {          - stanice       }
                 	    Socket : socketnr               {          - socket        }
                          end;

             header     = record                           { Hlavi‡ka paketu           }
                            CheckSum    : hiloword;        {   kontroln¡ sou‡et        }
                            IPXLen      : hiloword;        {   d‚lka paketu s hlavi‡kou}
                            TControl    : byte;            {   ©¡zen¡ transp. vrstvy   }
                            PType       : byte;            {   typ paketu,  0 nezn m˜  }
                            DestNet     : netaddr;         {   adres t    - s¡Ÿ        }
                            DestNode    : nodeaddr;        {              - stanice    }
                            DestSocket  : socketnr;        {              - socket     }
                            SourceNet   : netaddr;         {   odes¡latel - s¡Ÿ        }
                            SourceNode  : nodeaddr;        {              - stanice    }
                            SourceSocket: socketnr         {              - socket     }
                          end;

             packet     = record
                            Hdr    : header;
                            Data   : array[0..512] of byte
                          end;

             fragment   = record
                            Adr : ^packet;
                            Len : word
                          end;

             ecbrec   = record                               { ž¡d¡c¡ blok                }
                          Link       : pointer;              {   slu‘ebn¡                 }
                          ESRAddr    : pointer;              {   adresa FAR rutiny nebo 0 }
                          InUse      : byte;                 {   stav operace             }
                          Completion : byte;                 {   v˜sledek operace         }
                          Socket     : socketnr;             {   socket                   }
                          IPXArea    : netaddr;              {   slu‘ebn¡                 }
                          DriverArea : array[1..12]of byte;  {   slu‘ebn¡                 }
                          ImmAddr    : nodeaddr;             {   adresa routeru           }
                          FragCnt    : word;                 {   po‡et fragment–          }
                          Frag1      : fragment;             {   prvn¡ fragment           }
                          { ... }                            {   dal¨¡ fragmenty          }
                        end;
          		{ hlavi‡ka i datov  ‡ st paketu jsou v jednom fragmentu }

             packetData = array[0..512] of byte;

             {JIVA Struct.}
             Transmit = Record
                          Prvni: Byte;                 {potvrzeni prijmu}
                          SourceAddr: nodeaddr;        {odkud je poslany}
                          Proces: Byte;               {co delat s paketem}
                          Data: array[0..399] of Byte; {datova cast 400B}
                        End;

{16-Misc}    TRAW = Record                                      { Sound RAW }
                      Handle: Word;
                      Lenght: LongInt;

                      Load_Chunks: Word;
                      Load_Chunk: Word;
                      Load_Zbytek: Word;
                    End;


Const
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{01-Glob}

{02-RAM}

{03-DOS}     ReadOnly = $01;              {konstanty typu souboru, atributy}
             Hidden = $02;
             SysFile = $04;
             VolumeID = $08;
             Directory = $10;
             Archive = $20;
             AnyFile = $3F;

{04-VGA}     ColX: array[0..15] of Byte =         { 16 default use colors   }
             (240,241,242,243,244,245,246,247,    { ColX[15] = default font }
             248,249,250,251,252,253,254,255);

{05-SVGA}    _NeniVESA=0;                                    { chybove kody }
             _MaloPameti=1;
             _RezimNepujde=2;
             _NeselSpustit=3;

             _maxX=639; _maxY=479;

             _Textak=0; {rezim, ktery byl nastaven pred spustenim programu
                  (obvykle 16barevny textovy rezim 80x25),
                  tuto hodnotu zadejte pro ukonceni grafiky.}
             _640x350=$11C;
             _640x400=$100;
             _640x480=$101;
             _800x600=$103;
             _1024x768=$105;

             _frekvence:word=0;

{06-3DFX}

{07-Texts}   DefaultFont: array[0..124] of Byte =   { WriteText,WriteNumber }
             (119,157,239,253,241,255,227,24,198,16,
             132,72,31,250,17,247,175,242,6,49,
             140,97,8,196,145,143,157,239,193,209,
             251,163,8,197,222,119,159,249,67,121,
             140,99,24,19,144,173,99,234,249,196,
             148,35,56,194,113,9,35,248,197,208,
             124,124,72,198,49,143,192,64,6,49,
             138,162,47,144,2,140,98,69,16,31,
             249,34,170,168,136,249,0,135,17,81,39,
             192,64,65,196,247,143,247,125,206,155,
             2,20,194,1,140,107,71,59,238,240,
             156,252,146,1,8,98,72,133,223,255,
             131,231,33,206);

             znaky: array[0..204] of Byte = (          { OutText, OutNumber }
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

             SmallZnaky: array[0..131] of Byte = (     { OutText, OutNumber }
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

             Cifry: array[0..49] of Byte = (           { OutText, OutNumber }
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

             SmallCifry: array[0..39] of Byte = (      { OutText, OutNumber }
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

             _RidiciKody:byte=1;
             {Mozne hodnoty jsou:}
             _pouzivat=1; {kody pouzivat, ridit se podle nich}
             _vypisovat=2; {nepouzivat, zobrazit je jako prosty text}
             _preskakovat=3; {nepouzivat ani nevypisovat}

             {Nekdy je potreba dynamicky nastavovat pri zobrazovani textu jeho meritko.
             To se obvykle provede rucnim prepocitanim a prenastavenim velikosti a roztece.
             Ciselne hodnoty zadane ridicimi kody primo v textu ale nejsou zvenku
             pristupne, proto tu mame tuto promennou:}
             _MeritkoKodu:word=100;
             {Urcuje meritko cisel v procentech. Plati pro vsechny kody krome %%b a %%z.}

{08-Maps}

{09-Timer}

{10-SB16}

{11-Keyb.1}

{12-Keyb.2}

{13-Mouse}

{14-Math}

{15-IPX}     DATALNG=512;               { max. d‚lka datov‚ ‡ sti paketu - 1 }

             IPXINT       = $7A;

             STAYOPEN     = $FF;        { rezimy otevreni socketu }
             AUTOCLOSE    = $00;

             NOIPX        = $01;        { nen¡ IPX.COM, chyba inicializace }
             REQ_CANC     = $FC;        { ‘ dost o p©¡jem zru¨ena }
             BAD_PACKET   = $FD;        { chybn˜ paket }
             NOT_DELIV    = $FE;        { paket nelze doru‡it }
             ALROPEN      = $FF;        { socket je ji‘ otev©en }
             NOSOCK       = $FE;        { voln‚ sockety vy‡erp ny }

             BROADCAST    : nodeaddr = ($FF,$FF,$FF,$FF,$FF,$FF);
             THISNET      : netaddr  = 0;

             DATA_SOCKET = $3333;

             WAIT_FOR_PACKET_TIME = 50;    { 0.5 sekundy }
             SOCKET_ALREADY_OPEN  = $FF;   { Kod vysledku sluzby IPX Open Socket }

{16-Misc}

Var
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{01-Glob}

{02-RAM}     xmsAdr:longint;                                   {XMS handling}
             xmsVersion,ovlXmsVersion,hmaDetect: Word;
             xmsChyba: Byte;
             xmsSize: Word;

             RAW: array[0..9] of TRAW;                {10x 500KB RAW Sample}
             RAWBig: TRAW;

             Buffer: array[0..4] of Word;              {256KB} {mount point}
             BufferP: array[0..3] of Pointer;

             BufferMap: Word;                          {8KB}   {80x50 , sqr}
             BufferMapP: Pointer;                              {640x400 8x8}

             BufferRAW:Word;                           {8KB}   {sb16 domix}
             BufferRAWP:Pointer;

             BufferSND: Word;                          {10KB}  {pc-speaker}
             BufferSNDP: Pointer;

             BufferSPR: Word;                          {8KB}   {pc-speaker}
             BufferSPRP: Pointer;

             RLE: Word;                                {16KB}  {RLE unpacked}
             RLEKompressed: Word;
             RLEP: Pointer;                            {16KB}  {RLE packed}
             RLEKompressedP: Pointer;

             BufferC,BufferC1,BufferC2,BufferC3: Word; {2,5KB} {fonts}
             BufferCP,BufferC1P,BufferC2P,BufferC3P: Pointer;

{03-DOS}     DosError : integer;                           {chybovy kod DOSu}
             IntSaveXX : array[0..18] of pointer;
             PIntSave : pointer;                  {uschovane puvodni vektory}

{04-VGA}     Bmp: TBmp;                               { GIMP scan support   }

             SprDat: array[0..7999] of Byte;          { GRA format 8x8      }
             SprCol: array[0..499] of TSprCol;        { 4 colors per sqr.   }
             SprPal: array[0..15] of TRGBc;           { 16 colors per page  }

             PalBack: array[0..255] of TRGBc;         { Fade In/Out support }

{05-SVGA}    _VerzeVESA:word; {verze VESA BIOSu vasi graficke karty. Vyssi byte je ta
                  cislice pred teckou, nizsi ta za teckou
                  (napr. $0102 = verze 1.2)}

             _VGAkompatibilni:boolean; {jestli je graficka karta kompatibilni s VGA.
                  Pokud neni, nelze pouzivat standardni porty VGA, tj. cekani
                  na navrat paprsku nebo primou manipulaci s paletou!}

             _PujdeStrankovani:boolean; {jestli je pri aktualnim rozliseni dost
                  videopameti aspon na jednu virtualni obrazovku}

             Granularity:word;{Granularita znamena, o kolik KB dal zacina nasledujici
                      banka. Tohle uz je prepocitana hodnota, kterou kdyz
                      vynasobime cislo banky spocitane beznym zpusobem, vyjde
                      skutecne cislo banky, ktere muzeme poslat na grafarnu.}

             CurBank:word; {aktualni banka}

             _MinClipX,_MinClipY,_MaxClipX,_MaxClipY:integer; {orezavaci okno,
                                                              normalne je nastaveno na celou obrazovku}
             _PagingActive:boolean; {Indikator zapnuteho strankovani, nastavuje se
             automaticky (nemenit rucne). True znamena, ze co se nakresli na
             obrazovku, to bude videt az po zavolani procedury _FlipPage.
             Pri false je vsechno videt hned.}
             _PuvodniRezim:byte; {Sem se ulozi cislo rezimu, v jakem se obrazovka
             nachazela pred spustenim programu (obvykle 3). Pri
             ukonceni SVGA je puvodni rezim automaticky obnoven.}
             _Granularity:word;{Granularita znamena, o kolik KB dal zacina nasledujici
             banka. Tohle uz je prepocitana hodnota, kterou kdyz
             vynasobime cislo banky spocitane beznym zpusobem, vyjde
             skutecne cislo banky, ktere muzeme poslat na grafarnu.}
             _CteciSegment,_ZapisovaciSegment,{segmentove adresy oken, obvykle $A000}
             _CteciOkno,_ZapisovaciOkno:word;{cisla oken pro cteni a zapis
             (obvykle obe 0 (A), ale nektere karty pouzivaji na cteni B)}
             _CurBank:word; {aktualni banka}
             __SwitchBank:pointer; {adresa procedury pro prepinani bank pod VESA}
             __LHy:word; {automaticky se pricita k yove souradnici vseho, co se kresli
             (kvuli strankovani)}

{06-3DFX}

{07-Texts}   TexterColor: Byte;                                { font color }
             b: array[0..7] of Byte;                        { binary decode }

             __Font:_uknafont; {aktualni font...}
             __Vyska:Word;     {...a jeho vyska}
             __velikostX,__velikostY:Word; {Pokud z nejakeho duvodu zadate velikost nulovou, text se nevykresli}
             __roztec:word;

{08-Maps}

{09-Timer}   BIOSTimerHandler : Procedure;        { Paralel processing *1C* }
             clock_ticks, counter : longint;

             clock1:Word; wait_counter:Word;                   { delay *1C* }
                          wait_enable:Boolean;

             clock2:Word; timeStops_cnt:LongInt;              { stopky *1C* }
                          timeStops_enable:Boolean;

             clock3:Word; blinkCol: Byte;                       { fade *1C* }
                          blinking: Boolean;
                          blinkFreq: Word;
                          blinkFade: Byte;
                          n64: Byte;

             clock4:Word; flipflop1sec:Boolean;                 { 1 Hz *1C* }

             clock5:Word; InitLoading:Boolean;               { Loading *1C* }
                          LoadingPhase:Byte;
                          InitLimit:Word;

             clock6:Word; Generator:Boolean;               { Generator *1C* }
                          GenFreq:Word;
                          GenPhase:Byte;
                          GenSmer:Byte;

             clock7:Word; sndpl_counter:Word;            { Speaker SND *1C* }
                          sndpl_stopcount:Word;
                          sndpl_enable:Boolean;

             Tmp: array[0..255,1..3] of Byte;                { paleta R G B }

             SND_I: Byte;                           { PC-Speaker SND format }
             SND_Lenght: array[0..49] of Byte;      { 50 SND Speaker sounds }
             RAW_play: Boolean;                     { PC-Speaker RAW format }
             RAW_lenght: Word;                      { 8000Hz mono file 8bit }
             RAW_pos: Word;
             RAW_repeat: Boolean;

{10-SB16}    ZvukKarta: Boolean;

{11-Keyb.1}  BIOSKeyboardHandler : Procedure;      { Keyboard interrupt *9* }

             Key: array [1..128] of Byte;          { Keboard events 0/1 *9* }
             KeyCode: Byte;                        { Keyboard status    *9* }

{12-Keyb.2}

{13-Mouse}

{14-Math}

{15-IPX}     Request, Reply: procid;
             IPXresult                     : byte;
             iSocket,oSocket               : socketnr;
             recNode,fromNode,sendNode     : nodeaddr;
             net                           : netaddr;       { adresa site }
             IPXdata                       : packetData;

{16-Misc}    RLEDelka: Word;                      { Pack/Unpack GRA SND MAP }


Implementation
{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.

Scan           Scan            Scan
Code Key       Code Key        Code Key
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
30   A         11   0           1   ESC
48   B          2   1          28   ENTER
46   C          3   2          15   TAB
32   D          4   3
18   E          5   4          72   UP
33   F          6   5          80   DOWN
34   G          7   6          75   LEFT
35   H          8   7          77   RIGHT
23   I          9   8
36   J         10   9          82   INSERT
37   K                         83   DELETE
38   L       Scan              71   HOME
50   M       Code Key          79   END
49   N      ÄÄÄÄÄÄÄÄÄÄÄ        73   PGUP
24   O       59   F1           81   PGDN
25   P       60   F2
16   Q       61   F3           57   SPACEBAR
19   R       62   F4           14   BACKSPACE
31   S       63   F5
20   T       64   F6
22   U       65   F7
47   V       66   F8
17   W       67   F9
45   X       68   F10
21   Y       87   F11
44   Z       88   F12
