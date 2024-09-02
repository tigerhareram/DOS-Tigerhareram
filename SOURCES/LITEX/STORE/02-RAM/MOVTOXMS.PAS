Procedure RAM_MoveToXMS(Handle: Word; XMSOffset: LongInt; Var Source; BlockLength: LongInt);
Var
  ParamBlock: XMSParamBlock;
  XSeg,PSeg,POfs: Word;
Begin
  If Handle<>0 then
  Begin
    XMSchyba:=0;
    With ParamBlock Do
      Begin
        Length:=BlockLength;
        SHandle:=0;
        SOffset:=LongInt(addr(Source));
        DHandle:=Handle;
        DOffset:=XMSOffset;
      End;
    PSeg:=Seg(ParamBlock);
    POfs:=Ofs(ParamBlock);
    XSeg:=Seg(XMSAdr);
    Asm
      Push DS
      Mov  AH,0Bh
      Mov  SI,POfs
      Mov  BX,XSeg
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
