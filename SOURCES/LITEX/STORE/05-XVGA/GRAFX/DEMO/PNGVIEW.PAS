{$A+,B+,E-,F-,G+,I-,N-,O-,P+,Q-,R-,S-,T-,V-,X+,Y-}
{-$DEFINE DEBUG}

uses pngunit,inflate,crt,grafx,gr_vars;

{$IFDEF DEBUG}
var
  lasttime : longint;

function currenttime : longint;assembler;
asm
  mov   es,[seg0040]
  mov   ax,es:[6Ch]
  mov   dx,es:[6Eh]
end;
{$ENDIF}

function setfitmode(xres,yres,colres : word;greyscale : boolean) : boolean;
var
  table,i : byte;
begin
  setfitmode := false;
  if greyscale then table := 0 else
  case colres of
    1,2,4,8 : table := 0;
    else table := 2;
  end;
  for i := 0 to restab[table].avmodes-1 do
  with restab[table] do
  if ((mode[i].resx >= xres)and(mode[i].resy >= yres))or(i = restab[table].avmodes-1) then
  if (mode[i].resy <> 400) then begin
    if (colres <= 8)or(greyscale) then setmode(mode[i].resx,mode[i].resy,8) else
    setmode(mode[i].resx,mode[i].resy,16);
    setfitmode := graphresult = 0;
    exit;
  end;
end;


function showpng(name : string) : byte;
var
  info : timage_info;
  i    : integer;
begin
  if info_png(name,info) = image_filenotfound then
  begin
    writeln('File not found');
    halt;
  end;
  if not setfitmode(info.size.x,info.size.y,info.bpp,info.greyscale) then
  begin
    writeln('Error initializing GFX');
    halt;
  end;
  showpng := loadpng((mxx-info.size.x) div 2,(mxy-info.size.y) div 2,name);
  {$IFNDEF DEBUG}
  readkey;
  {$ENDIF}
end;

var
  b        : byte;
  startmem : longint;
begin
{$IFDEF DEBUG}
  lasttime := currenttime;
  repeat until lasttime <> currenttime;
  lasttime := currenttime;
  startmem := memavail;
{$ENDIF}
  b := showpng(paramstr(1));
  closegraph;
  if b <> image_noerror then
  writeln(image_errorstr[b]);
{$IFDEF DEBUG}
  writeln('Memory difference: ',startmem-memavail);
  writeln('Used time: ',(currenttime-lasttime)/18.2:4:2,' s');
{$ENDIF}
end.