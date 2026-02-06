(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: DISK.PAS                                                       *)
(*  Obsah: veci pro praci se soubory a par diagnostickych procedur         *)
(*  Posledni uprava: 2.1.2015                                              *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*         TrSek (reset)                                                   *)
(*         FReeZ (detekce Windows 9x)                                      *)
(*         Pino Navato (funkce pro dlouha jmena souboru)                   *)
(*  Pro kompilaci: DOS.TPU                                                 *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Disk;
{$I-,G+} {nutne, nemazat!}
interface
uses dos;

(*************************** prace s disky: *********************************)

{Parametr PD vzdy znamena "pismeno disku", napr. 'c', 'A' apod. (na velikosti
pismena nezalezi). Hodnota '@' znamena disk, na kterem se prave nachazime.}

procedure NastavDisk(PD:char);
{Prepne na dany disk. Pokud ten disk neexistuje, neudela nic.
Nelze pouzit '@'.
Mezi disky umi prepinat i Chdir, takze asi jedine vyuziti tehle procedury je
v tom, ze nezmeni aktualni adresar, ktery je na cilovem disku nastaveny.}
function ZjistiDisk:char;
{Vrati pismeno disku, na kterem se zrovna nachazime.}
procedure ZjistiVolneMisto(PD:char; var Hodnota:longint; var Jednotky:byte);
{Zjisti mnozstvi volneho mista na danem disku. Pouzitelna zaroven jako
detekce existence disku nebo neprilis spolehliva identifikace CD-ROMky.
 Hodnota - velikost volneho mista (nikdy nevyjde vic nez 102400),
           pro CD nebo DVD bude vzdycky 0
 Jednotky - v jakych jednotkach Hodnota vysla:
            1 - byty
            2 - kilobyty (1024 B)
            3 - megabyty (1024 KB)
            4 - gigabyty (1024 MB)
            5 - terabyty (1024 GB)
            nebo chybovy kod:
            0 - zadany disk neexistuje nebo to je prazdna CD nebo disketova
                mechanika
V podstate jde o ekvivalent funkce Diskfree, ale narozdil od ni zvlada i
disky vetsi nez 2 GB.
Funkce se na disk musi fyzicky kouknout, takze jestli testujete disketu nebo
CD, roztoci se.
Pozor, ze na discich se systemem NTFS vraci nesmysly.}
function PocetDisketovychMechanik:byte;
{Zjisti, kolik disketovych mechanik je na tomto pocitaci nainstalovano.
Informace taha z BIOSu, na disky nesaha.}
function ZjistiLogickeMapovani(PD:char):byte;
{Nahlasi, jak je na tom dany disk s logickym mapovanim. Mozne vysledky:
  0 - na tuhle jednotku je namapovan pouze jeden disk (obvykle u vseho krome
      disket, na Windows XP i tam)
  1..26 - pismeno, ktere bylo na tuhle jednotku naposledy namapovano
          (1=A, 2=B atd., obvykle pouze u disket)
  255 - tahle jednotka neexistuje
Mozne vyuziti:
 1) Test existence disku
 2) Test "fantomove diskety" - jednotka A: je obvykle namapovana na cislo 1,
    jednotka B:, pokud existuje, na cislo 2. Pokud neexistuje, byva namapovana
    take na 1 a kdyz se do ni zkusite prepnout, vyskoci systemova hlaska
    "Vlozte disk do jednotky B:", po stisku klavesy se A: i B: premapuji na
    cislo 2 a je z toho maglajz, ta hlaska vam prepise obrazovku a nekdy i
    shodi program, pokud bezel v nejake slozitejsi grafice.
    Z toho vyplyva: pokud B: neni namapovana na 0 nebo 2, nepokousejte se ji
    pouzivat.
    Na Windows XP se fantomove nevyskytuji, tam maji obe diskety nulu
    (i neexistujici Bcko, pozor na to! Je potreba zkontrolovat jejich pocet).}
function DiskJeVymenitelny(PD:char):boolean;
{Mozne vysledky:
 true - vymenitelny disk, cili disketova mechanika nebo USB flashka
 false - nevymenitelny disk, tj. harddisk nebo (kupodivu) CD/DVD mechanika,
         nebo to znamena, ze disk neexistuje}

{Pokud potrebujete detekovat typ disku, staci vhodne zkombinovat vyse uvedene
funkce. Na konci teto jednotky najdete souhrnnou tabulku, co ktery typ disku
dava za hodnoty.}

(********************* prace se soubory a adresari: *************************)

function ExistujeSoubor(Jmeno:string):boolean;
{Zjisti, jestli existuje soubor s danym Jmenem. Da se testovat i existence
vice souboru najednou, v takovem pripade vraci true pouze tehdy, kdyz existuji
vsechny. Do Jmena piste jmena oddelena carkami bez mezer, napr.:
 if existujesoubor('soubor1.bla,xxx\neco.txt,dalsi.dat')
   then writeln('Vsechny tyhle soubory existuji.');}
function ExistujeAdresar(jmeno:pathstr):boolean;
{zjisti, jestli existuje dany adresar}
function Kopiruj(Zdroj,Cil:pathstr):boolean;
{Kopiruje soubor Zdroj do souboru Cil. Pokud Cil existuje, bude bez varovani
prepsan. Vraci true, pokud se kopirovani povedlo.}
function SifrujSoubor(Zdroj,Cil:pathstr; Heslo:string):boolean;
{Obsah souboru Zdroj prekopiruje v zasifrovane podobe do souboru Cil. Koduje
se jednoduchym xorovanim kazdeho bytu vstupniho souboru s jednim znakem Hesla,
z cehoz mimo jine vyplyva, ze zakodovani i rozkodovani se dela tou samou
procedurou (protoze A xor B xor B = A).
Pokud se za behu procedury vyskytne jakakoli chyba (neexistujici soubor,
nezadane heslo atd.), vraci se False, jinak True.
Technicky detail: pokud je heslo stejne dlouhe jako sifrovany soubor, je tato
sifra dokonale neprolomitelna (dukaz je celkem jednoduchy: existuje hafo
moznych hesel, ktera soubor rozsifruji do citelne a smysluplne podoby, ale
neda se zjistit, jestli to je zrovna ta podoba, v jake byl pred zasifrovanim).}
function VymazSoubor(S:pathstr):boolean;
{vymaze soubor S a vraci true, pokud se to povedlo}
function AdresarProgramu:dirstr;
{vraci adresar, ze ktereho byl prave bezici program spusten}
function JmenoSouboru(soubor:pathstr):namestr;
{vraci samotne jmeno souboru bez cesty a koncovky}
procedure HromadneAtributy(maska:pathstr; jake:word);
{Nastavi dane atributy vsem souborum ve vsech podadresarich aktualniho
adresare (aktualni adresar ovlivnen nebude). Maska je napr. '*.*', '*.exe'
apod. (bez cesty!). Pouzitelne hodnoty pro Jake jsou: Archive, ReadOnly,
Hidden a SysFile, daji se scitat (nebo ORovat) - viz napovedu.}

{pomocne typy pro nasledujici proceduru:}
type UkNaSoubor = ^TSoubor;
     TSoubor = record
               jmeno:string[8]; {jmeno a koncovka jsou zvlast, protoze se s tim pak lip pracuje}
               koncovka:string[3]; {koncovka je bez uvodni tecky}
               atributy:byte; {stejny format jako v typu Searchrec}
               velikost:longint; {v bytech}
               zmeneno:longint; {rozbalite pomoci Unpacktime}
               dalsi:array[false..true] of uknasoubor;
                {dalsi[false] ukazuje na predchozi prvek seznamu,
                 dalsi[true] na nasledujici
                (v poli je to kvuli zjednoduseni prochazeni seznamu - nemusi
                se psat pro kazdy smer zvlast, staci znegovat jednu promennou)}
               end;
function SeznamSouboru(var Prvni:uknasoubor; Maska:pathstr; Adresare:boolean):word;
{Vytvori obousmerny linearni spojovy seznam souboru nebo adresaru, ktere
odpovidaji dane Masce, a na jeho zacatek nasmeruje ukazatel Prvni (na hodnote
tohoto ukazatele pred volanim procedury nezalezi). Seznam bude abecedne
serazeny nejdrive podle koncovky a potom podle jmena. Vyhledava se vsechno
vcetne skrytych a systemovych souboru a adresaru.
Pro Masku plati bezna pravidla DOSu. Napriklad: '*.txt', '*' (cokoli bez
koncovky), '*.*' (cokoli s koncovkou i bez), 'adresar\obr??.bmp' (cokoli, co
ma ve jmene za 'obr' prave dva znaky), 'a:\bla\neco*' apod.. V ceste otazniky
ani hvezdicky delat nejdou.
Parametr Adresare urcuje, jestli se ma delat seznam souboru (false) nebo
adresaru (true). Datova struktura se pouziva na oboji stejna, v pripade
potreby muzete seznamy obou typu i navzajem spojit.
Funkce vraci pocet polozek v seznamu.
Jestli je po skonceni funkce Doserror=-1, nebylo dost pameti a seznam
neni uplny. Jestli je Prvni=nil, zadny odpovidajici soubor nebo adresar
nebyl nalezen.}
procedure ZrusSeznamSouboru(var prvni:uknasoubor);
{Vymaze z pameti seznam vytvoreny procedurou SeznamSouboru.}

{pomocny typy pro nasledujici proceduru:}
type UkNaAUzel=^auzel;
     AUzel = record
             jmeno:string[12];
             dalsi, {dalsi jeho kolega nachazejici se ve stejnem adresari}
             obsah:uknaauzel; {seznam jeho podadresaru}
             end;
procedure StromAdresaru(var Cil:uknaauzel; Cesta:pathstr);
{Za ukazatelem Cil vytvori stromovou strukturu adresaru, ktere zacinaji v
adresari Cesta. Pozor: Cesta MUSI byt vyplnena, a to tak, aby nekoncila
znakem '\'. Takze napr.: 'c:', 'c:\dos', 'c:\tp\bin' apod.. Nelze zadat
prazdnou ('')!}
procedure ZrusStromAdresaru(var ktery:uknaauzel);
{zrusi drive vytvoreny strom adresaru}

procedure lRename(PuvodniJmeno,NoveJmeno:string);
{Prejmenuje soubor. Zvlada i windowsovsky dlouha jmena.}

(******************************* ostatni: ***********************************)

function Win9XAktivni:boolean;
{zjisti, jestli bezi Windows 95 nebo 98}
procedure ResetujPocitac;
{Zpusobi "teply restart" (ekvivalent ctrl+alt+del), funguje jen pod DOSem.
Kazdopadne bacha, je to docela nebezpecna vec.}


implementation

procedure nastavdisk(pd:char); assembler;
Asm
mov DL,pd
{pripadny prevod na velke pismeno:}
cmp DL,'Z'       {je za 'Z'?}
jle @JeVelke     {ne, takze uz je velke a nemusime ho prevadet}
 sub DL,'a'-'A'  {prevod z maleho na velke}
@JeVelke:         {(pripadne nesmysly mimo abecedu neresim, neplatny disk by to byl tak jako tak)}
sub DL,65  {prevod z 'A'..neco na 0..neco}
mov AH,$0E
int $21
End;{nastavdisk}

function zjistidisk:char; assembler;
Asm
mov AH,$19
int $21
add AL,'A'  {0=A, 1=B atd.}
End;{zjistidisk}

function existujesoubor(jmeno:string):boolean;
var f:file;
    i:byte; {index pro pohyb v retezci}
Begin
existujesoubor:=true;
 repeat
 {i nastavime tak, aby ukazovalo na posledni znak pred carkou
 nebo pred koncem retezce:}
 i:=1;
 while (i<length(jmeno))and(jmeno[i+1]<>',') do inc(i);
 {pokusne otevreni a zavreni souboru:}
 assign(f,copy(jmeno,1,i));
 reset(f);
 close(f);
 if ioresult<>0 then begin {jestli pri otvirani nastala chyba, soubor zrejme neexistuje}
                     existujesoubor:=false;
                     break;
                     end;
 delete(jmeno,1,i+1);{vymazani zpracovaneho jmena z retezce vcetne pripadne carky za nim}
 until jmeno='';{dokud neni zpracovan cely retezec}
End;{existujesoubor}

function ExistujeAdresar(jmeno:pathstr):boolean;
var info:searchrec;
Begin
findfirst(jmeno,anyfile-volumeid,info); {slo by to testovat i tak, ze bych se do toho
adresare zkusil prepnout a pak se zase vratit,ale mam s tim spatne zkusenosti}
existujeadresar:=(doserror=0)and(info.attr and directory<>0);
End;{existujeadresar}

function kopiruj(zdroj,cil:pathstr):boolean; {opsano z napovedy k prikazu Blockwrite :-]}
var FromF,ToF:file;
    NumRead,NumWritten:Word;
    Buf:array[1..2048] of byte;
Begin
Assign(FromF,zdroj);
Reset(FromF,1);
if ioresult=0 then begin
                   Assign(ToF,cil);
                   Rewrite(ToF,1);
                   if ioresult=0 then begin
                                       repeat
                                       BlockRead(FromF,Buf,SizeOf(Buf),NumRead);
                                       BlockWrite(ToF,Buf,NumRead,NumWritten);
                                       until (NumRead=0) or (NumWritten<>NumRead);
                                      Close(FromF);
                                      Close(ToF);
                                      kopiruj:=true;
                                      end
                                 else begin
                                      close(fromf);
                                      kopiruj:=false;
                                      end;
                   end
              else kopiruj:=false;
if ioresult=0 then ; {reset pro pripad potizi pri zavirani souboru (prakticky nemozne, ale co kdyby)}
End;{kopiruj}

function AdresarProgramu:dirstr;
var cesta:dirstr; jmeno:namestr; koncovka:extstr;
Begin
fsplit(paramstr(0),cesta,jmeno,koncovka);
adresarprogramu:=cesta;
End;{adresarprogramu}

function JmenoSouboru(soubor:pathstr):namestr;
var cesta:dirstr; jmeno:namestr; koncovka:extstr;
Begin
fsplit(soubor,cesta,jmeno,koncovka);
jmenosouboru:=jmeno;
End;{jmenosouboru}

procedure ResetujPocitac;
var reboot:procedure;
Begin
@reboot:=Ptr($FFFF,$0); {adresa bootovaciho programu}
reboot;
End;{resetujpocitac}

function VymazSoubor(s:pathstr):boolean;
var f:file;
Begin
assign(f,s);
erase(f);
vymazsoubor:=ioresult=0;
End;{vymazsoubor}

function SifrujSoubor(zdroj,cil:pathstr;heslo:string):boolean;
var f1,f2:file;
    bafr:array[1..1024]of byte;{bude se cist a psat po kilobytech}
    precteno,{kolik B bylo precteno ze vstupniho souboru}
    zapsano:word;{kolik B se podarilo zapsat do vystupniho souboru}
    i:word;{index pro pohyb v bufferu}
    j:byte;{index pro pohyb v heslu}
Begin
sifrujsoubor:=false;{zatim nevime, jestli vsechno dobre dopadne}
if heslo='' then exit;{prazdnym heslem by sifrovat neslo}
j:=1;{zacit se musi vzdy od prvniho znaku hesla}
assign(f1,zdroj); assign(f2,cil);{priradime promennym soubory}
reset(f1,1);{otevreme vstup}
if ioresult=0 then{kdyz to dobre dopadlo, tak pokracujeme}
  begin
  rewrite(f2,1);{otevreme vystup}
  if ioresult=0 then{kdyz to dobre dopadlo, tak pokracujeme, jinak...*}
    begin
     repeat
     blockread(f1,bafr,1024,precteno);{nacti 1024 bytu ze souboru f1, uloz je do bafru a do promenne Precteno uloz,
                                       kolik se jich ve skutecnosti podarilo precist}
     if precteno>0 then
      for i:=1 to precteno do begin{kodovani}
                              bafr[i]:=bafr[i] xor byte(heslo[j]);{a tohle je cely sifrovaci algoritmus :-)}
                              if j<length(heslo) then inc(j){a posuneme se v heslu bud na dalsi znak...}
                                                 else j:=1;{...nebo zpatky na zacatek, pokud uz jsme byli na konci}
                              end;
     blockwrite(f2,bafr,precteno,zapsano);{zapis z bafru do f2 tolik bytu, kolik jsi jich predtim nacetl z f1
                                           a do promenne Zapsano uloz, kolik se ti jich povedlo doopravdy zapsat}
     until (precteno<1024){jsme na konci vstupniho souboru}
        or(zapsano<precteno);{nebo doslo misto na disku s vystupnim souborem}
    close(f1); close(f2);{zavreme soubory}
    if (zapsano=precteno)and(ioresult=0)then sifrujsoubor:=true;{a jestli tohle vsechno dobre dopadlo, tak ohlasime,
                                                                 ze je vse v poradku}
    end
                else begin
                     close(f1);{*...zase zavreme vstup a koncime}
                     i:=ioresult;{to uz jen pro jistotu, aby se ioresult vynuloval po pripadnem neuspesnem zavreni}
                     end;
  end;
End;{sifrujsoubor}

function SeznamSouboru(var prvni:uknasoubor; maska:pathstr; adresare:boolean):word;
var vybrany,novy,predchozi:uknasoubor;
    smer:boolean;
    vysledek:searchrec;
    _cesta:dirstr; _jmeno:namestr; _koncovka:extstr;
    at:byte;
    pocet:word;
{}function JeVetsi(prvni,druhy:uknasoubor):boolean; {vraci true, kdyz prvni>druhy}
{}Begin
{}if prvni^.koncovka>druhy^.koncovka then jevetsi:=true {nejdriv radime podle koncovek...}
{} else if prvni^.koncovka<druhy^.koncovka then jevetsi:=false
{}  else jevetsi:=prvni^.jmeno>druhy^.jmeno; {...a kdyz jsou stejne, tak podle jmena}
{}End;{jevetsi}
Begin
pocet:=0;
prvni:=nil; vybrany:=nil; {oboji velmi dulezite!}
at:=anyfile-volumeid; {cokoli krome jmen disku...}
if not adresare then dec(at,directory); {...a adresaru, jestli je nechceme}
findfirst(maska,at,vysledek);
while doserror=0 do {dokud se neco naslo}
 begin
 if not adresare {jestli hledame soubory, ber vsechno}
    or (vysledek.attr and directory<>0) {jestli adresare, tak ignoruj soubory (soubory se z hledani vyfiltrovat nedaji)}
       and(vysledek.name<>'.') {taky si nevsimej pseudoadresare "tenhle adresar"}
   then if sizeof(tsoubor)>maxavail {jestli se zaznam nevejde do pameti...}
          then doserror:=-1 {...nahlas chybu (tohle neni zadny oficialni kod)...}
          else begin {...jinak ho vloz do seznamu}
               new(novy);
               if vysledek.name='..' then begin {z tohohle by se Fsplit zvencnul, tak musime rucne}
                                          _jmeno:='..'; {pseudoadresar "o uroven vys"}
                                          _koncovka:='';
                                          end
                                     else fsplit(vysledek.name,_cesta,_jmeno,_koncovka);
               with novy^ do begin                               {^^bude vzdy prazdna, Findfirst/next dava jmena bez cesty}
                             jmeno:=_jmeno;
                             koncovka:=copy(_koncovka,2,3); {z koncovky urizneme tecku, kterou tam Fsplit nechal}
                             atributy:=vysledek.attr;
                             velikost:=vysledek.size;
                             zmeneno:=vysledek.time;
                             dalsi[false]:=nil; {predchozi}
                             dalsi[true]:=nil; {nasledujici}
                             end;
               {zarazeni do seznamu:}
               if prvni=nil {je seznam prazdny?}
                 then prvni:=novy {je, neni co resit}
                 else begin {neni, musime do nej novy zaznam spravne zaradit}
                      if vybrany=nil then vybrany:=prvni; {Kdyz uz pomocny ukazatel ukazuje nekam do
                         seznamu, zacneme od nej - je to rychlejsi nez seznam pokazde prochazet uplne od zacatku.}
                      smer:=jevetsi(novy,vybrany); {jestli chceme novy zaznam vlozit pred nebo za vybrany}
                       repeat {projizdime seznam, dokud nenajdeme vhodne misto pro vlozeni}
                       predchozi:=vybrany;
                       vybrany:=vybrany^.dalsi[smer];
                       until (vybrany=nil) {jsme na zacatku nebo na konci seznamu}
                             or (smer and jevetsi(vybrany,novy)) {nebo jsme nasli misto nekde uvnitr}
                             or (not smer and not jevetsi(vybrany,novy));
                      {Novy vlozime mezi Vybrany a Predchozi:}
                      novy^.dalsi[smer]:=vybrany;
                      novy^.dalsi[not smer]:=predchozi;
                      if vybrany<>nil then vybrany^.dalsi[not smer]:=novy;
                      if predchozi<>nil then predchozi^.dalsi[smer]:=novy;
                      if prvni^.dalsi[false]<>nil then prvni:=prvni^.dalsi[false];
                                 {aby prvni byl porad prvni, i kdyz neco vlozime pred nej}
                      end;
               inc(pocet);
               end;
 if doserror<>-1 then findnext(vysledek);
 end;{while}
seznamsouboru:=pocet;
End;{seznamsouboru}

procedure ZrusSeznamSouboru(var prvni:uknasoubor);
var pom:uknasoubor;
Begin
while prvni<>nil do begin
                    pom:=prvni;
                    prvni:=prvni^.dalsi[true];
                    dispose(pom);
                    end;
End;{zrusseznamsouboru}

procedure StromAdresaru(var cil:uknaauzel; cesta:pathstr);
{}procedure novyuzel(var kde:uknaauzel; njmeno:string);
{}Begin
{}new(kde);
{}with kde^ do begin
{}             jmeno:=njmeno;
{}             dalsi:=nil; obsah:=nil;
{}             end;
{}End;{novyuzel}
var sr:searchrec;
    pom:uknaauzel;
Begin
{vytvoreni seznamu adresaru:}
findfirst(cesta+'\*.*',anyfile-volumeid,sr);
while doserror=0 do
  begin
  if ((sr.attr and directory)<>0)and(sr.name[1]<>'.') then {je to adresar a neni to aktualni ani predchozi}
    {zarazeni do seznamu:}
    if cil=nil then begin
                    novyuzel(cil,sr.name);
                    pom:=cil;
                    end
               else begin
                    novyuzel(pom^.dalsi,sr.name);
                    pom:=pom^.dalsi;
                    end;
  findnext(sr);
  end;
{vyreseni podadresaru od kazdeho adresare v seznamu:}
pom:=cil;
while pom<>nil do begin
                  stromadresaru(pom^.obsah,cesta+'\'+pom^.jmeno);
                  pom:=pom^.dalsi;
                  end;
End;{stromadresaru}

procedure ZrusStromAdresaru(var ktery:uknaauzel);
var pom:uknaauzel;
Begin
while ktery<>nil do begin
                    zrusstromadresaru(ktery^.obsah);
                    pom:=ktery;
                    ktery:=ktery^.dalsi;
                    dispose(pom);
                    end;
ktery:=nil;
End;{zrusstromadresaru}

procedure HromadneAtributy(maska:pathstr; jake:word);
var sa:uknaauzel;
    PocatecniCesta:pathstr;{cesta do aktualniho adresare bez \ na konci}
{}procedure NastavJe(kde:uknaauzel; cesta:pathstr);
{}var f:file;
{}    sr2:searchrec;
{}Begin
{}while kde<>nil do begin
{}                  findfirst(cesta+'\'+kde^.jmeno+'\'+maska,anyfile,sr2);
{}                  while doserror=0 do begin
{}                                      assign(f,cesta+'\'+kde^.jmeno+'\'+sr2.name);
{}                                      setfattr(f,jake);
{}                                      findnext(sr2);
{}                                      end;
{}                  if kde^.obsah<>nil then nastavje(kde^.obsah,cesta+'\'+kde^.jmeno);
{}                  kde:=kde^.dalsi;
{}                  end;
{}End;{nastavje}
Begin{hromadneatributy}
getdir(0,pocatecnicesta);
if pocatecnicesta[length(pocatecnicesta)]='\' then dec(pocatecnicesta[0]);{odmazani \}
sa:=nil;
stromadresaru(sa,pocatecnicesta);
nastavje(sa,pocatecnicesta);
zrusstromadresaru(sa);
End;{hromadneatributy}

function Win9XAktivni:boolean; assembler;
Asm
mov AX,$4B21
int $2F
{jestli AH=0, tak jsou, takze staci ho znegovat a posunout do AL:}
not AX
shr AX,8
{cokoli nenuloveho je true}
End;{win9xaktivni}

procedure ZjistiVolneMisto(pd:char; var hodnota:longint; var jednotky:byte);
var _ax,_bx,_cx:word;
Begin
asm
mov DL,pd {pismeno disku}
mov AH,$36 {cislo sluzby "zjisti informace o velikosti disku"}
{pripadny prevod pismena na velke:}
cmp DL,'Z'       {je za 'Z'?}
jle @ok          {ne, takze uz je velke a nemusime ho prevadet}
 sub DL,'a'-'A'  {prevod z maleho na velke}
@ok:              {(pripadne nesmysly mimo abecedu neresim, neplatny disk by to byl tak jako tak)}
sub DL,64  {prevod z 'A'..neco na 1..neco}
int $21
mov _ax,AX  {bud kod chyby nebo pocet sektoru na cluster}
mov _bx,BX  {pocet volnych clusteru}
{kdybyste potrebovali zjistit velikost celeho disku, tak v DX je celkovy pocet clusteru}
mov _cx,CX  {pocet bytu na sektor}
end;
if _ax=$FFFF
  then begin {chyba, tenhle disk neexistuje}
       hodnota:=0;
       jednotky:=0;
       end
  else begin {OK}
       {celkova hodnota je AX*BX*CX, jenze to se u hodne velkych disku
       nevejde do longintu (ten pobere maximalne soucin dvou wordu a ne tri),
       tak musime nasobit postupne a upravovat jednotky:}
       jednotky:=1;
       hodnota:=_ax; {kdyz sem dame rovnou _ax*_bx, vysledek pretece,
                      protoze si ho prekladac ulozi do wordu - bacha na to!}
       hodnota:=hodnota*_bx;
       {pokud Hodnota pretekla do zaporna nebo je vetsi nez word, delime ji 1024:}
       while (hodnota<0)or(hodnota>$FFFF) do begin
                                             hodnota:=hodnota shr 10;
                                             inc(jednotky);
                                             end;
       {ted uz bude urcite dost mala na to, aby snesla druhy soucin:}
       hodnota:=hodnota*_cx;
       {tohle uz je spis jenom kosmeticka uprava, aby vychazela lidsky pochopitelna cisla:}
       while (hodnota<0)or(hodnota>10*1024) do begin
                                               hodnota:=hodnota shr 10;
                                               inc(jednotky);
                                               end;
       {kazdy z tech dvou cyklu mohl probehnout maximalne dvakrat, za terabyty se nedostaneme}
       end;
End;{zjistivolnemisto}

function pocetdisketovychmechanik:byte; assembler;
Asm
int $11
{xor AX,AX
mov ES,AX                    takhle by to slo taky, ale ten int
mov DI,$0410                 je uspornejsi a o rychlost nam nejde
mov AX,[ES:DI]}
{Ted mame v AX seznam hardwaru. Bit 0 rika, jestli mame aspon jednu flopacku.
Jestli jo, tak v bitech 6 a 7 je jejich pocet minus 1 (teoreticke maximum
jsou tedy 4 disketovky v jednom pocitaci).}
test AX,1       {aspon jedna?}
jz @zadna       {ne, vrat nulu}
 shr AX,6        {posun ty dva bity s poctem na nejnizsi pozici}
 and AX,3        {vynuluj vsechno ostatni}
 inc AX          {byl tam pocet-1, tak ho preved na skutecny pocet}
 jmp @konec
@zadna:
xor AX,AX
@konec:
{funkce vrati to, co je v AL}
End;{pocetdisketovychmechanik}

function ZjistiLogickeMapovani(pd:char):byte; assembler;
Asm
mov BL,pd
mov AX,$440E
cmp BL,'Z'
jle @ok
 sub BL,'a'-'A'
@ok:
sub BL,64   {aktualni=0, A=1, B=2 atd.}
int $21
jnc @vPoradku
 mov AL,255    {chybovy kod}
@vPoradku:
{vysledek je v AL}
End;{zjistilogickemapovani}

function DiskJeVymenitelny(PD:char):boolean; assembler;
Asm
mov AX,$4408
mov BL,pd
cmp BL,'Z'
jle @ok
 sub BL,'a'-'A'
@ok:
sub BL,64   {aktualni=0, A=1, B=2 atd.}
int $21
jc @chyba
 xor AX,1   {hlasi to presne obracene (1 pro nevymenitelny), takze to otocime}
 jmp @konec
@chyba:
xor AX,AX   {dejme tomu, ze false bude znamenat i chybu}
@konec:
End;{diskjevymenitelny}

procedure lRename(PuvodniJmeno,NoveJmeno:string); assembler;
Asm
xor AX,AX
xor BX,BX
push DS
{pridani #0 na konec puvodniho jmena:}
lds DI,puvodnijmeno {0. znak}
mov BL,[DS:DI] {delka jmena}
inc DI {1. znak}
mov [DS:DI+BX],AL {zakoncovaci #0}
mov DX,DI {ofset potrebujeme mit v DX (DI jsme pouzivali proto, ze DXem se neda adresovat)}
{to same pro nove jmeno:}
les DI,novejmeno
mov BL,[ES:DI]
inc DI
mov [ES:DI+BX],AL
{a jedeme:}
mov AX,$7156 {funkce "prejmenuj soubor s dlouhym jmenem"}
stc {CF:=1 (pojistka pro pripad, ze OS dlouha jmena nezvlada a int 21h CF nezmeni)}
int $21
sbb BX,BX {pri CF=0 (OK) vyjde 0, pri CF=1 (chyba) vyjde $FFFF. Na puvodni hodnote BX nezalezi.}
and AX,BX {v AX je navratovy kod, ale ten nas zajima jenom pri chybe}
{uklid a hlaseni:}
pop DS
mov doserror,AX {navratovy kod ulozime}
End;{lrename}

END.

{Jak urcit typ disku:
                      +------------------+---------------+------------------+
                      | Logicke mapovani |               |   Volne misto    |
                      |    (obvykle)     | Vymenitelnost | hodnota/jednotky |
+---------------------+------------------+---------------+------------------+
| disketa             |  0, 1 nebo 2     |     ano       |    neco/neco     |
+---------------------+------------------+---------------+------------------+
| fantomova disketa   | A<>1, B<>2 apod. |     ano       |   nepouzivat!    |
+---------------------+------------------+---------------+------------------+
| prazdna             |  0, 1 nebo 2     |     ano       |    neco/0        |
| disketova mechanika |                  |               |                  |
+---------------------+------------------+---------------+------------------+
| harddisk            |        0         |     ne        |    neco/neco     |
+---------------------+------------------+---------------+------------------+
| CD/DVD              |        0         |     ne        |       0/1        |
+---------------------+------------------+---------------+------------------+
| prazdna             |        0         |     ne        |    neco/0        |
| CD/DVD mechanika    |                  |               |                  |
+---------------------+------------------+---------------+------------------+
| USB disk            |        0         |     ano       |    neco/neco     |
+---------------------+------------------+---------------+------------------+
| neexistujici disk   |       255        |     ne        |    neco/0        |
+---------------------+------------------+---------------+------------------+}
