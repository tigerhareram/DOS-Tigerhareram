Procedure LoadRAWFile(filename:String;Pozice:LongInt;N:Byte); {do 64KB}
Var F: File;
    ReadByte: Byte;
    L,I: LongInt;
    Offset: LongInt;

Begin
  Assign(F,filename);
  Reset(F,1);
  Seek(F,Pozice);
  RAW[N].Lenght:=FileSize(F)-60;

  Seek(F,54);

  If Odd(RAW[N].Lenght) then RAW[N].Lenght:=RAW[N].Lenght-1
                        else RAW[N].Lenght:=RAW[N].Lenght;

  RAW[N].Load_Chunks:=RAW[N].Lenght div 8192;
  RAW[N].Load_Zbytek:=RAW[N].Lenght - RAW[N].Load_Chunks*8192;
  RAW[N].Load_Chunk:=0;
  Inc(RAW[N].Load_Chunks); {+zbytek}

    {mame jen kratky zvuk do 1chunku mensi nez 8KB}
    If RAW[N].Load_Chunks=1 then
    Begin
      For I:=0 to RAW[N].Lenght-1 do
      Begin
        BlockRead(F,ReadByte,1);
        mem[Buffer[0]:I]:=ReadByte;
      End;
      RAM_MoveToXMS(RAW[N].Handle,0,mem[Buffer[0]:0],RAW[N].Lenght);
    End;

    {mame zvuk s nejmene jednim chunkem 8kb a mensim zbytkem}
    If RAW[N].Load_Chunks>1 then
    For L:=0 to RAW[N].Load_Chunks-1 do
    Begin

      {chunks ktere jsou celych 8KB}
      If L<RAW[N].Load_Chunks-1 then
      Begin
        For I:=0 to 8191 do
        Begin
          BlockRead(F,ReadByte,1);
          mem[Buffer[0]:I]:=ReadByte;
        End;
        Offset:=L*8192;
        RAM_MoveToXMS(RAW[N].Handle,Offset,mem[Buffer[0]:0],8192);
      End

       else {posledni zbytek zvuku mensi nez 8KB}

      Begin
        For I:=0 to RAW[N].Load_Zbytek-1 do
        Begin
          BlockRead(F,ReadByte,1);
          mem[Buffer[0]:I]:=ReadByte;
        End;
        Offset:=L*8192;
        RAM_MoveToXMS(RAW[N].Handle,Offset,mem[Buffer[0]:0],RAW[N].Load_Zbytek);
      End;

    End;

  Close(F);
End;