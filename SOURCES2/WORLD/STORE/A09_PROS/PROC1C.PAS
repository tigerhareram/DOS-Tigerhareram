Function ClientProcess(DruhProcesu:Byte): Boolean;
Var i: Word;
    X,Y: Word;
Begin

 {-POSILAME-----------------------------------------------------------------}
    Case DruhProcesu of
      0: Begin
         End;
      1: Begin {login}
           IPXTransmit.Prvni:=0;                       {potvrzovaci bajt}
           IPXTransmit.SourceAddr:=fromNode;           {odkud posilame}
           IPXTransmit.Proces:=1;                      {druh procesu , 1 = login}
           For i:=0 to 5 do
           IPXTransmit.Data[i]:=fromNode[i];           {adresa klienta pro login}
           TestSend(IPXTransmit);                      {vyslani paketu}
         End;
      2: Begin
         End;
      3: Begin {send message}
           IPXTransmit.Prvni:=0;                       {potvrzovaci bajt}
           IPXTransmit.SourceAddr:=fromNode;           {odkud posilame}
           IPXTransmit.Proces:=3;                      {druh procesu , 3 = message update}
           For Y:=0 to 4 do
           For X:=0 to 79 do
           IPXTransmit.Data[Y*80+X]:=Ord(stranka2[Y,X]);
           TestSend(IPXTransmit);                      {vyslani paketu}
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
      9: Begin {ping proces 9}
           IPXTransmit.Prvni:=0;                       {potvrzovaci bajt}
           IPXTransmit.SourceAddr:=fromNode;           {odkud posilame}
           IPXTransmit.Proces:=9;                      {druh procesu , 9 = ping}
           IPXTransmit.Data[0]:=Random(256);           {nahodny bajt pingu}
           PingBajt1:=IPXTransmit.Data[0];             {zaloha stranou bajtu pro porovnani}
           TestSend(IPXTransmit);                      {vyslani paketu}
         End;
    End;

    {uklid promennych paketu}
    IPXTransmit.Prvni:=0;
    for i:=0 to 5 do IPXTransmit.SourceAddr[i]:=0;
    IPXTransmit.Proces:=0;
    for i:=0 to 399 do IPXTransmit.Data[i]:=0;

 {-PRIJIMAME----------------------------------------------------------------}

    {ocekavani odpovedi}
    recNode_Backup:=recNode;
    DoneSend;
    InitReceive;
    TestReceive(IPXTransmit);
    If IPXTransmit.Prvni=1       {1=potvrzeni ipx prijmu, 0=paket nedorazil}
    then Begin {mame odpoved}
           Case IPXTransmit.Proces of
             0: Begin End;
             1: Begin CisloKlienta:=IPXTransmit.Data[0]; End;
             2: Begin {logout je exit z programu , server jednoduse snizil pocet klientu} End;
             3: Begin {po odeslani message ocekavame proces 4} End;
             4: Begin
                  FillChar(Stranka2,5*80,' ');
                  i:=0;
                  For Y:=0 to 4 do
                  For X:=0 to 79 do
                  Begin
                    Stranka2[Y,X]:=Chr(IPXTransmit.Data[i]);
                    inc(i);
                  End;
                  WriteStrankaChat(85+80);
                  FillChar(Stranka2,5*80,' ');
                  WriteStrankaChat(85);
                End;
             5: Begin End;
             6: Begin End;
             7: Begin End;
             8: Begin End;
             9: Begin
                  PingBajt2:=IPXTransmit.Data[0];
                End;
           End; {Case End}
           ClientProcess:=True;
         End
    else Begin {nemame odpoved}
           ClientProcess:=False;
         End;

    DoneReceive;
    recNode:=recNode_Backup;
    InitSend;

    {status ready to send}
End;