function _SirkaTextu2(PocetZnaku:byte):word;
{Spocita sirku retezce o zadanem poctu znaku. Nezohlednuje ridici kody,
kazdy znak pocita jako stejne siroky.}
Begin
{moznost c. 1: kdyz je roztec vetsi nez sirka znaku, pocitat sirku bez
prazdneho mista za poslednim znakem:}
if pocetznaku=0 then _sirkatextu2:=0
                else if __roztec>8 then _sirkatextu2:=(pocetznaku-1)*__roztec+__velikostx shl 3
                                   else _sirkatextu2:=pocetznaku*__roztec;{pro uzke pismo}
{moznost c. 2: aby to vychazelo stejne jako pri pouziti _zmertext:}
{if pocetznaku=0 then _sirkatextu2:=0
                else _sirkatextu2:=(pocetznaku-1)*__roztec+__velikostx shl 3;}
{moznost c. 3: vykaslat se na slozitosti a pocitat sirku jenom z roztece:}
{_sirkatextu2:=pocetznaku*__roztec;}
End;{_sirkatextu2}


{hlavni vykreslovaci procedura - vykresli slunecni soustavu v danem datu:}

procedure VykresliSoustavu(xSlunce,ySlunce:integer; {souradnice stredu soustavy na obrazovce}
                           Meritko:word; {v procentech, 100 = cca na celou obrazovku 640x480}
                           Datum:real); {datum v rocich pocitane od 9.11.2016 (+ je budoucnost)}

type PoleDat=array[1..pocetteles] of record {pomocne pole pro vypocty souradnic}
                                     x,y:integer; {vysledne souradnice telesa na obrazovce [px]}
                                     procento:integer;
                                     vyrizeno:boolean; {jestli uz je teleso vykreslene}
                                     end;

 function SpocitejPolohu(var D:poledat; I:word):boolean;
 {Funkce se pokusi spocitat polohu Iteho telesa a pripadne vysledky ulozi
 do pole D. Vraci true, kdyz se ji to povede. False by vratila, kdyby jeste
 nebyly spocitane souradnice telesa, kolem ktereho tohle obiha.
 Funkce cte pole Telesa a vsechny parametry procedury VykresliSoustavu.}
 var uhel,RozdilUhlu:real; {[rad]}
 Begin
 spocitejpolohu:=true;
 if telesa[i].kolemcehoobiha=0 then begin {kolem niceho neobiha => je primo uprostred}
                                    d[i].x:=xslunce;
                                    d[i].y:=yslunce;
                                    d[i].vyrizeno:=true;
                                    end
  else if not d[telesa[i].kolemcehoobiha].vyrizeno {kolem neceho obiha, ale jeste nevime, kde to je}
         then spocitejpolohu:=false
   else begin {kolem neceho obiha a uz vime, kde to je}
        uhel:=telesa[i].vychoziuhel-2*pi*datum/telesa[i].dobaobehu;
        d[i].x:=round(d[telesa[i].kolemcehoobiha].x+cos(uhel)*telesa[i].polomerdrahy*meritko/100);
        d[i].y:=round(d[telesa[i].kolemcehoobiha].y+sin(uhel)*telesa[i].polomerdrahy*meritko/100);
        d[i].vyrizeno:=true;                      {^otoceni tohohle znamenka otoci smer rotace}
        {procento shody s vybranym uhlem:}
        RozdilUhlu:=abs(Uhel-SpolecnyUhel);
        while rozdiluhlu>2*pi do rozdiluhlu:=rozdiluhlu-2*pi;
        if rozdiluhlu>pi then rozdiluhlu:=2*pi-rozdiluhlu;
        d[i].procento:=100-round(100*rozdiluhlu/pi);
        end;
 End;{spocitejpolohu}

var i:byte;
    hotovo:boolean;
    data:PoleDat;
    polomer:word; {aby se usetrilo trochu pocitani}
    proc:string[6];
Begin
{vypocet poloh teles:}
fillchar(data,sizeof(data),0); {vyrizeno:=false}
 repeat
 hotovo:=true;
 for i:=1 to pocetteles do
  if not data[i].vyrizeno and not spocitejpolohu(data,i) then hotovo:=false;
 until hotovo;
{vykresleni obeznych drah:}
for i:=2 to pocetteles do
 begin
 polomer:=telesa[i].polomerdrahy*longint(meritko) div 100;
 SVGA_ellipse(data[telesa[i].kolemcehoobiha].x,
           data[telesa[i].kolemcehoobiha].y,
           polomer,polomer,ColX[15],0);
 end;
{vykresleni planet:}
for i:=1 to pocetteles do
 begin
 {planeta:}
 polomer:=telesa[i].polomer*longint(meritko) div 100;
 SVGA_ellipse(data[i].x,data[i].y,polomer,polomer,telesa[i].barva,1);
 {jmeno:}
 _print(data[i].x-_sirkatextu2(length(telesa[i].jmeno)) shr 1,
         data[i].y+polomer+4,
         telesa[i].barva,telesa[i].jmeno);
 {procento:}
 str(data[i].procento,proc);
 proc:=proc+'%';
 Case i of
   1: _print(20,30+15*(5+i),telesa[i].barva,'Slunce  = '+proc);
   2: _print(20,30+15*(5+i),telesa[i].barva,'Merkur  = '+proc);
   3: _print(20,30+15*(5+i),telesa[i].barva,'Venuse  = '+proc);
   4: _print(20,30+15*(5+i),telesa[i].barva,'Zeme    = '+proc);
   5: _print(20,30+15*(5+i),telesa[i].barva,'Mars    = '+proc);
   6: _print(20,30+15*(5+i),telesa[i].barva,'Jupiter = '+proc);
   7: _print(20,30+15*(5+i),telesa[i].barva,'Saturn  = '+proc);
   8: _print(20,30+15*(5+i),telesa[i].barva,'Uran    = '+proc);
   9: _print(20,30+15*(5+i),telesa[i].barva,'Neptune = '+proc);
  10: _print(20,30+15*(5+i),telesa[i].barva,'Mesic   = '+proc);
 End; {Case End}

 end;
End;{vykreslisoustavu}
