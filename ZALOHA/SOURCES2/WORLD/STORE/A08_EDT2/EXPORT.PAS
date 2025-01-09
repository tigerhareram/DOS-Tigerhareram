{------------------------------ export: -------------------------------------}

procedure ExportujKnihovnu(cesta,uzivatel:string);
{Cesta je adresar, ve kterem jsou soubory index.dat a hlavicka.htm
a podadresare se strankami, vcetne koncoveho lomitka, zadano relativne od
adresare s programem (napr. 'KNIHOVNA\').
Uzivatel je 'JIVA' nebo 'USER'.}
var PrevodniTabulka:pole256znaku; {prevodni tabulka na diakritiku}
 function PripravVystup(var F:file; Jmeno:string):boolean;
 {Soubor F napoji na Jmeno (zadavej bez cesty), otevre ho pro zapis,
 zkopiruje do nej hlavicku a necha ho otevreny pro dalsi zapisy.
 Vraci true, pokud se vsechno povedlo.}
 const VelikostBufferu=3000;
 var hlavicka:file;
     buffer:array[1..velikostbufferu] of char;
     precteno,zapsano:word;
 Begin
 pripravvystup:=false;
 assign(f,cesta+'1HTML\'+uzivatel+'\'+jmeno);
 rewrite(f,1);
 if ioresult<>0 then exit;
 assign(hlavicka,cesta+'hlavicka.htm');
 reset(hlavicka,1);
 if ioresult=0
   then begin
         repeat
         blockread(hlavicka,buffer,velikostbufferu,precteno);
         if precteno<>0 then blockwrite(f,buffer,precteno,zapsano);
         until (precteno=0) or (zapsano<>precteno) or (ioresult<>0);
        close(hlavicka);
        if ioresult<>0 then {to se snad nestane};
        pripravvystup:=true;
        end;
 End;{pripravvystup}
 procedure ZavriVystup(var F:file; Nechat:boolean);
 {Do otevreneho souboru F zapise paticku a zavre ho.
 Nechat: true = soubor zustane, false = soubor se smaze (urceno pro prazdne
         bloky bez stranek, ktere nechceme generovat).}
 var radek:string[20];
 Begin
 radek:='</body></html>';
 blockwrite(f,radek[1],length(radek));
 close(f);
 if not nechat then erase(f);
 if ioresult=0 then ;
 End;{zavrivystup}
 function KopirujSoubor(var F:file; JmenoSouboru:string; CisloStranky:word):boolean;
 {Do otevreneho souboru F prida obsah souboru jako jednu stranku. JmenoSouboru
 zadavej i s cestou. Pro prevod diakritiky pouziva globalni promennou
 PrevodniTabulka, kterou je treba mit vygenerovanou predem. CisloStranky se
 vypise ke spodnimu okraji stranky ve tvaru '- 123 -'; pokud je 0, nevypise se
 nic. Funkce vraci true, jestli se vlozeni stranky povedlo, nebo false, pokud
 dany soubor nenasla.}
 const VelikostBufferu=4000; {idealne tolik, aby se do toho vesel cely soubor}
 var vstup:file;
     radek:string;
     precteno,zapsano:word;
     buffer:array[1..velikostbufferu] of char;
 Begin
 kopirujsoubor:=false;
 assign(vstup,jmenosouboru);
 reset(vstup,1);
 if ioresult<>0 then exit;
 radek:='<div class="stranka">'#13#10'<!--dalsi=soubor%%'+jmenosouboru+'%%-->';
 blockwrite(f,radek[1],length(radek),zapsano);
  repeat
  blockread(vstup,buffer,velikostbufferu,precteno);
  if precteno=0 then break;
  prekoduj(buffer,precteno,prevodnitabulka);
  blockwrite(f,buffer,precteno,zapsano);
  until (ioresult<>0) {chyba disku}
        or (zapsano<>precteno) {chyba zapisu}
        or (precteno<velikostbufferu); {cely vstupni soubor je precteny}
 close(vstup);
 radek:='<!--/soubor-->'#13#10;
 if cislostranky<>0 then radek:=radek+'<div class="cisloradku">- '+nastr(cislostranky,0)+' -</div>'#13#10;
 radek:=radek+'</div>'#13#10;
 blockwrite(f,radek[1],length(radek),zapsano);
 kopirujsoubor:=ioresult=0;
 End;{kopirujsoubor}
 function KopirujSadu(var F:file; JmenoAdresare:string; Cifry,Index:byte;
                       var Info:tknihovnainfo; Typ:byte):boolean;
 {Do otevreneho souboru F prida obsah daneho adresare nebo vice adresaru.
 JmenoAdresare zadavej bez cesty a bez koncoveho lomitka.
 Cifry: 0 - zpracuje se pouze jeden adresar. JmenoAdresare zadej cele vcetne
            cisla na konci, napr. 'KNIHA1' nebo 'SESIT01'.
        Cokoli jineho - pocet cifer na konci jmena. JmenoAdresare zadej bez
            cisla (napr. 'KNIHA' nebo 'SESIT'), cifry zadej podle potreby
            (1 pro 1,2,3..., 2 pro 01,02,03... atd.). Procedura pak projde
            vsechny adresare s danym jmenem a cisly od 1 nahoru.
 Index: index nadpisu v Infu pro tuhle sadu, vyuzije se jen pri cifry=0
 Info: tabulka jmen knih, kterou je potreba mit nactenou predem. Nazvy z ni se
       vypisou velkym pismem na prvni stranku.
 Typ: ze ktere casti tabulky se ma nazev vzit: 1=sesity, 2=bloky, 3=knihy
      (neurcuje se to podle jmena adresare)
 Navratova hodnota funkce: true = aspon jedna stranka byla uspesne vlozena.
                           false = nevlozilo se nic, vysledny soubor by byl
                                   prazdny.}
 var CeleJmenoAdresare,PrekodovanyNadpis:string;
     IndexAdresare,IndexSouboru,CisloStranky:word;
     radek:string;
     zapsano:word;
 Begin
 kopirujsadu:=false;
 cislostranky:=1;
 for indexadresare:=1 to 999 do
  begin
  if cifry=0 then {index je zadany primo}
                  celejmenoadresare:=jmenoadresare
             else begin
                  index:=indexadresare; {za index se dosazuje}
                  celejmenoadresare:=jmenoadresare+nastr(index,cifry);
                  end;
  case typ of 1:celejmenoadresare:='SESITY\'+celejmenoadresare;
              2:celejmenoadresare:='BLOKY\'+celejmenoadresare;
              3:celejmenoadresare:='KNIHY\'+celejmenoadresare;
              end;
  celejmenoadresare:=cesta+celejmenoadresare;
  if existujeadresar(celejmenoadresare)
    then if existujesoubor(celejmenoadresare+'\*.TXT')
           then begin
                {uvodni stranka s nadpisem:}
                radek:='';
                if ((typ=1)and(index-1<=9))or((typ=2)or(typ=3))and(index-1<=4) {sedi rozsah indexu?}
                  then begin
                       radek:='<!--dalsi=typ%%'+nastr(typ,0)+'%%-->'#13#10
                             +'<!--dalsi=index%%'+nastr(index,0)+'%%-->'#13#10;
                       blockwrite(f,radek[1],length(radek),zapsano);
                       case typ of 1:radek:=info.jmenasesitu[index-1]; {ano - vezmi jmeno z tabulky}
                                   2:radek:=info.jmenabloku[index-1];
                                   3:radek:=info.jmenaknih[index-1];
                                   end;
                       end;
                if radek='' then begin {jestli nesedel index nebo byla tabulka prazdna, pouzij jmeno adresare}
                                 radek:='<!--dalsi=nadpis%%%%-->'+jmenoadresare;
                                 if cifry<>0 then radek:=radek+' '+nastr(index,0);
                                 end
                            else begin
                                 prekodovanynadpis:=radek;
                                 prekoduj(prekodovanynadpis[1],length(prekodovanynadpis),prevodnitabulka);
                                 radek:='<!--dalsi=nadpis%%'+radek+'%%-->'+prekodovanynadpis; {jinak vem nadpis z tabulky}
                                 end;
                radek:='<div class="stranka"><h1>'+radek+'</h1></div>'#13#10;
                blockwrite(f,radek[1],length(radek),zapsano);
                for indexsouboru:=1 to 999 do
                 begin
                 if kopirujsoubor(f,celejmenoadresare+'\'+nastr(indexsouboru,3)+'.TXT',cislostranky)
                   then kopirujsadu:=true
                   else break;
                 inc(cislostranky);
                 end;
                end
           else {nic, prazdne adresare jenom preskakujeme}
    else break; {na prvnim neexistujicim adresari koncime}
  if cifry=0 then break;
  end;
 End;{kopirujsadu}
var vstup,vystup:file;
    KnihovnaInfo:TKnihovnaInfo;
    IndexKnihy:byte;
    ok:boolean;
Begin{exportujknihovnu}
assign(vstup,cesta+'index.dat');
reset(vstup,sizeof(knihovnainfo));
if ioresult=0 then begin
                   blockread(vstup,knihovnainfo,1);
                   close(vstup);
                   if ioresult=0 then ;
                   end
              else fillchar(knihovnainfo,sizeof(knihovnainfo),0);
PripravPrevodniTabulku(klatin2,kwindows1250,prevodnitabulka);
if pripravvystup(vystup,'blok.htm')
  then zavrivystup(vystup,kopirujsadu(vystup,'SESIT',2,0,knihovnainfo,1));
if pripravvystup(vystup,'kniha6.htm')
  then zavrivystup(vystup,kopirujsadu(vystup,'BLOK',1,0,knihovnainfo,2));
for indexknihy:=1 to 5 do
 if pripravvystup(vystup,'kniha'+nastr(indexknihy,0)+'.htm')
   then zavrivystup(vystup,kopirujsadu(vystup,'KNIHA'+nastr(indexknihy,0),0,indexknihy,knihovnainfo,3));
End;{exportujknihovnu}
