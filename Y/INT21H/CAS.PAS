(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: CAS.PAS                                                        *)
(*  Obsah: stopky (presnost na sekundy)                                    *)
(*         procedury pro cekani nebo mereni casu (presnost volitelna)      *)
(*         moznost nastaveni vlastni procedury tak, aby bezela v pozadi    *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*         M. Palms: timer                                                 *)
(*         M. Milda: prace s prerusenim, zrychleni casovace                *)
(*  Posledni uprava: 29.7.2007                                             *)
(*  Pro kompilaci: (DOS.TPU)                                               *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Cas;
{$R-}

interface

type
Timer = object
        stopped:boolean;{stopky zastaveny?}
        konec,zbyva:longint;{systemovy cas prevedeny na sekundy, nesahat}
        procedure init(time:longint);{vynuluje a spusti stopky (time je v sekundach)}
        function read:longint;{precte zbyvajici cas}
        procedure stop;{zastavi stopky}
        procedure restart;{znovu spusti stopky od mista zastaveni}
        end;
{jednoduche stopky, ktere vyuzivaji pouze standardni funkce a nejsou zavisle
 na zbytku jednotky}


(****************************************************************************)

{Pozn.: v hranatych zavorkach za hlavickami procedur a funkci jsou uvedeny
registry, ktere ta procedura ovlivnuje. Pokud neni uvedeno nic, je to tim,
ze je procedura psana v Pascalu a ne v Asm, takze o registrech nic nevime.}

procedure StartCekani;{[nic]}
{zacne pocitat cas}
procedure Pockej(doba:word);
{Ceka zadanou dobu od pocatecniho casu. Parametr doba je v ms.
Vlastne to same jako Delay, ale neceka se od zacatku procedury Pockej, ale od
zavolani procedury StartCekani. Pokud Startcekani nebyl zavolan, vola se na
zacatku procedury Pockej automaticky (a pak je to opravdu presne to same jako
Delay).}
function DosazenCas(doba:word):boolean;{[AX,BX]}
{vraci true v pripade, ze od prikazu startcekani ubehl zadany pocet milisekund}
procedure StopCekani;{[nic]}
{zastavi pocitani casu (milisekundy prestanou pribyvat)}
function GetMS:word;{[AX]}
{vrati hodnotu interni promenne ms (milisekundy nastradane od posledniho
volani procedury Startcekani)}

{Pokud potrebujete upravit presnost casomiry, udelejte to pomoci konstant
uvedenych hned za Implementation.}

procedure NastavProceduruNaPozadi(Procedura:pointer; JakCasto:word);
{Necha na pozadi programu bezet danou proceduru.
 Procedura - adresa procedury, ktera se ma volat (napr. addr(nejaka_proc)).
             Musi byt deklarovana jako FAR (procedure nejaka_proc; far; ...
             nebo direktiva $F+), nesmi mit zadne parametry a nesmi volat
             zadne preruseni (int, intr apod.) ani jinou proceduru, ktera by
             nejake preruseni volala! Taky pozor na grafiku - jestli procedura
             na pozadi zmeni banku a v popredi zrovna bezi nejake kresleni,
             bude z toho docela paseka.
 JakCasto - po kolika milisekundach se ma volat. Toto cislo musi byt vetsi nez
            nebo rovne hodnote Deltams (viz konstanty za Implementation),
            jinak ji preruseni nebude stihat volat, po nejake dobe podtece
            pocitadlo a procedura se cca na minutu prestane volat uplne.}
procedure ZrusProceduruNaPozadi;
{Timhle nastavenou proceduru odinstalujete}

{****************************************************************************}

{Na co je to vsechno vlastne dobre:

begin
 repeat                              Takhle by rychlost provadeni
 dlouha_posloupnost_prikazu;         cyklu zavisela na rychlosti
 delay(60);                          procesoru.
 until nejaka_podminka;
end;

begin
 repeat                              Takhle na ni nezavisi.
 startcekani;
 dlouha_posloupnost_prikazu;
 pockej(60);
 until nejaka_podminka;
end;


Dalsi priklad pouziti:

begin
startcekani;
Nejake_Prikazy;
stopcekani;
writeln('Provedeni Nejakych_Prikazu trvalo presne ',getms,' milisekund.');
end;

nebo:

procedure hodiny; far;
Begin
gotoxy(1,1);
write(...aktualni cas, nejak si to predstavte...);
End;
...
begin
NastavProceduruNaPozadi(@Hodiny,1000);
...ted se nam kazdou sekundu automaticky aktualizuje cas na obrazovce...
ZrusProceduruNaPozadi;
end;}

implementation
uses dos;

{Hodnoty zrychleni casovace (nechte aktivni to, co se vam nejvic hodi):}

const {rychlost=1;  deltams=55; {bez zrychleni - tohle asi nevyuzijete, ale pro jistotu at tu je}
      rychlost=11; deltams=5;  {celkem rozumne zrychleni pro bezne pouziti}
      {rychlost=20; deltams=3;  {trochu rychlejsi, ale milisekundy nenabihaji zrovna nejpresneji}
      {rychlost=55; deltams=1;  {maximalni rychlost, kterou tahle jednotka zvlada}
{Vyberte si vhodnou rychlost, ostatni nechte zakomentovane. Rychlost rika,
kolikanasobne se casovac zrychli. Deltams je interval volani preruseni v
milisekundach (tisicinach sekundy), zaroven udava maximalni absolutni chybu
mereni. Nekombinujte hodnoty z ruznych radku, vychazely by pak kraviny.

Instalace a odinstalace preruseni je plne automaticka, staci jednotku pouzit.
Kdyz je nove preruseni 8 nainstalovano, navenek se nijak neprojevi (vsechno
bezi normalne, systemovy cas vam nerozhodi).
Pozor je treba davat na to, jestli nepouzivate nejakou dalsi jednotku, ktera
si take zrychluje casovac - mohlo by dojit ke kolizim!}

var puvodni8:procedure;{puvodni procedura z preruseni 8}
    PuvodniExitproc:pointer;{ukazatel na puvodni ukoncovaci proceduru}
    counter:word;{pocita, kdy se ma spustit puvodni preruseni 8 (kvuli zrychlenemu casu)}
    ms:word;{milisekundy, ktere ubehly od zavolani procedury StartCekani}
    CekaSe:boolean;{pocita se cas?}
    JePozadi:boolean;{je nainstalovana uzivatelska procedura na pozadi?}
    ProcNaPoz:procedure;{adresa teto procedury}
    interval:word;{jak casto se vola?}
    counter2:word;{pocita, kdy ji mame zavolat}

procedure speedup(sp:word);{zrychli systemovy cas (nasobi puvodni rychlost hodnotou sp)}
Begin                      {speedup(1) vrati rychlost na puvodni hodnotu}
sp:=65536 div sp;
port[$43]:=$34;
port[$40]:=lo(sp);
port[$40]:=hi(sp);
End;{speedup}

procedure nova8; interrupt; assembler; {procedura, ktera bezi v pozadi a stara se o pocitani casu}
Asm
{vyrizeni pribyvani milisekund v promenne ms:}
mov AL,cekase
or AL,AL
jz @NecekaSe
 add ms,deltams  {deltams je konstanta}
@NecekaSe:
{vyreseni volani puvodni obsluhy preruseni:}
dec counter
jnz @NicSeNedeje
 mov AX,rychlost
 mov counter,AX
 pushf
 call puvodni8
@NicSeNedeje:
{vyreseni volani uzivatelske procedury bezici na pozadi:}
mov AL,jepozadi
or AL,AL
jz @ZadnaNeni
 sub counter2,deltams
 jg @JesteNe {jestli je counter2 porad kladny, nic se zatim nedeje}
  mov AX,interval
  add counter2,AX
  call procnapoz
 @JesteNe:
@ZadnaNeni:
{reset radice preruseni (nutna vec na konci kazdeho preruseni):}
mov AL,$20
out $20,AL    {takhle se to proste dela, neptejte se proc :-)}
End;{nova8}

procedure startcekani; assembler;
Asm
mov ms,0
mov cekase,true
End;{startcekani}

procedure pockej(doba:word);
Begin
if not cekase then startcekani;
 repeat until ms>=doba;{o promennou ms se stara preruseni, ktere bezi v pozadi}
cekase:=false;
End;{pockej}

function DosazenCas(doba:word):boolean; assembler;
Asm
mov BL,cekase
mov AX,1 {= true}
or BL,BL
jz @ano
 mov BX,ms
 cmp BX,doba
 jge @ano
  xor AX,AX {= false}
@ano:
{bez Asm by to vypadalo takhle:
 dosazencas:=(not cekase)or(ms>=doba);}
End;{dosazencas}

procedure StopCekani; assembler;
Asm
mov cekase,false
End;{stopcekani}

function GetMS:word; assembler;
Asm
mov AX,ms
End;{getms}

procedure NastavProceduruNaPozadi(Procedura:pointer; JakCasto:word);
Begin
@procnapoz:=procedura;
interval:=jakcasto;
counter2:=interval;
jepozadi:=true;
End;{nastavprocedurunapozadi}

procedure ZrusProceduruNaPozadi;
Begin
jepozadi:=false;
End;{zrusprocedurunapozadi}

procedure novaExitproc; far; {tohle se automaticky zavola pri skonceni programu (Exitproc - viz help)}
Begin
exitproc:=puvodniexitproc;{do ukazatele na standardni ukoncovaci proceduru
          vratime puvodni adresu, kterou jsme si na zacatku programu ulozili}
asm cli end;{zakaz asynchronnich preruseni}
speedup(1);{vraceni rychlosti casovace na puvodni hodnotu}
setintvec(8,@puvodni8);{vraceni puvodni procedury preruseni}
asm sti end;{povoleni asynchronnich preruseni}
End;{novaexitproc}

function zjisticas:longint;{pro Timer}
var ye,mo,da,ho,mi,se,nanic:word;
Begin
getdate(ye,mo,da,nanic); gettime(ho,mi,se,nanic);
zjisticas:=((((longint(ye-1980)*12+mo)*31+da)*24+ho)*60+mi)*60+se;
End;{zjisticas}

procedure timer.init(time:longint);
Begin
stopped:=false;
zbyva:=time;
konec:=zjisticas+time;
End;{timer.init}

function timer.read:longint;
Begin
if stopped then read:=zbyva
           else read:=konec-zjisticas;
End;{timer.read}

procedure timer.stop;
Begin
if not stopped then zbyva:=konec-zjisticas;
stopped:=true;
End;{timer.stop}

procedure timer.restart;
Begin
if stopped then konec:=zjisticas+zbyva;
stopped:=false;
End;{timer.restart}

BEGIN
jepozadi:=false; counter:=rychlost; cekase:=false;{inicializace promennych}
puvodniExitproc:=exitproc;{ulozeni standardni ukoncovaci procedury}
exitproc:=@novaExitproc;{vlozeni vlastni ukoncovaci procedury}
asm cli end;{aby se to preruseni nespoustelo zatimco ho instalujeme}
getintvec(8,@puvodni8);{ulozeni puvodni procedury z preruseni 8}
setintvec(8,@nova8);{nastaveni nove procedury pro preruseni}
speedup(rychlost);{zrychleni systemoveho casu (normalne tika po 55 ms)}
asm sti end;{povoleni preruseni}
END.