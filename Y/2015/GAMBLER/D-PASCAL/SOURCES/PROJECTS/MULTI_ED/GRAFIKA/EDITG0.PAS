Procedure WritePasek;
Var X: Word;
Begin
  WaitRetrace;
  X:=Trunc(Progress/5);
  Ramecek(110,90,212,109,253,Buffer[4]);
  Blok(111,91,211,108,252,Buffer[4]);
  Blok(111,91,111+X,108,250,Buffer[4]);
  OutNumber(150,98,X,False,Buffer[4]);
  If (X<10) then OutText(158,97,'%',Buffer[4]);
  If ((X>9) and (X<=99)) then OutText(164,97,'%',Buffer[4]);
  If X>99 then OutText(171,97,'%',Buffer[4]);
End;


Procedure Screen0Setup;
Begin
  ClearPage(Buffer[1]);
  Ramecek(0,0,79,199,253,Buffer[1]);
  Ramecek(240,0,319,199,253,Buffer[1]);
  OutText(3,3,'F6=Lupa',Buffer[1]);
  OutText(3,16,'F7=4Barvy',Buffer[1]);
  OutText(3,29,'F8=Paleta',Buffer[1]);
  OutText(3,42,'Esc=Exit',Buffer[1]);
  OutText(243,3,'EDITOR',Buffer[1]);
  OutText(3,60,'Sipky',Buffer[1]);
  OutText(3,73,'C=kopirovat',Buffer[1]);
  OutText(3,86,'V=vlozit',Buffer[1]);
  OutText(3,99,'F2=SAVE',Buffer[1]);
  OutText(243,16,'Stranka=',Buffer[1]);
End;

Procedure GrafikaG0Screen;
Begin
  Ramecek(80+Xs1*8,Ys1*8,80+Xs1*8+7,Ys1*8+7,253,Buffer[1]);
  Blok(291,17,301,23,254,Buffer[1]);
  OutNumber(291,17,CisloStranky,False,Buffer[1]);
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure WriteGrafika;
Var Offset2,Offset3,Offset32,Xa,Ya,x,y,X1,Y1: Word;
Begin
  Progress:=1;
  For Ya:=0 to 24 do
  For Xa:=0 to 19 do
  Begin
    If Progress<=500 then
    Begin
      WritePasek;
      If Progress=500 then Wait(400);
      Inc(Progress);
    End;
    For y:=0 to 7 do
    For x:=0 to 7 do
    Begin
      X1:=Trunc((Xa*8+x)/8);
      Y1:=Trunc((Ya*8+y)/8);
      Offset2:=(Y1*20+X1)*4;
      Offset3:=((Ya*8+y)*320)+(Xa*8+x);
      Offset32:=((Ya*8+y)*160)+(Xa*8+x);
      Case mem[Bity:Offset32] of
        0: Begin
             If mem[BufferSeg2:Offset2+0]>0
             then mem[Buffer[3]:Offset3]:=mem[BufferSeg2:Offset2+0]+(CisloStranky*16)
             else mem[Buffer[3]:Offset3]:=0;
           End;
        1: Begin
             If mem[BufferSeg2:Offset2+1]>0
             then mem[Buffer[3]:Offset3]:=mem[BufferSeg2:Offset2+1]+(CisloStranky*16)
             else mem[Buffer[3]:Offset3]:=0;
           End;
        2: Begin
             If mem[BufferSeg2:Offset2+2]>0
             then mem[Buffer[3]:Offset3]:=mem[BufferSeg2:Offset2+2]+(CisloStranky*16)
             else mem[Buffer[3]:Offset3]:=0;
           End;
        3: Begin
             If mem[BufferSeg2:Offset2+3]>0
             then mem[Buffer[3]:Offset3]:=mem[BufferSeg2:Offset2+3]+(CisloStranky*16)
             else mem[Buffer[3]:Offset3]:=0;
           End;
      End; {Case End}
    End;
  End;
  WriteBlok(80,0,0,0,159,199,Buffer[3],Buffer[1]);
End;


Procedure StartEditG0;
Var Ending: Boolean;
    I,Xsch,Ysch: Byte;
Begin
  Ending:=False;
  Screen0Setup;
  WriteGrafika;
  Repeat
    GrafikaG0Screen;
{F6}  If Key[64]=True then
      Begin
        Ending:=True;
        TABGrafikaG1:=True;
      End;
{F7}  If Key[65]=True then
      Begin
        Ending:=True;
        TABGrafikaG2:=Tru e;
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
          If Ys1>0 then Dec(Ys1)
                   else Ys1:=24;
          WriteBlok(80,0,0,0,159,199,Buffer[3],Buffer[1]);
        End;
{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do WaitButton(80);
          If Ys1<24 then Inc(Ys1)
                    else Ys1:=0;
          WriteBlok(80,0,0,0,159,199,Buffer[3],Buffer[1]);
        End;
{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          If Xs1>0 then Dec(Xs1)
                   else Xs1:=19;
          WriteBlok(80,0,0,0,159,199,Buffer[3],Buffer[1]);
        End;
{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          If Xs1<19 then Inc(Xs1)
                    else Xs1:=0;
          WriteBlok(80,0,0,0,159,199,Buffer[3],Buffer[1]);
        End;
{C} If Key[46]=True then
    Begin
      While Key[46]=True do Begin End;
      I:=0;
      For Ysch:=0 to 7 do
      For Xsch:=0 to 7 do
      Begin
        Schranka[I]:=mem[Bity:(Ys1*8+Ysch)*160+(Xs1*8+Xsch)];
        Inc(I);
      End;
      For I:=0 to 3 do Schranka4Barvy[I]:=mem[BufferSeg2:(Ys1*20+Xs1)*4+I];
      SoundDone;
    End;
{V} If Key[47]=True then
    Begin
      While Key[47]=True do Begin End;
      I:=0;
      For Ysch:=0 to 7 do
      For Xsch:=0 to 7 do
      Begin
        mem[Bity:(Ys1*8+Ysch)*160+(Xs1*8+Xsch)]:=Schranka[I];
        Inc(I);
      End;
      For I:=0 to 3 do mem[BufferSeg2:(Ys1*20+Xs1)*4+I]:=Schranka4Barvy[I];
      WriteGrafika;
      SoundDone;
    End;
{PgUp}   If Key[73]=True then
         Begin
           While Key[73]=True do WaitButton(73);
           If CisloStranky<15 then Inc(CisloStranky)
                              else CisloStranky:=15;
           For I:=0 to 15 do SetPal(CisloStranky*16+I,Barva[I].R,Barva[I].G,Barva[I].B);
           WriteGrafika;
         End;
{PgDown} If Key[81]=True then
         Begin
           While Key[81]=True do WaitButton(81);
           If CisloStranky>0 then Dec(CisloStranky)
                             else CisloStranky:=0;
           For I:=0 to 15 do SetPal(CisloStranky*16+I,Barva[I].R,Barva[I].G,Barva[I].B);
           WriteGrafika;
         End;

  Until Ending=True;
End;