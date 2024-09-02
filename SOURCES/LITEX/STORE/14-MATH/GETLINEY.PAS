Function Math_GetLineY(a,b,c,d:integer;Vzdalenost:Word): Word;

  function sgn(a:real):integer;
  begin
    if a>0 then sgn:=1
    else
      if a<0 then sgn:=-1
      else sgn:=0;
  end;

var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;
    ErrorOutput,vzd2: Word;
begin
  vzd2:=0;
  u:= c-a;
  v:= d-b;
  d1x:= sgn(u);
  d1y:= sgn(v);
  m:= abs(u);
  n:= abs(v);
  if not(m>n) then
    begin
      d2x:= 0;
      d2y:= d1y;
      i:=m;
      m:=n;
      n:=i;
    end
  else
    begin
      d2x:= d1x;
      d2y:= 0;
    end;
  s:= m shr 1;
  for i:=0 to m do
    begin
      Inc(vzd2);
      If vzd2=Vzdalenost then Math_GetLineY:=b;
      ErrorOutput:=b;
      s:= s+n;
      if not(s<m) then
        begin
          s:= s-m;
          a:= a+d1x;
          b:= b+d1y;
        end
      else
        begin
          a:= a+d2x;
          b:= b+d2y;
        end;
    end;
  If Vzdalenost>vzd2 then Math_GetLineY:=ErrorOutput;
end;