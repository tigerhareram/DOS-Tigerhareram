Procedure Main;
Var
  KonecProgramu: Boolean;
  i: Byte;

Begin
  KonecProgramu:=False;

  LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);
  LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);

  Repeat
    MainWorldScreen;

    i:=0;
    Repeat
    if i<25 then Begin
                   Inc(i);
                   Timer_Wait(20);
                   If KeyCode<128 then i:=25;
                 End;
    Until i>=25;

{Up}     If ((Key[72]=1) or (Key[23]=1)) then
         Begin
           If Key[72]=1 then Kbd_RPush(72);
           If Key[23]=1 then Kbd_RPush(23);
           If MainMenuSel>0 then Dec(MainMenuSel);
         End;

{Down}   If ((Key[80]=1) or (Key[37]=1)) then
         Begin
           If Key[80]=1 then Kbd_RPush(80);
           If Key[37]=1 then Kbd_RPush(37);
           If MainMenuSel<MainMenuMax then Inc(MainMenuSel);
         End;

{Enter}  If ((Key[28]=1) or (Key[30]=1)) then
         Begin
           If Key[28]=1 then Kbd_RPush(28);
           If Key[30]=1 then Kbd_RPush(30);
           Case MainMenu of
  {MainMenu} 0: Begin
                  Case MainMenuSel of
                    0: Begin
                         MainMenu:=1;                   {HIT100A}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                         Hit100A;
                         MainMenu:=0;
                         MainMenuSel:=MainMenuSelSave;
                         MainMenuMax:=8;
                         P16_SetPal(ColX[0],0,0,0);   {Black}
                         P16_SetPal(ColX[15],5,35,8); {Dark Green}
                         LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                    1: Begin
                         MainMenu:=1;                   {HIT100B}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                         Hit100B;
                         MainMenu:=0;
                         MainMenuSel:=MainMenuSelSave;
                         MainMenuMax:=8;
                         P16_SetPal(ColX[0],0,0,0);   {Black}
                         P16_SetPal(ColX[15],5,35,8); {Dark Green}
                         LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                    2: Begin
                         MainMenu:=1;                   {HIT100C}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                         Hit100C;
                         MainMenu:=0;
                         MainMenuSel:=MainMenuSelSave;
                         MainMenuMax:=8;
                         P16_SetPal(ColX[0],0,0,0);   {Black}
                         P16_SetPal(ColX[15],5,35,8); {Dark Green}
                         LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                    3: Begin
                         MainMenu:=1;                   {HIT100D}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                         Hit100D;
                         MainMenu:=0;
                         MainMenuSel:=MainMenuSelSave;
                         MainMenuMax:=8;
                         P16_SetPal(ColX[0],0,0,0);   {Black}
                         P16_SetPal(ColX[15],5,35,8); {Dark Green}
                         LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                    4: Begin
                         MainMenu:=1;                   {HIT50}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                         Hit50;
                         MainMenu:=0;
                         MainMenuSel:=MainMenuSelSave;
                         MainMenuMax:=8;
                         P16_SetPal(ColX[0],0,0,0);   {Black}
                         P16_SetPal(ColX[15],5,35,8); {Dark Green}
                         LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                    5: Begin
                         MainMenu:=1;                   {HIT25A}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                         Hit25A;
                         MainMenu:=0;
                         MainMenuSel:=MainMenuSelSave;
                         MainMenuMax:=8;
                         P16_SetPal(ColX[0],0,0,0);   {Black}
                         P16_SetPal(ColX[15],5,35,8); {Dark Green}
                         LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                    6: Begin
                         MainMenu:=1;                   {HIT25B}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                         Hit25B;
                         MainMenu:=0;
                         MainMenuSel:=MainMenuSelSave;
                         MainMenuMax:=8;
                         P16_SetPal(ColX[0],0,0,0);   {Black}
                         P16_SetPal(ColX[15],5,35,8); {Dark Green}
                         LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                    7: Begin
                         MainMenu:=1;                   {ALL15Min}
                         MainMenuSelSave:=MainMenuSel;
                         MainMenuSel:=0;
                         MainMenuMax:=0;
                         ALL15Min;
                         MainMenu:=0;
                         MainMenuSel:=MainMenuSelSave;
                         MainMenuMax:=8;
                         P16_SetPal(ColX[0],0,0,0);   {Black}
                         P16_SetPal(ColX[15],5,35,8); {Dark Green}
                         LoadBMPFile('BITMAP\globe.bmp',0,0,0,176,Buffer[1]);
                         LoadBMPFile('BITMAP\rambo16.bmp',0,0,100,188,Buffer[1]);
                       End;
                    8: Begin
                         KonecProgramu:=True;           {Exit}
                       End;
                  End; {Case End}
                End;
  {Prog}     1: Begin
                End;
           End; {Case End}
         End;

{Esc}    If ((Key[1]=1) or (Key[31]=1)) then
         Begin
           If Key[1]=1 then Kbd_RPush(1);
           If Key[31]=1 then Kbd_RPush(31);
           Case MainMenu of
             0: Begin
                  KonecProgramu:=True;                      {Esc MainMenu}
                End;
           End; {Case End}
         End;

  Until KonecProgramu=True;

  Spkr_Silence;
End;