Procedure MainGame;
Var
  Konec: Boolean;

Begin
  Konec:=False;

  fps:=0;
  frame_counter:=0;

  Repeat
    Screen;
    If Timer_Second=True then
    Begin
      Inc(frame_counter);
    End else
    Begin
      If frame_counter>0 then fps:=frame_counter;
      frame_counter:=0;
    End;

{Esc}    If ((Key[68]=1) or (Key[1]=1)) then
         Begin
           If Key[68]=1 then Kbd_RPush(68);
           If Key[1]=1 then Kbd_RPush(1);
           Konec:=True;                         {Esc MainMenu}
         End;
  Until Konec=True;
End;