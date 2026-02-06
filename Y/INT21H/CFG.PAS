(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: CFG.PAS                                                        *)
(*  Obsah: jednotka pro praci s konfiguracnimi soubory                     *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 10.4.2011                                             *)
(*  Pro kompilaci: RETEZCE.TPU                                             *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit CFG;
{$I-,R-,B-} {dulezite, nemenit}
interface

type
{pomocne typy (netreba cist):}
UkNaCfgPolozku = ^cfgpolozka;
CfgPolozka = record
             dalsi:uknacfgpolozku;
             vyrizeno:boolean;
             data:string; {dva retezce za sebou; prvni nazev, druhy hodnota; celkova delka dynamicka}
             end;
UkNaCfgSekci = ^cfgsekce;
CfgSekce = record
           dalsi:uknacfgsekci;
           vyrizeno:boolean;
           PrvniPolozka:uknacfgpolozku;
           nazev:string; {delka dynamicka}
           end;

{************************* uzivatelsky typ: *********************************}

{(kdyz tady zmacknete End, dostane se obrazovka do spravne polohy pro cteni vysvetlivek)->}

Konfigurace = object
              PrvniSekce,VybranaSekce:uknacfgsekci;
              procedure init;
              {Inicializuje interni ukazatele. Nutne provest pred prvnim pouzitim.}
              function PridejSekci(Jmeno:string):boolean;
              {Vytvori novou prazdnou sekci s danym Jmenem a hned ji automaticky vybere.
              Neresi kolize, takze jestli uz sekce se stejnym jmenem existovala, budete mit
              dve stejne sekce, coz muze pozdeji zpusobit potize.}
              procedure VyberSekci(Jmeno:string);
              {Nastavi interni ukazatel na sekci s danym Jmenem. Vyber sekce je nutny pred
              jakoukoli manipulaci s datovymi polozkami pomoci nasledujicich tri metod:}
              function ZadejPolozku(Jmeno,Hodnota:string):boolean;
              {Do vybrane sekce bud vlozi novou polozku se zadanym Jmenem a Hodnotou (pokud
              v ni neexistovala zadna polozka stejneho jmena) nebo prepise zadanou
              hodnotou existujici polozku se stejnym jmenem. Prazdna hodnota ('') je
              dovolena.}
              function ZadejCislo(jmeno:string; hodnota:longint):boolean;
              {Totez, pro zadavani polozek s ciselnou hodnotou.}
              function ZadejReal(jmeno:string; hodnota:real):boolean;
              {Totez pro realna cisla.}
              function ZadejBoolean(jmeno:string; hodnota:boolean):boolean;
              {Totez pro logicke hodnoty (false se prevede na '0', true na '1').}
              procedure PrectiPolozku(Jmeno:string; var Hodnota:string);
              {Najde polozku s danym Jmenem a jeji hodnotu vrati pres parametr Hodnota.
              Pokud neni vybrana zadna sekce nebo v te vybrane tahle polozka neexistuje,
              promenna Hodnota zustane nezmenena.}
              procedure PrectiLongint(Jmeno:string; var Hodnota:longint);
              {Totez, ale hodnotu polozky rovnou prevede na cislo. Pokud polozka nebyla ve
              vybrane sekci nalezena nebo pokud to neni platne cislo, parametr Hodnota
              zustane beze zmeny.}
              procedure PrectiReal(Jmeno:string; var Hodnota:real);
              {Totez, ale pro realna cisla.}
              procedure PrectiByte(Jmeno:string; var Hodnota:byte);
              procedure PrectiWord(Jmeno:string; var Hodnota:word);
              procedure PrectiInteger(Jmeno:string; var Hodnota:integer);
              {Tyto metody funguji podobne jako Prectilongint, plus navic jeste hodnoty
              automaticky orezavaji podle rozsahu prislusneho typu (v konfiguraci zustanou
              nezmeneny, oriznou se jenom vystupy - napr. Prectibyte misto 1000 vrati 255,
              ale nasledny Prectiinteger uz da 1000).}
              procedure PrectiBoolean(Jmeno:string; var Hodnota:boolean);
              {Podobne, ale pro boolean. Jako true se bere cokoli, co zacina znakem A, Y,
              T nebo 1, jako false cokoli na N, F nebo 0 (bez ohledu na velikost pisma).
              Jine hodnoty se povazuji za neplatne a Hodnota pri nich zustane beze zmeny.}
              function Uloz(Soubor:string):boolean;
              {Ulozi konfiguraci do souboru (Soubor = jmeno i s koncovkou). Pokud soubor
              neexistuje, vytvori se novy. Pokud existuje, budou v nem existujici datove
              polozky v prislusnych sekcich nahrazeny novymi hodnotami a neexistujici
              polozky a sekce budou nove vytvoreny. Poradi existujicich sekci a polozek,
              vsechny komentare, prazdne radky a irelevantni polozky budou zachovany.
              Vraci true, pokud ukladani probehlo bez chyby.}
              procedure Nacti(Soubor,Sekce:string);
              {Nacte konfiguraci ze Souboru (opet jmeno i s koncovkou). Je mozne nacist
              jen urcite sekce (pak jejich nazvy vypiste do parametru Sekce, oddelujte je
              stredniky bez mezer) nebo cely soubor (v takovem pripade nechte parametr
              Sekce prazdny). Komentare se nenacitaji, aby se setrilo pameti.
              Zadne specialni hlaseni o chybach - proste co se nacte, to se nacte.
              Po nacteni je automaticky vybrana prvni nactena sekce.}
              procedure ZrusPolozku(Jmeno:string);
              {Odstrani z vybrane sekce polozku s danym Jmenem.}
              procedure ZrusSekci(jmeno:string);
              {Odstrani danou sekci vcetne obsahu. Rusi aktualni vyber sekce
              (tj. po skonceni teto metody nebude vybrana zadna).}
              procedure Zrus;
              {Dealokuje veskery obsah konfigurace.}
              end;
{Vsechny metody, ktere vraceji boolean, vraceji true pri uspechu a false
pri chybe.}


{*************************** verejne promenne: ******************************}

const cfgSoubor:string[12]='CONFIG.CFG'; {predpokladam, ze si sem program
           vlozi jmeno, ktere se k nemu bude dobre hodit. Kdyz potom vsechny
           jednotky budou nacitat nastaveni odtud, bude na vsechno stacit
           jeden soubor a nebude treba upravovat kazdou jednotku zvlast.}
      cfgCS:boolean=false; {Jestli se maji rozlisovat velka a mala pismena ve
           jmenech sekci a datovych polozek (true = ano). Vsechna data i nazvy
           se ale budou vzdy ukladat presne v tom tvaru, v jakem je zadate;
           v zadnem pripade nedojde k automatickemu prevodu na velka pismena
           nebo necemu podobnemu.}
      cfgOrezatNazvy:boolean=true; {True znamena, ze se ignoruji mezery na
           zacatku a konci nazvu sekci a polozek ctenych ze souboru (vhodne
           napr. pri rucnim odsazeni a zarovnavani do sloupcu). False znamena,
           ze se nazvy nactou presne tak, jak jsou v souboru napsany, vcetne
           mezer.}
      cfgOrezatHodnoty:boolean=false; {totez pro hodnoty datovych polozek}

{************************ dalsi verejne procedury: **************************}

function PodepisSeTu:boolean;
{Do hlavniho konfiguracniho souboru (konstanta Cfgsoubor, viz vyse) si
poznamena, ze uz jsme tento program na tomto pocitaci jednou spousteli.
Vraci true, pokud se ukladani zdarilo.}
function ByliJsmeTu:boolean;
{Zjisti, jestli nas program bezi na tomto pocitaci poprve (pak vraci false)
nebo jestli uz jsme tady nekdy byli a podepsali jsme se tu (pak vraci true).}

{****************************************************************************}

implementation
uses retezce;

procedure konfigurace.init;
Begin              {Globalni promenne vetsinou byvaji vynulovane implicitne, }
prvnisekce:=nil;   {ale proc na to spolehat? Lokalni naopak nejsou implicitne}
vybranasekce:=nil; {vynulovany nikdy, potom je tohle nutne.                  }
End;{konfigurace.init}

function konfigurace.PridejSekci(jmeno:string):boolean;
var p,nova:uknacfgsekci;
    velikost:word;
Begin
velikost:=length(jmeno)+10; {8 B na ukazatele, 1 B na promennou Vyrizeno, 1 B na nulty znak jmena a zbytek na to jmeno}
if velikost>maxavail
  then pridejsekci:=false {nevesla by se do pameti}
  else begin {OK, muzeme ji bez obav alokovat}
       getmem(nova,velikost);
       with nova^ do begin
                     dalsi:=nil; {pridava se na konec, takze za touhle sekci urcite nic nebude}
                     prvnipolozka:=nil; {zatim tu nic neni}
                     nazev:=jmeno;
                     end;
       {zapojeni do seznamu sekci:}
       if prvnisekce=nil then prvnisekce:=nova {bude prvni}
                         else begin {seznam neni prazdny, tak nejdriv najdeme konec...}
                              p:=prvnisekce;
                              while p^.dalsi<>nil do p:=p^.dalsi;
                              p^.dalsi:=nova; {...a za ten konec to vlozime}
                              end;
       pridejsekci:=true; {nahlasime uspech}
       vybranasekce:=nova; {automaticky vyber nove sekce}
       end;
End;{konfigurace.pridejsekci}

procedure konfigurace.VyberSekci(jmeno:string);
var ret:string;
Begin
{jestli se nema rozlisovat velikost pismen, musime si jmena prevest na jednu velikost:}
if not cfgcs then jmeno:=stringup(jmeno);
vybranasekce:=prvnisekce;
while vybranasekce<>nil do begin
                           ret:=vybranasekce^.nazev; {precteme nazev}
                           if not cfgcs then ret:=stringup(ret); {kdyz je to potreba, prevedeme na velka pismena}
                           if cfgorezatnazvy then ret:=strip(ret,'B',' '); {pripadne orizneme mezery}
                           if jmeno=ret then break; {kdyz jsme se trefili, koncime...}
                           vybranasekce:=vybranasekce^.dalsi; {...jinak prohledavame dal}
                           end;
End;{konfigurace.vybersekci}

function konfigurace.ZadejPolozku(jmeno,hodnota:string):boolean;
var p,nova:uknacfgpolozku;
    velikost:word;
Begin
zadejpolozku:=false;
if (vybranasekce<>nil)and(hodnota<>#0) then
  begin
  zruspolozku(jmeno); {jestli uz stejna polozka existuje, smazeme ji (jestli neexistuje, nic se nestane)}
  {jak velka bude nova polozka:}
  velikost:=byte(jmeno[0])+byte(hodnota[0])+7; {4B ukazatel, 1B Vyrizeno, 2B nulte znaky a zbytek jmeno a hodnota}
  if velikost>maxavail then exit; {staci nam pamet?}
  {vytvorime ji:}
  getmem(nova,velikost);
  with nova^ do begin
                dalsi:=nil; {bude na konci, takze za ni nic nebude}
                data:=jmeno; {jmeno na zacatek...}
                move(hodnota[0],data[byte(jmeno[0])+1],byte(hodnota[0])+1); {...a hodnotu za jmeno}
                end;
  {a vlozime na konec seznamu:}
  p:=vybranasekce^.prvnipolozka;
  if p=nil then vybranasekce^.prvnipolozka:=nova
           else begin
                while p^.dalsi<>nil do p:=p^.dalsi;
                p^.dalsi:=nova;
                end;
  zadejpolozku:=true;
  end;
End;{konfigurace.zadejpolozku}

function konfigurace.ZadejCislo(jmeno:string; hodnota:longint):boolean;
var r:string[11];
Begin
str(hodnota,r);
zadejcislo:=zadejpolozku(jmeno,r);
End;{konfigurace.zadejcislo}

function konfigurace.ZadejReal(jmeno:string; hodnota:real):boolean;
var r:string[11];
Begin
str(hodnota:0:4,r);
zadejreal:=zadejpolozku(jmeno,r);
End;{konfigurace.zadejreal}

function konfigurace.ZadejBoolean(jmeno:string; hodnota:boolean):boolean;
var r:string[1];
Begin
if hodnota then r:='1' else r:='0';
zadejboolean:=zadejpolozku(jmeno,r);
End;{konfigurace.zadejboolean}

procedure konfigurace.ZrusPolozku(jmeno:string);
var predchozi,p:uknacfgpolozku;
    velikost:word;
    _jmeno,ret:string;
Begin
if vybranasekce<>nil then
  begin
  {nalezeni polozky:}
  if cfgcs then _jmeno:=jmeno
           else _jmeno:=stringup(jmeno);
  p:=vybranasekce^.prvnipolozka;
  predchozi:=nil;
  while p<>nil do begin {dokud neprojdeme cely seznam}
                  ret:=p^.data; {precteme jmeno polozky}
                  if not cfgcs then ret:=stringup(ret);
                  if ret=_jmeno then break; {kdyz to je to hledane, koncime...}
                  predchozi:=p; {...jinak se pidalkovitym stylem...}
                  p:=p^.dalsi;  {...posuneme o polozku dal}
                  end;
  if p<>nil then begin {polozka se nasla (p), jdeme ji smazat}
                 {prepojeni ukazatelu:}
                 if predchozi=nil then vybranasekce^.prvnipolozka:=p^.dalsi
                                  else predchozi^.dalsi:=p^.dalsi;
                 {vypocet velikosti:}
                 with p^ do velikost:=byte(data[0])+byte(data[byte(data[0])+1])+7;
                          {co tim chtel basnik rici:
                            delka druheho retezce=byte(znak)
                            znak=data[index]
                            index=delka1+1
                            delka1=byte(data[0])
                           Dosadte si postupne od konce a nakonec vam vyjde vyse uvedeny humac :-).
                           Plus samozrejme delka prvniho retezce a 7 B na ostatni data v polozce.}
                 {a nakonec vlastni smazani:}
                 freemem(p,velikost);
                 end;
  end;
End;{konfigurace.zruspolozku}

procedure konfigurace.ZrusSekci(jmeno:string);
var velikost:word;
    up:uknacfgpolozku;
    predchozi:uknacfgsekci;
    ret:string;
Begin
{nalezeni sekce:
(je potreba zapamatovat si i tu predchozi, takze Vybersekci nestaci)}
if not cfgcs then jmeno:=stringup(jmeno);
vybranasekce:=prvnisekce;
predchozi:=nil;
while vybranasekce<>nil do begin
                           ret:=vybranasekce^.nazev;
                           if not cfgcs then ret:=stringup(ret);
                           if jmeno=ret then break;
                           predchozi:=vybranasekce; {opet styl "pidalka"}
                           vybranasekce:=vybranasekce^.dalsi;
                           end;
if vybranasekce<>nil then
  begin
  {smazani obsahu:}
  while vybranasekce^.prvnipolozka<>nil do
    begin
    up:=vybranasekce^.prvnipolozka;
    with up^ do velikost:=byte(data[0])+byte(data[byte(data[0])+1])+7;
    vybranasekce^.prvnipolozka:=up^.dalsi;
    freemem(up,velikost);
    end;
  {smazani sekce:}
  if predchozi=nil then prvnisekce:=vybranasekce^.dalsi
                   else predchozi^.dalsi:=vybranasekce^.dalsi;
  velikost:=byte(vybranasekce^.nazev[0])+10;
  freemem(vybranasekce,velikost);
  vybranasekce:=nil;
  end;
End;{konfigurace.zrussekci}

procedure konfigurace.PrectiPolozku(Jmeno:string; var Hodnota:string);
  {Pozn.: Hodnota by teoreticky mohla byt beztypovy Var parametr, aby se dala
   pohodlne pouzit na jakkoli dlouhy retezec. Jenze kdyby skutecna hodnota
   byla delsi nez prislusna promenna, pretekla by do nealokovane pameti a
   zpusobila by Neplatnou Aplikaci nebo neco podobneho. Proto je tu natvrdo
   plny 255znakovy string.}
var p:uknacfgpolozku;
    ret:string;
Begin
if vybranasekce<>nil then
  begin
  {nalezeni polozky:}
  if not cfgcs then jmeno:=stringup(jmeno);
  p:=vybranasekce^.prvnipolozka;
  while p<>nil do begin
                  ret:=p^.data;
                  if not cfgcs then ret:=stringup(ret);
                  if ret=jmeno then break;
                  p:=p^.dalsi;
                  end;
  {precteni jeji hodnoty:}
  if p<>nil then begin
                 with p^ do move(data[length(data)+1], {zdroj: hodnota od nulteho bytu dal}
                                 hodnota,                  {cil: vystupni retezec od nulteho bytu dal}
                                 byte(data[length(data)+1])+1); {delka: nulty byte hodnoty plus 1 (za ten nulty B)}
                 p^.vyrizeno:=true; {tohle je tu kvuli metode Uloz}
                 end;
  end;
End;{konfigurace.prectipolozku}

procedure konfigurace.PrectiLongint(Jmeno:string; var Hodnota:longint);
var vysledek:longint;
    kod:integer;
    nalezeno:string;
Begin
nalezeno:='';
prectipolozku(jmeno,nalezeno);
if nalezeno<>'' then begin
                     val(nalezeno,vysledek,kod);
                     if kod=0 then hodnota:=vysledek;
                     end;
End;{konfigurace.prectilongint}

procedure konfigurace.PrectiByte(Jmeno:string; var Hodnota:byte);
var vysledek:longint;
    kod:integer;
    nalezeno:string;
Begin
{Pres Prectilongint to bohuzel nejde, protoze se pres nej neda detekovat
neexistujici polozka (nebylo by poznat, jestli se dana longintova promenna
nezmenila kvuli chybe nebo jestli proste zrovna mela stejnou hodnotu, jakou
jsme do ni pred ctenim dali). Takze to musime rozepsat:}
nalezeno:='';
prectipolozku(jmeno,nalezeno);
if nalezeno<>'' then begin
                     val(nalezeno,vysledek,kod);
                     if kod=0 then begin
                                   if vysledek<0 then vysledek:=0
                                    else if vysledek>255 then vysledek:=255;
                                   hodnota:=vysledek;
                                   end;
                     end;
End;{konfigurace.prectibyte}

procedure konfigurace.PrectiWord(Jmeno:string; var Hodnota:word);
var vysledek:longint;
    kod:integer;
    nalezeno:string;
Begin
nalezeno:='';
prectipolozku(jmeno,nalezeno);
if nalezeno<>'' then begin
                     val(nalezeno,vysledek,kod);
                     if kod=0 then begin
                                   if vysledek<0 then vysledek:=0
                                    else if vysledek>$FFFF then vysledek:=$FFFF;
                                   hodnota:=vysledek;
                                   end;
                     end;
End;{konfigurace.prectiword}

procedure konfigurace.PrectiInteger(Jmeno:string; var Hodnota:integer);
var vysledek:longint;
    kod:integer;
    nalezeno:string;
Begin
nalezeno:='';
prectipolozku(jmeno,nalezeno);
if nalezeno<>'' then begin
                     val(nalezeno,vysledek,kod);
                     if kod=0 then begin
                                   if vysledek<-32768 then vysledek:=-32768
                                    else if vysledek>32767 then vysledek:=32767;
                                   hodnota:=vysledek;
                                   end;
                     end;
End;{konfigurace.prectiinteger}

procedure konfigurace.PrectiReal(Jmeno:string; var Hodnota:real);
var vysledek:real;
    kod:integer;
    nalezeno:string;
Begin
nalezeno:='';
prectipolozku(jmeno,nalezeno);
if nalezeno<>'' then begin
                     val(nalezeno,vysledek,kod);
                     if kod=0 then hodnota:=vysledek; {u realu orezavani nema moc velky smysl}
                     end;
End;{konfigurace.prectireal}

procedure konfigurace.PrectiBoolean(Jmeno:string; var Hodnota:boolean);
var vysledek:real;
    kod:integer;
    nalezeno:string;
Begin
nalezeno:='';
prectipolozku(jmeno,nalezeno);
if nalezeno<>''
  then if nalezeno[1] in ['n','N','f','F','0'] then hodnota:=false
        else if nalezeno[1] in ['a','A','y','Y','t','T','1'] then hodnota:=true;
End;{konfigurace.prectiboolean}

function konfigurace.Uloz(soubor:string):boolean;
var puvodni,novy:text; {z puvodniho cteme a do noveho zapisujeme; nakonec puvodni smazeme a novy prejmenujeme na puvodni}
    us,puvodnivybrana:uknacfgsekci;
    up:uknacfgpolozku;
    radek,jmeno,hodnota:string;
    predel:byte; {pozice rovnitka v radku}
{}procedure DojedSekci; {zapise do noveho souboru zbytek aktualne vybrane sekce a oznaci tuto sekci za vyrizenou}
{}Begin
{}up:=vybranasekce^.prvnipolozka;
{}while up<>nil do
{} begin
{} if not up^.vyrizeno then begin {zapiseme tuto polozku do souboru}
{}                          with up^ do move(data[length(data)+1],hodnota[0],byte(data[length(data)+1])+1);
{}                          writeln(novy,up^.data+'='+hodnota);
{}                          up^.vyrizeno:=true;
{}                          end;
{} up:=up^.dalsi;
{} end;
{}vybranasekce^.vyrizeno:=true;
{}End;{dojedsekci}
Begin
if prvnisekce=nil then begin uloz:=true; exit; end; {neni co ukladat}
uloz:=false;
assign(puvodni,soubor);
assign(novy,'smazat.$$$'); {docasny soubor, ktery pak prejmenujeme nebo smazeme}
rewrite(novy);
if ioresult<>0 then exit; {nepovedlo se otevrit soubor pro zapis}
{inicializace pomocnych promennych v konfiguraci:}
us:=prvnisekce;
while us<>nil do begin
                 us^.vyrizeno:=false; {zapamatujeme si, ze tuhle sekci jsme jeste neukladali}
                 {to same pro vsechny polozky v teto sekci:}
                 up:=us^.prvnipolozka;
                 while up<>nil do begin
                                  up^.vyrizeno:=false;
                                  up:=up^.dalsi;
                                  end;
                 us:=us^.dalsi;
                 end;
puvodnivybrana:=vybranasekce; {zaloha pro pozdejsi obnoveni}
vybranasekce:=nil; {dulezite!}
reset(puvodni);
if ioresult=0 then
 begin {puvodni soubor existuje, budeme ho postupne cist a doplnovat}
 while not eof(puvodni) do
  begin
  readln(puvodni,radek);
  if (radek<>'')and(radek[1]<>';') then {neni to komentar}
   begin
   predel:=pos('=',radek);
   if predel=0 then begin {je to sekce}
                    if vybranasekce<>nil then dojedsekci; {nejdriv zkontrolujeme a pripadne zapiseme zbytky z minula}
                    if cfgorezatnazvy then jmeno:=strip(radek,'b',' ')
                                      else jmeno:=radek;
                    vybersekci(jmeno);
                    {jestli vyjde nil, znamena to, ze se ta sekce
                    nachazi pouze v souboru, ale ne v konfiguraci =>
                    => nadpis i nasledujici polozky opiseme beze zmeny}
                    end
               else if vybranasekce<>nil then
                     begin {je to datova polozka}
                     jmeno:=left(radek,predel-1); {to pred rovnitkem}
                     if cfgorezatnazvy then jmeno:=strip(jmeno,'b',' ');
                     hodnota:=#13#10; {znak konce radku}
                     prectipolozku(jmeno,hodnota); {mame tu neco stejneho? (metoda Prectipolozku oznaci polozku za vyrizenou)}
                     if hodnota<>#13#10 {jestli tu tohle zustalo, tak nemame (Readln konce radku nenacita)}
                       then radek:=jmeno+'='+hodnota; {mame}
                     end;
   end;
  writeln(novy,radek);
  end;
 close(puvodni);
 if ioresult=0 then erase(puvodni);
 end;
{doplnime zbytek, ktery v puvodnim souboru nebyl (nebo uplne vsechno, pokud
zadny puvodni soubor neexistoval):}
if vybranasekce<>nil then dojedsekci;
vybranasekce:=prvnisekce;
while vybranasekce<>nil do
 begin
 if not vybranasekce^.vyrizeno then begin
                                    writeln(novy); {vynechani radku mezi sekcemi (pro prehlednost)}
                                    writeln(novy,vybranasekce^.nazev);
                                    dojedsekci;
                                    end;
 vybranasekce:=vybranasekce^.dalsi;
 end;
close(novy);
rename(novy,soubor); {prejmenujeme novy na puvodni}
vybranasekce:=puvodnivybrana; {obnoveni ze zalohy}
uloz:=ioresult=0;
End;{konfigurace.uloz}

procedure konfigurace.Nacti(Soubor,Sekce:string);
var t:text;
    radek,jmeno,hodnota:string;
    predel,index1,index2:byte;
    MuzemeNacitat:boolean; {jestli se prave nachazime v platne sekci}
Begin
self.zrus;
assign(t,soubor);
reset(t);
if ioresult=0 then
 begin
 if not cfgcs then sekce:=stringup(sekce);
 muzemenacitat:=false;
 while not eof(t) do
  begin
  readln(t,radek);
  if ioresult<>0 then break;
  if (radek<>'')and(radek[1]<>';') then {kdyz to neni komentar}
   begin
   predel:=pos('=',radek);
   if predel=0
     then begin {je to nadpis sekce}
          if sekce='' then muzemenacitat:=true {nacitame vsechno}
                      else begin
                           if cfgcs then jmeno:=radek
                                    else jmeno:=stringup(radek);
                           {je toto jmeno v seznamu sekci k nacteni?:}
                           index1:=pos(jmeno,sekce);
                           muzemenacitat:=false; {zatim nevime}
                           if (index1<>0)and((index1=1)or(sekce[index1-1]=';')) then
                           {kdyz se jmeno v seznamu naslo a zacina bud hned na zacatku
                           seznamu nebo je pred nim strednik (tj. neni to prostredek
                           nejakeho jineho jmena):}
                            begin
                            index2:=index1+byte(jmeno[0]);{index2 ukazuje za konec jmena}
                            muzemenacitat:=(index2>byte(sekce[0]))or(sekce[index2]=';');
                            {ano, pokud bud poslednim znakem jmena seznam konci
                            nebo pokud je za nim strednik (proste kdyz uz jmeno
                            nepokracuje dal)}
                            end;
                           end;
          {vytvorime sekci:}
          if muzemenacitat and not pridejsekci(radek) then break;
          end
     else if muzemenacitat then begin {je to datova polozka}
                                jmeno:=copy(radek,1,predel-1);
                                if cfgorezatnazvy then jmeno:=strip(jmeno,'B',' ');
                                hodnota:=copy(radek,predel+1,byte(radek[0])-predel);
                                if cfgorezathodnoty then hodnota:=strip(hodnota,'B',' ');
                                if not zadejpolozku(jmeno,hodnota) then break;
                                end;
   end
  end;
 vybranasekce:=prvnisekce; {automaticky vyber prvni nactene sekce}
 close(t);
 predel:=ioresult; {bezpecnostni reset pro pripad, ze by pri zavirani souboru doslo k chybe}
 end;
End;{konfigurace.nacti}

procedure konfigurace.Zrus;
var us:uknacfgsekci;
    up:uknacfgpolozku;
    velikost:word;
Begin
while prvnisekce<>nil do
 begin
 {vymazani vsech polozek v sekci:}
 with prvnisekce^ do
  begin
  while prvnipolozka<>nil do
   begin
   up:=prvnipolozka;
   with up^ do velikost:=byte(data[0])+byte(data[byte(data[0])+1])+7;
   prvnipolozka:=prvnipolozka^.dalsi;
   freemem(up,velikost);
   end;
  end;
 {vymazani sekce:}
 us:=prvnisekce;
 prvnisekce:=prvnisekce^.dalsi;
 freemem(us,byte(us^.nazev[0])+10);
 end;
vybranasekce:=nil;
End;{konfigurace.zrus}


(****************************************************************************)

{nazvy kontrolovanych polozek:}
const podpisovasekce:string[11]='[prostredi]'; {nadpis sekce}
      verzevesa:string[10]='Verze VESA'; {tohle se sice stroj od stroje moc nemeni, ale proc to nepouzit}
      grafarna:string[14]='Graficka karta'; {jmeno grafarny (OEM ID)}
      biosdate:string[18]='Datum vyroby BIOSu';
      equipment:string[8]='Hardware'; {bitove pole obsahujici informace o existenci harddisku,
                                       poctu disketovych mechanik, portu, tiskaren a podobne}

procedure OkoukniProstredi(var KamSTim:konfigurace);
{Nacte nejake informace o pocitaci, na kterem zrovna program bezi.
Promenna Kamstim musi byt inicializovana!}
type pch=array[0..0] of char;
     tVESAInfo = record
                 Signatura:array[0..3] of char;
                 Verze:word;
                 JmenoKarty:^pch; {ukazatel na jmeno karty (retezec zakonceny znakem #0)}
                 zbytek:array[1..502] of byte;
                 end;
var VESAinfo:^tVESAInfo;
    vysledek:word;
    b:byte;
    r1,r2:string;
Begin
if not kamstim.pridejsekci(podpisovasekce) then exit;
if maxavail<sizeof(tvesainfo) then vysledek:=$FFFF {nestaci pamet}
                              else begin {OK, pamet staci}
                                   new(vesainfo);
                                   asm
                                   mov AX,$4F00     {kod sluzby "zjisti informace o rozhrani VESA"}
                                   les DI,vesainfo  {adresa navratoveho zasobniku}
                                   int $10          {a makej...}
                                   mov vysledek,AX  {jak jsme dopadli?}
                                   end;
                                   end;
if vysledek=$4F then with vesainfo^ do begin {OK, informace jsou nacteny}
                                       r1:=nastr(hi(verze))+'.'+nastr(lo(verze));
                                       b:=0;
                                       {prevod nulou ukonceneho retezce na string:}
                                       while (b<246)and(jmenokarty^[b]<>#0) do inc(b);
                                       byte(r2[0]):=b;
                                       move(jmenokarty^[0],r2[1],b);
                                       end
                else begin {informace se nenacetly (coz je v podstate taky informace :-) )}
                     r1:='neznama';
                     r2:=r1;
                     end;
if vysledek<>$FFFF then dispose(vesainfo); {jestli jsme zasobnik alokovali, zase ho uvolnime}
if not (kamstim.zadejpolozku(verzevesa,r1) and kamstim.zadejpolozku(grafarna,r2)) then exit;
r1[0]:=#8; {delku retezce nastavime natvrdo na 8 znaku}
for b:=1 to 8 do r1[b]:=chr(mem[$F000:$FFF4+b]); {By Pedro Eisman, CRAMP / Dark Ritual, 1996}
if not (kamstim.zadejpolozku(biosdate,r1)
  and kamstim.zadejpolozku(equipment,nastr(memw[0:$0410]))) then {ted uz je exit zbytecny};
End;{okoukniprostredi}

function ByliJsmeTu:boolean;
var ulozena,aktualni:konfigurace;
    s1,s2:string;
    ano:boolean;
Begin
ulozena.init; aktualni.init; {nutna inicializace internich ukazatelu}
{podivame se na aktualni stav systemu:}
okoukniprostredi(aktualni);
{nacteme stav, ktery jsme si minule poznamenali:}
ulozena.nacti(cfgsoubor,podpisovasekce);
{a oba stavy porovname:}
ulozena.prectipolozku(verzevesa,s1);
aktualni.prectipolozku(verzevesa,s2);
ano:=s1=s2;
ulozena.prectipolozku(grafarna,s1);
aktualni.prectipolozku(grafarna,s2);
if s1<>s2 then ano:=false;
ulozena.prectipolozku(biosdate,s1);
aktualni.prectipolozku(biosdate,s2);
if s1<>s2 then ano:=false;
ulozena.prectipolozku(equipment,s1);
aktualni.prectipolozku(equipment,s2);
if s1<>s2 then ano:=false;
bylijsmetu:=ano;
{jestli je vsechno stejne, znamena to, ze tu nejsme poprve}
ulozena.zrus; aktualni.zrus; {uvolneni zabrane pameti}
End;{bylijsmetu}

function PodepisSeTu:boolean;
var k:konfigurace;
Begin
k.init;
okoukniprostredi(k);
podepissetu:=k.uloz(cfgsoubor);
k.zrus;
End;{podepissetu}

END.

{Format souboru *.CFG:

Konfiguracni soubory jsou obycejne textaky a daji se upravovat i rucne.
Radky zacinajici strednikem (';') se berou jako komentare (strednik musi byt
prvnim znakem na radku a nesmi mu predchazet zadne mezery ani tabulatory).
Pro zlepseni prehlednosti je mozne vynechavat radky, prazdny radek se bere
taky jako komentar.
Radky, ve kterych se vyskytuje rovnitko ('=') se berou jako datove polozky.
Text vlevo od rovnitka znamena nazev polozky, text vpravo az do konce radku
hodnotu. Hodnota a/nebo nazev mohou byt i prazdne.
Vsechny ostatni neprazdne radky, ktere neobsahuji '=' a ani nezacinaji
strednikem, se berou jako nazvy sekci. Neni nutne, aby se psaly uzavrene do
hranatych zavorek, ale zlepsi to prehlednost a kompatibilitu s jinymi
cteckami, ktere to mohou vyzadovat. Pozor: datove polozky, kterym nepredchazi
zadny nadpis sekce, nebudou nacteny!
Nazvy sekci, nazvy datovych polozek a jejich hodnoty se mohou skladat z
jakychkoli znaku vcetne mezer (v takovych pripadech neni potreba psat je do
uvozovek nebo neceho podobneho).
Z kazdeho radku se nacte pouze prvnich 255 znaku, proto radky obsahujici data
nikdy nedelejte delsi (u komentaru to nevadi, ty se stejne nenacitaji).


Priklad:
(zacatek souboru)

;Konfigurace pro hru Tetris

[hra]
HiScore      =3098
Jmeno hrace  =Raketovej Pepa
NejlepsiHrac =
MaxLevel     =15

[zvuk]
;tohle si nastavte rucne (ano nebo ne):
zapnout=ano

[grafika]
BPP=8
Obnovovaci frekvence=75 Hz

(konec souboru)
}
