Procedure Main;
Var
  KonecProgramu: Boolean;

Begin
  KonecProgramu:=False;

  Repeat

      SkocNaStranku(StranaCis,0,0,0,0,159,199);   {+auto gra1234, map, ASCII}
      Kbd_RKey;                                   {wait a key.. and bmp scan}

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

{Enter}  If ((Key[28]=1) or (Key[30]=1)) then
         Begin
           If Key[28]=1 then Kbd_RPush(28);
           If Key[30]=1 then Kbd_RPush(30);
           {Enter Page 160x200 switch Enter}
           If VisiblePage<4 then Inc(VisiblePage) else VisiblePage:=0;
         End;

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           KonecProgramu:=True;                      {Esc MainMenu}
         End;

  Until KonecProgramu=True;

End;