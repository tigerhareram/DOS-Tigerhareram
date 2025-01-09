{------------ pomocne veci vykopirovane odjinud, aby byl program sobestacny: -----------}

type PoleCharu=array[0..0] of char; {pomocny typ (sablona pro dynamicke pole)}

     Turbosoubor=object                      {Na tomhle radku zmacknete End, tim se obrazovka}
                 soubor:file;                {dostane do spravne polohy pro cteni komentaru. }
                 otevreny:boolean;
                 buffer:^polecharu; {vyrovnavaci pamet}
                 VB:word; {velikost bufferu}
                 pocet:word; {pocet dosud nezpracovanych platnych znaku v bufferu}
                 index:word; {aktualni pozice v bufferu}
                 Hotovo:boolean; {hlasi vysledek metod NajedZa a CtiDo (viz nize)}
                 procedure Init(VelikostBufferu:word);
                 {Zavolejte jednou pred prvnim pouzitim, vickrat uz ne. Procedura inicializuje
                 interni promenne a alokuje vyrovnavaci buffer. Jeho velikost si zvolte
                 v parametru, maximum je 65528 B (kdyby pamet nestacila, buffer se automaticky
                 zmensi). Cim je vetsi, tim je prace se souborem rychlejsi, protoze se nemusi
                 tak casto sahat na disk.}
                 procedure Otevri(Jmeno:pathstr);
                 {Napoji objekt na soubor s danym Jmenem a otevre ho pro cteni (jako Assign
                 a Reset). Pripadny drive otevreny soubor napred automaticky zavre.}
                 procedure Nasosej;
                 {Nacte ze souboru do bufferu dalsi varku dat. Rucni volani celkem nema smysl,
                 ostatni metody si ji volaji automaticky podle potreby.}
                 procedure NajedZa(Co:string);
                 {Posune kurzor v souboru za nejblizsi vyskyt retezce Co a Hotovo nastavi na
                 true. Kdyz ten retezec vubec nenajde, zastavi se az na konci souboru a
                 Hotovo nastavi na false.}
                 function CtiDo(Ceho:string):string;
                 {Vrati data ze souboru od aktualni pozice kurzoru po posledni znak pred
                 zacatkem nejblizsiho retezce Ceho, kurzor posune za konec toho retezce a
                 Hotovo nastavi na true. Jestli ten retezec nenajde, zastavi se po 255 znacich
                 (vic se do stringu nevejde) nebo na konci souboru a Hotovo nastavi na false.
                 Jestli je Ceho='' nebo ze souboru nejde cist, vrati se '' a se souborem se
                 nic nedela.}
                 function NaKonci:boolean;
                 {Vraci true, jestli ze souboru nejde cist - bud jeste neni otevreny, nebo uz
                 je docteny az do konce (vcetne bufferu). Vicemene obdoba Eof.}
                 procedure Zavri;
                 {Zavre soubor na disku a vyprazdni buffer. Obdoba Close.}
                 procedure Zrus;
                 {Zavre soubor a dealokuje buffer. Kdybyste potom chteli objekt znovu pouzit,
                 pouzijte Init.}
                 end;
{Objekt je delany maximalne blbuvzdorne. O Ioresult se nestarejte, kontroluje
a resetuje se automaticky, takze po skonceni jakekoli metody bude vzdy nulovy.
Ze doslo k chybe zjistite podle toho, ze se neda nic nacist a metoda NaKonci
hlasi true (soubor se pri chybe obvykle automaticky zavira).
Datove polozky krome Hotovo nejsou urceny k rucnimu zpracovani, pohodlnejsi
(a bezpecnejsi) je vsechno resit volanim metod.}

procedure turbosoubor.init(VelikostBufferu:word);
Begin
otevreny:=false;
if velikostbufferu<maxavail then vb:=velikostbufferu else vb:=maxavail;
if vb=0 then buffer:=nil {neco malo pro kontrolu}
        else getmem(buffer,vb);
pocet:=0;
End;{turbosoubor.init}

procedure turbosoubor.Otevri(Jmeno:pathstr);
Begin
pocet:=0;
if buffer=nil {chaba podminka (zapomenutou inicializaci vetsinou neodhali), ale lepsi nez nic}
  then begin otevreny:=false; exit; end;
if otevreny then zavri;
assign(soubor,jmeno);
reset(soubor,1);
otevreny:=true;
End;{turbosoubor.otevri}

procedure turbosoubor.Nasosej;
var nacteno:word;
Begin
{pripadny zbytek platnych dat posun na zacatek:}
if (pocet<>0)and(index<>0) then begin
                                move(buffer^[index],buffer^[0],pocet);
                                index:=0;
                                end;
{do volneho mista za platnymi daty nacti, co se vejde:}
if pocet<vb then begin
                 blockread(soubor,buffer^[pocet],vb-pocet,nacteno);
                 inc(pocet,nacteno);
                 index:=0;
                 if ioresult<>0 then zavri;
                 end;
End;{turbosoubor.nasosej}

procedure turbosoubor.NajedZa(Co:string);
var pom:string;
    znak:char;
Begin
hotovo:=false;
if nakonci or (co='') then exit;
pom:='';
 repeat
 if pocet=0 then nasosej;
 if nakonci then break;
 znak:=buffer^[index]; inc(index); dec(pocet);
 if pom='' then if znak=co[1] then pom:=znak {prvni znak se shoduje - zapamatuj si ho}
                              else {prvni znak se neshoduje - zahod ho}
           else begin
                pom:=pom+znak; {ulozit se musi kazdopadne}
                if znak<>co[length(pom)] {pri neshode zahod vsechno, co se neshoduje}
                  then while (pom<>'')and(pom<>copy(co,1,length(pom))) do delete(pom,1,1);
                end;
 until pom=co;
hotovo:=pom=co;
End;{turbosoubor.najedza}

function turbosoubor.CtiDo(Ceho:string):string;
var vystup,pom:string;
    znak:char;
Begin
{algoritmus je stejny jako u NajedZa, jenom se zpracovane znaky misto
zahazovani ukladaji do vystupniho retezce}
hotovo:=false;
if nakonci or (ceho='') then begin ctido:=''; exit; end;
vystup:='';
pom:='';
 repeat
 if pocet=0 then nasosej;
 if nakonci then break;
 znak:=buffer^[index]; inc(index); dec(pocet);
 if pom='' then if znak=ceho[1] then pom:=znak
                                else vystup:=vystup+znak
           else begin
                pom:=pom+znak;
                if znak<>ceho[length(pom)]
                  then while (pom<>'')and(pom<>copy(ceho,1,length(pom))) do
                        begin
                        vystup:=vystup+pom[1];
                        delete(pom,1,1)
                        end
                end;
 until (pom=ceho)or(length(vystup)=255);
ctido:=vystup;
hotovo:=pom=ceho;
End;{turbosoubor.ctido}

function turbosoubor.NaKonci:boolean;
Begin
nakonci:=not otevreny or (pocet=0) and eof(soubor);
if ioresult<>0 then zavri;
End;{turbosoubor.nakonci}

procedure turbosoubor.Zavri;
Begin
if otevreny then begin
                 close(soubor);
                 if ioresult=0 then
                 otevreny:=false;
                 pocet:=0;
                 end;
End;{turbosoubor.zavri}

procedure turbosoubor.zrus;
Begin
zavri;
if buffer<>nil then begin
                    freemem(buffer,vb);
                    buffer:=nil;
                    vb:=0;
                    end;
End;{turbosoubor.zrus}


function NaStr(a:longint; NaKolik:byte):string;
var vysl:string[80];
Begin
str(a,vysl);
while length(vysl)<nakolik do vysl:='0'+vysl;
nastr:=vysl;
End;{nastr}

const kLatin2='üÖæ¦›¬íÞÕé·Òµàý¡ç§œŸì…å£ØÔ ‚¢';
      kWindows1250='ØÍŠŽÈÝÙÒÚÌÏÁÉÓøíšžèýùòúìïáéó';

type pole256znaku=array[#0..#255] of char;

procedure PripravPrevodniTabulku(PuvodniZnaky,NoveZnaky:string; var PrevodniTabulka:pole256znaku);
var i,j:byte;
    HledaneZnaky:set of char;
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

procedure Prekoduj(var Co; Delka:word; var PrevodniTabulka:pole256znaku);
{prekoduje pole Co o dane Delce, typ toho pole je array[1..cokoli] of char}
type PoleCharu=array[1..1] of char;
var i:word;
Begin
for i:=1 to delka do polecharu(co)[i]:=prevodnitabulka[polecharu(co)[i]];
End;{prekoduj}

function ExistujeSoubor(jmeno:pathstr):boolean;
var info:searchrec;
Begin
findfirst(jmeno,anyfile-volumeid,info);
existujesoubor:=(doserror=0)and(info.attr and directory=0);
End;{existujesoubor}

function ExistujeAdresar(jmeno:pathstr):boolean;
var info:searchrec;
Begin
findfirst(jmeno,anyfile-volumeid,info);
existujeadresar:=(doserror=0)and(info.attr and directory<>0);
End;{existujeadresar}

