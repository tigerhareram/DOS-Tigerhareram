Procedure Main;
Var
  KonecProgramu: Boolean;

Begin
  KonecProgramu:=False;
  StranaCis:=1;
  LoadingStranky(StranaCis);
  X1map:=0; {Map segment}
  Y1map:=0;
  X2map:=319;
  Y2map:=199;
  Rect1map:=ColX[15];
  Rect2map:=ColX[15];
  SVGA_ClearPage(ColX[0]);

  Repeat

      SkocNaStranku(StranaCis,0,0,0,0,159,199);   {+auto gra1234, map, ASCII}
      Kbd_RKey; {Wait KeyPressed}

{Up}     If Key[72]=1 then
         Begin
           If Key[72]=1 then Kbd_RPush(72);
           If StranaCis>5 then Dec(StranaCis,5);
           LoadingStranky(StranaCis);
           SVGA_ClearPage(ColX[0]);
         End;

{Down}   If Key[80]=1 then
         Begin
           If Key[80]=1 then Kbd_RPush(80);
           If StranaCis<=15 then Inc(StranaCis,5);
           LoadingStranky(StranaCis);
           SVGA_ClearPage(ColX[0]);
         End;

{Left}   If Key[75]=1 then
         Begin
           If Key[75]=1 then Kbd_RPush(75);
           If StranaCis>1 then Dec(StranaCis);
           LoadingStranky(StranaCis);
           SVGA_ClearPage(ColX[0]);
         End;

{Right}  If Key[77]=1 then
         Begin
           If Key[77]=1 then Kbd_RPush(77);
           If StranaCis<20 then Inc(StranaCis);
           LoadingStranky(StranaCis);
           SVGA_ClearPage(ColX[0]);
         End;

{Enter}  If Key[28]=1 then
         Begin
           If Key[28]=1 then Kbd_RPush(28);
           {Enter Page 160x200 switch Enter gra1234}
           If VisiblePage<4 then Inc(VisiblePage) else VisiblePage:=0;
           SVGA_ClearPage(ColX[0]);
         End;

{Insert} If Key[82]=1 then {Visibility BMP toggle}
         Begin
           If Key[82]=1 then Kbd_RPush(82);
           {show/hide BMP 160x200}
           If VisibleBMP<1 then Inc(VisibleBMP) else VisibleBMP:=0;
           SVGA_ClearPage(ColX[0]);
         End;

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           KonecProgramu:=True;                      {Esc MainMenu}
         End;

  Until KonecProgramu=True;

End;