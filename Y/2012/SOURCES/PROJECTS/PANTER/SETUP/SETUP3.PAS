Procedure WriteSetupOstatniScreen(X,Y: Word; VolbaMenu: Byte);
Begin
  Blok(X,Y,X+166,Y+35,Graphics.WindowsColor,Buffer[3]);
  Ramecek(X,Y,X+166,Y+35,Graphics.FontColor,Buffer[3]);
  WriteSipka(X+4,Y+(VolbaMenu-1)*10+4);
  WriteText(X+15,Y+3,'vSync =',Buffer[3]);
  If Graphics.vSync=True then WriteText(X+62,Y+3,'zapnuto',Buffer[3])
                         else WriteText(X+62,Y+3,'vypnuto',Buffer[3]);
  WriteText(X+15,Y+14,'FPS limit =',Buffer[3]);
  If Graphics.vSync=False then WriteNumber(X+81,Y+15,fps.limit,False,Buffer[3])
                          else WriteText(X+81,Y+14,'freq.monitoru',Buffer[3]);
  WriteText(X+15,Y+24,'zobrazovat FPS =',Buffer[3]);
  If fps.zobrazovat=True then WriteText(X+118,Y+24,'zapnuto',Buffer[3])
                         else WriteText(X+118,Y+24,'vypnuto',Buffer[3]);
End;


Procedure SetupOstatni;
Var
  Ending: Boolean;
  Volba: Byte;
Begin
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  Volba:=1;
  Blok(3,3,12,31,Graphics.WindowsColor,Buffer[3]);
  Repeat
    Stopky_Start;
    If Graphics.vSync=True then WaitRetrace;
    WriteSetupOstatniScreen(69,125,Volba);
    ShowFPS(10,180);
    FlipPage(Buffer[3],Buffer[4]);
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
          If Volba<3 then Inc(Volba) else Volba:=3;
        End;
{Left}  If Key[Ovladani.KeyLeft]=True then
        Begin
          While Key[Ovladani.KeyLeft]=True do WaitButton(Ovladani.KeyLeft);
          Case Volba of
            1: Begin
                 Graphics.vSync:=False;
                 fps.prodleva:=1000 div fps.limit;
                 fps.prodlevamenu:=1000 div fps.limit;
                 fps.trvaniTarget:=fps.prodleva;
               End;
            2: Begin
                 If Graphics.vSync=False then
                 Begin
                   If fps.limit>15 then Begin
                                          Dec(fps.limit);
                                          fps.prodleva:=1000 div fps.limit;
                                          fps.prodlevamenu:=1000 div fps.limit;
                                          fps.trvaniTarget:=fps.prodleva;
                                        End;
                 End;
               End;
            3: Begin
                 fps.zobrazovat:=False;
                 Blok(10,180,39,189,Graphics.BlackColor,Buffer[3]);
               End;
          End; {Case End}
        End;
{Right} If Key[Ovladani.KeyRight]=True then
        Begin
          While Key[Ovladani.KeyRight]=True do WaitButton(Ovladani.KeyRight);
          Case Volba Of
            1: Begin
                 Graphics.vSync:=True;
                 fps.prodleva:=0;
                 fps.prodlevamenu:=0;
               End;
            2: Begin
                 If Graphics.vSync=False then
                 Begin
                   If fps.limit<60 then Begin
                                           Inc(fps.limit);
                                           fps.prodleva:=1000 div fps.limit;
                                           fps.prodlevamenu:=1000 div fps.limit;
                                           fps.trvaniTarget:=fps.prodleva;
                                        End;
                 End;
               End;
            3: Begin
                 fps.zobrazovat:=True;
               End;
          End; {Case End}
        End;
{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
          If Volba=1 then
          If Graphics.vSync=True then Graphics.vSync:=False
                                 else Graphics.vSync:=True;
          If Volba=3 then
          If fps.zobrazovat=False then fps.zobrazovat:=True
                                  else Begin
                                         Blok(10,180,39,189,Graphics.BlackColor,Buffer[3]);
                                         fps.zobrazovat:=False;
                                       End;
        End;
{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          While Key[Ovladani.KeyBack]=True do WaitButton(Ovladani.KeyBack);
          Ending:=True;
        End;
  Until Ending=True;
End;
