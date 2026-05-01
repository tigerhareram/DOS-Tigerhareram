{Small example how to fade images over - nothing fast to hold the overview
 Hey, just to show you the flexibility of GrafX: try it with 8 bpp... it
 looks a bit crappy, but it works!!                                        }
uses crt,grafx,pngunit;
var
  i,x,y          : integer;
  r,g,b,cr,cg,cb : byte;
  upward         : boolean;
begin
  setmode(640,480,16);
  i := graphresult;
  if i <> 0 then begin
    textmode(3);
    writeln('Sorry, an error occured');
    writeln('Grafx says: '+grapherrormsg(i));
    writeln('Press the anykey');
    readkey;
    halt;
  end;
  {Ok, when we get here, there were obviously no probs...}
  writexy(0,10,'Images to overfade:');
  i := loadpng(0,20,'fadeover.png');
  if i <> image_noerror then begin
    closegraph;
    writeln('Sorry, an error occured while loading fadeover.png:');
    writeln(image_errorstr[i]);
  end;
  writexy(0,80,'The result...');
  {All right...? Then let's start!!}
  i      := 0;
  upward := true;
  repeat
    waitretrace;
    for y := 0 to 39 do
    for x := 0 to 159 do begin
      dergb(getpixel(x,y+20),cr,cg,cb);
      dergb(getpixel(x+160,y+20),r,g,b);
      cr := (word(cr)*((31-i) shl 3)) shr 8+(word(r)*(i shl 3)) shr 8;
      cg := (word(cg)*((31-i) shl 3)) shr 8+(word(g)*(i shl 3)) shr 8;
      cb := (word(cb)*((31-i) shl 3)) shr 8+(word(b)*(i shl 3)) shr 8;
      putpixel(x,y+90,rgb(cr,cg,cb));
    end;
    if upward then inc(i) else dec(i);
    if (i = 0)or(i = 31) then upward := not upward;
  until keypressed;
  {Whew?? Stopped?}
  while keypressed do readkey;
  closegraph;
  {And bye...}
end.

