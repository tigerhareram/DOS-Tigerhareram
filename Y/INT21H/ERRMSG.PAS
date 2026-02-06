(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: ERRMSG.PAS                                                     *)
(*  Obsah: procedura pro chybove hlaseni                                   *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 17.11.2010                                            *)
(*  Pro kompilaci: KLAVESY2.TPU                                            *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit errmsg;
{$D-,L-}
interface

procedure Chyba(S:string; ukoncit:byte);
{vypise hlasku S a potom:
 ukoncit=0 - po stisku libovolne klavesy se program ukonci
 ukoncit=1 - po stisku libovolne klavesy program pokracuje
 ukoncit=2 - uzivatel si vybere, jestli chce pokracovat (A/N)
Funguje v jakemkoli rezimu obrazovky.
Vypsana zprava se nesmaze, ale zustava na obrazovce.}

{$define cesky}
{...$define english}
{Tyhle direktivy urcuji jazyk, kterym bude procedura Chyba komunikovat s
uzivatelem. Vyberte jednu z nich (ani vic, ani min!).}


{Nasledujici funkce si muzete aktivovat povolenim definic prislusneho symbolu.
Pokud je nepotrebujete, nechte je vyrazene, at se neplytva pameti (obsahuji
spoustu textovych konstant).}

{...$define _doserror}
{$ifdef _doserror}
function EM_doserror(cislo:integer):string;
{Vraci textovy popis chyby podle zadaneho cisla, jake jste si precetli z
promenne Doserror z jednotky DOS.}
{$endif}

{...$define _ioresult}
{$ifdef _ioresult}
function EM_IOresult(cislo:word):string;
{Vraci popis chyby podle cisla, ktere vyplivla standardni funkce IOresult.}
{$endif}

{...$define _xmsresult}
{$ifdef _xmsresult}
function EM_xmsresult(cislo:word):string;
{Vraci popis chyby podle daneho cisla, ktere vam vratila funkce XMSresult
z jednotky XMS.}
{$endif}

{...$define _vyrresult}
{$ifdef _vyrresult}
function EM_vyrresult(cislo:word):string;
{Vraci popis chyby podle daneho cisla, jake jste si precetli z promenne
VyrResult z jednotky Matyka (vysledek vyhodnocovani vyrazu)}
{$endif}

implementation
uses klavesy2;

procedure chyba(s:string;ukoncit:byte);
var fn:char;{mØlo to bìt få :-)}
{}procedure DOSWrite(co:string); assembler;
{}Asm  {Vypise retezec natvrdo pres sluzbu Dosu => funguje pri jakemkoli stavu obrazovky.}
{}xor CH,CH        {CH = 0}
{}les DI,co        {ES:DI = adresa retezce}
{}mov AH,2         {AH = cislo sluzby}
{}mov CL,[ES:DI]   {CX = delka retezce (nulty znak)}
{} @smycka:        {pro kazdy znak retezce:}
{} inc DI           {o znak dal (pri prvnim pruchodu se dostaneme na prvni)}
{} mov DL,[ES:DI]   {DL = znak}
{} int $21          {DOS ten znak vypise}
{} loop @smycka
{}End;{doswrite}
Begin
if ukoncit>2 then ukoncit:=2;
kresetuj;
{$ifdef cesky}
doswrite(#13#10' Chyba!'#13#10);{#13 = kurzor na zacatek radku (CR), #10 = kurzor o radek niz (LF)}
{$endif}
{$ifdef english}
doswrite(#13#10' Error!'#13#10);
{$endif}
doswrite(s+#13#10#13#10);
case ukoncit of 0:begin
                  {$ifdef cesky}
                  doswrite('       Konec libovolnou klavesou.');
                  {$endif}
                  {$ifdef english}
                  doswrite('       Press any key to exit program.');
                  {$endif}
                  fn:=readkey;
                  doswrite(#13#10); {= writeln}
                  halt;
                  end;
                1:begin
                  {$ifdef cesky}
                  doswrite('       Pokracujte libovolnou klavesou.');
                  {$endif}
                  {$ifdef english}
                  doswrite('       Press any key to continue.');
                  {$endif}
                  fn:=readkey;
                  doswrite(#13#10);
                  end;
                2:begin
                  {$ifdef cesky}
                  doswrite('       Chcete pokracovat? (A/N)');
                   repeat fn:=upcase(readkey) until fn in ['A','N'];
                  doswrite(#13#10);
                  if fn<>'A' then halt;
                  {$endif}
                  {$ifdef english}
                  doswrite('       Do you wish to continue? (Y/N)');
                   repeat fn:=upcase(readkey) until fn in ['Y','N'];
                  doswrite(#13#10);
                  if fn<>'Y' then halt;
                  {$endif}
                  end;
                end;
kresetuj;
End;{chyba}

{$ifdef _doserror}
function EM_doserror(cislo:integer):string;
var s:string[6];
Begin
case cislo of 0:EM_doserror:='Vse v poradku.';
              2:EM_doserror:='Soubor nebyl nalezen.';
              3:EM_doserror:='Cesta nebyla nalezena.';
              5:EM_doserror:='Pristup odepren.';
              6:EM_doserror:='Neplatne handle.';
              8:EM_doserror:='Nedostatek pameti.';
              10:EM_doserror:='Neplatne prostredi.';
              11:EM_doserror:='Neplatny format.';
              18:EM_doserror:='Zadne dalsi soubory.';{tuhle vraceji Findfirst a Findnext, kdyz nic nenajdou}
              else begin
                   str(cislo,s);
                   EM_doserror:='DOSError '+s;
                   end;
              end;
End;{em_doserror}
{$endif}

{$ifdef _ioresult}
function EM_ioresult(cislo:word):string;
var s:string[5];
Begin
case cislo of 0:EM_ioresult:='Vse v poradku.';
              2:EM_ioresult:='Soubor neexistuje.';
              3:EM_ioresult:='Cesta neexistuje.';
              4:EM_ioresult:='Prilis mnoho otevrenych souboru.';
              5:EM_ioresult:='Pristup k souboru odepren.';
              12:EM_ioresult:='Neplatny kod pristupu k souboru (Filemode).';
              16:EM_ioresult:='Aktualni adresar se neda odstranit.';
              17:EM_ioresult:='Neda se prejmenovavat mezi disky.';{v ramci jednoho disku ale muzeme pouzivat Rename
                                                                   k presouvani souboru}
              100:EM_ioresult:='Jsme na konci souboru, neni co cist.';
              101:EM_ioresult:='Neni misto na disku.';
              102:EM_ioresult:='Soubor neni prirazen (Assign).';
              103:EM_ioresult:='Soubor neni otevren.';
              104:EM_ioresult:='Soubor neni otevren pro cteni.';
              105:EM_ioresult:='Soubor neni otevren pro zapis.';
              106:EM_ioresult:='To, co se melo nacist, neni cislo.';{objevuje se pri nacitani cisel z textovych souboru}
              150:EM_ioresult:='Disk je chranen proti zapisu.';
              152:EM_ioresult:='Diskova jednotka neni pripravena.';
              160,161,162:EM_ioresult:='Chyba hardwaru.';
              else begin
                   str(cislo,s);
                   EM_ioresult:='I/O chyba cislo '+s;
                   end;
              end;
End;{em_ioresult}
{$endif}

{$ifdef _xmsresult}
function EM_xmsresult(cislo:word):string;
var s:string[5];
Begin
{Komentare odpovidaji rozsahu jednotky XMS, hlasky jsou (krome tech poslednich
s cisly $C0 a $C1) univerzalni.}
case cislo of 0:EM_xmsresult:='Vse v poradku.';
              $80:EM_xmsresult:='Neznama funkce (spatne cislo).';{to asi kdyz se do AH zada nejaka blbost
                                                                  a pak se vola procedura OvladacXMS}
              $81:EM_xmsresult:='VDISK instalovan.';{?}
              $82:EM_xmsresult:='Chyba hradlovani A20.';{?}
              $8E:EM_xmsresult:='Jakasi chyba ovladace, pocitac mozna spadne.';{obecna chyba (ovladac je K.O.)}
              $8F:EM_xmsresult:='Nenapravitelna chyba ovladace.';{to jako ze uplne spadnul}
              $90:EM_xmsresult:='HMA neexistuje.';                  {\                                     }
              $91:EM_xmsresult:='HMA je jiz alokovana.';            { \ o HMA se tato jednotka nestara     }
              $92:EM_xmsresult:='DX je mensi nez parametr /HMAMIN.';{ / (navic je tam obvykle uhnizden DOS)}
              $93:EM_xmsresult:='HMA neni alokovana.';              {/                                     }
              $94:EM_xmsresult:='A20 je jiz povolena.';{A20 se musi povolit, kdybychom chteli pristupovat k HMA
                                                        v chranenem rezimu, coz stejne nechceme}
              $A0:EM_xmsresult:='Cela XMS uz je zaplnena.';{tahle chyba se objevuje, kdyz se pokousite spustit program
                                                        vyuzivajici XMS z IDE Turbo.exe, nebo kdyz pamet opravdu dojde :-).}
              $A1:EM_xmsresult:='Neni volne zadne handle.';{I tohle se muze stat, handlu byva obvykle pouze 32.}
              $A2:EM_xmsresult:='Spatne handle.';{objevi se napriklad kdyz chcete vymazat neexistujici blok apod.}
              $A3:EM_xmsresult:='Neplatne zdrojove handle.';{\                                                }
              $A4:EM_xmsresult:='Neplatny zdrojovy ofset.'; { \Tyhle se mohou objevit pri pokusu o presun dat,}
              $A5:EM_xmsresult:='Neplatne cilove handle.';  { /kdyz je nektera z tech veci spatne.            }
              $A6:EM_xmsresult:='Neplatny cilovy ofset.';   {/                                                }
              $A7:EM_xmsresult:='Neplatna velikost bloku dat.';{tohle se objevi treba kdyz je presouvany blok dat
                                                               vetsi nez 64 kB nebo ma lichou delku a ovladac to pak nezvladne}
              $A8:EM_xmsresult:='Spatny prekryv.';{? (podle AThelpu je to uz pry historie)}
              $A9:EM_xmsresult:='Chyba parity.';{?}
              $AA:EM_xmsresult:='Blok neni zamcen.';      {\  Souvisi s moznosti zamknout XMS blok, takze se s nim potom}
              $AB:EM_xmsresult:='Blok je zamcen.';        { \ v pameti nehybe. To tahle jednotka nedela.                }
              $AC:EM_xmsresult:='Prekrocen pocet zamku.'; { / (stejne to k necemu je jen v chranenem rezimu             }
              $AD:EM_xmsresult:='Chyba zamku.';           {/   s primym 32bitovym adresovanim).                         }
              $B0:EM_xmsresult:='Neni dostupny tak velky UMB.'; {\                                         }
              $B1:EM_xmsresult:='UMB neexistuje.';              { \ Upper Memory - to je taky jina kapitola}
              $B2:EM_xmsresult:='UMB segment je neplatny.';     { /                                        }
              $C0:EM_xmsresult:='Pamet XMS neni dostupna.';{tuhle generuje procedura XMSinit, kdyz nenajde ovladac
                                                            nebo kdyz neni zadna pamet volna, neni to standardni kod}
              $C1:EM_xmsresult:='I/O chyba pri emulaci XMS.';{tenhle kod taky neni nic oficialniho,
                                                              generuje ho alternativni obsluha, ktera emuluje XMS na disku}
              else begin
                   str(cislo,s);
                   EM_xmsresult:='Chyba XMS cislo '+s;
                   end;
              end;
End;{em_xmsresult}
{$endif}

{$ifdef _vyrresult}
function EM_vyrresult(cislo:word):string;
var s:string[5];
Begin
case cislo of 0:em_vyrresult:='vse v poradku';
              1:em_vyrresult:='deleni nulou';
              2:em_vyrresult:='nevypocitatelna mocnina';
              3:em_vyrresult:='nulta odmocnina';
              4:em_vyrresult:='nevypocitatelna odmocnina';
              5:em_vyrresult:='nekonecny vysledek funkce tg';
              6:em_vyrresult:='nekonecny vysledek funkce cotg';
              7:em_vyrresult:='nepripustny argument funkce arcsin';
              8:em_vyrresult:='nepripustny argument funkce arccos';
              9:em_vyrresult:='nekladny argument funkce ln';
              10:em_vyrresult:='nekladny argument funkce log';
              11:em_vyrresult:='neznamy operator';
              12:em_vyrresult:='chybne zadane cislo';
              13:em_vyrresult:='nedostatek operandu';
              14:em_vyrresult:='nezname klicove slovo';
              15:em_vyrresult:='neukoncena zavorka';
              16:em_vyrresult:='neznamy znak';
              17:em_vyrresult:='nedostatek operatoru';
              18:em_vyrresult:='prebytek operatoru';
              19:em_vyrresult:='nedostatek pameti pro alokaci pracovnich zasobniku';
              else begin
                   str(cislo,s);
                   em_vyrresult:='chyba cislo '+s+', popis neni definovan';
                   end;
              end;
End;{em_vyrresult}
{$endif}

END.