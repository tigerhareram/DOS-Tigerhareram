Procedure Hit100D;

Type
{Sun}  RGBPal256=array[0..255,1..3] of Byte;

Const
{Sun} MaxRGB=63; {Nejvetsi mozna hodnota slozky barvy palety. Pri vychozim
                  nastaveni VGA je to 63, po prepnuti karty do 8bitoveho
                  rezimu muze byt 255.}

      prvni=224;  {prvni vyhrazena barva}
      sirka=16;   {sirka prouzku v palete}

Var
{Sun} pal:rgbpal256;
      mircosoftSmer: Byte;
      I:Byte;


procedure PripravPaletu(var p:rgbpal256; {pole, do ktereho se barvy ulozi (vystup)}
                        PrvniBarva, {index prvni barvy, ktera se pro animaci v palete vyhradi}
                        SirkaProuzku:byte); {pocet vyhrazenych barev v palete
                                             a zaroven sirka viditelnych prouzku na obrazovce}
var i, {pomocna pro rizeni cyklu}
    b, {vysledna hodnota barevnych slozek}
    PulSirky:word; {pomocna, aby se to nemuselo pocitat vickrat}
Begin
pulsirky:=sirkaprouzku div 2;
for i:=0 to sirkaprouzku-1 do {cyklus pres vsechny vyhrazene barvy}
 begin
 {Zvolil jsem si, ze od zacatku do pulky vyhrazeneho useku se barvy postupne
 meni z cerne na bilou a ve druhe pulce zase tmavnou zpatky do cerne.
 Prubeh ma tvar zubu pily - linearne nahoru od 0 do Maxrgb a pak linearne
 dolu:}
 if i<=pulsirky then b:=(2*maxrgb*i) div sirkaprouzku
                else b:=(2*maxrgb*(sirkaprouzku-i)) div sirkaprouzku;
 {nebo jinak - sinusovy prubeh od cerne do bile a zase zpatky:}
{ b:=round((maxrgb/2)*sin((2*pi/sirkaprouzku)*i-pi/2)+maxrgb/2);}
 {kreslim v odstinech sede, tak jsou vsechny tri slozky stejne:}
 p[prvnibarva+i,1]:=b;
 p[prvnibarva+i,2]:=b;
 p[prvnibarva+i,3]:=b;
 end;
End;{pripravpaletu}


{posun vyhrazeneho useku palety o jeden krok doleva
(bez aplikace na obrazovku), parametry jsou tytez jako pri priprave:}
procedure RotujPaletuDoleva(var p:rgbpal256; PrvniBarva,SirkaProuzku:byte);
var i,r,g,b:byte;
Begin
{zaloha barvy z leveho konce:}
r:=p[prvnibarva,1];
g:=p[prvnibarva,2];
b:=p[prvnibarva,3];
{posun celeho useku o jednu pozici doleva:}
for i:=0 to sirkaprouzku-2 do p[prvnibarva+i]:=p[prvnibarva+i+1];
{vlozeni barvy z leveho konce na pravy:}
p[prvnibarva+sirkaprouzku-1,1]:=r;
p[prvnibarva+sirkaprouzku-1,2]:=g;
p[prvnibarva+sirkaprouzku-1,3]:=b;
End;{rotujpaletudoleva}


{to same pro opacny smer:}
procedure RotujPaletuDoprava(var p:rgbpal256; PrvniBarva,SirkaProuzku:byte);
var i,r,g,b:byte;
Begin
{zaloha barvy z praveho konce:}
r:=p[prvnibarva+sirkaprouzku-1,1];
g:=p[prvnibarva+sirkaprouzku-1,2];
b:=p[prvnibarva+sirkaprouzku-1,3];
{posun celeho useku o jednu pozici doprava:}
for i:=sirkaprouzku-1 downto 1 do p[prvnibarva+i]:=p[prvnibarva+i-1];
{vlozeni barvy z praveho konce na levy:}
p[prvnibarva,1]:=r;
p[prvnibarva,2]:=g;
p[prvnibarva,3]:=b;
End;{rotujpaletudoprava}


{vykresleni obrazce na obrazovku (bez operaci s paletou):}
procedure VykresliObrazec(xStredu,yStredu, {kde na obrazovce ma byt stred obrazce}
                          Sirka,Vyska, {celkove rozmery obrazce}
                          PocetPaprsku:integer; {pri hodnotach nad cca 100 se pixely kolem stredu slevaji
                                                 a vznikaji zajimave interferencni vzory, }
                          PrvniBarva,SirkaProuzku:byte);{stejne hodnoty jako pri priprave palety}
var x,y:longint; {longint je nutny, aby to pri umocnovani nepretekalo}
    barva:byte;
    uhel,polomer:real;
Begin
for y:=-(vyska div 2) to vyska div 2 do    {cyklus pres vsechny body obrazce}
 for x:=-(sirka div 2) to sirka div 2 do
  begin
  {Nejdriv je potreba prepocitat kartezske souradnice bodu (x a y) na polarni
  (uhel a polomer). Uhel je trochu slozitejsi, protoze arctan nedava uplne
  jednoznacne vysledky:}
  if x>0 then uhel:=arctan(y/x) {1. a 4. kvadrant}
         else if x<0 then uhel:=pi+arctan(y/x) {2. a 3. kvadrant}
                     else if y>=0 then uhel:=pi/2 {primo nahoru}
                                  else uhel:=3*pi/2; {primo dolu}
  {polomer je jednoducha Pythagorova veta:}
  polomer:=sqrt(sqr(x)+sqr(y));
  {drobne zvlneni paprsku:}
  uhel:=uhel+0.007*sin(0.13*polomer); {jestli chces paprsky rovne, tenhle radek zrus}
  {normalizace uhlu do kladnych hodnot - dulezite pro vypocet barvy:}
  if uhel<0 then uhel:=uhel+2*pi; {2*pi = 360 stupnu}
  {barva je zase linearne interpolovana z rezervovaneho useku palety:}
  barva:=prvnibarva+round(uhel*sirkaprouzku*pocetpaprsku/(2*pi)) mod sirkaprouzku;
  {a kresleni:}
  SVGA_Pixel(xstredu+x,ystredu+y,barva);
  end;
End;{vykresliobrazec}


procedure NastavCelouPaletu(var pal:rgbpal256); assembler; {by Asp / VR group}
Asm
mov DX,$03C8
xor AX,AX
out DX,AL     {port[$03C8]:=0}
push DS
lds SI,pal    {priprav do DS:SI adresu palety}
inc DX
mov CX,768
 rep outsb    {port[$03C9]:=postupne kazdy byte palety}
pop DS
{mov _jas,100  {jas 100%}
End;{nastavceloupaletu}

{*--* *---------------------------------------------------------------* *--*}

Begin
  SVGA_TogglePaging;
  pripravpaletu(pal,prvni,sirka);
  For I:=prvni to prvni+sirka-1 do P16_SetPal(I,pal[I,1],pal[I,2],pal[I,3]);
  vykresliobrazec(320,240,640,480,60,prvni,sirka);
  Repeat
    SVGA_WaitRetrace;
    If mircosoftSmer=0 then rotujpaletudoprava(pal,prvni,sirka)
                       else rotujpaletudoleva(pal,prvni,sirka);
    For I:=prvni to prvni+sirka-1 do P16_SetPal(I,pal[I,1],pal[I,2],pal[I,3]);
    If Key[28]=1 then
    Begin
      Kbd_RPush(28);
      If mircosoftSmer=0 then mircosoftSmer:=1 else mircosoftSmer:=0;
    End;
  Until Key[1]=1;
  Kbd_RPush(1);
  SVGA_TogglePaging;
End;