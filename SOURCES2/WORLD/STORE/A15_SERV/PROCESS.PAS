Procedure WriteFromAddr(x:nodeaddr); {odkud paket prisel}
Var i: Byte;
Begin
  for i:=0 to 5 do write(x[i],'.');
End;


Procedure Processing;
Var i: Word;
Begin

 {-POSILAME-----------------------------------------------------------------}

    {ping proces9}
    IPXTransmit.Prvni:=0;                       {potvrzovaci bajt}
    IPXTransmit.SourceAddr:=fromNode;           {odkud posilame}
    IPXTransmit.Proces:=9;                      {9 = druh procesu = ping}
    IPXTransmit.Data[0]:=Random(256);           {nahodny bajt pingu}
    SendBajt:=IPXTransmit.Data[0];              {zaloha stranou bajtu}
    TestSend(IPXTransmit);                      {vyslani paketu}
    Write('Paket odeslan.  ');

    {uklid promennych paketu}
    IPXTransmit.Prvni:=0;
    for i:=0 to 5 do IPXTransmit.SourceAddr[i]:=0;
    IPXTransmit.Proces:=0;
    for i:=0 to 399 do IPXTransmit.Data[i]:=0;

 {-PRIJIMAME----------------------------------------------------------------}

    {ocekavani odpovedi}
    Write('Cekam odpoved.  ');
    recNode_Backup:=recNode;
    DoneSend;
    InitReceive;
    TestReceive(IPXTransmit);
    If IPXTransmit.Prvni=1       {1=potvrzeni ipx prijmu, 0=paket nedorazil}
    then Begin {mame odpoved}
           WriteLn;
           Write('Ping z adresy:  '); WriteFromAddr(fromNode); Write('  ');
           If SendBajt=IPXTransmit.Data[0] then WriteLn('  TRUE  ',SendBajt,' = ',IPXTransmit.Data[0])
                                           else WriteLn('  FALSE  ',SendBajt,' | ',IPXTransmit.Data[0]);
           writeln('IPXData.Prvni=',IPXTransmit.Prvni);
           writeln('IPXData.SourceAddr='
                      ,IPXTransmit.SourceAddr[0],
                   '.',IPXTransmit.SourceAddr[1],
                   '.',IPXTransmit.SourceAddr[2],
                   '.',IPXTransmit.SourceAddr[3],
                   '.',IPXTransmit.SourceAddr[4],
                   '.',IPXTransmit.SourceAddr[5]);
           write('IPXData.Proces=',IPXTransmit.Proces);
           Case IPXTransmit.Proces of
             0: Begin End;
             1: Begin End;
             2: Begin End;
             3: Begin End;
             4: Begin End;
             5: Begin End;
             6: Begin End;
             7: Begin End;
             8: Begin End;
             9: Begin WriteLn(' Ping'); End;
           End; {Case End}
         End
    else Begin {nemame odpoved}
           WriteLn('Ping se nezdaril.');
         End;

    DoneReceive;
    recNode:=recNode_Backup;
    InitSend;

    {status ready to send}
End;