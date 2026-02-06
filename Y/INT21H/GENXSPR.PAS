(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: GENXSPR.PAS                                                    *)
(*  Obsah: sada procedur pro tvorbu datovych souboru pro objekt Xsprite    *)
(*         z jednotky XMS                                                  *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 17.2.2012                                             *)
(*  Pro kompilaci: nic                                                     *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit GenXspr;

interface

procedure PripravSpritovySoubor(JmenoSouboru:string);
{Otevre (pripadne prepise) dany soubor a inicializuje si interni promenne.
Tuhle proceduru zavolejte jednou na zacatku.
POZOR: v jednu chvili muze byt otevren jenom jeden soubor! Nijak se to
automaticky nekontroluje, tak si to hlidejte, jinak bude zle.}
procedure UlozSprite(ktery:pointer);
{Do pripraveneho souboru ulozi dany sprite. Lze volat jedine kdyz mame
pripraveny soubor. Pocet spritu v jednom souboru je omezen jenom rozsahem
typu Word, celkova velikost maximalni velikosti alokovatelneho bloku XMS.}
procedure DokonciSpritovySoubor;
{Zapise do souboru hlavicku a zavre ho. Velice dulezita vec - bez hlavicky
by soubor nesel nacist. Tuto proceduru zavolejte jednou na konci, kdyz mate
vsechny sprity vyrizene.
Dalsim pouzitim Pripravspritovysoubor si muzete otevrit novy soubor
a ukladat dal.}

{Uspesnost vsech tri procedur se testuje klasicky Ioresultem (nebo jestli mate
zapnutou automatickou kontrolu I/O operaci ($I+), program spadne).}

implementation

type HlavickaXspritu = record {data na zacatku souboru}
                       Pocet, {pocet spritu v tomto souboru}
                       CelkovaVelikost, {celkova velikost vsech spritu [KB]}
                       MaxVelikost:word; {velikost nejvetsiho z nich [B]}
                       end;

var HXS:hlavickaxspritu;
    Sprity:file; {soubor, do ktereho budeme sprity ukladat}
    CelkVelLong:longint; {celkova velikost vsech spritu [B]}

procedure PripravSpritovySoubor(JmenoSouboru:string);
Begin
assign(sprity,jmenosouboru);
rewrite(sprity,1);
fillchar(hxs,sizeof(hxs),0);
celkvellong:=0; {zatim nic}
blockwrite(sprity,hxs,sizeof(hxs)); {tohle je jenom kvuli posunuti kurzoru za hlavicku,
 na zaver se sem jeste vratime a zapiseme smysluplne hodnoty}
End;{pripravspritovysoubor}

procedure UlozSprite(ktery:pointer);
Begin
inc(hxs.pocet); {pridavame jeden sprite, takze zvysime pocet o 1}
inc(celkvellong,word(ktery^)); {jeho velikost pridame k celkove sume}
if word(ktery^)>hxs.maxvelikost then hxs.maxvelikost:=word(ktery^); {pripadne upravime maximum, pokud je tenhle vetsi}
blockwrite(sprity,ktery^,word(ktery^)); {a zapiseme sprajt do souboru}
End;{ulozsprite}

procedure DokonciSpritovySoubor;
Begin
hxs.celkovavelikost:=(celkvellong+1023) div 1024; {zaokrouhleni nahoru na cele KB}
if odd(hxs.maxvelikost) then inc(hxs.maxvelikost);
seek(sprity,0); {navrat na zacatek souboru}
blockwrite(sprity,hxs,sizeof(hxs)); {zapis hlavicky ve finalni podobe}
close(sprity); {a to je vsechno}
End;{dokoncispritovysoubor}

END.

{Format souboru:

 pocet spritu v souboru, minimalne 1 (word)
 soucet velikosti vsech spritu [KB], zaokrouhleno nahoru na cele KB (word)
 velikost nejvetsiho spritu [B], zaokrouhleno nahoru na sude cislo (word)
 sprity, naskladane jeden za druhym

Format spritu je popsan v jednotkach VESA a Images.}
