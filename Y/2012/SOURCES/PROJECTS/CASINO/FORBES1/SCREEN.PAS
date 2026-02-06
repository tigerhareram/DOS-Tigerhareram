Procedure WriteAutomatScreen;
Var I,X,Y: Word;
Begin
  ClearPage(Buffer[2]);
  WriteBlok(0,0,260,0,319,180,Buffer[1],Buffer[2]);
  Ramecek(74,62,195,159,100,Buffer[2]);
  Ramecek(72,60,197,161,100,Buffer[2]);

  WriteBlok(75,63,0,0,119,95,Buffer[3],Buffer[2]);

  WriteBlok(0,184,0,184,215,199,Buffer[3],Buffer[2]);
  Ramecek(209,63,306,160,100,Buffer[2]);
  Ramecek(207,61,308,162,100,Buffer[2]);

  WriteBlok(210,64,200,0,295,95,Buffer[3],Buffer[2]);

  Blok(64,0,66,180,100,Buffer[2]);
  Number(75,6,Score,False,2);
  If Sazka<10 then Number(310,6,Sazka,True,2);
  If (Sazka>=10) and (Sazka<100) then Number(300,6,Sazka,True,2);
  If (Sazka>=100) and (Sazka<1000) then Number(290,6,Sazka,True,2);
  If Sazka=1000 then Number(280,6,Sazka,True,2);
  If Credit<10 then Number(310,26,Credit,True,2);
  If (Credit>=10) and (Credit<100) then Number(300,26,Credit,True,2);
  If (Credit>=100) and (Credit<1000) then Number(290,26,Credit,True,2);
  If (Credit>=1000) and (Credit<10000) then Number(280,26,Credit,True,2);
  If (Credit>=10000) and (Credit<100000) then Number(270,26,Credit,True,2);
  If (Credit>=100000) and (Credit<1000000) then Number(260,26,Credit,True,2);
  Number(220,183,Hotovost1,True,2);
  If (Hotovost1>=0) and (Hotovost1<10) then X:=232;
  If (Hotovost1>=10) and (Hotovost1<100) then X:=242;
  If (Hotovost1>=100) and (Hotovost1<1000) then X:=252;
  If (Hotovost1>=1000) and (Hotovost1<10000) then X:=262;
  If (Hotovost1>=10000) and (Hotovost1<100000) then X:=272;
  If (Hotovost1>=100000) and (Hotovost1<1000000) then X:=282;
  If (Hotovost1>=1000000) and (Hotovost1<9999999) then X:=292;
  WriteBlok(X,183,163,164,186,179,Buffer[1],Buffer[2]);
  If AddFundDiag=True then
  Begin
    Blok(207,61,308,162,0,Buffer[2]);

    X:=204; Y:=70;
    For I:=0 to 4 do
    Begin
      Blok(X,Y,X+46,Y+19,97,Buffer[2]);
      Ramecek(X,Y,X+46,Y+19,100,Buffer[2]);
      Inc(Y,22);
    End;
    X:=254; Y:=70;
    For I:=0 to 4 do
    Begin
      Blok(X,Y,X+46,Y+19,97,Buffer[2]);
      Ramecek(X,Y,X+46,Y+19,100,Buffer[2]);
      Inc(Y,22);
    End;
    Case AddFundSelect of
     0: Begin X:=204; Y:=70;  End;
     1: Begin X:=204; Y:=92;  End;
     2: Begin X:=204; Y:=114; End;
     3: Begin X:=204; Y:=136; End;
     4: Begin X:=204; Y:=158; End;
     5: Begin X:=254; Y:=70;  End;
     6: Begin X:=254; Y:=92;  End;
     7: Begin X:=254; Y:=114; End;
     8: Begin X:=254; Y:=136; End;
     9: Begin X:=254; Y:=158; End;
    End;
    Blok(X+1,Y+1,X+45,Y+18,15,Buffer[2]);
    Number(225,72,5,True,2);
    Number(220,94,10,True,2);
    Number(220,116,20,True,2);
    Number(220,138,50,True,2);
    Number(215,160,100,True,2);
    Number(265,72,200,True,2);
    Number(265,94,500,True,2);
    Number(258,116,1000,True,2);
    Number(258,138,2000,True,2);
    Number(258,160,5000,True,2);
    X:=215; Y:=52;
    If BlikInfo=True then Begin
                            BlikInfo:=False;
                            WriteBlok(X,Y,160,80,232,95,Buffer[1],Buffer[2]);
                          End
                     else Begin
                            BlikInfo:=True;
                            WriteBlok(X,Y,160,96,232,111,Buffer[1],Buffer[2]);
                          End;
  End;
  WaitRetrace;
  FlipPage(Buffer[2],Buffer[4]);
End;