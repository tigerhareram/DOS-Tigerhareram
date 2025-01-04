Procedure Kniha;
Var i:Byte;
    KonecKnihy:Boolean;
Begin
  {Kniha}
  KnihovnaInfoOperate;

  MainMenuSel:=0;
  MainMenuMax:=64;
  FileName:='KNIHOVNA\index.dat';
  FindFirst(FileName , Archive, DirInfo);
  If DosError = 0 then Begin {jiz existuje}
                         Assign(F,FileName);
                         Reset(F,SizeOf(KnihovnaInfo));
                         BlockRead(F,KnihovnaInfo,1);
                         Close(F);
                       End
                  else Begin {je treba vytvorit}
                         Assign(F,FileName);
                         ReWrite(F,SizeOf(KnihovnaInfo));
                         BlockWrite(F,KnihovnaInfo,1);
                         Close(F);
                       End;

{XXXXX MENU KNIHA XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}

  KonecKnihy:=False;
  Repeat
    MainWorldScreen;

    i:=0;
    Repeat
    if i<25 then Begin
                   Inc(i);
                   Timer_Wait(20);
                   If KeyCode<128 then i:=25;
                 End;
    Until i>=25;

{Up}     If ((Key[72]=1) or (Key[23]=1)) then
         Begin
           If Key[72]=1 then Kbd_RPush(72);
           If Key[23]=1 then Kbd_RPush(23);
           If MainMenuSel>0 then Dec(MainMenuSel);
         End;

{Down}   If ((Key[80]=1) or (Key[37]=1)) then
         Begin
           If Key[80]=1 then Kbd_RPush(80);
           If Key[37]=1 then Kbd_RPush(37);
           If MainMenuSel<MainMenuMax then Inc(MainMenuSel);
         End;

{Left}   If ((Key[75]=1) or (Key[36]=1)) then
         Begin
           If Key[75]=1 then Kbd_RPush(75);
           If Key[36]=1 then Kbd_RPush(36);
           If ((MainMenu=15) and (MainMenuSel>=60)) then Dec(MainMenuSel);
           {MainMenu=}
                Begin
                  If MainMenu<>36 then
                  Begin
                    If ((MainMenuMax>20) and not ((MainMenu=15) and (MainMenuSel>=60))) then
                    Begin
                      If MainMenuSel>19 then Dec(MainMenuSel,20);
                    End;
                  End else
                  Begin
                    If MainMenuSel>9 then Dec(MainMenuSel,10);
                  End;
                End;
         End;

{Right}  If ((Key[77]=1) or (Key[38]=1)) then
         Begin
           If Key[77]=1 then Kbd_RPush(77);
           If Key[38]=1 then Kbd_RPush(38);
           If ((MainMenu=15) and ((MainMenuSel>=60) and (MainMenuSel<64))) then Inc(MainMenuSel);
           {MainMenu=}
                Begin
                  If MainMenu<>36 then
                  Begin
                    If MainMenuMax>20 then
                    Begin
                      If MainMenuSel<MainMenuMax-19 then Inc(MainMenuSel,20);
                    End;
                  End else
                  Begin
                    If MainMenuSel<MainMenuMax-9 then Inc(MainMenuSel,10);
                  End;
                End;
         End;


{Enter}  If ((Key[28]=1) or (Key[30]=1)) then
         Begin
           If Key[28]=1 then Kbd_RPush(28);
           If Key[30]=1 then Kbd_RPush(30);
           Case MainMenu of
            15: Begin
                  Case MainMenuSel of
                    0: Begin
                         MainMenu:=16;                             {Sesit 01}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    1: Begin
                         MainMenu:=17;                             {Sesit 02}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    2: Begin
                         MainMenu:=18;                             {Sesit 03}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    3: Begin
                         MainMenu:=19;                             {Sesit 04}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    4: Begin
                         MainMenu:=20;                             {Sesit 05}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    5: Begin
                         MainMenu:=21;                             {Sesit 06}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    6: Begin
                         MainMenu:=22;                             {Sesit 07}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    7: Begin
                         MainMenu:=23;                             {Sesit 08}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    8: Begin
                         MainMenu:=24;                             {Sesit 09}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                    9: Begin
                         MainMenu:=25;                             {Sesit 10}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=5;
                       End;
                   10: Begin
                         MainMenu:=26;                              {Blok 1}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   11: Begin
                         MainMenu:=27;                              {Blok 2}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   12: Begin
                         MainMenu:=28;                              {Blok 3}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   13: Begin
                         MainMenu:=29;                              {Blok 4}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   14: Begin
                         MainMenu:=30;                              {Blok 5}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=59;
                       End;
                   15: Begin
                         MainMenu:=31;                              {Kniha 1}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   16: Begin
                         MainMenu:=32;                              {Kniha 2}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   17: Begin
                         MainMenu:=33;                              {Kniha 3}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   18: Begin
                         MainMenu:=34;                              {Kniha 4}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   19: Begin
                         MainMenu:=35;                              {Kniha 5}
                         MainMenuSelSave3:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=299;
                       End;
                   20: Begin
                         ZadaniJmena(0,0);
                       End;
                   21: Begin
                         ZadaniJmena(1,0);
                       End;
                   22: Begin
                         ZadaniJmena(2,0);
                       End;
                   23: Begin
                         ZadaniJmena(3,0);
                       End;
                   24: Begin
                         ZadaniJmena(4,0);
                       End;
                   25: Begin
                         ZadaniJmena(5,0);
                       End;
                   26: Begin
                         ZadaniJmena(6,0);
                       End;
                   27: Begin
                         ZadaniJmena(7,0);
                       End;
                   28: Begin
                         ZadaniJmena(8,0);
                       End;
                   29: Begin
                         ZadaniJmena(9,0);
                       End;
                   30: Begin
                         ZadaniJmena(10,20);
                       End;
                   31: Begin
                         ZadaniJmena(11,20);
                       End;
                   32: Begin
                         ZadaniJmena(12,20);
                       End;
                   33: Begin
                         ZadaniJmena(13,20);
                       End;
                   34: Begin
                         ZadaniJmena(14,20);
                       End;
                   35: Begin
                         ZadaniJmena(15,40);
                       End;
                   36: Begin
                         ZadaniJmena(16,40);
                       End;
                   37: Begin
                         ZadaniJmena(17,40);
                       End;
                   38: Begin
                         ZadaniJmena(18,40);
                       End;
                   39: Begin
                         ZadaniJmena(19,40);
                       End;
                   40: Begin
                         PrecistZKnihovny(0);
                       End;
                   41: Begin
                         PrecistZKnihovny(1);
                       End;
                   42: Begin
                         PrecistZKnihovny(2);
                       End;
                   43: Begin
                         PrecistZKnihovny(3);
                       End;
                   44: Begin
                         PrecistZKnihovny(4);
                       End;
                   45: Begin
                         PrecistZKnihovny(5);
                       End;
                   46: Begin
                         PrecistZKnihovny(6);
                       End;
                   47: Begin
                         PrecistZKnihovny(7);
                       End;
                   48: Begin
                         PrecistZKnihovny(8);
                       End;
                   49: Begin
                         PrecistZKnihovny(9);
                       End;
                   50: Begin
                         PrecistZKnihovny(10);
                       End;
                   51: Begin
                         PrecistZKnihovny(11);
                       End;
                   52: Begin
                         PrecistZKnihovny(12);
                       End;
                   53: Begin
                         PrecistZKnihovny(13);
                       End;
                   54: Begin
                         PrecistZKnihovny(14);
                       End;
                   55: Begin
                         PrecistZKnihovny(15);
                       End;
                   56: Begin
                         PrecistZKnihovny(16);
                       End;
                   57: Begin
                         PrecistZKnihovny(17);
                       End;
                   58: Begin
                         PrecistZKnihovny(18);
                       End;
                   59: Begin
                         PrecistZKnihovny(19);
                       End;
                   60: Begin
                         SmazVsechnySoubory('KNIHOVNA\');      {erase all}
                         KnihovnaInfoOperate;
                         strankovaniloadu:=0;
                       End;
                   61: Begin
                         ExportujKnihovnu('KNIHOVNA\','USER'); {save user}
                         SmazVsechnySoubory('KNIHOVNA\');      {erase all}
                         KnihovnaInfoOperate;
                         strankovaniloadu:=0;
                       End;
                   62: Begin
                         strankovaniloadu:=0;
                         ImportujKnihovnu('KNIHOVNA\','USER'); {load user}
                         KnihovnaInfoOperate;
                       End;
                   63: Begin
                         ExportujKnihovnu('KNIHOVNA\','JIVA'); {save jiva}
                         SmazVsechnySoubory('KNIHOVNA\');      {erase all}
                         KnihovnaInfoOperate;
                         strankovaniloadu:=0;
                       End;
                   64: Begin
                         strankovaniloadu:=0;
                         ImportujKnihovnu('KNIHOVNA\','JIVA'); {load jiva}
                         KnihovnaInfoOperate;
                       End;
                  End; {Case End}
                End;
        16..35: Begin
                  WriterMemo(MainMenuSel);
                End;
           End; {Case End}
         End;

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           Case MainMenu of
            1: Begin           {Kniha}
                  MainMenu:=0;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            16: Begin           {Sesit 1}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            17: Begin           {Sesit 2}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            18: Begin           {Sesit 3}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            19: Begin           {Sesit 4}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            20: Begin           {Sesit 5}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            21: Begin           {Sesit 6}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            22: Begin           {Sesit 7}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            23: Begin           {Sesit 8}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            24: Begin           {Sesit 9}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            25: Begin           {Sesit 10}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            26: Begin           {Blok 1}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            27: Begin           {Blok 2}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            28: Begin           {Blok 3}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            29: Begin           {Blok 4}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            30: Begin           {Blok 5}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            31: Begin           {Kniha 1}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            32: Begin           {Kniha 2}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            33: Begin           {Kniha 3}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            34: Begin           {Kniha 4}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
            35: Begin           {Kniha 5}
                  MainMenu:=1;
                  MainMenuSel:=MainMenuSelSave3;
                  MainMenuMax:=9;
                End;
           End; {Case End}

           KonecKnihy:=True;
         End;

  Until KonecKnihy=True;
End;