Procedure RAM_Done;
Var I: Byte;
Begin
  For I:=0 to 9 do RAM_FreeXMS(RAW[I].Handle);
  RAM_FreeXMS(RAWBig.Handle);
  For I:=0 to 3 do FreeMem(BufferP[I],64000);
  FreeMem(BufferCP,1435);
  FreeMem(BufferC1P,350);
  FreeMem(BufferC2P,280);
  FreeMem(BufferC3P,1056);
  FreeMem(BufferMapP,8000);
  FreeMem(BufferRAWP,8192);
  FreeMem(BufferSNDP,10000);
  FreeMem(BufferSPRP,10000);
  FreeMem(RLEP,16000);
  FreeMem(RLEKompressedP,16000);
End;
