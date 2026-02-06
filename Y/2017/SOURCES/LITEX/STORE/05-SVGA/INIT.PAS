procedure SVGA_Init;
{Spusti 256barevny graficky rezim 640x480.}
type t_ModeInfo = record {buffer na informace o rezimu}
                  {pro vsechny verze rozhrani VESA:}
                  Atributy:word;{par dulezitych bitu:
                      bit 0: 1 = hardware tento rezim zvladne
                          1: jsou pritomne rozsirene informace (pro VESA 1.2 a vyssi je vzdy 1)
                          2: podporovan vystup pres BIOS
                          3: 0 = cernobily, 1 = barevny
                          4: 0 = textovy, 1 = graficky
                         od verze 2.0:
                          5: 0 = VGA kompatibilni, 1 = ne
                          6: 0 = bankovani podporovano, 1 = ne
                          7: LFB podporovano
                          8: podporovan double scan (= radky se kresli nadvakrat;
                             nutne pro nizka rozliseni, kdy jsou pixely moc vysoke a vykreslovaci paprsek moc tenky)
                         od verze 3.0:
                          9: moznost prokladaneho rezimu (= zobrazuji se jen liche radky nebo tak nejak)
                         10: podporovan hardwarovy triplebuffering
                         11: hardware zvladne stereoskopicke zobrazeni (jsou na to potreba specialni LCD bryle)
                         12: podporovana zdvojena adresa pocatku zobrazeni
                         13..15: rezervovano}
                  AtributyOknaA:byte;{bit 0: okno existuje
                                          1: da se z nej cist
                                          2: da se do nej zapisovat
                                          3..7: rezervovano}
                  AtributyOknaB:byte;{-''-}
                  Granularita:word;{o kolik KB se posune okno, kdyz prepneme na dalsi banku (zivotne dulezita hodnota)}
                  VelikostOkna:word;{[KB]}
                  SegmentOknaA:word;{v real modu prakticky vzdy $A000}
                  SegmentOknaB:word;
                  BankovaciProcedura:pointer;{dulezita procedura na prepinani bank}
                  BytuNaRadek:word;{kolik je celych bytu na radek (v bankovanych rezimech)}
                  {pro VBE 1.2 a vyssi (pro nizsi verze pouze pokud bit 1 v atributech je 1):}
                  RozliseniX:word; {\ rozmery obrazovky v pixelech,}
                  RozliseniY:word; {/    je treba zkontrolovat     }
                  SirkaZnaku,
                  VyskaZnaku:byte;
                  PocetBitovychRovin:byte;{pro 256 barev je to 1}
                  BituNaPixel:byte;{pro 256barevne rezimy 8, tohle zkontrolujeme}
                  PocetBank:byte;
                  PametovyModel:byte;{0 = textak
                                      1 = CGA
                                      2 = HGC
                                      3 = 16barevna EGA
                                      4 = packed pixel (bezna 256barevna grafika, ve ktere tato jednotka pracuje)
                                      5 = "sequ 256" (non-chain 4) graphics
                                      6 = direct color (hicolor nebo truecolor)
                                      7 = YUV
                                      8..15 - rezervovano
                                      16..255 - specialni OEM modely}
                  VelikostBanky:byte;{[KB], obvykle 64}
                  PocetStranek:byte;{kolik stranek se vejde do VRAM (tato hodnota je o 1 mensi nez skutecnost)}
                  Rezervovano1:byte;
                  {pro pametove modely 6 (direct color) a 7 (YUV):}
                  VelikostCerveneMasky:byte;{[b]}
                  PoziceCervene:byte;{pozice LSB cervene masky}
                  VelikostZeleneMasky:byte;
                  PoziceZelene:byte;
                  VelikostModreMasky:byte;
                  PoziceModre:byte;
                  VelikostRezervovaneMasky:byte;
                  PoziceRezervovane:byte;
                  AtributyDirectcoloru:byte;
                  {pro VBE 2.0 a vyssi:}
                  FyzickaFlatAdresa:longint;
                  Rezervovano2:longint;
                  Rezervovano3:word;
                  {pro VBE 3.0 a vyssi:}
                  BytuNaRadek_LFB:word;
                  PocetStranek_BankovaneRezimy:byte;
                  PocetStranek_LFB:byte;
                  VelikostCerveneMasky_LFB:byte;
                  PoziceCervene_LFB:byte;
                  VelikostZeleneMasky_LFB:byte;
                  PoziceZelene_LFB:byte;
                  VelikostModreMasky_LFB:byte;
                  PoziceModre_LFB:byte;
                  VelikostRezervovaneMasky_LFB:byte;
                  PoziceRezervovane_LFB:byte;
                  MaxPixelClock:longint;{maximalni zobrazovaci frekvence [pixelu/s] (mel by to byt dword)}
                  Zbytek:array[1..190] of byte;{doplnek do nutnych 256 B}
                  end;
     p_ModeInfo = ^t_modeinfo;
var vesainfo:p_vesainfo;
    modeinfo:p_modeinfo;
{---}
function JeToOn(rezim:word; var buffer:t_modeinfo):boolean; {nacte informace o rezimu a vrati true, pokud je to ten hledany}
var vysledek:word;
Begin
{$ifdef debug}writeln('Kontroluji rezim c. ',rezim,'...');{$endif}
jetoon:=false;
fillchar(modeinfo^,256,0); {vynulujeme zasobnik (starsi verze VESA to za nas neudelaji)}
asm
mov AX,$4F01    {sluzba "zjisti informace o rezimu"}
mov CX,rezim    {o kterem rezimu}
les DI,buffer   {pripravime zasobnik}
int $10
mov vysledek,AX
end;
if vysledek=$4F then with buffer do
 begin
 jetoon:=((atributy and 25)=25){je to barevny graficky rezim a hardware ho zvladne}
         and ((atributy and 64)=0){funguje v nem bankovani}
         and (((atributyoknaA and 1)<>0)
            or((atributyoknaB and 1)<>0)){existuje presouvatelne okno (cili opet: funguje bankovani)}
         and (((atributy and 2)=0) or ((rozlisenix=_maxx+1)and(rozliseniy=_maxy+1)and(bitunapixel=8)));
          {bud mame VBE 1.0 nebo 1.1 a budeme doufat, ze to vyjde, nebo
          mame novejsi a pak si zkontrolujeme rozliseni a barevnou hloubku}
 if granularita=0 then _granularity:=1
                  else _granularity:=64 div granularita;{prepocitani granularity na pouzitelnou hodnotu}
  {(pozn.: granularitA je polozka infa, _granularitY je globalni promenna)}
 if bankovaciprocedura=nil then __switchbank:=@_nouzovyswitchbank {kdyz to nejde jinak, pouzijeme int $10}
                           else __switchbank:=bankovaciprocedura;
 {urceni zapisovaciho a cteciho okna a segmentu:}
 if (atributyoknaA and 5)=5 then begin {okno A existuje a da se do nej zapisovat}
                                 _zapisovaciokno:=0;
                                 _zapisovacisegment:=segmentoknaA;
                                 end
  else if (atributyoknaB and 5)=5 then begin {okno B existuje a da se do nej zapisovat}
                                       _zapisovaciokno:=1;
                                       _zapisovacisegment:=segmentoknaB;
                                       end
   else begin {zadne z obou oken neni pouzitelne (to se snad vubec nemuze stat)}
        _zapisovacisegment:=$A000; {vychozi hodnoty - tim se snad nic nezkazi}
        _zapisovaciokno:=0;
        end;
 if (atributyoknaA and 3)=3 then begin {okno A existuje a da se z nej cist}
                                 _cteciokno:=0;
                                 _ctecisegment:=segmentoknaA;
                                 end
  else if (atributyoknaB and 3)=3 then begin {okno B existuje a da se z nej cist}
                                       _cteciokno:=1;
                                       _ctecisegment:=segmentoknaB;
                                       end
   else begin
        _ctecisegment:=$A000;
        _cteciokno:=0;
        end;
 end;
End;{jetoon}
{---}
function SpustHo(rezim:word):word; assembler; {spusti graficky rezim, vraci $4F pri uspechu}
Asm
mov AX,$4F02     {sluzba "nastav rezim"}
mov BX,rezim     {cislo rezimu}
xor CX,CX       {pro jistotu}
int $10
{navratova hodnota funkce = AX}
End;{spustho}
{----------------------------------------------------------------------------}
var i:integer;
    vysledek,mode:word;
Begin{_startsvga}
{pripravime navratove zasobniky:}
if maxavail<sizeof(t_vesainfo) then _chcipni(_malopameti) else new(vesainfo);
if maxavail<sizeof(t_modeinfo) then _chcipni(_malopameti) else new(modeinfo);
asm
{jaky rezim zrovna bezi? (mel by to byt textak cili cislo 3, ale jeden nikdy nevi)}
mov AH,15
int $10
mov _puvodnirezim,AL
{zjisteni obecnych informaci o vese:}
mov AX,$4F00         {kod sluzby - "zjisti informace o VESA rozhrani"}
les DI,vesainfo      {adresa zasobniku}
int $10              {a makej...}
mov vysledek,AX      {jak jsme dopadli?}
end;
if (vysledek<>$004F)or((VESAInfo^.Signature<>'VESA')and(VESAInfo^.Signature<>'VBE2'))
  then _chcipni(_nenivesa);
asm
mov AX,$4F00    {nacti informace o VESA}
les DI,vesainfo
int $10
cmp AX,$004F    {povedlo se?}
je @OK
 push _nenivesa {nepovedlo}
 call _chcipni
@OK:
end;
{Nejdriv urcime, ktere cislo rezimu odpovida pozadovanemu 640x480:}
mode:=$101;
if not JeToOn(mode,modeinfo^) then
  begin
  i:=0; {bude slouzit jako index v seznamu rezimu}
   repeat
   mode:=vesainfo^.modelist^[i]; {nacteme kod ze seznamu}
   if (mode=$FFFF){jestli jsme na konci pole...}
      or (i=32767){...nebo taaakhle daleko (coz se teoreticky snad ani nemuze stat)}
     then _chcipni(_rezimnepujde);
   inc(i);
   until jetoon(mode,modeinfo^);
  {cyklus bezi tak dlouho, dokud nenajdeme 256barevny rezim se spravnym rozlisenim}
  end;
if spustho(mode)<>$4F then _chcipni(_neselspustit);
dispose(modeinfo); dispose(vesainfo);
_curbank:=$FFFF; {po inicializaci by mela byt vzdy nastavena banka 0, ale co kdyby nebyla}
End;{svga_init}
