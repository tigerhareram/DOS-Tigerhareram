procedure SVGA_Line(x1,y1,x2,y2:word; barva:byte);
{obecna cara z bodu x1,y1 do x2,y2}
var dx,dy,krokx,kroky:integer;
    pom:word;
Begin
{Pokud vychazi cara vodorovna nebo svisla, pouzijeme z duvodu rychlosti radsi
procedury pro vodorovnou nebo svislou caru, i kdyz Bresenhamuv algoritmus by
fungoval i v techto pripadech (krok druhe souradnice by byl 0):}
if x1=x2 then begin
              if y2>y1 then svga_vline(x1,y1,y2,barva)
                       else svga_vline(x1,y2,y1,barva);
              exit;
              end;
if y1=y2 then begin
              if x2>x1 then svga_hline(x1,x2,y1,barva)
                       else svga_hline(x2,x1,y1,barva);
              exit;
              end;
{A ted ten Bresenham. Vypocet rozdilu souradnic a kroku:}
if x2>x1 then begin dx:=x2-x1; krokx:=1; end
         else begin dx:=x1-x2; krokx:=-1; end;
if y2>y1 then begin dy:=y2-y1; kroky:=1; end
         else begin dy:=y1-y2; kroky:=-1; end;
{Zadny rozdil souradnic urcite neni 0, protoze to by odchytily predchozi dve
podminky a procedura by uz touhle dobou davno skoncila. Takze se ted o takovy
pripad nemusime starat.}
svga_pixel(x1,y1,barva); {prvni bod cary}
if dx>=dy then begin {cara je spis vodorovnejsi, x je ridici promenna}
               pom:=dx shr 1; {pocatecni hodnota pomocne promenne}
                repeat
                inc(x1,krokx); {zmenime x o 1}
                inc(pom,dy); {pricteme k pomocne dy (mensi rozdil)}
                if pom>=dx then begin {kdyz je vesti nez dx (ten vetsi rozdil)...}
                                dec(pom,dx); {...vetsi rozdil odecteme...}
                                inc(y1,kroky); {...a zmenime y o 1}
                                end;
                svga_pixel(x1,y1,barva); {nakreslime bod}
                until x1=x2; {dokud nejsme na koncovem bodu}
               end
          else begin {cara je spis svislejsi, ridici je y}
               pom:=dy shr 1;
                repeat         {postup stejny, jen jsou prehozene souradnice}
                inc(y1,kroky);
                inc(pom,dx);
                if pom>=dy then begin
                                dec(pom,dy);
                                inc(x1,krokx);
                                end;
                svga_pixel(x1,y1,barva);
                until y1=y2;
               end;
End;{svga_line}
