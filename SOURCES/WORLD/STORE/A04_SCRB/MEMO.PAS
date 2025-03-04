procedure Doprava; {posun kurzoru o pozici doprava}
Begin
If KurzX<79 then Inc(KurzX) {posun v ramci jednoho radku}
            else if kurzy<24 then begin {z konce radku na zacatek dalsiho}
                                  kurzx:=0;
                                  inc(kurzy);
                                  end;
End;                        {else nic - z praveho dolniho rohu stranky uz nikam dal nemuzeme}

procedure Doleva; {posun kurzoru o pozici doleva}
Begin
if kurzx>0 then dec(kurzx) {posun na radku}
           else if kurzy>0 then begin {ze zacatku radku se skoci na konec predchoziho}
                                dec(kurzy);
                                kurzx:=79; {jestli je predchozi radek zaplneny az do konce, nebude to uplne ciste}
                                while (kurzx>0)and(stranka[kurzy,kurzx-1]=' ') do dec(kurzx);
                                end;
End;

procedure SmazZnak; {funkce klavesy delete}
var i,DelkaDalsiho,MistoNaKonci:word;
    NaKonci:boolean;
Begin
{Posouvat cely zbytek stranky mi prijde trochu nesikovne - musime mit moznost
uprav v jednom radku, ktere nerozhodi nic jineho. Takze dejme tomu, ze vsechno
budeme posouvat jenom v pripade, ze je kurzor na konci radku.}
nakonci:=kurzy<24; {posledni radek radsi odchytime rovnou tady}
for i:=kurzx to 79 do if stranka[kurzy,i]<>' ' then nakonci:=false;
if nakonci then begin {slouceni radku}
                {kolik mame volneho mista napravo od kurzoru:}
                mistonakonci:=80-kurzx;
                {jak dlouhy je nasledujici radek:}
                delkadalsiho:=80;
                while (delkadalsiho>0)and(stranka[kurzy+1,delkadalsiho-1]=' ') do dec(delkadalsiho);
                {presun textu z nasledujiciho radku:}
                if mistonakonci>=delkadalsiho
                  then begin {dalsi radek se sem presune cely a zrusi se}
                       move(stranka[kurzy+1,0],stranka[kurzy,kurzx],delkadalsiho);
                       for i:=kurzy+1 to 23 do move(stranka[i+1,0],stranka[i,0],80);
                       fillchar(stranka[24,0],80,' ');
                       end
                  else begin {presune se sem jenom cast dalsiho radku, ktera se vejde, a radek se nerusi}
                       move(stranka[kurzy+1,0],stranka[kurzy,kurzx],mistonakonci);
                       move(stranka[kurzy+1,mistonakonci],stranka[kurzy+1,0],mistonakonci);
                       fillchar(stranka[kurzy+1,mistonakonci],80-mistonakonci,' ');
                       end;
                  WriteStranka;
                end
           else begin {jednoduche smazani znaku v ramci jednoho radku}
                for i:=kurzx to 78 do
                begin
                  stranka[kurzy,i]:=stranka[kurzy,i+1];
                  SVGA_BarZ(i*8,kurzy*16,i*8+7,kurzy*16+15,ColX[0]);
                  _Print(i*8,kurzy*16,ColX[15],stranka[kurzy,i]);
                end;
                stranka[kurzy,79]:=' ';
                SVGA_BarZ(79*8,kurzy*16,79*8+7,kurzy*16+15,ColX[0]);
                _Print(79*8,kurzy*16,ColX[15],stranka[kurzy,79]);
                end;
End;{smazznak}

procedure ZalomRadek; {funkce klavesy enter}
var i:word;
Begin
if kurzy=24 then exit; {z posledniho radku uz neni kam entrovat}
{vlozeni radku by ten posledni vysouplo ze stranky, coz nechci, takze jestli
na nem neco je, koncim:}
for i:=0 to 79 do if stranka[24,i]<>' ' then exit;
{a ted to vkladani:}
for i:=24 downto kurzy+2 do move(stranka[i-1,0],stranka[i,0],80); {odsunuti radku dole}
fillchar(stranka[kurzy+1,0],80,' '); {vymazani toho noveho}
move(stranka[kurzy,kurzx],stranka[kurzy+1,0],80-kurzx); {presun dat za kurzorem na zacatek noveho radku}
fillchar(stranka[kurzy,kurzx],80-kurzx,' '); {vymazani dat za kurzorem z puvodniho radku}
inc(kurzy); kurzx:=0; {kurzor na zacatek noveho radku}
WriteStranka;
End;{zalomradek}


Procedure Scan_ToggleProc;
Begin
If Scan_Toggle=False then Scan_Toggle:=True else Scan_Toggle:=False;
End;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}


procedure Doprava2; {posun kurzoru o pozici doprava}
Begin
If KurzX<79 then Inc(KurzX) {posun v ramci jednoho radku}
            else if kurzy<4 then begin {z konce radku na zacatek dalsiho}
                                   kurzx:=0;
                                   inc(kurzy);
                                 end;
End;                        {else nic - z praveho dolniho rohu stranky uz nikam dal nemuzeme}

procedure Doleva2; {posun kurzoru o pozici doleva}
Begin
if kurzx>0 then dec(kurzx) {posun na radku}
           else if kurzy>0 then begin {ze zacatku radku se skoci na konec predchoziho}
                                dec(kurzy);
                                kurzx:=79; {jestli je predchozi radek zaplneny az do konce, nebude to uplne ciste}
                                while (kurzx>0)and(stranka2[kurzy,kurzx-1]=' ') do dec(kurzx);
                                end;
End;

procedure SmazZnak2(Y1: Word); {funkce klavesy delete}
var i,DelkaDalsiho,MistoNaKonci:word;
    NaKonci:boolean;
Begin
{Posouvat cely zbytek stranky mi prijde trochu nesikovne - musime mit moznost
uprav v jednom radku, ktere nerozhodi nic jineho. Takze dejme tomu, ze vsechno
budeme posouvat jenom v pripade, ze je kurzor na konci radku.}
nakonci:=kurzy<4; {posledni radek radsi odchytime rovnou tady}
for i:=kurzx to 79 do if stranka2[kurzy,i]<>' ' then nakonci:=false;
if nakonci then begin {slouceni radku}
                {kolik mame volneho mista napravo od kurzoru:}
                mistonakonci:=80-kurzx;
                {jak dlouhy je nasledujici radek:}
                delkadalsiho:=80;
                while (delkadalsiho>0)and(stranka2[kurzy+1,delkadalsiho-1]=' ') do dec(delkadalsiho);
                {presun textu z nasledujiciho radku:}
                if mistonakonci>=delkadalsiho
                  then begin {dalsi radek se sem presune cely a zrusi se}
                       move(stranka2[kurzy+1,0],stranka2[kurzy,kurzx],delkadalsiho);
                       for i:=kurzy+1 to 3 do move(stranka2[i+1,0],stranka2[i,0],80);
                       fillchar(stranka2[4,0],80,' ');
                       end
                  else begin {presune se sem jenom cast dalsiho radku, ktera se vejde, a radek se nerusi}
                       move(stranka2[kurzy+1,0],stranka2[kurzy,kurzx],mistonakonci);
                       move(stranka2[kurzy+1,mistonakonci],stranka2[kurzy+1,0],mistonakonci);
                       fillchar(stranka2[kurzy+1,mistonakonci],80-mistonakonci,' ');
                       end;
                  WriteStrankaChat(Y1);
                end
           else begin {jednoduche smazani znaku v ramci jednoho radku}
                for i:=kurzx to 78 do
                begin
                  stranka2[kurzy,i]:=stranka2[kurzy,i+1];
                  SVGA_BarZ(i*8,kurzy*16+Y1,i*8+7,kurzy*16+15+Y1,ColX[0]);
                  _Print(i*8,kurzy*16+Y1,ColX[15],stranka2[kurzy,i]);
                end;
                stranka2[kurzy,79]:=' ';
                SVGA_BarZ(79*8,kurzy*16+Y1,79*8+7,kurzy*16+15+Y1,ColX[0]);
                _Print(79*8,kurzy*16+Y1,ColX[15],stranka2[kurzy,79]);
                end;
End;{smazznak}

procedure ZalomRadek2(Y1: Word); {funkce klavesy enter}
var i:word;
Begin
if kurzy=4 then exit; {z posledniho radku uz neni kam entrovat}
{vlozeni radku by ten posledni vysouplo ze stranky, coz nechci, takze jestli
na nem neco je, koncim:}
for i:=0 to 79 do if stranka2[4,i]<>' ' then exit;
{a ted to vkladani:}
for i:=4 downto kurzy+2 do move(stranka2[i-1,0],stranka2[i,0],80); {odsunuti radku dole}
fillchar(stranka2[kurzy+1,0],80,' '); {vymazani toho noveho}
move(stranka2[kurzy,kurzx],stranka2[kurzy+1,0],80-kurzx); {presun dat za kurzorem na zacatek noveho radku}
fillchar(stranka2[kurzy,kurzx],80-kurzx,' '); {vymazani dat za kurzorem z puvodniho radku}
inc(kurzy); kurzx:=0; {kurzor na zacatek noveho radku}
WriteStrankaChat(Y1);
End;{zalomradek}


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}


procedure Doprava3; {posun kurzoru o pozici doprava}
Begin
If KurzX<39 then Inc(KurzX) {posun v ramci jednoho radku}
            else if kurzy<19 then begin {z konce radku na zacatek dalsiho}
                                   kurzx:=0;
                                   inc(kurzy);
                                 end;
End;                        {else nic - z praveho dolniho rohu stranky uz nikam dal nemuzeme}

procedure Doleva3; {posun kurzoru o pozici doleva}
Begin
if kurzx>0 then dec(kurzx) {posun na radku}
           else if kurzy>0 then begin {ze zacatku radku se skoci na konec predchoziho}
                                dec(kurzy);
                                kurzx:=39; {jestli je predchozi radek zaplneny az do konce, nebude to uplne ciste}
                                while (kurzx>0)and(stranka3[kurzy,kurzx-1]=' ') do dec(kurzx);
                                end;
End;

procedure SmazZnak3(Y1: Word); {funkce klavesy delete}
var i,DelkaDalsiho,MistoNaKonci:word;
    NaKonci:boolean;
Begin
{Posouvat cely zbytek stranky mi prijde trochu nesikovne - musime mit moznost
uprav v jednom radku, ktere nerozhodi nic jineho. Takze dejme tomu, ze vsechno
budeme posouvat jenom v pripade, ze je kurzor na konci radku.}
nakonci:=kurzy<19; {posledni radek radsi odchytime rovnou tady}
for i:=kurzx to 39 do if stranka3[kurzy,i]<>' ' then nakonci:=false;
if nakonci then begin {slouceni radku}
                {kolik mame volneho mista napravo od kurzoru:}
                mistonakonci:=40-kurzx;
                {jak dlouhy je nasledujici radek:}
                delkadalsiho:=40;
                while (delkadalsiho>0)and(stranka3[kurzy+1,delkadalsiho-1]=' ') do dec(delkadalsiho);
                {presun textu z nasledujiciho radku:}
                if mistonakonci>=delkadalsiho
                  then begin {dalsi radek se sem presune cely a zrusi se}
                       move(stranka3[kurzy+1,0],stranka3[kurzy,kurzx],delkadalsiho);
                       for i:=kurzy+1 to 18 do move(stranka3[i+1,0],stranka3[i,0],40);
                       fillchar(stranka3[19,0],40,' ');
                       end
                  else begin {presune se sem jenom cast dalsiho radku, ktera se vejde, a radek se nerusi}
                       move(stranka3[kurzy+1,0],stranka3[kurzy,kurzx],mistonakonci);
                       move(stranka3[kurzy+1,mistonakonci],stranka3[kurzy+1,0],mistonakonci);
                       fillchar(stranka3[kurzy+1,mistonakonci],40-mistonakonci,' ');
                       end;
                  WriteStrankaPlanet(Y1);
                end
           else begin {jednoduche smazani znaku v ramci jednoho radku}
                for i:=kurzx to 38 do
                begin
                  stranka3[kurzy,i]:=stranka3[kurzy,i+1];
                  SVGA_BarZ(i*8,kurzy*16+Y1,i*8+7,kurzy*16+15+Y1,ColX[0]);
                  _Print(i*8,kurzy*16+Y1,ColX[15],stranka3[kurzy,i]);
                end;
                stranka3[kurzy,39]:=' ';
                SVGA_BarZ(39*8,kurzy*16+Y1,39*8+7,kurzy*16+15+Y1,ColX[0]);
                _Print(39*8,kurzy*16+Y1,ColX[15],stranka3[kurzy,39]);
                end;
End;{smazznak}

procedure ZalomRadek3(Y1: Word); {funkce klavesy enter}
var i:word;
Begin
if kurzy=19 then exit; {z posledniho radku uz neni kam entrovat}
{vlozeni radku by ten posledni vysouplo ze stranky, coz nechci, takze jestli
na nem neco je, koncim:}
for i:=0 to 39 do if stranka3[19,i]<>' ' then exit;
{a ted to vkladani:}
for i:=19 downto kurzy+2 do move(stranka3[i-1,0],stranka3[i,0],40); {odsunuti radku dole}
fillchar(stranka3[kurzy+1,0],40,' '); {vymazani toho noveho}
move(stranka3[kurzy,kurzx],stranka3[kurzy+1,0],40-kurzx); {presun dat za kurzorem na zacatek noveho radku}
fillchar(stranka3[kurzy,kurzx],40-kurzx,' '); {vymazani dat za kurzorem z puvodniho radku}
inc(kurzy); kurzx:=0; {kurzor na zacatek noveho radku}
WriteStrankaPlanet(Y1);
End;{zalomradek}
