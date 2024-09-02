Procedure InitSend;
Begin
  { Otevri sockety pro vysilani dat a prijimani potvrzeni }

  oSocket := DATA_SOCKET;
  OpenSocket (AUTOCLOSE,oSocket,IPXresult,oSocket);
  if not (IPXresult in [0,SOCKET_ALREADY_OPEN]) then begin
          writeln('Chyba cislo ',IPXresult,' pri otvirani socketu');
          Exit;
                   end;

  GetInterNetAddr (net,fromNode);
End;
