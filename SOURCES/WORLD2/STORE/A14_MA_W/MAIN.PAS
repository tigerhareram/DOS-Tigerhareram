Procedure Main;
Var
  KonecProgramu: Boolean;

Begin
  KonecProgramu:=False;


  Repeat

    MainWorldScreen;                            {1st write screen interface}
    Str80('KNIHOVNA\001.txt');                  {2nd write text file}
    Str80BMP('KNIHOVNA\001.bmp',150,250,0,0,79,49); {3rd write image}

    SVGA_WaitRetrace;
    SVGA_FlipPage;                              {4th show screen finished}

    Kbd_RKey;                                   {5th wait a key}

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           KonecProgramu:=True;                      {Esc MainMenu}
         End;

  Until KonecProgramu=True;

End;