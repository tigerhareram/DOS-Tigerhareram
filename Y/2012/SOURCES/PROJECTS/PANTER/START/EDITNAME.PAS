Function VratZnak(CisloZnaku: Byte): Char;
Begin
  Case CisloZnaku of
    0: VratZnak:='A';
    1: VratZnak:='B';
    2: VratZnak:='C';
    3: VratZnak:='D';
    4: VratZnak:='E';
    5: VratZnak:='F';
    6: VratZnak:='G';
    7: VratZnak:='H';
    8: VratZnak:='I';
    9: VratZnak:='J';

   10: VratZnak:='K';
   11: VratZnak:='L';
   12: VratZnak:='M';
   13: VratZnak:='N';
   14: VratZnak:='O';
   15: VratZnak:='P';
   16: VratZnak:='Q';
   17: VratZnak:='R';
   18: VratZnak:='S';
   19: VratZnak:='T';

   20: VratZnak:='U';
   21: VratZnak:='V';
   22: VratZnak:='W';
   23: VratZnak:='X';
   24: VratZnak:='Y';
   25: VratZnak:='Z';
   26: VratZnak:='a';
   27: VratZnak:='b';
   28: VratZnak:='c';
   29: VratZnak:='d';

   30: VratZnak:='e';
   31: VratZnak:='f';
   32: VratZnak:='g';
   33: VratZnak:='h';
   34: VratZnak:='i';
   35: VratZnak:='j';
   36: VratZnak:='k';
   37: VratZnak:='l';
   38: VratZnak:='m';
   39: VratZnak:='n';

   40: VratZnak:='o';
   41: VratZnak:='p';
   42: VratZnak:='q';
   43: VratZnak:='r';
   44: VratZnak:='s';
   45: VratZnak:='t';
   46: VratZnak:='u';
   47: VratZnak:='v';
   48: VratZnak:='w';
   49: VratZnak:='x';

   50: VratZnak:='y';
   51: VratZnak:='z';
   52: VratZnak:=' ';
   53: VratZnak:='‚';
   54: VratZnak:='¡';
   55: VratZnak:='¢';
   56: VratZnak:='£';
   57: VratZnak:='…';
   58: VratZnak:='ì';
   59: VratZnak:='Ÿ';

   60: VratZnak:='Ø';
   61: VratZnak:='å';
   62: VratZnak:='ý';
   63: VratZnak:='ç';
   64: VratZnak:='§';
   65: VratZnak:='-';
   66: VratZnak:='0';
   67: VratZnak:='2';
   68: VratZnak:='4';
   69: VratZnak:='6';

   70: VratZnak:='8';
   71: VratZnak:=' ';
   72: VratZnak:='1';
   73: VratZnak:='3';
   74: VratZnak:='5';
   75: VratZnak:='7';
   76: VratZnak:='9';
  End; {Case End}
End;


Procedure WriteNameScreen(X,Y,CisloPlayera: Byte);
Var Xa,Ya,Cislo: Word;
Begin
  Blok(184,0,315,198,Graphics.WindowsColor,Buffer[3]);
  Ramecek(188,4,311,19,Graphics.FontColor,Buffer[3]);
  WriteNumber(300,6,12-Length(Player[CisloPlayera].Jmeno),True,Buffer[3]);
  WriteText(192,8,Player[CisloPlayera].Jmeno,Buffer[3]);
  For Ya:=0 to 12 do
  For Xa:=0 to 5 do
  Begin
    Blok(185+Xa*20,20+Ya*13,185+Xa*20+19,20+Ya*13+12,Graphics.WindowsColor,Buffer[3]);
    Cislo:=Ya*6+Xa;
    Case Cislo of
     0: WriteText(196+Xa*20,22+Ya*13,'A',Buffer[3]);
     1: WriteText(196+Xa*20,22+Ya*13,'B',Buffer[3]);
     2: WriteText(196+Xa*20,22+Ya*13,'C',Buffer[3]);
     3: WriteText(196+Xa*20,22+Ya*13,'D',Buffer[3]);
     4: WriteText(196+Xa*20,22+Ya*13,'E',Buffer[3]);
     5: WriteText(196+Xa*20,22+Ya*13,'F',Buffer[3]);
     6: WriteText(196+Xa*20,22+Ya*13,'G',Buffer[3]);
     7: WriteText(196+Xa*20,22+Ya*13,'H',Buffer[3]);
     8: WriteText(196+Xa*20,22+Ya*13,'I',Buffer[3]);
     9: WriteText(196+Xa*20,22+Ya*13,'J',Buffer[3]);

    10: WriteText(196+Xa*20,22+Ya*13,'K',Buffer[3]);
    11: WriteText(196+Xa*20,22+Ya*13,'L',Buffer[3]);
    12: WriteText(196+Xa*20,22+Ya*13,'M',Buffer[3]);
    13: WriteText(196+Xa*20,22+Ya*13,'N',Buffer[3]);
    14: WriteText(196+Xa*20,22+Ya*13,'O',Buffer[3]);
    15: WriteText(196+Xa*20,22+Ya*13,'P',Buffer[3]);
    16: WriteText(196+Xa*20,22+Ya*13,'Q',Buffer[3]);
    17: WriteText(196+Xa*20,22+Ya*13,'R',Buffer[3]);
    18: WriteText(196+Xa*20,22+Ya*13,'S',Buffer[3]);
    19: WriteText(196+Xa*20,22+Ya*13,'T',Buffer[3]);

    20: WriteText(196+Xa*20,22+Ya*13,'U',Buffer[3]);
    21: WriteText(196+Xa*20,22+Ya*13,'V',Buffer[3]);
    22: WriteText(196+Xa*20,22+Ya*13,'W',Buffer[3]);
    23: WriteText(196+Xa*20,22+Ya*13,'X',Buffer[3]);
    24: WriteText(196+Xa*20,22+Ya*13,'Y',Buffer[3]);
    25: WriteText(196+Xa*20,22+Ya*13,'Z',Buffer[3]);
    26: WriteText(196+Xa*20,22+Ya*13,'a',Buffer[3]);
    27: WriteText(196+Xa*20,22+Ya*13,'b',Buffer[3]);
    28: WriteText(196+Xa*20,22+Ya*13,'c',Buffer[3]);
    29: WriteText(196+Xa*20,22+Ya*13,'d',Buffer[3]);

    30: WriteText(196+Xa*20,22+Ya*13,'e',Buffer[3]);
    31: WriteText(196+Xa*20,22+Ya*13,'f',Buffer[3]);
    32: WriteText(196+Xa*20,22+Ya*13,'g',Buffer[3]);
    33: WriteText(196+Xa*20,22+Ya*13,'h',Buffer[3]);
    34: WriteText(196+Xa*20,22+Ya*13,'i',Buffer[3]);
    35: WriteText(196+Xa*20,22+Ya*13,'j',Buffer[3]);
    36: WriteText(196+Xa*20,22+Ya*13,'k',Buffer[3]);
    37: WriteText(196+Xa*20,22+Ya*13,'l',Buffer[3]);
    38: WriteText(196+Xa*20,22+Ya*13,'m',Buffer[3]);
    39: WriteText(196+Xa*20,22+Ya*13,'n',Buffer[3]);

    40: WriteText(196+Xa*20,22+Ya*13,'o',Buffer[3]);
    41: WriteText(196+Xa*20,22+Ya*13,'p',Buffer[3]);
    42: WriteText(196+Xa*20,22+Ya*13,'q',Buffer[3]);
    43: WriteText(196+Xa*20,22+Ya*13,'r',Buffer[3]);
    44: WriteText(196+Xa*20,22+Ya*13,'s',Buffer[3]);
    45: WriteText(196+Xa*20,22+Ya*13,'t',Buffer[3]);
    46: WriteText(196+Xa*20,22+Ya*13,'u',Buffer[3]);
    47: WriteText(196+Xa*20,22+Ya*13,'v',Buffer[3]);
    48: WriteText(196+Xa*20,22+Ya*13,'w',Buffer[3]);
    49: WriteText(196+Xa*20,22+Ya*13,'x',Buffer[3]);

    50: WriteText(196+Xa*20,22+Ya*13,'y',Buffer[3]);
    51: WriteText(196+Xa*20,22+Ya*13,'z',Buffer[3]);
    52: WriteText(196+Xa*20,22+Ya*13,' ',Buffer[3]);
    53: WriteText(196+Xa*20,22+Ya*13,'‚',Buffer[3]);
    54: WriteText(196+Xa*20,22+Ya*13,'¡',Buffer[3]);
    55: WriteText(196+Xa*20,22+Ya*13,'¢',Buffer[3]);
    56: WriteText(196+Xa*20,22+Ya*13,'£',Buffer[3]);
    57: WriteText(196+Xa*20,22+Ya*13,'…',Buffer[3]);
    58: WriteText(196+Xa*20,22+Ya*13,'ì',Buffer[3]);
    59: WriteText(196+Xa*20,22+Ya*13,'Ÿ',Buffer[3]);

    60: WriteText(196+Xa*20,22+Ya*13,'Ø',Buffer[3]);
    61: WriteText(196+Xa*20,22+Ya*13,'å',Buffer[3]);
    62: WriteText(196+Xa*20,22+Ya*13,'ý',Buffer[3]);
    63: WriteText(196+Xa*20,22+Ya*13,'ç',Buffer[3]);
    64: WriteText(196+Xa*20,22+Ya*13,'§',Buffer[3]);
    65: WriteText(196+Xa*20,22+Ya*13,'-',Buffer[3]);
    66: WriteText(196+Xa*20,22+Ya*13,'0',Buffer[3]);
    67: WriteText(196+Xa*20,22+Ya*13,'2',Buffer[3]);
    68: WriteText(196+Xa*20,22+Ya*13,'4',Buffer[3]);
    69: WriteText(196+Xa*20,22+Ya*13,'6',Buffer[3]);

    70: WriteText(196+Xa*20,22+Ya*13,'8',Buffer[3]);
    71: WriteText(196+Xa*20,22+Ya*13,' ',Buffer[3]);
    72: WriteText(196+Xa*20,22+Ya*13,'1',Buffer[3]);
    73: WriteText(196+Xa*20,22+Ya*13,'3',Buffer[3]);
    74: WriteText(196+Xa*20,22+Ya*13,'5',Buffer[3]);
    75: WriteText(196+Xa*20,22+Ya*13,'7',Buffer[3]);
    76: WriteText(196+Xa*20,22+Ya*13,'9',Buffer[3]);
    77: WriteText(196+Xa*20,22+Ya*13,'OK',Buffer[3]);
    End; {Case End}
  End;

  Ramecek(184,0,315,198,Graphics.FontColor,Buffer[3]);
  WriteSipka(187+X*20,23+Y*13);

  ShowFPS(10,180);
  If Graphics.vSync=True then WaitRetrace;
  FlipPage(Buffer[3],Buffer[4]);
End;


Function EditPlayerName(Number: Byte): String;
Var
  Ending: Boolean;
  X,Y: Byte;
Begin
  Ending:=False;
  Graphics.ShowMenu:=True;
  Graphics.ShowGame:=False;
  X:=0; Y:=0;
  Blok(47,(Number-1)*50+13,55,(Number-1)*50+33,Graphics.WindowsColor,Buffer[3]);
  Blok(96,(Number-1)*50+12,180,(Number-1)*50+22,Graphics.WindowsColor,Buffer[3]);
  Repeat
    Stopky_Start;
    WriteNameScreen(X,Y,Number);
    WaitMenu(fps.prodlevamenu);
    Stopky_Stop;
    FPSTrigg;
{Up}    If Key[Ovladani.KeyUp]=True then
        Begin
          While Key[Ovladani.KeyUp]=True do WaitButton(Ovladani.KeyUp);
          If Y>0 then Dec(Y) else Y:=12;
        End;
{Down}  If Key[Ovladani.KeyDown]=True then
        Begin
          While Key[Ovladani.KeyDown]=True do WaitButton(Ovladani.KeyDown);
          If Y<12 then Inc(Y) else Y:=0;
        End;
{Left}  If Key[Ovladani.KeyLeft]=True then
        Begin
          While Key[Ovladani.KeyLeft]=True do WaitButton(Ovladani.KeyLeft);
          If X>0 then Dec(X) else X:=5;
        End;
{Right} If Key[Ovladani.KeyRight]=True then
        Begin
          While Key[Ovladani.KeyRight]=True do WaitButton(Ovladani.KeyRight);
          If X<5 then Inc(X) else X:=0;
        End;
{OK}    If Key[Ovladani.KeyOK]=True then
        Begin
          While Key[Ovladani.KeyOK]=True do WaitButton(Ovladani.KeyOK);
          If Y*6+X=77 then Begin {OK}
                             EditPlayerName:=Player[Number].Jmeno;
                             Ending:=True;
                             WaitRelease;
                           End
                      else Begin {write znak}
                             Player[Number].Jmeno:=Player[Number].Jmeno+VratZnak(Y*6+X);
                           End;
        End;
{Back}  If Key[Ovladani.KeyBack]=True then
        Begin
          While Key[Ovladani.KeyBack]=True do WaitButton(Ovladani.KeyBack);
          Delete(Player[Number].Jmeno,Length(Player[Number].Jmeno),1);
        End;
  Until Ending=True;
  Blok(184,0,315,198,Graphics.BlackColor,Buffer[3]);
End;
