procedure GetLocalTarget (Net:netaddr;Node:nodeaddr;Socket:socketnr;
                          var LocalTargetNode:nodeaddr;
			  var Completion:byte; var TransportTime:word);
{ Pro zadan‚ho adres ta zjisti nejv˜hodnˆj¨¡ho prost©edn¡ka, tedy
  dodej adresu routeru nebo samotn˜ c¡lov˜ uzel
  Net,Node,Socket  c¡lov  adresa
  Completion       £spˆ¨nost
  LocalTargetNode  vhodn˜ prost©edn¡k
  TransportTime    odhadnut  doba pro p©enos paketu
}

var
    Regs:registers;
    LTarget:nodeaddr absolute Reply;

begin
  Request.Net:=Net;
  Request.Node:=Node;
  Request.Socket:=Socket;
  Regs.ES:=Seg(Request); Regs.SI:=Ofs(Request);
  Regs.DI:=Ofs(Reply);
  Regs.BX:=2;
  intr(IPXINT,Regs);
  Completion:=Regs.AL;
  TransportTime:=Regs.CX;
  LocalTargetNode:=LTarget;
end;
