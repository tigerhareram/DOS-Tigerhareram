Procedure SaveSNDFile(FileName:String);
Var
  F: File;
  I,A: Word;

  {RLE}
  WritedA: Byte;   {znak A}
  WritedB: Byte;   {je-li komprese tak stejny jako znak A}
  WritedC: Byte;   {pocet kolikrat tam je znak A}
  Stejne: Boolean;
  delka,longsize: Word;

Begin
  Assign(F,FileName);
  ReWrite(F,1);

  { Clear RLE packing area }
  For I:=0 to 15999 do mem[RLE:I]:=0;

  { BufferSND fill by editor }
  A:=0;
  For I:=0 to 9999 do Begin
                        mem[RLE:A]:=mem[BufferSND:I];
                        Inc(A);
                      End;

  { 50 Sounds Leghts }
  For I:=0 to 49 do Begin
                      mem[RLE:A]:=SND_Lenght[I];
                      Inc(A);
                    End;

  { RLE Kompress }
  longsize:=A; A:=0; I:=0;
  Repeat
    Stejne:=False;

    If I=longsize-1 then
    Begin
      mem[RLEKompressed:A]:=mem[RLE:I];
      Inc(A);
      Break;
    End;

    While (mem[RLE:I]<>mem[RLE:I+1]) and (I<longsize-1) do
    Begin
      mem[RLEKompressed:A]:=mem[RLE:I]; {zapis stav 1 kazdy bajt jiny}
      Inc(I);                          {inkrementujeme index pole I}
      Inc(A);                          {inkrementujeme index zabaleneho pole}
    End;

    delka:=1; {zjistujeme kolik bajtu nasleduje za sebou stejnych}
    While (mem[RLE:I]=mem[RLE:I+delka]) and (delka<255) and (I+delka<longsize-1) do
    Begin
      Inc(delka);
      Stejne:=True;
    End;

    If Stejne=True then
    Begin
      WritedA:=mem[RLE:I];
      WritedB:=mem[RLE:I];
      WritedC:=delka;
      mem[RLEKompressed:A]:=WritedA;
      mem[RLEKompressed:A+1]:=WritedB;
      mem[RLEKompressed:A+2]:=WritedC;
      Inc(I,delka);
      Inc(A,3);
    End;

  Until I=longsize;
  RLEdelka:=A;

  { Write File to HDD }
  BlockWrite(F,RLEDelka,2);
  For I:=0 to RLEDelka do BlockWrite(F,mem[RLEKompressed:I],1);

  Close(F);
End;
