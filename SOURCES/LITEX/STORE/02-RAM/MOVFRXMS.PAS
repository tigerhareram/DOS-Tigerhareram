Procedure RAM_MoveFromXMS(Handle: Word; XMSOffset: LongInt; Var Dest; BlockLength: LongInt);
Var
  ParamBlock: XMSParamBlock;
  XSeg,PSeg,POfs: Word;
Begin
  If Handle<>0 then
  Begin
    XMSChyba:=0;
    With ParamBlock Do
      Begin
        Length:=BlockLength;
        SHandle:=Handle;
        SOffset:=XMSOffset;
        DHandle:=0;
        DOffset:=LongInt(addr(Dest));
      End;
    PSeg:=Seg(ParamBlock);
    POfs:=Ofs(ParamBlock);
    XSeg:=Seg(XMSAdr);
    Asm
      Push DS
      Mov  AH,0Bh
      Mov  SI,POfs
      Mov  BX,XSeg;
      Mov  ES,BX
      Mov  BX,PSeg
      Mov  DS,BX
      Call [ES:XMSAdr]
      Or   AX,AX
      Jne  @@1
      Mov  XMSChyba,BL
  @@1:
      Pop  DS
    End;
  End;
End;
