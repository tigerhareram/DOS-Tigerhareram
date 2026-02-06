Function GetSizeOfSlot: LongInt;
Begin
  GetSizeOfSlot:= SizeOf(Player)   +
                  SizeOf(Ovladani) +
                  SizeOf(Graphics) +
                  SizeOf(Menu)     +
                  SizeOf(fps)      +
                  SizeOf(Parta)    +
                  SizeOf(Lod1)     +
                  SizeOf(Lod2)     +
                  SizeOf(Mapa);
End;


Procedure WriteToSlot(CisloSlotu: Byte);
Var pozice: LongInt;
Begin
  pozice:=(CisloSlotu-1)*GetSizeOfSlot;
  Seek(F,pozice);
  BlockWrite(F,Player,SizeOf(Player));
  BlockWrite(F,Ovladani,SizeOf(Ovladani));
  BlockWrite(F,Graphics,SizeOf(Graphics));
  BlockWrite(F,Menu,SizeOf(Menu));
  BlockWrite(F,fps,SizeOf(fps));
  BlockWrite(F,Parta,SizeOf(Parta));
  BlockWrite(F,Lod1,SizeOf(Lod1));
  BlockWrite(F,Lod2,SizeOf(Lod2));
  BlockWrite(F,Mapa,SizeOf(Mapa));
End;


Procedure LoadFromSlot(CisloSlotu: Byte);
Var pozice: LongInt;
Begin
  pozice:=(CisloSlotu-1)*GetSizeOfSlot;
  Seek(F,pozice);
  BlockRead(F,Player,SizeOf(Player));
  BlockRead(F,Ovladani,SizeOf(Ovladani));
  BlockRead(F,Graphics,SizeOf(Graphics));
  BlockRead(F,Menu,SizeOf(Menu));
  BlockRead(F,fps,SizeOf(fps));
  BlockRead(F,Parta,SizeOf(Parta));
  BlockRead(F,Lod1,SizeOf(Lod1));
  BlockRead(F,Lod2,SizeOf(Lod2));
  BlockRead(F,Mapa,SizeOf(Mapa));

  SetPal(Graphics.FontColor,Graphics.FontColorR,Graphics.FontColorG,Graphics.FontColorB);
  SetPal(Graphics.WindowsColor,Graphics.WindowsColorR,Graphics.WindowsColorG,Graphics.WindowsColorB);

  Parta.Vudce:=Player[1].Job-1;
End;


Procedure ZalohujStav;
Var I: Byte;
Begin
  For I:=1 to 4 do Save.Slot[4].Player[I]:=Player[I];
  Save.Slot[4].Ovladani:=Ovladani;
  Save.Slot[4].Graphics:=Graphics;
  Save.Slot[4].Menu:=Menu;
  Save.Slot[4].fps:=fps;
  Save.Slot[4].Parta:=Parta;
  Save.Slot[4].Lod1:=Lod1;
  Save.Slot[4].Lod2:=Lod2;
  Save.Slot[4].Mapa:=Mapa;
End;


Procedure ObnovStav;
Var I: Byte;
Begin
  For I:=1 to 4 do Player[I]:=Save.Slot[4].Player[I];
  Ovladani:=Save.Slot[4].Ovladani;
  Graphics:=Save.Slot[4].Graphics;
  Menu:=Save.Slot[4].Menu;
  fps:=Save.Slot[4].fps;
  Parta:=Save.Slot[4].Parta;
  Lod1:=Save.Slot[4].Lod1;
  Lod2:=Save.Slot[4].Lod2;
  Mapa:=Save.Slot[4].Mapa;

  SetPal(Graphics.FontColor,Graphics.FontColorR,Graphics.FontColorG,Graphics.FontColorB);
  SetPal(Graphics.WindowsColor,Graphics.WindowsColorR,Graphics.WindowsColorG,Graphics.WindowsColorB);

  Parta.Vudce:=Player[1].Job-1;
End;


Procedure ZapisInfo(Cislo: Byte);
Var I,N: Byte;
Begin
  For I:=1 to 4 do Save.Slot[Cislo].Player[I]:=Player[I];
  Save.Slot[Cislo].Ovladani:=Ovladani;
  Save.Slot[Cislo].Graphics:=Graphics;
  Save.Slot[Cislo].Menu:=Menu;
  Save.Slot[Cislo].fps:=fps;
  Save.Slot[Cislo].Parta:=Parta;
  Save.Slot[Cislo].Lod1:=Lod1;
  Save.Slot[Cislo].Lod2:=Lod2;
  Save.Slot[Cislo].Mapa:=Mapa;
End;


Procedure SetEmpty; {Create Empty SaveFile}
Var I: Byte;
Begin
  For I:=1 to 4 do
  Begin
    Player[I].Jmeno:='';
    Player[I].Job:=0;
  End;

  Graphics.vSync:=False;
  Graphics.WindowsColor:=254;
  Graphics.WindowsColorR:=0;
  Graphics.WindowsColorG:=0;
  Graphics.WindowsColorB:=63;
  Graphics.FontColor:=255;
  Graphics.FontColorR:=63;
  Graphics.FontColorG:=63;
  Graphics.FontColorB:=63;

  fps.limit:=100;
  fps.prodleva:=1000 div fps.limit;
  fps.prodlevamenu:=1000 div fps.limit;
  fps.zobrazovat:=False;

  menu.Speed:=140;

  Ovladani.KeyUp:=72;
  Ovladani.KeyDown:=80;
  Ovladani.KeyLeft:=75;
  Ovladani.KeyRight:=77;
  Ovladani.KeyOK:=28;
  Ovladani.KeyBack:=1;
End;


Procedure WriteSaveLoadScreen(VolbaMenu,Mode: Byte);
Var I,N: Byte;
Begin
  ClearPage(Buffer[3]);

  If Mode=1 then Begin {Save}
                   Blok(230,7,261,21,Graphics.WindowsColor,Buffer[3]);
                   Ramecek(230,7,261,21,Graphics.FontColor,Buffer[3]);
                   WriteText(234,10,'SAVE',Buffer[3]);
                 End
            else Begin {Load}
                   Blok(220,7,251,21,Graphics.WindowsColor,Buffer[3]);
                   Ramecek(220,7,251,21,Graphics.FontColor,Buffer[3]);
                   WriteText(224,10,'LOAD',Buffer[3]);
                 End;

  For I:=0 to 3 do
  Begin
    Blok(12,I*50,212,I*50+48,Graphics.WindowsColor,Buffer[3]);
    Ramecek(12,I*50,212,I*50+48,Graphics.FontColor,Buffer[3]);
    WriteText(15,I*50+3,'Pozice',Buffer[3]);
    WriteNumber(55,I*50+4,I+1,False,Buffer[3]);

    For N:=1 to 4 do
    Begin
      If Save.Slot[I].Player[N].Job>0 then
      Begin
        If Save.Slot[I].Player[N].HP>0
        then WriteSprite(30+N*35,I*50+10,(Save.Slot[I].Player[N].Job-1)*20,148,(Save.Slot[I].Player[N].Job-1)*20+19,179,
        Buffer[1],Buffer[3])
        else WriteSprite(30+N*35,I*50+26,128,(Save.Slot[I].Player[N].Job-1)*16,
        159,(Save.Slot[I].Player[N].Job-1)*16+15,Buffer[1],Buffer[3]);
      End;
    End;
  End;

  WriteSipka(2,(VolbaMenu-1)*50+22);
  ShowFPS(10,180);
  If Graphics.vSync=True then WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure SaveLoad(Mode: Byte); {Mode1=Save Mode2=Load}
Var
  Ending: Boolean;
  Volba: Byte;
  I,N: Byte;
  WritedBajt: Byte;
Begin
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  Volba:=1;
  FindFirst('panter.sav',Archive,DirInfo);
  Case DosError Of
  0: Begin {OK -> Load info}
       Assign(F,'panter.sav');
       Reset(F,1);
       ZalohujStav;
       For I:=0 to 3 do
       Begin
         LoadFromSlot(I+1);
         ZapisInfo(I);
       End;
       ObnovStav;
       Close(F);
     End;
 18: Begin {Not found -> Create new}
       Assign(F,'panter.sav');
       ReWrite(F,1);
       ZalohujStav;
       SetEmpty;
       For I:=0 to 3 do WriteToSlot(I+1);
       ObnovStav;
       Close(F);
     End;
  End; {Case End}

  {Start Loop}
  Repeat
    Stopky_Start;
    WriteSaveLoadScreen(Volba,Mode);
    Waitmenu(fps.prodlevamenu);
    Stopky_Stop;
    FPSTrigg;
{Up}    If Key[Ovladani.KeyUp]=True then
        Begin
          While Key[Ovladani.KeyUp]=True do WaitButton(Ovladani.KeyUp);
          If Volba>1 then Dec(Volba) else Volba:=1;
        End;
{Down}  If Key[Ovladani.KeyDown]=True then
        Begin
          While Key[Ovladani.KeyDown]=True do WaitButton(Ovladani.KeyDown);
          If Volba<4 then Inc(Volba) else Volba:=4;
        End;
{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
          Case Mode Of
            1: Begin {SAVE MODE}
                 Assign(F,'panter.sav');
                 Reset(F,1);
                 WriteWaitScreen;
                 WriteToSlot(Volba);
                 Close(F);
               End;
            2: Begin {LOAD MODE}
                 If Save.Slot[Volba-1].Player[1].Job>0 then
                 Begin
                   Assign(F,'panter.sav');
                   Reset(F,1);
                   WriteWaitScreen;
                   LoadFromSlot(Volba);
                   Close(F);
                   StartGame:=True;
                 End;
               End;
          End; {Case End}
          Ending:=True;
        End;
{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          While Key[Ovladani.KeyBack]=True do WaitButton(Ovladani.KeyBack);
          Ending:=True;
        End;
  Until Ending=True;
End;
