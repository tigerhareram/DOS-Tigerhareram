Procedure LoadSNDFile(FileName:String;Pozice:Longint);
Var
  F: File;
  I,A: Word;

  {RLE}
  WritedA: Byte;     {znak A}
  WritedB: Byte;     {je-li komprese tak stejny jako znak A}
  WritedC: Byte;     {pocet kolikrat tam je znak A }
  posun: Word;

  Function GetHDDByte: Byte;
  Var ReadByte: Byte;
  Begin
    BlockRead(F,ReadByte,1);
    GetHDDByte:=ReadByte;
  End;

Begin
  Assign(F,FileName);
  Reset(F,1);
  Seek(F,Pozice);

  {Read file from HDD}
  BlockRead(F,RLEDelka,2);

  I:=0; posun:=0;
  While not (posun=RLEDelka) do
  Begin

    WritedA:=GetHDDByte;                   {nacteme A}
    Inc(posun);
    If posun=RLEDelka then                 {je-li konec zapsat a BREAK}
    Begin
      mem[RLE:I]:=WritedA;
      Break;
    End;

    WritedB:=GetHDDByte;                 {nacteme B}
    Inc(posun);

    If posun=RLEDelka then               {je-li konec zapsat a BREAK}
    Begin
      mem[RLE:I]:=WritedA;
      mem[RLE:I+1]:=WritedB;
      Break;
    End;

    If WritedA=WritedB then     {jsou-li dva stejne tzn. nasleduje pocet}
    Begin
      WritedC:=GetHDDByte;      {muzeme nacist pocet}
      Inc(posun);
      For A:=1 to WritedC do
      Begin
        mem[RLE:I]:=WritedA; {zapisujeme WritedBC krat}
        Inc(I);
      End;
    End else {jsou dva ruzne}
    Begin
      mem[RLE:I]:=WritedA;   {zapisme jeden a navrat nahoru}
      Inc(I);
      Dec(posun);         {posuneme index o jednu nazpet}
      Seek(F,FilePos(F)-1);
    End;

  End; {While End}

  {BufferRLE to BufferSND and Lengts}

  A:=0;
  For I:=0 to 9999 do Begin
                        mem[BufferSND:I]:=mem[RLE:A];
                        Inc(A);
                      End;

  For I:=0 to 49 do Begin
                      SND_Lenght[I]:=mem[RLE:A];
                      Inc(A);
                    End;

  Close(F);
End;
