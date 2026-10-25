Program RawMod;

Var
  F1,F2: File;
  Lenght1,Lenght2: LongInt;
  position: LongInt;
  TransferByte: Byte;

Const
  HeaderLenght = 54;

Begin
  If ParamStr(1)<>'' then
  Begin
    Assign(F1,ParamStr(1));
    Reset(F1,1);
    Seek(F1,HeaderLenght);
    Lenght1:=FileSize(F1);
    Lenght2:=Lenght1-HeaderLenght;

    Assign(F2,'output.raw');
    ReWrite(F2,1);
    BlockWrite(F2,Lenght2,4);

    position:=HeaderLenght;
    Repeat
      BlockRead(F1,TransferByte,1);
      BlockWrite(F2,TransferByte,1);
      Inc(position);
    Until position=Lenght1;

    Close(F1);
    Close(F2);
  End else Write('imput error, zadejte jako parametr jmeno souboru');
End.