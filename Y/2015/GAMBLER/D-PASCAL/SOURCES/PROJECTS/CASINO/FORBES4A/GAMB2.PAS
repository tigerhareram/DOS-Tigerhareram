Unit Gamb2;

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Interface
Uses DOS,Lite,Gamb1;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
{misc}
Procedure TestStopAutoStart;
Procedure TestBetDown;
Function  TestRollEnable: Boolean;
Procedure SetButtonColor(I: Byte);
Procedure ButtonBlink(I: Byte);


{mys}
Function J1: Byte;
Function K1: Byte;
Function L1: Byte;
Function EnterStiskly1: Byte;
Function AutostartStiskly1: Byte;
Function StartStiskly1: Byte;
Function WinGambleStiskly1: Byte;
Function VsaditStiskly1: Byte;
Function DoMultiwinuStiskly1: Byte;
Function CollectStiskly1: Byte;
Function HlavaStiskly1: Byte;
Function OrelStiskly1: Byte;
Function VybratCreditStiskly1: Byte;
Function VybratMultiwinStiskly1: Byte;
Function BazarStiskly1: Byte;
Function ZapsatStiskly1: Byte;
Function Vlozit50Stiskly1: Byte;
Function Vlozit500Stiskly1: Byte;


{waitbtn}
Procedure WaitButton(Klavesa: Byte);
Procedure WaitMouseButton1;
Procedure WaitMouseButton11;
Procedure WaitButton1;


{saveload}
Procedure ResetVyhernosti;
Procedure SaveLoadForbes(Save: Boolean);
Procedure SaveLoadPenize(Save: Boolean);


{loading}
Procedure SavePal1(Color:Byte);
Procedure Loading;


{default}
Procedure Default;


{histher}
Procedure HistorieHer;


{zisky}
Procedure Zisky(X,Y,I: Word);


{wrivalce}
Procedure WriteSymbolLight(x,y:Word; Symbol:Byte; Color:Byte; Light:Byte; Up,Down:Byte;BufferTo:Word);
Procedure KresliValce(SymbolLight,Svetlo1,Svetlo2,Svetlo3:Byte;BufferTo:Word);


{riskscr}
Procedure RiskScreen;


{update1}
Procedure UpdateGamble;


{update2}
Procedure UpdateDuchod;


{screen}
Procedure MainGameScreen;


{jackpot}
Procedure JackPotWin;


{score}
Procedure AddScore(Number: Word);
Procedure AddScoreCollect(Number: Word);

{setbet}
Procedure SetBet0;
Procedure SetBet;


{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Implementation

{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\misc.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\mys.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\waitbtn.pas}

{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\saveload.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\loading.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\default.pas}

{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\histher.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\zisky.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\wrivalce.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\riskscr.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\update1.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\update2.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\screen.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\jackpot.pas}

{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\score.pas}
{$I E:\SOURCES\PROJECTS\CASINO\FORBES4A\setbet.pas}

{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX}
Begin End.
