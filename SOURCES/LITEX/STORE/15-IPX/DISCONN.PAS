procedure DisconnectTarget (Net:netaddr;Node:nodeaddr;Socket:socketnr);
{ Informace o nejv˜hodnˆj¨¡m prost©edn¡ku ji‘ nepot©ebuji }
var
  Request:procid;
  Regs:registers;
begin
  Regs.ES:=Seg(Request); Regs.SI:=Ofs(Request);
  Request.Net:=Net;
  Request.Node:=Node;
  Request.Socket:=Socket;
  Regs.Bx := 11;
  intr(IPXInt,Regs);
end;
