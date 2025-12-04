Procedure Bmp2Gra;
Var X,Y,I: Word;
Begin
  For I:=0 to 15 do
  Begin
    Barva[I].R:=0;
    Barva[I].G:=0;
    Barva[I].B:=0;
    SetPal(CisloStranky*16+I,Barva[I].R,Barva[I].G,Barva[I].B);
  End;
  GetPal(ImportBarva1,Barva[1].R,Barva[1].G,Barva[1].B);
  SetPal(CisloStranky*16+1,Barva[1].R,Barva[1].G,Barva[1].B);
  GetPal(ImportBarva2,Barva[2].R,Barva[2].G,Barva[2].B);
  SetPal(CisloStranky*16+2,Barva[2].R,Barva[2].G,Barva[2].B);
  GetPal(ImportBarva3,Barva[3].R,Barva[3].G,Barva[3].B);
  SetPal(CisloStranky*16+3,Barva[3].R,Barva[3].G,Barva[3].B);

  For Y:=0 to 24 do
  For X:=0 to 19 do
  Begin
    mem[BufferSeg2:(Y*20+X)*4+0]:=0;
    mem[BufferSeg2:(Y*20+X)*4+1]:=1;
    mem[BufferSeg2:(Y*20+X)*4+2]:=2;
    mem[BufferSeg2:(Y*20+X)*4+3]:=3;
  End;

  For Y:=0 to 199 do
  For X:=0 to 159 do
  Begin
    mem[Bity:Y*160+X]:=0;
    If ReadPixel(X,Y,Buffer[2])=ImportBarva1 then mem[Bity:Y*160+X]:=1;
    If ReadPixel(X,Y,Buffer[2])=ImportBarva2 then mem[Bity:Y*160+X]:=2;
    If ReadPixel(X,Y,Buffer[2])=ImportBarva3 then mem[Bity:Y*160+X]:=3;
  End;
End;