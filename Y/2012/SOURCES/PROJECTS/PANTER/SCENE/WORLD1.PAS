Procedure WritePolicko(X,Y: Word; Cislo: Byte; x1,y1,x2,y2: ShortInt);
Var Xa,Ya: Word;
Begin
  If ((Cislo=0) and (Mapa.WorldMapOnScreen=True)) then
  Begin
    Case Water.WaterBlink of
      0: Begin Ya:=0; Xa:=0; End;
      1: Begin Ya:=0; Xa:=1; End;
      2: Begin Ya:=1; Xa:=0; End;
      3: Begin Ya:=1; Xa:=1; End;
    End; {Case End}
    If (x2<>16) and (y2<>16) then
    WriteBlok(X,Y,Xa*16+x1,Ya*16+y1,Xa*16+15-x2,Ya*16+15-y2,Buffer[2],Buffer[3]);
  End else
  Begin
    Ya:=Cislo div 10;
    Xa:=Cislo mod 10;
    If (x2<>16) and (y2<>16) then
    WriteBlok(X,Y,Xa*16+x1,Ya*16+y1,Xa*16+15-x2,Ya*16+15-y2,Buffer[2],Buffer[3]);
  End;
End;


Procedure WriteWorldScreenSegment(Xa,Ya,Xview,YView: Word; Xs1,Ys1,Xs2,Ys2: Byte;
            Okraj1,Okraj2,Okraj3,Okraj4: Boolean; Roh1,Roh2,Roh3,Roh4: Byte; switch1,switch2: Boolean);

Var I,Offset: Word;

  Procedure GetFish_I;
  Begin
    If GetMapByte(Offset)>=128
    then I:=GetMapByte(Offset)-128
    else I:=GetMapByte(Offset);
  End;

  Procedure WritePlocha(Xp1,Yp1,Xp2,Yp2: Byte; Varianta: Char);
  Var X,Y: Byte;
  Begin
    {plocha bez okraju}
    Case Varianta of
    'A':
    Begin
      For Y:=Yp1 to Yp2 do
      For X:=Xp1 to Xp2 do
      Begin
        Offset:=(((Yview div 16)+Y+1)*320)+((Xview div 16)+X+1); GetFish_I;
        WritePolicko(Xa+16-(Xview mod 16)+(X-Xp1)*16,Ya+(16-(Yview mod 16)+(Y-Yp1)*16)+8,I,
       0,0,0,0);
      End;
    End;
    'B':
    Begin
      For Y:=Yp1 to Yp2 do
      For X:=Xp1 to Xp2 do
      Begin
        Offset:=(((Yview div 16)+Y)*320)+((Xview div 16)+X+1); GetFish_I;
        WritePolicko(Xa+16-(Xview mod 16)+(X-Xp1)*16,Ya-16+(16-(Yview mod 16)+(Y-Yp1)*16)+8,I,
       0,0,0,0);
      End;
    End;
    'C':
    Begin
      For Y:=Yp1 to Yp2 do
      For X:=Xp1 to Xp2 do
      Begin
        Offset:=(((Yview div 16)+Y+1)*320)+((Xview div 16)+X); GetFish_I;
        WritePolicko(Xa+(16-(Xview mod 16)+(X-Xp1)*16)-16,Ya+(16-(Yview mod 16)+(Y-Yp1)*16)+8,I,
       0,0,0,0);
      End;
    End;
    End; {Case End}
  End;

  Procedure WriteOkraj1;
  Var X,Y: Word;
  Begin
    {okraj 1 - leva strana}
    If Okraj1=True then
    Begin
      For Y:=Ys1 to Ys2-2 do
      Begin
        Offset:=(((Yview div 16)+Y+1)*320)+(Xview div 16)+Xs1; GetFish_I;
        WritePolicko(Xa,Ya+(16-(Yview mod 16)+(Y-Ys1)*16)+8,I,
        Xview mod 16,0,0,0);
      End;
    End Else
    Begin
      For Y:=Ys1 to Ys2-2 do
      Begin
        Offset:=(((Yview div 16)+Y+1)*320)+(Xview div 16)+Xs1; GetFish_I;
        WritePolicko(Xa-(Mapa.Xview mod 16),Ya+(16-(Yview mod 16)+(Y-Ys1)*16)+8,I,
        0,0,0,0);
      End;
    End;
  End;

  Procedure WriteOkraj2;
  Var X,Y: Word;
  Begin
    {okraj 2 - prava strana}
    If Okraj2=True then
    Begin
      For Y:=Ys1 to Ys2-2 do
      Begin
        Offset:=(((Yview div 16)+Y+1)*320)+((Xview div 16)+Xs2); GetFish_I;
        WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya+(16-(Yview mod 16)+(Y-Ys1)*16)+8,I,
        0,0,16-(Xview mod 16),0);
      End;
    End Else
    Begin
      For Y:=Ys1 to Ys2-2 do
      Begin
        Offset:=(((Yview div 16)+Y+1)*320)+((Xview div 16)+Xs2); GetFish_I;
        WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya+(16-(Yview mod 16)+(Y-Ys1)*16)+8,I,
        0,0,0,0);
      End;
    End;
  End;

  Procedure WriteOkraj3;
  Var X,Y: Word;
  Begin
    {okraj 3 - horni strana}
    If Okraj3=True then
    Begin
      For X:=Xs1 to Xs2-2 do
      Begin
        Offset:=(((Yview div 16)+Ys1)*320)+((Xview div 16)+X+1); GetFish_I;
        WritePolicko(Xa+((16-(Xview mod 16))+(X-Xs1)*16),Ya+8,I,
        0,(Yview mod 16),0,0);
      End;
    End else
    Begin
      For X:=Xs1 to Xs2-2 do
      Begin
        Offset:=(((Yview div 16)+Ys1)*320)+((Xview div 16)+X+1); GetFish_I;
        WritePolicko(Xa+((16-(Xview mod 16))+(X-Xs1)*16),Ya-(Mapa.Yview mod 16)+8,I,
        0,0,0,0);
      End;
    End;
  End;

  Procedure WriteOkraj4;
  Var X,Y: Word;
  Begin
    {okraj 4 - dolni strana}
    If Okraj4=True then
    Begin
      For X:=Xs1 to Xs2-2 do
      Begin
        Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+X+1); GetFish_I;
        WritePolicko(Xa+(16-(Xview mod 16)+(X-Xs1)*16),Ya+((Ys2-Ys1-1)*16)+(16-(Yview mod 16))+8,I,
        0,0,0,16-(Yview mod 16));
      End;
    End else
    Begin
      For X:=Xs1 to Xs2-2 do
      Begin
        Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+X+1); GetFish_I;
        WritePolicko(Xa+(16-(Xview mod 16))+(X-Xs1)*16,Ya+(16-(Yview mod 16))+((Ys2-Ys1-1)*16)+8,I,
        0,0,0,0);
      End;
    End;
  End;

  Procedure WriteRoh1(Roh: Byte);
  Begin
    {roh 1 - vlevo nahore}
    Case Roh of
    1:
    Begin
      Offset:=(((Yview div 16)+Ys1)*320)+((Xview div 16)+Xs1); GetFish_I;
      WritePolicko(Xa,Ya+8,I,
      (Xview mod 16),(Yview mod 16),0,0);
    End;
    2:
    Begin
      Offset:=(((Yview div 16)+Ys1)*320)+((Xview div 16)+Xs1); GetFish_I;
      WritePolicko(Xa-(Xview mod 16),Ya+8,I,
      0,(Yview mod 16),0,0);
    End;
    3:
    Begin
      Offset:=(((Yview div 16)+Ys1)*320)+((Xview div 16)+Xs1); GetFish_I;
      WritePolicko(Xa-(Xview mod 16),Ya-(Yview mod 16)+8,I,
      0,0,0,0);
    End;
    4:
    Begin
      Offset:=(((Yview div 16)+Ys1)*320)+((Xview div 16)+Xs1); GetFish_I;
      WritePolicko(Xa,Ya-(Yview mod 16)+8,I,
      (Xview mod 16),0,0,0);
    End;
    End; {Case End}
  End;

  Procedure WriteRoh2(Roh: Byte);
  Begin
    {roh 2 - vpravo nahore}
    Case Roh of
    1:
    Begin
      Offset:=(((Yview div 16)+Ys1)*320)+(Xview div 16)+Xs2; GetFish_I;
      WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya+8,I,
      0,(Yview mod 16),16-(Xview mod 16),0);
    End;
    2:
    Begin
      Offset:=(((Yview div 16)+Ys1)*320)+(Xview div 16)+Xs2; GetFish_I;
      WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya+8,I,
      0,(Yview mod 16),0,0);
    End;
    3:
    Begin
      Offset:=(((Yview div 16)+Ys1)*320)+(Xview div 16)+Xs2; GetFish_I;
      WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya-(Yview mod 16)+8,I,
      0,0,0,0);
    End;
    4:
    Begin
      Offset:=(((Yview div 16)+Ys1)*320)+(Xview div 16)+Xs2; GetFish_I;
      WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya-(Yview mod 16)+8,I,
      0,0,16-(Xview mod 16),0);
    End;
    End; {Case End}
  End;

  Procedure WriteRoh3(Roh: Byte);
  Begin
    {roh 3 - vlevo dole}
    Case Roh of
    1:
    Begin
      Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+Xs1); GetFish_I;
      WritePolicko(Xa,Ya+((Ys2-Ys1-1)*16)+(16-(Yview mod 16))+8,I,
      (Xview mod 16),0,0,16-(Yview mod 16));
    End;
    2:
    Begin
      Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+Xs1); GetFish_I;
      WritePolicko(Xa-(Xview mod 16),Ya+((Ys2-Ys1-1)*16)+(16-(Yview mod 16))+8,I,
      0,0,0,16-(Yview mod 16));
    End;
    3:
    Begin
      Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+Xs1); GetFish_I;
      WritePolicko(Xa-(Xview mod 16),Ya+((Ys2-Ys1-1)*16)+(16-(Yview mod 16))+8,I,
      0,0,0,0);
    End;
    4:
    Begin
      Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+Xs1); GetFish_I;
      WritePolicko(Xa,Ya+((Ys2-Ys1-1)*16)+(16-(Yview mod 16))+8,I,
      (Xview mod 16),0,0,0);
    End;
    End; {Case End}
  End;

  Procedure WriteRoh4(Roh: Byte);
  Begin
    {roh 4 - vpravo dole}
    Case Roh of
    1:
    Begin
      Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+Xs2); GetFish_I;
      WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya+((Ys2-Ys1-1)*16)+(16-(Yview mod 16))+8,I,
      0,0,16-(Xview mod 16),16-(Yview mod 16));
    End;
    2:
    Begin
      Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+Xs2); GetFish_I;
      WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya+((Ys2-Ys1-1)*16)+(16-(Yview mod 16))+8,I,
      0,0,0,16-(Yview mod 16));
    End;
    3:
    Begin
      Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+Xs2); GetFish_I;
      WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya+((Ys2-Ys1-1)*16)+(16-(Yview mod 16))+8,I,
      0,0,0,0);
    End;
    4:
    Begin
      Offset:=(((Yview div 16)+Ys2)*320)+((Xview div 16)+Xs2); GetFish_I;
      WritePolicko(Xa+((Xs2-Xs1-1)*16)+(16-(Xview mod 16)),Ya+((Ys2-Ys1-1)*16)+(16-(Yview mod 16))+8,I,
      0,0,16-(Xview mod 16),0);
    End;
    End; {Case End}
  End;

Begin
  If (Xs1<Xs2-1) and (Ys1<Ys2-1) then
  Begin
    WritePlocha(Xs1,Ys1,Xs2-2,Ys2-2,'A');
    WriteOkraj1;
    WriteOkraj2;
    WriteOkraj3;
    WriteOkraj4;
    WriteRoh1(Roh1);
    WriteRoh2(Roh2);
    WriteRoh3(Roh3);
    WriteRoh4(Roh4);
  End;

  If (Xs1<Xs2-1) and (Ys1=Ys2) then
  Begin
    If (Yview>=3184) and (Yview<=3199) then
    Begin
      WriteOkraj3;
      If (Mapa.Xview>=4800) then
      Begin
        If switch1=True then WriteRoh1(1) else WriteRoh1(2);
        If switch1=True then WriteRoh2(2) else WriteRoh2(1);
      End;
      If (Mapa.Xview<=4799) then
      Begin
        WriteRoh1(1);
        WriteRoh2(1);
      End;

    End;
    If (Yview>=0) and (Yview<=15) then
    Begin
      WriteOkraj4;
      If (Mapa.Xview>=4800) then
      Begin
        If switch1=True then WriteRoh3(1) else WriteRoh3(2);
        If switch1=True then WriteRoh4(2) else WriteRoh4(1);
      End;
      If (Mapa.Xview<=4799) then
      Begin
        WriteRoh3(1);
        WriteRoh4(1);
      End;
    End;
  End;

  If (Xs1=Xs2) and (Ys1<Ys2-1) then
  Begin
    If (Xview>=5104) and (Xview<=5119) then
    Begin
      WriteOkraj1;
      If (Mapa.Yview>=3008) then
      Begin
        If switch2=True then WriteRoh1(1) else WriteRoh1(4);
        If switch2=True then WriteRoh3(4) else WriteRoh3(1);
      End;
      If (Mapa.Yview<=3007) then
      Begin
        WriteRoh1(1);
        WriteRoh3(1);
      End;
    End;
    If (Xview>=0) and (Xview<=15) then
    Begin
      WriteOkraj2;
      If (Mapa.Yview>=3008) then
      Begin
        If switch2=True then WriteRoh2(1) else WriteRoh2(4);
        If switch2=True then WriteRoh4(4) else WriteRoh4(1);
      End;
      If (Mapa.Yview<=3007) then
      Begin
        WriteRoh2(1);
        WriteRoh4(1);
      End;
    End;
  End;

  If (Xs1<Xs2-1) and (Ys1+1=Ys2) then
  Begin
    If (Yview>=3168) and (Yview<=3183) then
    Begin
      WritePlocha(Xs1,Ys1,Xs2-2,Ys2-1,'A');
      WriteOkraj3;
      If (Mapa.Xview>=4800) then
      Begin
        Inc(Ya,16);
        Inc(Ys1);
        If switch1=True then Begin WriteRoh1(4); WriteRoh2(3); End
                        else Begin WriteRoh1(3); WriteRoh2(4); End;
        Dec(Ys1);
        Dec(Ya,16);
        If switch1=True then Begin WriteRoh1(1); WriteRoh2(2); End
                        else Begin WriteRoh1(2); WriteRoh2(1); End;
      End;
      If (Mapa.Xview<=4799) then
      Begin
        Inc(Ya,16);
        Inc(Ys1);
        WriteRoh1(4);
        WriteRoh2(4);
        Dec(Ys1);
        Dec(Ya,16);
        WriteRoh1(1);
        WriteRoh2(1);
      End;
    End;
    If (Yview>=0) and (Yview<=15) then
    Begin
      WritePlocha(Xs1,Ys1,Xs2-2,Ys2-1,'B');
      WriteOkraj4;
      If (Mapa.Xview>=4800) then
      Begin
        Dec(Ys2);
        If switch1=True then Begin WriteRoh3(4); WriteRoh4(3); End
                        else Begin WriteRoh3(3); WriteRoh4(4); End;
        Inc(Ys2);
        If switch1=True then Begin WriteRoh3(1); WriteRoh4(2); End
                        else Begin WriteRoh3(2); WriteRoh4(1); End;
      End;
      If (Mapa.Xview<=4799) then
      Begin
        Dec(Ys2);
        WriteRoh3(4);
        WriteRoh4(4);
        Inc(Ys2);
        WriteRoh3(1);
        WriteRoh4(1);
      End;
    End;
  End;

  If (Xs1+1=Xs2) and (Ys1<Ys2-1) then
  Begin
    If (Xview>=5088) and (Xview<=5103) then
    Begin
      WritePlocha(Xs1,Ys1,Xs2-1,Ys2-2,'A');
      WriteOkraj1;
      If (Mapa.Yview>=3008) then
      Begin
        Inc(Xa,16);
        Inc(Xs1);
        If switch2=True then Begin WriteRoh1(2); WriteRoh3(3); End
                        else Begin WriteRoh1(3); WriteRoh3(2); End;
        Dec(Xs1);
        Dec(Xa,16);
        If switch2=True then Begin WriteRoh1(1); WriteRoh3(4); End
                        else Begin WriteRoh1(4); WriteRoh3(1); End
      End;
      If (Mapa.Yview<=3007) then
      Begin
        Inc(Xa,16);
        Inc(Xs1);
        WriteRoh1(2);
        WriteRoh3(2);
        Dec(Xs1);
        Dec(Xa,16);
        WriteRoh1(1);
        WriteRoh3(1);
      End;
    End;
    If (Xview>=0) and (Xview<=15) then
    Begin
      WritePlocha(Xs1,Ys1,Xs2-1,Ys2-2,'C');
      WriteOkraj2;
      If (Mapa.Yview>=3008) then
      Begin
        Dec(Xs2);
        If switch2=True then Begin WriteRoh2(2); WriteRoh4(3); End
                        else Begin WriteRoh2(3); WriteRoh4(2); End;
        Inc(Xs2);
        If switch2=True then Begin WriteRoh2(1); WriteRoh4(4); End
                        else Begin WriteRoh2(4); WriteRoh4(1); End
       End;
      If (Mapa.Yview<=3007) then
      Begin
        Dec(Xs2);
        WriteRoh2(2);
        WriteRoh4(2);
        Inc(Xs2);
        WriteRoh2(1);
        WriteRoh4(1);
      End;
    End;
  End;

  If (Xs1=Xs2) and (Ys1=Ys2) then
  Begin
    If (Mapa.Xview>=5104) and (Mapa.Yview>=3184) then WriteRoh1(1);
    If (Mapa.Xview<=5103) and (Mapa.Yview>=3184) then WriteRoh2(1);
    If (Mapa.Xview>=5104) and (Mapa.Yview<=3183) then WriteRoh3(1);
    If (Mapa.Xview<=5103) and (Mapa.Yview<=3183) then WriteRoh4(1);
  End;

  If (Mapa.Xview>=5088) and (Mapa.Yview>=3168) then
  Begin
    If (Xs1+1=Xs2) and (Ys1=Ys2) then
    Begin
        Inc(Xs1);
        Inc(Xa,16);
        WriteRoh1(2);
        Dec(Xa,16);
        Dec(Xs1);
        WriteRoh1(1);
    End;

    If (Xs1=Xs2) and (Ys1+1=Ys2) then
    Begin
        Inc(Ys1);
        Inc(Ya,16);
        WriteRoh1(4);
        Dec(Ya,16);
        Dec(Ys1);
        WriteRoh1(1);
    End;

    If (Xs1+1=Xs2) and (Ys1+1=Ys2) then
    Begin
        Inc(Xs1);
        Inc(Xa,16);
        WriteRoh1(2);
        Dec(Xa,16);
        Dec(Xs1);

        Inc(Ys1);
        Inc(Ya,16);
        WriteRoh1(4);
        Dec(Ya,16);
        Dec(Ys1);

        WriteRoh1(1);
        Inc(Xs1);
        Inc(Ys1);
        Inc(Xa,16);
        Inc(Ya,16);
        WriteRoh1(3);
        Dec(Ya,16);
        Dec(Xa,16);
        Dec(Ys1);
        Dec(Xs1);
    End;
  End;

  If (Mapa.Xview<=4831) and (Mapa.Yview>=3168) then
  Begin
    If (Xs1+1=Xs2) and (Ys1=Ys2) then
    Begin
        Dec(Xs2);
        WriteRoh2(2);
        Inc(Xs2);
        WriteRoh2(1);
    End;

    If (Xs1=Xs2) and (Ys1+1=Ys2) then
    Begin
        Inc(Ys1);
        Inc(Ya,16);
        WriteRoh2(4);
        Dec(Ya,16);
        Dec(Ys1);
        WriteRoh2(1);
    End;

    If (Xs1+1=Xs2) and (Ys1+1=Ys2) then
    Begin
        Dec(Xs2);
        WriteRoh2(2);
        Inc(Xs2);

        Inc(Ys1);
        Inc(Ya,16);
        WriteRoh2(4);
        Dec(Ya,16);
        Dec(Ys1);

        WriteRoh2(1);
        Inc(Ya,16);
        Dec(Xs2);
        Inc(Ys1);
        WriteRoh2(3);
        Dec(Ys1);
        Inc(Xs2);
        Dec(Ya,16);
    End;
  End;

  If (Mapa.Xview>=5088) and (Mapa.Yview<=3039) then
  Begin
    If (Xs1+1=Xs2) and (Ys1=Ys2) then
    Begin
      Inc(Xs1);
      Inc(Xa,16);
      WriteRoh3(2);
      Dec(Xa,16);
      Dec(Xs1);
      WriteRoh3(1);
    End;

    If (Xs1=Xs2) and (Ys1+1=Ys2) then
    Begin
      Dec(Ys2);
      WriteRoh3(4);
      Inc(Ys2);
      WriteRoh3(1);
    End;

    If (Xs1+1=Xs2) and (Ys1+1=Ys2) then
    Begin
      Inc(Xs1);
      Inc(Xa,16);
      WriteRoh3(2);
      Dec(Xa,16);
      Dec(Xs1);

      Dec(Ys2);
      WriteRoh3(4);
      Inc(Ys2);

      WriteRoh3(1);
      Dec(Ys2);
      Inc(Xs1);
      Inc(Xa,16);
      WriteRoh3(3);
      Dec(Xa,16);
      Dec(Xs1);
      Inc(Ys2);
    End;
  End;

  If (Mapa.Xview<=4831) and (Mapa.Yview<=3039) then
  Begin
    If (Xs1+1=Xs2) and (Ys1=Ys2) then
    Begin
      Dec(Xs2);
      WriteRoh4(2);
      Inc(Xs2);
      WriteRoh4(1);
    End;

    If (Xs1=Xs2) and (Ys1+1=Ys2) then
    Begin
      Dec(Ys2);
      WriteRoh4(4);
      Inc(Ys2);
      WriteRoh4(1);
    End;

    If (Xs1+1=Xs2) and (Ys1+1=Ys2) then
    Begin
      Dec(Xs2);
      WriteRoh4(2);
      Inc(Xs2);

      Dec(Ys2);
      WriteRoh4(4);
      Inc(Ys2);

      WriteRoh4(1);
      Dec(Ys2);
      Dec(Xs2);
      WriteRoh4(3);
      Inc(Xs2);
      Inc(Ys2);
    End;
  End;

End;


Procedure WriteWorldScreen;
Var
  X1,Y1,X2,Y2: Integer;
Begin
  ClearPage(Buffer[3]);

  If (Mapa.Xview<=4799) and (Mapa.Yview<=3007) then
  WriteWorldScreenSegment(0,0,Mapa.Xview,Mapa.Yview,
  0,0,20,12,True,True,True,True,1,1,1,1,False,False);

  If (Mapa.Xview>=4800) and (Mapa.Yview<=3007) then
  Begin
    X1:=0;
    Y1:=0;
    X2:=320-(Mapa.Xview div 16)-1;
    Y2:=12;
    WriteWorldScreenSegment(0,0,Mapa.Xview,Mapa.Yview,
    X1,Y1,X2,Y2,True,False,True,True,1,2,1,2,True,False);

    X1:=0;
    Y1:=0;
    X2:=20-(320-(Mapa.Xview div 16));
    Y2:=12;
    WriteWorldScreenSegment((320-(Mapa.Xview div 16))*16,0,Mapa.Xview mod 16,Mapa.Yview,
    X1,Y1,X2,Y2,False,True,True,True,2,1,2,1,False,False);
  End;

  If (Mapa.Xview<=4799) and (Mapa.Yview>=3008) then
  Begin
    X1:=0;
    Y1:=0;
    X2:=20;
    Y2:=200-(Mapa.Yview div 16)-1;
    WriteWorldScreenSegment(0,0,Mapa.Xview,Mapa.Yview,
    X1,Y1,X2,Y2,True,True,True,False,1,1,4,4,False,True);

    X1:=0;
    Y1:=0;
    X2:=20;
    Y2:=12-(200-(Mapa.Yview div 16));
    WriteWorldScreenSegment(0,(200-(Mapa.Yview div 16))*16,Mapa.Xview,Mapa.Yview mod 16,
    X1,Y1,X2,Y2,True,True,False,True,4,4,1,1,False,False);
  End;

  If (Mapa.Xview>=4800) and (Mapa.Yview>=3008) then
  Begin
    {levy horni}
    X1:=0;
    Y1:=0;
    X2:=320-(Mapa.Xview div 16)-1;
    Y2:=200-(Mapa.Yview div 16)-1;
    WriteWorldScreenSegment(0,0,Mapa.Xview,Mapa.Yview,
    X1,Y1,X2,Y2,True,False,True,False,1,2,4,3,True,True);

    {pravy horni}
    X1:=0;
    Y1:=0;
    X2:=20-(320-(Mapa.Xview div 16));
    Y2:=200-(Mapa.Yview div 16)-1;
    WriteWorldScreenSegment((320-(Mapa.Xview div 16))*16,0,Mapa.Xview mod 16,Mapa.Yview,
    X1,Y1,X2,Y2,False,True,True,False,2,1,3,4,False,True);

    {levy dolni}
    X1:=0;
    Y1:=0;
    X2:=320-(Mapa.Xview div 16)-1;
    Y2:=12-(200-(Mapa.Yview div 16));
    WriteWorldScreenSegment(0,(200-(Mapa.Yview div 16))*16,Mapa.Xview,Mapa.Yview mod 16,
    X1,Y1,X2,Y2,True,False,False,True,4,3,1,2,True,False);

    {pravy dolni}
    X1:=0;
    Y1:=0;
    X2:=20-(320-(Mapa.Xview div 16));
    Y2:=12-(200-(Mapa.Yview div 16));
    WriteWorldScreenSegment((320-(Mapa.Xview div 16))*16,(200-(Mapa.Yview div 16))*16,Mapa.Xview mod 16,Mapa.Yview mod 16,
    X1,Y1,X2,Y2,False,True,False,True,3,4,2,1,False,False);
  End;
End;
