Procedure Main;
Var
  KonecProgramu: Boolean;

Begin
  KonecProgramu:=False;

  StranaCis:=001;
  StranaMin:=001;
  StranaMax:=001;

  Repeat

      SkocNaStranku(StranaCis,150,250,0,0,79,49);
      Kbd_RKey;                                      {wait a key}

{Left}   If ((Key[75]=1) or (Key[36]=1)) then
         Begin
           If Key[75]=1 then Kbd_RPush(75);
           If Key[36]=1 then Kbd_RPush(36);
           If StranaCis>StranaMin then Dec(StranaCis);
         End;

{Right}  If ((Key[77]=1) or (Key[38]=1)) then
         Begin
           If Key[77]=1 then Kbd_RPush(77);
           If Key[38]=1 then Kbd_RPush(38);
           If StranaCis<StranaMax then Inc(StranaCis);
         End;

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           KonecProgramu:=True;                      {Esc MainMenu}
         End;

  Until KonecProgramu=True;

End;