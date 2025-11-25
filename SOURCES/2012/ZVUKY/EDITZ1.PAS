Procedure WriteRadek(Y,Cislo,Backgr:Byte;Index:Word;Kurzor,Kurzor1,Kurzor2:Boolean);
Begin
  If Kurzor=True then Blok(160,Y*9,319,Y*9+8,247,Buffer[1])
                 else Blok(160,Y*9,319,Y*9+8,Backgr,Buffer[1]);
  If Kurzor1=True then Blok(180,Y*9,204,Y*9+8,246,Buffer[1]);
  If Kurzor2=True then Blok(225,Y*9,244,Y*9+8,246,Buffer[1]);
  OutNumber(160,Y*9+1,Cislo,False,Buffer[1]);
  OutNumber(180,Y*9+1,memW[ZvukTabSeg:Index*2],False,Buffer[1]);
  OutNumber(225,Y*9+1,memW[ZvukTabSeg:Index*2+2],False,Buffer[1]);
  OutNumber(263,Y*9+1,memW[ZvukTabSeg:Index*2],False,Buffer[1]);
  OutText(288,Y*9+1,'-',Buffer[1]);
  OutNumber(295,Y*9+1,memW[ZvukTabSeg:Index*2]+memW[ZvukTabSeg:Index*2+2],False,Buffer[1]);
End;

Procedure WriteTabulka;
Var I,blinker,color: Byte;
    A: Word;
Begin
  Blok(160,0,319,199,254,Buffer[1]);
  OutText(160,0,'-',Buffer[1]);
  OutText(180,0,'ZACATEK',Buffer[1]);
  OutText(225,0,'DELKA',Buffer[1]);
  OutText(263,0,'ROZSAH',Buffer[1]);
  blinker:=0;
  color:=249;
  A:=ZvukIndex;
  For I:=0 to 18 do
  Begin
    WriteRadek(I+1,I+ZvukY,color,A,False,False,False);
    If blinker=0 then Begin blinker:=1; color:=248; End
                 else Begin blinker:=0; color:=249; End;
    Inc(A,2);
  End;
  If TABZacatky=True then WriteRadek(ZvukSelect1+1,ZvukSelect,248,ZvukSelect*2,True,True,False);
  If TABDelky=True then WriteRadek(ZvukSelect1+1,ZvukSelect,248,ZvukSelect*2,True,False,True);
End;


Procedure SetupTabScreen;
Begin
  ClearPage(Buffer[1]);
  Ramecek(0,0,159,199,253,Buffer[1]);
  OutText(3,3,'F6,Enter=Editor',Buffer[1]);
  OutText(3,16,'F5=Tabulka',Buffer[1]);
  OutText(3,29,'Esc=Exit',Buffer[1]);
  OutText(3,42,'P=Play',Buffer[1]);
  OutText(3,59,'doleva',Buffer[1]);
  OutText(3,72,'doprava',Buffer[1]);
  OutText(3,85,'nahoru',Buffer[1]);
  OutText(3,98,'dolu',Buffer[1]);
  OutText(3,111,'U,insert=+1',Buffer[1]);
  OutText(3,124,'J,delete=-1',Buffer[1]);
  OutText(3,137,'I,home=+10',Buffer[1]);
  OutText(3,150,'K,end=-10',Buffer[1]);
  OutText(3,163,'O,pageup=+100',Buffer[1]);
  OutText(3,176,'L,pagedown=-100',Buffer[1]);
  OutText(3,189,'F2=SAVE',Buffer[1]);
End;


Procedure EditTabulkaScreen;
Begin
  WaitRetrace;
  FlipPage(Buffer[1],Buffer[4]);
End;


Procedure EditZT; {TABULKA}
Var Ending: Boolean;
Begin
  Ending:=False;
  SetupTabScreen;
  WriteTabulka;
  Repeat
    EditTabulkaScreen;

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
{F6}  If Key[64]=True then
      Begin
        Ending:=True;
        TABZvukyE:=True;
      End;
{Esc} If Key[1]=True then
      Begin
        While Key[1]=True do Begin End;
        Ending:=True;
        EndingEditZ:=True;
      End;

{Enter} If Key[28]=True then
        Begin
          Ending:=True;
          TABZvukyE:=True;
        End;

{Up}    If Key[72]=True then
        Begin
          While Key[72]=True do WaitButton(72);
          If ZvukSelect>0 then Dec(ZvukSelect);
          If ZvukSelect1>0 then Dec(ZvukSelect1);
          If ((ZvukSelect<ZvukY) and (ZvukY>0)) then
          Begin
            Dec(ZvukY);
            Dec(ZvukIndex,2);
          End;
          WriteTabulka;
        End;
{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do WaitButton(80);
          If ZvukSelect<49 then Inc(ZvukSelect);
          If ZvukSelect1<18 then Inc(ZvukSelect1);
          If ((ZvukSelect>ZvukY+18) and (ZvukY<31)) then
          Begin
            Inc(ZvukY);
            Inc(ZvukIndex,2);
          End;
          WriteTabulka;
        End;
{Left}  If Key[75]=True then
        Begin
          While Key[75]=True do WaitButton(75);
          If TABZacatky=False then
          Begin
            TABZacatky:=True;
            TABDelky:=False;
            WriteTabulka;
          End;
        End;
{Right} If Key[77]=True then
        Begin
          While Key[77]=True do WaitButton(77);
          If TABDelky=False then
          Begin
            TABDelky:=True;
            TABZacatky:=False;
            WriteTabulka;
          End;
        End;

{Insert} If ((Key[82]=True) or (Key[22]=True)) then
{U}      Begin
           While Key[82]=True do WaitButton(82);
           While Key[22]=True do WaitButton(22);
           If TABZacatky=True then
           Begin
             If memW[ZvukTabSeg:ZvukSelect*4]+memW[ZvukTabSeg:ZvukSelect*4+2]<1999 then
             If memW[ZvukTabSeg:ZvukSelect*4]<1999 then Inc(memW[ZvukTabSeg:ZvukSelect*4]);
           End;
           If TABDelky=True then
           Begin
             If memW[ZvukTabSeg:ZvukSelect*4]+memW[ZvukTabSeg:ZvukSelect*4+2]<1999 then
             If memW[ZvukTabSeg:ZvukSelect*4+2]<299 then Inc(memW[ZvukTabSeg:ZvukSelect*4+2]);
           End;
           WriteTabulka;
         End;
{Delete} If ((Key[83]=True) or (Key[36]=True)) then
{J}      Begin
           While Key[83]=True do WaitButton(83);
           While Key[36]=True do WaitButton(36);
           If TABZacatky=True then
           If memW[ZvukTabSeg:ZvukSelect*4]>0 then Dec(memW[ZvukTabSeg:ZvukSelect*4]);
           If TABDelky=True then
           If memW[ZvuktabSeg:ZvukSelect*4+2]>0 then Dec(memW[ZvukTabSeg:ZvukSelect*4+2]);
           WriteTabulka;
         End;
{Home}   If ((Key[71]=True) or (Key[23]=True)) then
{I}      Begin
           While Key[71]=True do WaitButton(71);
           While Key[23]=True do WaitButton(23);
           If TABZacatky=True then
           Begin
             If memW[ZvukTabSeg:ZvukSelect*4]+memW[ZvukTabSeg:ZvukSelect*4+2]<1989 then
             If memW[ZvukTabSeg:ZvukSelect*4]<1989 then Inc(memW[ZvukTabSeg:ZvukSelect*4],10);
           End;
           If TABDelky=True then
           Begin
             If memW[ZvukTabSeg:ZvukSelect*4]+memW[ZvukTabSeg:ZvukSelect*4+2]<1989 then
             If memW[ZvukTabSeg:ZvukSelect*4+2]<289 then Inc(memW[ZvukTabSeg:ZvukSelect*4+2],10);
           End;
           WriteTabulka;
         End;
{End}    If ((Key[79]=True) or (Key[37]=True)) then
{K}      Begin
           While Key[79]=True do WaitButton(79);
           While Key[37]=True do WaitButton(37);
           If TABZacatky=True then
           If memW[ZvukTabSeg:ZvukSelect*4]>=10 then Dec(memW[ZvukTabSeg:ZvukSelect*4],10);
           If TABDelky=True then
           If memW[ZvuktabSeg:ZvukSelect*4+2]>=10 then Dec(memW[ZvukTabSeg:ZvukSelect*4+2],10);
           WriteTabulka;
         End;
{PgUp}   If ((Key[73]=True) or (Key[24]=True)) then
{O}      Begin
           While Key[73]=True do WaitButton(73);
           While Key[24]=True do WaitButton(24);
           If TABZacatky=True then
           Begin
             If memW[ZvukTabSeg:ZvukSelect*4]+memW[ZvukTabSeg:ZvukSelect*4+2]<1899 then
             If memW[ZvukTabSeg:ZvukSelect*4]<1899 then Inc(memW[ZvukTabSeg:ZvukSelect*4],100);
           End;
           If TABDelky=True then
           Begin
             If memW[ZvukTabSeg:ZvukSelect*4]+memW[ZvukTabSeg:ZvukSelect*4+2]<1899 then
             If memW[ZvukTabSeg:ZvukSelect*4+2]<199 then Inc(memW[ZvukTabSeg:ZvukSelect*4+2],100);
           End;
           WriteTabulka;
         End;
{PgDown} If ((Key[81]=True) or (Key[38]=True)) then
{L}      Begin
           While Key[81]=True do WaitButton(81);
           While Key[38]=True do WaitButton(38);
           If TABZacatky=True then
           If memW[ZvukTabSeg:ZvukSelect*4]>=100 then Dec(memW[ZvukTabSeg:ZvukSelect*4],100);
           If TABDelky=True then
           If memW[ZvuktabSeg:ZvukSelect*4+2]>=100 then Dec(memW[ZvukTabSeg:ZvukSelect*4+2],100);
           WriteTabulka;
         End;
  Until Ending=True;
End;