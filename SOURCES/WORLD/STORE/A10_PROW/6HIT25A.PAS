Procedure Hit25A;
Var
    Ending: Boolean;
Begin
  Ending:=False;

  SVGA_TogglePaging;
  ShowBMP640('BITMAP\LSD\6hit25A\hit25a.bmp',0,0,0,0);

  Repeat
    If Key[1]=1 then
    Begin
      Kbd_RPush(1);
      Ending:=True;
    End;
  Until Ending=True;

  SVGA_TogglePaging;
End;