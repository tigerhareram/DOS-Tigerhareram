Procedure Setup;
Var
 Konec: Boolean;
 i: Byte;
Begin
  Konec:=False;

  Repeat
    SetupScreen;

    i:=0;
    Repeat
    if i<25 then Begin
                   Inc(i);
                   Timer_Wait(20);
                   If KeyCode<128 then i:=25;
                 End;
    Until i>=25;

{Esc}    If ((Key[68]=1) or (Key[1]=1)) then
         Begin
           If Key[68]=1 then Kbd_RPush(68);
           If Key[1]=1 then Kbd_RPush(1);
           Konec:=True;                         {Esc back to MainMenu}
         End;
  Until Konec=True;

End;