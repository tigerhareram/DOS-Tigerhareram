Procedure Main;
Var Konec: Boolean;
    klavesa: Byte;
    i: Byte;

Begin
  Konec:=False;

  Repeat
    MainScreen;

    i:=0;
    Repeat
    if i<25 then Begin
                   Inc(i);
                   Timer_Wait(20);
                   If KeyCode<128 then i:=25;
                 End;
    Until i>=25;

{Up}    If ((Key[23]=1) or (Key[72]=1)) then
         Begin
           If Key[23]=1 then Kbd_RPush(23);
           If Key[72]=1 then Kbd_RPush(72);
           If selection>1 then dec(selection);
         End;

{Down}    If ((Key[37]=1) or (Key[80]=1)) then
         Begin
           If Key[37]=1 then Kbd_RPush(37);
           If Key[80]=1 then Kbd_RPush(80);
           If selection<3 then inc(selection);
         End;

{Enter}  If ((Key[31]=1) or (Key[28]=1)) then
         Begin
           If Key[31]=1 then Kbd_RPush(31);
           If Key[28]=1 then Kbd_RPush(28);
           Case selection of
           1: Begin
                MainGame;
              End;
           2: Begin
                Setup;
              End;
           3: Begin
                Konec:=True;
              End;
           End; {Case End}
         End;

{Esc}    If ((Key[68]=1) or (Key[1]=1)) then
         Begin
           If Key[68]=1 then Kbd_RPush(68);
           If Key[1]=1 then Kbd_RPush(1);
           Konec:=True;                         {Esc MainMenu}
         End;
  Until Konec=True;


End;