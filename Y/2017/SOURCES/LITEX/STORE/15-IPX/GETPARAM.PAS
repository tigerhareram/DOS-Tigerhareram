function IPXgetParams: boolean;
 { Rozdekoduje prikazovou radku programu a nastavi recnode a fname. }
 { Pokud se nepovede, ohlasi chybu a vrati FALSE; jinak vrati TRUE  }
 begin
   IPXgetParams:=TRUE;
   if paramCount<1 then begin
      writeln('jako parametr je nutne uvest adresu prijemce');
      writeln('(6 decimalnich hodnot oddelenych teckami)');
      writeln('priklad adresy IPX = 127.0.0.1.224.186');
      IPXgetParams:=FALSE; end;

   if not setRecNode(paramStr(1)) then
    begin writeln('Chybne zadana sitova adresa RECEIVE');
          IPXgetParams:=FALSE;
    end;
 end;
