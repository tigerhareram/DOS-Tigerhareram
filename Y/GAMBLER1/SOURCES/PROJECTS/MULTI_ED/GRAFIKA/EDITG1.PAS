Procedure Screen1Setup;
Begin
  ClearPage(Buffer[1]);
  Ramecek(0,0,79,199,253,Buffer[1]);
  Ramecek(240,0,319,199,253,Buffer[1]);
  Ramecek(81,161,238,199,253,Buffer[1]);
  OutText(3,3,'F5=Editor',Buffer[1]);
  OutText(3,16,'F7=4Barvy',Buffer[1]);
  OutText(3,29,'F8=Paleta',Buffer[1]);
  OutText(3,42,'Esc=Exit',Buffer[1]);

  OutText(3,60,'Sipky',Buffer[1]);
  OutText(3,73,'I J K L',Buffer[1]);
  OutText(3,86,'A S D F',Buffer[1]);
  OutText(3,99,'F2=SAVE',Buffer[1]);

  OutText(243,3,'LUPA',Buffer[1]);
  OutText(264,102,'A',Buffer[1]);
  OutText(274,102,'S',Buffer[1]);
  OutText(284,102,'D',Buffer[1]);
  OutText(294,102,'F',Buffer[1]);
End;


Procedure GrafikaG1Screen;
Begin
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure WriteLupaScreen;
Var x,y: Byte;
Begin
  Blok(80,0,239,159,254,Buffer[1]);
  For y:=0 to 39 do
  For x:=0 to 39 do
  Blok(80+1+x*4,1+y*4,80+1+x*4+1,1+y*4+1,ReadPixel(Xe1*8+x,Ye1*8+y,Buffer[3]),Buffer[1]);
  Ramecek(80+Xe*4,Ye*4,80+Xe*4+3,Ye*4+3,253,Buffer[1]);
End;


Procedure WriteNahled;
Var Offset2,Offset3,Offset32,Xa,Ya,x,y,X1,Y1: Word;
Begin
  For Ya:=Ye1 to Ye1+4 do
  For Xa:=Xe1 to Xe1+4 do
  Begin
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
  Blok(242,15,317,76,254,Buffer[1]);
  OutNumber(242,15,Xe1*8,True,Buffer[1]);
  OutNumber(242,21,Ye1*8,True,Buffer[1]);
  OutNumber(304,15,Xe1*8+39,True,Buffer[1]);
  OutNumber(304,21,Ye1*8,True,Buffer[1]);
  OutNumber(242,65,Xe1*8,True,Buffer[1]);
  OutNumber(242,71,Ye1*8+39,True,Buffer[1]);
  OutNumber(304,65,Xe1*8+39,True,Buffer[1]);
  OutNumber(304,71,Ye1*8+39,True,Buffer[1]);
  Ramecek(258,23,301,66,253,Buffer[1]);
  WriteBlok(260,25,Xe1*8,Ye1*8,Xe1*8+39,Ye1*8+39,Buffer[3],Buffer[1]);
End;


Procedure WriteBarvy;
Var X1,Y1,I: Byte;
    Offset: Word;
Begin
  For I:=0 to 3 do
  Begin
    Ramecek(260+1+I*10,90,260+1+I*10+8,100,253,Buffer[1]);
    X1:=Trunc((Xe1*8+Xe)/8);
    Y1:=Trunc((Ye1*8+Ye)/8);
    Offset:=(Y1*20+X1)*4;
    Blok(260+1+I*10+2,92,260+1+I*10+6,98,CisloStranky*16+mem[BufferSeg2:Offset+I],Buffer[1]);
  End;
  Ramecek(260,115,302,157,253,Buffer[1]);
  Blok(262,117,300,155,CisloStranky*16+mem[BufferSeg2:Offset+MouseColor],Buffer[1]);
End;


Procedure StartEditG1;
Var Ending: Boolean;
Begin
  Ending:=False;
  If Xs1<15 then Xe1:=Xs1 else Xe1:=15;
  If Ys1<20 then Ye1:=Ys1 else Ye1:=20;
  Screen1Setup;
  WriteNahled;
  WriteLupaScreen;
  WriteBarvy;
  Repeat
    GrafikaG1Screen;

{   If GetButton2=1 then
    Begin
      If MouseColor<3 then Inc(MouseColor)
                      else MouseColor:=0;
      WriteBarvy;
      GrafikaG1Screen;
      While GetButton2=1 do Begin End;
    End;

    If GetButton1=1 then
    Begin
      mem[Bity:(Ye1*8+Ye)*160+(Xe1*8+Xe)]:=MouseColor;
      WriteNahled;
      WriteLupaScreen;
    End;

    If GetButton3=1 then
    Begin
      mem[Bity:(Ye1*8+Ye)*160+(Xe1*8+Xe)]:=0;
      WriteNahled;
      WriteLupaScreen;
    End;

    {kurzor mysi}
{   Xe:=((GetMouseX-160) div 2) div 4;
    Ye:=GetMouseY div 4;
    MouseX:=(Xe*4)*2+160;
    MouseY:=Ye*4;
    WriteLupaScreen;
    WriteBarvy; }

{F5}  If Key[63]=True then
      Begin
        Ending:=True;
        TABGrafikaG0:=True;
      End;
{F7}  If Key[65]=True then
      Begin
        Ending:=True;
        TABGrafikaG2:=True;
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
          If Ye1>0 then Dec(Ye1)
                   else Ye1:=0;
          WriteNahled;
          WriteLupaScreen;
          WriteBarvy;
        End;
{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do WaitButton(80);
          If Ye1<20 then Inc(Ye1)
                    else Ye1:=20;
          WriteNahled;
          WriteLupaScreen;
          WriteBarvy;
        End;
{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          If Xe1>0 then Dec(Xe1)
                   else Xe1:=0;
          WriteNahled;
          WriteLupaScreen;
          WriteBarvy;
        End;
{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          If Xe1<15 then Inc(Xe1)
                    else Xe1:=15;
          WriteNahled;
          WriteLupaScreen;
          WriteBarvy;
        End;

{I} If Key[23]=True then
    Begin
      While Key[23]=True do WaitButton(23);
      If Ye>0 then Begin Dec(Ye); Dec(MouseY,4); End
              else Begin Ye:=39; MouseY:=160; End;
      SetMouseXY(MouseX,MouseY);
      WriteLupaScreen;
      WriteBarvy;
    End;
{K} If Key[37]=True then
    Begin
      While Key[37]=True do WaitButton(37);
      If Ye<39 then Begin Inc(Ye); Inc(MouseY,4); End
               else Begin Ye:=0; MouseY:=0; End;
      SetMouseXY(MouseX,MouseY);
      WriteLupaScreen;
      WriteBarvy;
    End;
{J} If Key[36]=True then
    Begin
      While Key[36]=True do WaitButton(36);
      If Xe>0 then Begin Dec(Xe); Dec(MouseX,8); End
              else Begin Xe:=39; MouseX:=480; End;
      SetMouseXY(MouseX,MouseY);
      WriteLupaScreen;
      WriteBarvy;
    End;
{L} If Key[38]=True then
    Begin
      While Key[38]=True do WaitButton(38);
      If Xe<39 then Begin Inc(Xe); Inc(MouseX,8); End
               else Begin Xe:=0; MouseX:=160; End;
      SetMouseXY(MouseX,MouseY);
      WriteLupaScreen;
      WriteBarvy;
    End;

{A} If Key[30]=True then
    Begin
      mem[Bity:(Ye1*8+Ye)*160+(Xe1*8+Xe)]:=0;
      WriteNahled;
      WriteLupaScreen;
    End;
{S} If Key[31]=True then
    Begin
      mem[Bity:(Ye1*8+Ye)*160+(Xe1*8+Xe)]:=1;
      WriteNahled;
      WriteLupaScreen;
    End;
{D} If Key[32]=True then
    Begin
      mem[Bity:(Ye1*8+Ye)*160+(Xe1*8+Xe)]:=2;
      WriteNahled;
      WriteLupaScreen;
    End;
{F} If Key[33]=True then
    Begin
      mem[Bity:(Ye1*8+Ye)*160+(Xe1*8+Xe)]:=3;
      WriteNahled;
      WriteLupaScreen;
    End;

  Until Ending=True;
End;