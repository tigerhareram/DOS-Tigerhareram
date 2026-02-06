Program Test2;
Uses Engine;

Const
  MaxPanaku=6;

Var
  Ending: Boolean;
  Select: Byte;
  Frame: Byte;
  Smer: Byte;
  X,Y: Word;
  Krok: Boolean;
  KrokCounter: Byte;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Procedure Main;
Var I: Byte;
Begin
  Ending:=False;
  Select:=0;
  Frame:=0;
  Smer:=0;
  X:=152;
  Y:=77;
  Krok:=False;
  KrokCounter:=0;

  Init320x200;
  InitBuffers;
  InitKeyboard;
  InitTexter(50);
  InitTimer;

  LoadGrPage('panter2.gra',0);

  For I:=0 to MaxPanaku do
  Begin
    LoadBlok(0,I*16,0,I*16,15,I*16+15,Buffer[1]);
    LoadBlok(16,I*16,0,I*16,15,I*16+7,Buffer[1]);
    LoadBlokM(16,I*16+8,0,I*16+8,15,I*16+15,Buffer[1]);
    LoadBlok(32,I*16,16,I*16,31,I*16+15,Buffer[1]);
    LoadBlok(48,I*16,16,I*16,31,I*16+7,Buffer[1]);
    LoadBlokM(48,I*16+8,16,I*16+8,31,I*16+15,Buffer[1]);
    LoadBlok(64,I*16,32,I*16,47,I*16+15,Buffer[1]);
    LoadBlok(80,I*16,48,I*16,63,I*16+15,Buffer[1]);
    LoadBlokM(96,I*16,32,I*16,47,I*16+15,Buffer[1]);
    LoadBlokM(112,I*16,48,I*16,63,I*16+15,Buffer[1]);
  End;

  Repeat
    ClearPage(Buffer[3]);
    Blok(5,40,300,180,120,Buffer[3]);
    Ramecek(5,40,300,180,40,Buffer[3]);

    WriteText(10,5, 'zmÿna = Enter',Buffer[3]);
    WriteText(10,15,'pohyb = Áipky',Buffer[3]);
    WriteText(10,25,'exit = Esc',Buffer[3]);

{Esc}   If Key[1]=True then Ending:=True;

{Enter} If Key[28]=True then
        Begin
          While Key[28]=True do Begin End;
          If Select<MaxPanaku-1 then Inc(Select)
                                else Select:=0;
        End;

{Up}    If Key[72]=True then
        Begin
          If Krok=False then Begin Krok:=True; Smer:=1; End;
        End;

{Down}  If Key[80]=True then
        Begin
          If Krok=False then Begin Krok:=True; Smer:=0; End;
        End;

{Left}  If Key[75]=True then
        Begin
          If Krok=False then Begin Krok:=True; Smer:=3; End;
        End;

{Right} If Key[77]=True then
        Begin
          If Krok=False then Begin Krok:=True; Smer:=2; End;
        End;


    If Krok=True then
    Begin
      If KrokCounter<7 then Inc(KrokCounter)
                       else Begin
                              KrokCounter:=0;
                              Krok:=False;
                            End;
      Case Smer of
      {dolu}    0: Begin If Y<180 then Inc(Y,2) else Y:=40; End;
      {nahoru}  1: Begin If Y>40 then Dec(Y,2) else Y:=180; End;
      {doprava} 2: Begin If X<300 then Inc(X,2) else X:=5; End;
      {doleva}  3: Begin If X>5 then Dec(X,2) else X:=300; End;
      End; {Case End}

      Case Smer of
        0: Begin
             If Frame=0 then Begin Frame:=1; WriteSprite(X,Y,0,Select*16,15,Select*16+15,Buffer[1],Buffer[3]); End
                        else Begin Frame:=0; WriteSprite(X,Y,16,Select*16,31,Select*16+15,Buffer[1],Buffer[3]); End;
           End;
        1: Begin
             If Frame=0 then Begin Frame:=1; WriteSprite(X,Y,32,Select*16,47,Select*16+15,Buffer[1],Buffer[3]); End
                        else Begin Frame:=0; WriteSprite(X,Y,48,Select*16,63,Select*16+15,Buffer[1],Buffer[3]); End;
           End;
        2: Begin
             If Frame=0 then Begin Frame:=1; WriteSprite(X,Y,64,Select*16,79,Select*16+15,Buffer[1],Buffer[3]); End
                        else Begin Frame:=0; WriteSprite(X,Y,80,Select*16,95,Select*16+15,Buffer[1],Buffer[3]); End;
           End;
        3: Begin
             If Frame=0 then Begin Frame:=1; WriteSprite(X,Y,96,Select*16,111,Select*16+15,Buffer[1],Buffer[3]); End
                        else Begin Frame:=0; WriteSprite(X,Y,112,Select*16,127,Select*16+15,Buffer[1],Buffer[3]); End;
           End;
      End; {Case End}
    End Else
    Begin
      Case Smer of
        0: WriteSprite(X,Y,0,Select*16,15,Select*16+15,Buffer[1],Buffer[3]);
        1: WriteSprite(X,Y,32,Select*16,47,Select*16+15,Buffer[1],Buffer[3]);
        2: WriteSprite(X,Y,64,Select*16,79,Select*16+15,Buffer[1],Buffer[3]);
        3: WriteSprite(X,Y,96,Select*16,111,Select*16+15,Buffer[1],Buffer[3]);
      End; {Case End}
    End;

    FlipPage(Buffer[3],Buffer[4]);
    Wait(100);

  Until Ending=True;

  ShutdownTimer;
  ShutdownTexter;
  ShutdownKeyboard;
  ShutdownBuffers;
  Init80x25;
End;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin Main; End.