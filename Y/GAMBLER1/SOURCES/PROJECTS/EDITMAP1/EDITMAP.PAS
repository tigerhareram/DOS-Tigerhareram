Procedure WriteLista;
Begin
  Blok(0,192,319,199,254,Buffer[3]);
  OutText(0,192,'X=',Buffer[3]);
  OutNumber(12,193,Xm1+Xm,False,Buffer[3]);
  OutText(40,192,'Y=',Buffer[3]);
  OutNumber(52,193,Ym1+Ym,False,Buffer[3]);
  If ViewZ=True then OutText(80,192,'ViewZ ZAPNUTO',Buffer[3])
                else OutText(80,192,'ViewZ VYPNUTO',Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure WritePolicko(X,Y,Cislo: Byte);
Var Xa,Ya: Word;
    RamecekZ: Boolean;
Begin
  If Cislo>=128 then Begin
                       Dec(Cislo,128);
                       RamecekZ:=True;
                     End
                else RamecekZ:=False;
  Xa:=Cislo mod 10;
  Ya:=Cislo div 10;
  WriteBlok(X,Y,Xa*16,Ya*16,Xa*16+15,Ya*16+15,Buffer[1],Buffer[3]);
  If ((RamecekZ=True) and (ViewZ=True)) then
  Begin
    Ramecek(X+1,Y+1,X+14,Y+14,252,Buffer[3]);
    OutNumber(X+3,Y+3,1,True,Buffer[3]);
  End;
End;


Procedure WriteMap;
Var N,X,Y: Byte;
    Offset: Word;
Begin
  Blok(0,0,159,191,254,Buffer[3]);

  For Y:=0 to 11 do
  For X:=0 to 9 do
  Begin
    Offset:=(Ym1+Y)*RozmerX+(Xm1+X);
    N:=GetMapByte(Offset);
    WritePolicko(X*16,Y*16,N);
  End;

  Ramecek(Xm*16,Ym*16,Xm*16+15,Ym*16+15,252,Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure WriteGraphics;
Begin
  WriteBlok(160,0,0,0,159,199,Buffer[1],Buffer[3]);
  Ramecek(160+Xg*16,Yg*16,160+Xg*16+15,Yg*16+15,252,Buffer[3]);
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure WriteEditScreen;
Begin
  ClearPage(Buffer[3]);
  WriteGraphics;
  WriteMap;
  WriteLista;
  WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure EditMap;
Var Ending: Boolean;
    N: Byte;
Begin
  Ending:=False;
  Xg:=0;
  Yg:=0;
  Xm:=0;
  Ym:=0;
  Xm0:=0;
  Ym0:=0;
  Xm1:=0;
  Ym1:=0;
  ViewZ:=True;
  WriteEditScreen;
  Repeat
{I}     If Key[23]=True then
        Begin
          While Key[23]=True do WaitButton(23);
          If Ym>0 then Dec(Ym)
                  else Begin
                         If Ym0>0 then Dec(Ym0);
                         If Ym1>0 then Dec(Ym1);
                       End;
          WriteMap;
          WriteLista;
        End;
{K}     If Key[37]=True then
        Begin
          While Key[37]=True do WaitButton(37);
          If Ym<11 then Inc(Ym)
                   else Begin
                          If Ym0<RozmerY-1 then Inc(Ym0);
                          If Ym1<RozmerY-12 then Inc(Ym1);
                        End;
          WriteMap;
          WriteLista;
        End;
{J}     If Key[36]=True then
        Begin
          While Key[36]=True do WaitButton(36);
          If Xm>0 then Dec(Xm)
                  else Begin
                         If Xm0>0 then Dec(Xm0);
                         If Xm1>0 then Dec(Xm1);
                       End;
          WriteMap;
          WriteLista;
        End;
{L}     If Key[38]=True then
        Begin
          While Key[38]=True do WaitButton(38);
          If Xm<9 then Inc(Xm)
                  else Begin
                         If Xm0<RozmerX-1 then Inc(Xm0);
                         If Xm1<RozmerX-10 then Inc(Xm1);
                       End;
          WriteMap;
          WriteLista;
        End;

{Enter} If Key[28]=True then
        Begin
          While Key[28]=True do Begin End;
          SetMapByte((Ym1+Ym)*RozmerX+(Xm1+Xm),Yg*10+Xg);
          WriteMap;
        End;

{PgUp}  If Key[73]=True then
        Begin
          While Key[73]=True do Begin End;
          N:=GetMapByte((Ym1+Ym)*RozmerX+(Xm1+Xm));
          If N<128 then
          Begin
            Inc(N,128);
            SetMapByte((Ym1+Ym)*RozmerX+(Xm1+Xm),N);
          End;
          WriteMap;
        End;

{PgDn}  If Key[81]=True then
        Begin
          While Key[81]=True do Begin End;
          N:=GetMapByte((Ym1+Ym)*RozmerX+(Xm1+Xm));
          If N>=128 then
          Begin
            Dec(N,128);
            SetMapByte((Ym1+Ym)*RozmerX+(Xm1+Xm),N);
          End;
          WriteMap;
        End;

{Up}    If Key[72]=True then
        Begin
          While Key[72]=True do WaitButton(72);
          If Yg>0 then Dec(Yg) else Yg:=11;
          WriteGraphics;
        End;
{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do WaitButton(80);
          If Yg<11 then Inc(Yg) else Yg:=0;
          WriteGraphics;
        End;
{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          If Xg>0 then Dec(Xg) else Xg:=9;
          WriteGraphics;
        End;
{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          If Xg<9 then Inc(Xg) else Xg:=0;
          WriteGraphics;
        End;

{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        SaveMapFile(MapName);
        SoundDone;
      End;

{F5}  If Key[63]=True then
      Begin
        While Key[63]=True do Begin End;
        If ViewZ=True then Begin ViewZ:=False; SoundDone; End
                      else Begin ViewZ:=True; SoundDone; End;
        WriteMap;
        WriteLista;
      End;

{Esc} If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        Ending:=True;
      End;

{F10} If Key[68]=True then
      Begin
        While Key[68]=True do Begin End;
        Ending:=True;
      End;

  Until Ending=True;
End;