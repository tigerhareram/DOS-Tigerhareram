Procedure SetupKlavesa(OvladaniButton: Byte);
Var
  X,Y: Word;
  Klavesa: Byte;
  ReadPort: Byte;
Begin
  X:=195; Y:=0;
  Blok(X,Y+16,X+102,Y+27,Graphics.BlackColor,Buffer[3]);
  Blok(X,Y,X+98,Y+11,Graphics.WindowsColor,Buffer[3]);
  Ramecek(X,Y,X+98,Y+11,Graphics.FontColor,Buffer[3]);
  WriteText(X+2,Y+2,'Stisknÿte kl†vesu',Buffer[3]);
  If Graphics.vSync=True then WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
  WaitKey;
  Klavesa:=InPortB($60);
  If (Klavesa in [1..42]) or
     (Klavesa in [44..83]) or
     (Klavesa in [87..88]) then
  Begin
    If (Ovladani.KeyUp<>Klavesa) and
    (Ovladani.KeyDown<>Klavesa) and
    (Ovladani.KeyLeft<>Klavesa) and
    (Ovladani.KeyRight<>Klavesa) and
    (Ovladani.KeyOK<>Klavesa) and
    (Ovladani.KeyBack<>Klavesa) then
    Begin
      Case OvladaniButton of
        1: Begin Ovladani.KeyUp:=Klavesa; WaitRelease; End;
        2: Begin Ovladani.KeyDown:=Klavesa; WaitRelease; End;
        3: Begin Ovladani.KeyLeft:=Klavesa; WaitRelease; End;
        4: Begin Ovladani.KeyRight:=Klavesa; WaitRelease; End;
        5: Begin Ovladani.KeyOK:=Klavesa; WaitRelease; End;
        6: Begin Ovladani.KeyBack:=Klavesa; WaitRelease; End;
    End; {Case End}
    End else
    Begin {Klavesa je uz pouzita}
      Blok(X,Y,X+98,Y+11,Graphics.BlackColor,Buffer[3]);
      Blok(X,Y+16,X+102,Y+27,Graphics.ButtonColor,Buffer[3]);
      Ramecek(X,Y+16,X+102,Y+27,Graphics.FontColor,Buffer[3]);
      WriteText(X+2,Y+18,'Duplicitn° kl†vesa',Buffer[3]);
      If Graphics.vSync=True then WaitRetrace;
      FlipPage(Buffer[3],Buffer[4]);
    End;
  End else
  Begin {Nepodporovana klavesa}
    Blok(X,Y,X+98,Y+11,Graphics.BlackColor,Buffer[3]);
    Blok(X,Y+16,X+94,Y+27,Graphics.ButtonColor,Buffer[3]);
    Ramecek(X,Y+16,X+94,Y+27,Graphics.FontColor,Buffer[3]);
    WriteText(X+2,Y+18,'Nezn†m† kl†vesa',Buffer[3]);
    If Graphics.vSync=True then WaitRetrace;
    FlipPage(Buffer[3],Buffer[4]);
  End;
  While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
  Blok(X,Y,X+99,Y+11,Graphics.BlackColor,Buffer[3]);
  If Graphics.vSync=True then WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Procedure WriteKey(X,Y: Word; Klavesa: Byte);
Begin
  Case Klavesa of
{Esc}               1: WriteText(X,Y,'Esc',Buffer[3]);
{1}                 2: WriteText(X,Y,'1',Buffer[3]);
{2}                 3: WriteText(X,Y,'2',Buffer[3]);
{3}                 4: WriteText(X,Y,'3',Buffer[3]);
{4}                 5: WriteText(X,Y,'4',Buffer[3]);
{5}                 6: WriteText(X,Y,'5',Buffer[3]);
{6}                 7: WriteText(X,Y,'6',Buffer[3]);
{7}                 8: WriteText(X,Y,'7',Buffer[3]);
{8}                 9: WriteText(X,Y,'8',Buffer[3]);
{9}                10: WriteText(X,Y,'9',Buffer[3]);
{0}                11: WriteText(X,Y,'0',Buffer[3]);
{Minus}            12: WriteText(X,Y,'m°nus',Buffer[3]);
{Plus}             13: WriteText(X,Y,'plus',Buffer[3]);
{BackSpace}        14: WriteText(X,Y,'backspace',Buffer[3]);
{TAB}              15: WriteText(X,Y,'TAB',Buffer[3]);
{Q}                16: WriteText(X,Y,'Q',Buffer[3]);
{W}                17: WriteText(X,Y,'W',Buffer[3]);
{E}                18: WriteText(X,Y,'E',Buffer[3]);
{R}                19: WriteText(X,Y,'R',Buffer[3]);
{T}                20: WriteText(X,Y,'T',Buffer[3]);
{Y}                21: WriteText(X,Y,'Y',Buffer[3]);
{U}                22: WriteText(X,Y,'U',Buffer[3]);
{I}                23: WriteText(X,Y,'I',Buffer[3]);
{O}                24: WriteText(X,Y,'O',Buffer[3]);
{P}                25: WriteText(X,Y,'P',Buffer[3]);
{HranataZavorka1}  26: WriteText(X,Y,'<',Buffer[3]);
{HranataZavorka2}  27: WriteText(X,Y,'>',Buffer[3]);
{Enter}            28: WriteText(X,Y,'Enter',Buffer[3]);
{LeftControl}      29: WriteText(X,Y,'L-CTRL',Buffer[3]);
{A}                30: WriteText(X,Y,'A',Buffer[3]);
{S}                31: WriteText(X,Y,'S',Buffer[3]);
{D}                32: WriteText(X,Y,'D',Buffer[3]);
{F}                33: WriteText(X,Y,'F',Buffer[3]);
{G}                34: WriteText(X,Y,'G',Buffer[3]);
{H}                35: WriteText(X,Y,'H',Buffer[3]);
{J}                36: WriteText(X,Y,'J',Buffer[3]);
{K}                37: WriteText(X,Y,'K',Buffer[3]);
{L}                38: WriteText(X,Y,'L',Buffer[3]);
{Strednik}         39: WriteText(X,Y,'st˝edn°k',Buffer[3]);
{Uvozovka}         40: WriteText(X,Y,'£vozovka',Buffer[3]);
{Semicolon}        41: WriteText(X,Y,'semicolon',Buffer[3]);
{LeftShift}        42: WriteText(X,Y,'L-Shift',Buffer[3]);
{Z}                44: WriteText(X,Y,'Z',Buffer[3]);
{X}                45: WriteText(X,Y,'X',Buffer[3]);
{C}                46: WriteText(X,Y,'C',Buffer[3]);
{V}                47: WriteText(X,Y,'V',Buffer[3]);
{B}                48: WriteText(X,Y,'B',Buffer[3]);
{N}                49: WriteText(X,Y,'N',Buffer[3]);
{M}                50: WriteText(X,Y,'M',Buffer[3]);
{Carka}            51: WriteText(X,Y,',',Buffer[3]);
{Tecka}            52: WriteText(X,Y,'.',Buffer[3]);
{Lomitko}          53: WriteText(X,Y,'/',Buffer[3]);
{RightShift}       54: WriteText(X,Y,'R-Shift',Buffer[3]);
{Hvezdicka}        55: WriteText(X,Y,'hvÿzdiüka',Buffer[3]);
{LeftAlt}          56: WriteText(X,Y,'L-Alt',Buffer[3]);
{Space}            57: WriteText(X,Y,'mezern°k',Buffer[3]);
{CapsLock}         58: WriteText(X,Y,'CapsLock',Buffer[3]);
{F1}               59: WriteText(X,Y,'F1',Buffer[3]);
{F2}               60: WriteText(X,Y,'F2',Buffer[3]);
{F3}               61: WriteText(X,Y,'F3',Buffer[3]);
{F4}               62: WriteText(X,Y,'F4',Buffer[3]);
{F5}               63: WriteText(X,Y,'F5',Buffer[3]);
{F6}               64: WriteText(X,Y,'F6',Buffer[3]);
{F7}               65: WriteText(X,Y,'F7',Buffer[3]);
{F8}               66: WriteText(X,Y,'F8',Buffer[3]);
{F9}               67: WriteText(X,Y,'F9',Buffer[3]);
{F10}              68: WriteText(X,Y,'F10',Buffer[3]);
{NumLock}          69: WriteText(X,Y,'NumLock',Buffer[3]);
{ScrollLock}       70: WriteText(X,Y,'ScrollLock',Buffer[3]);
{KeyPadHome}       71: WriteText(X,Y,'Keypad-Home',Buffer[3]);
{KeyPadUp}         72: WriteText(X,Y,'Áipka nahoru',Buffer[3]);
{KeyPadPgUp}       73: WriteText(X,Y,'Keypad-PageUp',Buffer[3]);
{KeyPadMinus}      74: WriteText(X,Y,'Keypad-M°nus',Buffer[3]);
{KeyPadLeft}       75: WriteText(X,Y,'Áipka doleva',Buffer[3]);
{KeyPad5}          76: WriteText(X,Y,'Keypad-5',Buffer[3]);
{KeyPadRight}      77: WriteText(X,Y,'Áipka doprava',Buffer[3]);
{KeyPadPlus}       78: WriteText(X,Y,'Keypad-Plus',Buffer[3]);
{KeyPadEnd}        79: WriteText(X,Y,'Keypad-End',Buffer[3]);
{KeyPadDown}       80: WriteText(X,Y,'Áipka dolÖ',Buffer[3]);
{KeyPadPgDn}       81: WriteText(X,Y,'Keypad-PageDown',Buffer[3]);
{KeyPadIns}        82: WriteText(X,Y,'Keypad-Ins',Buffer[3]);
{KeyPadDel}        83: WriteText(X,Y,'Keypad-Del',Buffer[3]);
{F11}              87: WriteText(X,Y,'F11',Buffer[3]);
{F12}              88: WriteText(X,Y,'F12',Buffer[3]);
  End; {Case End}
End;


Procedure WriteSetupOvladaniScreen(X,Y:Word; VolbaMenu: Byte);
Var I: Byte;
Begin
  Blok(X,Y,X+120,Y+120,Graphics.WindowsColor,Buffer[3]);
  Ramecek(X,Y,X+120,Y+120,Graphics.FontColor,Buffer[3]);
  WriteSipka(X+3,Y+(VolbaMenu-1)*20+6);
  For I:=0 to 3 do
  Begin
    Blok(X+13,Y+4+I*20,X+24,Y+15+I*20,Graphics.ButtonColor,Buffer[3]);
    Ramecek(X+13,Y+4+I*20,X+24,Y+15+I*20,Graphics.FontColor,Buffer[3]);
    Case I of
      0: WriteSprite(X+15,Y+6+I*20,128,192,135,199,Buffer[1],Buffer[3]);
      1: WriteSprite(X+15,Y+6+I*20,136,192,143,199,Buffer[1],Buffer[3]);
      2: WriteSprite(X+15,Y+6+I*20,144,192,151,199,Buffer[1],Buffer[3]);
      3: WriteSprite(X+15,Y+6+I*20,152,192,159,199,Buffer[1],Buffer[3]);
    End; {Case End}
    WriteText(X+27,Y+6+I*20,'=',Buffer[3]);
  End;
  Blok(X+13,Y+84,X+27,Y+94,Graphics.ButtonColor,Buffer[3]);
  Ramecek(X+13,Y+84,X+27,Y+94,Graphics.FontColor,Buffer[3]);
  WriteText(X+15,Y+85,'OK',Buffer[3]);
  WriteText(X+30,Y+85,'=',Buffer[3]);
  Blok(X+13,Y+102,X+39,Y+115,Graphics.ButtonColor,Buffer[3]);
  Ramecek(X+13,Y+102,X+39,Y+115,Graphics.FontColor,Buffer[3]);
  WriteText(X+15,Y+104,'Zpÿt',Buffer[3]);
  WriteText(X+42,Y+104,'=',Buffer[3]);

  WriteKey(X+35,Y+5,Ovladani.KeyUp);
  WriteKey(X+35,Y+25,Ovladani.KeyDown);
  WriteKey(X+35,Y+45,Ovladani.KeyLeft);
  WriteKey(X+35,Y+65,Ovladani.KeyRight);
  WriteKey(X+38,Y+85,Ovladani.KeyOK);
  WriteKey(X+50,Y+104,Ovladani.KeyBack);

End;


Procedure SetupOvladani;
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
    WriteSetupOvladaniScreen(69,0,Volba);
    ShowFPS(10,180);
    FlipPage(Buffer[3],Buffer[4]);
    Waitmenu(fps.prodlevamenu);
    Stopky_Stop;
    FPSTrigg;
{Up}    If Key[Ovladani.KeyUp]=True then
        Begin
          While Key[Ovladani.KeyUp]=True do WaitButton(Ovladani.KeyUp);
          If Volba>1 then Dec(Volba) else Volba:=1;
          Blok(195,16,297,27,Graphics.BlackColor,Buffer[3]);
        End;
{Down}  If Key[Ovladani.KeyDown]=True then
        Begin
          While Key[Ovladani.KeyDown]=True do WaitButton(Ovladani.KeyDown);
          If Volba<6 then Inc(Volba) else Volba:=6;
          Blok(195,16,297,27,Graphics.BlackColor,Buffer[3]);
        End;
{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
          SetupKlavesa(Volba);
        End;
{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          While Key[Ovladani.KeyBack]=True do WaitButton(Ovladani.KeyBack);
          Ending:=True;
        End;
  Until Ending=True;
End;
