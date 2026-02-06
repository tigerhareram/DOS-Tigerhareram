(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: TEXTMENU.PAS                                                   *)
(*  Obsah: jednotka pro zobrazovani nabidek v textovem rezimu              *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 25.5.2014                                             *)
(*  Pro kompilaci: TEXTY2.TPU, KLAVESY2.TPU, RETEZCE.TPU                   *)
(*  Pro spusteni: nic                                                      *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
unit TextMenu;

interface

const MaxPolozek=10; {max. pocet polozek nabidky}
      MaxPopisu=10; {max. pocet radku popisu ke kazde polozce}
      BarvaTMenu:byte=3;    {barva textu neaktivnich polozek (0..15)}
      BarvaPozTMenu:byte=3; {barva pozadi aktivni polozky (0..7, pripadne +8 pro blikani textu)}
      BarvaTMPopisu:byte=7; {barva textu popisu (0..15)}

type PolozkaTMenu = record {pomocny typ pro vnitrni pouziti}
                    nadpis:string[70]; {text polozky}
                    PocetPopisu:byte; {skutecny pocet popisnych radku}
                    popisy:array[1..maxpopisu] of string[80];
                    end;

     TMenu = object {uzivatelsky typ}
             LHY, {yova souradnice prvniho radku nabidky}
             PocetPolozek, {skutecny pocet polozek nabidky}
             hodnota:byte; {ktera polozka je prave vybrana (pocitano od 1)}
             zruseno:boolean; {true, pokud se skoncilo Escapem misto Enteru}
             polozky:array[1..maxpolozek] of polozkatmenu;
             procedure Init(iy:byte);
              {pripravi nabidku k pouziti (jestli uz v ni neco bylo, smaze
              to), iy je pozadovana yova souradnice prvniho radku nabidky
              (pocitano od 1)}
             procedure Polozka(iNadpis:string);
              {prida jednu polozku nabidky s danym nadpisem}
             procedure PrepisPolozku(kterou:byte; NovyNadpis:string);
              {u dane polozky zmeni nadpis}
             procedure Popis(iPopis:string);
              {k posledne pridane polozce prida jeden radek popisu}
             procedure Kontrola;
              {Vykresli nabidku a necha uzivatele neco vybrat (kurzorove
              klavesy, Enter, Esc). Prvni polozka nabidky se zobrazi na yove
              souradnici lhy, pod poslednim polozkou se jeden radek vynecha a
              pak zacnou popisy. Zbytek obrazovky nad prvnim a pod poslednim
              radkem zustane nedotceny. Menu zustane po skonceni Kontroly
              zobrazene.}
             end;

{Menu nepouziva kurzor, takze je jedno, jestli bude zapnuty nebo vypnuty.}


implementation
uses texty2,klavesy2,retezce;

procedure tmenu.init(iy:byte);
Begin
lhy:=iy;
pocetpolozek:=0;
hodnota:=1;
zruseno:=false;
End;{tmenu.init}

procedure tmenu.polozka(inadpis:string);
Begin
if pocetpolozek<maxpolozek
  then begin
       inc(pocetpolozek);
       with polozky[pocetpolozek] do begin
                                     nadpis:=inadpis;
                                     pocetpopisu:=0;
                                     end;
       end;
End;{tmenu.polozka}

procedure tmenu.prepispolozku(kterou:byte; NovyNadpis:string);
Begin
if (kterou>=1)and(kterou<=pocetpolozek) then polozky[kterou].nadpis:=novynadpis;
End;{tmenu.prepispolozku}

procedure tmenu.popis(ipopis:string);
Begin
if polozky[pocetpolozek].pocetpopisu<maxpopisu
  then with polozky[pocetpolozek] do begin
                                     inc(pocetpopisu);
                                     popisy[pocetpopisu]:=ipopis;
                                     end;
End;{tmenu.popis}

procedure tmenu.kontrola;
var i,b, {pomocne indexy}
    maxdelka, {delka nejdelsi polozky - podle ni se pocita delka vybarveni vybraneho radku}
    pocpopisu:byte; {nejvetsi pocet popisnych radku - podle toho se pocita, kolik radku se ma pri zmene vyberu mazat}
    o:word; {pro klavesnici}
    MinulaHodnota:byte; {co bylo vybrano predtim, aby bylo kam se vracet pri Escapu}
Begin
if pocetpolozek=0 then exit; {pro jistotu}
{spocitani sirky nabidky:}
maxdelka:=length(polozky[1].nadpis);
for i:=2 to pocetpolozek do if length(polozky[i].nadpis)>maxdelka then maxdelka:=length(polozky[i].nadpis);
inc(maxdelka,2); {vypln vlevo a vpravo}
{spocitani popisu:}
pocpopisu:=polozky[1].pocetpopisu;
for i:=2 to pocetpolozek do if polozky[i].pocetpopisu>pocpopisu then pocpopisu:=polozky[i].pocetpopisu;
{udelame si misto na obrazovce:}
for i:=0 to pocetpolozek+pocpopisu do vymazradek(lhy+i,barvatmpopisu);
{hlavni cyklus:}
minulahodnota:=hodnota;
kresetuj;
 repeat
 {vykresleni polozek:}
 for i:=1 to pocetpolozek do begin
                             if i=hodnota then b:=barvapoztmenu shl 4
                                          else b:=barvatmenu;
                             with polozky[i] do
                              writexy(4,lhy+i-1,b,zarovnej(' '+nadpis,maxdelka,_doleva,' '));
                             end;
 {vykresleni popisu:}
 for i:=1 to pocpopisu do vymazradek(lhy+pocetpolozek+i,barvatmpopisu);
 with polozky[hodnota] do
   for i:=1 to pocetpopisu do writexy(1,lhy+pocetpolozek+i,barvatmpopisu,popisy[i]);
 {uzivateluv vyber:}
 o:=xreadkey;
 zruseno:=false;
 case o of xhsipka,xlsipka,xpgup:if hodnota>1 then dec(hodnota); {nahoru}
           xdsipka,xpsipka,xpgdn:if hodnota<pocetpolozek then inc(hodnota); {dolu}
           xhome:hodnota:=1; {na zacatek}
           xend:hodnota:=pocetpolozek; {na konec}
           xesc:begin
                hodnota:=minulahodnota;
                zruseno:=true;
                end;
           end;
 until (o=xenter)or(o=xesc);
End;{tmenu.kontrola}

END.