Procedure Screen2Setup;
Var X,Y,I: Byte;
Begin
  ClearPage(Buffer[1]);
  Ramecek(0,0,79,199,253,Buffer[1]);
  Ramecek(240,0,319,199,253,Buffer[1]);
  OutText(3,3,'F5=Editor',Buffer[1]);
  OutText(3,16,'F6=Lupa',Buffer[1]);
  OutText(3,29,'F8=Paleta',Buffer[1]);
  OutText(3,42,'Esc=Exit',Buffer[1]);
  OutText(243,3,'4BARVY',Buffer[1]);

  OutText(3,60,'Sipky',Buffer[1]);
  OutText(3,73,'I J K L',Buffer[1]);
  OutText(3,86,'A S D F',Buffer[1]);
  OutText(3,99,'C=kopirovat',Buffer[1]);
  OutText(3,112,'V=vlozit',Buffer[1]);
  OutText(3,125,'F2=SAVE',Buffer[1]);

  I:=0;
  For Y:=0 to 3 do
  For X:=0 to 3 do
  Begin
    Blok(245+X*18,20+Y*18,245+X*18+13,20+Y*18+13,CisloStranky*16+I,Buffer[1]);
    Inc(I);
  End;

End;


Procedure Write4BarvyScreen;
Var X,Y: Byte;
    I: Word;
Begin
  Blok(80,0,239,199,254,Buffer[1]);
  I:=0;
  For Y:=0 to 24 do
  For X:=0 to 19 do
  Begin
    Blok(80+X*8+2,Y*8+2,80+X*8+1+2,Y*8+1+2,CisloStranky*16+mem[BufferSeg2:(Y*20+X)*4],Buffer[1]);
    Blok(80+X*8+2+2,Y*8+2,80+X*8+2+1+2,Y*8+1+2,CisloStranky*16+mem[BufferSeg2:(Y*20+X)*4+1],Buffer[1]);
    Blok(80+X*8+2,Y*8+2+2,80+X*8+1+2,Y*8+2+1+2,CisloStranky*16+mem[BufferSeg2:(Y*20+X)*4+2],Buffer[1]);
    Blok(80+X*8+2+2,Y*8+2+2,80+X*8+2+1+2,Y*8+2+1+2,CisloStranky*16+mem[BufferSeg2:(Y*20+X)*4+3],Buffer[1]);
  End;
End;


Procedure GrafikaG2Screen;
Var X,Y: Byte;
Begin
  Ramecek(80+X4B*8,Y4B*8,80+X4B*8+7,Y4B*8+7,253,Buffer[1]);
  For Y:=0 to 3 do
  For X:=0 to 3 do
  Ramecek(243+X*18,18+Y*18,243+X*18+17,18+Y*18+17,254,Buffer[1]);
  Ramecek(243+X4B1*18,18+Y4B1*18,243+X4B1*18+17,18+Y4B1*18+17,253,Buffer[1]);
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure StartEditG2;
Var Ending: Boolean;
    I: Byte;
Begin
  Ending:=False;
  VybranaBarva2:=0;
  Screen2Setup;
  Write4BarvyScreen;
  Repeat
    GrafikaG2Screen;
{F5}  If Key[63]=True then
      Begin
        Ending:=True;
        TABGrafikaG0:=True;
      End;
{F6}  If Key[64]=True then
      Begin
        Ending:=True;
        TABGrafikaG1:=True;
      End;
{F8}  If Key[66]=True then
      Begin
        Ending:=True;
        TABGrafikaG3:=True;
      End;
{Esc} If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        EndingEditG:=True;
        Ending:=True;
      End;
{F2}  If Key[60]=True then
      Begin
        While Key[60]=True do Begin End;
        SaveGrPage(FileName);
        SoundDone;
      End;

{Up}    If Key[72]=True then
        Begin
          While Key[72]=True do WaitButton(72);
          If Y4B1>0 then Dec(Y4B1)
                    else Y4B1:=3;
          VybranaBarva2:=Y4B1*4+X4B1;
        End;
{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do WaitButton(80);
          If Y4B1<3 then Inc(Y4B1)
                    else Y4B1:=0;
          VybranaBarva2:=Y4B1*4+X4B1;
        End;
{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          If X4B1>0 then Dec(X4B1)
                    else X4B1:=3;
          VybranaBarva2:=Y4B1*4+X4B1;
        End;
{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          If X4B1<3 then Inc(X4B1)
                    else X4B1:=0;
          VybranaBarva2:=Y4B1*4+X4B1;
        End;

{I} If Key[23]=True then
    Begin
      While Key[23]=True do WaitButton(23);
      If Y4B>0 then Dec(Y4B)
               else Y4B:=24;
      Write4BarvyScreen;
    End;
{K} If Key[37]=True then
    Begin
      While Key[37]=True do WaitButton(37);
      If Y4B<24 then Inc(Y4B)
                else Y4B:=0;
      Write4BarvyScreen;
    End;
{J} If Key[36]=True then
    Begin
      While Key[36]=True do WaitButton(36);
      If X4B>0 then Dec(X4B)
               else X4B:=19;
      Write4BarvyScreen;
    End;
{L} If Key[38]=True then
    Begin
      While Key[38]=True do WaitButton(38);
      If X4B<19 then Inc(X4B)
                else X4B:=0;
      Write4BarvyScreen;
    End;

{A} If Key[30]=True then
    Begin
      While Key[30]=True do Begin End;
      mem[BufferSeg2:(Y4B*20+X4B)*4]:=VybranaBarva2;
      Write4BarvyScreen;
    End;
{S} If Key[31]=True then
    Begin
      While Key[31]=True do Begin End;
      mem[BufferSeg2:(Y4B*20+X4B)*4+1]:=VybranaBarva2;
      Write4BarvyScreen;
    End;
{D} If Key[32]=True then
    Begin
      While Key[32]=True do Begin End;
      mem[BufferSeg2:(Y4B*20+X4B)*4+2]:=VybranaBarva2;
      Write4BarvyScreen;
    End;
{F} If Key[33]=True then
    Begin
      While Key[33]=True do Begin End;
      mem[BufferSeg2:(Y4B*20+X4B)*4+3]:=VybranaBarva2;
      Write4BarvyScreen;
    End;
{C} If Key[46]=True then
    Begin
      While Key[46]=True do Begin End;
      I:=0;
      For I:=0 to 3 do Schranka4Barvy[I]:=mem[BufferSeg2:(Y4B*20+X4B)*4+I];
      SoundDone;
    End;
{V} If Key[47]=True then
    Begin
      While Key[47]=True do Begin End;
      I:=0;
      For I:=0 to 3 do mem[BufferSeg2:(Y4B*20+X4B)*4+I]:=Schranka4Barvy[I];
      Write4BarvyScreen;
      SoundDone;
    End;

  Until Ending=True;
End;