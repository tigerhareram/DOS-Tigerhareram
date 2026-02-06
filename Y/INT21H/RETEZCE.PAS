(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: RETEZCE.PAS                                                    *)
(*  Obsah: procedury a funkce pro operace s retezci                        *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 25.5.2014                                             *)
(*  Pro kompilaci: nic                                                     *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Retezce;
{$B-}
interface

function KolikCeho(Kolik:byte; Ceho:char):string;
{Vrati retezec tvoreny opakovanim jednoho znaku.
 Kolik - delka retezce, Ceho - znak, kterym se ma retezec vyplnit}
function Zarovnej(Co:string; NaKolik:word; Jak:byte; Cim:char):string;
{Vraci dany retezec upraveny na danou delku. Parametry:
 Co - retezec, ktery se ma upravit
 NaKolik - pozadovana delka vysledneho retezce
 Jak - zpusob zarovnani. Mozne hodnoty:                                       }
       const _Doleva=0; _NaStred=1; _Doprava=2;                               {
       Kdyz je retezec kratsi, prodlouzi se. Kdyz je delsi, nic se s nim
       nedela. Pokud ale k Jak prictete konstantu:} _Orezat=4; {,
       bude zkracen.
 Cim - pokud se bude retezec prodluzovat, doplni se temito znaky.}
function NaStr(a:longint):string;
{prevede parametr na retezec}
function NaStr2(a:longint; NaKolik:byte):string;
{To same, ale zadava se i pozadovana delka retezce (max. 80 znaku). Zarovnava
se doprava vkladanim mezer na levy konec.}
function NaStr3(a:longint; NaKolik:byte):string;
{Podobne, ale zarovnava vkladanim nul.}
function NaStrR(a:real; DesMista:byte):string;
{pro realna cisla; zadava se pocet desetinnych mist, sirka zustava vychozi
(nejmensi mozna)}
function LowCase(znak:char):char;
{prevede dane pismeno na male (opak Upcase)}
function StringUp(S:string):string;
{vraci retezec S prevedeny na velka pismena (diakritiku neprevadi)}
function StringDown(S:string):string;
{vraci retezec S prevedeny na mala pismena (diakritiku neprevadi)}
function ValF(Retezec:string; Default:longint):longint;
{Prevede cislo zadane v textu Retezec na ciselnou hodnotu. Pokud se to
nepovede (chyba v zapisu cisla atd.), vrati se hodnota Default.}
function ValFR(retezec:string; default:real):real;
{podobna, ale pro realna cisla}
function Prekoduj(Retezec,PuvodniKodovani,NoveKodovani:string):string;
{Projde dany Retezec a vsechny znaky, ktere najde i v retezci PuvodniKodovani,
nahradi znaky z retezce NoveKodovani na stejne pozici. Puvodne urcena pro
prevody ceske diakritiky mezi ruznymi kodovacimi standardy, odtud nazev a
nasledujici konstanty:}
const kBezDiakritiky='RISZTCYUNUEDAEOrisztcyunuedaeo';{Nepouzivat jako zdrojove!!!}
      kLatin2='üÖæ¦›¬íÞÕé·Òµàý¡ç§œŸì…å£ØÔ ‚¢';{jinak take IBM 852, obvykle standardni znakova sada ceskych verzi DOSu}
      kKamenici='ž‹›’†€¦¥—‰…•©¡¨‘Ÿ‡˜–¤£ˆƒ ‚¢';{kodovani bratru Kamenickych, pouzivaji ho nektere ceske dosovske programy}
      kWindows1250='ØÍŠŽÈÝÙÒÚÌÏÁÉÓøíšžèýùòúìïáéó';{vychozi znakova sada Windows}
      kISO8859_1='RÍSZTCÝUNÚEDÁÉÓrísztcýunúedáéó';{Nepouzivat jako zdrojove!!! (neobsahuje vsechny znaky)}
      kISO8859_2='ØÍ©®«ÈÝÙÒÚÌÏÁÉÓøí¹¾»èýùòúìïáéó';{standardni kodovani pro e-maily a internet vubec}

type pole256znaku=array[#0..#255] of char; {pomocny typ pro ukladani prevodnich tabulek}
procedure PripravPrevodniTabulku(PuvodniZnaky,NoveZnaky:string; var PrevodniTabulka:pole256znaku);
{Vyrobi prevodni tabulku pro dve nasledujici funkce.
Prvni dva parametry maji stejny vyznam jako u funkce Prekoduj a daji se
pouzit vyse uvedene konstanty.}
function PrekodujRetezec(ktery:string; var PrevodniTabulka:pole256znaku):string;
{Stejny efekt jako Prekoduj, ale mnohem rychlejsi.}
function PrekodujSoubor(JmenoVstupu,JmenoVystupu:string; var PrevodniTabulka:pole256znaku):boolean;
{Tahle prekoduje cely soubor. Prvni dva parametry jsou cela jmena vstupniho
a vystupniho souboru, treti je jasny. Funkce vraci pri uspechu true a pri
neuspechu (I/O chyba) false.}

function NajdiKonecRadku(Retezec:string; Zacatek,MaxDelka:byte):byte;
{Vrati index posledniho znaku z useku Retezce, ktery zacina indexem Zacatek
a jeho delka nepresahuje hodnotu MaxDelka. Pokud by nejake slovo (tj. usek
ohraniceny mezerami) precuhovalo za Maxdelku, skonci "radek" uz pred nim.
Prilis dlouha slova (delsi nez Maxdelka) budou rozdelena. Pokud zadate Zacatek
vetsi nez je delka retezce nebo je retezec prazdny, vrati se nula.}
function xChr(cislo:word):char;
{Pro cisla 0..255 funguje jako standardni Chr, pro cisla >255 vraci #0.}
function ZkratRetezec(Ktery:string; NaKolik,VlevoNechat,VpravoNechat:byte):string;
{Zkrati retezec na dany pocet znaku tim zpusobem, ze v nem urcity usek nahradi
tremi teckami. Posledni dva parametry urcuji, kolik znaku z puvodniho retezce
ma na jeho zacatku a konci zarucene zustat.}
function Left(Retezec:string; Kolik:byte):string;
{Vrati Kolik znaku z leveho konce Retezce.}
function Right(Retezec:string; Kolik:byte):string;
{Podobna, ale vraci znaky z praveho konce.
Funkce Left a Right nevolaji Copy a pouzivaji 32bitove kopirovani, takze jsou
docela rychle.}
function Strip(Retezec:string; Kde,Co:char):string;
{Orizne ze zacatku a/nebo z konce Retezce urcity znak.
 Kde - jestli se ma orezavat zleva ('L' nebo 'Z'), zprava ('P', 'R' nebo 'T')
       nebo z obou koncu ('O' nebo 'B'). Na velikosti pismene nezalezi.
       Jde o zkratky prislusnych ceskych (Levy/Zacatek, Pravy/Konec, Oba) a
       anglickych (Left/Leading, Right/Trailing, Both) terminu.
 Co - znak, ktery se ma uriznout.
Priklad: Strip('** *xxx*z*','B','*') = ' *xxx*z' }
function PocetSlov(Retezec,Oddelovac:string):byte;
{Vraci pocet "slov" v Retezci, neboli pocet useku oddelenych danym
Oddelovacem. Pocita podle vzorce pocet_slov=pocet_oddelovacu+1, slovem se
rozumi i prazdny retezec (napr. pocetslov('-x-','-') = 3).}
function DejSlovo(Retezec,Oddelovac:string; Kolikate:byte):string;
{Vraci xte slovo od zacatku retezce, poradi pocita stejne jako predchozi
funkce (od 1). Vracene slovo neobsahuje oddelovace.}

(*************** nacitani a uchovavani viceradkovych textu: *****************)

type
UkNaRadek = ^tRadek; {tenhle typ pouzivejte k vytvareni promennych}
tRadek = record {tohle je jenom sablona pro spojovy seznam}
         dalsi:UkNaRadek;
         obsah:string;
         end;
{Jestli se v tom hodlate vrtat, urcite neprohodte poradi polozek - Obsah musi
byt posledni. Pro radek se totiz alokuje jen tolik pameti, kolik je zrovna
podle jeho delky potreba, tudiz neni predem dano, kde presne retezec konci
a k cemukoli za nim by neslo normalne (pres tecku) pristupovat.}

procedure NactiTexty(var Kam:uknaradek; Odkud:string; Sirka:byte);
{Za ukazatelem Kam vytvori spojovy seznam radku, ktere nacte z retezce Odkud.
Sirka je pozadovana maximalni sirka radku (ve znacich). Ke kazdemu radku se
vzdycky pridavaji slova tak dlouho, dokud tuto delku neprekroci (pozor,
narozdil od funkce NajdiKonecRadku ji tedy prekrocit muze, ale maximalne o
delku jednoho slova. Zadne slovo nebude rozdeleno). Pokud potrebujete
odradkovat rucne, dela se to znakem '|'.
Pokud na cely text nevystaci pamet, ulozi se proste jen tolik radku, na kolik
stacila - zadne chybove hlaseni, zadne padani programu.
Pro pridavani dalsich radku do jiz hotoveho seznamu se procedura pouzije uplne
stejne (Kam je potom ukazatel na libovolny radek jiz hotoveho seznamu).
 POZOR: pri vytvareni NOVEHO seznamu musi byt ukazatel, ktery predavate v
parametru Kam, bezpodminecne nutne nastaven na NIL, jinak si procedura bude
myslet, ze tam uz nejaky seznam je, pokusi se najit jeho konec (ktery tam
neni), zacne zapisovat do nealokovane pameti a skonci to Nepovolenou Aplikaci!}
function NejdelsiRadek(Ceho:uknaradek):byte;
{Vraci delku nejdelsiho radku v danem seznamu. Pro prazdny seznam vraci 0.}
function PocetRadkuVSeznamu(VeKterem:uknaradek):word;
{vraci pocet radku v danem seznamu}
procedure ZrusTexty(var Ktere:uknaradek);
{zrusi seznam radku, na ktery ukazuje ukazatel Ktere (ten pak bude nil)}

{...$define superstringy}
{$ifdef superstringy}
(********************** retezce s neomezenou delkou: ************************)
{O co jde: retezec je tvoren spojovym seznamem kratsich podretezcu (clanku),
takze jeho delka neni omezena ani 255 znaky jako u obycejneho stringu, ani
64 KB jako u retezce ukonceneho znakem #0 (pchar), ale jen velikosti zakladni
pameti (teoreticky 640 KB).
Jde vicemene o experiment bez praktickeho vyuziti, pro bezne ucely 64 KB
bohate staci. V pripade potreby staci odkomentovat (umazat ty tri tecky
z $define).}

const ssGranularita=32;{Velikost jednoho clanku superstringu v B. Mel by to
                        byt nasobek 16, aby se zbytecne neplytvalo pameti.}
      ssDelka=ssgranularita-5;{pocet znaku v jednom clanku}

type UkNaKSS = ^kousekss;        {pomocne typy}
     kousekSS = record
                dalsi:uknakss;
                obsah:string[ssdelka];
                end;

Superstring = record {tohle je typ pro vytvareni uzivatelskych promennych}
              delka:longint;{celkovy pocet znaku v celem superstringu dohromady}
              zacatek:uknakss;{ukazatel na prvni clanek}
              fragmentovany:boolean;{true, pokud je delka nekterych clanku (krome posledniho) kratsi nez maximalni
                                     a tudiz v retezci existuji nevyuzite diry}
              end;

procedure ssInit(var Ktery:superstring);
{Inicializuje dany retezec (vynuluje interni promenne). Je nutne to pred
prvnim pouzitim provest!!! (kdyby ukazatel Zacatek nebyl nil, braly by ho
procedury jako zacatek existujiciho retezce a byly by z toho problemy)}
procedure ssVymaz(var Ktery:superstring);
{Vymaze obsah daneho retezce, po provedeni je pripraven k dalsimu pouziti.}
procedure ssPripoj(var KeKteremu,Ktery:superstring);
{Pripoji retezec Ktery na konec retezce KeKteremu a retezec Ktery vymaze.}
procedure ssKopiruj(var Kam,Ktery:superstring);
{retezcem Ktery nahradi obsah retezce Kam, retezec Ktery zustane zachovan}
procedure ssZadej(var Kam:superstring; Co:string);
{Prakticky kam:=co.}
function ssCopy(var Zdroj:superstring; Index:longint; Pocet:byte):string;
{Vrati usek retezce Zdroj dlouhy Pocet znaku a zacinajici na Indextem znaku.}
procedure ssInsert(Co:string; var Kam:superstring; Pozice:longint);
{Do retezce Kam pred znak s indexem Pozice vlozi podretezec Co. Pokud je
Pozice vetsi nez delka retezce Kam, pripoji se Co na jeho konec. Procedura je
vypiplana tak, aby vytvarela co nejmene novych clanku a der, takze je vhodna
treba i pro textove editory, kde se pridava obvykle po jednom znaku.}
procedure ssDelete(var Odkud:superstring; Index,Pocet:longint);
{Z retezce Odkud vymaze usek o delce Pocet znaku pocinaje Indextym. Pokud je
Index mimo rozsah delky retezce Odkud, neprovede se nic.}
procedure ssDefrag(var Ktery:superstring);
{Defragmentuje dany retezec, tj. odstrani vsechny pripadne diry na koncich
jednotlivych clanku a tim uvolni pamet, kterou tyto diry zabiraly.}
procedure ssReadLn(var Odkud:text; var Kam:superstring);
{Z textoveho souboru Odkud (otevreneho pro cteni) nacte jeden radek a ulozi ho
do superstringu Kam. Pokud v Kam neco bylo, bude to napred vymazano.}
procedure ssWriteLn(var Kam:text; var Co:superstring);
{Zapise do textoveho souboru Kam (otevreneho pro zapis) superstring Co a
ukonci radek.}
procedure ssPrekoduj(var Retezec:superstring; PuvodniKodovani,NoveKodovani:string);
{prekoduje ceskou diakritiku v Retezci, viz vyse uvedenou funkci Prekoduj}
function ssNajdiKonecRadku(retezec:superstring; Zacatek:longint; MaxDelka:word):longint;
{Dela zhruba totez, co funkce NajdiKonecRadku (viz vyse), ale pouziva starsi
algoritmus, ktery ma trochu problemy s vicenasobnymi mezerami, takze obcas
radek ukonci driv nez by bylo nutne. Jestli chcete, opravte si to (novy
algoritmus je mimo jine i jednodussi), ja uz na to kaslu :-).}

{$endif}

implementation
uses nfsup;

function kolikceho(kolik:byte;ceho:char):string;
var s:string;
Begin
s[0]:=char(kolik);{nastaveni delky}
fillchar32(s[1],kolik,byte(ceho));{vyplneni obsahu}
kolikceho:=s;{vraceni vysledku}
End;{kolikceho}

function zarovnej(co:string;nakolik:word;jak:byte;cim:char):string;
var orezb:boolean;
Begin
orezb:=jak>=4;{ma se orezavat?}
jak:=jak and 3;{vynulovani "orezavaciho" bitu, aby se na nej nemusel brat ohled pri Case}
if length(co)<nakolik {retezec je kratsi, bude se prodluzovat}
 then case jak of _doleva:co:=co+kolikceho(nakolik-length(co),cim);{prodlouzime konec retezce}
                  _nastred:begin
                           co:=kolikceho((nakolik-length(co)) shr 1,cim)+co;{nejdriv prodlouzit konec o pulku rozdilu...}
                           co:=co+kolikceho((nakolik-length(co)),cim);{...potom zacatek o zbytek}
                           end;
                  _doprava:co:=kolikceho(nakolik-length(co),cim)+co;{prodlouzime zacatek retezce}
                  end
 else if (length(co)>nakolik) and orezb{retezec je delsi, zkrati se}
             then case jak of _doleva:dec(co[0],length(co)-nakolik);{uriznuti konce = proste zmenseni delky}
                              _nastred:begin
                                       delete(co,1,(length(co)-nakolik)shr 1);{nejdriv uriznuti zacatku o pul rozdilu...}
                                       dec(co[0],length(co)-nakolik);{...pak uriznuti konce o zbytek}
                                       end;
                              _doprava:delete(co,1,length(co)-nakolik);{uriznuti znaku ze zacatku}
                              end;
zarovnej:=co;
End;{zarovnej}

function nastr(a:longint):string;
var vysl:string[11];{nejdelsi mozny longint}
Begin
str(a,vysl);
nastr:=vysl;
End;{nastr}

function nastr2(a:longint;nakolik:byte):string;
var vysl:string[80];
Begin
str(a:nakolik,vysl);
nastr2:=vysl;
End;{nastr2}

function NaStr3(a:longint;NaKolik:byte):string;
var vysl:string[80];
Begin
str(a,vysl);
while length(vysl)<nakolik do vysl:='0'+vysl;
nastr3:=vysl;
End;{nastr3}

function NaStrR(a:real;DesMista:byte):string;
var vysl:string[80];
Begin
str(a:0:desmista,vysl);
nastrr:=vysl;
End;{nastrr}

function LowCase(znak:char):char;
Begin
if (znak>='A')and(znak<='Z') then lowcase:=char(byte(znak)+32)
                             else lowcase:=znak;
End;{lowcase}

function stringup(s:string):string;         {by Ist¢k Attila}
var i:byte;
Begin
for i:=1 to length(s) do
 if s[i] in ['a'..'z'] then s[i]:=char(byte(s[i])-32);
stringup:=s;
End;{stringup}

function stringdown(s:string):string;       {by Ist¢k Attila}
var i:byte;
Begin
for i:=1 to length(s) do
 if s[i] in ['A'..'Z'] then s[i]:=char(byte(s[i])+32);
stringdown:=s;
End;{stringdown}

procedure NactiTexty(var kam:uknaradek; odkud:string; sirka:byte);
var pozice:word;{index pro pohyb v retezci Odkud. Word proto, aby nepretekl pri dojeti za konec retezce (>255)}
    radek:string;{pomocny retezec}
    KonecRadku:boolean;{nastavi se na true, pokud se dojelo na konec radku nebo celeho retezce}
    vybrany:uknaradek;{pro pohyb ve spojovem seznamu}
    velikost:word;{velikost prave alokovaneho radku v B}
{}function slovo:string;
{}{vraci slovo prectene ze vstupniho retezce vcetne pripadne mezery za nim, ale bez znaku pro konec radku}
{}var pom:string;
{}    znak:char;
{}Begin
{}pom:='';
{} repeat
{} znak:=odkud[pozice];
{} if znak='|' then konecradku:=true
{}             else pom:=pom+znak;
{} inc(pozice);
{} until (znak=' ')or(znak='|')or(pozice>length(odkud));
{}if pozice>length(odkud) then konecradku:=true;
{}slovo:=pom;
{}End;{slovo}
Begin{nactitexty}
if odkud='' then exit;
if kam=nil then vybrany:=nil {seznam zatim neexistuje}
           else begin {seznam jiz existuje => najdeme konec}
                vybrany:=kam;
                while vybrany^.dalsi<>nil do vybrany:=vybrany^.dalsi;
                end;                   {ted Vybrany ukazuje na posledni radek}
pozice:=1;
 repeat {pro kazdy radek}
 radek:=''; konecradku:=false;
 {nacteni radku:}
  repeat
  radek:=radek+slovo;
  until konecradku or(length(radek)>=sirka);
 {uriznuti pripadne mezery z konce radku:}
 if radek[length(radek)]=' ' then dec(radek[0]);
 {potrebne mnozstvi pameti pro ulozeni radku do pameti:}
 velikost:=length(radek)+5;{= delka radku ve znacich (ruzna) + jeho nulty znak (1B) + ukazatel (4B)}
 if velikost>maxavail then exit;{jestli pamet nestaci, tak uz dal ukladat nebudeme}
 {alokace pameti pro radek (trochu netradicne s Getmem misto New):}
 if vybrany=nil then begin{seznam je zatim prazdny}
                     getmem(kam,velikost);{vytvorime prvni radek}
                     vybrany:=kam;{a nasmerujeme na nej pracovni ukazatel}
                     end
                else begin{v seznamu uz neco je}
                     getmem(vybrany^.dalsi,velikost);{vytvorime novy radek za poslednim}
                     vybrany:=vybrany^.dalsi;{a nastavime na nej ukazatel}
                     end;
 vybrany^.dalsi:=nil;{aby bylo jasne, ze to je posledni radek}
 move32(radek[0],vybrany^.obsah[0],length(radek)+1);{prekopirovani radku (celeho, od nulteho znaku)}
 until pozice>length(odkud);{a to vsechno opakujeme, dokud nejsme na konci vstupniho retezce}
End;{nactitexty}

function NejdelsiRadek(Ceho:uknaradek):byte;
var vybrany:uknaradek;
    max:byte;
Begin
vybrany:=ceho; max:=0;
while vybrany<>nil do
  begin
  if length(vybrany^.obsah)>max then max:=length(vybrany^.obsah);
  vybrany:=vybrany^.dalsi;
  end;
nejdelsiradek:=max;
End;{nejdelsiradek}

function PocetRadkuVSeznamu(VeKterem:uknaradek):word;
var vybrany:uknaradek;
    pocet:word;
Begin
vybrany:=vekterem; pocet:=0;
while vybrany<>nil do begin
                      vybrany:=vybrany^.dalsi;
                      inc(pocet);
                      end;
pocetradkuvseznamu:=pocet;
End;{pocetradkuvseznamu}

procedure ZrusTexty(var ktere:uknaradek);
var vybrany:uknaradek;
    velikost:word;{velikost prave ruseneho radku v B}
Begin
while ktere<>nil do {dokud je co mazat}
  begin
  vybrany:=ktere;{nastavime pomocny ukazatel na prvni radek}
  velikost:=length(vybrany^.obsah)+5;{spocitame velikost}
  ktere:=vybrany^.dalsi;{ukazatel na prvni radek presuneme na nasledujici
       (pokud dojede za konec seznamu, bude mit hodnotu nil a cyklus skonci)}
  freemem(vybrany,velikost);{a vybrany radek smazeme}
  end;
End;{zrustexty}

function ValF(retezec:string; default:longint):longint;
var cislo:longint;
    kod:integer;
Begin
val(retezec,cislo,kod);
if kod=0 then valf:=cislo
         else valf:=default;
End;{valf}

function ValFR(retezec:string; default:real):real;
var cislo:real;
    kod:integer;
Begin
val(retezec,cislo,kod);
if kod=0 then valfr:=cislo
         else valfr:=default;
End;{valfr}

function Prekoduj(Retezec,PuvodniKodovani,NoveKodovani:string):string;
var i,j:byte;
    z:char;
    vysledek:string;
Begin
vysledek[0]:=retezec[0]; {nastaveni delky vysledku rovne delce vstupu}
for i:=1 to length(retezec) do {pro kazdy znak retezce}
 begin
 z:=retezec[i]; {precteme znak z retezce}
 for j:=1 to length(puvodnikodovani) do {projdeme seznam diakritickych znaku...}
   if z=puvodnikodovani[j] then begin {...pokud narazime na hacek nebo carku...}
                                z:=novekodovani[j]; {...nahradime ji prislusnym znakem z cilove znakove sady...}
                                break; {...a ukoncime cyklus for j}
                                end;
 vysledek[i]:=z; {zapiseme prevedeny znak na prislusnou pozici vysledneho textu}
 end;
prekoduj:=vysledek;
End;{prekoduj}

procedure PripravPrevodniTabulku(PuvodniZnaky,NoveZnaky:string; var PrevodniTabulka:pole256znaku);
var i,j:byte;
    HledaneZnaky:set of char; {kouknuti do mnoziny je rychlejsi nez prochazeni retezce}
    ch:char;
Begin
hledaneznaky:=[];
for i:=1 to length(puvodniznaky) do include(hledaneznaky,puvodniznaky[i]);
for ch:=#0 to #255 do
 if ch in hledaneznaky then begin
                            j:=1;
                            while puvodniznaky[j]<>ch do inc(j);
                            prevodnitabulka[ch]:=noveznaky[j];
                            end
                       else prevodnitabulka[ch]:=ch;
End;{pripravprevodnitabulku}

function PrekodujRetezec(ktery:string; var PrevodniTabulka:pole256znaku):string;
var i:byte;
    vystup:string;
Begin
vystup[0]:=ktery[0];
for i:=1 to length(ktery) do vystup[i]:=prevodnitabulka[ktery[i]];
prekodujretezec:=vystup;
End;{prekodujretezec}

function PrekodujSoubor(JmenoVstupu,JmenoVystupu:string; var PrevodniTabulka:pole256znaku):boolean;
var buffer:string;
    vstup,vystup:file;
    nacteno,zapsano:word;
Begin
prekodujsoubor:=false;
assign(vstup,jmenovstupu);
reset(vstup,1);
if ioresult<>0 then exit;
assign(vystup,jmenovystupu);
rewrite(vystup,1);
if ioresult<>0 then begin close(vstup); nacteno:=ioresult; exit; end;
while not eof(vstup) do begin
                        blockread(vstup,buffer[1],255,nacteno);
                        buffer[0]:=char(nacteno);
                        buffer:=prekodujretezec(buffer,prevodnitabulka);
                        blockwrite(vystup,buffer[1],nacteno,zapsano);
                        if zapsano<>nacteno then break;
                        end;
close(vstup); close(vystup);
prekodujsoubor:=ioresult=0;
End;{prekodujsoubor}

function NajdiKonecRadku(retezec:string; Zacatek,MaxDelka:byte):byte;
var Prst, {index pro pohyb v retezci}
    PotudJiste:byte; {index pro oznaceni posledniho znaku radku}
    BylaMezera:boolean; {jestli uz se na tomto radku nasla mezera}
Begin
if (retezec='')or(zacatek>length(retezec)) then begin
                                                najdikonecradku:=0;
                                                exit;
                                                end;
bylamezera:=false;
prst:=zacatek;
potudjiste:=zacatek; {uz vime, ze aspon jeden znak v retezci je, tak tohle muzeme udelat}
while (prst<=length(retezec))and(prst-zacatek<maxdelka) do
 begin
 if retezec[prst]=' '
   then begin {mezery berem vsechny}
        potudjiste:=prst;
        bylamezera:=true;
        end
   else if bylamezera then begin {pismeno 2+. slova na radku}
                           if (prst=length(retezec)) {je to posledni znak retezce...}
                              or(retezec[succ(prst)]=' ') {...nebo posledni pismeno slova}
                             then potudjiste:=prst;
                           end
                      else potudjiste:=prst; {pismeno 1. slova na radku}
 inc(prst);
 end;
najdikonecradku:=potudjiste;
End;{najdikonecradku}


{$ifdef superstringy}

procedure ssInit(var ktery:superstring);
Begin
fillchar(ktery,sizeof(ktery),0);
End;{ssinit}

procedure ssVymaz(var ktery:superstring);
var p:uknakss;
Begin
with ktery do begin
              while zacatek<>nil do begin
                                    p:=zacatek;
                                    zacatek:=zacatek^.dalsi;
                                    dispose(p);
                                    end;
              delka:=0;
              fragmentovany:=false;
              end;
End;{ssvymaz}

procedure ssPripoj(var KeKteremu,Ktery:superstring);
var p:uknakss;
Begin
if ktery.delka<>0 then
 with kekteremu do
  begin
  inc(delka,ktery.delka);
  if zacatek=nil then begin
                      zacatek:=ktery.zacatek;
                      fragmentovany:=ktery.fragmentovany;
                      end
                 else begin
                      p:=zacatek;
                      while p^.dalsi<>nil do p:=p^.dalsi;
                      p^.dalsi:=ktery.zacatek;
                      fragmentovany:=fragmentovany or ktery.fragmentovany or(length(p^.obsah)<ssdelka);
                      end;
  {zruseni Ktereho:}
  ktery.delka:=0;
  ktery.zacatek:=nil;
  ktery.fragmentovany:=false;
  end;
End;{sspripoj}

function ssNovyClanek(var cil:uknakss):boolean;
{Vytori a vynuluje novy clanek superstringu pod zadanym ukazatelem, pokud tedy
na nej je dost pameti. Vraci true, kdyz vsechno dobre dopadne.}
Begin
if maxavail>=ssgranularita {kdyz staci pamet}
  then begin
       new(cil);
       fillchar(cil^,5,0);{nuluje ukazatel na dalsi clanek a delku obsahu}
       ssnovyclanek:=true;
       end
  else ssnovyclanek:=false;
End;{ssnovyclanek}

procedure ssKopiruj(var Kam,Ktery:superstring);
var p,q:uknakss;
Begin
if kam.delka<>0 then ssvymaz(kam);
p:=ktery.zacatek;
while p<>nil do begin
                if kam.zacatek=nil then begin
                                        if not ssnovyclanek(kam.zacatek) then exit;
                                        q:=kam.zacatek;
                                        end
                                   else begin
                                        if not ssnovyclanek(q^.dalsi) then exit;
                                        q:=q^.dalsi;
                                        end;
                move32(p^.obsah[0],q^.obsah[0],ssdelka+1);
                p:=p^.dalsi;
                end;
End;{sskopiruj}

procedure ssZadej(var kam:superstring; co:string);
var pocet:byte;{pocet znaku, ktere se v aktualnim kroku kopiruji}
    pozice:word;{pozice ve zdrojovem retezci}
    p:uknakss;{pomocny ukazatel}
Begin
if kam.delka<>0 then ssvymaz(kam);
if co<>'' then
 with kam do
  begin
  fragmentovany:=false;
  pozice:=1;
  if not ssnovyclanek(zacatek) then exit;{kam.delka je ted urcite 0}
  p:=zacatek;
   repeat
   pocet:=length(co)-pozice+1;{kolik znaku zbyva zkopirovat}
   if pocet>ssdelka then begin{zpracujeme jen cast a vytvorime dalsi clanek}
                         move32(co[pozice],p^.obsah[1],ssdelka);
                         p^.obsah[0]:=char(ssdelka);
                         inc(pozice,ssdelka);
                         if not ssnovyclanek(p^.dalsi) then begin
                                                            delka:=pozice-1;
                                                            exit;
                                                            end;
                         p:=p^.dalsi;
                         end
                    else begin{dojedeme cely zbytek vstupniho retezce}
                         move32(co[pozice],p^.obsah[1],pocet);
                         p^.obsah[0]:=char(pocet);
                         pozice:=0;
                         end;
   until pozice=0;
  delka:=length(co);{nastaveni delky}
  end;
End;{sszadej}

function ssCopy(var zdroj:superstring; index:longint; pocet:byte):string;
var p:uknakss;
    vysledek:string;
    kolik:byte;
Begin
vysledek:='';
with zdroj do if (pocet>0)and(delka>0)and(index<=delka)and(index>=1) then
  begin
  {nalezeni mista:}
  p:=zacatek;
  while index>length(p^.obsah) do begin
                                  dec(index,length(p^.obsah));
                                  p:=p^.dalsi;
                                  end;
  {kopirujeme od p^.obsah[index]:}
   repeat
   {kolik znaku se bude z tohoto clanku kopirovat:}
   kolik:=length(p^.obsah)-index+1;
   if kolik>pocet then kolik:=pocet;
   {kopirovani:}
   vysledek:=vysledek+copy(p^.obsah,index,kolik);
   {ostatni veci:}
   dec(pocet,kolik);
   p:=p^.dalsi;
   index:=1;
   until (pocet=0)or(p=nil);
  end;
sscopy:=vysledek;
End;{sscopy}

procedure ssInsert(co:string; var kam:superstring; pozice:longint);
var p,ZbytekRetezce,predchozi:uknakss;
    PoziceVeZdroji:word;{word proto, aby se zabranilo preteceni pri delce retezce plnych 255 znaku}
    buffer:string[ssdelka];
    pocet:byte;
{}procedure PrectiKousek(JakVelky:byte);{nacte zadany (nebo mensi) pocet znaku
ze vstupniho retezce nebo ulozeneho konce do bufferu}
{}Begin
{}if pozicevezdroji>length(co) then buffer:=''
{}                             else begin
{}                                  buffer:=copy(co,pozicevezdroji,jakvelky);
{}                                  inc(pozicevezdroji,jakvelky);
{}                                  end;
{}End;{prectikousek}
{}function ZbyvaZnaku:word;{vraci pocet znaku, ktere se jeste budou vkladat}
{}Begin
{}if pozicevezdroji>length(co) then zbyvaznaku:=0
{}                             else zbyvaznaku:=length(co)-pozicevezdroji+1;
{}End;{zbyvaznaku}
Begin{ssinsert}
if co<>'' then if kam.zacatek=nil then sszadej(kam,co)
                                  else with kam do
   begin
   if pozice<1 then pozice:=1;
   if pozice>delka+1 then pozice:=delka+1;
   pozicevezdroji:=1; buffer:='';
   {nalezeni mista, do ktereho budeme vkladat:}
   p:=zacatek; predchozi:=nil;
   if pozice=delka+1 then begin{na konec}
                          while p^.dalsi<>nil do begin
                                                 predchozi:=p;
                                                 p:=p^.dalsi;
                                                 end;
                          if length(p^.obsah)=ssdelka then begin
                                                           if not ssnovyclanek(p^.dalsi) then exit;
                                                           predchozi:=p;
                                                           p:=p^.dalsi;
                                                           pozice:=1;
                                                           end
                                                      else pozice:=length(p^.obsah)+1;
                          end
                     else begin{nekam doprostred}
                          while pozice>length(p^.obsah) do
                            begin
                            dec(pozice,length(p^.obsah));
                            predchozi:=p;
                            p:=p^.dalsi;
                            end;
                          fragmentovany:=true;{sice se muze stat, ze se vlozenim nefragmentuje, ale neni to pravdepodobne}
                          end;
   zbytekretezce:=p^.dalsi;
   {Ted je: p^ - existujici clanek, do ktereho vkladame
            zbytekretezce^ - clanek za p^
            predchozi^ - clanek pred p^
            pozice - index znaku v clanku p^, pred ktery se bude vkladat}
   {pokud mame vkladat pred prvni znak, zkusime to nejdriv vlozit na konec
   predchoziho clanku:}
   if (pozice=1)and(predchozi<>nil)and(length(predchozi^.obsah)<ssdelka)
     then begin
          prectikousek(ssdelka-length(predchozi^.obsah));{precteni}
          predchozi^.obsah:=predchozi^.obsah+buffer;{zapis}
          if pozicevezdroji>length(co) then begin
                                            inc(delka,length(co));{aktualizace delky retezce}
                                            exit;{vesel se tam cely}
                                            end;
          end;
   {pokud se vkladany retezec nevejde do p^, zkusime si v nem udelat misto
   presunutim casti obsahu p^ na konec predchoziho clanku:}
   if (length(p^.obsah)+zbyvaznaku>ssdelka)and(predchozi<>nil)and(length(predchozi^.obsah)<ssdelka)
     then begin
          pocet:=ssdelka-length(predchozi^.obsah);
          if pocet>length(p^.obsah) then pocet:=length(p^.obsah);
          predchozi^.obsah:=predchozi^.obsah+copy(p^.obsah,1,pocet);
          delete(p^.obsah,1,pocet);
          dec(pozice,pocet);
          end;
   {pokud se nyni vkladany retezec vejde cely do p^, vlozime ho tam a koncime:}
   if ssdelka-length(p^.obsah)>=zbyvaznaku
     then begin
          prectikousek(ssdelka);{ve skutecnosti se nejspis nacte mene, coz nevadi}
          insert(buffer,p^.obsah,pozice);
          inc(delka,length(co));
          exit;
          end;
   {Pokud jsme jeste tady, retezec se do clanku p^ cely nevejde, takze budeme
   muset vytvorit nejake nove clanky.}
   if pozice=1 then if predchozi=nil then begin{uplny zacatek retezce - novy clanek pred p; p a zbytekretezce o pozici zpet}
                                          if not ssnovyclanek(zacatek) then exit;
                                          zacatek^.dalsi:=p;
                                          zbytekretezce:=p;
                                          p:=zacatek;
                                          end
                                     else begin{zacatek nejakeho clanku - novy clanek pred p; p a zbytekretezce o pozici zpet}
                                          if not ssnovyclanek(predchozi^.dalsi) then exit;
                                          predchozi^.dalsi^.dalsi:=p;
                                          zbytekretezce:=p;
                                          p:=predchozi^.dalsi;
                                          end
               else begin{p^ rozdelime a novy clanek vytvorime za nim}
                    if not ssnovyclanek(p^.dalsi) then exit;
                    co:=co+copy(p^.obsah,pozice,ssdelka);{pripoji se jen skutecna delka zbytku clanku}
                    dec(delka,length(p^.obsah)-pozice+1);{aktualizace delky pro pripad predcasneho konce procedury}
                    byte(p^.obsah[0]):=pozice-1;{smazani ulozeneho konce z p^}
                    p:=p^.dalsi;
                    p^.dalsi:=zbytekretezce;
                    {ukazatel Predchozi uz nebude potreba, tak se o nej nestarame}
                    end;
   prectikousek(ssdelka-length(p^.obsah));
   while buffer<>'' do
     begin
     p^.obsah:=p^.obsah+buffer;
     inc(delka,length(buffer));
     if length(p^.obsah)=ssdelka then begin
                                      if not ssnovyclanek(p^.dalsi) then exit;
                                      p:=p^.dalsi;
                                      p^.dalsi:=zbytekretezce;
                                      end;
     prectikousek(ssdelka-length(p^.obsah));
     end;
   end;
End;{ssinsert}

procedure ssDelete(var odkud:superstring; index,pocet:longint);
var p,predchozi:uknakss;
    xmazani:byte;{pocet znaku k smazani z jednoho clanku}
Begin
with odkud do if (pocet>0)and(delka>0)and(index<=delka)and(index>=1) then
  begin
  p:=zacatek; predchozi:=nil;
  while index>length(p^.obsah) do begin
                                  dec(index,length(p^.obsah));
                                  predchozi:=p;
                                  p:=p^.dalsi;
                                  end;
  {mazeme od p^.obsah[index]:}
   repeat
   if pocet<=length(p^.obsah)-index+1
     then begin{budeme mazat jen z jednoho clanku}
          delete(p^.obsah,index,pocet);
          dec(delka,pocet);
          pocet:=0;
          if p^.obsah[0]=#0 then begin{vymazali jsme cely obsah clanku p^, tak ho zrusime}
                                 if predchozi=nil then zacatek:=p^.dalsi
                                                  else predchozi^.dalsi:=p^.dalsi;
                                 dispose(p);
                                 end
                            else fragmentovany:=true;{zkracenim clanku na nenulovou delku jsme vytvorili diru}
          end
     else begin{cast smazeme odtud, zbytek z nasledujiciho}
          if index>1 then fragmentovany:=true;{kdyz clanek nesmazeme cely, vznikne v nem dira}
          xmazani:=length(p^.obsah)-index+1;
          dec(pocet,xmazani);
          dec(delka,xmazani);
          index:=1;
          dec(byte(p^.obsah[0]),xmazani);{umazani konce retezce (rychlejsi nez Delete)}
          predchozi:=p;
          p:=p^.dalsi;
          if p=nil then pocet:=0;{uz neni co mazat}
          end;
   until pocet=0;
  end;
End;{ssdelete}

procedure ssDefrag(var ktery:superstring);
var p,xmazani:uknakss;
    pocet:byte;{pro pocitani velikosti der}
Begin
if (ktery.delka>0)and(ktery.fragmentovany) then with ktery do
  begin
  p:=zacatek;
  while p^.dalsi<>nil do
    begin
    if length(p^.obsah)=ssdelka
      then p:=p^.dalsi{OK, tenhle je cely zaplneny, jdeme na dalsi}
      else with p^ do begin{tady je dira}
                      pocet:=ssdelka-length(obsah);{jak je dira velka?}
                      obsah:=obsah+copy(dalsi^.obsah,1,pocet);{zaplnime diru zacatkem nasledujiciho clanku}
                      delete(dalsi^.obsah,1,pocet);{nekopirujeme, ale presouvame}
                      if dalsi^.obsah[0]=#0 then begin{jestli v tom nasledujicim clanku nic nezbylo, smazeme ho}
                                                 xmazani:=dalsi;
                                                 dalsi:=dalsi^.dalsi;
                                                 dispose(xmazani);
                                                 end;
                      end;
    end;
  fragmentovany:=false;
  end;
End;{ssdefrag}

procedure ssReadLn(var odkud:text; var kam:superstring);
var buffer:string[ssdelka];
    p:uknakss;
Begin
if kam.delka<>0 then ssvymaz(kam);
with kam do
  begin
  fragmentovany:=false;
  buffer:='';{dulezite pro detekci I/O chyb}
  read(odkud,buffer);{Read se o konec radku v souboru zastavi a dal necte}
  while buffer<>'' do begin
                      {Po I/O chybe se dalsi Read neprovede a buffer zustane
                      prazdny. Ioresult zaroven zustane nedotcen a da se
                      zkontrolovat mimo tuto proceduru.
                      Vytvoreni noveho clanku superstringu:}
                      if zacatek=nil then begin
                                          if not ssnovyclanek(zacatek) then exit;
                                          p:=zacatek;
                                          end
                                     else begin
                                          if not ssnovyclanek(p^.dalsi) then exit;
                                          p:=p^.dalsi;
                                          end;
                      p^.obsah:=buffer;{prekopirovani nactenych dat}
                      inc(delka,length(buffer));{aktualizace delky}
                      buffer:='';
                      read(odkud,buffer);{nacteni dalsi porce textu}
                      end;
  if not eof(odkud) then readln(odkud);{skocime na zacatek dalsiho radku,
          tedy jestli uz nejsme na konci souboru nebo se nevyskytla I/O chyba}
  end;
End;{ssreadln}

procedure ssWriteLn(var kam:text; var co:superstring);
var p:uknakss;
Begin
p:=co.zacatek;
while p<>nil do begin
                write(kam,p^.obsah);
                p:=p^.dalsi;
                end;
writeln(kam);
{I/O chyba zpusobi, ze se do souboru proste nebude nic zapisovat, takze se nic
spatneho nestane. Ioresult zustane nedotcen a muzeme si ho tedy potom
zkontrolovat.}
End;{sswriteln}

procedure ssPrekoduj(var Retezec:superstring; PuvodniKodovani,NoveKodovani:string);
var pom:uknakss;
Begin
pom:=retezec.zacatek;
while pom<>nil do begin
                  pom^.obsah:=prekoduj(pom^.obsah,puvodnikodovani,novekodovani);
                  pom:=pom^.dalsi;
                  end;
End;{ssprekoduj}

function ssNajdiKonecRadku(retezec:superstring; Zacatek:longint; MaxDelka:word):longint;
var ZacatekSlova,KonecSlova:longint;
    uk:uknakss;{ukazatel na clanek}
    poz:byte;{pozice v clanku}
Begin
if zacatek>retezec.delka then begin
                              ssnajdikonecradku:=0;
                              exit;
                              end;
{nalezeni clanku a pozice v nem, ktere odpovidaji zadanemu indexu zacatku:}
uk:=retezec.zacatek;
zacatekslova:=1; poz:=1;
while zacatekslova<zacatek do
 if zacatek-zacatekslova>=length(uk^.obsah)
   then begin
        inc(zacatekslova,length(uk^.obsah));
        uk:=uk^.dalsi;
        end
   else begin
        poz:=zacatek-zacatekslova+1;
        zacatekslova:=zacatek;
        end;
konecslova:=zacatek;
 repeat
  repeat
  inc(konecslova);
  {tohle je druhy a posledni rozdil oproti vyse uvedene funkci pro obycejny string:}
  inc(poz);
  if poz>length(uk^.obsah) then begin
                                uk:=uk^.dalsi;
                                poz:=1;
                                end;
  until (konecslova>=retezec.delka)or(uk^.obsah[poz]=' ');
 if konecslova-zacatek+1<maxdelka
   then zacatekslova:=konecslova
   else begin
        if zacatekslova=zacatek then ssnajdikonecradku:=zacatek+maxdelka-1
                                else ssnajdikonecradku:=zacatekslova;
        break;
        end;
 until false;
End;{ssnajdikonecradku}

{$endif}

function xChr(cislo:word):char; assembler;
Asm
mov AX,cislo
test AX,$FF00
jz @normalni
 xor AX,AX
@normalni:
{znak je jenom jinak vyjadrene cislo, takze se nemusi nijak prevadet}
End;{xchr}

function ZkratRetezec(Ktery:string; NaKolik,VlevoNechat,VpravoNechat:byte):string;
Begin
if (length(ktery)>nakolik) {kdyz je retezec delsi nez ma byt, mel by se zkratit}
   and(vlevonechat+vpravonechat+3<length(ktery)) {tohle je proti zbytecnemu prodluzovani}
  then begin {zkracujeme}
       if vlevonechat+vpravonechat+3>=nakolik
         then {zustanou jenom konce a mezi nimi tri tecky}
              ktery:=copy(ktery,1,vlevonechat)+'...'+copy(ktery,length(ktery)-vpravonechat+1,vpravonechat)
         else begin {zustane levy konec, tri tecky, neco z prostredka a pravy konec}
              delete(ktery,vlevonechat+1,length(ktery)-nakolik);{odmazani prebytku}
              fillchar(ktery[vlevonechat+1],3,'.');{doplneni tri tecek}
              end;
       end;
zkratretezec:=ktery;
End;{zkratretezec}

function left(retezec:string; kolik:byte):string;
var vystup:string;
Begin
if kolik>=length(retezec) then left:=retezec
                          else begin
                               vystup[0]:=char(kolik);
                               move32(retezec[1],vystup[1],kolik);
                               left:=vystup;
                               end;
End;{left}

function right(retezec:string; kolik:byte):string;
var vystup:string;
Begin
if kolik>=length(retezec) then right:=retezec
                          else begin
                               vystup[0]:=char(kolik);
                               move32(retezec[length(retezec)-kolik+1],vystup[1],kolik);
                               right:=vystup;
                               end;
End;{right}

function strip(retezec:string; kde,co:char):string;
var p:byte;
Begin
kde:=upcase(kde);
if kde in ['T','R','P','O','B'] {zprava}
  then while (length(retezec)<>0)and(retezec[length(retezec)]=co) do dec(retezec[0]);
if kde in ['L','Z','O','B'] {zleva}
  then begin
       p:=0;
       while (p<length(retezec))and(retezec[p+1]=co) do inc(p); {najdeme vsechny, at se Delete nemusi volat vickrat}
       if p<>0 then delete(retezec,1,p);
       end;
strip:=retezec;
End;{strip}

function PocetSlov(Retezec,Oddelovac:string):byte;
var p,pocet:byte;
Begin
if oddelovac=''
  then pocetslov:=1 {bez oddelovacu neni co resit, je to jedno slovo (muze byt i prazdne)}
  else begin {spocitame oddelovace}
       p:=1; {pozice v retezci}
       pocet:=0;
       while p<=length(retezec)-length(oddelovac)+1 do
        begin
        if copy(retezec,p,length(oddelovac))=oddelovac {narazili jsme na zacatek oddelovace}
          then begin
               inc(pocet);
               inc(p,length(oddelovac));
               end
          else inc(p);
        end;
       pocetslov:=pocet+1; {pocet slov = pocet oddelovacu + 1}
       end;
End;{pocetslov}

function DejSlovo(Retezec,Oddelovac:string; Kolikate:byte):string;
var index, {kolikate slovo jsme zatim nasli}
    zacatek,konec:byte; {okraje zkoumaneho slova}
Begin
if (retezec='')or(oddelovac='')or(length(retezec)<length(oddelovac))or(kolikate=0)
  then dejslovo:=retezec
  else begin
       zacatek:=0; {slovo bude zacinat o 1 za zacatkem}
       index:=0; {cislo slova}
       dejslovo:=''; {pro pripad, ze bychom tolikate slovo vubec nenasli}
        repeat
        inc(index);
        konec:=zacatek;
        while (konec<length(retezec))and(copy(retezec,konec+1,length(oddelovac))<>oddelovac)
          do inc(konec);
        {ted mame zacatek pred prvnim znakem slova a konec na poslednim}
        if index=kolikate then dejslovo:=copy(retezec,zacatek+1,konec-zacatek) {hotovo}
                          else zacatek:=konec+length(oddelovac); {na dalsi slovo}
        until (index=kolikate)or(zacatek>=length(retezec)); {do nalezeni pozadovaneho slova nebo do konce retezce}
       end;
End;{dejslovo}

END.