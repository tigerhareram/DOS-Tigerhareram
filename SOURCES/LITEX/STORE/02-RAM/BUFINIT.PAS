Procedure RAM_Init;
Var I,N: Word;
Begin
  {RAW data}
  If DetectXMS=0 then GetSizeXMS(XMSsize);
  For I:=0 to 9 do RAW[I].Handle:=RAM_GetXMS(256);
  {Big One}
  RAWBig.Handle:=RAM_GetXMS(1000);

  {0=LoadArea 1=GFXdata 2=MapSource 3=FrameBuffer}
  For I:=0 to 3 do
  Begin
    GetMem(BufferP[I],64000);
    Buffer[I]:=Seg(BufferP[I]^);
    For N:=0 to 63999 do mem[Buffer[I]:N]:=0;
  End;

  {Video Segment}
  Buffer[4]:=$A000;

  {Texter}
  GetMem(BufferCP,1435);
  BufferC:=Seg(BufferCP^);
  For N:=0 to 1434 do mem[BufferC:N]:=0;

  GetMem(BufferC1P,350);
  BufferC1:=Seg(BufferC1P^);
  For N:=0 to 349 do mem[BufferC1:N]:=0;

  GetMem(BufferC2P,280);
  BufferC2:=Seg(BufferC2P^);
  For N:=0 to 279 do mem[BufferC2:N]:=0;

  GetMem(BufferC3P,1056);
  BufferC3:=Seg(BufferC3P^);
  For N:=0 to 1055 do mem[BufferC3:N]:=0;

  {Mapa}
  GetMem(BufferMapP,8000);
  BufferMap:=Seg(BufferMapP^);
  For N:=0 to 7999 do mem[BufferMap:N]:=0;

  {Domix}
  GetMem(BufferRAWP,8192);
  BufferRAW:=Seg(BufferRAWP^);
  For N:=0 to 8191 do mem[BufferRAW:N]:=0;

  {PC Speaker}
  GetMem(BufferSNDP,10000);
  BufferSND:=Seg(BufferSNDP^);
  For N:=0 to 9999 do mem[BufferSND:N]:=0;

  {PC Speaker RAW}
  GetMem(BufferSPRP,10000);
  BufferSPR:=Seg(BufferSPRP^);
  For N:=0 to 9999 do mem[BufferSPR:N]:=0;

  {Kompression}
  GetMem(RLEP,16000);
  RLE:=Seg(RLEP^);
  For N:=0 to 15999 do mem[RLE:N]:=0;

  GetMem(RLEKompressedP,16000);
  RLEKompressed:=Seg(RLEKompressedP^);
  For N:=0 to 15999 do mem[RLEKompressed:N]:=0;
End;
