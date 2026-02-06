(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: UMAC3.PAS                                                      *)
(*  Obsah: procedury pro praci s grafickymi soubory *.MAC                  *)
(*  Posledni uprava: 17.11.2010                                            *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Pro kompilaci: VESA.TPU, CAS.TPU, KLAVESY.TPU, MATYKA.TPU              *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit uMAC3;
{$R-,I-} {dulezite}

{Cilem bylo vytvorit takovy format grafiky, ktery by umoznoval zobrazovat
jak staticke obrazky, tak animace, a ktery by zabiral na disku i v pameti
co nejmene mista. Format *.MAC je vysledek. Tyto soubory se tvori editorem
Mircosoft AlmostCAD (proto ta koncovka :-) ).

Vykres ulozeny v souboru sestava z jednoho nebo vice bloku. Blok je
posloupnost prikazu ke kresleni ruznych elementarnich grafickych prvku nebo
k rizeni animace (cekani atd.). Blok muze byt i prazdny.
Podrobny popis struktury souboru *.MAC je na konci teto jednotky.

Tato jednotka umoznuje soubory MAC nacitat a zobrazovat (ukladani by bylo
celkem k nicemu - editor pouziva jiny format dat).}

interface
uses vesa;

(*************** usek, ktery neni treba cist ani chapat: ********************)

const
{podporovane graficke prvky:                              odpovida procedure:    z jednotky: }
kbod          =1;{pixel                                       __putpixel          VESA}
kcara         =2;{plna cara                                   __line              VESA}
kmcara        =3;{maskovana cara (treba prerusovana)          __maskedline        VESA}
krectangle    =4;{obdelnik (obrys)                            __rectangle         VESA}
kbar          =5;{vyplneny obdelnik                           __bar               VESA}
kmbar         =6;{maskovany obdelnik (treba pruhovany apod.)  __maskedbar         VESA}
kbox          =7;{obdelnik s okrajem                          __box               VESA}
 {maskedbar a box se nedaji otocit (pri nenulovem uhlu natoceni se nezobrazi)}
ktrojuhelnik  =8;{vyplneny trojuhelnik                        __filledtriangle    VESA}
kctyruhelnik  =9;{vyplneny obecny ctyruhelnik                 2*__filledtriangle  VESA}
kelipsa       =10;{prazdna elipsa                             __ellipse           VESA}
kpelipsa      =11;{vyplnena elipsa                            __filledellipse     VESA}
 {elipsy se pri otoceni zobrazi, ale neotoci (stred elipsy se sice otoci kolem
  pocatku souradnic, ale elipsa zustane orientovana porad stejne)}
ktext         =12;{radek textu                                _print              VESA}
 {pri otoceni dopadne text podobne jako elipsy}
kkresliblok   =13;{povel k nakresleni celeho bloku prvku      kresliblok          uMAC3 (lokalni)}
klsmycka      =14;{nakresleni bloku v cyklu                   kresliblok vickrat  uMAC3 (lokalni)}
 {cislo 15 je umyslne ponechano volne pro pripadne budouci rozsireni}
{pomocne prvky (prikazy pro animace):}
kstartcekani  =16;{povel pro zaznamenani casu                 startcekani         Cas}
kcekani       =17;{povel pro cekani                           pockej              Cas}
kstrankovani  =18;{zapni nebo vypni strankovani pro animace   _nastavstrankovani  VESA}
kswap         =19;{zobrazi virtualni obrazovku                _swap               VESA}
kresetstranek =20;{vrati stranky do nuly (defaultni situace)  _resetstrankovani   VESA}
kstartanimace =21;{kombinace kstrankovani+kstartcekani}
kkonecramecku =22;{kombinace kcekani+kswap+kstartcekani}

type
{pomocne typy:}
tbod = record x,y:integer; barva:byte; end; {pro kbod}
tcara = record x1,y1,x2,y2:integer; barva:byte; end; {kcara, krectangle, kbar}
tmbar = record x1,y1,x2,y2:integer; barva:word; vzorek:_pole8bytu; end; {kmbar}
tmcara = record x1,y1,x2,y2:integer; barva:byte; maska:word; end; {kmcara}
tbox = record x1,y1,x2,y2:integer; lhbarva,pdbarva,vbarva:byte; end; {kbox}
ttrojuhelnik = record x1,y1,x2,y2,x3,y3:integer; barva:byte; end; {ktrojuhelnik}
tctyruhelnik = record x1,y1,x2,y2,x3,y3,x4,y4:integer; barva:byte; end; {kctyruhelnik}
telipsa = record x,y:integer; rx,ry:word; barva:byte; end; {kelipsa, kpelipsa}
ttext = record x,y:integer; velikostx,velikosty,roztec:byte; barva:byte; obsah:string; end; {ktext}
tkresliblok = record x,y:integer; cislo,meritko:word; kolikrat:byte; uhel:integer; end; {kkresliblok}
                       {uhel je ve stupnich, + je po smeru hodinovych rucicek}
tlsmycka = record x0,y0,uhel0,qx,qy,quhel,qmeritko:integer; cislo,meritko0,tmax:word; kolikrat:byte; end; {klsmycka}
   {parametr t se zvysuje od 0 po 1 do tmax a v kazdem kroku se vykresli blok
    daneho cisla na souradnicich x=x0+qx*t,y=y0+qy*t (obdobne meritko a uhel).}
{tstartcekani je prazdny}    {kstartcekani}
tcekani = {doba:}word;       {kcekani, kkonecramecku}
{tstrankovani je prazdny}    {kstrankovani}
{tswap taky}                 {kswap}
{tresetstranek taky}         {kresetstranek}
{tstartanimace taky}         {kstartanimace}

{nezbytne ukazatele:}
ubod=^tbod;
ucara=^tcara;
umcara=^tmcara;
umbar=^tmbar;
ubox=^tbox;
utrojuhelnik=^ttrojuhelnik;
uctyruhelnik=^tctyruhelnik;
uelipsa=^telipsa;
utext=^ttext;
ukresliblok=^tkresliblok;
ulsmycka=^tlsmycka;
ucekani=^tcekani;

{prvek je abstraktni datova struktura, ktera zacina identifikacnim bytem,
ktery urcuje jeho typ, a pokracuje daty, ktera jsou na tom typu zavisla}

polebytu = array[0..0] of byte;{prvky v nem budou nasypane jeden za druhym,
        pristupovat se k nim bude pres vhodne pretypovany ukazatel na adresu
        prislusneho bytu pole. Rozsah 0..0 muze byt, protoze je vypnuta
        kontrola rozsahu ($R-). Takze do pole muzu psat kam chci a je uplne
        jedno, jak bude ve skutecnosti velke (hlavne kdyz je alokovane).}
uknapolebytu = ^polebytu;{pole budou dynamicka, takze potrebujeme nejaky ukazatel}

blok = record
       prvky:uknapolebytu;{ukazatel na dynamicke pole s prvky}
       velikost:word;{velikost tohoto pole v B (kazdy prvek je jinak velky,
                      proto by jakykoli udaj o jejich poctu byl k nicemu)}
       end;

polebloku = array[0..0] of blok;
uknapolebloku = ^polebloku;

{Editor uklada vykresy jako spojove seznamy, ktere sice zabiraji mnohem vic
pameti nez zde pouzita dynamicka pole, ale jejich polozky se narozdil od poli
daji pridavat, mazat a upravovat.}


(*********************** typ, ktery potrebujete: ****************************)

MAC = record {vykres}
      bloky:uknapolebloku;{pole bloku (dynamicke)}
      pocetbloku:word;{typ Blok uz ma konstantni velikost, takze tohle jde}
      end;

(*********************** procedury, ktere potrebujete: **********************)

procedure NactiMAC(var ktery:MAC; var F:file);
{Nacte strukturu typu MAC ze souboru F, ktery musi byt otevreny pro cteni
s velikosti bloku 1 B (reset(f,1);) a musi mit kurzor pripraveny na spravnem
miste (lze pouzit pro nacitani ze souboru, ktere krome MAC obrazku obsahuji i
jine veci). Pokud nekde pri cteni nastane chyba, tak se bud nenacte nic (kdyz
se chyba stane hned na zacatku) nebo se nactou jenom nektere bloky (kdyz se
chyba stane pozdeji). Program kvuli tomu nespadne a Ioresult zustava 0.}
procedure NactiMAC2(var ktery:MAC; soubor:string);
{Totez, ale staci zadat jmeno souboru (i s koncovkou); procedura si ho otevre,
nacte obrazek a zase ho zavre (urceno pro nacitani ze souboru *.MAC, ktere nic
jineho nez jeden obrazek neobsahuji). Zavazne chyby (soubor neexistuje, bylo
zadano neplatne jmeno apod.) po skonceni procedury odhalite Ioresultem, mensi
chyby vznikle pri cteni muzou opet zpusobit, ze nebude nactene vsechno.}
procedure ZrusMAC(var ktery:MAC);
{Vymaze obsah vykresu Ktery z pameti, ukazatel Ktery.bloky nastavi na nil
a hodnotu Ktery.pocetbloku na 0. Spravne osetri i neuplne nactene obrazky.}
procedure KresliMAC(var ktery:MAC; odkud:word; naX,naY:integer; vMeritku:word; vUhlu:integer);
{Zobrazi MAC strukturu. Pokud obsahuje nejake texty, vypisi se aktualne
nastavenym fontem, velikost a roztec si nastavi vlastni. Pokud obsahuje nejake
cekani (v animacich), da se stiskem klavesy Escape vynechat (vsechny faze
animace se vykresli, ale bez cekani). Klavesou F10 se kresleni ukonci (takze
se nejspis nevykresli vsechno). Pokud si ale tuto promennou:                  }
const PovolitKlavesy:boolean=true;                                            {
nastavite na false, pak budou veskere vstupy z klavesnice ignorovany
(a klavesnice nebude nijak ovlivnena), vykresli se vzdy a spolehlive vsechno
a nepujde to nijak prerusit. Pozor, ze pokud je tato promenna true, resetuje
se buffer klavesnice pred a po kazdem volani procedury Kreslimac!
 odkud - cislo bloku, ktery se ma kreslit. Cislovany jsou od 0.
 naX,naY - souradnice, na ktere se vykres nakresli
 vMeritku - meritko v % (100 = normalni; pri mensich se nemusi zobrazit texty)
 vUhlu - uhel natoceni ve stupnich, kladny je po smeru hodinovych rucicek,
         obvykle 0. Ne vsechny typy grafickych objektu se daji otocit.
Pri chybne zadanych parametrech (neexistuje blok s danym cislem apod.) se
nekresli nic.}
procedure PrebijBarvou(Touto:byte);
{Pri pristim volani procedury Kreslimac se cely vykres vykresli Touto barvou,
kterou jste nyni urcili. Vhodne napr. pro mazani objektu nakreslenych na
jednobarevnem pozadi. Ucinek je jednorazovy, tj. ovlivni pouze jedno volani
procedury Kreslimac. Potom uz se bude kreslit zase normalne.}

{procedure UlozMAC(var ktery:MAC; soubor:string);
{Ulozi MAC strukturu do souboru. Parametr Soubor je cele jmeno vysledneho
souboru i s koncovkou. Vyrazeno z provozu pro naprostou zbytecnost (editor
pouziva jiny format dat).}

implementation
uses cas,{kvuli cekani pri animacich}
     klavesy2,{aby sla animace prerusit stisknutim escapu nebo F10}
     nfsup;{kvuli rychlemu celociselnemu sinu a cosinu}

const PrebijeciBarva:word=$FFFF;{barva, kterou se daji prebit veskere barvy
    vykresu (word proto, aby se nejakou hodnotou vetsi nez jaka se vejde do
    bytu dalo rict, ze se nic prebijet nema)}

procedure kresliMAC(var ktery:MAC; odkud:word; naX,naY:integer; vMeritku:word; vUhlu:integer);
var cekat:boolean;
    pmk:word;
{}procedure kresliblok(jaky:word; ussx,ussy:integer; M:word; fi:integer);
{}var ukazatel:pointer;{pro cteni prvku z pole}
{}    pozice:word;{pro pohyb v poli}
{}    i:byte; t:word; {pomocne}
{}    sinfi,cosfi:longint;{sinus a cosinus uhlu (tyto hodnoty je treba delit 10000)}
{}{}function pocitejX(puvodniX,puvodniY:integer):integer;
{}{}Begin
{}{}if fi=0 then pocitejx:=longint(puvodnix)*M div 100+ussx
{}{}        else pocitejx:=((cosfi*puvodnix-sinfi*puvodniy)div 10000)*M div 100+ussx;
{}{}End;{pocitejx}
{}{}function pocitejY(puvodniX,puvodniY:integer):integer;
{}{}Begin
{}{}if fi=0 then pocitejy:=longint(puvodniy)*M div 100+ussy
{}{}        else pocitejy:=((sinfi*puvodnix+cosfi*puvodniy)div 10000)*M div 100+ussy;
{}{}End;{pocitejy}
{}{}function b(puvodni:byte):byte;
{}{}Begin
{}{}if prebijecibarva>$FF then b:=puvodni
{}{}                      else b:=prebijecibarva;
{}{}End;{b}
{}Begin
{}if fi<>0 then begin sinfi:=rychlysin(fi); cosfi:=rychlycos(fi); end;
{}if (ktery.bloky<>nil)and(ktery.pocetbloku>jaky) then with ktery.bloky^[jaky] do
{} begin
{} pozice:=0;{na prvni byte pole}
{}  while pozice<velikost do{dokud nejsme na konci pole}
{}    begin
{}    if povolitklavesy and keypressed then case xreadkey of 27:cekat:=false;
{}                                                           xF10:exit;
{}                                                           end;
{}    ukazatel:=@prvky^[pozice+1];{ukazatel ted ukazuje na data za identifikacnim bytem...}
{}    case prvky^[pozice] of{...a pozice udava pozici identifikacniho bytu, podle ktere zjistime,}
{}     kbod:begin                                             { na co se musi ukazatel pretypovat}
{}          with ubod(ukazatel)^ do __putpixel(pocitejx(x,y),pocitejy(x,y),b(barva));
{}          inc(pozice,sizeof(tbod));{presun Pozice pred identifikacni byte nasledujiciho prvku}
{}          end;
{}     kcara:begin
{}           with ucara(ukazatel)^ do __line(pocitejx(x1,y1),pocitejy(x1,y1),
{}                                           pocitejx(x2,y2),pocitejy(x2,y2),b(barva));
{}           inc(pozice,sizeof(tcara));
{}           end;
{}     kmcara:begin
{}            with umcara(ukazatel)^ do __maskedline(pocitejx(x1,y1),pocitejy(x1,y1),
{}                                                   pocitejx(x2,y2),pocitejy(x2,y2),b(barva),maska);
{}            inc(pozice,sizeof(tmcara));
{}            end;
{}     krectangle:begin
{}                with ucara(ukazatel)^ do
{}                  if fi=0 then __rectangle(pocitejx(x1,y1),pocitejy(x1,y1),
{}                                           pocitejx(x2,y2),pocitejy(x2,y2),b(barva)) {normalni}
{}                          else begin {otoceny}
{}                               __line(pocitejx(x1,y1),pocitejy(x1,y1),pocitejx(x2,y1),pocitejy(x2,y1),b(barva));
{}                               __line(pocitejx(x1,y1),pocitejy(x1,y1),pocitejx(x1,y2),pocitejy(x1,y2),b(barva));
{}                               __line(pocitejx(x2,y1),pocitejy(x2,y1),pocitejx(x2,y2),pocitejy(x2,y2),b(barva));
{}                               __line(pocitejx(x1,y2),pocitejy(x1,y2),pocitejx(x2,y2),pocitejy(x2,y2),b(barva));
{}                               end;
{}                inc(pozice,sizeof(tcara));
{}                end;
{}     kbar:begin
{}          with ucara(ukazatel)^ do
{}            if fi=0 then __bar(pocitejx(x1,y1),pocitejy(x1,y1),pocitejx(x2,y2),pocitejy(x2,y2),b(barva))
{}                    else begin
{}                         __filledtriangle(pocitejx(x1,y1),pocitejy(x1,y1),
{}                                          pocitejx(x1,y2),pocitejy(x1,y2),
{}                                          pocitejx(x2,y1),pocitejy(x2,y1),b(barva));
{}                         __filledtriangle(pocitejx(x1,y2),pocitejy(x1,y2),
{}                                          pocitejx(x2,y1),pocitejy(x2,y1),
{}                                          pocitejx(x2,y2),pocitejy(x2,y2),b(barva));
{}                         end;
{}          inc(pozice,sizeof(tcara));
{}          end;
{}     kmbar:begin
{}           if fi=0 then with umbar(ukazatel)^ do __maskedbar(pocitejx(x1,y1),pocitejy(x1,y1),
{}                                                             pocitejx(x2,y2),pocitejy(x2,y2),b(barva),vzorek);
{}           inc(pozice,sizeof(tmbar));
{}           end;
{}     kbox:begin
{}          if fi=0 then with ubox(ukazatel)^ do __box(pocitejx(x1,y1),pocitejy(x1,y1),
{}                                                     pocitejx(x2,y2),pocitejy(x2,y2),b(lhbarva),b(pdbarva),b(vbarva));
{}          inc(pozice,sizeof(tbox));
{}          end;
{}     ktrojuhelnik:begin
{}                  with utrojuhelnik(ukazatel)^ do __FilledTriangle(pocitejx(x1,y1),pocitejy(x1,y1),
{}                                                                   pocitejx(x2,y2),pocitejy(x2,y2),
{}                                                                   pocitejx(x3,y3),pocitejy(x3,y3),b(barva));
{}                  inc(pozice,sizeof(ttrojuhelnik));
{}                  end;
{}     kctyruhelnik:begin
{}                  with uctyruhelnik(ukazatel)^ do begin
{}                                                  __FilledTriangle(pocitejx(x1,y1),pocitejy(x1,y1),
{}                                                                   pocitejx(x2,y2),pocitejy(x2,y2),
{}                                                                   pocitejx(x3,y3),pocitejy(x3,y3),b(barva));
{}                                                  __FilledTriangle(pocitejx(x1,y1),pocitejy(x1,y1),
{}                                                                   pocitejx(x3,y3),pocitejy(x3,y3),
{}                                                                   pocitejx(x4,y4),pocitejy(x4,y4),b(barva));
{}                                                  end;
{}                  inc(pozice,sizeof(tctyruhelnik));
{}                  end;
{}     kelipsa:begin
{}             with uelipsa(ukazatel)^ do __Ellipse(pocitejx(x,y),pocitejy(x,y),
{}                                                  longint(rx)*M div 100,longint(ry)*M div 100,b(barva));
{}             inc(pozice,sizeof(telipsa));
{}             end;
{}     kpelipsa:begin
{}              with uelipsa(ukazatel)^ do __filledEllipse(pocitejx(x,y),pocitejy(x,y),
{}                                                         longint(rx)*M div 100,longint(ry)*M div 100,b(barva));
{}              inc(pozice,sizeof(telipsa));
{}              end;
{}     ktext:begin
{}           with utext(ukazatel)^ do begin
{}                                    __velikostx:=velikostx*M div 100; {nastaveni textu je treba rozepsat, protoze}
{}                                    __velikosty:=velikosty*M div 100; {procedura _nastavtext bere nulove hodnoty }
{}                                    __roztec:=word(roztec)*M div 100; {jako povel "nech nastavenou minulou hodnotu"}
{}                                    pmk:=_meritkokodu;
{}                                    _meritkokodu:=M;
{}                                    _print(pocitejx(x,y),pocitejy(x,y),b(barva),obsah);
{}                                    _meritkokodu:=pmk;
{}                                    end;
{}           inc(pozice,9+prvky^[pozice+9]);{text muze byt ruzne dlouhy. Byte prvky^[pozice+9]  }
{}                                          {     je nulty znak retezce, ktery udava jeho delku.}
{}           end;
{}     kkresliblok:begin
{}                 with ukresliblok(ukazatel)^ do for i:=1 to kolikrat do kresliblok(cislo,pocitejx(x,y),pocitejy(x,y),
{}                                                                                   longint(M)*meritko div 100,uhel+fi);
{}                 inc(pozice,sizeof(tkresliblok));
{}                 end;
{}     klsmycka:begin
{}              with ulsmycka(ukazatel)^ do
{}                for t:=0 to tmax do
{}                 for i:=1 to kolikrat do kresliblok(cislo,pocitejx(x0+qx*t,y0+qy*t),pocitejy(x0+qx*t,y0+qy*t),
{}                                                    longint(M)*(meritko0+qmeritko*t) div 100,uhel0+quhel*t+fi);
{}              inc(pozice,sizeof(tlsmycka));
{}              end;
{}     kstartcekani:startcekani;
{}     kcekani:begin
{}             if cekat then pockej(ucekani(ukazatel)^);
{}             inc(pozice,sizeof(tcekani));
{}             end;
{}     kstrankovani:_nastavstrankovani;
{}     kswap:_swap;
{}     kresetstranek:_resetstrankovani;
{}     kstartanimace:begin
{}                   _nastavstrankovani;
{}                   startcekani;
{}                   end;
{}     kkonecramecku:begin
{}                   if cekat then pockej(ucekani(ukazatel)^);
{}                   _swap;
{}                   startcekani;
{}                   inc(pozice,sizeof(tcekani));
{}                   end;
{}     end;{case}
{}    inc(pozice);
{}    end;{while}
{} end;{with}
{}End;{kresliblok}
Begin{kreslimac}
with ktery do if (pocetbloku=0)or(bloky=nil)or(odkud>=pocetbloku) then exit; {kdyz neni co kreslit, koncime}
if povolitklavesy then kresetuj;
cekat:=true;
_pushtext; pmk:=_meritkokodu; {pro pripad, ze by se pri kresleni zmenilo nastaveni textu}
kresliblok(odkud,nax,nay,vmeritku,vuhlu);
_meritkokodu:=pmk; _poptext; {obnoveni puvodnich hodnot}
if povolitklavesy then kresetuj;
prebijecibarva:=$FFFF;
End;{kreslimac}

procedure PrebijBarvou(touto:byte);
Begin
prebijecibarva:=touto;
End;{prebijbarvou}

procedure NactiMAC(var ktery:MAC; var f:file);
var w,w2:word;
Begin
with ktery do
 begin
 bloky:=nil; pocetbloku:=0; {jestli se neco pokazi, tohle tu zustane}
 blockread(f,pocetbloku,2);
 if ioresult<>0 then begin pocetbloku:=0; exit; end;
 w:=pocetbloku*sizeof(blok);
 if (w>maxavail)or(w>65528) then begin pocetbloku:=0; exit; end; {kdyby se pole neveslo do pameti}
 getmem(bloky,w); {pamet pro pole bloku}
 for w:=0 to pocetbloku-1 do
  with bloky^[w] do
   begin {nacitani obsahu jednotlivych bloku}
   blockread(f,velikost,2); {velikost pole s prvky}
   if (ioresult<>0)or(velikost>65528)or(velikost>maxavail) then begin velikost:=0; exit; end;
   getmem(prvky,velikost);
   blockread(f,prvky^,velikost); {nacteni pole prvku}
   if ioresult<>0 then begin {nacetly se kraviny}
                       freemem(prvky,velikost);
                       velikost:=0;
                       exit;
                       end;
   end;
 end;
End;{nactimac}

procedure NactiMAC2(var ktery:MAC; soubor:string);
var f:file;
Begin
assign(f,soubor);
reset(f,1);
nactimac(ktery,f);
close(f);
End;{nactimac2}

{procedure UlozMAC(var ktery:MAC; soubor:string);
var f:file;
    w:word;
Begin                                takhle jednoduche by bylo ukladani :-)
assign(f,soubor);
rewrite(f,1);
if ioresult<>0 then exit;
with ktery do
 begin
 blockwrite(f,pocetbloku,2);
 for w:=0 to pocetbloku-1 do with bloky^[w] do begin
                                               blockwrite(f,velikost,2);
                                               blockwrite(f,prvky^,velikost);
                                               end;
 end;
close(f);
End;{ulozmac}

procedure ZrusMAC(var ktery:MAC);
var w:word;
Begin
with ktery do
 begin
 if (pocetbloku=0)or(bloky=nil) then exit;
 for w:=0 to pocetbloku-1 do
  with bloky^[w] do
   if velikost<>0 then freemem(prvky,velikost);
 freemem(bloky,pocetbloku*sizeof(blok));
 bloky:=nil; pocetbloku:=0;
 end;
End;{zrusmac}

END.

{Struktura souboru *.MAC ([tohle] tam muze byt, ale nemusi):

 pocet bloku (minimalne 1) (word)
 blok 0
 [blok 1]
 [blok 2]
 ...
 [blok n]

Struktura bloku:

 velikost bloku v B (word)
 [prvek 0]
 [prvek 1]
 ...
 [prvek n]

Struktura prvku:

 identifikacni kod (byte)
 [data]

Struktura dat je ruzna pro kazdy typ prvku (jsou to ty vyse uvedene typy
(recordy) zacinajici na t).

Graficky prvek je prikaz pro nakresleni specificke veci - bodu, cary, elipsy,
celeho bloku jinych prvku atd., nebo prikaz (cekani apod. - pro animace).
Blok je soubor takovychto prvku; existuje proto, ze vetsinou je z hlediska
uspory pameti mnohem vyhodnejsi definovat si jeden slozity blok a pak ho
nakreslit desetkrat, nez desetkrat opakovat kresleni stejne hromady
samostatnych prvku. Kazdy blok muzeme zobrazit na libovolnych souradnicich,
v libovolnem meritku a natoceny o libovolny uhel.

Pozor: kdyz se do bloku da prikaz pro vykresleni tehoz bloku (nebo kdyz se
nekolik bloku zobrazuje navzajem), vznikne nekonecna smycka, ktera neni nijak
osetrena.}