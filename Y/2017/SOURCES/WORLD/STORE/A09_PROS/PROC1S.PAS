Procedure WriteFromAddr(x:nodeaddr); {odkud paket prisel}
Var i: Byte;
Begin
  for i:=0 to 5 do write(x[i],'.');
End;


Procedure ServerProcess;
Var i : Word;
Begin

  {-PRIJEM-----------------------------------------------------------}

  Write('PaketDorazil z adresy: ');
  WriteFromAddr(fromNode); WriteLn(' ');
  writeln('IPXData.Prvni=',IPXTransmit.Prvni);   {Kontrolni bajt Prvni=1}
  writeln('IPXData.SourceAddr='
             ,IPXTransmit.SourceAddr[0],
          '.',IPXTransmit.SourceAddr[1],
          '.',IPXTransmit.SourceAddr[2],         {IPX adresa odesilatele}
          '.',IPXTransmit.SourceAddr[3],
          '.',IPXTransmit.SourceAddr[4],
          '.',IPXTransmit.SourceAddr[5]);
  write('IPXData.Proces= ',IPXTransmit.Proces,' '); {Typ paketu ke zpracovani}
  Case IPXTransmit.Proces of
    0: Begin End;
    1: Begin WriteLn('login'); End;
    2: Begin End;
    3: Begin WriteLn('message'); End;
    4: Begin End;
    5: Begin End;
    6: Begin End;
    7: Begin End;
    8: Begin End;
    9: Begin WriteLn('ping'); End; {pouze odezva bez mereni casu}
  End; {Case End}

  {-ODPOVED----------------------------------------------------------}
  DoneReceive;
  recNode_Backup:=recNode;
  recNode:=fromNode;
  InitSend;

  Case IPXTransmit.Proces of
    0: Begin
       End;
    1: Begin {login na serveru}
         If PocetKlientu<2 then {pro max 3 lidi}
         Begin
           {zjistili jsme bajt IPXTransmit.Data[0-5]}
           For i:=0 to 5 do recNode_klient[CisloKlienta,i] :=IPXTransmit.Data[i];
           CisloKlienta:=0; {vzdy klient nula}
           Inc(PocetKlientu);

           IPXTransmit.Prvni:=0;                   {potvrzovaci bajt nastavi ipx}
           IPXTransmit.SourceAddr:=recNode_Backup; {odkud posilame z jake adresy}
           IPXTransmit.Proces:=1;                  {typ 9 = druh procesu = ping}
           IPXTransmit.Data[0]:=CisloKlienta;
           TestSend(IPXTransmit);                  {vyslani paketu odpovedi}
           WriteLn('odpoved OK');                  {v poradku odeslano}

           {uklid objektu promenne paketu, priprava na dalsi pakety a akce s nimi}
           IPXTransmit.Prvni:=0;
           For i:=0 to 5 do IPXTransmit.SourceAddr[i]:=0;
           IPXTransmit.Proces:=0;
           For i:=0 to 399 do IPXTransmit.Data[i]:=0;                   {uklizeno}
         End;
       End;
    2: Begin {log out na serveru}
         If PocetKlientu>0 then {pro max 3 lidi}
         Begin
           Dec(PocetKlientu);

           {uklid objektu promenne paketu, priprava na dalsi pakety a akce s nimi}
           IPXTransmit.Prvni:=0;
           For i:=0 to 5 do IPXTransmit.SourceAddr[i]:=0;
           IPXTransmit.Proces:=0;
           For i:=0 to 399 do IPXTransmit.Data[i]:=0;                   {uklizeno}
         End;
       End;
    3: Begin {prisel message na server od klienta}
         {odpovidame paketem}
         IPXTransmit.Prvni:=0;                   {potvrzovaci bajt nastavi ipx}
         IPXTransmit.SourceAddr:=recNode_Backup; {odkud posilame z jake adresy}
         IPXTransmit.Proces:=4;                  {typ 4 = server rozdava message}
         {zjistili jsme bajt IPXTransmit.Data[i], vypiseme ho na obrazovku}
         For i:=0 to 399 do
         Write(Chr(IPXTransmit.Data[i])); WriteLn(' '); {Vypis Data[i]}
         {rozeznavani retezcu proc}
         For i:=0 to PocetKlientu-1 do
         Begin
           recNode:=recNode_Klient[i];
           TestSend(IPXTransmit);                  {vyslani paketu odpovedi}
           WriteLn('odpoved OK');                  {v poradku odeslano}
         End;
         {uklid objektu promenne paketu, priprava na dalsi pakety a akce s nimi}
         IPXTransmit.Prvni:=0;
         For i:=0 to 5 do IPXTransmit.SourceAddr[i]:=0;
         IPXTransmit.Proces:=0;
         For i:=0 to 399 do IPXTransmit.Data[i]:=0;                   {uklizeno}
       End;
    4: Begin
       End;
    5: Begin
       End;
    6: Begin
       End;
    7: Begin
       End;
    8: Begin
       End;
    9: Begin                                     {volaci kod 9 = akce ping}
         {odpovidame paketem}
         IPXTransmit.Prvni:=0;                   {potvrzovaci bajt nastavi ipx}
         IPXTransmit.SourceAddr:=recNode_Backup; {odkud posilame z jake adresy}
         IPXTransmit.Proces:=9;                  {typ 9 = druh procesu = ping}
         {zjistili jsme bajt IPXTransmit.Data[0], vypiseme ho na obrazovku}
         Write('IPXData[0]=',IPXTransmit.Data[0]); WriteLn(' '); {Vypis Data[0]}
         {IPXTransmit.Data[0]}                   {bajt pingu odesilame totozny}
         TestSend(IPXTransmit);                  {vyslani paketu odpovedi}
         WriteLn('odpoved OK');                  {v poradku odeslano}
         {uklid objektu promenne paketu, priprava na dalsi pakety a akce s nimi}
         IPXTransmit.Prvni:=0;
         For i:=0 to 5 do IPXTransmit.SourceAddr[i]:=0;
         IPXTransmit.Proces:=0;
         For i:=0 to 399 do IPXTransmit.Data[i]:=0;                   {uklizeno}
       End;
  End; {Case End}

  DoneSend;
  InitReceive;

  {status ready to receive}
End;
