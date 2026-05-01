(*** Fontgrabber ************************************************************
 * Author    : Stefan Goehler, Germany                                      *
 * Version   : 1.0                                                          *
 * Task      : grab the actual system font                                  *
 * Copyright : ? Not for this little program!                               *
 ****************************************************************************)
uses crt;
const
  h = 16; {Char height}

  header : record
  kennung    : string[11];
  version    : word;        {CHS version - at the moment 1.00}
  name       : string[20];
  charsize,height,width : byte;
  chartype   : byte;        {1= Vektor;2= Bitmap;3= Vektor/Polygone}
  colordepth : byte;        {should be obvious with system font}
  startchar,endchar : word; {also}
  distance   : byte;        {pixel distance between the chars}
  reserved   : array[0..18] of byte;
  end = (kennung:'GSCharset>>';version:$0001;name:'';
         charsize:1;height:h;width:8;chartype:2;colordepth:1;
         startchar:0;endchar:255;distance:1);

type
  fonttype = array[0..255] of array[0..h-1] of byte;
var
  f : file;

  chars2,chars : fonttype;
  movedat : word;

  i        : integer;
  ch       : char;
  pointinc : byte;

procedure getchars;
var i : byte;
begin
  portw[$03c4]:=$0402;
  portw[$03c4]:=$0704;
  portw[$03ce]:=$0204;
  portw[$03ce]:=$0005;
  portw[$03ce]:=$0006;
  for i := 0 to 255 do move(ptr(segA000,i shl 5)^,chars2[i],movedat);
  portw[$03c4]:=$0302;
  portw[$03c4]:=$0304;
  portw[$03ce]:=$0004;
  portw[$03ce]:=$1005;
  portw[$03ce]:=$0e06;
end;

procedure writefile(name : string);
begin
  assign(f,name);
  rewrite(f,1);
  blockwrite(f,header,sizeof(header));
  blockwrite(f,chars,sizeof(chars));
  close(f);
end;

procedure setbit(var byt : byte;bit : byte;on : boolean);
var
  zahl : byte;
begin
  zahl := 1;
  zahl := zahl shl pred(bit);
  if on then byt := byt or zahl else byt := byt and not zahl;
end;

function getbit(value,bit : byte) : boolean;assembler;
asm
  mov cl,bit
  mov bl,1
  shl bl,cl
  mov al,value
  and al,bl
  jz @next
    mov al,1
  @next:
end;

var
  x,y : word;
begin
  if paramcount < 2 then begin
    writeln('Fontgrab 1.0 - (c) 1998 by Stefan Goehler (stefan.goehler@gmx.de)');
    writeln('usage: FONTGRAB [filename] [fontname]');
    halt;
  end;
  movedat := h;
  getchars;
  header.name := paramstr(2);
  for i := 0 to 255 do begin
  for y := 0 to movedat-1 do
  for x := 1 to 8 do setbit(chars[i,y],x,getbit(chars2[i,y],8-x));
  end;
  writefile(paramstr(1));
end.
