Procedure WriteSoustruh;
Var x,y,vyska,Posun,Offset: Word;
Begin
  ClearPage(Buffer[1]);
  If memW[ZvukTabSeg:ZvukSelect*4+2]>0 then
  Begin
    Offset:=memW[ZvukTabSeg:ZvukSelect*4]; {Zacatek}
    x:=18;
    y:=199;
    For Posun:=0 to memW[ZvukTabSeg:ZvukSelect*4+2]-1 do {0 .. delka}
    Begin
      For vyska:=0 to Trunc((memW[SoundDataSeg:Offset*2+Posun*2])/10) do
      Begin
        WritePixel(x,y,248,Buffer[1]);
        Dec(y);
      End;
      Inc(x);
      y:=199;
    End;
    {kurzor}
    x:=18+ZvukPosunX;
    y:=199;
    For vyska:=0 to Trunc((memW[SoundDataSeg:Offset*2+ZvukPosunX*2])/10) do
    Begin
      WritePixel(x,y,246,Buffer[1]);
      Dec(y);
    End;
  End;
  Blok(0,0,17,17,254,Buffer[1]);
  OutNumber(0,0,ZvukPosunX,False,Buffer[1]);
  OutNumber(0,9,memW[SoundDataSeg:Offset*2+ZvukPosunX*2],False,Buffer[1]);
End;


Procedure EditZEScreen;
Begin
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure EditZE; {EDITOR}
Var Ending: Boolean;
Begin
  Ending:=False;
  ZvukPosunX:=0;
  WriteSoustruh;
  Repeat
    EditZEScreen;
{P}   If Key[25]=True then
      Begin
        While Key[25]=True do Begin End;
        PrehrajZvuk(ZvukSelect);
      End;
{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        SaveSNDFile(FileName);
        SoundDone;
      End;
{F5}  If Key[63]=True then
      Begin
        While Key[63]=True do Begin End;
        Ending:=True;
        TABZvukyT:=True;
      End;
{Esc} If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        Ending:=True;
        TABZvukyT:=True;
      End;

{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          If ZvukPosunX>0 then Dec(ZvukPosunX);
          WriteSoustruh;
        End;
{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          If ZvukPosunX<memW[ZvukTabSeg:ZvukSelect*4+2]-1 then Inc(ZvukPosunX);
          WriteSoustruh;
        End;

{Insert} If ((Key[82]=True) or (Key[22]=True)) then
{U}      Begin
           While Key[82]=True do WaitButton(82);
           While Key[22]=True do WaitButton(22);
           If memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2]<1999
           then Inc(memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2]);
           WriteSoustruh;
         End;
{Delete} If ((Key[83]=True) or (Key[36]=True)) then
{J}      Begin
           While Key[83]=True do WaitButton(83);
           While Key[36]=True do WaitButton(36);
           If memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2]>0
           then Dec(memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2]);
           WriteSoustruh;
         End;
{Home}   If ((Key[71]=True) or (Key[23]=True)) then
{I}      Begin
           While Key[71]=True do WaitButton(71);
           While Key[23]=True do WaitButton(23);
           If memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2]<1989
           then Inc(memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2],10);
           WriteSoustruh;
         End;
{End}    If ((Key[79]=True) or (Key[37]=True)) then
{K}      Begin
           While Key[79]=True do WaitButton(79);
           While Key[37]=True do WaitButton(37);
           If memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2]>=10
           then Dec(memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2],10);
           WriteSoustruh;
         End;
{PgUp}   If ((Key[73]=True) or (Key[24]=True)) then
{O}      Begin
           While Key[73]=True do WaitButton(73);
           While Key[24]=True do WaitButton(24);
           If memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2]<1899
           then Inc(memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2],100);
           WriteSoustruh;
         End;
{PgDown} If ((Key[81]=True) or (Key[38]=True)) then
{L}      Begin
           While Key[81]=True do WaitButton(81);
           While Key[38]=True do WaitButton(38);
           If memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2]>=100
           then Dec(memW[SoundDataSeg:(memW[ZvukTabSeg:ZvukSelect*4])*2+ZvukPosunX*2],100);
           WriteSoustruh;
         End;
  Until Ending=True;
End;