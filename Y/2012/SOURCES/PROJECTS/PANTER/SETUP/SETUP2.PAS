Procedure WriteSetupBarvyScreen(X,Y: Word; VolbaRGB: Byte);
Var I,n: Byte;
Begin
  Blok(X,Y,X+96,Y+70,Graphics.WindowsColor,Buffer[3]);
  Ramecek(X,Y,X+96,Y+70,Graphics.FontColor,Buffer[3]);

  WriteSipka(X+4,Y+(VolbaRGB-1)*10+6);
  WriteText(X+15,Y+5,'R',Buffer[3]);
  WriteText(X+15,Y+15,'G',Buffer[3]);
  WriteText(X+15,Y+25,'B',Buffer[3]);
  WriteText(X+15,Y+35,'R',Buffer[3]);
  WriteText(X+15,Y+45,'G',Buffer[3]);
  WriteText(X+15,Y+55,'B',Buffer[3]);
  For n:=0 to 5 do
  For I:=0 to 63 do WritePixel(X+23+I,Y+n*10+9,Graphics.FontColor,Buffer[3]);
  WriteKurzor(X+23+Graphics.FontColorR,Y+6);
  WriteKurzor(X+23+Graphics.FontColorG,Y+16);
  WriteKurzor(X+23+Graphics.FontColorB,Y+26);
  WriteKurzor(X+23+Graphics.WindowsColorR,Y+36);
  WriteKurzor(X+23+Graphics.WindowsColorG,Y+46);
  WriteKurzor(X+23+Graphics.WindowsColorB,Y+56);
End;


Procedure SetupBarvy;
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
    WriteSetupBarvyScreen(195,40,Volba);
    ShowFPS(10,180);
    FlipPage(Buffer[3],Buffer[4]);
    WaitMenu(fps.prodlevamenu);
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
          If Volba<6 then Inc(Volba) else Volba:=6;
        End;
{Left}  If Key[Ovladani.KeyLeft]=True then
        Begin
          While Key[Ovladani.KeyLeft]=True do WaitButton(Ovladani.KeyLeft);
          Case Volba of
            1: Begin
                 If Graphics.FontColorR>0 then Dec(Graphics.FontColorR);
                 SetPal(Graphics.FontColor,Graphics.FontColorR,Graphics.FontColorG,Graphics.FontColorB);
               End;
            2: Begin
                 If Graphics.FontColorG>0 then Dec(Graphics.FontColorG);
                 SetPal(Graphics.FontColor,Graphics.FontColorR,Graphics.FontColorG,Graphics.FontColorB);
               End;
            3: Begin
                 If Graphics.FontColorB>0 then Dec(Graphics.FontColorB);
                 SetPal(Graphics.FontColor,Graphics.FontColorR,Graphics.FontColorG,Graphics.FontColorB);
               End;
            4: Begin
                 If Graphics.WindowsColorR>0 then Dec(Graphics.WindowsColorR);
                 SetPal(Graphics.WindowsColor,Graphics.WindowsColorR,Graphics.WindowsColorG,Graphics.WindowsColorB);
               End;
            5: Begin
                 If Graphics.WindowsColorG>0 then Dec(Graphics.WindowsColorG);
                 SetPal(Graphics.WindowsColor,Graphics.WindowsColorR,Graphics.WindowsColorG,Graphics.WindowsColorB);
               End;
            6: Begin
                 If Graphics.WindowsColorB>0 then Dec(Graphics.WindowsColorB);
                 SetPal(Graphics.WindowsColor,Graphics.WindowsColorR,Graphics.WindowsColorG,Graphics.WindowsColorB);
               End;
          End; {Case End}
        End;
{Right} If Key[Ovladani.KeyRight]=True then
        Begin
          While Key[Ovladani.KeyRight]=True do WaitButton(Ovladani.KeyRight);
          Case Volba of
            1: Begin
                 If Graphics.FontColorR<63 then Inc(Graphics.FontColorR);
                 SetPal(Graphics.FontColor,Graphics.FontColorR,Graphics.FontColorG,Graphics.FontColorB);
               End;
            2: Begin
                 If Graphics.FontColorG<63 then Inc(Graphics.FontColorG);
                 SetPal(Graphics.FontColor,Graphics.FontColorR,Graphics.FontColorG,Graphics.FontColorB);
               End;
            3: Begin
                 If Graphics.FontColorB<63 then Inc(Graphics.FontColorB);
                 SetPal(Graphics.FontColor,Graphics.FontColorR,Graphics.FontColorG,Graphics.FontColorB);
               End;
            4: Begin
                 If Graphics.WindowsColorR<63 then Inc(Graphics.WindowsColorR);
                 SetPal(Graphics.WindowsColor,Graphics.WindowsColorR,Graphics.WindowsColorG,Graphics.WindowsColorB);
               End;
            5: Begin
                 If Graphics.WindowsColorG<63 then Inc(Graphics.WindowsColorG);
                 SetPal(Graphics.WindowsColor,Graphics.WindowsColorR,Graphics.WindowsColorG,Graphics.WindowsColorB);
               End;
            6: Begin
                 If Graphics.WindowsColorB<63 then Inc(Graphics.WindowsColorB);
                 SetPal(Graphics.WindowsColor,Graphics.WindowsColorR,Graphics.WindowsColorG,Graphics.WindowsColorB);
               End;
          End; {Case End}
        End;
{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          While Key[Ovladani.KeyBack]=True do WaitButton(Ovladani.KeyBack);
          Ending:=True;
        End;
  Until Ending=True;
End;
