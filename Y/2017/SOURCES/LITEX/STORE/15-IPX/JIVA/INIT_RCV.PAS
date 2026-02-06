Procedure InitReceive;
Var i: Byte;
Begin
  { Otevri socket pro prijem paketu }

  iSocket := DATA_SOCKET;
  OpenSocket (AUTOCLOSE,iSocket,IPXresult,iSocket);
  if not (IPXresult in [0,SOCKET_ALREADY_OPEN]) then begin
          writeln('Chyba cislo ',IPXresult,' pri otvirani socketu');
          halt;
                   end;

  GetInterNetAddr (net,recNode);
End;
