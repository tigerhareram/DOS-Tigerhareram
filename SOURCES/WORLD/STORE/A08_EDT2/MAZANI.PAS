{------------------------------- mazani: ------------------------------------}

procedure SmazVsechnySoubory(cesta:string);
{Smaze soubor index.dat a vsechny textove soubory ve vsech pracovnich
adresarich. Cesta je stejna jako u exportu.}
 procedure VyprazdniAdresar(JmenoAdresare:string);
 {smaze vsechny textove soubory v danem adresari (jmeno pis i s cestou)}
 var sr:searchrec;
     f:file;
 Begin
 findfirst(jmenoadresare+'\*.TXT',anyfile,sr);
 while doserror=0 do
  begin
  if (sr.attr and volumeid=0)and(sr.attr and directory=0)
    then begin
         assign(f,jmenoadresare+'\'+sr.name);
         erase(f);
         if ioresult<>0 then {budu doufat, ze se soubor importem prepise};
         end;
  findnext(sr);
  end;
 End;{vyprazdniadresar}
var i:integer;
    jmeno:string;
    f:file;
Begin
assign(f,cesta+'index.dat');
erase(f);
if ioresult<>0 then {nevadi, uz byl smazany};
for i:=1 to 99 do
 begin
 jmeno:=cesta+'SESITY\SESIT'+nastr(i,2);
 if existujeadresar(jmeno) then vyprazdniadresar(jmeno) else break;
 end;
for i:=1 to 9 do
 begin
 jmeno:=cesta+'BLOKY\BLOK'+nastr(i,1);
 if existujeadresar(jmeno) then vyprazdniadresar(jmeno) else break;
 end;
for i:=1 to 9 do
 begin
 jmeno:=cesta+'KNIHY\KNIHA'+nastr(i,1);
 if existujeadresar(jmeno) then vyprazdniadresar(jmeno) else break;
 end;
End;{smazvsechnysoubory}
