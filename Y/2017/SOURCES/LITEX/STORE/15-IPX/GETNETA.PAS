procedure GetInterNetAddr (var Net:netaddr;var Node:nodeaddr);
{ zji¨tˆn¡ vlastn¡ adresy }
var Regs:registers;
    Reply:procid;

begin
  Regs.ES:=Seg(Reply); Regs.SI:=Ofs(Reply);
  Regs.BX:=9;
  intr(IPXINT,regs);
  Net:=Reply.Net;
  Node:=Reply.Node;
end;
