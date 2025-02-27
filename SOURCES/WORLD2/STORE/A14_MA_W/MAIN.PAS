Procedure Main;
Var
  KonecProgramu: Boolean;

Begin
  KonecProgramu:=False;


  Repeat
    MainWorldScreen;
    Str80('KNIHOVNA\001.txt');
    Kbd_RKey;

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           KonecProgramu:=True;                      {Esc MainMenu}
         End;

  Until KonecProgramu=True;

End;