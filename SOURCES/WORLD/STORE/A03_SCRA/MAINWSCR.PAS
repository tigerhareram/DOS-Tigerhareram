Procedure MainWorldScreen;
Var I,Kn,N: Word;
    X,Y: Word;

Begin
  SVGA_ClearPage(ColX[0]);
  SVGA_WaitRetrace;
  SVGA_Rectangle(0,0,639,479,ColX[15]);
  SVGA_Rectangle(0,0,639,15,ColX[15]);
  Text_OutText(5,3,'Ovladani: Sipky,Enter,Esc, IJKL+ASQW',Buffer[0],SVGA);
  Text_OutText(420,3,'* W.O.R.L.D. *',Buffer[0],SVGA);
  Text_OutText(590,3,'Esc=Exit',Buffer[0],SVGA);

  If MainMenu=0 then
  Begin
    I:=0;  Text_OutText(20,30+15*I,'Program',Buffer[0],SVGA);
    I:=1;  Text_OutText(20,30+15*I,'Hit100A',Buffer[0],SVGA);
    I:=2;  Text_OutText(20,30+15*I,'Hit100B',Buffer[0],SVGA);
    I:=3;  Text_OutText(20,30+15*I,'Hit100C',Buffer[0],SVGA);
    I:=4;  Text_OutText(20,30+15*I,'Hit100D',Buffer[0],SVGA);
    I:=5;  Text_OutText(20,30+15*I,'Hit50',Buffer[0],SVGA);
    I:=6;  Text_OutText(20,30+15*I,'Hit25A',Buffer[0],SVGA);
    I:=7;  Text_OutText(20,30+15*I,'Hit25B',Buffer[0],SVGA);
    I:=8;  Text_OutText(20,30+15*I,'Hit15',Buffer[0],SVGA);
    I:=9;  Text_OutText(20,30+15*I,'Exit',Buffer[0],SVGA);
    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// MENU //',Buffer[0],SVGA);

    {World}
    SVGA_Rectangle(285,30,624,349,ColX[15]);
    For Y:=0 to 99 do
    For X:=0 to 159 do SVGA_BarZ(295+X*2,40+Y*3,295+1+X*2,40+2+Y*3,mem[Buffer[1]:Y*320+X]);
    {Rambo}
    SVGA_Rectangle(524,349,624,419,ColX[15]);
    SVGA_SprZ(534,359,0,100,79,149,1,Buffer[1]);
  End;

  If MainMenu=1 then
  Begin
    I:=0;  Text_OutText(20,30+15*I,'Dungeon',Buffer[0],SVGA);
    I:=1;  Text_OutText(20,30+15*I,'Kniha',Buffer[0],SVGA);
    I:=2;  Text_OutText(20,30+15*I,'Zvuky',Buffer[0],SVGA);
    I:=3;  Text_OutText(20,30+15*I,'..back',Buffer[0],SVGA);
    {Kur}  Text_OutText(20-15,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// PROGRAM //',Buffer[0],SVGA);

    {World}
    SVGA_Rectangle(285,30,624,349,ColX[15]);
    For Y:=0 to 99 do
    For X:=0 to 159 do SVGA_BarZ(295+X*2,40+Y*3,295+1+X*2,40+2+Y*3,mem[Buffer[1]:Y*320+X]);
    {Rambo}
    SVGA_Rectangle(524,349,624,419,ColX[15]);
    SVGA_SprZ(534,359,0,100,79,149,1,Buffer[1]);
  End;

  If MainMenu=15 then {Kniha}
  Begin
    I:=0; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 01   6 stran',Buffer[0],SVGA);
    I:=1; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 02   6 stran',Buffer[0],SVGA);
    I:=2; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 03   6 stran',Buffer[0],SVGA);
    I:=3; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 04   6 stran',Buffer[0],SVGA);
    I:=4; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 05   6 stran',Buffer[0],SVGA);
    I:=5; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 06   6 stran',Buffer[0],SVGA);
    I:=6; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 07   6 stran',Buffer[0],SVGA);
    I:=7; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 08   6 stran',Buffer[0],SVGA);
    I:=8; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 09   6 stran',Buffer[0],SVGA);
    I:=9; Text_OutText(20+120*0,30+15*(I-0), 'Sesit 10   6 stran',Buffer[0],SVGA);

    I:=10; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  01  60 stran',Buffer[0],SVGA);
    I:=11; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  02  60 stran',Buffer[0],SVGA);
    I:=12; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  03  60 stran',Buffer[0],SVGA);
    I:=13; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  04  60 stran',Buffer[0],SVGA);
    I:=14; Text_OutText(20+120*0,30+20+15*(I-0),'Blok  05  60 stran',Buffer[0],SVGA);

    I:=15; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 01 300 stran',Buffer[0],SVGA);
    I:=16; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 02 300 stran',Buffer[0],SVGA);
    I:=17; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 03 300 stran',Buffer[0],SVGA);
    I:=18; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 04 300 stran',Buffer[0],SVGA);
    I:=19; Text_OutText(20+120*0,30+40+15*(I-0),'Kniha 05 300 stran',Buffer[0],SVGA);

    Text_OutText(20+175*1,30+15*0,KnihovnaInfo.JmenaSesitu[0],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*1,KnihovnaInfo.JmenaSesitu[1],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*2,KnihovnaInfo.JmenaSesitu[2],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*3,KnihovnaInfo.JmenaSesitu[3],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*4,KnihovnaInfo.JmenaSesitu[4],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*5,KnihovnaInfo.JmenaSesitu[5],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*6,KnihovnaInfo.JmenaSesitu[6],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*7,KnihovnaInfo.JmenaSesitu[7],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*8,KnihovnaInfo.JmenaSesitu[8],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+15*9,KnihovnaInfo.JmenaSesitu[9],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*10,KnihovnaInfo.JmenaBloku[0],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*11,KnihovnaInfo.JmenaBloku[1],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*12,KnihovnaInfo.JmenaBloku[2],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*13,KnihovnaInfo.JmenaBloku[3],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+20+15*14,KnihovnaInfo.JmenaBloku[4],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*15,KnihovnaInfo.JmenaKnih[0],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*16,KnihovnaInfo.JmenaKnih[1],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*17,KnihovnaInfo.JmenaKnih[2],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*18,KnihovnaInfo.JmenaKnih[3],Buffer[0],SVGA);
    Text_OutText(20+175*1,30+40+15*19,KnihovnaInfo.JmenaKnih[4],Buffer[0],SVGA);

    I:=40; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=41; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=42; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=43; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=44; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=45; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=46; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=47; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=48; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=49; Text_OutText(570,30+15*(I-40),'Precist',Buffer[0],SVGA);

    I:=50; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=51; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=52; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=53; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=54; Text_OutText(570,30+20+15*(I-40),'Precist',Buffer[0],SVGA);

    I:=55; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=56; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=57; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=58; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);
    I:=59; Text_OutText(570,30+40+15*(I-40),'Precist',Buffer[0],SVGA);

    I:=60; Text_OutText(80,30+40+15*(I-40)+35,'ERASE ALL',Buffer[0],SVGA);
    I:=60; Text_OutText(180,30+40+15*(I-40)+35,'SAVE USER',Buffer[0],SVGA);
    I:=60; Text_OutText(280,30+40+15*(I-40)+35,'LOAD USER',Buffer[0],SVGA);
    I:=60; Text_OutText(380,30+40+15*(I-40)+35,'SAVE JIVA',Buffer[0],SVGA);
    I:=60; Text_OutText(480,30+40+15*(I-40)+35,'LOAD JIVA',Buffer[0],SVGA);

    {Kur}
    If  (MainMenuSel<10)                         then Text_OutText(20-15+120*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=10) and (MainMenuSel<15))  then Text_OutText(20-15+120*0,30+20+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=15) and (MainMenuSel<20))  then Text_OutText(20-15+120*0,30+40+15*MainmenuSel,'>>',Buffer[0],SVGA);

    If ((MainMenuSel>=20) and (MainMenuSel<30)) then Text_OutText(20-15+175*1,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=30) and (MainMenuSel<35)) then Text_OutText(20-15+175*1,30+20+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=35) and (MainMenuSel<40)) then Text_OutText(20-15+175*1,30+40+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);

    If   ((MainMenuSel>=40) and (MainMenuSel<50)) then Text_OutText(570-15,30+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);
    If   ((MainMenuSel>=50) and (MainMenuSel<55)) then Text_OutText(570-15,30+20+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);
    If   ((MainMenuSel>=55) and (MainMenuSel<60)) then Text_OutText(570-15,30+40+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);

    If   MainMenuSel>=60 then
    Case MainMenuSel of
      60: Text_OutText(80-15,30+40+15*(MainmenuSel-40)+35,'>>',Buffer[0],SVGA);
      61: Text_OutText(180-15,30+40+15*(MainmenuSel-41)+35,'>>',Buffer[0],SVGA);
      62: Text_OutText(280-15,30+40+15*(MainmenuSel-42)+35,'>>',Buffer[0],SVGA);
      63: Text_OutText(380-15,30+40+15*(MainmenuSel-43)+35,'>>',Buffer[0],SVGA);
      64: Text_OutText(480-15,30+40+15*(MainmenuSel-44)+35,'>>',Buffer[0],SVGA);
    End; {Case End}

    {Stitek} Text_OutText(20,455,'// LITERARNI DILO //',Buffer[0],SVGA);

    {Strankovani} Text_OutText(290,455,'HTML : ',Buffer[0],SVGA);
                  Text_OutNumber(332,456,strankovaniloadu,False,Buffer[0],SVGA);
  End;

  {Kniha - Sesity}
  If ((MainMenu>=16) and (MainMenu<=25)) then
  Begin
    For I:=0 to 5 do Text_OutNumber(20,30+15*I+1,I+1,False,Buffer[0],SVGA);

    {Kur} Text_OutText(20-13,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    {Stitek} Text_OutText(20,455,'// LITERARNI DILO //',Buffer[0],SVGA);
             Case MainMenu of
               16: Text_OutText(180,455,'Sesit 01',Buffer[0],SVGA);
               17: Text_OutText(180,455,'Sesit 02',Buffer[0],SVGA);
               18: Text_OutText(180,455,'Sesit 03',Buffer[0],SVGA);
               19: Text_OutText(180,455,'Sesit 04',Buffer[0],SVGA);
               20: Text_OutText(180,455,'Sesit 05',Buffer[0],SVGA);
               21: Text_OutText(180,455,'Sesit 06',Buffer[0],SVGA);
               22: Text_OutText(180,455,'Sesit 07',Buffer[0],SVGA);
               23: Text_OutText(180,455,'Sesit 08',Buffer[0],SVGA);
               24: Text_OutText(180,455,'Sesit 09',Buffer[0],SVGA);
               25: Text_OutText(180,455,'Sesit 10',Buffer[0],SVGA);
             End; {Case End}

  End;

  {Kniha - Bloky}
  If ((MainMenu>=26) and (MainMenu<=30)) then
  Begin
    For N:=0 to 2 do
    Begin
      For I:=0 to 19 do Text_OutNumber(20+40*N,30+15*I+1,I+1+N*20,False,Buffer[0],SVGA);
    End;

    {Kur}
    If  (MainMenuSel<20)                        then Text_OutText(20-13+40*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=20) and (MainMenuSel<40)) then Text_OutText(20-13+40*1,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If   MainMenuSel>=40                        then Text_OutText(20-13+40*2,30+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);

    {Stitek} Text_OutText(20,455,'// LITERARNI DILO //',Buffer[0],SVGA);
             Case MainMenu of
               26: Text_OutText(180,455,'Blok 1',Buffer[0],SVGA);
               27: Text_OutText(180,455,'Blok 2',Buffer[0],SVGA);
               28: Text_OutText(180,455,'Blok 3',Buffer[0],SVGA);
               29: Text_OutText(180,455,'Blok 4',Buffer[0],SVGA);
               30: Text_OutText(180,455,'Blok 5',Buffer[0],SVGA);
             End; {Case End}

  End;

  {Kniha - Knihy}
  If ((MainMenu>=31) and (MainMenu<=35)) then
  Begin
     For N:=0 to 14 do
     Begin
       For I:=0 to 19 do Text_OutNumber(20+40*N,30+15*I+1,I+1+N*20,False,Buffer[0],SVGA);
     End;

    {Kur}
    If  (MainMenuSel<20)
    then Text_OutText(20-13+40*0,30+15*MainmenuSel,'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=20) and (MainMenuSel<40))
    then Text_OutText(20-13+40*1,30+15*(MainmenuSel-20),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=40) and (MainMenuSel<60))
    then Text_OutText(20-13+40*2,30+15*(MainmenuSel-40),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=60) and (MainMenuSel<80))
    then Text_OutText(20-13+40*3,30+15*(MainmenuSel-60),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=80) and (MainMenuSel<100))
    then Text_OutText(20-13+40*4,30+15*(MainmenuSel-80),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=100) and (MainMenuSel<120))
    then Text_OutText(20-13+40*5,30+15*(MainmenuSel-100),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=120) and (MainMenuSel<140))
    then Text_OutText(20-13+40*6,30+15*(MainmenuSel-120),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=140) and (MainMenuSel<160))
    then Text_OutText(20-13+40*7,30+15*(MainmenuSel-140),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=160) and (MainMenuSel<180))
    then Text_OutText(20-13+40*8,30+15*(MainmenuSel-160),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=180) and (MainMenuSel<200))
    then Text_OutText(20-13+40*9,30+15*(MainmenuSel-180),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=200) and (MainMenuSel<220))
    then Text_OutText(20-13+40*10,30+15*(MainmenuSel-200),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=220) and (MainMenuSel<240))
    then Text_OutText(20-13+40*11,30+15*(MainmenuSel-220),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=240) and (MainMenuSel<260))
    then Text_OutText(20-13+40*12,30+15*(MainmenuSel-240),'>>',Buffer[0],SVGA);
    If ((MainMenuSel>=260) and (MainMenuSel<280))
    then Text_OutText(20-13+40*13,30+15*(MainmenuSel-260),'>>',Buffer[0],SVGA);
    If   MainMenuSel>=280
    then Text_OutText(20-13+40*14,30+15*(MainmenuSel-280),'>>',Buffer[0],SVGA);

    {Stitek} Text_OutText(20,455,'// LITERARNI DILO //',Buffer[0],SVGA);
             Case MainMenu of
               31: Text_OutText(180,455,'Kniha 1',Buffer[0],SVGA);
               32: Text_OutText(180,455,'Kniha 2',Buffer[0],SVGA);
               33: Text_OutText(180,455,'Kniha 3',Buffer[0],SVGA);
               34: Text_OutText(180,455,'Kniha 4',Buffer[0],SVGA);
               35: Text_OutText(180,455,'Kniha 5',Buffer[0],SVGA);
             End; {Case End}

  End;



  SVGA_WaitRetrace;
  SVGA_FlipPage;
End;
