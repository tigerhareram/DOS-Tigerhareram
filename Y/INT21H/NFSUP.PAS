(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: NFSUP.PAS                                                      *)
(*  Obsah: procedury pro presuny dat v rychlejsi nez standardni podobe,    *)
(*         vylepseni typu mnozina                                          *)
(*  Autor: Mircosoft, castecne podle ASP/VR Group (http://mircosoft.mzf.cz)*)
(*         Laaca: zaklad FPUmove                                           *)
(*  Posledni uprava: 16.10.2012                                            *)
(*  Pro kompilaci: nic                                                     *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit NFSUP;{aneb Need For Speed UnderPascal :-) }
{$G+} {povoleni instrukcni sady 80286}
{$N+} {povoleni instrukci pro numericky koprocesor (potrebuje ho FPUMove)}
interface

(************************** kopirovani dat: *********************************)

procedure FillChar32(var kam; kolik:word; ceho:byte);
{podobna jako standardni Fillchar, ale pouziva 32bitove instrukce, takze je
o dost rychlejsi (konkretne 3.39krat, meril jsem to)}
procedure FillWord32(var kam; kolik,ceho:word);
{podobna, ale vyplnuje wordem (Kolik je pocet tech wordu)}
procedure Move32(var odkud; var kam; kolik:word);
{funguje a pouziva se stejne jako standardni Move, ale je opet 32bitova
a cca 3.6krat rychlejsi}
procedure Move32Rev(var odkud; var kam; kolik:word);
{totez, ale kopiruje odzadu (parametry nasmerujte normalne na zacatek danych
promennych stejne jako pri Move32, rozdil je jenom v internim smeru
zpracovani - vhodne napr. pro presouvani obsahu pole doprava)}
Procedure FPUMove(var odkud; var kam; kolik:word);
{Dalsi variace na Move. Tentokrat ne 32bitova, ale rovnou 64bitova.
Je jeste cca 1.29krat rychlejsi nez Move32 a asi 4.63krat rychlejsi nez Move.}


(********************** rychle goniometricke funkce: ************************)

function rychlySin(x:integer):integer;
function rychlyCos(x:integer):integer;
{Vraci sin a cos podle tabulky (const). X je ve stupnich, vysledek je potreba
jeste vydelit 10000. O dost rychlejsi nez standardni sin a cos.}


(**************************** extra mnoziny: ********************************)

{ Standardni pascalovska mnozina (typ Set of neco) je zalozena na bitovych
logickych operacich. Je velka 32 B (vzdy), tedy pole 256 bitu. To, jestli je
urcity prvek v mnozine, se pozna tak, ze je prislusny bit v tomto poli
nastaven na 1. Neni to tedy zadny seznam, do ktereho by se ukladala jednotliva
cisla, ale naopak tato cisla tvori index bitoveho pole. Velikosti mnoziny je
limitovan maximalni pocet prvku (256) a tedy i jejich typ.

Moje varianta mnozin funguje prakticky stejne, ale bitove pole muze byt
libovolne velke (to si zadate na zacatku pri inicializaci) a alokuje se
dynamicky. Prvky mnozin jsou cela cisla typu word nebo libovolny ordinalni typ
pretypovany na cislo.
Zadny specialni typ Mnozina deklarovan neni, pouzijte obycejny ukazatel.}

function InitMn(var Kterou:pointer; ProKolik:word):boolean;
{Alokuje pamet pro danou mnozinu. Prokolik - pro kolik cisel ma byt. Napr.
kdyz Prokolik=10, budu moci do mnoziny ukladat cisla 0..9 (cisluje se od 0).
Vraci true, pokud se mnozinu podari uspesne alokovat.}
procedure ZrusMn(var kterou:pointer);
{Zrusi drive alokovanou mnozinu a nastavi ji na nil. Nepouzivejte ji na
zadny jiny ukazatel nez na mnozinu! Velikost mnoziny v B je totiz ulozena v
prvnich dvou bytech alokovane pameti a podle nich se rozhoduje, kolik B se ma
uvolnit. Kdyby tam byla nejaka kravina, skonci to chybou Invalid pointer
operation a padem programu. Pokud proceduru omylem pouzijete na ukazatel
s hodnotou nil, nic se nestane (alespon nejaka pojistka :-) ).}
procedure MnPridej(DoKtere:pointer; co:word);
{Prida do mnoziny dane cislo.
 POZOR!!! Procedura je optimalizovana pro rychlost, a proto neobsahuje zadnou
kontrolu rozsahu! Pokud vlozite cislo vetsi nez je rozsah zadany pri
inicializaci mnoziny, zpusobite zapis do nealokovane pameti a pad programu
(ve Windows s hlaskou "Program provedl nepovolenou operaci a bude ukoncen",
v DOSu se pocitac vetsinou proste kousne).}
procedure MnVyjmi(ZeKtere:pointer; co:word);
{Vyhodi z mnoziny dane cislo. POZOR!!! Plati stejna poznamka jako u vkladani!}
function JeVMn(kde:pointer; co:word):boolean;
{Otestuje, jestli je dane cislo v dane mnozine. Pozor, opet zadna kontrola
rozsahu! Tady se ale do pameti nezapisuje, takze byste nanejvys dostali
nesmyslny vysledek a program by bezel dal.}
procedure SjednotMn(SeKterou,Kterou:pointer);
{Provede sjednoceni dvou mnozin a vysledek ulozi do te prvni.
 POZOR!!! Druha mnozina nesmi byt vetsi nez ta prvni (velikosti se mysli
 maximalni pocet prvku zadany pri inicializaci)!! Jinak by se opet zapisovalo
 nekam do nealokovane pameti.}
procedure PrunikMn(SeKterou,Kterou:pointer);
{Provede prunik dvou mnozin a vysledek ulozi do te prvni.
 POZOR! Tady je to naopak: druha mnozina nesmi byt mensi nez prvni. Sice by
 nedoslo k chybe, ale vysel by nesmysl, protoze by se pocitalo s
 nedefinovanymi daty "za" druhou mnozinou.
(U sjednoceni i pruniku bude tedy nejjednodussi, kdyz budou obe mnoziny
stejne velke - pak budou bez problemu fungovat obe procedury.)}
function PrvkuVMn(VeKtere:pointer):word;
{Vrati pocet prvku v dane mnozine (tj. pocet cisel, ktera do ni byla vlozena).}

implementation

procedure fillchar32(var kam; kolik:word; ceho:byte); assembler;
Asm
mov AL,ceho         {do AL hodnotu, ktera se ma zapisovat}
mov AH,ceho         {do AH taky}
mov CX,kolik
mov DX,kolik
mov BX,AX           {ulozime AX}
shr CX,2            {CX = kolik dwordu (1 dword = 2 wordy = 4 byty, proto shr 2 cili div 4)}
db $66; shl AX,16   {= shl EAX,16, tedy cely 32b registr}
and DX,3            {DX = kolik bytu jeste zbyde (max. 3)}
mov AX,BX           {EAX ma ted v kazdem bytu pozadovanou hodnotu}
les DI,kam          {ES:DI = adresa cile}
 db $66; rep stosw  {= rep stosd, tj. zapis po dwordech ($66 je prefix pro 32bitovou instrukci)}
mov CX,DX
 rep stosb          {zapis zbytku po bytech}
End;{fillchar32}

procedure FillWord32(var kam; kolik,ceho:word); assembler;
Asm
mov AX,ceho
mov BX,AX
db $66; shl AX,16
mov AX,BX
les DI,kam
mov CX,kolik
shr CX,1
 db $66; rep stosw
jnc @konec      {jestli byl sudy pocet wordu, koncime (CF byl nastaven pri shr CX,1)}
 mov ES:[DI],AX     {posledni lichy word}
@konec:
End;{fillword32}

procedure move32(var odkud; var kam; kolik:word); assembler;
Asm
push DS             {ulozime DS, protoze ho budeme menit}
lds SI,odkud        {DS:SI = adresa zdroje}
les DI,kam          {ES:DI = adresa cile}
mov CX,kolik
shr CX,2            {CX = kolik dwordu}
 db $66; rep movsw  {= rep movsd cili presun po dwordech}
mov CX,kolik
and CX,3            {CX = kolik bytu jeste zbylo (max. 3)}
 rep movsb          {presun zbytku po bytech}
pop DS              {obnoveni DS}
End;{move32}

procedure Move32Rev(var odkud; var kam; kolik:word); assembler;
Asm
mov CX,kolik
push DS
mov BX,CX
lds SI,odkud;  les DI,kam     {ted ukazujeme na zacatky}
add SI,CX;     add DI,CX      {ted za konce}
dec SI;        dec DI         {a ted presne na konce}
shr BX,2    {pocet dwordu}
and CX,3    {pocet zbylych bytu}
std         {otoceni smeru pro instrukci rep (zprava doleva)}
 rep movsb  {zkopirujeme byty, skoncime na poslednim bytu posledniho dwordu}
mov CX,BX
sub DI,3;      sub SI,3       {presun na prvni byte posledniho dwordu}
 db $66; rep movsw;           {zkopirujeme dwordy}
cld         {vraceni smeru na puvodni hodnotu (zleva doprava)}
pop DS
End;{move32rev}

Procedure FPUmove(var odkud; var kam; kolik:word); assembler;
Asm
push DS                      {ulozime DS}
lds SI,odkud                 {DS:SI = adresa zdroje}
les DI,kam                   {ES:DI = adresa cile}
{presun po qwordech:}
mov CX,kolik
shr CX,4                     {CX = pocet 16bytovych bloku, ktere se budou presouvat (shr 4 = div 16)}
jz @MeneNez16                {jestli je CX=0, znamena to, ze je mene nez 16 B a tedy tuhle cast preskocime}
 @smycka:
 fild qword ptr DS:[SI]      {na zasobnik koprocesoru uloz qword (1 qword = 4 wordy = 8 bytu = 64 bitu) ze zdroje}
 fild qword ptr DS:[SI+8]    {dalsi qword na zasobnik (takhle po dvou to delame proto, aby cyklus nemusel bezet tolikrat)}
 fistp qword ptr ES:[DI+8]   {presun vrchni qword ze zasobniku do cile, ale az jako druhy (zasobnik neni fronta)}
 fistp qword ptr ES:[DI]     {druhy (tedy vlastne prvni) qword presun do cile}
 add SI,16
 add DI,16                   {oba indexy zvysime o 16 (tolik bytu se v teto smycce kopirovalo)}
 loop @smycka
@MeneNez16:
{presun po dwordech:}    {odtedka je to v podstate move32 - viz vyse}
mov CX,kolik
and CX,15           {kolik jeste zbylo na zkopirovani po te qwordove casti}
mov kolik,CX        {ulozime}
shr CX,2
 db $66; rep movsw
{presun po bytech:}
mov CX,kolik
and CX,3
 rep movsb
pop DS
End;{fpumove}


const sinus:array[0..180] of integer=
                 (0,175,349,523,698,872,1045,1219,1392,1564,1736,1908,2079,2250,2419,2588,2756,2924,3090,3256,3420,3584,3746,
                  3907,4067,4226,4384,4540,4695,4848,5000,5150,5299,5446,5592,5736,5878,6018,6157,6293,6428,6561,6691,6820,
                  6947,7071,7193,7314,7431,7547,7660,7771,7880,7986,8090,8192,8290,8387,8480,8572,8660,8746,8829,8910,8988,
                  9063,9135,9205,9272,9336,9397,9455,9511,9563,9613,9659,9703,9744,9781,9816,9848,9877,9903,9925,9945,9962,
                  9976,9986,9994,9998,10000,9998,9994,9986,9976,9962,9945,9925,9903,9877,9848,9816,9781,9744,9703,9659,9613,
                  9563,9511,9455,9397,9336,9272,9205,9135,9063,8988,8910,8829,8746,8660,8572,8480,8387,8290,8192,8090,7986,
                  7880,7771,7660,7547,7431,7314,7193,7071,6947,6820,6691,6561,6428,6293,6157,6018,5878,5736,5592,5446,5299,
                  5150,5000,4848,4695,4540,4384,4226,4067,3907,3746,3584,3420,3256,3090,2924,2756,2588,2419,2250,2079,1908,
                  1736,1564,1392,1219,1045,872,698,523,349,175,0);

function rychlysin(x:integer):integer;
var zn:shortint;{znamenko}
Begin
x:=x mod 360;
if x<0 then begin
            zn:=-1; x:=-x;
            end
       else if x>0 then zn:=1
                   else zn:=0;
if x>180 then rychlysin:=zn*(-sinus[x-180])
         else rychlysin:=zn*sinus[x];
End;{rychlysin}

function rychlycos(x:integer):integer;
Begin
rychlycos:=rychlysin(x+90);
End;{rychlycos}


function InitMn(var kterou:pointer; ProKolik:word):boolean;
var PocetBytu:word; {kolik mista zabere v pameti}
Begin
pocetbytu:=(prokolik+7) shr 3;
 {Do jednoho bytu se vejde 8 bitu, takze zadane cislo vydelime osmi (shr 3).
  Sedmicku pricitame proto, aby se vysledek zaokrouhlil nahoru.}
if pocetbytu+2<=maxavail then begin {misto v pameti staci}
                              getmem(kterou,pocetbytu+2);
                              fillchar32(kterou^,pocetbytu+2,0); {vyprazdnime mnozinu}
                              word(kterou^):=pocetbytu; {do prvnich dvou bytu ulozime velikost}
                              initmn:=true; {nahlasime uspech}
                              end
                         else begin {neni misto}
                              kterou:=nil;
                              initmn:=false;
                              end;
End;{initmn}

procedure ZrusMn(var kterou:pointer);
Begin
if kterou<>nil then begin
                    freemem(kterou,word(kterou^)+2);
                    kterou:=nil;
                    end;
End;{zrusmn}

procedure MnPridej(DoKtere:pointer; co:word); assembler;
Asm
mov CX,co      {jake cislo se bude pridavat?}
mov BX,CX      {zkopirovat do BX}
and CX,7       {zbytek po deleni osmi}
shr BX,3       {vydeleni osmi (mame adresu)}
les DI,doktere {do ES:DI nacteme adresu mnoziny}
add DI,2       {presuneme se za ulozenou velikost}
mov AL,1       {pripravime bit}
add DI,BX      {posuneme DI na vypocitanou adresu bytu, ktery budeme menit}
shl AL,CL      {bit v AL posuneme a tim vytvorime bitovou masku}
or ES:[DI],AL  {bit priorujeme do mnoziny a je hotovo}
End;{mnpridej}

procedure MnVyjmi(ZeKtere:pointer; co:word); assembler;
Asm
mov CX,co
mov BX,CX
and CX,7             {...zacatek podobny...}
shr BX,3
les DI,zektere
add DI,2
mov AL,1
add DI,BX
shl AL,CL
not AL         {negace vsech bitu v AL}
and ES:[DI],AL {vynulujeme prislusny bit}
End;{mnvyjmi}

function JeVMn(kde:pointer; co:word):boolean; assembler;
Asm
mov CX,co
mov BX,CX
and CX,7
shr BX,3            {...zacatek je podobny...}
les DI,kde
add DI,2
add DI,BX
mov AL,ES:[DI]  {nacteme prislusny byte}
shr AL,CL {posuneme ho doprava, aby se testovany bit dostal na nejnizsi pozici}
and AX,1 {vynulujeme vsechny bity krome nejnizsiho. Tim ziskame primo ordinalni cislo logickeho (boolean) vysledku.}
End;{jevmn}

procedure SjednotMn(SeKterou,Kterou:pointer); assembler;
Asm
push DS        {DS budeme menit => musi se ulozit}
lds SI,kterou  {nacteme adresu druhe mnoziny}
mov CX,DS:[SI] {precteme jeji velikost - kolik bytu se bude prochazet}
add SI,2       {presuneme se za ulozenou velikost}
les DI,sekterou
add DI,2
 @cyklus:       {pro kazdy byte druhe (mensi nebo stejne velke) mnoziny}
 lodsb
 or ES:[DI],AL  {sjednoceni je v podstate zase jenom obycejny or}
 inc DI
 loop @cyklus
pop DS          {obnoveni DS}
{Nevyuzite bity v poslednim bytu mnoziny maji hodnotu 0 a v logickem souctu se
neuplatni, proto muzeme orovat i posledni byte v celku.}
End;{sjednotmn}

procedure PrunikMn(SeKterou,Kterou:pointer); assembler;
Asm
push DS
lds SI,kterou
add SI,2
les DI,sekterou
mov CX,ES:[DI]    {tady musime pouzit velikost te prvni mnoziny}
add DI,2
 @cyklus:
 lodsb
 and ES:[DI],AL  {prunik znamena and}
 inc DI
 loop @cyklus
pop DS
{Nevyuzite nulove bity na konci druhe mnoziny by vynulovaly odpovidajici
(ale tady uz platne) bity na konci prvni mnoziny, pokud by byla vetsi nez ta
druha. Proto naopak musime brat velikost podle prvni.}
End;{sjednotmn}

function PrvkuVMn(VeKtere:pointer):word; assembler;
Asm
push DS
lds SI,vektere
mov CX,DS:[SI]    {pocet bytu v mnozine}
add SI,2
xor DX,DX         {v DX bude ulozen pocet, takze zatim je 0}
 @cyklus: {cyklus pro kazdy byte mnoziny}
 lodsb
 mov BL,9  {o jedna vic, nez by se zdalo spravne, ale snizujeme ho na zacatku cyklu, ktery tedy probehne spravne osmkrat}
  @rotace: {cyklus pro kazdy bit nacteneho bytu}
  dec BL
  jz @hotovo
   shr AL,1
   jnc @rotace  {kdyz byl "vypadly" bit 0, hodnota se nezvysuje...}
   inc DX       {...jinak ano}
   jmp @rotace
  @hotovo:
 loop @cyklus
pop DS
mov AX,DX   {vysledek funkce se vraci v AX}
End;{prvkuvmn}

END.