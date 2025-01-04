{----------------------------- import: --------------------------------------}

procedure ImportujKnihovnu(Cesta,Uzivatel:string);
{Cesta, Uzivatel - jako u exportu. Puvodni textove soubory a index se
automaticky smazou a budou nahrazeny importovanym obsahem.}
var PrevodniTabulka:pole256znaku;
 procedure RozeberSoubor(jmeno:string; var info:tknihovnainfo);
 {Importuje veskera data z daneho HTML souboru. Jmeno pis i s cestou.
 Do parametru Info se ulozi nadpisy, ktere se v souboru najdou.}
 var vstup:turbosoubor;
     vystup:file;
     slovo,JmenoSouboru:string;
     typ,index:byte;
     VysledekPrevodu:integer;
 Begin
 vstup.init(60000);
 if vstup.buffer=nil then exit;
 vstup.otevri(jmeno);
 typ:=0; index:=0;
 while not vstup.nakonci do
  begin
  vstup.najedza('<!--dalsi=');
  inc(strankovaniloadu);
  SVGA_BarZ(332,456,332+24,456+8,ColX[0]);
  Text_OutNumber(332,456,strankovaniloadu,False,Buffer[0],SVGA);
  SVGA_FlipPage;
  slovo:=vstup.ctido('%%');
  if slovo='typ'
    then begin
         {tvar dat: <!--dalsi=typ%%1%%-->}
         slovo:=vstup.ctido('%%-->');
         val(slovo,typ,vysledekprevodu);
         if (vysledekprevodu<>0) or (typ<1) or (typ>3) then typ:=0;
         end
   else if slovo='index'
          then begin
               {<!--dalsi=index%%2%%-->}
               slovo:=vstup.ctido('%%-->');
               val(slovo,index,vysledekprevodu);
               if (vysledekprevodu<>0) or (typ=0) or (index<1)
                  or (typ=1) and (index>10)
                  or ((typ=2)or(typ=3)) and (index>5)
                 then index:=0;
               end
    else if slovo='nadpis'
           then begin
                {<!--dalsi=nadpis%%Nadpis sesitu 1%%--> (tenhle nadpis je v dosovskem kodovani)}
                slovo:=vstup.ctido('%%-->');
                if vstup.hotovo and (slovo<>'') and (typ<>0) and (index<>0)
                  then case typ of 1:info.jmenasesitu[index-1]:=slovo;
                                   2:info.jmenabloku[index-1]:=slovo;
                                   3:info.jmenaknih[index-1]:=slovo;
                                   end;
                typ:=0; index:=0;
                end
     else if slovo='soubor'
            then begin
                 {<!--dalsi=soubor%%zdrojaky\thr\outputs\world\knihovna\SESITY\SESIT02\001.TXT%%-->
                 ...obsah souboru (bez CRLF pred a za)...
                 <!--/soubor-->}
                 jmenosouboru:=vstup.ctido('%%-->');
                 assign(vystup,jmenosouboru);
                 rewrite(vystup,1);
                 if ioresult=0 then begin
                                     repeat
                                     slovo:=vstup.ctido('<!--/soubor-->');
                                     prekoduj(slovo[1],length(slovo),prevodnitabulka);
                                     blockwrite(vystup,slovo[1],length(slovo));
                                     until vstup.hotovo or vstup.nakonci or (ioresult<>0);
                                    close(vystup);
                                    if ioresult<>0 then ;
                                    end;
                 end;
  end;
 vstup.zrus;
 End;{rozebersoubor}
var vystup:file;
    KnihovnaInfo:TKnihovnaInfo;
    IndexKnihy:byte;
Begin
{pripravy:}
fillchar(knihovnainfo,sizeof(knihovnainfo),0);
PripravPrevodniTabulku(kwindows1250,klatin2,prevodnitabulka);
{udelame si misto:}
smazvsechnysoubory(cesta);
{importujeme data:}
FindFirst(cesta+'1HTML\'+uzivatel+'\blok.htm', Archive, DirInfo);
If DosError = 0 then {existuje}
  rozebersoubor(cesta+'1HTML\'+uzivatel+'\blok.htm',knihovnainfo);
FindFirst(cesta+'1HTML\'+uzivatel+'\kniha6.htm', Archive, DirInfo);
If DosError = 0 then {existuje}
  rozebersoubor(cesta+'1HTML\'+uzivatel+'\kniha6.htm',knihovnainfo);
for indexknihy:=1 to 5 do
Begin
  FindFirst(cesta+'1HTML\'+uzivatel+'\kniha'+nastr(indexknihy,0)+'.htm' , Archive, DirInfo);
  If DosError = 0 then {existuje}
    rozebersoubor(cesta+'1HTML\'+uzivatel+'\kniha'+nastr(indexknihy,0)+'.htm',knihovnainfo);
End;
{a ulozime nadpisy, ktere se behem importu nacetly:}
assign(vystup,cesta+'index.dat');
rewrite(vystup,sizeof(knihovnainfo));
blockwrite(vystup,knihovnainfo,1);
close(vystup);
if ioresult=0 then ;
End;{importujknihovnu}
