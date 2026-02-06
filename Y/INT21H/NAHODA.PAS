(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: NAHODA.PAS                                                     *)
(*  Obsah: ruzne funkce pracujici s nahodnymi cisly                        *)
(*         automaticka inicializace generatoru nahodnych cisel             *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 31.3.2008                                             *)
(*  Pro kompilaci: nic                                                     *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit Nahoda;
interface

function k(PocetSten:byte):byte;
{Virtualni hraci kostka. Vraci nahodna cisla v rozsahu 1..PocetSten.}
function kProc(Pravdepodobnost:byte):boolean;
{Procentova kostka. Vraci true, pokud se nahodnym cislem trefi do dane
Pravdepodobnosti (v procentech).}
function Rand(Dolni,Horni:word):word;
{Vraci nahodne cislo z intervalu Dolni..Horni (obe meze do intervalu patri).}
function LongRandom(rozsah:longint):longint;
{Navenek funguje stejne jako standardni Random, ale ma longintovy rozsah
(pracuje metodou puleni intervalu).}
function LongRand(dolni,horni:longint):longint;
{Obdobna jako Rand, ale s vetsim rozsahem.}

implementation

function k(pocetsten:byte):byte;
Begin
k:=random(pocetsten)+1;
End;{k}

function kProc(pravdepodobnost:byte):boolean;
Begin
kproc:=pravdepodobnost>=(random(100)+1);
End;{kproc}

function rand(dolni,horni:word):word;
Begin
rand:=random(horni-dolni+1)+dolni;
End;{rand}

function longrandom(rozsah:longint):longint;
var vysledek:longint;
Begin
vysledek:=0;
while rozsah>$FFFF do
  begin {dokud se rozsah nevejde do wordu...}
  rozsah:=rozsah div 2; {...rozpulime ho...}
  if random(2)=0 then inc(vysledek,rozsah);{...a nahodne vybereme, do ktere pulky se trefime}
  end;
inc(vysledek,random(rozsah)); {pricteme zbytek, ktery uz Random zvladne}
longrandom:=vysledek;
End;{longrandom}

function longrand(dolni,horni:longint):longint;
Begin
longrand:=longrandom(horni-dolni+1)+dolni;
End;{longrand}

BEGIN
randomize;
END.