procedure SVGA_Ellipse(centerX,centerY,rx,ry:word; color:byte; style:byte);
{Nakresli elipsu.
 centerX, centerY - souradnice stredu
 rX, rY - vodorovny a svisly polomer
 Color - barva obrysu nebo vyplne
 Style - 0 = obrys, 1 = vyplnena}
var x,y:word;
    a,b,as,tas,bs,tbs:longint;
    d,dx,dy:longint;
Begin
if rx=0 then begin {nulova sirka - neni to elipsa, ale svisla cara}
             svga_VLine(centerx,centery-ry,centery+ry,color);
             exit;
             end;
if ry=0 then begin {nulova vyska - neni to elipsa, ale vodorovna cara}
             svga_HLine(centerx-rx,centerx+rx,centery,color);
             exit;
             end;
{Nasledujici algoritmus jsem nepochopil. Je to nejaka varianta Bresenhama.}
x:=0; y:=ry; a:=rx; b:=ry; as:=a*a;
tas:=as shl 1; bs:=b*b; tbs:=bs shl 1;
d:=bs-as*b+(as shr 2); dx:=0; dy:=tas*b;
while dx<dy do begin
               if style=1
                 then begin
                      svga_HLine(centerX-x,centerX+x,centerY+y,color);
                      svga_HLine(centerX-x,centerX+x,centerY-y,color);
                      end
                 else begin
                      svga_Pixel(centerx+x,centery+y,color);
                      svga_Pixel(centerx-x,centery+y,color);
                      svga_Pixel(centerx+x,centery-y,color);
                      svga_Pixel(centerx-x,centery-y,color);
                      end;
               if d>0 then begin dec(y); dec(dy,tas); dec(d,dy); end;
               inc(x); inc(dx,tbs); d:=d+bs+dx;
               end;
d:=d+((3*(as-bs) div 2-(dx+dy)) div 2);
while y>0 do begin
             if style=1
               then begin
                    svga_HLine(centerX-x,centerX+x,centerY+y,color);
                    svga_HLine(centerX-x,centerX+x,centerY-y,color);
                    end
               else begin
                    svga_Pixel(centerx+x,centery+y,color);
                    svga_Pixel(centerx-x,centery+y,color);
                    svga_Pixel(centerx+x,centery-y,color);
                    svga_Pixel(centerx-x,centery-y,color);
                    end;
             if d<0 then begin inc(x); inc(dx,tbs); inc(d,dx); end;
             dec(y); dec(dy,tas); d:=d+as-dy;
             end;
if style=1 then svga_HLine(centerX-x,centerX+x,centerY,color)
           else begin
                svga_Pixel(centerx+x,centery,color);
                svga_Pixel(centerx-x,centery,color);
                end;
End;{svga_ellipse}
