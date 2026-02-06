(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)
(*  Soubor: WOKBARVY.INC                                                   *)
(*  Obsah: konstanty barev pro jednotku Woknows 3                          *)
(*  Autor: Mircosoft                                                       *)
(*  Posledni uprava: 31.12.2009                                            *)
(*  Pro kompilaci: nejaky zdrojak, do ktereho tohle vlozite                *)
(*  Pro spusteni: -''-                                                     *)
(*  Upozorneni: tyto zdrojove kody pouzivate na vlastni nebezpeci          *)
(* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *)

const
(***************************** pro objekty: *********************************)
{tlacitko:}
tlhbarva=15;      {barva leveho a horniho okraje}
tpdbarva=8;       {barva praveho a dolniho okraje}
tvbarva=7;        {barva vnitrku}
ttxtbarva=16;     {barva textu}

{zatrzitko:}
zlhbarva=8;      {levy a horni okraj ctverecku}
zpdbarva=28;     {pravy a dolni okraj}
zvbarva=15;      {vnitrek ctverecku}
zzbarva=0;       {"fajfka" ve ctverecku}
ztxtbarva=0;     {text vedle ctverecku}

{prepinac:}
plhbarva=8;   {levy a horni okraj kolecek}
ppdbarva=28;  {pravy a dolni okraj}
pvbarva=15;   {vnitrek kolecek}
ppbarva=0;    {barva puntiku}
ptxtbarva=0;  {texty}

{roleta:}
slhbarva=8;    {levy a horni okraj textoveho pole}
spdbarva=28;   {pravy a dolni okraj textoveho pole}
svbarva=15;    {vypln textoveho pole}
stxtbarva=0;   {text v tomto poli (vybrana polozka)}
srlhbarva=0;   {levy a horni okraj rolety s nabidkou}
srpdbarva=0;   {pravy a dolni okraj rolety}
srvbarva=15;   {vypln rolety}
srntxtbarva=0; {barva textu neaktivnich polozek v rolete}
sratxtbarva=15;{barva aktivnich textu v rolete (tech, na ktere ukazuje mys)}
sravbarva=1;   {podklad aktivnich textu v rolete}
sskrtbarva=12; {kdyz nebyly zadany zadne moznosti, okenko bude touhle barvou preskrtnute}
{rozbalovaci tlacitko ma barvy jako bezne tlacitko}

{posuvnik:}
posbarva=26;    {barva stredni casti posuvniku}
{posuvny ramecek ma barvu jako tlacitka}

{ciselnaosa:}
colhbarva=8;   {levy a horni okraj drazky}
copdbarva=15;  {pravy a dolni okraj drazky}
covbarva=7;    {vypln drazky}
cotxtbarva=0;  {texty a "vroubky" pod drazkou}
{posuvny obdelnicek ma stejne barvy jako tlacitka}

{textovepole a textovepole2:}
tplhbarva=8;        {levy a horni okraj}
tppdbarva=28;       {pravy a dolni okraj}
tpvbarva=15;        {barva pozadi pod textem}
tptxtbarva=0;       {neoznaceny text}
tpkbarva=16;        {kurzor (nedavat nulu, kresli se xorem!)}
tpozntxtbarva=15;   {oznaceny text}
tpozntxtpodbarva=1; {podklad oznaceneho textu}
tpmimobarva=26;     {barva pozadi za koncem textu (pouze textovepole2)}
tpchtxtbarva=12;    {barva textu chybovych hlasek (pouze textovepole2)}

tpneaktozntxtpodbarva=23; {podklad oznaceneho textu v neaktivnim poli}

{konzole:}
konlhbarva=8;   {levy a horni okraj}
konpdbarva=15;  {pravy a dolni okraj}
konvbarva=15;   {vypln}

{menu:}
mlhbarva=15;   {levy a horni okraj okna menu}
mpdbarva=8;    {pravy a dolni okraj okna}
mvbarva=7;     {vypln okna}
mtxtbarva=0;   {barva uvodniho textu nad tlacitky}
minlhbarva=8;  {levy a horni okraj neaktivnich tlacitek}
minpdbarva=8;  {pravy a dolni okraj neaktivnich tlacitek}
minvbarva=7;   {vypln neaktivnich tlacitek}
mintxtbarva=8; {barva textu v neaktivnich tlacitkach}
mialhbarva=15; {levy a horni okraj aktivnich tlacitek}
miapdbarva=8;  {pravy a dolni okraj aktivnich tlacitek}
miavbarva=29;  {vypln neaktivnich tlacitek}
miatxtbarva=0; {barva textu v aktivnich tlacitkach}
mislhbarva=8;  {levy a horni okraj stisknutych tlacitek}
mispdbarva=15; {pravy a dolni okraj stisknutych tlacitek}
misvbarva=22;  {vypln stisknutych tlacitek}
mistxtbarva=15;{barva textu ve stisknutych tlacitkach}

{okno:}
olhbarva=15;      {levy a horniho okraj}
opdbarva=8;       {pravy a dolni okraj}
ovbarva=7;        {vypln okna}
oobdbarva=1;      {lista s nadpisem}
obarvanadpisu=15; {text nadpisu}
opozadinamazani=0;{barva, kterou se smaze okno, pokud nestacila pamet na ulozeni pozadi}
oembarva=7;       {barva, kterou se v takovem pripade vypise chybova hlaska}


(************************* pro procedury a funkce: **************************)

{infokno:}
iolhbarva=27;     {levy a horni okraj}
iopdbarva=24;     {pravy a dolni okraj}
iovbarva=14;      {vnitrek}
iobarvatextu=16;  {text}

{okokno, anoneokno:}
txtbarva=16;  {text v okne}

{nabidka:}
nhbarva=8;        {horni pulka rozdelovacich car}
ndbarva=15;       {dolni pulka rozdelovacich car}
ntxtbarva=16;      {neoznaceny text}
nozntxtbarva=15;  {oznaceny text}
nozntxtpodbarva=1;{podklad oznaceneho textu}
{cely ramecek ma barvu jako bezne okno}

{nastaveniklaves:}
nkatxtbarva=14;   {text prave zadavane polozky}
nkatxtpodbarva=12;{pozadi textu prave zadavane polozky}
{ostatni barvy jsou jako u textoveho pole}


{EOF}