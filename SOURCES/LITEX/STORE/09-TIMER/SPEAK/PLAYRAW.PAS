Procedure Spkr_PlayRaw(Cislo:Byte;Opakovat:Boolean);
Var I: Word;
Begin
  For I:=0 to 8191 do memL[BufferSPR:I*4]:=0;
  If Raw[Cislo].Lenght<=32767 then RAW_lenght:=Raw[Cislo].Lenght
                              else RAW_lenght:=32767;
  RAM_MoveFromXMS(Raw[Cislo].Handle,0,mem[BufferSPR:0],RAW_lenght);
  RAW_pos:=0;
  RAW_repeat:=Opakovat;
  RAW_play:=True;
End;