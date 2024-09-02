Procedure SaveGRAFile(Filename:String);
Var
  F: File;
  I,A: Word;
  BinBajt: Byte;
  WriteBajt: Byte;
  Ii,Ni,Xi,Yi: Word;
  X,Y: Byte; {SprPal}

  {RLE}
  WritedA: Byte;   {znak A}
  WritedB: Byte;   {je-li komprese tak stejny jako znak A}
  WritedC: Byte;   {pocet kolikrat tam je znak A}
  Stejne: Boolean;
  delka,longsize: Word;

Begin
  Assign(F,FileName);
  ReWrite(F,1);

  {Clear RLE packing area}
  For I:=0 to 15999 do mem[RLE:I]:=0;

  {SprPal}
  For Ii:=0 to 15 do
  Begin
    SprPal[Ii].c:=Ii;
  { SprPal[Ii].R , fill by editor }
  { SprPal[Ii].G , fill by editor }
  { SprPal[Ii].B , fill by editor }
  End;

  {SprCol}
  For Y:=0 to 24 do
  Begin
    For X:=0 to 19 do
    Begin
      SprCol[Y*20+X].C[0]:=SprCol[Y*20+X].C[0];
      SprCol[Y*20+X].C[1]:=SprCol[Y*20+X].C[1];
      SprCol[Y*20+X].C[2]:=SprCol[Y*20+X].C[2];
      SprCol[Y*20+X].C[3]:=SprCol[Y*20+X].C[3];
    End;
  End;

  {Write Buffer[0] pixels to SprDat}
  Ii:=0; Ni:=0;
  For Yi:=0 to 199 do
  Begin
    For Xi:=0 to 159 do
    Begin
      BinBajt:=mem[Buffer[0]:Yi*160+Xi];
      Case Ii Of
         0: Begin
              WriteBajt:=BinBajt;
            End;
         1: Begin
              BinBajt:=BinBajt shl 2;
              WriteBajt:=WriteBajt or BinBajt;
            End;
         2: Begin
              BinBajt:=BinBajt shl 4;
              WriteBajt:=WriteBajt or BinBajt;
            End;
         3: Begin
              BinBajt:=BinBajt shl 6;
              WriteBajt:=WriteBajt or BinBajt;
            End;
      End; {Case End}
      If Ii<3  then Inc(Ii)
        {Ii=3} else Begin
                      Ii:=0;
                      SprDat[Ni]:=WriteBajt;
                      Inc(Ni);
                    End;
    End;
  End;

  {To one Buffer}
  A:=0;
  For I:=0 to 7999 do Begin
                        mem[RLE:A]:=SprDat[I]; Inc(A);
                      End;
  For I:=0 to 499 do Begin
                       mem[RLE:A]:=SprCol[I].C[0]; Inc(A);
                       mem[RLE:A]:=SprCol[I].C[1]; Inc(A);
                       mem[RLE:A]:=SprCol[I].C[2]; Inc(A);
                       mem[RLE:A]:=SprCol[I].C[3]; Inc(A);
                     End;
  For I:=0 to 15 do Begin
                      memW[RLE:A]:=SprPal[I].c; Inc(A,2);
                      memW[RLE:A]:=SprPal[I].R; Inc(A,2);
                      memW[RLE:A]:=SprPal[I].G; Inc(A,2);
                      memW[RLE:A]:=SprPal[I].B; Inc(A,2);
                    End;

  {RLE Kompress}
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

  {Write File to HDD}
  BlockWrite(F,RLEDelka,2);
  For I:=0 to RLEDelka do BlockWrite(F,mem[RLEKompressed:I],1);

  Close(F);
End;
