Procedure VGA_Spr(x,y,X1,Y1,Transp,BufferFrom,BufferTo:Word);
Var Xa,Ya: Word;
Begin
  If Transp=0 then Begin
                     For Ya:=0 to 7 do
                     For Xa:=0 to 1 do
                     memL[BufferTo:((y+Ya)*320+(x+Xa*4))]:=memL[BufferFrom:((Y1+Ya)*320+(X1+Xa*4))];
                   End
   {Transp=1} else Begin
                     For Ya:=0 to 7 do
                     For Xa:=0 to 7 do
                     If mem[BufferFrom:((Y1+Ya)*320+(X1+Xa))]>0 then
                     mem[BufferTo:((y+Ya)*320+(x+Xa))]:=mem[BufferFrom:((Y1+Ya)*320+(X1+Xa))];
                   End;
End;
