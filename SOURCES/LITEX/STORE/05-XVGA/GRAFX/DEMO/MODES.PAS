{ Little program to show how to access the mode-table of GrafX to find
  available graphical modes }
uses gr_vars,grafx,crt;
var
  i,num : integer;

begin
  gettext;
  textattr := blue shl 4+white;
  clrscr;
  writeln('**** '+grafx_version+' - Available modes on this card ****');
  writeln;
  writeln('   8 bit         15 bit        16 bit        24 bit        32 bit');
  for i := 0 to 4 do begin
    num := restab[i].avmodes;   { Get available modes        }
    if num > 20 then num := 20; { Don't go out of the screen }
    for num := 1 to num do begin
      gotoxy(i*14+4,num+4);
      write(restab[i].mode[num-1].resx,'x',restab[i].mode[num-1].resy);
    end;
  end;
  readkey;
  textattr := lightgray;
  clrscr;
  puttext;
end.