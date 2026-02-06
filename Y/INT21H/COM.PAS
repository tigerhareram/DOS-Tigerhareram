(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: COM.PAS                                                        *)
(*  Obsah: veci pro komunikaci po seriovem kabelu mezi dvema pocitaci      *)
(*  Autor puvodni jednotky IBMCOM 3.0: Wayne E. Conrad (leden 1989)        *)
(*  Preklad, vysvetlivky a mnoha vylepseni: Mircosoft                      *)
(*                                          (http://mircosoft.mzf.cz)      *)
(*  Posledni uprava: 22.2.2007                                             *)
(*  Pro kompilaci: DOS.TPU                                                 *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit COM;
{$R-,S-,B-}

{ Trocha teorie
~~~~~~~~~~~~~~~~~
 Po devitizilovem seriovem kabelu RS 232 spolu muze komunikovat bud pocitac
(DTE) a modem (DCE), v takovem pripade se pouzije nekrizeny kabel (modem ma
prohozene dirky v zasuvce), nebo dva pocitace (DTE - DTE), pak se pouzije
kabel krizeny (takovemu kabelu se rika null modem).
 Seriovy prenos znamena, ze kazdy posilany byte se rozlozi na jednotlive bity
a ty se poslou jeden po druhem po jednom drate.
 Bity se prenaseji pomoci napeti vzhledem k "zemi" (0 V). L (logicka 0) je
-3..-15 V, H (log. 1) je +3..+15 V. Obvykle se pracuje s hodnotou +-10 voltu.
Hodnoty -3..+3 V neznamenaji nic, nanejvys nam reknou, ze je poskozeny nebo
vypojeny kabel.
 Funkce jednotlivych zil v kabelu (pro zkrizeny kabel DTE - DTE cili PC - PC):
SG (Signal Ground) - zem signalu (0 V). Vuci ni se pocitaji veskera napeti.
  Spolecna pro obe strany.
TX (Transmitter) - vysilac
RX (Receiver) - vysilac
  TX a RX jsou zkrizene. Na jednom konci poslu bit do TX a na druhem vyleze
  z RX. Prenos je plne duplexni, tj. v jednom okamziku muzu posilat data obema
  smery najednou, kazdy po jednom drate. SG, TX a RX uz samy staci na zakladni
  prenos (v teto jednotce si s nimi vystacime).
RTS (Request To Send) - "jsem pripraven, muzes mi posilat data"
CTS (Clear To Send) - "na druhe strane jsou pripraveni na prijem dat"
  Opet zkrizene draty. Kdyz poslu druhemu pocitaci RTS, objevi se mu to na
  CTS a naopak. Dokud nemam CTS = H, nic neposilam, protoze vim, ze to ted
  druhy pocitac nemuze zpracovat a data by se ztratila. Zde nechame RTS
  nastaven permanentne na H.
DTR (DTE Ready) - "na tomto konci dratu je pripojen pocitac (DTE)".
DSR (DCE Ready) - "na tomto konci dratu je pripojen modem (DCE)".
  Tyhle jsou taky zkrizene. Jen informuji o tom, ze na druhem konci kabelu
  nekdo je. Take nastavime na H a nechame byt.
DCD (Data Carrier Detect) a RI (Ring Indicator) - maji vyznam pouze pri
  pouziti modemu (detekovana nosna vlna a indikator vyzvaneni).

 Pozor na to, ze ne kazdy kabel ma uvnitr opravdu vsech 9 dratu! Dost casto
se muzeme setkat s pripady, kdy tam jsou jenom TX, RX a SG. RTS je propojeno
s CTS a DTR s DSR a DCD uvnitr zastrcek na kazdem konci kabelu (takze napr.
vysleme RTS a okamzite se nam vrati CTS bez ohledu na to, co se na druhe
strane doopravdy deje). Proto jestli chcete univerzalne pouzitelnou
komunikaci, radeji pouzivejte jen tri zakladni vodice.

 Byty se prenaseji v ramcich, ktere vypadaji (bit po bitu) takhle (brano tak,
ze vlevo je zacatek; popisky ctete odspodu):

1111110DDDDDDDDP1111111
...__/|\______/|\/\___...
   |  |  |     ||  |
   |  |  |     ||  +-- opet vychozi stav linky
   |  |  |     |+-- jeden, 1.5 (jen otazka casove prodlevy na vysilaci) nebo
   |  |  |     |    dva stopbity s hodnotou 1. Urcuji delku pauzy po kazdem
   |  |  |     |    ramci, aby ho prijimac behem ni stihl zpracovat.
   |  |  |     +-- paritni bit (nepovinny)
   |  |  +-- datove bity, nejnizsi jde prvni. Pocet datovych bitu v jednom
   |  |      ramci neni pevny, muzeme si ho nastavit.
   |  +-- start bit - okamzikem prechodu napeti z H na L se synchronizuje cas
   |      na prijimaci a zacnou se prijimat jednotlive datove bity.
   +-- Pokud se nic neposila, je na datovem dratu hodnota H (log. 1).

 Prenos je asynchronni, tj. kazda strana ma sve "hodiny" (taktovaci signal),
ktere se synchronizuji pouze na zacatku ramce sestupnou hranou startbitu.
Vzhledem k tomu, jak je ramec kratky, nehrozi vetsinou za tu chvilku ztrata
synchronizace. Sirku (dobu trvani) jednoho bitu urcuje rychlost portu v bitech
za sekundu (baud), kterou si muzeme nastavit a musi byt na obou pocitacich
stejna.

 O prevod odesilanych a prijimanych dat z paralelnich 8 bitu na seriovy tvar
a zpet se stara obvod UART (pomoci posuvnych registru).

 Paritni bit slouzi k detekci chyb pri prenosu. Da se z nej poznat, ze je
v doslem bytu lichy pocet chybnych bitu. Pokud si nastavime (procedurou
ComSetup) paritu jinou nez zadnou, bude paritni bit automaticky doplnovan ke
kazdemu posilanemu ramci tak, aby byl vysledny bitovy soucet datovych bitu
sudy nebo lichy (parita even nebo odd), nebo se nastavi vzdy na 1 nebo na 0
(parita one nebo zero). Prijimac opet automaticky zkontroluje, jestli parita
sedi, a jestli ne, nahlasi chybu (o pripadne vyslani pozadavku na opakovani
prenosu se ale musime postarat sami).
 Obvykle paritu neni treba pouzivat. Chyby vznikaji daleko casteji tim, ze
jeden pocitac nestihne vcas ulozit prisly ramec a tim se mu ten dalsi ztrati,
nez aby vznikaly rusenim na drate, coz by se dalo detekovat paritou (navic
v teto jednotce nejsou zadne prostredky, ktere by takto detekovane chyby
osetrily).}

interface
uses dos;

(******************* instalace, odinstalace, nastaveni: *********************)
function ComInstall(PortNum:Word):boolean;
{Nainstaluje obsluhu preruseni pro dany port. PortNum je cislo portu
(1 pro COM 1 az 4 pro COM 4). Tato jednotka nedokaze obsluhovat vic portu
najednou, takze pokud chcete prepnout na jiny, musite nejdriv preruseni
odinstalovat.
Pri zavolani teto procedury se vyprazdni prijimaci i odesilaci fronta.}
procedure ComUninstall;
{Odinstaluje obsluhu portu a vrati vse do puvodniho stavu. Pokud ji po
skonceni prace zapomenete zavolat, udela to na konci programu sama (Exitproc).}
procedure ComSetup(Speed:longint; Parity,Data_Stop_Bits:byte);
{Nastavi rychlost, paritu, datove bity a stopbity. Volejte az po Cominstall.
 Speed - rychlost v baudech (bit/s). Rozsah 2..115200, obvykle se pouzivaji
         hodnoty 2400 (pomalu, ale jiste), 9600 (cca maximum pro 486ky) nebo
         57600 (rychlost telefonniho modemu, ale jen pro rychle pocitace).
         Technicka poznamka: rychlost se UARTu zadava pomoci delitele:
         delitel = 115200 div Speed (to se spocita uvnitr procedury) a
         vysledna rychlost bude 115200 div delitel (to si spocita UART).
         To jen aby bylo jasno, ze se rychlost rozhodne neda nastavit s
         presnosti na baudy. Nastavitelne rychlosti jsou: 115200,57600,38400,
         28800,23040,19200,16457,14400,12800,11520,10472,9600,8861,8228,7680,
         7200,...,6400,...,2400,...,1200... atd., dal uz je nastavovani
         pomerne jemne. Kdyz zadate hodnotu mezi, zaokrouhli se rychlost
         nahoru.
 Parity - nastaveni paritni kontroly dat:}
   const comNone=0;   {zadna - obvykla volba}
         comOdd=1;    {licha}
         comEven=3;   {suda}
         comZero=5;   {paritni bit = 0}
         comOne=7;    {paritni bit = 1
 Data_Stop_Bits - pocet datovych bitu (prvni cislo v identifikatoru) a
                  stopbitu (druhe cislo) v jednom ramci:}
         com5d1s=0;
         com6d1s=1;
         com7d1s=2;
         com8d1s=3;   {8 datovych bitu a 1 stopbit - obvykla volba}
         com5d15s=4;   {(15 znamena 1.5 stopbitu)}
         com6d2s=5;
         com7d2s=6;
         com8d2s=7;   {8 dat. bitu a 2 stopbity - dalsi obvykla volba}

(****************************** odesilani: **********************************)
{Data jsou ukladana do kruhove fronty, ve ktere cekaji, az na ne bude mit
UART cas a posle je. Odesilani do fronty je pomerne rychle, takze muzeme
poslat velky blok dat (musi se vejit do odesilaci fronty; pokud ne, pocka se,
az se uvolni nejake misto) a zatimco ho obsluha preruseni cpe do kabelu, muze
uz nas program davno delat neco jineho.}

const tx_queue_size=2048; {Velikost odesilaci fronty v B. Nastavte si dle
        potreby (nejlepe nejake cislo delitelne 16). Pri instalaci portu bude
        fronta alokovana na hromade (Getmem).}

function ComTxReady:Boolean;
{Zjisti, jestli je v odesilaci fronte misto aspon na 1 B. Pokud neni vubec
nainstalovane preruseni, vraci false.}
function ComTxEmpty:Boolean;
{Zjisti, jestli je odesilaci fronta prazdna. Pokud neni nainstalovane
preruseni, vraci true.}
function ComTxFree:word;
{Vraci pocet volnych bytu v odesilaci fronte.}
procedure ComFlushTx;
{Vyprazdni odesilaci frontu.}
procedure ComTx(b:byte);
{Necha poslat jeden byte (vlozi ho do odesilaci fronty). Pokud je fronta plna,
ceka, az se nejake misto uvolni.}
procedure ComTxBlock(var data; size:word);
{Odesle blok dat (jakoukoli promennou). Size je velikost bloku v bytech.}

(******************************** prijem: ***********************************)
{Prijate byty se automaticky ukladaji do druhe kruhove fronty (pokud tam na ne
je misto; pokud ne, ztraceji se). Staci, aby bylo nainstalovano preruseni
portu, a prijem je bezpecne zajisten. Dokud ve fronte nedochazi misto (!!!),
neni treba neustale hlidat a prijata data zpracovavat.}

const rx_queue_size=8192; {velikost prijimaci fronty - nastavte dle potreby}

function ComRxReady:boolean;
{Zjisti, jestli v prijimaci fronte cekaji nejaka prijata data. Pokud neni
nainstalovane preruseni, vraci false.}
function ComRxEmpty:boolean;
{Zjisti, jestli je prijimaci fronta prazdna. Pokud neni nainstalovane
preruseni, vraci true.}
procedure ComFlushRx;
{Vyprazdni prijimaci frontu.}
function ComRx:byte;
{Precte jeden byte z prijimaci fronty. Jestli zatim neprislo nic (fronta je
prazdna), ceka, az neco prijde. Kdyz neni nainstalovane preruseni, vraci 0.}
procedure ComRxBlock(var data; size:word);
{Precte z prijimaci fronty blok dat dane velikosti. Data je promenna, kam se
prijate byty zapisou, Size je velikost dat v B. Pokud neni nainstalovano
preruseni, s promennou Data se nic nestane.}

(*********************** bezpecnostni pojistka: *****************************)
{Kdyz neni misto v odesilaci fronte, procedury Comtx a Comtxblock cekaji,
dokud se nejake neuvolni. Kdyz je prijimaci fronta prazdna, procedury Comrx a
Comrxblock cekaji, az neco prijde. Nekdy se ale muze stat, ze budou cekat
marne, protoze se nekde stala nejaka neocekavana chyba (vypojil se kabel,
jeden pocitac spadnul a podobne). Aby se zabranilo cekani donekonecna, jsou tu
nasledujici procedury a funkce:}

var BreakFunc:function:boolean;
{Funkce, ktera se cyklicky vola pri kazdem cekani. Jakmile vrati hodnotu true,
cekani okamzite konci bez ohledu na to, jestli se cekajici procedura dockala
nejakych vysledku. Za tuto funkci si muzete ve svem programu dosadit treba
test stisknuti nejake klavesove kombinace, pocitani ubehleho casu a podobne.}
function EmptyBreakFunc:boolean;
{Tato funkce je standardne dosazena za Breakfunc. Vraci vzdy false (a tedy
zatim nic neresi, pozor!).}
var BreakFuncInit:procedure;
{Tato procedura se vola na zacatku kazde procedury nebo funkce, ktera obsahuje
nejake cekani. Muzete si sem dosadit treba reset klavesnice nebo vynulovani
casomiry apod.
Pozn.: pri pouziti casomiry a odesilani bloku dat pozor na to, ze se
inicializace provadi pred odeslanim celeho bloku. Maximalni delku cekani
musite velikosti bloku prizpusobit, aby se prenos neprerusil, kdyz se posila
neco hodne velkeho a trva to hodne dlouho (ale pritom bez problemu).}
procedure EmptyProc;
{Prazdna procedura; nedela vubec nic. Je standardne dosazena za Breakfuncinit.}

implementation

const
max_port=4; {predpokladame maximalne 4 seriove porty na jednom pocitaci}

{maximalni indexy front (indexuje se od 0):}
tx_queue_max=tx_queue_size-1;
rx_queue_max=rx_queue_size-1;

intnums: array[1..max_port] of Byte=($0C,$0B,$0C,$0B);{cisla preruseni pro jednotlive porty}
i8259levels: array[1..max_port] of Byte=(4,3,4,3);{cisla IRQ pro jednotlive porty}

com_installed:boolean=false;{true, pokud je nainstalovano ridici preruseni}

var

uart_base:array[1..max_port] of word absolute 0:$0400;
{Adresy bazovych registru jednotlivych seriovych portu, primo v pameti BIOSu.
Obvykle to jsou hodnoty $3F8,$2F8,$3E8 a $2E8.}

{I/O registry (adresy portu) UARTu
(hodnoty zavisi na tom, ktery port pouzivame):}
uart_data:word; {Data Register - sem se zapisuji data k odeslani a ctou se
                 prijata data (cteni i zapis sice provadime pres stejny port,
                 ale fyzicky jsou to dva ruzne registry).}
uart_IER:word; {Interrupt Enable Register - urcuje, kdy se ma preruseni volat.}
uart_IIR:word; {Interrupt Identification Register. Z nej se procedura
                obsluhujici preruseni dozvi, proc byla zavolana.
                Zapisem do tohoto registru se da povolit nebo zakazat interni
                hardwarova fronta UARTu 16550.}
uart_LCR:word; {Line Control Register - pomoci nej nastavujeme parametry
                prenosove linky.}
uart_MCR:word; {Modem Control Register. Pres nej ridime mj. signaly DTR a RTS.}
uart_LSR:word; {Line Status Register - z nej cteme stav prenosove linky.}
uart_MSR:word; {Modem Status Register - z nej bychom cetli stav modemu,
                kdybychom ho pouzivali, coz tato jednotka nedela.}
{Jeste existuje SPR (Scratch Pad Register), ale netusim, k cemu je dobry. Tato
jednotka ho na nic nepouziva.}

{puvodni hodnoty pro obnoveni pri odinstalaci:}
old_ier,old_mcr:byte;{puvodni hodnoty registru IER a MCR}
old_vector:pointer;{puvodni vektor preruseni}
old_i8259_mask:byte;{puvodni bitova maska radice preruseni (IRQ)}

i8259bit:byte;{bitova maska pro radic preruseni (IRQ)}
intnum:byte;{cislo vektoru preruseni}

type fronta=array[0..0] of byte; {sablona fronty (bude to dynamicke pole)}

{prijimaci fronta:}
var rx_queue:^fronta;
    rx_in:word;    {index pozice, na kterou se ma vlozit pristi prichozi byte}
    rx_out:word;   {index pozice, ze ktere se ma cist}
    rx_chars:word; {pocet bytu ve fronte}

{odesilaci fronta:}
    tx_queue:^fronta;
    tx_in:word;     {kam zapsat pristi byte}
    tx_out:word;    {odkud cist pristi byte}
    tx_chars:word;  {pocet bytu ve fronte}

exit_save:pointer;{pro ulozeni puvodni adresy procedury Exitproc}

{makra na zakaz a povoleni asynchronnich preruseni:}
procedure disable_interrupts; inline($FA); {asm cli}
procedure enable_interrupts; inline($FB);  {asm sti}

procedure com_interrupt_driver; interrupt;
{Ovladac poveseny na preruseni. Obvod UART jsme naprogramovali tak, aby toto
preruseni volal pokazde, kdyz byl prijat jeden byte nebo kdyz je pripraven na
poslani dalsiho bytu (pokud to ma povoleno).}
var b,iir:Byte;
Begin
iir:=Port[uart_iir]; {proc tu jsme?}
while (iir and 1)=0 do {dokud je nejnizsi bit IIR nulovy, je co delat}
  begin
  case (iir shr 1) and 3 of
   2:begin{prisel bajt a ceka na zpracovani}
     b:=port[uart_data];{nacteni prijateho bytu (nutne provest v kazdem pripade - prectenim se resetuje prislusny bit v IIR)}
     if rx_chars<=rx_queue_size then begin {pokud na nej je misto v prijimaci fronte, ulozime ho:}
                                     rx_queue^[rx_in]:=b;{ulozeni}
                                     if rx_in=rx_queue_max then rx_in:=0  {fronta je kruhova}
                                                           else inc(rx_in);
                                     inc(rx_chars);
                                     end;
     end;
   1:{vysilaci registr je prazdny, muzeme vysilat}
     if tx_chars=0 {pokud neni co posilat...}
       then Port[uart_ier]:=1{...nastavime preruseni, aby se volalo uz jen pri prijeti dat}
       else if Port[uart_lsr] and 32<>0{Opravdu je ten registr prazdny? (nektere UARTy pry chybne hlasi, ze ano, ale on pritom
                                        neni a kdybychom ted neco poslali, prisli bychom o data, ktera se jiz posilaji)}
              then begin
                   Port[uart_data]:=tx_queue^[tx_out]; {odesleme bajt z vysilaci fronty na port}
                   if tx_out=tx_queue_max then tx_out:=0
                                          else inc(tx_out);
                   dec(tx_chars);
                   end;
   0:b:=Port[uart_msr];{Zmena stavu modemu (CTS, DSR, RI, DCD). Preruseni se
     pri teto situaci volat nema, ale co kdyby... takze pro jistotu prectenim
     MSR tento registr resetujeme, aby se nam tu nekouslo.}
   3:b:=Port[uart_lsr];{Zmena stavu linky (chyby - OE, PE, FE, BI). To same -
     - asi nikdy nenastane, ale kdyby nahodou, tak se musi resetovat.}
   end;{case}
  iir:=Port[uart_iir]; {zjistime, jak jsme na tom ted}
  end;{while}
Port[$20]:=$20;{ohlasime konec preruseni}
End;{com_interrupt_driver}

(*    {pokus o Asm variantu tehoz (nefunguje):}
procedure com_interrupt_driver; far; assembler;
Asm
push DS
push AX
push DX
push ES
push DI
push CX
mov AX,seg @data
mov DS,AX
 @cyklus:
 mov DX,uart_iir
 in AL,DX
 mov CL,AL
 test CL,1
 jnz @hotovo
 shr CL,1
 and CL,3
 {*************** prijem: ***************}
 cmp CL,2
 jne @KonecPrijmu
  mov DX,uart_data
  in AL,DX
  cmp rx_chars,rx_queue_size
  jge @KonecPrijmu
   les DI,rx_queue
   add DI,rx_in
   mov ES:[DI],AL
   inc rx_chars
   inc rx_in
   cmp rx_in,rx_queue_max
   jle @KonecPrijmu
    mov rx_in,0
 @KonecPrijmu:
 {************* odesilani: ***************}
 cmp CL,1
 jne @KonecOdesilani
  cmp tx_chars,0
  jne @odesilame
   mov DX,uart_ier
   mov AL,1
   out DX,AL
   jmp @neodesilame
  @odesilame:
  mov DX,uart_lsr
  in AL,DX
  test AL,32
  jz @KonecOdesilani
   les DI,tx_queue
   add DI,tx_out
   mov AL,ES:[DI]
   mov DX,uart_data
   out DX,AL
   inc tx_out
   dec tx_chars
   cmp tx_out,tx_queue_max
   jle @KonecOdesilani
    mov tx_out,0
 @KonecOdesilani:
 {********** resetovani pripadnych chybovych priznaku: ***********}
 or CL,CL
 jnz @MSRstejny
  mov DX,uart_msr
  in AL,DX
 @MSRstejny:
 cmp CL,3
 jne @cyklus
  mov DX,uart_lsr
  in AL,DX
 jmp @cyklus
@hotovo:
mov AL,$20
out $20,AL
pop CX
pop DI
pop ES
pop DX
pop AX
pop DS
iret
End;{com_interrupt_driver}
(**)

function cominstall(portnum:Word):boolean;
Begin
if com_installed or(portnum<1)or(portnum>max_port)or(uart_base[portnum]=0)
  then cominstall:=false
  else begin
       {instalace odinstalacni procedury, ktera se automaticky zavola pri ukonceni programu:}
       exit_save:=ExitProc;
       ExitProc:=@comuninstall;
       {nastaveni I/O adres a dalsich hodnot pro vybrany port:}
       uart_data:=uart_base[portnum]; {zakladni adresa (datovy registr)}
       uart_ier:=uart_data+1;
       uart_iir:=uart_data+2;
       uart_lcr:=uart_data+3;               {adresy ostatnich registru}
       uart_mcr:=uart_data+4;
       uart_lsr:=uart_data+5;
       uart_msr:=uart_data+6;
       intnum:=intnums[portnum]; {cislo preruseni}
       i8259bit:=1 shl i8259levels[portnum]; {maska preruseni (IRQ)}
       {detekce, jestli existuje potrebny hardware:}
       old_ier:=Port[uart_ier]; {ulozime hodnotu registru povoleni preruseni}
       Port[uart_ier]:=0; {zapiseme tam nulu...}
       if Port[uart_ier]<>0 {...a pokud tam nezustala...}
         then cominstall:=false {...je to spatne, obvod UART neexistuje nebo nefunguje}
         else begin
              cominstall:=true; {OK, ted uz to musi vyjit}
              {zakaz prislusneho IRQ:}
              disable_interrupts; {zakazeme vsechna preruseni, aby se nam tohle nahodou nespustilo,
                                   kdyz se v nem zrovna chystame stourat}
              old_i8259_mask:=Port[$21]; {zjistime a ulozime puvodni masku tohoto preruseni (IRQ)...}
              Port[$21]:=old_i8259_mask or i8259bit; {...a prozatim ho zakazeme
                                                     (preruseni je zakazane, kdyz je prislusny bit nastaven na 1)}
              enable_interrupts; {vsechna ostatni hardwarova preruseni muzeme zase povolit, to nase je zakazane na urovni IRQ}
              {alokujeme obe fronty:}
              getmem(tx_queue,tx_queue_size);
              getmem(rx_queue,rx_queue_size);
              comflushtx; comflushrx; {a vyprazdnime je}
              {nastaveni vektoru obsluhy preruseni:}
              GetIntVec(intnum,old_vector); {ulozime puvodni vektor preruseni...}
              SetIntVec(intnum,@com_interrupt_driver); {...a nastavime novy - adresu nasi obsluzne procedury}
              {nastaveni LCR:}
              Port[uart_lcr]:=3;{pro zacatek nastavime zadnou paritu a 1 stopbit, na prenosovou rychlost nesahame}
              {nastaveni MCR:}
              disable_interrupts;{nevim, jestli je tohle nutne, kdyz je zakazane IRQ; radsi to tu necham}
              old_mcr:=Port[uart_mcr]; {zjistime a ulozime puvodni hodnotu registru MCR}
              Port[uart_mcr]:=11; {aktivujeme draty RTS a DTR a nastavime bit OUT2 na 1 (nutne, aby preruseni fungovalo)}
              enable_interrupts;
              {nastaveni IER:}
              Port[uart_ier]:=1; {zapneme automaticke volani preruseni pri
               prijeti dat (volani preruseni pro odesilani zapina odesilaci
               procedura a vypina si ho samo preruseni, kdyz odesle z fronty
               posledni byte)}
              {povoleni hardwarove fronty obvodu UART 16550:}
              port[uart_iir]:=71; {tj. povolit pouziti prijimaci a vysilaci
               fronty, obe vyprazdnit a nastavit neco na 4 B (Nevim, jestli to
               je velikost fronty nebo frekvence volani preruseni - po kazdem
               4. prijatem nebo odeslanem bytu. Podle AThelpu je to ta druha
               varianta, ale zrovna v AThelpu byly chybne konstanty pro cteni
               IIR, takze nevim, jestli mu muzu verit. Kazdopadne ted neni
               problem poslat nebo prijmout data o obecne delce - vyzkouseno).}
              {povoleni IRQ:}
              disable_interrupts;
              Port[$21]:=Port[$21] and not i8259bit; {pomoci vynulovani bitu v masce IRQ povolime nase preruseni}
              enable_interrupts;
              com_installed:=true; {zapamatujeme si, ze uz mame nainstalovano}
              end;
       end;
End;{cominstall}

procedure comsetup(speed:longint; parity,data_stop_bits:byte);
var lcr:byte;
    divisor:word; {delitel rychlosti}
Begin
if com_installed then
 begin
 {slozeni hodnoty registru:}
 lcr:=(parity shl 3) or data_stop_bits;
 {delitel rychlosti:}
 if speed<2 then speed:=2; {min. 2 baudy}
 divisor:=115200 div speed;
 {nastaveni hodnot:}
 disable_interrupts;
 Port[uart_lcr]:=lcr or 128; {128 rika, ze budeme zadavat rychlost}
 Portw[uart_data]:=divisor; {rychlost se zadava pres datovy a IER registr}
 Port[uart_lcr]:=lcr; {nastavime hodnotu pro normalni provoz (s nejvyssim bitem = 0)}
 enable_interrupts;
 comflushtx; comflushrx;
 end;
End;{comsetup}

procedure comuninstall;
Begin
if com_installed then
  begin
  {vratime ukazatel na puvodni ukoncovaci proceduru:}
  ExitProc:=exit_save;
  {zakaz IRQ (budeme se v nem zase stourat):}
  disable_interrupts;
  port[$21]:=port[$21] or i8259bit;
  enable_interrupts;
  {vratime puvodni hodnoty registru:}
  Port[uart_mcr]:=old_mcr;
  Port[uart_ier]:=old_ier;
  {vratime puvodni vektor preruseni:}
  SetIntVec(intnum,old_vector);
  {povoleni IRQ (pokud puvodne bylo povolene):}
  disable_interrupts;
  Port[$21]:=Port[$21] and not i8259bit or old_i8259_mask and i8259bit;
   {Obnovujeme pouze ten jeden bit u nami pouziteho IRQ. Neda se napsat jenom
    port[$21]:=old_i8259_mask, protoze kdykoli po nainstalovani nasi obsluhy
    portu mohl nejake jine IRQ zmenit nejaky jiny program a my mu to ted
    nesmime rozhodit.}
  enable_interrupts;
  {zrusime fronty:}
  freemem(tx_queue,tx_queue_size);
  freemem(rx_queue,rx_queue_size);
  rx_chars:=0; tx_chars:=0;
  rx_in:=0;    tx_in:=0;
  rx_out:=0;   tx_out:=0;
  {a je odinstalovano:}
  com_installed:=false;
  end;
End;{comuninstall}

procedure comflushrx;
Begin
disable_interrupts; {aby se nevolala nase obsluha preruseni, kdyz se stourame ve fronte}
rx_chars:=0;
rx_in:=0;
rx_out:=0;
enable_interrupts;
End;{comflushrx}

procedure comflushtx;
Begin
disable_interrupts;
tx_chars:=0;
tx_in:=0;
tx_out:=0;
enable_interrupts;
End;{comflushtx}

function comrx:byte;
Begin
if com_installed
  then begin
       breakfuncinit;
       while rx_chars=0 do if breakfunc then exit; {cekani, az neco prijde (da se zrusit funkci Breakfunc)}
       disable_interrupts;
       comrx:=rx_queue^[rx_out];
       if rx_out<rx_queue_max then inc(rx_out)
                              else rx_out:=0;
       dec(rx_chars);
       enable_interrupts;
       end
  else comrx:=0;
End;{comrx}

procedure comrxblock(var data; size:word);
type polebytu=array[1..1]of byte;
var i:word;
Begin
if com_installed
  then begin
       breakfuncinit;
       for i:=1 to size do
        begin
        while rx_chars=0 do if breakfunc then exit;
        disable_interrupts;
        polebytu(data)[i]:=rx_queue^[rx_out];
        if rx_out<rx_queue_max then inc(rx_out)
                               else rx_out:=0;
        dec(rx_chars);
        enable_interrupts;
        end;
       end;
End;{comrxblock}

function comrxready:boolean;
Begin
comrxready:=com_installed and (rx_chars<>0);
End;{comrxready}

function comtxready:Boolean;
Begin
comtxready:=com_installed and (tx_chars<tx_queue_size);
End;{comtxready}

function comtxfree:word;
Begin
if com_installed then comtxfree:=tx_queue_size-tx_chars
                 else comtxfree:=0;
End;{comtxfree}

function comtxempty:Boolean;
Begin
comtxempty:=(tx_chars=0) or not com_installed;
End;{comtxempty}

function comrxempty:Boolean;
Begin
comrxempty:=(rx_chars=0) or not com_installed;
End;{comrxempty}

procedure comtx(b:byte);
Begin
if com_installed then
  begin
  breakfuncinit;
  while tx_chars>=tx_queue_size do if breakfunc then exit; {cekame, dokud se neuvolni misto}
  disable_interrupts;
  tx_queue^[tx_in]:=b;
  if tx_in<tx_queue_max then inc(tx_in)
                        else tx_in:=0;
  inc(tx_chars);
  Port[uart_ier]:=3;{nastavime preruseni tak, aby se volalo nejen pri prijeti
                     bytu, ale i pri volnem odesilacim registru}
  enable_interrupts;
  end;
End;{comtx}

procedure comtxblock(var data; size:word);
type polebytu=array[1..1]of byte;
var i:word; {index pro pohyb v odesilanych datech}
Begin
if com_installed then
  begin
  i:=1;
  breakfuncinit;
  while i<=size do
    begin
    while (comtxfree<size)and(not comtxempty) do if breakfunc then exit;{cekame, dokud se neuvolni dostatek mista}
    disable_interrupts;
    while (i<=size)and(tx_chars<tx_queue_size) do
      begin
      tx_queue^[tx_in]:=polebytu(data)[i];
      if tx_in<tx_queue_max then inc(tx_in)
                            else tx_in:=0;
      inc(tx_chars);
      inc(i);
      end;
    Port[uart_ier]:=3; {povolime volani preruseni i pri volnem odesilacim registru}
    enable_interrupts;
    end;
  end;
End;{comtxblock}

function EmptyBreakFunc:boolean; {zde neni potreba uvadet direktivu far, protoze je uvedena v Interface}
Begin
emptybreakfunc:=false;
End;{emptybreakfunc}

procedure EmptyProc;
Begin End;

BEGIN
@breakfunc:=@emptybreakfunc;
@breakfuncinit:=@emptyproc;
END.
