Procedure Hit25B;
Var
    Ending: Boolean;
Begin
  Ending:=False;

  SVGA_TogglePaging;
  ShowBMP640('BITMAP\LSD\7hit25B\hit25b.bmp',0,0,0,0);

  Repeat
    If Key[1]=1 then
    Begin
      Kbd_RPush(1);
      Ending:=True;
    End;
  Until Ending=True;

  SVGA_TogglePaging;
End;