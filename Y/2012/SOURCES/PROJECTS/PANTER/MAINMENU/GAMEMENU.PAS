Procedure WriteHP(X,Y,HP,HPmax:Word);
Begin
  If ((HPmax>=10) and (HPmax<100)) then
  Begin
    If ((HP>=0) and (HP<10)) then
    Begin
      WriteNumber(X,Y,HP,False,Buffer[3]);
      WriteText(X+6,Y,'/',Buffer[3]);
      WriteNumber(X+14,Y,HPmax,False,Buffer[3]);
    End;
    If ((HP>=10) and (HP<100)) then
    Begin
      WriteNumber(X,Y,HP,False,Buffer[3]);
      WriteText(X+12,Y,'/',Buffer[3]);
      WriteNumber(X+20,Y,HPmax,False,Buffer[3]);
    End;
  End;

  If ((HPmax>=100) and (HPmax<1000)) then
  Begin
    If ((HP>=0) and (HP<10)) then
    Begin
      WriteNumber(X,Y,HP,False,Buffer[3]);
      WriteText(X+6,Y,'/',Buffer[3]);
      WriteNumber(X+14,Y,HPmax,False,Buffer[3]);
    End;
    If ((HP>=10) and (HP<100)) then
    Begin
      WriteNumber(X,Y,HP,False,Buffer[3]);
      WriteText(X+12,Y,'/',Buffer[3]);
      WriteNumber(X+20,Y,HPmax,False,Buffer[3]);
    End;
    If ((HP>=100) and (HP<1000)) then
    Begin
      WriteNumber(X,Y,HP,False,Buffer[3]);
      WriteText(X+18,Y,'/',Buffer[3]);
      WriteNumber(X+26,Y,HPmax,False,Buffer[3]);
    End;
  End;

  If ((HPmax>=1000) and (HPmax<10000)) then
  Begin
    If ((HP>=0) and (HP<10)) then
    Begin
      WriteNumber(X,Y,HP,False,Buffer[3]);
      WriteText(X+6,Y,'/',Buffer[3]);
      WriteNumber(X+14,Y,HPmax,False,Buffer[3]);
    End;
    If ((HP>=10) and (HP<100)) then
    Begin
      WriteNumber(X,Y,HP,False,Buffer[3]);
      WriteText(X+12,Y,'/',Buffer[3]);
      WriteNumber(X+20,Y,HPmax,False,Buffer[3]);
    End;
    If ((HP>=100) and (HP<1000)) then
    Begin
      WriteNumber(X,Y,HP,False,Buffer[3]);
      WriteText(X+18,Y,'/',Buffer[3]);
      WriteNumber(X+26,Y,HPmax,False,Buffer[3]);
    End;
    If ((HP>=1000) and (HP<10000)) then
    Begin
      WriteNumber(X,Y,HP,False,Buffer[3]);
      WriteText(X+24,Y,'/',Buffer[3]);
      WriteNumber(X+32,Y,HPmax,False,Buffer[3]);
    End;
  End;
End;


Procedure WriteMP(X,Y:Word;Cislo:Byte);
Var I: Byte;
Begin
  For I:=0 to 3 do WriteNumber(X+I*20,Y,Player[Cislo].MP[I],False,Buffer[3]);
  For I:=0 to 3 do WriteNumber(X+I*20,Y+15,Player[Cislo].MP[I+4],False,Buffer[3]);
End;


Procedure WritePanak(X:Word;Y,Cislo,Job:Byte;Jmeno:String);
Begin
  Blok(X,Y,X+115,Y+95,Graphics.WindowsColor,Buffer[3]);
  Ramecek(X,Y,X+115,Y+95,Graphics.FontColor,Buffer[3]);
  If Player[Cislo].HP>0 then WriteSprite(X+11,Y+5,(Job-1)*20,148,(Job-1)*20+19,179,Buffer[1],Buffer[3])
  {Player[Cislo].HP=0}  else WriteSprite(X+5,Y+26,128,(Job-1)*16,159,(Job-1)*16+15,Buffer[1],Buffer[3]);
  WriteText(X+42,Y+10,Jmeno,Buffer[3]);
  WriteHP(X+42,Y+25,Player[Cislo].HP,Player[Cislo].HPmax);
  If Job>=4 then WriteMP(X+20,Y+55,Cislo);
  {Gold}
  Blok(0,183,73,195,Graphics.WindowsColor,Buffer[3]);
  Ramecek(0,183,73,195,Graphics.FontColor,Buffer[3]);
  WriteText(5,185,'G',Buffer[3]);
  WriteNumber(12,186,Parta.Gold,False,Buffer[3]);
End;


Procedure WriteGameMenuScreen(Volba:Byte);
Begin
  ClearPage(Buffer[3]);

  Blok(0,0,73,87,Graphics.WindowsColor,Buffer[3]);
  Ramecek(0,0,73,87,Graphics.FontColor,Buffer[3]);
  WriteText(16,4,'Invent ý',Buffer[3]);
  WriteText(16,14,'Kouzla',Buffer[3]);
  WriteText(16,24,'Vybaven¡',Buffer[3]);
  WriteText(16,34,'Status',Buffer[3]);
  WriteText(16,44,'Formace',Buffer[3]);
  WriteText(16,54,'Mapa',Buffer[3]);
  WriteText(16,64,'Nastaven¡',Buffer[3]);
  WriteText(16,74,'Save',Buffer[3]);
  WriteSipka(4,Volba*10+5);

  WritePanak(80,0,1,Player[1].Job,Player[1].Jmeno);
  WritePanak(200,0,2,Player[2].Job,Player[2].Jmeno);
  WritePanak(80,100,3,Player[3].Job,Player[3].Jmeno);
  WritePanak(200,100,4,Player[4].Job,Player[4].Jmeno);

  ShowFPS(10,180);
  If Graphics.Vsync=True then WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure GameMenu;
Var
  Ending: Boolean;
  Volba: Byte;
Begin
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  Volba:=0;
  Repeat
    Stopky_Start;
    WriteGameMenuScreen(Volba);
    WaitMenu(fps.prodlevamenu);
    Stopky_Stop;
    FPSTrigg;

{Up}    If Key[Ovladani.KeyUp]=True then
        Begin
          While Key[Ovladani.KeyUp]=True do WaitButton(Ovladani.KeyUp);
          If Volba>0 then Dec(Volba) else Volba:=7;
        End;

{Down}  If Key[Ovladani.KeyDown]=True then
        Begin
          While Key[Ovladani.KeyDown]=True do WaitButton(Ovladani.KeyDown);
          If Volba<7 then Inc(Volba) else Volba:=0;
        End;

{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
          Case Volba of
            0: GM_Item;       {Invent ý}
            1: GM_Magic;      {Kouzla}
            2: GM_Equip;      {Vybaven¡}
            3: GM_Status;     {Status}
            4: GM_Formation;  {Formace}
            5: Begin          {Mapa}
                 If Mapa.Obtain[Mapa.Id]=True then GM_Mapa;
               End;
            6: GM_Config;     {Nastaven¡}
            7: GM_Save;       {Save}
          End; {Case End}
        End;

{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          WaitRelease;
          Key[Ovladani.KeyBack]:=False;
          Ending:=True;
        End;

{F10}   If Key[68]=True then
        Begin
          Ending:=True;
        End;

  Until Ending=True;
End;
