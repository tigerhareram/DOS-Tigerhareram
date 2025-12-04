Procedure WritePalette;
Var A,I: Byte;
Begin
  Blok(129,22,190,152,254,Buffer[1]);
  Ramecek(129,22,190,152,253,Buffer[1]);
  A:=0;
  For I:=0 to Barva[VybranaBarva].R do
  Begin
    Blok(131,150-A,148,150-A,250,Buffer[1]);
    Inc(A,2);
  End;
  A:=0;
  For I:=0 to Barva[VybranaBarva].G do
  Begin
    Blok(151,150-A,168,150-A,251,Buffer[1]);
    Inc(A,2);
  End;
  A:=0;
  For I:=0 to Barva[VybranaBarva].B do
  Begin
    Blok(171,150-A,188,150-A,252,Buffer[1]);
    Inc(A,2);
  End;
End;


Procedure Screen3Setup;
Begin
  ClearPage(Buffer[1]);
  Ramecek(0,0,79,179,253,Buffer[1]);
  Ramecek(240,0,319,179,253,Buffer[1]);
  OutText(3,3,'F5=Editor',Buffer[1]);
  OutText(3,16,'F6=Lupa',Buffer[1]);
  OutText(3,29,'F7=4Barvy',Buffer[1]);
  OutText(3,42,'Esc=Exit',Buffer[1]);

  OutText(3,60,'doprava',Buffer[1]);
  OutText(3,73,'doleva',Buffer[1]);
  OutText(3,86,'U,insert',Buffer[1]);
  OutText(3,99,'J,delete',Buffer[1]);
  OutText(3,112,'I,home',Buffer[1]);
  OutText(3,125,'K,end',Buffer[1]);
  OutText(3,138,'O,pageup',Buffer[1]);
  OutText(3,151,'L,pagedown',Buffer[1]);
  OutText(3,164,'F2=SAVE',Buffer[1]);

  OutText(243,3,'PALETA',Buffer[1]);

  WritePalette;
End;


Procedure GrafikaG3Screen;
Var I,A: Byte;
Begin
  {barvy}
  For I:=0 to 15 do
  Begin
    Ramecek(2+I*20,183,2+I*20+15,199,253,Buffer[1]);
    Ramecek(3+I*20,184,3+I*20+13,198,254,Buffer[1]);
    Ramecek(4+I*20,185,4+I*20+11,197,254,Buffer[1]);
    Ramecek(5+I*20,186,5+I*20+9,196,254,Buffer[1]);
    Blok(7+I*20,188,7+I*20+5,194,CisloStranky*16+I,Buffer[1]);
  End;

  {kurzor}
  Ramecek(2+VybranaBarva*20,183,2+VybranaBarva*20+15,199,254,Buffer[1]);
  Ramecek(3+VybranaBarva*20,184,3+VybranaBarva*20+13,198,253,Buffer[1]);
  Ramecek(4+VybranaBarva*20,185,4+VybranaBarva*20+11,197,254,Buffer[1]);
  Ramecek(5+VybranaBarva*20,186,5+VybranaBarva*20+9,196,253,Buffer[1]);

  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure StartEditG3;
Var Ending: Boolean;
Begin
  Ending:=False;
  VybranaBarva:=0;
  Screen3Setup;
  Repeat
    GrafikaG3Screen;
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
{F7}  If Key[65]=True then
      Begin
        Ending:=True;
        TABGrafikaG2:=True;
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

{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          If VybranaBarva>0 then Dec(VybranaBarva)
                            else VybranaBarva:=15;
          WritePalette;
        End;
{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          If VybranaBarva<15 then Inc(VybranaBarva)
                             else VybranaBarva:=0;
          WritePalette;
        End;
{Insert} If ((Key[82]=True) or (Key[22]=True)) then
{U}      Begin
           While Key[82]=True do WaitButton(82);
           While Key[22]=True do WaitButton(22);
           If Barva[VybranaBarva].R<63 then
           Begin
             Inc(Barva[VybranaBarva].R);
             SetPal(CisloStranky*16+VybranaBarva,Barva[VybranaBarva].R,
                                                 Barva[VybranaBarva].G,
                                                 Barva[VybranaBarva].B);
           End;
           WritePalette;
         End;
{Delete} If ((Key[83]=True) or (Key[36]=True)) then
{J}      Begin
           While Key[83]=True do WaitButton(83);
           While Key[36]=True do WaitButton(36);
           If Barva[VybranaBarva].R>0 then
           Begin
             Dec(Barva[VybranaBarva].R);
             SetPal(CisloStranky*16+VybranaBarva,Barva[VybranaBarva].R,
                                                 Barva[VybranaBarva].G,
                                                 Barva[VybranaBarva].B);
           End;
           WritePalette;
         End;
{Home}   If ((Key[71]=True) or (Key[23]=True)) then
{I}      Begin
           While Key[71]=True do WaitButton(71);
           While Key[23]=True do WaitButton(23);
           If Barva[VybranaBarva].G<63 then
           Begin
             Inc(Barva[VybranaBarva].G);
             SetPal(CisloStranky*16+VybranaBarva,Barva[VybranaBarva].R,
                                                 Barva[VybranaBarva].G,
                                                 Barva[VybranaBarva].B);
           End;
           WritePalette;
         End;
{End}    If ((Key[79]=True) or (Key[37]=True)) then
{K}      Begin
           While Key[79]=True do WaitButton(79);
           While Key[37]=True do WaitButton(37);
           If Barva[VybranaBarva].G>0 then
           Begin
             Dec(Barva[VybranaBarva].G);
             SetPal(CisloStranky*16+VybranaBarva,Barva[VybranaBarva].R,
                                                 Barva[VybranaBarva].G,
                                                 Barva[VybranaBarva].B);
           End;
           WritePalette;
         End;
{PgUp}   If ((Key[73]=True) or (Key[24]=True)) then
{O}      Begin
           While Key[73]=True do WaitButton(73);
           While Key[24]=True do WaitButton(24);
           If Barva[VybranaBarva].B<63 then
           Begin
             Inc(Barva[VybranaBarva].B);
             SetPal(CisloStranky*16+VybranaBarva,Barva[VybranaBarva].R,
                                                 Barva[VybranaBarva].G,
                                                 Barva[VybranaBarva].B);
           End;
           WritePalette;
         End;
{PgDown} If ((Key[81]=True) or (Key[38]=True)) then
{L}      Begin
           While Key[81]=True do WaitButton(81);
           While Key[38]=True do WaitButton(38);
           If Barva[VybranaBarva].B>0 then
           Begin
             Dec(Barva[VybranaBarva].B);
             SetPal(CisloStranky*16+VybranaBarva,Barva[VybranaBarva].R,
                                                 Barva[VybranaBarva].G,
                                                 Barva[VybranaBarva].B);
           End;
           WritePalette;
         End;
  Until Ending=True;
End;