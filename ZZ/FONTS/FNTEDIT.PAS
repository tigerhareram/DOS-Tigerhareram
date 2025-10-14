(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: FNTEDIT.PAS                                                    *)
(*  Obsah: editor na rastrove fonty (*.FNT)                                *)
(*  Autor: Mircosoft (http://mircosoft.mzf.cz)                             *)
(*  Posledni uprava: 30.10.2020                                            *)
(*  Pro kompilaci: viz Uses                                                *)
(*  Pro spusteni: STDSIPKA.KUR, MSDFLT.FNT                                 *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)

{dodelat:
- posun znaku
- import z PCX
- zesikmeni
- globalni zmena vysky
- protazeni?}

program Editor_na_fonty;
{$B-,I-,R-,S-,X-,D-,L-}
uses vesa2,grafika4,mys4,woknows4,klavesy2,konst,retezce,disk,cfg;

{format FNT souboru:

 vyska pisma (byte) = pocet radku jednoho znaku
 doporucena roztec (byte)
 doporucena velikost (byte) - dolni 4 bity urcuji velikostX, horni velikostY
 data (array[#0..#255,1..vyska] of byte)
}

const ycisla=240;
      yznaku=250;

type PoleBytu=array[0..0] of byte;
     UkNaPB=^polebytu;

var fn:_font;{aktualne upravovany font}
    krpole:array[0..29,0..7]of boolean;{kreslici pole}
    i,j:word;{pomocne indexy}
    vybrany:byte;{ordinalni cislo vybraneho znaku, ktery se prave upravuje}
    ttp:textovepole;{pro psani zkusebniho textu}
    vyska:byte;{vyska aktualniho fontu (totez jako fn.fvyska, jen pro kratsi zapis)}
    soubor:string[79];
    o:word;{pro klavesnici}

procedure NactiZnak;{nacte znak Vybrany z fontu do Krpole a zobrazi ho}
var pom,x,y:byte;
Begin
for y:=0 to vyska-1 do
  begin
  pom:=uknapb(fn.glyphdata)^[vyska*vybrany+y];
  for x:=0 to 7 do krpole[y,x]:=((pom shr (7-x)) and 1)=1;
  end;
kvyp;
for i:=0 to vyska-1 do
 for j:=0 to 7 do _bar(j shl 4+1,i shl 4+1,j shl 4+15,i shl 4+15,ord(krpole[i,j])shl 1);
kzap;
End;{nactiznak}

procedure UlozZnak;{ulozi znak z KrPole do fontu a zobrazi ho}
var pom,x,y:byte;
Begin
for y:=0 to vyska-1 do
  begin
  for x:=0 to 7 do begin
                   pom:=pom shl 1;
                   pom:=pom or ord(krpole[y,x]);
                   end;
  uknapb(fn.glyphdata)^[vyska*vybrany+y]:=pom;
  end;
kvyp;
_bar(141+(vybrany and 15)*9,(vybrany shr 4)*(vyska+1)+1,{vymazani puvodniho znaku}
     140+(vybrany and 15)*9+8,(vybrany shr 4)*(vyska+1)+vyska,0);
_setfont(fn,false);
_settextscale(1,1,8);
__print(141+(vybrany and 15)*9,(vybrany shr 4)*(vyska+1)+1,2,0,chr(vybrany));{napsani noveho}
kzap;
End;{ulozznak}

procedure VyberZnak(cislo:byte);
Begin
kvyp;
__rectangle(140+(vybrany and 15)*9,(vybrany shr 4)*(vyska+1),
            149+(vybrany and 15)*9,(vybrany shr 4)*(vyska+1)+vyska+1,8,_outline);
ulozznak;
vybrany:=cislo;
kvyp;
__rectangle(140+(vybrany and 15)*9,(vybrany shr 4)*(vyska+1),
            149+(vybrany and 15)*9,(vybrany shr 4)*(vyska+1)+vyska+1,15,_outline);
_setfont(wokfont,true);
napis(349,ycisla,10,0,nastr2(vybrany,3));
napis(507,yznaku,10,0,chr(vybrany));
_setfont(fn,true);
nactiznak;
End;{vyberznak}

procedure KresliSadu;{vykresli celou znakovou sadu}
var i:word;
Begin
kvyp;
_bar(140,0,284,479,0);{vymazani cele sady}
for i:=0 to 16 do begin{mrizka}
                  _hline(140,284,i*vyska+i,8);
                  _vline(140+i shl 3+i,0,vyska shl 4+16,8,0);
                  end;
_setfont(fn,false);
_settextscale(1,1,8);
for i:=0 to 255 do __print(141+(i and 15)*9,(i shr 4)*(vyska+1)+1,2,0,chr(i));{znaky}
_setfont(fn,true);           {mod 16}     {div 16}
kzap;
End;{kreslisadu}

procedure Load;
var jak:byte;
    posunuti:shortint;
    i,y,z:byte;
    vychozi:_font;
    vychozisoubor:string[79];
Begin
if soubor='' then begin
                  okokno('Nebylo zad no jm‚no souboru, nem…§u proto nic naŸ¡st.|');
                  exit;
                  end;
_disposefont(fn);
_loadfont2(fn,soubor);
vyska:=fn.glyphheight;
if fn.glyphdata=nil
  then begin
       vyska:=vlozcislookno('Zadej vìçku p¡sma [pix.]:',1,30,8);
       fn.glyphheight:=vyska;
       getmem(fn.glyphdata,256*vyska);
       fillchar(fn.glyphdata^,256*vyska,0);
       vychozisoubor:=vybersouborokno('Zalo§it na:','','*.FNT',false);
       _loadfont2(vychozi,vychozisoubor);
       if vychozi.glyphdata<>nil
         then begin
              posunuti:=vlozcislookno('odsazen¡ od horn¡ho okraje:',0,vyska-1,0);
              for i:=0 to 255 do
               begin
               z:=0;
               for y:=posunuti to vyska-1 do
                begin
                uknapb(fn.glyphdata)^[i*vyska+y]:=uknapb(vychozi.glyphdata)^[i*vychozi.glyphheight+z];
                inc(z);
                if z>=vychozi.glyphheight then break;
                end;
               end;
              _disposefont(vychozi);
              end;
       fn.stdxscale:=vlozcislookno('Jakou doporuŸujete Xovou velikost?',0,15,1);
       fn.stdyscale:=vlozcislookno('A jakou Yovou?',0,15,1);
       fn.stdpitch:=vlozcislookno('A co rozteŸ?',0,255,8);
       end;
kreslisadu;
nactiznak;
vyberznak(vybrany);
infokno(320,240,'NaŸteno.',true);
End;{load}

procedure Save;
Begin
ulozznak;
_setfont(wokfont,true);
if _savefont(fn,soubor) then infokno(320,240,'Ulo§eno.',true)
                        else okokno('Chyba pýi ukl d n¡.');
_setfont(fn,true);
End;{save}

BEGIN
cfgsoubor:='FNTEDIT.CFG';
fn.glyphdata:=nil;
_setmode(_640x480); initmys; zapniobsluhumysi; initwoknows(true,true,true);
dialogystandardnimfontem:=true; nactinastavenimysi;
{soubor:}
if paramcount=0 then repeat
                     soubor:=vybersouborokno('',soubor,'*.FNT',false)
                     until soubor<>''
                else soubor:=paramstr(1);
load;
_setfont(wokfont,true);
kvyp;
{mrizka kresliciho pole (vysku nastavila procedura Load):}
for i:=0 to vyska do _hline(0,128,i shl 4,6);
for j:=0 to 8 do _vline(j shl 4,0,vyska shl 4,6,0);
{popisky:}
__print(290,10,7,0,'Myç:');
__print(290,20,7,0,'lev‚ tlaŸ¡tko: v kreslic¡m poli vybarv¡ bod,');
__print(410,30,7,0,'v tabulce znak… vybere znak.');
__print(290,40,7,0,'prav‚ tlaŸ¡tko: v kreslic¡m poli vyma§e bod,');
__print(370,50,7,0,'v tabulce znak… vyma§e celì znak.');
__print(290,70,7,0,'Kl vesnice:');
__print(290,80,7,0,lsipkazn+psipkazn+hsipkazn+dsipkazn+': vìbØr znaku');
__print(290,90,7,0,'Del: vymaz n¡ znaku');
__print(290,100,7,0,'F2: ulo§en¡');
__print(290,110,7,0,'F3: naŸten¡');
__print(290,120,7,0,'K: kop¡rov n¡ vybran‚ho znaku');
__print(290,130,7,0,'U: ulo§en¡ upravovan‚ho znaku do tabulky');
__print(290,140,7,0,'R: pýenastaven¡ parametr… p¡sma');
__print(290,150,7,0,'M: nastaven¡ vlastnost¡ myçi');
__print(290,160,7,0,'Esc: konec');

__print(290,180,7,0,'soubor:');
__print(290,190,10,0,right(soubor,40));

__print(290,200,7,0,'Parametry fontu:');
__print(290,210,7,0,'vìçka:'); __print(350,210,10,0,nastr(vyska));
__print(290,220,7,0,'rozteŸ:'); __print(350,220,10,0,nastr(fn.stdpitch));

__print(290,ycisla,7,0,'znak: %%b010#');
__print(290,yznaku,7,0,'syst‚movìm fontem obvykle: ');

__rectangle(552,381,639,409,9,_outline);
__print(561,386,9,0,'Mircosoft');
__print(565,396,9,0,'FontEdit');

_setfont(fn,true); {takto je nastaven v celem hlavnim cyklu, na jine nastaveni se prepina jen chvilkove a zase se vraci sem}

ttp.init(1,470-_textheight,630 div fn.stdpitch,'Toto je testovac¡ pole pro vyzkouçen¡ upravovan‚ho fontu.',false,false);
vyberznak(65);
 Repeat{hlavni cyklus}
 cekej;
 if ttp.stav<>_aktivni then
 if lmys
   then begin
        if mysvpoli(0,0,127,16*vyska-1)
          then begin{nakresleni bodu}
               i:=ymys shr 4;{y}
               j:=xmys shr 4;{x}
               krpole[i,j]:=true;
               kvyp;
               _bar(j shl 4+1,i shl 4+1,j shl 4+15,i shl 4+15,2);
               kzap;
               end
          else if mysvpoli(140,0,140+16*9-1,(vyska+1)shl 4-1)
                 then begin{vyber znaku}
                      vyberznak(((ymys div(vyska+1)) shl 4)+((xmys-140) div 9));
                      resetuj;
                      end;
        end
  else if pmys
         then begin
              if mysvpoli(0,0,127,16*vyska-1)
                then begin{smazani bodu}
                     i:=ymys shr 4;
                     j:=xmys shr 4;
                     krpole[i,j]:=false;
                     kvyp;
                     _bar(j shl 4+1,i shl 4+1,j shl 4+15,i shl 4+15,0);
                     kzap;
                     end
               else if mysvpoli(129,0,139,479) then resetuj{abych omylem nesmazal znak,
                                       kdyz mi pri mazani bodu vyjede kurzor z kreslici plochy.
                                                   Moc to sice nepomaha, ale aspon neco.}
                else if mysvpoli(140,0,140+16*9-1,(vyska+1)shl 4-1)
                       then begin{smazani znaku}
                            i:=((ymys div(vyska+1)) shl 4)+((xmys-140) div 9);
                            vyberznak(i);
                            if anoneokno('Opravdu chcete znak '''+chr(vybrany)+''' vymazat?') then
                             begin
                             fillchar(uknapb(fn.glyphdata)^[vyska*vybrany],vyska,0);
                             nactiznak;
                             kvyp;
                             _bar(141+(vybrany and 15)*9,(vybrany shr 4)*(vyska+1)+1,
                                  140+(vybrany and 15)*9+8,(vybrany shr 4)*(vyska+1)+vyska,0);
                             kzap;
                             end;
                            resetuj;
                            end;
              end {if pmys}
   else if keypressed
          then begin
               o:=xreadkey;
               case o of
                xlsipka:if vybrany>0 then vyberznak(vybrany-1);
                xpsipka:if vybrany<255 then vyberznak(vybrany+1);
                xhsipka:if vybrany shr 4>0 then vyberznak(vybrany-16);
                xdsipka:if vybrany shr 4<15 then vyberznak(vybrany+16);
                xdel:if anoneokno('Opravdu chcete znak '''+chr(vybrany)+''' vymazat?')
                       then begin
                            fillchar(uknapb(fn.glyphdata)^[vyska*vybrany],vyska,0);
                            nactiznak;
                            kvyp;
                            _bar(141+(vybrany and 15)*9,(vybrany shr 4)*(vyska+1)+1,
                                 140+(vybrany and 15)*9+8,(vybrany shr 4)*(vyska+1)+vyska,0);
                            kzap;
                            end;
                xF2:save;
                xF3:begin
                    kvyp;
                    _bar(0,470-_textheight,639,479,0);
                    load;
                    ttp.init(1,470-_textheight,630 div fn.stdpitch,ttp.hodnota,false,false);
                    end;
                ord('k'):begin{kopie vybraneho znaku nekam}
                         ulozznak;
                         resetuj;
                         _setfont(wokfont,true);
                         infokno(390,50,lsipkazn+' Vyber c¡lovou pozici.',ne);
                         _setfont(fn,true);
                         _settextscale(1,1,8);
                         if mysvpoli(140,0,140+16*9-1,(vyska+1)shl 4)
                           then begin
                                i:=((ymys div(vyska+1)) shl 4)+((xmys-140) div 9);
                                for j:=0 to vyska-1 do
                                 uknapb(fn.glyphdata)^[vyska*i+j]:=uknapb(fn.glyphdata)^[vyska*vybrany+j];
                                kvyp;
                                _bar(141+(i and 15)*9,(i shr 4)*(vyska+1)+1,
                                     140+(i and 15)*9+8,(i shr 4)*(vyska+1)+vyska,0);
                                __print(141+(i and 15)*9,(i shr 4)*(vyska+1)+1,2,0,chr(i));
                                vyberznak(i);
                                end;
                         resetuj;
                         end;
                ord('u'):begin
                         ulozznak;{aktualizace znaku v sade}
                         _setfont(fn,true);
                         end;
                ord('r'):begin{nastaveni standardnich rozmeru}
                         fn.stdxscale:=vlozcislookno('Xov  velikost:',1,15,fn.stdxscale);
                         fn.stdyscale:=vlozcislookno('Yov  velikost:',1,15,fn.stdyscale);
                         fn.stdpitch:=vlozcislookno('rozteŸ:',0,255,fn.stdpitch);
                         _setfont(wokfont,true);
                         kvyp;
                         napis(350,220,10,0,nastr(fn.stdpitch)+'  ');
                         _setfont(fn,true);
                         _bar(0,470-_textheight,639,479,0);
                         ttp.init(1,470-_textheight,630 div fn.stdpitch,ttp.hodnota,false,false);
                         end;
                ord('m'):nastavmysokno(true);
                end;
               end;{if keypressed}
 ttp.kontrola;
 if ttp.stav=_aktivni then resetuj;
 Until o=xEsc;
_disposefont(fn);
zrusobsluhumysi;
zruswoknows;
_setmode(_textmode);
END.