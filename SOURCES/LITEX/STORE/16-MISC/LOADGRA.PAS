Procedure LoadGRAFile(Filename:String;Pozice:LongInt;PageNumber:Byte);
Var
  F: File;
  I,A: Word;
  BinBajt,Pixel: Byte;
  Ii,Ni,Xi,Yi: Word; {binary byte}
  X,Y,x1,y1: Word;   {buffer[0] data}

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

  {Buffer to 3 Buff.}
  A:=0;
  For I:=0 to 7999 do Begin
                        SprDat[I]:=mem[RLE:A]; Inc(A);
                      End;
  For I:=0 to 499 do Begin
                       SprCol[I].C[0]:=mem[RLE:A]; Inc(A);
                       SprCol[I].C[1]:=mem[RLE:A]; Inc(A);
                       SprCol[I].C[2]:=mem[RLE:A]; Inc(A);
                       SprCol[I].C[3]:=mem[RLE:A]; Inc(A);
                     End;
  For I:=0 to 15 do Begin
                      SprPal[I].c:=memW[RLE:A]; Inc(A,2);
                      SprPal[I].R:=memW[RLE:A]; Inc(A,2);
                      SprPal[I].G:=memW[RLE:A]; Inc(A,2);
                      SprPal[I].B:=memW[RLE:A]; Inc(A,2);
                    End;

  {Write SprDat to Buffer[0] pixels}
  Ii:=0; Ni:=0;
  For Yi:=0 to 199 do
  Begin
    For Xi:=0 to 159 do
    Begin
      BinBajt:=SprDat[Ni];
      Case Ii Of
        0: Begin
             BinBajt:=BinBajt and 3;
           End;
        1: Begin
             BinBajt:=BinBajt and 12;
             BinBajt:=BinBajt shr 2;
           End;
        2: Begin
             BinBajt:=BinBajt and 48;
             BinBajt:=BinBajt shr 4;
           End;
        3: Begin
             BinBajt:=BinBajt and 192;
             BinBajt:=BinBajt shr 6;
           End;
      End; {Case End}
      mem[Buffer[0]:Yi*160+Xi]:=BinBajt;
      If Ii<3 then Inc(Ii) else Begin Ii:=0; Inc(Ni); End;
    End;
  End;

  {Load AREA}
  For Y:=0 to 199 do
  Begin
    For X:=0 to 159 do
    Begin
      x1:= X div 8;
      y1:= Y div 8;
      Pixel:=mem[Buffer[0]:Y*160+X];
      Case Pixel Of
        0: mem[Buffer[3]:Y*320+X]:=SprCol[y1*20+x1].C[0]+(PageNumber*16);
        1: mem[Buffer[3]:Y*320+X]:=SprCol[y1*20+x1].C[1]+(PageNumber*16);
        2: mem[Buffer[3]:Y*320+X]:=SprCol[y1*20+x1].C[2]+(PageNumber*16);
        3: mem[Buffer[3]:Y*320+X]:=SprCol[y1*20+x1].C[3]+(PageNumber*16);
      End; {Case End}
    End;
  End;

  {SprPal}
  For Ii:=0 to 15 do
  Begin
    SprPal[Ii].c:=Ii+(PageNumber*16);
    P16_SetPal(SprPal[Ii].c,SprPal[Ii].R,SprPal[Ii].G,SprPal[Ii].B);
  End;

  Close(F);
End;
