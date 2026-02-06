Procedure Prodat;
Const MaxPolozek = 13;
Var Ending: Boolean;
    polozka: Byte;

  Procedure ProdatVec;
  Begin
          Penize:=0;
          If VecProdata[Polozka]=False then
          Begin
            Case Polozka of
              0: Inc(Penize,325000);
              1: Inc(Penize,12000);
              2: Inc(Penize,6500);
              3: Inc(Penize,2500);
              4: Inc(Penize,3500);
              5: Inc(Penize,1500);
              6: Inc(Penize,2000);
              7: Inc(Penize,4500);
              8: Inc(Penize,1000);
              9: Inc(Penize,4000);
             10: Inc(Penize,2500);
             11: Inc(Penize,10000);
             12: Inc(Penize,9000);
             13: Inc(Penize,16000);
            End; {Case End}
            VecProdata[Polozka]:=True;
            DatRec2.vec[Polozka]:=False;
            Inc(DatRec2.Hotovost,Penize);
            Penize:=0;
            If DatRec.SBEnable=True then SBPlayRaw(11)
                                    else PlaySound(1);
          End else
          Begin
            Case Polozka of
              0: Inc(Penize,325000);
              1: Inc(Penize,12000);
              2: Inc(Penize,6500);
              3: Inc(Penize,2500);
              4: Inc(Penize,3500);
              5: Inc(Penize,1500);
              6: Inc(Penize,2000);
              7: Inc(Penize,4500);
              8: Inc(Penize,1000);
              9: Inc(Penize,4000);
             10: Inc(Penize,2500);
             11: Inc(Penize,10000);
             12: Inc(Penize,9000);
             13: Inc(Penize,16000);
            End; {Case End}
            If DatRec2.Hotovost>=Penize then
            Begin
              Dec(DatRec2.Hotovost,Penize);
              VecProdata[Polozka]:=False;
              DatRec2.vec[Polozka]:=True;
            End;
            Penize:=0;
            If DatRec.SBEnable=True then SBPlayRaw(11)
                                    else PlaySound(1);
          End;

  End;

  Procedure ProdatScreen;
  Var I: Byte;
  Begin
    ClearPage(Buffer[3]);
    Ramecek(0,0,319,199,ColorGreen,Buffer[3]);
    WriteText(Buffer[1],160,0,5,5,1,268,5,'esc=exit',Buffer[3]);
    {kurzor}
    OutText(5,2+polozka*14,'>>>',Buffer[3]);
    {polozky}
    For I:=0 to MaxPolozek do
    Begin
      If VecProdata[I]=True then
      Case I of
        0: OutText(25,2+I*14,'Byt ........................ prod no KŸ',Buffer[3]);
        1: OutText(25,2+I*14,'Auto ....................... prod no KŸ',Buffer[3]);
        2: OutText(25,2+I*14,'Motorka .................... prod no KŸ',Buffer[3]);
        3: OutText(25,2+I*14,'LedniŸka ................... prod no KŸ',Buffer[3]);
        4: OutText(25,2+I*14,'PraŸka ..................... prod no KŸ',Buffer[3]);
        5: OutText(25,2+I*14,'Televize ................... prod no KŸ',Buffer[3]);
        6: OutText(25,2+I*14,'Kolo ....................... prod no KŸ',Buffer[3]);
        7: OutText(25,2+I*14,'Obìvac¡ stØna .............. prod no KŸ',Buffer[3]);
        8: OutText(25,2+I*14,'Mikrovlnn  trouba .......... prod no KŸ',Buffer[3]);
        9: OutText(25,2+I*14,'PoŸ¡taŸ .................... prod no KŸ',Buffer[3]);
       10: OutText(25,2+I*14,'Hern¡ Konzole .............. prod no KŸ',Buffer[3]);
       11: OutText(25,2+I*14,'P…jŸka ................... vyp…jŸeno KŸ',Buffer[3]);
       12: OutText(25,2+I*14,'D…chod ................... vyplaceno KŸ',Buffer[3]);
       13: OutText(25,2+I*14,'Vìplata .................. vyplaceno KŸ',Buffer[3]);
      End {Case End}
      else
      Case I of
        0: OutText(25,2+I*14,'Byt ........................ +325000 KŸ',Buffer[3]);
        1: OutText(25,2+I*14,'Auto ........................ +12000 KŸ',Buffer[3]);
        2: OutText(25,2+I*14,'Motorka ...................... +6500 KŸ',Buffer[3]);
        3: OutText(25,2+I*14,'LedniŸka ..................... +2500 KŸ',Buffer[3]);
        4: OutText(25,2+I*14,'PraŸka ....................... +3500 KŸ',Buffer[3]);
        5: OutText(25,2+I*14,'Televize ..................... +1500 KŸ',Buffer[3]);
        6: OutText(25,2+I*14,'Kolo ......................... +2000 KŸ',Buffer[3]);
        7: OutText(25,2+I*14,'Obìvac¡ stØna ................ +4500 KŸ',Buffer[3]);
        8: OutText(25,2+I*14,'Mikrovlnn  trouba ............ +1000 KŸ',Buffer[3]);
        9: OutText(25,2+I*14,'PoŸ¡taŸ ...................... +4000 KŸ',Buffer[3]);
       10: OutText(25,2+I*14,'Hern¡ Konzole ................ +2500 KŸ',Buffer[3]);
       11: OutText(25,2+I*14,'P…jŸka ...................... +10000 KŸ',Buffer[3]);
       12: OutText(25,2+I*14,'D…chod ....................... +9000 KŸ',Buffer[3]);
       13: OutText(25,2+I*14,'Vìplata ..................... +16000 KŸ',Buffer[3]);
      End; {Case End}
    End;
    HideMouse;
    WaitRetrace;
    FlipPage(Buffer[3],Buffer[4]);
    ShowMouse;
  End;

Begin
  Ending:=False;
  ProdatScreen;
  For polozka:=0 to 13 do If DatRec2.Vec[polozka]=True then VecProdata[polozka]:=False
                                                       else VecProdata[polozka]:=True;
  polozka:=0;
  Repeat
    ProdatScreen;
    Wait(DatRec.fpsProdleva);

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=0) and (GetMouseY<14) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=0 then ProdatVec
                       else polozka:=0;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=14) and (GetMouseY<28) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=1 then ProdatVec
                       else polozka:=1;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=28) and (GetMouseY<42) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=2 then ProdatVec
                       else polozka:=2;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=42) and (GetMouseY<56) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=3 then ProdatVec
                       else polozka:=3;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=56) and (GetMouseY<70) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=4 then ProdatVec
                       else polozka:=4;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=70) and (GetMouseY<84) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=5 then ProdatVec
                       else polozka:=5;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=84) and (GetMouseY<98) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=6 then ProdatVec
                       else polozka:=6;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=98) and (GetMouseY<112) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=7 then ProdatVec
                       else polozka:=7;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=112) and (GetMouseY<126) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=8 then ProdatVec
                       else polozka:=8;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=126) and (GetMouseY<140) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=9 then ProdatVec
                       else polozka:=9;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=140) and (GetMouseY<154) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=10 then ProdatVec
                        else polozka:=10;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=154) and (GetMouseY<168) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=11 then ProdatVec
                        else polozka:=11;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=168) and (GetMouseY<182) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=12 then ProdatVec
                        else polozka:=12;
        End;

    If ((GetMouseX>=0*2) and (GetMouseX<=319*2) and
        (GetMouseY>=182) and (GetMouseY<196) and (GetButton1=1)) then
        Begin
          While GetButton1=1 do Begin End;
          If polozka=13 then ProdatVec
                        else polozka:=13;
        End;

{Up}    If Key[72]=True then
        Begin
          While Key[72]=True do WaitButton(72);
          If polozka>0 then Dec(polozka) else polozka:=MaxPolozek;
        End;

{Down}  If Key[80]=True then
        Begin
          While Key[80]=True do WaitButton(80);
          If polozka<MaxPolozek then Inc(polozka) else polozka:=0;
        End;

{Enter} If Key[28]=True then
        Begin
          While Key[28]=True do Begin End;
          ProdatVec;
        End;

{Esc} If ((Key[1]=True) or (GetButton2=1)) then
      Begin
        While ((Key[1]=True) or (GetButton2=1)) do Begin End;
        Ending:=True;
      End;

  Until Ending=True;

End;