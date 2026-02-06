(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: ZVUKY.PAS                                                      *)
(*  Obsah: jednotka pro prehravani zvuku na kartach typu Sound Blaster     *)
(*  Zalozeno na jednotce SMIX / Ethan Brodsky (1995)                       *)
(*  Preklad, komentare a par vylepseni: Mircosoft (http://mircosoft.mzf.cz)*)
(*  Posledni uprava: 22.2.2012                                             *)
(*  Pro kompilaci: DOS.TPU, CAS.TPU, RETEZCE.TPU, XMS.TPU                  *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Zvuky;
{$G+,R-,I-}

{...$define debug} {nechava vypisovat informace o zvukove karte a o nacitanych WAVech}

interface

(********************* zapnuti, vypnuti a nastaveni: ************************)

procedure NactiBlaster(var adresa:word; var IRQ,DMA,DMA16:byte);
{Nacte systemovou promennou BLASTER a v parametrech vrati nalezene hodnoty.
Kdyz je kterakoli z nich rovna 255 ($FF), znamena to, ze nebyla nalezena.
Pozn.: I kdyz promenna BLASTER neexistuje, zvukovka teoreticky muze normalne
fungovat. V takovem pripade je nejlepsi zeptat se uzivatele.}

function InitZvuky(Adresa:word; IRQ,DMA,DMA16:byte; PovolitAutoinit:boolean):boolean;
{Funkce inicializuje zvukovou kartu a pripravi vsechno na to, abyste mohli
zacit prehravat zvuky. Pokud se ji to povede, vraci true.
Parametry (muzete dosadit cisla, ktere vyplivla procedura Nactiblaster, ale
napred zkontrolujte, jestli jsou platne):
Adresa: zakladni port zvukovky. Mozne hodnoty $210..$280 po $10, obvykle $220.
IRQ: cislo pozadavku preruseni. Obvykle 5 nebo 7, nekdy i 2, 3 nebo 10.
DMA: cislo kanalu 8bitoveho primeho pristupu do pameti. Mozne hodnoty 0..3,
     prakticky vzdy 1. Pokud existuje DMA16, je tento parametr zbytecny.
DMA16: cislo 16bitoveho kanalu DMA. Mozne hodnoty 5..7, 0 nebo 255 se bere
       jako "neexistuje".
PovolitAutoinit: tim urcite, jestli se ma pouzivat automaticky spousteny DMA
     prenos. Pokud ho vase karta neumi, nema tenhle parametr zadny vliv.
     Na nekterych kartach je ve zvuku slyset lupani a bruceni s vypnutym
     autoinitem, na nekterych se zapnutym, tak si vyberte variantu, ktera
     u vas zni lip (jako defaultni hodnotu doporucuji spis true).
POZOR: prvni ctyri parametry neprochazeji zadnou autodetekci - pouziji se tak,
       jak jsou zadany.}
procedure ZrusZvuky;
{Vypne zvukovku a uklidi pamet. Jestli ji na konci programu zapomenete
zavolat, zavola se sama pres Exitproc.}

procedure NastavFrekvenciZvuku(frekvence:word);
{Nastavi vzorkovaci frekvenci prehravaneho zvuku v Hz (vzorku za sekundu).
Lze volat naprosto kdykoli.
Karta si zadanou hodnotu automaticky zaokrouhli podle svych moznosti, takze si
s presnymi hodnotami nemusite lamat hlavu.
Nejnizsi mozna frekvence je cca 5000 Hz. Spolehlive maximum, ktere rozchodite
zarucene na vsem, je 22050 Hz. Maximum pro novejsi karty (SB16) je 48000 Hz.
Vychozi frekvence je:} const VychoziVzorkovaciFrekvence=22050;
function AktualniFrekvenceZvuku:word;
{Vraci aktualne nastavenou vzorkovaci frekvenci.}


(******************* zakladni funkce pro prehravani zvuku: ******************)

{Jednotka si zvuky interne uklada jako 8bitove monofonni se znamenkem
(shortint), ulozeny jsou vzdy v rozsirene pameti (XMS). V konvencni pameti
jsou jenom pomocne zasobniky.
Da se prehravat az 8 zvuku soucasne (to urcuje konstanta PocetKanalu, kterou
si muzete v pripade potreby upravit).}

procedure zapnizvuk(Handle:word; Ofset,Velikost:longint;
                    Index:byte; Opakovat:boolean; Hlasitost:byte);
{Na prvnim volnem kanalu zacne prehravat dany zvuk. Kdyby se zadny volny
kanal nenasel, nedela nic.
Parametry:
Handle - cislo bloku XMS, kde je zvuk ulozen
Ofset - kde v tom bloku zvuk zacina (pocitano v bytech, od nuly)
Velikost - jak je ten zvuk dlouhy (v bytech)
Index - jakekoli cislo, ktere si vymyslite, krome 255. Pomoci nej pak zvuk
        vypinate nebo kontrolujete. Muze hrat i vic zvuku se stejnym indexem.
Opakovat - pri false se zvuk prehraje jednou a skonci. Pri true bude hrat
           porad dokolecka, dokud ho nevypnete.
Hlasitost - urcuje hlasitost prehravani zvuku, mozne hodnoty 0 (ticho) az 128
            (dvojnasobna hlasitost), normalni je 64.}
procedure NastavHlasitost(Index,NovaHlasitost:byte);
{Nastavi hlasitost prave prehravanych zvuku s danym Indexem
(nebo vsech, pokud zadate index 255).}
procedure VypniZvuk(Index:byte);
{Vypne vsechny zvuky s danym Indexem (index 255 vypne uplne vsechny).}
function HrajeZvuk(Index:byte):boolean;
{Zjisti, jestli zrovna hraje alespon jeden zvuk s danym Indexem (pri indexu
255 rika, jestli hraje aspon neco).}


(******************* funkce pro praci se soubory *.WAV: *********************)

{Jestli vas zajimaji podrobnosti o tomto zvukovem formatu, najdete je
v implementacni casti, skoro uplne na konci tehle jednotky
(hledejte heslo "WAV").}

function NactiWAV(HandleBloku:word; Ofset:longint; var Velikost:longint; JmenoSouboru:string):longint;
{Funkce pro cteni souboru *.WAV. Zvlada 8- i 16bitove soubory, mono i stereo,
s jakoukoli frekvenci. Pri nacitani zvuk automaticky prevede na 8bitovy mono,
protoze nic jineho tahle jednotka prehrat neumi. Zvukova data ulozi do bloku
XMS s danym Handlem, pocinaje od daneho Ofsetu (ten blok pameti samozrejme
musite mit predem alokovany) a pres parametr Velikost preda delku nacteneho
zvuku (v bytech). Pozor, ze jestli bude delka zvuku licha, zkopiruje se do XMS
o 1 B vic. Pri uspechu vrati vzorkovaci frekvenci nacteneho zvuku, pri
neuspechu (neexistujici soubor, soubor neni WAV, neznamy typ komprese atd.)
vraci nulu.}
function VelikostWAVu(JmenoSouboru:string):longint;
{Vraci delku zvukovych dat v danem souboru v B (po pripadnem prevodu na 8b
mono), cili kolik pameti pro tento zvuk budete potrebovat.
Pri neuspechu vraci 0.}
function FrekvenceWAVu(JmenoSouboru:string):longint;
{Vraci vzorkovaci frekvenci zvuku v danem souboru (nebo 0 pri neuspechu).}


(****************************************************************************)

implementation

uses cas,{jen pro kratke cekani pri resetu DSP, jinak neni potreba}
     dos,{pro praci s prerusenimi - nutna}
     retezce,{jenom pro prevod obsahu promenne BLASTER na velka pismena}
     xms;{pro uchovavani zvuku v rozsirene pameti - nutna}

const DelkaBloku=512; {Delka bloku 8bitovych zdrojovych zvukovych dat v B, se
                       kterymi pracujeme (cili pocet vzorku v jednom bloku).
                       Pri vzorkovaci frekvenci 22 kHz je to na nejakych
                       23 ms hrani.}
      PulDelkyBloku=delkabloku div 2; {pro zkraceni zapisu}
      PocetKanalu=8; {kolik zvuku muze hrat soucasne}

var ResetPort, {pres tenhle port se resetuje DSP}
    ReadPort,  {odtud cteme data z DSP}
    WritePort, {tudy posilame data na DSP}
    PollPort,  {pres tenhle port zjistujeme, jestli jsou na DSP pripravena data ke cteni}
    AckPort,   {prectenim tohoto portu potvrzujeme, ze je obsluha preruseni hotova}
    PICMaskPort, {port, pres ktery se povoluje nebo zakazuje IRQ}
    DMAMaskPort, {port, pres ktery se zapina nebo vypina DMA prenos}
    DMAClrPtrPort,
    DMAModePort, {sem se posila hodnota DMAMode}
    DMABaseAddrPort, {tudy se posila adresa, odkud ma DMA prenos tahat data}
    DMACountPort,    {tudy se posila, jak dlouha maji odesilana data byt}
    DMAPagePort:word;

    IRQStartMask, {kdyz se timhle vyoruje PICMaskPort, IRQ se zakaze}
    IRQStopMask,  {kdyz se timhle vyanduje PICMaskPort, IRQ se povoli}
    IRQIntVector, {cislo (vektor) preruseni}
    DMAStartMask, {kdyz se tohle posle na DMAMaskPort, DMA se spusti}
    DMAStopMask,  {kdyz se tohle posle na DMAMaskPort, DMA se vypne}
    DMAMode:byte; {urcuje rezim DMA prenosu: 8/16b, s autoinitem nebo bez}
    DMALength:word; {po jak dlouhych usecich bude DMA data posilat na kartu}

    PuvodniPreruseni, {pro ulozeni adresy puvodni obsluhy preruseni}
    PuvodniExitProc:pointer; {pro ulozeni adresy puvodni ukoncovaci procedury}
    PreruseniNainstalovano:boolean; {jestli mame nainstalovanou novou obsluhu preruseni}
    VzorkovaciFrekvence:word; {s jakou frekvenci karta zrovna hraje (vzorku/s)}

    AutoInit:boolean; {jestli se DMA prenosy inicializuji automaticky}
    SestnactBitu:boolean; {jestli karta hraje 16bitove}
    DACZapnuty:boolean; {jestli je zapnuty D/A prevodnik}

type JedenKanal = record {informace o tom, co hraje v jednom kanale}
   { 0}           _Handle:word; {cislo XMS bloku, ve kterem je zvuk ulozen}
   { 2}           _Ofset:longint; {adresa zacatku zvuku v tom bloku (pocitano od 0)}
   { 6}           _Velikost:longint; {velikost zvuku v B}
   {10}           _Index:byte; {identifikacni cislo, ktere kanalu pridelil uzivatel pri spusteni}
   {11}           _KdeJsme:longint; {aktualni pozice v prehravanem zvuku}
   {15}           _Opakovat:boolean; {jestli ma ten zvuk hrat porad dokolecka (true)
                                      nebo jestli ma po prvnim prehrani skoncit (false)}
   {16}           _Hlasitost:byte; {mozne hodnoty 0..128, normalni je 64}
   {17}           _Hraje:boolean; {jestli zrovna hraje (vicemene pomocna hodnota, aby se nemusela pokazde kontrolovat pozice)}
   {^ofsety}      end; {POZOR, v tomhle se nestourejte! Obsluha preruseni ke
                        kanalum pristupuje pres natvrdo nakodovane ofsety a
 delka: 18 B            delky, takze jestli se v tomhle typu cokoli zmeni,
                        prestane to cele fungovat!}

{      ofsety                        velikosti
           0      _handle:word;         2
           2      _ofset:longint;       4
           6      _velikost:longint;    4
          10      _index:byte;          1
          11      _KdeJsme:longint;     4
          15      _opakovat:boolean;    1
          16      _hlasitost:byte;      1
          17      _hraje:boolean;       1     celkem 18 B}


     tVystupniPole8b = array[0..1,0..delkabloku-1] of byte;
     tVystupniPole16b = array[0..1,0..delkabloku-1] of integer;
     {zasobniky, odkud se zvuk pres DMA prenasi do reproduktoru}

var Kanaly:array[0..pocetkanalu-1] of jedenkanal;
    Mezipamet:array[0..delkabloku] of shortint;
     {Sem se zvuk kopiruje ze XMS, odtud pak dale pokracuje do Michacky.
     Je schvalne o 1 B delsi nez DelkaBloku, protoze ze XMS se da kopirovat
     jenom po sudych delkach a zaokrouhluje se to nahoru.}
    Michacka:array[0..delkabloku-1] of integer;
     {Tady se zvuky michaji (tj. scitaji se jejich jednotlive vzorky).
     Zvuk je 8bitovy se znamenkem, integery tu jsou jenom kvuli moznemu
     preteceni shortintu (orezava se az vysledny namixovany zvuk).}
    OrezavaciPole:array[-128*pocetkanalu..128*pocetkanalu] of byte;
     {Tabulka pro orezavani v 8bitovem rezimu. Orezavani funguje tak, ze se
     vezme 16bitova hodnota vzorku z Michacky, pouzije se jako index pro toto
     pole a nalezena 8bitova hodnota se odesle do vystupniho pole.
     Pred mixovanim jsou zvuky 8bitove s rozsahem -128..127. Orezavaci pole
     musi byt tak velke, aby rozsah indexu pokryl cely mozny rozsah hodnot
     namixovaneho zvuku, tj. i kdyby hraly vsechny kanaly soucasne a zrovna ze
     vsech najednou prisel vzorek s nejvetsi (nebo nejmensi) moznou hodnotou.
     "Oriznutim" pres tohle pole se zvuk zaroven upravi na rozsah 0..255 bez
     znamenka, jak ho vyzaduje zvukova karta.}
    AdresaVystupu:pointer; {ukazatel pro alokaci pameti pro vystupni pole}
    VystupniPole8b:^tVystupniPole8b; {vystupni pole pro 8bitovy rezim}
    VystupniPole16b:^tVystupniPole16b; {vystupni pole pro 16bitovy rezim}
    AdresaBloku:array[0..1] of pointer; {mame dva vystupni bloky, tohle jsou jejich adresy}
    VybranyBlok:word; {a timhle indexem se mezi nimi prepina}

    AdresaMezipameti:pointer; {pomocna konstanta}
    adresamezipametiw:word absolute adresamezipameti; {kvuli Asm, aby fungoval 32bitovy pristup}

    {pro rezim DMA s autoinitem:}
    AdresaBufferu:longint;
    StrankaBufferu:byte;
    OfsetBufferu:word;
    {pro rezim bez autoinitu:}
    StrankaBloku:array[0..1] of byte;
    OfsetBloku:array[0..1] of word;

    {nizkourovnova obsluha rozsirene pameti (zkopirovano z jednotky XMS):}
    Deskriptor:array[0..15] of byte; {stejne se do nej leze pres ofsety, tak neni potreba definovat ho jako record}
    OvladacXMS:pointer; {ukazatel na ovladaci rutinu XMS}

procedure NactiBlaster(var adresa:word; var IRQ,DMA,DMA16:byte);
var blaster:string;
{}function VytahniParametr(odkud:string; jaky:char; hex:boolean):word;
{}var hodnota:word;
{}    pom:integer;
{}Begin
{}vytahniparametr:=$FF; {jestli ho nenajdeme, tohle tu zustane}
{}if pos(jaky,odkud)<>0 then begin {OK, nasli jsme ho}
{}                           delete(odkud,1,pos(jaky,odkud)); {smaz vsechno pred nim}
{}                           delete(odkud,pos(' ',odkud),255); {smaz vsechno za nim}
{}                                               {(pokud tam mezera neni, Pos vyjde 0 a nesmaze se nic)}
{}                           if hex then odkud:='$'+odkud; {velmi jednoduchy prevod soustav :-)}
{}                           val(odkud,hodnota,pom); {prevod na cislo}
{}                           if pom=0 then vytahniparametr:=hodnota; {prevod se povedl}
{}                           end;
{}End;{vytahniparametr}
Begin
adresa:=$FF; irq:=$FF; dma:=$FF; dma16:=$FF;
blaster:=stringup(GetEnv('BLASTER'));
{$ifdef debug}
writeln('Blaster: ',blaster);
{$endif}
if blaster<>'' then begin
                    adresa:=vytahniparametr(blaster,'A',true);
                    IRQ:=vytahniparametr(blaster,'I',false);
                    DMA:=vytahniparametr(blaster,'D',false);
                    DMA16:=vytahniparametr(blaster,'H',false);
                    end;
End;{nactiblaster}

procedure WriteDSP(hodnota:byte); assembler;
Asm
mov DX,WritePort
 @cekani:         {pockame, az je DSP pripraveny...}
 in AL,DX                  {repeat until (port[WritePort] and $80)=0;}
 test AL,$80
 jnz @cekani
mov AL,hodnota    {...a posleme tam hodnotu}
out DX,AL                  {port[WritePort]:=hodnota;}
End;{writedsp}

function ReadDSP:byte; assembler;
Asm
mov DX,PollPort
 @cekani:        {pockame, az je DSP pripraveny...}
 in AL,DX                   {repeat until (port[PollPort] and $80)<>0;}
 test AL,$80
 jz @cekani
mov DX,ReadPort  {...a precteme z nej hodnotu}
in AL,DX                    {readdsp:=port[ReadPort];}
End;{readdsp}

function ResetDSP:boolean;
var i:byte;
Begin
startcekani;
Port[ResetPort]:=1; {posleme na port jednicku,...}
pockej(4);          {...chvili pockame...}
Port[ResetPort]:=0; {...a pak tam posleme nulu. Tim je reset dokoncen.}
i:=100;
while (ReadDSP<>$AA)and(i<>0) do dec(i); {overime, jestli se to povedlo}
ResetDSP:=i<>0; {pokud se tam spravna hodnota objevila driv nez nam doslo tech 100 pokusu, je to OK}
End;{resetdsp}

function SpocitejLinearniAdresu(ukazatel:pointer):longint;
Begin
spocitejlinearniadresu:=seg(ukazatel^)*longint(16)+ofs(ukazatel^);{adresa=16*segment+ofset}
End;{spocitejlinearniadresu}

function NormalizujUkazatel(ukazatel:pointer):pointer;
{prepocita dany ukazatel tak, aby mel co nejmensi ofset, ale ukazoval porad na stejne misto}
var adresa:longint;
Begin
adresa:=spocitejlinearniadresu(ukazatel);
normalizujukazatel:=ptr(adresa div 16,adresa mod 16);
{tj.: novy_segment = stary_segment + stary_ofset div 16
      novy_ofset = stary_ofset mod 16
Linearni adresa ukazatele se nezmeni.}
End;{normalizujukazatel}

procedure InicializujFrekvenci(frekvence:word);
Begin
if sestnactbitu then begin {tady se nastavuje primo frekvence}
                     WriteDSP($41);
                     WriteDSP(Hi(frekvence));
                     WriteDSP(Lo(frekvence));
                     end
                else begin {tady se to dela pres casovou konstantu}
                     WriteDSP($40);
                     WriteDSP(256-(1000000 div frekvence));
                     end;
End;{inicializujfrekvenci}

procedure ObsluhaPreruseni; interrupt; assembler;
var zbyva:word; {kolik vzorku zbyva zkopirovat ze XMS do Mezipameti}
    CilovaPozice:longint; {kam to v Mezipameti davame}
    cilovapozicew:word absolute cilovapozice; {oklika kvuli 16b prekladaci}
    delka:word; {kolik vzorku se ma primixovat do Michacky}
    IndexKanalu:word; {pro cykleni pres vsechny kanaly}
    ZbyvajiciDelkaZvuku:longint; {delka od kanal._kdejsme do konce zvuku}
    ZDZW:word absolute zbyvajicidelkazvuku;
Asm
{Direktiva interrupt se dokaze postarat jenom o 16bitove registry, jenze
pri praci se zvuky nutne potrebujeme 32bitova cisla. Prekladac pro longinty
pouziva bud 32bitove registry nebo alternativni 16bitove postupy (vybira
se to promennou Test8086). To je zaprve spousta zbytecneho kodu a zadruhe si
nejsem jisty, ktere vsechny registry pouziva, tak jsem celou tuhle proceduru
pro jistotu prepsal do Assembleru. Uzijte si to :-).}
db $66; push AX
db $66; push CX       {zaloha 32b registru (EBX se menit nebude)}
db $66; push DX
cld   {smer retezcovych instrukci: dopredu (velice dulezite!)}
{Jestli neni aktivni autoinit, musime ze vseho nejdriv zapnout DMA prenos
aktualniho bloku na reproduktor, aby ve zvuku nebyly moc velke diry:}
mov AL,autoinit
or AL,AL           {true?}
jnz @NeniCoResit   {jo, uz se to zapnulo samo}
 mov DX,DMAMaskPort;     mov AL,DMAStopMask;  out DX,AL
 mov DX,DMAClrPtrPort;   xor AL,AL;           out DX,AL
 mov DX,DMAModePort;     mov AL,DMAMode;      out DX,AL
 mov DX,DMABaseAddrPort; lea SI,ofsetbloku
                         add SI,vybranyblok
                         add SI,vybranyblok {jeste jednou, protoze 1 word = 2 B}
                         mov AX,[SI];         out DX,AL
                                              shr AX,8
                                              out DX,AL
 mov DX,DMACountPort;    mov AX,DMALength
                         dec AX;              out DX,AL
                                              shr AX,8
                                              out DX,AL
 mov DX,DMAPagePort;     lea SI,strankabloku
                         add SI,vybranyblok
                         mov AL,[SI];         out DX,AL
 mov DX,DMAMaskPort;     mov AL,DMAStartMask; out DX,AL

 mov DX,WritePort
 call @CekejNaWrite
 mov AL,$14
 out DX,AL              {WriteDSP($14);}

 mov CX,delkabloku
 dec CX
 call @CekejNaWrite
 mov AL,CL
 out DX,AL              {WriteDSP(Lo(delkabloku-1));}
 call @CekejNaWrite
 mov AL,CH
 out DX,AL              {WriteDSP(Hi(delkabloku-1));}

 jmp @NeniCoResit
 {}@CekejNaWrite: {podprocedurka pro cekani na zapis do DSP          }
 {} in AL,DX      {(zkopirovano z Writedsp, aby se nemuselo callovat)}
 {} test AL,$80
 {} jnz @CekejNaWrite
 {}ret
@NeniCoResit:

{Aktualni blok uz se prehrava. Prepneme se na druhy blok, do ktereho budeme
kopirovat nova zvukova data:}
lea SI,adresabloku
xor vybranyblok,1 {timhle se zmeni 0 na 1 nebo 1 na 0}
jz @BlokNula
 add SI,4
@BlokNula:
les DI,[SI]   {ES:DI = adresabloku[vybranyblok]}

{Do druheho bloku zkopirujeme odminula pripraveny zvuk z michacky:}
mov AL,sestnactbitu
or AL,AL
jz @OsmBitu
 {16 b:}
 lea SI,michacka
 mov CX,delkabloku
  @cyklus16b:
  lodsw    {precteni vzorku z michacky}
  sal AX,5 {roztahnuti vzorku do 16bitoveho rozsahu (jinak by to hralo moc potichu)}
  stosw    {zapis vzorku do vystupniho bloku}
  loop @cyklus16b
  jmp @zkopirovano1
@OsmBitu:
 {tady data cedime pres orezavaci tabulku, takze to bude trosku slozitejsi:}
 push BP
 mov DX,SS {SS musime schovat do nejakeho registru, protoze zasobnik si na chvili znepristupnime}
 mov AX,DS
 lea SI,OrezavaciPole
 mov SS,AX                     {DS:SI = adresa prostredku orezavaci tabulky}
 add SI,128*pocetkanalu        {SS:BP = adresa 16bitove michacky (vstup)}
 lea BP,michacka               {ES:DI = adresa 8bitoveho vystupniho bloku}
 mov CX,delkabloku
  @cyklus8b:
  mov BX,[SS:BP]    {nacteme vzorek ze vstupu (se znamenkem)}
  add BP,2          {ve vstupu se posuneme dal}
  mov AL,[DS:SI+BX] {v tabulce najdeme prislusnou orizlou hodnotu bez znamenka}
  stosb             {ulozime vysledek do vystupniho bloku}
  loop @cyklus8b
 mov SS,DX        {znovu zprovoznime zasobnik}
 pop BP
@zkopirovano1:
{Druhy vystupni blok je pripraveny.}

{Vypneme kanaly, ktere uz dojely na konec:}
mov CX,pocetkanalu
lea SI,kanaly       {DS:SI -> prvni kanal}
 @PresVsechnyKanaly1:
 mov AL,[SI+17]     {kanal._hraje}
 or AL,AL           {true?}
 jz @KanalVyrizen1  {jestli ne, neni co resit}
  db $66; mov AX,[SI+11]    {kanal._kdejsme}
  db $66; cmp AX,[SI+6]     {_kdejsme<_velikost?}
  jl @KanalVyrizen1         {jo, jeste hraje}
   mov byte ptr [SI+17],false {uz dohral, vypneme ho}
 @KanalVyrizen1:
 add SI,18          {na dalsi kanal (18 je sizeof(jedenkanal))}
 loop @PresVsechnyKanaly1

{Vyplnime michacku tichem:}
mov AX,DS
lea DI,michacka
mov ES,AX
mov CX,puldelkybloku {delka michacky ve dwordech (512 integeru = 256 dwordu)}
db $66; xor AX,AX    {ticho}
db $66; rep stosw    {rep stosd}

{Projdeme vsechny kanaly, vykopirujeme je ze XMS a primichame do michacky:}
mov BX,pocetkanalu  {index kanalu}
 @PresVsechnyKanaly2:
 dec BX
 mov indexkanalu,BX {zaloha}

 lea SI,kanaly
 mov AX,18        {sizeof(jedenkanal)}
 mul BL           {* cislo kanalu}
 add SI,AX        {DS:SI -> kanal}

 mov AL,[SI+17]   {kanal._hraje}
 or AL,AL         {true?}
 jz @nehraje      {jestli ne, tak nic}

 db $66; mov AX,[SI+6]     {kanal._velikost...}
 db $66; sub AX,[SI+11]    {...-kanal._kdejsme = zbyvajici delka zvuku}
 db $66; xor CX,CX   {budeme potrebovat nulovy horni word}
 db $66; mov zdzw,AX
 mov DL,[SI+15]           {kanal._opakovat}
 or DL,DL                 {true?}
 jnz @CelyBlok            {jo}
 db $66; cmp AX,delkabloku; dw 0 {zbyvajicidelkazvuku>delkabloku?
             (ta nula je horni word te delky - delkabloku se prelozi jako 16b)}
 jg @CelyBlok               {jo}
  {ne:}
  mov CX,AX        {zbyvajici delka zvuku (<= delka bloku, takze staci 16b)}
  jmp @MameDelku
 @CelyBlok:
  mov CX,delkabloku
 @MameDelku:
 mov delka,CX  {tolik toho potrebujeme natahnout ze XMS a zamixovat}

 {stav registru v tomhle miste:
 AX = zbyvajici delka zvuku
 BX = index kanalu, ale zalohovany, takze se muze prepsat
 CX = kolik toho jeste zbyva ke zkopirovani
 DX je volny
 DS:SI -> kanal
 SS:BP -> lokalni promenne
 ES:DI volne}

 {Vykopirovani zvuku ze XMS:}
 mov zbyva,CX
 db $66; xor DX,DX
 db $66; mov cilovapozicew,DX {pozice v mezipameti, od ktere budeme zapisovat}
  @kopirovani:      {cyklus while zbyva<>0}
  or CX,CX
  jz @zkopirovano2
  db $66; cmp CX,AX {zbyva>zbyvajicidelkazvuku?}
  jg @JenomZbytek   {jo}
   {ne, zkopirujeme to cele najednou a koncime.
   Hodnoty pro deskriptor:}
   mov BX,[SI]               {kanal._handle}
   db $66; mov AX,[SI+2]     {kanal._ofset}
   db $66; add AX,[SI+11]    {+kanal._kdejsme}
   {delka = Zbyva, ta je ted v CX}
   inc CX         {\ zaokrouhleni delky nahoru na sude cislo}
   and CX,$FFFE   {/                                        }
   push SI        {zaloha adresy kanalu, protoze sem musi prijit deskriptor}
   {Vyplneni deskriptoru:}
   lea SI,deskriptor
   mov [SI],CX   {velikost = Zbyva (16 b staci, horni word uz je prednulovany)}
   mov [SI+4],BX {handle zdroje}
   db $66; mov [SI+6],AX  {ofset ve zdroji}
   {handle cile uz je predvyplneny (vzdy 0, neboli zakladni pamet)}
   db $66; mov CX,adresamezipametiw
   db $66; add CX,cilovapozicew  {@(mezipamet[cilovapozice])}
   db $66; mov [SI+12],CX        {pri kopirovani do zakladni pameti je misto ofsetu v cili ukazatel}
   {volani XMS:}
   mov AH,$0B       {sluzba "kopirovani dat"}
   call ovladacXMS  {do toho!}
   pop SI           {obnoveni adresy aktualniho kanalu}
   {prepocitani pozic pro priste:}
   db $66; xor AX,AX {potrebuju cisty horni word}
   mov AX,zbyva
   db $66; add AX,[SI+11]  {inc(kanal._kdejsme,zbyva)}
   db $66; mov [SI+11],AX  {podle tohohle se zjistuje, jestli uz kanal dohral}
   jmp @zkopirovano2 {a to je vsechno}
  @JenomZbytek:
  {Zvuk skonci driv nez blok - zkopirujeme co jde, vratime se na zacatek
  zvuku a dokoncime to v dalsich iteracich.
  Hodnoty pro deskriptor:}
  mov BX,[SI]               {kanal._handle}
  db $66; mov CX,[SI+2]     {kanal._ofset...}
  db $66; add CX,[SI+11]    {...+kanal._kdejsme}
  inc AX         {\ zaokrouhleni delky nahoru na sude cislo}
  and AX,$FFFE   {/                                        }
  push SI        {zaloha}
  {vyplneni deskriptoru:}
  lea SI,deskriptor
  mov [SI],AX    {velikost = zbyvajici delka zvuku (16 b staci)}
  mov [SI+4],BX  {handle zdroje}
  db $66; mov [SI+6],CX  {ofset ve zdroji}
  {handle cile uz je predvyplneny (vzdy 0)}
  db $66; mov CX,adresamezipametiw
  db $66; add CX,cilovapozicew  {@(mezipamet[cilovapozice])}
  db $66; mov [SI+12],CX        {ofset v cili = adresa}
  {volani XMS:}
  mov AH,$0B
  call ovladacXMS
  pop SI
  {prepocitani pozic:}
  mov CX,zbyva
  mov BX,zdzw   {16b staci}
  sub CX,BX                {odecteme, kolik jsme ted zkopirovali}
  mov zbyva,CX  {pozor, musi to zustat v CX}
  add cilovapozicew,BX     {posuneme se o zkopirovanou delku dal}
  db $66; xor DX,DX
  db $66; mov AX,[SI+6]    {kanal._velikost  (pozor, musi to byt v AX)}
  db $66; mov [SI+11],DX   {kanal._kdejsme:=0}
  db $66; mov zdzw,AX
  jmp @kopirovani          {a tocime dal, mozna to jeste neni vsechno}
 @zkopirovano2:

 {stav registru v tomhle miste:
 DS:SI -> kanal
 SS:BP -> lokalni promenne
 Zbytek je volny}

 {Primixujeme zvuk do Michacky:}
 mov DL,[SI+16]  {kanal._hlasitost}
 or DL,DL
 jz @nehraje      {nuly nema cenu pricitat, muzeme rovnou skoncit}
  lea SI,mezipamet  {DS:SI -> mezipamet (zdroj)}
  mov AX,DS
  lea DI,michacka
  mov ES,AX         {ES:DI -> michacka (cil)}
  mov CX,delka      {kolik vzorku budeme mixovat}
   @cyklus:
   lodsb          {AL:=vzorek}
   imul DL        {AX:=(vzorek*hlasitost)...}
   sar AX,6       {...idiv 64}
   add [ES:DI],AX {pricteni vzorku k obsahu michacky}
   add DI,2       {v michacce o pozici dal}
   loop @cyklus
 @nehraje:
 mov BX,indexkanalu
 or BX,BX                   {byl tohle posledni kanal?}
 jnz @PresVsechnyKanaly2    {jestli ne, tocime dal}

{rekneme radici, ze preruseni bylo obslouzeno:}
mov DX,ackport
in AL,DX
mov AL,$A0
out $20,AL
mov AL,$20
out $20,AL
{obnovime ulozene 32bitove registry:}
db $66; pop DX
db $66; pop CX
db $66; pop AX
End;{obsluhapreruseni}

(* puvodni verze posledniho useku obsluhy:
...
for temp:=0 to pocetkanalu-1 do if hrajekanal[temp]
  then begin {primichani kanalu}
       {kolik toho celkem musime ze XMS nakopirovat:}
       with kanaly[temp] do
        begin
        zbyvajicidelkazvuku:=obsah^.velikost-kdejsme;
        if opakovat or (zbyvajicidelkazvuku>delkabloku) then delka:=delkabloku
                                                        else delka:=zbyvajicidelkazvuku;
        end;
       zbyva:=delka;
       {kopirovani:}
       cilovapozice:=0;
       while zbyva<>0 do
        if zbyva<=zbyvajicidelkazvuku
          then begin {zkopirujeme to cele najednou a koncime}
               zexms(mezipamet[cilovapozice],
                     kanaly[temp].obsah^.handle,kanaly[temp].obsah^.ofset+kanaly[temp].kdejsme,
                     zbyva);
               inc(kanaly[temp].kdejsme,zbyva); {tohle je dulezite - podle toho se zjistuje, jestli uz kanal dohral}
               zbyva:=0;
               {o Cilovou pozici v Mezipameti se uz nemusime starat}
               end
          else begin {zkopirujeme co jde, vratime se na zacatek zvuku a dokoncime to ve druhe iteraci}
               zexms(mezipamet[cilovapozice],
                     kanaly[temp].obsah^.handle,kanaly[temp].obsah^.ofset+kanaly[temp].kdejsme,
                     zbyvajicidelkazvuku);
               dec(zbyva,zbyvajicidelkazvuku);
               inc(cilovapozice,zbyvajicidelkazvuku);
               kanaly[temp].kdejsme:=0;
               zbyvajicidelkazvuku:=kanaly[temp].obsah^.velikost;
               end;
       hlasitost:=kanaly[temp].hlasitost;
       if hlasitost<>0
         then asm
              lea SI,mezipamet {DS:SI = mezipamet}
              mov AX,DS
              lea DI,michacka
              mov ES,AX        {ES:DI = michacka}
              mov CX,delka
               @cyklus:
               lodsb
               imul hlasitost
               sar AX,6       {= idiv 64}
               add [ES:DI],AX {mixovani zvuku = scitani jednotlivych vzorku}
               add DI,2
               loop @cyklus
              end;
       end;*)

function initzvuky(adresa:word; IRQ,DMA,DMA16:byte; povolitautoinit:boolean):boolean;
{$ifdef debug}
{}function AnoNe(co:boolean):string;
{}Begin
{}if co then anone:='ano' else anone:='ne';
{}End;{anone}
{$endif}
var DSPVersion:word;
    i,hodnota:integer;
    BlockAddr:array[0..1] of longint;
Begin
initzvuky:=false;
{porty zvukovky:}
ResetPort:=adresa+$6;
ReadPort:= adresa+$A;
WritePort:=adresa+$C;
PollPort:= adresa+$E;
{zkusime resetovat DSP:}
if not ResetDSP then exit; {pokud se to nepovedlo, je to spatne => koncime}
{zjistime verzi DSP:}
WriteDSP($E1); {dotaz na verzi}
DSPVersion:=ReadDSP; {vyssi byte}
DSPVersion:=(DSPVersion shl 8) or ReadDSP; {nizsi byte}
{podle verze nastavime par promennych:}
autoinit:=povolitautoinit and (DSPVersion>=$0200);
sestnactbitu:=(DSPVersion>=$0400)and(DMA16<>$FF)and(DMA16>3);
{$ifdef debug}
writeln('Inicializace Sound Blasteru');
writeln('Verze DSP: ',hi(dspversion),'.',lo(dspversion));
write('16bitove prehravani: '); writeln(anone(sestnactbitu));
write('Automaticky spoustene DMA prenosy: '); writeln(anone(autoinit));
writeln('Pokracujte stisknutim Enteru...');
readln;
{$endif}
{vypocitame porty a parametry IRQ:}
if IRQ<=7 then begin
               IRQIntVector:=$08+IRQ;
               PICMaskPort:=$21;
               end
          else begin
               IRQIntVector:=$70+IRQ-8;
               PICMaskPort:=$A1;
               end;
IRQStopMask:=1 shl (IRQ and 7);
IRQStartMask:=not IRQStopMask;
{porty a parametry DMA:}
if sestnactbitu then begin
                     DMAMaskPort:=$D4;
                     DMAClrPtrPort:=$D8;
                     DMAModePort:=$D6;
                     DMABaseAddrPort:=$C0+4*(DMA16-4);
                     DMACountPort:=$C2+4*(DMA16-4);
                     case DMA16 of 5:DMAPagePort:=$8B;
                                   6:DMAPagePort:=$89;
                                   7:DMAPagePort:=$8A;
                                   end;
                     DMAStopMask:=DMA16;
                     DMAStartMask:=DMA16-4;
                     DMAMode:=DMA16+$54;
                     AckPort:=adresa+$F;
                     end
                else begin
                     DMAMaskPort:=$0A;
                     DMAClrPtrPort:=$0C;
                     DMAModePort:=$0B;
                     DMABaseAddrPort:=2*DMA;
                     DMACountPort:=1+2*DMA;
                     case DMA of 0:DMAPagePort:=$87;
                                 1:DMAPagePort:=$83;
                                 2:DMAPagePort:=$81;
                                 3:DMAPagePort:=$82;
                                 end;
                     DMAStopMask:=DMA+4;
                     DMAStartMask:=DMA;
                     if AutoInit then DMAMode:=DMA+$58
                                 else DMAMode:=DMA+$48;
                     AckPort:=adresa+$E;
                     end;
if AutoInit then DMALength:=2*delkabloku
            else DMALength:=delkabloku;
daczapnuty:=false;
vzorkovacifrekvence:=vychozivzorkovacifrekvence;
{inicializace bufferu:}
fillchar(kanaly,sizeof(kanaly),0);
adresamezipameti:=@mezipamet;
fillchar(mezipamet,sizeof(mezipamet),0);
fillchar(deskriptor,sizeof(deskriptor),0); {tohle je velice dulezite}
fillchar(michacka,sizeof(michacka),0);
{alokace vystupnich bufferu:}
if sestnactbitu
  then begin
       {Musime najit blok pameti, ktery neprecuhuje pres hranici
       64KB stranky. Nejjistejsi je alokovat 2x vetsi blok nez
       je potreba a pokud jeho prvni pulkou prochazi hranice,
       pouzivat tu druhou:}
       if maxavail<8*delkabloku then exit; {malo pameti}
       getmem(AdresaVystupu,8*delkabloku);
       if ((spocitejlinearniadresu(AdresaVystupu) div 2) mod 65536)+2*delkabloku<65536
         then VystupniPole16b:=AdresaVystupu
         else VystupniPole16b:=normalizujukazatel(Ptr(Seg(AdresaVystupu^),Ofs(AdresaVystupu^)+4*delkabloku));
       for i:=0 to 1 do adresabloku[i]:=normalizujukazatel(addr(VystupniPole16b^[i,0]));
       {parametry DMA:}
       AdresaBufferu:=spocitejlinearniadresu(pointer(VystupniPole16b));
       StrankaBufferu:=AdresaBufferu div 65536;
       OfsetBufferu:=(AdresaBufferu div 2) mod 65536;
       for i:=0 to 1 do begin
                        BlockAddr[i]:=spocitejlinearniadresu(pointer(adresabloku[i]));
                        StrankaBloku[i]:=BlockAddr[i] div 65536;
                        OfsetBloku[i]:=(BlockAddr[i] div 2) mod 65536;
                        end;
       fillchar(VystupniPole16b^,4*delkabloku,0); {16bitove ticho}
       end
  else begin
       {tady je to podobne, jenom je blok polovicni:}
       if maxavail<4*delkabloku then exit;
       getmem(AdresaVystupu,4*delkabloku);
       if (spocitejlinearniadresu(AdresaVystupu) mod 65536)+2*delkabloku<65536
         then VystupniPole8b:=AdresaVystupu
         else VystupniPole8b:=normalizujukazatel(Ptr(Seg(AdresaVystupu^),Ofs(AdresaVystupu^)+2*delkabloku));
       for i:=0 to 1 do adresabloku[i]:=normalizujukazatel(addr(VystupniPole8b^[i,0]));
       {DMA:}
       AdresaBufferu:=spocitejlinearniadresu(pointer(VystupniPole8b));
       StrankaBufferu:=AdresaBufferu div 65536;
       OfsetBufferu:=AdresaBufferu mod 65536;
       for i:=0 to 1 do begin
                        BlockAddr[i]:=spocitejlinearniadresu(pointer(adresabloku[i]));
                        StrankaBloku[i]:=BlockAddr[i] div 65536;
                        OfsetBloku[i]:=BlockAddr[i] mod 65536;
                        end;
       fillchar(VystupniPole8b^,2*delkabloku,$80); {8bitove ticho}
       {inicializace orezavaci tabulky:}
       for i:=-128*pocetkanalu to 128*pocetkanalu do
        begin
        hodnota:=i;
        if hodnota<-128 then hodnota:=-128
                        else if hodnota>127 then hodnota:=127;
        OrezavaciPole[i]:=hodnota+128;
        end;
       end;
vybranyblok:=0;
PuvodniExitProc:=ExitProc;
ExitProc:=@ZrusZvuky;
ovladacxms:=adresaovladacexms;
{instalace obsluhy preruseni:}
asm cli end; {na chvili zakazeme vsechna preruseni}
port[PICMaskPort]:=port[PICMaskPort] or IRQStopMask; {zakazeme nase IRQ}
getintvec(IRQIntVector,puvodnipreruseni); {ulozime puvodni vektor preruseni}
setintvec(IRQIntVector,@ObsluhaPreruseni); {nastavime novy}
port[PICMaskPort]:=port[PICMaskPort] and IRQStartMask; {povolime nase IRQ}
asm sti end; {zase povolime vsechna preruseni}
preruseninainstalovano:=true;
{zapnuti DAC:}
Port[DMAMaskPort]:=DMAStopMask;
Port[DMAClrPtrPort]:=0;
Port[DMAModePort]:=DMAMode;
Port[DMABaseAddrPort]:=Lo(OfsetBufferu);
Port[DMABaseAddrPort]:=Hi(OfsetBufferu);
Port[DMACountPort]:=Lo(DMALength-1);
Port[DMACountPort]:=Hi(DMALength-1);
Port[DMAPagePort]:=StrankaBufferu;
Port[DMAMaskPort]:=DMAStartMask;
inicializujfrekvenci(vzorkovacifrekvence);
if sestnactbitu then begin
                     WriteDSP($B6); {16b, autoinit}
                     WriteDSP($10); {16b mono se znamenkem}
                     WriteDSP(Lo(delkabloku-1));
                     WriteDSP(Hi(delkabloku-1));
                     end
                else begin
                     WriteDSP($D1); {zapnuti reproduktoru}
                     if AutoInit then begin {8b, autoinit - SBPro a vys (DSP 2.0+)}
                                      WriteDSP($48);
                                      WriteDSP(Lo(delkabloku-1));
                                      WriteDSP(Hi(delkabloku-1));
                                      WriteDSP($1C);
                                      end
                                 else begin {8b bez autoinitu - DSP 1.x}
                                      WriteDSP($14);
                                      WriteDSP(Lo(delkabloku-1));
                                      WriteDSP(Hi(delkabloku-1));
                                      end;
                     end;
daczapnuty:=true;
initzvuky:=true;
End;{initzvuky}

procedure zruszvuky;
Begin
ExitProc:=PuvodniExitProc;
if sestnactbitu then WriteDSP($D5) {zastav 16bitovy DMA prenos}
                else begin
                     WriteDSP($D0); {zastav 8bitovy DMA prenos}
                     WriteDSP($D3); {vypni reproduktor}
                     end;
daczapnuty:=false;
port[DMAMaskPort]:=DMAStopMask; {konec DMA}
if preruseninainstalovano
  then begin {odinstalace}
       asm cli end; {zakazeme vsechna preruseni}
       port[PICMaskPort]:=port[PICMaskPort] or IRQStopMask; {zakazeme nase IRQ}
       setintvec(IRQIntVector,puvodnipreruseni); {vratime puvodni vektor preruseni}
       asm sti end; {povolime vsechna preruseni}
       preruseninainstalovano:=false; {zapamatujeme si, ze je odinstalovano}
       end;
if ResetDSP then ;
if sestnactbitu then freemem(AdresaVystupu,8*delkabloku)
                else freemem(AdresaVystupu,4*delkabloku);
End;{zruszvuky}

procedure nastavfrekvencizvuku(frekvence:word);
Begin
vzorkovacifrekvence:=frekvence;
if daczapnuty then if sestnactbitu then begin
                                        inicializujfrekvenci(vzorkovacifrekvence); {nova frekvence}
                                        WriteDSP($D6); {hraj}
                                        end
                                   else begin
                                        WriteDSP($D0); {pauzni zvuk}
                                        inicializujfrekvenci(vzorkovacifrekvence); {nova frekvence}
                                        WriteDSP($D4); {pokracuj v hrani}
                                        end;
{pokud je DAC vypnuty, nastavi se frekvence pri jeho zapnuti}
End;{nastavfrekvencizvuku}

function AktualniFrekvenceZvuku:word;
Begin
aktualnifrekvencezvuku:=vzorkovacifrekvence;
End;{aktualnifrekvencezvuku}

procedure zapnizvuk(handle:word; ofset,velikost:longint; index:byte; opakovat:boolean; hlasitost:byte);
var i:byte;
Begin
for i:=0 to pocetkanalu-1 do with kanaly[i] do
 if not _hraje then begin {OK, mame volny kanal}
                    _handle:=handle;
                    _ofset:=ofset;
                    _velikost:=velikost;
                    _index:=index;
                    _kdejsme:=0;
                    _opakovat:=opakovat;
                    _hlasitost:=hlasitost;
                    _hraje:=true;
                    break;
                    end;
End;{zapnizvuk}

procedure VypniZvuk(index:byte);
var i:byte;
Begin
for i:=0 to pocetkanalu-1 do with kanaly[i] do
 if _hraje and ((index=255)or(index=_index)) then _hraje:=false;
End;{vypnizvuk}

procedure nastavhlasitost(index,novahlasitost:byte);
var i:byte;
Begin
for i:=0 to pocetkanalu-1 do with kanaly[i] do
 if _hraje and((index=255)or(index=_index)) then _hlasitost:=novahlasitost;
End;{nastavhlasitost}

function hrajezvuk(index:byte):boolean;
var i:byte;
Begin
hrajezvuk:=false;
for i:=0 to pocetkanalu-1 do with kanaly[i] do
 if _hraje and((index=255)or(index=_index)) then begin
                                                 hrajezvuk:=true;
                                                 break;
                                                 end;
End;{hrajezvuk}

{************************ prace se soubory WAV: *****************************}

{Trocha teorie:
Soubor WAV se sklada z nekolika bloku. Kazdy blok zacina 8bytovou hlavickou,
po ktere nasleduji data. Hlavicka bloku obsahuje textovou signaturu (4*char)
a za ni udaj o delce (v B) dat v tomto bloku (longint). Pokud je delka dat
licha, nasleduje za daty jeste jeden zarovnavaci byte s hodnotou 0 (tento byte
se ale do udaje o delce nepocita).

Hlavni blok obaluje vsechna data v souboru. Ma signaturu 'RIFF'.
Jeho datova cast zacina textem 'WAVE' (4*char) a dale jsou v ni vlozeny dalsi
bloky. Pro bezne prehravani si vystacime s bloky 'fmt ' (obsahuje informace o
formatu zvuku) a 'data' (obsahuje vlastni zvukova data). Poradi techto bloku
muze byt obecne libovolne, ale obvykle je formatovy blok umisten pred daty, na
coz v teto jednotce spolehame.}

type pole4znaku=array[1..4] of char;

     BlokRiff = record {timhle soubor WAV zacina}
                {hlavicka bloku:}
                SignaturaRiff:pole4znaku;{='RIFF'}
                VelikostDat:longint; {obvykle rovno velikosti souboru minus velikost tehle hlavicky (8 B)}
                {datova cast bloku:}
                identifikatorWave:pole4znaku;{='WAVE'}
                {nasleduji dalsi bloky, ktere cteme zvlast}
                end;

     BlokFmt = record {tenhle je nekde uvnitr datove casti bloku 'RIFF'}
               {hlavicka:}
               {SignaturaFmt:pole4znaku; ='fmt ', nacteme zvlast}
               VelikostDat:longint; {delka dat v tomto bloku}
               {datova cast bloku:}
               komprese:word; {1 = nekomprimovane PCM, zbytek jsou ruzne silenosti}
               PocetKanalu:word; {1 = mono, 2 = stereo, dale existuji i surroundy atd.}
               VzorkovaciFrekvence:longint; {pocet vzorku za sekundu}
               BytuZaSekundu:longint; {vypocita se jako VzorkovaciFrekvence*PocetKanalu,
                                       u komprimovanych zvuku se bere prumerna hodnota}
               BytuNaVzorek:word; {kolik bytu ma jeden vzorek (vsechny kanaly dohromady)}
               BituNaVzorekPro1Kanal:word; {kolik bitu ma 1 vzorek v 1 kanale
                                           (podle tohohle se zvuku rika 8bitovy, 16bitovy apod.)}
               {U nekterych souboru nasleduje jeste:
               DelkaExtraDat:word;
               ExtraData:array[1..DelkaExtraDat] of byte;
               ale tim se nemusime zabyvat (nekomprimovane PCM tato data nepotrebuje).}
               end;

     BlokData = record {tenhle je take uvnitr datove casti bloku 'RIFF', obvykle za blokem 'fmt '}
                {hlavicka:}
                {signaturu 'data' nacteme zvlast}
                VelikostDat:longint; {velice dulezita hodnota, udava delku zvukovych dat}
                {datova cast:}
                {nasleduji zvukova data, ktera nacteme zvlast}
                end;

{Pozn.: PCM znamena "Pulse Code Modulation". Jednotlive vzorky jsou bezna
 binarni cisla primo udavajici polohu membrany reproduktoru, neni v tom zadna
 komprese.
 U 8bitovych zvuku je rozsah vzorku 0..255 s nulovou polohou v hodnote 128,
 u 16bitovych je -32768..32767 s nulovou polohou v nule.}

function NajdiSignaturu(var f:file; signatura:pole4znaku):boolean;
{Bud v danem otevrenem souboru posune "kurzor" na prvni byte za danou
signaturou a vrati true, nebo vrati false, pokud tu signaturu nenajde
(hleda pouze dopredu).}
var pomocna:pole4znaku;
    b:byte;
Begin
najdisignaturu:=false;
pomocna[1]:=#0; {nejaky nesmysl, kterym urcite zadna signatura nezacina}
 repeat
 {hledame prvni znak:}
 while not eof(f) and (pomocna[1]<>signatura[1]) do begin
                                                    blockread(f,pomocna[1],1);
                                                    if ioresult<>0 then exit;
                                                    end;
 if eof(f) then exit; {jestli jsme na konci souboru, tak urcite nic nenajdeme}
 {Ted mame nacteny znak, ktery je stejny jako prvni znak signatury.
 Precteme zbyle tri:}
 for b:=2 to 4 do begin
                  blockread(f,pomocna[b],1); {musime po jednom, jinak bychom mohli signaturu prehlednout}
                  if eof(f) or (ioresult<>0) then exit;
                  if pomocna[b]<>signatura[b] then begin {neni to ono}
                                                   pomocna[1]:=pomocna[b]; {posledne nacteny znak presuneme na zacatek}
                                                   break; {vyskocime z foru a nechame repeat projet odznova}
                                                   end;
                  end;
 until pomocna=signatura;
najdisignaturu:=true; {jestli jsme se dostali az sem, znamena to, ze jsme signaturu nasli}
End;{najdisignaturu}

function NactiWAV(HandleBloku:word; Ofset:longint; var velikost:longint; JmenoSouboru:string):longint;
label konec;
var f:file;
    riff:blokriff;
    fmt:blokfmt;
    data:blokdata;
    buffer:pointer;
    VelikostBufferu:longint;
    zbyva:longint;
    nacteno,w:word;
Begin
nactiwav:=0;
buffer:=nil;
assign(f,jmenosouboru);
reset(f,1);
if ioresult<>0 then exit; {soubor neexistuje}
blockread(f,riff,sizeof(blokriff)); {nacteme hlavicku}
if (ioresult<>0) or (riff.signaturaRiff<>'RIFF') or (riff.identifikatorWave<>'WAVE')
   or not najdisignaturu(f,'fmt ') then goto konec;
blockread(f,fmt,sizeof(blokfmt));
if (ioresult<>0) or (fmt.komprese<>1)
 or not najdisignaturu(f,'data') then goto konec;
blockread(f,data,sizeof(blokdata));
if ioresult<>0 then goto konec;
{$ifdef debug}
writeln('Nacitame zvukovy soubor: ',jmenosouboru);
with fmt do begin
            writeln('typ komprese: ',komprese);
            writeln('pocet kanalu: ',PocetKanalu);
            writeln('frekvence: ',VzorkovaciFrekvence);
            writeln('B/s prumerne: ',BytuZaSekundu);
            writeln('B/vzorek celkem: ',BytuNaVzorek);
            writeln('b/vzorek pro jeden kanal: ',BituNaVzorekPro1Kanal);
            end;
{$endif}
if fmt.bytunavzorek>4 then goto konec;
{vedlejsi funkce:}
if ofset=maxlongint then begin {jenom vratime velikost zvuku po prevedeni na 8bitovy mono}
                         nactiwav:=data.velikostdat div fmt.bytunavzorek;
                         goto konec;
                         end
 else if ofset=maxlongint-1 then begin {jenom vratime vzorkovaci frekvenci}
                                 nactiwav:=fmt.vzorkovacifrekvence;
                                 goto konec;
                                 end;
{vypocet velikosti cteciho bufferu:}
velikostbufferu:=maxavail; {kolik je volne pameti?}
if velikostbufferu>65528 then velikostbufferu:=65528; {omezime na maximalni alokovatelnou hodnotu}
if velikostbufferu>data.velikostdat then velikostbufferu:=data.velikostdat; {jestli je soubor mensi, zmensime i zasobnik}
while velikostbufferu mod fmt.bytunavzorek<>0 do dec(velikostbufferu); {zarovname na cele vzorky}
{zaokrouhlovat nahoru na sudou delku neni nutne, protoze ze zasobniku budeme pouze cist}
getmem(buffer,velikostbufferu); {alokujeme cteci zasobnik}
{inicializace zaznamu o zvuku:}
velikost:=data.velikostdat;
{nacteni zvuku:}
zbyva:=data.velikostdat;
while zbyva>0 do
 begin
 blockread(f,buffer^,velikostbufferu,nacteno);
 if nacteno=0 then goto konec; {chyba pri cteni}
 {uprava zvuku na pozadovany format (mono 8 bitu se znamenkem):
  (pozn.: Assembler tu neni ani tak kvuli rychlosti, ale hlavne kvuli
  prehlednosti a jednoduchosti - ve srovnani s komplikovanymi for-cykly s
  nekolikrat pretypovanym bufferem, ukazateli a tak je to brnkacka :-) )}
 if fmt.bytunavzorek=1 then asm {8b mono}
                            mov CX,nacteno
                            les DI,buffer
                             @cyklus:
                             mov AL,[ES:DI] {nacteme jeden vzorek (cislo bez znamenka v rozsahu 0..255, prostredek je 128)}
                             sub AL,128 {timhle to prevedeme na shortint se znamenkem (s nulou uprostred)}
                             stosb      {a ulozime zpatky}
                             loop @cyklus
                            end
  else if fmt.bytunavzorek=4 then asm {16b stereo}
                                  mov CX,nacteno
                                  shr CX,2       {CX = pocet vzorku (4 B na jeden)}
                                  push DS
                                  les DI,buffer  {ES:DI = cilova oblast v bufferu}
                                  lds SI,buffer  {DS:SI = zdrojova oblast v bufferu}
                                   @cyklus:
                                   lodsw          {AX = levy vzorek}
                                   mov DX,[DS:SI] {DX = pravy vzorek}
                                   add SI,2
                                   add AX,DX  {v 16bitovem formatu jsou to integery se znamenkem, takze nemusime hybat s nulou}
                                   sar AX,9       {AX = zprumerovany vzorek smrskly do 8bitoveho rozsahu}
                                   stosb
                                   loop @cyklus
                                  pop DS
                                  end
   else if fmt.pocetkanalu=2 then asm {8b stereo}
                                  mov CX,nacteno
                                  shr CX,1       {CX = pocet vzorku}
                                  push DS
                                  les DI,buffer  {ES:DI = cilova oblast v bufferu}
                                  lds SI,buffer  {DS:SI = zdrojova oblast v bufferu}
                                   @cyklus:
                                   lodsb          {AL = levy vzorek}
                                   mov DL,[DS:SI] {DL = pravy vzorek}
                                   inc SI
                                   sub AL,128
                                   sub DL,128
                                   add AL,DL
                                   sar AL,1   {AL = zprumerovany vzorek}
                                   stosb
                                  loop @cyklus
                                  pop DS
                                  end
    else asm {16b mono}
         mov CX,nacteno
         shr CX,1
         push DS
         les DI,buffer
         lds SI,buffer
          @cyklus:
          lodsw
          sar AX,8  {prevod na 8bitovy rozsah}
          stosb
          loop @cyklus
         pop DS
         end;
 doxms(handlebloku,ofset,buffer^,nacteno div fmt.bytunavzorek);
 inc(ofset,nacteno div fmt.bytunavzorek);
 dec(zbyva,nacteno);
 end;
nactiwav:=fmt.vzorkovacifrekvence; {jestli jsme se dostali az sem, je vsechno v poradku}
konec:
if buffer<>nil then freemem(buffer,velikostbufferu);
close(f);
if ioresult<>0 then {uz je mi to jedno};
End;{nactiwav}

function VelikostWAVu(JmenoSouboru:string):longint;
var nanic:longint;
Begin
velikostwavu:=nactiwav(0,maxlongint,nanic,jmenosouboru);
End;{velikostwavu}

function FrekvenceWAVu(JmenoSouboru:string):longint;
var nanic:longint;
Begin
frekvencewavu:=nactiwav(0,maxlongint-1,nanic,jmenosouboru);
End;{frekvencewavu}

BEGIN
preruseninainstalovano:=false;
END.